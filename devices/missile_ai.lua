-- missile_ai.lua
-- Умные ракеты: наведение, упреждение, уклонение, потеря энергии

local DamageSystem = require(path .. "/devices/damage_system")
local Projectiles = require(path .. "/devices/projectiles")

local MissileAI = {}

---------------------------------------------------------
-- НАВЕДЕНИЕ НА ЦЕЛЬ
---------------------------------------------------------

function MissileAI.SeekTarget(missile, target)
    if not target then return end

    local dx = target.x - missile.x
    local dy = target.y - missile.y

    local dist = math.sqrt(dx*dx + dy*dy)
    if dist == 0 then return end

    -- нормализуем направление
    local nx = dx / dist
    local ny = dy / dist

    -- поворот ракеты к цели
    missile.vx = missile.vx * 0.9 + nx * missile.turnRate
    missile.vy = missile.vy * 0.9 + ny * missile.turnRate
end

---------------------------------------------------------
-- УПРЕЖДЕНИЕ ПО ДВИЖЕНИЮ ЦЕЛИ
---------------------------------------------------------

function MissileAI.LeadTarget(missile, target)
    if not target or not target.vx then return end

    local leadFactor = 0.4

    missile.vx = missile.vx + target.vx * leadFactor
    missile.vy = missile.vy + target.vy * leadFactor
end

---------------------------------------------------------
-- УКЛОНЕНИЕ ОТ ПРЕПЯТСТВИЙ
---------------------------------------------------------

function MissileAI.AvoidObstacles(missile, obstacles)
    for _, obs in ipairs(obstacles or {}) do
        local dx = obs.x - missile.x
        local dy = obs.y - missile.y
        local dist = math.sqrt(dx*dx + dy*dy)

        if dist < 80 then
            -- ракета отталкивается от препятствия
            missile.vx = missile.vx - dx * 0.02
            missile.vy = missile.vy - dy * 0.02
        end
    end
end

---------------------------------------------------------
-- ПОТЕРЯ НАВЕДЕНИЯ ПРИ ПРОБИТИИ СЛОЁВ
---------------------------------------------------------

function MissileAI.LoseLockOnPenetration(missile, penetrationResult)
    if not penetrationResult.penetrated then
        -- ракета теряет наведение
        missile.turnRate = missile.turnRate * 0.3
        missile.speed = missile.speed * 0.5
    end
end

---------------------------------------------------------
-- ПОВЕДЕНИЕ В ПУСТОТЕ
---------------------------------------------------------

function MissileAI.FlyThroughVoid(missile)
    missile.speed = missile.speed * 0.7
    missile.energy = (missile.energy or 1.0) * 0.6
end

---------------------------------------------------------
-- ОБРАБОТКА СТОЛКНОВЕНИЯ
---------------------------------------------------------

function MissileAI.OnHit(missile, target)
    local projectile = Projectiles[missile.projectileName]
    if not projectile then return end

    -- вызываем систему урона
    local result = DamageSystem.OnHit(projectile, target)

    -- если ракета пробила слои — взрыв
    if result.penetrated then
        target:ApplyDamage(result.damage)
        target:ApplyImpulse(result.impulse)
    else
        -- потеря наведения
        MissileAI.LoseLockOnPenetration(missile, result)
    end
end

---------------------------------------------------------
-- ОБНОВЛЕНИЕ РАКЕТЫ КАЖДЫЙ ТИК
---------------------------------------------------------

function MissileAI.Update(missile, target, obstacles)
    -- если пустота — ракета теряет энергию
    if missile.inVoid then
        MissileAI.FlyThroughVoid(missile)
    end

    -- наведение
    MissileAI.SeekTarget(missile, target)

    -- упреждение
    MissileAI.LeadTarget(missile, target)

    -- уклонение
    MissileAI.AvoidObstacles(missile, obstacles)

    -- обновление позиции
    missile.x = missile.x + missile.vx * missile.speed
    missile.y = missile.y + missile.vy * missile.speed
end

return MissileAI

