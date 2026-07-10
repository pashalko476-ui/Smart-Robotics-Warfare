-- Aegis Titan AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local AegisAI = setmetatable({}, { __index = BaseAI })

function AegisAI:Init(id)
    BaseAI.Init(self, id)

    self.evadeCooldown  = 0
    self.scanCooldown   = 0
    self.shieldCooldown = 0
end

function AegisAI:IsLowHP()
    local hp  = GetRobotHealth(self.id)
    local max = GetRobotMaxHealth(self.id)
    return hp / max
end

function AegisAI:Evade()
    if self.evadeCooldown > 0 then return end

    if self:IsLowHP() <= 0.30 then
        HeavyRetreat(self.id)
        self.evadeCooldown = 2.0
    end
end

function AegisAI:GetPriority(target)
    local type = GetTargetType(target)
    local base = 1

    if type == "robot" then
        if IsHeavyRobot(target) then base = 7 else base = 4 end
    elseif type == "device" then
        base = 5
    end

    return base
end

function AegisAI:FindTarget()
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

function AegisAI:ActivateShield()
    if self.shieldCooldown > 0 then return end
    ActivateAegisShield(self.id)
    self.shieldCooldown = 8.0
end

function AegisAI:Advance()
    if not self.target then return end
    MoveRobotTowards(self.id, self.target)
end

function AegisAI:Attack()
    if not self.target then return end
    FireAegisShot(self.id, self.target)
end

function AegisAI:Update(dt)
    self.evadeCooldown  = math.max(0, self.evadeCooldown - dt)
    self.scanCooldown   = math.max(0, self.scanCooldown - dt)
    self.shieldCooldown = math.max(0, self.shieldCooldown - dt)

    self:Evade()
    self:FindTarget()
    self:ActivateShield()
    self:Advance()
    self:Attack()
end

return AegisAI
