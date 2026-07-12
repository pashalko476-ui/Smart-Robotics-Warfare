-- Kamikaze Drone AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local KamiAI = setmetatable({}, { __index = BaseAI })
robot.missiles = {}

function KamiAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown = 0
    self.dashCooldown = 0
    self.explodeRange = 120
    self.dashRange    = 500
end

function KamiAI:GetPriority(target)
    local type = GetTargetType(target)
    local base = 1

    if type == "device" then
        base = 6
    elseif type == "robot" then
        if IsHeavyRobot(target) then
            base = 5
        else
            base = 3
        end
    end

    return base
end

function KamiAI:FindTarget()
    if self.scanCooldown > 0 then return end
    self.scanCooldown = 0.2

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

function KamiAI:Dash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.explodeRange and dist < self.dashRange then
        Dash(self.id, 250)
        self.dashCooldown = 1.5
    end
end

function KamiAI:MoveToTarget()
    if not self.target then return end

    MoveRobotTowards(self.id, self.target)
end

function KamiAI:Explode()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist <= self.explodeRange then
        TriggerKamikazeExplosion(self.id)
    end
end

function KamiAI:Update(dt)
    self.scanCooldown = math.max(0, self.scanCooldown - dt)
    self.dashCooldown = math.max(0, self.dashCooldown - dt)

    self:FindTarget()
    self:Dash()
    self:MoveToTarget()
    self:Explode()
end

return KamiAI
