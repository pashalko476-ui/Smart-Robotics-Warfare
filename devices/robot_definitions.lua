-- robot_definitions.lua
-- Основные характеристики всех роботов

local Robots = {

    ---------------------------------------------------------
    -- TIER 1
    ---------------------------------------------------------
    worker_bot = {
        tier = 1,
        health = 120,
        speed = 80,
        mass = 1.0,
        weapons = {},
        role = "support",
    },

    gunner = {
        tier = 1,
        health = 180,
        speed = 90,
        mass = 1.2,
        weapons = { "minigun", "light_cannon" },
        role = "ranged",
    },

    shield_breaker = {
        tier = 1,
        health = 160,
        speed = 85,
        mass = 1.3,
        weapons = { "shield_piercer", "pulse_rifle" },
        role = "anti_shield",
    },

    emp_saboteur = {
        tier = 1,
        health = 140,
        speed = 95,
        mass = 1.0,
        weapons = { "emp_blast", "disruptor" },
        role = "utility",
    },

    scout = {
        tier = 1,
        health = 110,
        speed = 120,
        mass = 0.8,
        weapons = { "scout_rifle" },
        role = "recon",
    },

    kamikaze = {
        tier = 1,
        health = 100,
        speed = 130,
        mass = 0.7,
        weapons = { "explosive_core" },
        role = "suicide",
    },

    ---------------------------------------------------------
    -- TIER 2
    ---------------------------------------------------------
    hunter_striker = {
        tier = 2,
        health = 260,
        speed = 100,
        mass = 1.8,
        weapons = { "striker_blades", "shotgun_burst" },
        role = "melee",
    },

    phantom_strider = {
        tier = 2,
        health = 240,
        speed = 110,
        mass = 1.6,
        weapons = { "phase_rifle", "ghost_missile" },
        role = "stealth",
    },

    artillery_walker = {
        tier = 2,
        health = 300,
        speed = 70,
        mass = 2.5,
        weapons = { "artillery_cannon", "cluster_launcher" },
        role = "artillery",
    },

    ---------------------------------------------------------
    -- TIER 3
    ---------------------------------------------------------
    aegis_titan = {
        tier = 3,
        health = 600,
        speed = 60,
        mass = 4.0,
        weapons = { "titan_shield", "heavy_laser" },
        role = "tank",
    },

    stormbringer = {
        tier = 3,
        health = 520,
        speed = 80,
        mass = 3.5,
        weapons = { "storm_missiles", "arc_blaster" },
        role = "aoe",
    },

    juggernaut = {
        tier = 3,
        health = 700,
        speed = 55,
        mass = 4.5,
        weapons = { "railgun", "crusher_fists" },
        role = "heavy",
    },

    predator = {
        tier = 3,
        health = 480,
        speed = 100,
        mass = 3.0,
        weapons = { "sniper_lance", "hunter_missile" },
        role = "assassin",
    },

    executioner = {
        tier = 3,
        health = 650,
        speed = 75,
        mass = 4.2,
        weapons = { "execution_blade", "pulse_cannon" },
        role = "elite",
    },

    ---------------------------------------------------------
    -- TIER 4
    ---------------------------------------------------------
    titanus_devastator = {
        tier = 4,
        health = 1200,
        speed = 50,
        mass = 8.0,
        weapons = { "devastator_beam", "obliterator_missiles", "quake_hammer" },
        role = "superheavy",
    },
}

return Robots

