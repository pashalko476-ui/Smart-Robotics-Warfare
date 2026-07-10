-- Gunner Unit AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local GunnerAI = setmetatable({}, { __index = BaseAI })

function GunnerAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown = 0
    self.fireCooldown = 0
    self.dashCooldown = 0

    self.minRange = 200
    self.maxRange = 600
end

function GunnerAI:GetPriority(target)
    local hp  = GetRobotHealth(target)
    local max = GetRobotMaxHealth(target)
    return (1 - hp / max) * 5
end

function GunnerAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.3

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

function GunnerAI:MiniDash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    if IsUnderFire(self.id) then
        MiniDash(self.id)
        self.dashCooldown = 2.0
    end
end

function GunnerAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    end
end

function GunnerAI:Attack()
    if self.fireCooldown > 0 then return end
    if not self.target then return end

    FireGunnerShot(self.id, self.target)
    self.fireCooldown = GetWeaponReloadTime(self.id)
end

function GunnerAI:Update(dt)
    self.scanCooldown = math.max(0, self.scanCooldown - dt)
    self.fireCooldown = math.max(0, self.fireCooldown - dt)
    self.dashCooldown = math.max(0, self.dashCooldown - dt)

    self:FindTarget()
    self:MiniDash()
    self:KeepDistance()
    self:Attack()
end

return GunnerAI
