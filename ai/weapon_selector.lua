-- weapon_selector.lua
-- Выбор оружия + стрельба всеми подходящими орудиями

local Weapons = require(path .. "/devices/weapons.lua")
local Robots  = require(path .. "/devices/robot_definitions.lua")

local Selector = {}

---------------------------------------------------------
-- 1. Определение размера цели
---------------------------------------------------------
local function GetSizeCategory(target)
    if IsBuilding(target) then return "heavy" end
    if IsTank(target)     then return "medium" end

    if IsRobot(target) then
        local tier = GetRobotTier(target)
        if tier == 1 then return "small" end
        if tier == 2 then return "medium" end
        if tier >= 3 then return "heavy" end
    end

    return "small"
end

---------------------------------------------------------
-- 2. Выбор одного оружия для конкретной цели
---------------------------------------------------------
function Selector.ChooseWeapon(self, target)
    local size = GetSizeCategory(target)
    local w = Robots[self.type].weapons

    -- Мелкие цели → лёгкое оружие
    if size == "small" and w.light then
        return w.light
    end

    -- Средние цели → среднее оружие
    if size == "medium" and w.medium then
        return w.medium
    end

    -- Тяжёлые цели → тяжёлое оружие
    if size == "heavy" and w.heavy then
        return w.heavy
    end

    -- Если нет подходящего — fallback
    return w.light or w.medium or w.heavy
end

---------------------------------------------------------
-- 3. Проверка: подходит ли оружие для цели
---------------------------------------------------------
local function IsWeaponSuitable(weapon, target)
    local w = Weapons[weapon]
    if not w then return false end

    local size = GetSizeCategory(target)

    for _, t in ipairs(w.target_types or {}) do
        if t == size then
            return true
        end
    end

    return false
end

---------------------------------------------------------
-- 4. Стрельба всеми подходящими орудиями
---------------------------------------------------------
function Selector.FireAllSuitableWeapons(self, target)
    local wset = Robots[self.type].weapons

    -- Лёгкое оружие
    if wset.light and IsWeaponSuitable(wset.light, target) then
        FireWeapon(self.id, wset.light, target)
    end

    -- Среднее оружие
    if wset.medium and IsWeaponSuitable(wset.medium, target) then
        FireWeapon(self.id, wset.medium, target)
    end

    -- Тяжёлое оружие
    if wset.heavy and IsWeaponSuitable(wset.heavy, target) then
        FireWeapon(self.id, wset.heavy, target)
    end
end

---------------------------------------------------------
-- 5. Стрельба одним оружием (для простых роботов)
---------------------------------------------------------
function Selector.FireSingleWeapon(self, target)
    local weapon = Selector.ChooseWeapon(self, target)
    FireWeapon(self.id, weapon, target)
end

return Selector

