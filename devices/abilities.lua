-- abilities.lua
-- Активируемые способности роботов

local Abilities = {

    ---------------------------------------------------------
    -- TIER 1 ABILITIES
    ---------------------------------------------------------

    worker_repair = {
        cooldown = 6,
        duration = 2,
        healAmount = 40,
        effect = "repair_effect",
        description = "Ремонтирует ближайшие структуры.",
    },

    scout_dash = {
        cooldown = 4,
        dashSpeed = 220,
        dashTime = 0.25,
        effect = "dash_effect",
        description = "Совершает быстрый рывок вперёд.",
    },

    saboteur_emp = {
        cooldown = 8,
        radius = 120,
        disableTime = 2.0,
        effect = "emp_blast",
        description = "Вызывает локальный EMP-взрыв.",
    },

    ---------------------------------------------------------
    -- TIER 2 ABILITIES
    ---------------------------------------------------------

    striker_overdrive = {
        cooldown = 10,
        duration = 3,
        damageBoost = 1.4,
        speedBoost = 1.3,
        effect = "overdrive_effect",
        description = "Увеличивает урон и скорость ближнего боя.",
    },

    phantom_phase = {
        cooldown = 12,
        duration = 2,
        invulnerable = true,
        fadeEffect = "phase_effect",
        description = "Робот становится фазовым и неуязвимым.",
    },

    artillery_lock = {
        cooldown = 14,
        lockTime = 2.5,
        accuracyBoost = 1.5,
        effect = "target_lock_effect",
        description = "Фиксирует цель для точного артиллерийского удара.",
    },

    ---------------------------------------------------------
    -- TIER 3 ABILITIES
    ---------------------------------------------------------

    titan_shield_wall = {
        cooldown = 18,
        duration = 4,
        shieldStrength = 300,
        effect = "shield_wall_effect",
        description = "Создаёт мощный энергетический щит.",
    },

    storm_overcharge = {
        cooldown = 16,
        duration = 3,
        missileBoost = 1.3,
        fireRateBoost = 1.25,
        effect = "overcharge_effect",
        description = "Усиливает ракетный залп и ускоряет стрельбу.",
    },

    juggernaut_groundslam = {
        cooldown = 20,
        radius = 180,
        damage = 120,
        impulse = 300,
        effect = "groundslam_effect",
        description = "Мощный удар по земле, создающий ударную волну.",
    },

    predator_mark = {
        cooldown = 12,
        duration = 4,
        damageBoost = 1.5,
        effect = "mark_effect",
        description = "Отмечает цель, увеличивая урон по ней.",
    },

    executioner_bloodrage = {
        cooldown = 15,
        duration = 3,
        speedBoost = 1.4,
        meleeBoost = 1.5,
        effect = "bloodrage_effect",
        description = "Увеличивает скорость и урон ближнего боя.",
    },

    ---------------------------------------------------------
    -- TIER 4 ABILITIES
    ---------------------------------------------------------

    devastator_overload = {
        cooldown = 25,
        duration = 5,
        beamBoost = 1.6,
        impulseBoost = 1.5,
        effect = "overload_effect",
        description = "Перегружает лучевое оружие, увеличивая мощность.",
    },

    obliterator_storm = {
        cooldown = 22,
        duration = 4,
        swarmBoost = 1.5,
        turnRateBoost = 1.3,
        effect = "storm_effect",
        description = "Усиливает рой ракет и улучшает наведение.",
    },

    titanus_quake = {
        cooldown = 30,
        radius = 300,
        damage = 200,
        impulse = 600,
        effect = "quake_effect",
        description = "Создаёт гигантскую ударную волну, разрушая всё вокруг.",
    },
}

return Abilities
