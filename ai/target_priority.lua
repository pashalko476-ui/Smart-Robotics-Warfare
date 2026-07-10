-- target_priority.lua
-- Система динамического приоритета целей

local Weapons = require(path .. "/devices/weapons.lua")
local Robots  = require(path .. "/devices/robot_definitions.lua")

local Priority = {}

---------------------------------------------------------
-- 1. Определение типа цели
---------------------------------------------------------
local function GetTargetType(target)
    if IsBuilding(target) then return "building" end
    if IsTank(target)     then return "tank"     end
    if IsRobot(target)    then
        local tier = GetRobotTier(target)
        if tier == 1 then return "robot_t1" end
        if tier == 2 then return "robot_t2" end
        if tier == 3 then return "robot_t3" end
        if tier == 4 then return "robot_t4" end
    end
    return "unknown"
end

---------------------------------------------------------
-- 2. Базовый приоритет по типу цели
---------------------------------------------------------
local basePriority = {
    robot_t4  = 12,
    robot_t3  = 10,
    robot_t2  = 7,
    robot_t1  = 4,
    tank      = 9,
    building  = 6,
    unknown   = 1
}

---------------------------------------------------------
-- 3. Приоритет по дистанции
-- Чем ближе цель — тем выше приоритет
-- Но если цель слишком далеко — приоритет падает
---------------------------------------------------------
local function DistancePriority(self, target)
    local dist = DistanceTo(self.id, target)
    local ideal = 800  -- универсальная дистанция боя

    -- ближе идеала → +приоритет
    -- дальше идеала → -приоритет
    return (ideal - dist) * 0.01
end

---------------------------------------------------------
-- 4. Приоритет по угрозе цели
-- Цели, которые наносят много урона → выше приоритет
---------------------------------------------------------
local function ThreatPriority(target)
    local dps = GetTargetDPS(target)
    return dps * 0.02
end

---------------------------------------------------------
-- 5. Приоритет по уязвимости цели
-- Цели с низким HP → выше приоритет (добивание)
---------------------------------------------------------
local function VulnerabilityPriority(target)
    local hp  = GetTargetHP(target)
    local max = GetTargetMaxHP(target)
    local percent = hp / max

    return (1 - percent) * 4
end

---------------------------------------------------------
-- 6. Приоритет по синергии оружия
-- Если у робота есть оружие, идеально подходящее для цели,
-- приоритет цели повышается.
---------------------------------------------------------
local function WeaponSynergyPriority(self, target)
    local ttype = GetTargetType(target)
    local w = Robots[self.type].weapons

    local score = 0

    -- Лёгкое оружие
    if w.light then
        local lw = Weapons[w.light]
        if lw and lw.target_types then
            for _, t in ipairs(lw.target_types) do
                if t == "small" and (ttype == "robot_t1") then
                    score = score + 3
                end
            end
        end
    end

    -- Среднее оружие
    if w.medium then
        local mw = Weapons[w.medium]
        if mw and mw.target_types then
            for _, t in ipairs(mw.target_types) do
                if t == "medium" and (ttype == "robot_t2" or ttype == "tank") then
                    score = score + 4
                end
            end
        end
    end

    -- Тяжёлое оружие
    if w.heavy then
        local hw = Weapons[w.heavy]
        if hw and hw.target_types then
            for _, t in ipairs(hw.target_types) do
                if t == "heavy" and (ttype == "robot_t3" or ttype == "robot_t4" or ttype == "building") then
                    score = score + 6
                end
            end
        end
    end

    return score
end

---------------------------------------------------------
-- 7. Финальная функция вычисления приоритета
---------------------------------------------------------
function Priority.Calculate(self, target)
    local ttype = GetTargetType(target)

    local score = 0

    -- базовый приоритет по типу цели
    score = score + (basePriority[ttype] or 1)

    -- дистанция
    score = score + DistancePriority(self, target)

    -- угроза
    score = score + ThreatPriority(target)

    -- уязвимость
    score = score + VulnerabilityPriority(target)

    -- синергия оружия
    score = score + WeaponSynergyPriority(self, target)

    return score
end

return Priority

