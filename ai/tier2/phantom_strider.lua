-- Phantom Strider AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local PhantomAI = setmetatable({}, { __index = BaseAI })

function PhantomAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown   = 0
    self.cloakCooldown  = 0
    self.fireCooldown   = 0
    self.dashCooldown   = 0

    self.minRange       = 120
    self.maxRange       = 350
    self.cloakDuration  = 3.5
    self.cloakRecharge  = 6.0
end

function PhantomAI:GetPriority(target)
    local hp  = GetRobotHealth(target)
    local max = GetRobotMaxHealth(target)
    return (1 - hp / max) * 5
end

function PhantomAI:FindTarget()
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

function PhantomAI:Cloak()
    if self.cloakCooldown > 0 then return end

    ActivateCloak(self.id, self.cloakDuration)
    self.cloakCooldown = self.cloakRecharge
end

function PhantomAI:Dash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    Dash(self.id, 200)
    self.dashCooldown = 2.0
end

function PhantomAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    end
end

function PhantomAI:Attack()
    if self.fireCooldown > 0 then return end
    if not self.target then return end

    FireAmbushStrike(self.id, self.target)
    self.fireCooldown = GetWeaponReloadTime(self.id)
end

function PhantomAI:Update(dt)
    self.scanCooldown  = math.max(0, self.scanCooldown - dt)
    self.cloakCooldown = math.max(0, self.cloakCooldown - dt)
    self.fireCooldown  = math.max(0, self.fireCooldown - dt)
    self.dashCooldown  = math.max(0, self.dashCooldown - dt)

    self:FindTarget()
    self:Cloak()
    self:Dash()
    self:KeepDistance()
    self:Attack()
end

return PhantomAI
