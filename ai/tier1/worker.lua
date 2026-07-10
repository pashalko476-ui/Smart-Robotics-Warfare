-- Worker Bot AI (Full Version)

local BaseAI = require(path .. "/ai/ai_base.lua")
local WorkerAI = setmetatable({}, { __index = BaseAI })

function WorkerAI:Init(id)
    BaseAI.Init(self, id)

    self.repairRobotCooldown = 0
    self.repairBlockCooldown = 0
    self.buildGroundCooldown = 0
    self.buildFortCooldown   = 0
end

---------------------------------------------------------
---------------------------------------------------------
function WorkerAI:RepairRobots()
    if self.repairRobotCooldown > 0 then return end

    local allies = GetVisibleAllies(self.id)
    for _, ally in ipairs(allies) do
        if IsRobot(ally) and GetRobotHealth(ally) < GetRobotMaxHealth(ally) then
            RepairRobot(self.id, ally)
            self.repairRobotCooldown = 1.0
            return
        end
    end
end

---------------------------------------------------------
---------------------------------------------------------
function WorkerAI:RepairBlocks()
    if self.repairBlockCooldown > 0 then return end

    local blocks = GetNearbyBlocks(self.id, 300)
    for _, block in ipairs(blocks) do
        if GetBlockHealth(block) < GetBlockMaxHealth(block) then
            RepairBlock(self.id, block)
            self.repairBlockCooldown = 1.2
            return
        end
    end
end

---------------------------------------------------------
---------------------------------------------------------
function WorkerAI:RestoreDestroyedBlocks()
    if self.buildFortCooldown > 0 then return end

    local ruins = GetDestroyedBlockPositions(self.id, 400)
    if #ruins > 0 then
        local pos = ruins[1]
        RebuildBlock(self.id, pos)
        self.buildFortCooldown = 2.5
    end
end

---------------------------------------------------------
---------------------------------------------------------
function WorkerAI:PlaceTemporaryGround()
    if self.buildGroundCooldown > 0 then return end

    if NeedTemporaryGround(self.id) then
        local pos = FindBuildPosition(self.id)
        if pos then
            PlaceTemporaryGround(self.id, pos)
            self.buildGroundCooldown = 3.0
        end
    end
end

---------------------------------------------------------
---------------------------------------------------------
function WorkerAI:BuildFortifications()
    if self.buildFortCooldown > 0 then return end

    local tiles = GetTemporaryGroundTiles(self.id)
    for _, tile in ipairs(tiles) do
        if CanBuildFortification(tile) then
            BuildFortification(self.id, tile)
            self.buildFortCooldown = 4.0
            return
        end
    end
end

---------------------------------------------------------
---------------------------------------------------------
function WorkerAI:Update(dt)
    self.repairRobotCooldown = math.max(0, self.repairRobotCooldown - dt)
    self.repairBlockCooldown = math.max(0, self.repairBlockCooldown - dt)
    self.buildGroundCooldown = math.max(0, self.buildGroundCooldown - dt)
    self.buildFortCooldown   = math.max(0, self.buildFortCooldown - dt)

    self:RepairRobots()
    self:RepairBlocks()
    self:RestoreDestroyedBlocks()
    self:PlaceTemporaryGround()
    self:BuildFortifications()
end

return WorkerAI
