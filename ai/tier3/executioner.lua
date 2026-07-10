-- Executioner Unit AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local ExecutionerAI = setmetatable({}, { __index = BaseAI })

function ExecutionerAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown       = 0
    self.evadeCooldown      = 0
    self.attackCooldown     = 0
    self.dashCooldown       = 0
    self.repositionCooldown = 0

    self.minRange           = 80
    self.maxRange           = 250
    self.dashRange          = 300
    self.repositionTime     = 1.2
end

function ExecutionerAI:IsLowHP()
    local hp  = GetRobotHealth(self.id)
    local max = GetRobotMaxHealth(self.id)
    return hp / max
end

function ExecutionerAI:Evade()
    if self.evadeCooldown > 0 then return end

    local ratio = self:IsLowHP()
    if ratio <= 0.30 then
        HeavyRetreat(self.id)
        self.evadeCooldown = 2.0
    end
end

function ExecutionerAI:GetPriority(target)
    local type = GetTargetType(target)
    local hp   = GetRobotHealth(target)
    local max  = GetRobotMaxHealth(target)

    local base = 0

    if type == "robot" then
        if IsHeavyRobot(target) then
            base = 6
        else
            base = 3
        end
    end

    local hpFactor = (1 - hp / max) * 5

    return base + hpFactor
end

function ExecutionerAI:FindTarget()
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

function ExecutionerAI:Dash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.maxRange and dist < self.dashRange then
        Dash(self.id, 200)
        self.dashCooldown = 3.0
    end
end

function ExecutionerAI:Chase()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    elseif dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    end
end

function ExecutionerAI:Attack()
    if not self.target then return end
    if self.attackCooldown > 0 then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.minRange then return end

    FireExecutionerStrike(self.id, self.target)

    self.attackCooldown     = GetWeaponReloadTime(self.id)
    self.repositionCooldown = self.repositionTime
end

function ExecutionerAI:Reposition()
    if self.repositionCooldown <= 0 then return end
    MoveToCover(self.id)
end

function ExecutionerAI:Update(dt)
    self.scanCooldown       = math.max(0, self.scanCooldown - dt)
    self.evadeCooldown      = math.max(0, self.evadeCooldown - dt)
    self.attackCooldown     = math.max(0, self.attackCooldown - dt)
    self.dashCooldown       = math.max(0, self.dashCooldown - dt)
    self.repositionCooldown = math.max(0, self.repositionCooldown - dt)

    self:Evade()
    self:FindTarget()
    self:Dash()
    self:Reposition()
    self:Chase()
    self:Attack()
end

return ExecutionerAI
