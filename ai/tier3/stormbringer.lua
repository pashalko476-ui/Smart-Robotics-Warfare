-- Stormbringer AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local StormAI = setmetatable({}, { __index = BaseAI })

function StormAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown       = 0
    self.evadeCooldown      = 0
    self.fireCooldown       = 0
    self.repositionCooldown = 0

    self.minRange           = 300
    self.maxRange           = 800
    self.chainRange         = 250
    self.repositionTime     = 1.2
    self.groupPriorityBonus = 3
end

function StormAI:IsLowHP()
    local hp  = GetRobotHealth(self.id)
    local max = GetRobotMaxHealth(self.id)
    return hp / max
end

function StormAI:Evade()
    if self.evadeCooldown > 0 then return end

    if self:IsLowHP() <= 0.30 then
        HeavyRetreat(self.id)
        self.evadeCooldown = 1.5
    end
end

function StormAI:GetPriority(target)
    local dist   = DistanceTo(self.id, target)
    local hp     = GetRobotHealth(target)
    local maxHp  = GetRobotMaxHealth(target)

    local hpFactor   = (1 - hp / maxHp) * 4
    local distFactor = (1 - dist / 1200) * 2
    local nearby     = CountEnemiesInRadius(target, self.chainRange)
    local groupFactor = nearby * self.groupPriorityBonus

    return hpFactor + distFactor + groupFactor
end

function StormAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.5

    local enemies = GetVisibleEnemies(self.id)
    if #enemies == 0 then self.target = nil return end

    local best, bestScore = nil, -1
    for _, enemy in ipairs(enemies) do
        local score = self:GetPriority(enemy)
        if score > bestScore then best = enemy bestScore = score end
    end

    self.target = best
end

function StormAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then MoveRobotTowards(self.id, self.target)
    end
end

function StormAI:Attack()
    if self.fireCooldown > 0 then return end
    if not self.target then return end

    FireChainLightning(self.id, self.target, self.chainRange)

    self.fireCooldown       = GetWeaponReloadTime(self.id)
    self.repositionCooldown = self.repositionTime
end

function StormAI:Reposition()
    if self.repositionCooldown <= 0 then return end
    MoveToCover(self.id)
end

function StormAI:Update(dt)
    self.scanCooldown       = math.max(0, self.scanCooldown - dt)
    self.evadeCooldown      = math.max(0, self.evadeCooldown - dt)
    self.fireCooldown       = math.max(0, self.fireCooldown - dt)
    self.repositionCooldown = math.max(0, self.repositionCooldown - dt)

    self:Evade()
    self:FindTarget()
    self:Reposition()
    self:KeepDistance()
    self:Attack()
end

return StormAI
