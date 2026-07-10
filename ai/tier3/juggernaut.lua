-- Juggernaut Siege Unit AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local JuggernautAI = setmetatable({}, { __index = BaseAI })

function JuggernautAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown       = 0
    self.evadeCooldown      = 0
    self.fireCooldown       = 0
    self.repositionCooldown = 0

    self.minRange           = 350
    self.maxRange           = 900
    self.repositionTime     = 2.0
end

function JuggernautAI:IsLowHP()
    local hp  = GetRobotHealth(self.id)
    local max = GetRobotMaxHealth(self.id)
    return hp / max
end

function JuggernautAI:Evade()
    if self.evadeCooldown > 0 then return end

    if self:IsLowHP() <= 0.30 then
        HeavyRetreat(self.id)
        self.evadeCooldown = 3.0
    end
end

function JuggernautAI:GetPriority(target)
    local type = GetTargetType(target)
    local dist = DistanceTo(self.id, target)

    local base = 0

    if type == "device" then base = 6
    elseif type == "robot" then
        if IsHeavyRobot(target) then base = 5 else base = 2 end
    end

    if IsShieldDevice(target) then base = 7 end

    local distFactor = (1 - dist / 1500) * 2

    return base + distFactor
end

function JuggernautAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.7

    local enemies = GetVisibleEnemies(self.id)
    if #enemies == 0 then self.target = nil return end

    local best, bestScore = nil, -1
    for _, enemy in ipairs(enemies) do
        local score = self:GetPriority(enemy)
        if score > bestScore then best = enemy bestScore = score end
    end

    self.target = best
end

function JuggernautAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then MoveRobotTowards(self.id, self.target)
    end
end

function JuggernautAI:Attack()
    if self.fireCooldown > 0 then return end
    if not self.target then return end

    FireSiegeCannon(self.id, self.target)

    self.fireCooldown       = GetWeaponReloadTime(self.id)
    self.repositionCooldown = self.repositionTime
end

function JuggernautAI:Reposition()
    if self.repositionCooldown <= 0 then return end
    MoveToCover(self.id)
end

function JuggernautAI:Update(dt)
    self.scanCooldown       = math.max(0, self.scanCooldown - dt)
    self.evadeCooldown      = math.max(0, self.evadeCooldown - dt)
    self.fireCooldown       = math.max(0, self.fireCooldown - dt)
    self.repositionCooldown = math.max(0, self.repositionCooldown - dt)

    self:Evade()
    self:FindTarget()
    self:Reposition()
    self:KeepDistance()
    self: