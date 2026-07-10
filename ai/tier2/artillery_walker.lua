-- Artillery Walker AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local ArtAI = setmetatable({}, { __index = BaseAI })

function ArtAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown = 0
    self.fireCooldown = 0

    self.minRange = 600
    self.maxRange = 1600
end

function ArtAI:GetPriority(target)
    local type = GetTargetType(target)
    local base = 1

    if type == "device" then
        base = 8
    elseif type == "robot" then
        if IsHeavyRobot(target) then
            base = 6
        else
            base = 3
        end
    end

    return base
end

function ArtAI:FindTarget()
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

function ArtAI:KeepDistance()
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)

    if dist < self.minRange then
        MoveAwayFrom(self.id, self.target)
    elseif dist > self.maxRange then
        MoveRobotTowards(self.id, self.target)
    end
end

function ArtAI:Attack()
    if self.fireCooldown > 0 then return end
    if not self.target then return end

    FireArtilleryShell(self.id, self.target)
    self.fireCooldown = GetWeaponReloadTime(self.id)
end

function ArtAI:Update(dt)
    self.scanCooldown = math.max(0, self.scanCooldown - dt)
    self.fireCooldown = math.max(0, self.fireCooldown - dt)

    self:FindTarget()
    self:KeepDistance()
    self:Attack()
end

return ArtAI
