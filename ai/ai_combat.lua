-- ai_combat.lua
-- Центральный боевой модуль для всех роботов

local Priority  = require(path .. "/ai/target_priority.lua")
local Selector  = require(path .. "/ai/weapon_selector.lua")
local Robots    = require(path .. "/devices/robot_definitions.lua")
local Weapons = require(path .. "/devices/weapons")

local CombatAI = {}

---------------------------------------------------------
-- 1. Поиск лучшей цели
---------------------------------------------------------
function CombatAI.FindBestTarget(self)
    local enemies = GetVisibleEnemies(self.id)
    if #enemies == 0 then
        self.target = nil
        return nil
    end

    local bestTarget = nil
    local bestScore = -999

    for _, target in ipairs(enemies) do
        local score = Priority.Calculate(self, target)
        if score > bestScore then
            bestScore = score
            bestTarget = target
        end
    end

    self.target = bestTarget
    return bestTarget
end

---------------------------------------------------------
-- 2. Стрельба по цели всеми подходящими орудиями
---------------------------------------------------------
function CombatAI.FireWeapons(self)
    if not self.target then return end

    Selector.FireAllSuitableWeapons(self, self.target)
end

---------------------------------------------------------
-- 3. Движение к цели, если она одна
---------------------------------------------------------
function CombatAI.MoveToSingleTarget(self)
    local enemies = GetVisibleEnemies(self.id)
    if #enemies == 1 and self.target then
        MoveRobotTowards(self.id, self.target)
    end
end

---------------------------------------------------------
-- 4. Движение к выгодной дистанции (если целей много)
---------------------------------------------------------
function CombatAI.AdjustDistance(self)
    if not self.target then return end

    local dist = DistanceTo(self.id, self.target)
    local ideal = 800  -- универсальная дистанция боя

    if dist > ideal + 150 then
        MoveRobotTowards(self.id, self.target)
    elseif dist < ideal - 150 then
        MoveAwayFrom(self.id, self.target)
    end
end

---------------------------------------------------------
-- 5. Проверка: цель всё ещё выгодна?
-- Если нет — выбираем новую
---------------------------------------------------------
function CombatAI.ReevaluateTarget(self)
    if not self.target then return end

    local currentScore = Priority.Calculate(self, self.target)

    local enemies = GetVisibleEnemies(self.id)
    for _, enemy in ipairs(enemies) do
        if enemy ~= self.target then
            local score = Priority.Calculate(self, enemy)
            if score > currentScore + 2 then
                self.target = enemy
                return
            end
        end
    end
end

---------------------------------------------------------
-- 6. Главный боевой цикл
---------------------------------------------------------
function CombatAI.Update(self, dt)
    -- 1. Найти лучшую цель
    CombatAI.FindBestTarget(self)

    -- 2. Если цели нет — ничего не делаем
    if not self.target then return end

    -- 3. Проверить, не стала ли другая цель выгоднее
    CombatAI.ReevaluateTarget(self)

    -- 4. Движение к цели (если одна)
    CombatAI.MoveToSingleTarget(self)

    -- 5. Движение к выгодной дистанции (если целей много)
    CombatAI.AdjustDistance(self)

    -- 6. Стрельба всеми подходящими орудиями
    CombatAI.FireWeapons(self)
end

local damageResult = Weapons.ApplyDamage(weaponName, projectileName, target)

if damageResult then
    target:ApplyDamage(damageResult.damage)
    target:ApplyImpulse(damageResult.impulse)
end


return CombatAI

