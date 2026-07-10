-- Titanus Devastator AI
-- Smart Robotics Warfare Mod

local BaseAI = require(path .. "/ai/ai_base.lua")

local TitanusAI = setmetatable({}, { __index = BaseAI })

function TitanusAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown       = 0
    self.primaryCooldown    = 0
    self.secondaryCooldown  = 0
    self.abilityCooldown    = 0
    self.evadeCooldown      = 0

    self.minRange           = 500
    self.maxRange           = 1300

    self.rageThreshold      = 0.40
    self.retreatThreshold   = 0.30

    self.isRaging           = false
end

function TitanusAI:IsLowHP()
    local hp  = GetRobotHealth(self.id)
    local max = GetRobotMaxHealth(self.id)
    return hp / max
end

function TitanusAI:UpdateRageState()
    local ratio = self:IsLowHP()
    self.isRaging = (ratio <= self.rageThreshold)
end

function TitanusAI:GetPriority(target)
    local type = GetTargetType(target)
    local dist = DistanceTo(self.id, target)

    local base = 1

    if type == "titan" then
        base = 10
    elseif type == "robot" then
        if IsHeavyRobot(target) then
            base = 7
        else
            base = 4
        end
    elseif type == "device" then
        base = 6
    end

    local distFactor = (1 - dist / 2000) * 2

    return base + distFactor
end

function TitanusAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.7

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

function TitanusAI:Evade()
    if self.evadeCooldown > 0 then return end

    local ratio = self:IsLowHP()
    if ratio <= self.retreatThreshold then
        HeavyRetreat(self.id)
        self.evadeCooldown = 3.0
    end
end

function TitanusAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    end
end

function TitanusAI:PrimaryAttack()
    if not self.target then return end
    if self.primaryCooldown > 0 then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.maxRange then return end

    FireDevastatorCannon(self.id, self.target)

    self.primaryCooldown = GetWeaponReloadTime(self.id)
end

function TitanusAI:SecondaryAttack()
    if not self.target then return end
    if self.secondaryCooldown > 0 then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.maxRange then return end

    FireDevastatorBeam(self.id, self.target)

    self.secondaryCooldown = GetSecondaryReloadTime(self.id)
end

function TitanusAI:UseAbility()
    if self.abilityCooldown > 0 then return end
    if not self.isRaging then return end

    ActivateDevastatorOverdrive(self.id)

    self.abilityCooldown = 15.0
end

function TitanusAI:Update(dt)
    self.scanCooldown      = math.max(0, self.scanCooldown - dt)
    self.primaryCooldown   = math.max(0, self.primaryCooldown - dt)
    self.secondaryCooldown = math.max(0, self.secondaryCooldown - dt)
    self.abilityCooldown   = math.max(0, self.abilityCooldown - dt)
    self.evadeCooldown     = math.max(0, self.evadeCooldown - dt)

    self:UpdateRageState()
    self:FindTarget()
    self:Evade()
    self:KeepDistance()
    self:UseAbility()
    self:PrimaryAttack()
    self:SecondaryAttack()
end

return TitanusAI
