-- Predator Walker AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local PredatorAI = setmetatable({}, { __index = BaseAI })

function PredatorAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown       = 0
    self.evadeCooldown      = 0
    self.fireCooldown       = 0
    self.repositionCooldown = 0

    self.minRange           = 500
    self.maxRange           = 1400
    self.repositionTime     = 2.0
end

function PredatorAI:IsLowHP()
    local hp  = GetRobotHealth(self.id)
    local max = GetRobotMaxHealth(self.id)
    return hp / max
end

function PredatorAI:Evade()
    if self.evadeCooldown > 0 then return end

    local ratio = self:IsLowHP()
    if ratio <= 0.30 then
        HeavyRetreat(self.id)
        self.evadeCooldown = 2.5
    end
end

function PredatorAI:GetPriority(target)
    local type = GetTargetType(target)
    local dist = DistanceTo(self.id, target)

    local base = 1

    if type == "titanus_devastator" then
        base = 10
    elseif type == "aegis_titan" then
        base = 9
    elseif type == "artillery_walker" then
        base = 8
    elseif type == "shield_breaker" or type == "stormbringer" then
        base = 7
    elseif type == "gunner_unit" then
        base = 5
    elseif type == "device" then
        base = 4
    end

    local distFactor = (1 - dist / 2000) * 2

    return base + distFactor
end

function PredatorAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.8

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

function PredatorAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    end
end

function PredatorAI:Attack()
    if not self.target then return end
    if self.fireCooldown > 0 then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.maxRange then return end

    FireSniperShot(self.id, self.target)

    self.fireCooldown       = GetWeaponReloadTime(self.id)
    self.repositionCooldown = self.repositionTime
end

function PredatorAI:Reposition()
    if self.repositionCooldown <= 0 then return end
    MoveToCover(self.id)
end

function PredatorAI:Update(dt)
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

return PredatorAI
