-- Hunter Striker AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local StrikerAI = setmetatable({}, { __index = BaseAI })

function StrikerAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown = 0
    self.dashCooldown = 0
    self.attackCooldown = 0

    self.minRange   = 80
    self.maxRange   = 260
    self.dashRange  = 400
end

function StrikerAI:GetPriority(target)
    local hp  = GetRobotHealth(target)
    local max = GetRobotMaxHealth(target)

    local hpFactor = (1 - hp / max) * 5
    return hpFactor
end

function StrikerAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.25

    local enemies = GetVisibleEnemies(self.id)
    if #enemies == 0 then
        self.target = nil
        return
    end

    local best, bestScore = nil, -1
    for _, enemy in ipairs(enemies) do
        local score = self:GetPriority(enemy)
        if score > bestScore then
            best = enemy
            bestScore = score
        end
    end

    self.target = best
end

function StrikerAI:Dash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.maxRange and dist < self.dashRange then
        Dash(self.id, 220)
        self.dashCooldown = 2.0
    end
end

function StrikerAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    elseif dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    end
end

function StrikerAI:Attack()
    if self.attackCooldown > 0 then return end
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.maxRange then return end

    FireStrikerShot(self.id, self.target)
    self.attackCooldown = GetWeaponReloadTime(self.id)
end

function StrikerAI:Update(dt)
    self.scanCooldown   = math.max(0, self.scanCooldown - dt)
    self.dashCooldown   = math.max(0, self.dashCooldown - dt)
    self.attackCooldown = math.max(0, self.attackCooldown - dt)

    self:FindTarget()
    self:Dash()
    self:KeepDistance()
    self:Attack()
end

return StrikerAI
