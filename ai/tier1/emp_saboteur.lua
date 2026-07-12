-- EMP Saboteur AI

local BaseAI = require(path .. "/ai/ai_base.lua")
local EmpAI = setmetatable({}, { __index = BaseAI })
robot.missiles = {}

function EmpAI:Init(id)
    BaseAI.Init(self, id)

    self.scanCooldown = 0
    self.empCooldown  = 0
    self.dashCooldown = 0

    self.empRange = 300
end

function EmpAI:GetPriority(target)
    if IsDevice(target) then
        return 8
    end
    return 1
end

function EmpAI:FindTarget()
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

function EmpAI:MiniDash()
    if self.dashCooldown > 0 then return end
    if not self.target then return end

    if IsUnderFire(self.id) then
        MiniDash(self.id)
        self.dashCooldown = 2.0
    end
end

function EmpAI:MoveToTarget()
    if not self.target then return end
    MoveRobotTowards(self.id, self.target)
end

function EmpAI:UseEMP()
    if self.empCooldown > 0 then return end
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    if dist <= self.empRange then
        FireEMPBlast(self.id)
        self.empCooldown = 5.0
    end
end

function EmpAI:Update(dt)
    self.scanCooldown = math.max(0, self.scanCooldown - dt)
    self.empCooldown  = math.max(0, self.empCooldown - dt)
    self.dashCooldown = math.max(0, self.dashCooldown - dt)

    self:FindTarget()
    self:MiniDash()
    self:MoveToTarget()
    self:UseEMP()
end

return EmpAI
