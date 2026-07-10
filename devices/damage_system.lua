-- damage_system.lua
-- Реалистичная система урона: бронепробитие, слои, взрывы, импульс

local DamageSystem = {}

---------------------------------------------------------
-- МАТЕРИАЛЫ И ИХ БРОНЯ
---------------------------------------------------------

local Materials = {
    wood = { armor = 1 },
    metal = { armor = 3 },
    reinforced = { armor = 4 },
    concrete = { armor = 6 },
    armor_plate = { armor = 8 }, -- как броня Forts
}

---------------------------------------------------------
-- ПРОБИТИЕ СЛОЁВ
---------------------------------------------------------

function DamageSystem.PenetrateLayers(projectile, layers)
    local penetration = projectile.penetration or 1
    local energy = projectile.energy or 1.0

    for i, layer in ipairs(layers) do
        local armor = Materials[layer].armor

        if penetration >= armor then
            -- пробивает слой, теряет энергию
            penetration = penetration - armor
            energy = energy * 0.75
        else
            -- не пробил — вся энергия гасится
            return {
                penetrated = false,
                remainingEnergy = 0,
                stoppedAt = layer,
            }
        end
    end

    return {
        penetrated = true,
        remainingEnergy = energy,
        stoppedAt = nil,
    }
end

---------------------------------------------------------
-- ВЗРЫВ С ГРАДИЕНТОМ УРОНА
---------------------------------------------------------

function DamageSystem.ExplosionDamage(projectile, distance)
    local radius = projectile.explosionRadius or 100
    local maxDamage = projectile.damage or 50

    if distance > radius then
        return 0
    end

    -- градиент урона: центр = максимум, край = минимум
    local factor = 1 - (distance / radius)
    return maxDamage * factor
end

---------------------------------------------------------
-- УДАРНАЯ ВОЛНА (ИМПУЛЬС)
---------------------------------------------------------

function DamageSystem.Impulse(projectile, distance)
    local radius = projectile.explosionRadius or 100
    local maxImpulse = projectile.impulse or 0

    if distance > radius then
        return 0
    end

    local factor = 1 - (distance / radius)
    return maxImpulse * factor
end

---------------------------------------------------------
-- ОБРАБОТКА ПОПАДАНИЯ СНАРЯДА
---------------------------------------------------------

function DamageSystem.OnHit(projectile, target)
    -- 1. Проверяем слои материала
    local layers = target.layers or {"wood"} -- по умолчанию дерево
    local penetrationResult = DamageSystem.PenetrateLayers(projectile, layers)

    if not penetrationResult.penetrated then
        -- снаряд не пробил — урон гасится
        return {
            damage = 0,
            impulse = 0,
            penetrated = false,
            stoppedAt = penetrationResult.stoppedAt,
        }
    end

    -- 2. Если пробил — взрыв
    local distance = target.distance or 0

    local damage = DamageSystem.ExplosionDamage(projectile, distance)
    local impulse = DamageSystem.Impulse(projectile, distance)

    -- 3. Учитываем потерю энергии при пробитии
    damage = damage * penetrationResult.remainingEnergy
    impulse = impulse * penetrationResult.remainingEnergy

    return {
        damage = damage,
        impulse = impulse,
        penetrated = true,
        stoppedAt = nil,
    }
end

---------------------------------------------------------
-- ПОВЕДЕНИЕ СНАРЯДА В ПУСТОТЕ
---------------------------------------------------------

function DamageSystem.FlyThroughVoid(projectile)
    projectile.speed = projectile.speed * 0.6
    projectile.energy = (projectile.energy or 1.0) * 0.5
end

---------------------------------------------------------


return DamageSystem

