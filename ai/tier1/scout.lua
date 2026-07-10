-- Scout Drone AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local ScoutAI = setmetatable({}, { __index = BaseAI })

function ScoutAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown = 0
    self.dashCooldown = 0
    self.reportCooldown = 0

    self.safeRange   = 600
    self.dashRange   = 400
end

function ScoutAI:GetPriority(target)
    local dist = DistanceTo(self.id, target)
    return (1 - dist / 1500) * 5
end

function ScoutAI:FindTarget()
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

function ScoutAI:Dash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist > self.dashRange then
        Dash(self.id, 200)
        self.dashCooldown = 2.0
    end
end

function ScoutAI:KeepSafeDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist < self.safeRange then
        MoveAwayFrom(self.id, self.target)
    end
end

function ScoutAI:Report()
    if self.reportCooldown > 0 then return end
    if not self.target then return end

    MarkTargetForAllies(self.id, self.target)
    self.reportCooldown = 3.0
end

function ScoutAI:Update(dt)
    self.scanCooldown   = math.max(0, self.scanCooldown - dt)
    self.dashCooldown   = math.max(0, self.dashCooldown - dt)
    self.reportCooldown = math.max(0, self.reportCooldown - dt)

    self:FindTarget()
    self:Dash()
    self:KeepSafeDistance()
    self:Report()
end

return ScoutAI
