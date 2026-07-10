-- weapons.lua
-- Параметры оружия для всех роботов
local DamageSystem = require(path .. "/devices/damage_system")
local Projectiles = require(path .. "/devices/projectiles")

function Weapons.ApplyDamage(weaponName, projectileName, target)
    local projectile = Projectiles[projectileName]
    if not projectile then return end

    return DamageSystem.OnHit(projectile, target)
end

local Weapons = {

    ---------------------------------------------------------
    -- ЛЁГКОЕ ОРУЖИЕ (TIER 1)
    ---------------------------------------------------------

    minigun = {
        type = "bullet",
        damage = 6,
        fireRate = 0.08,
        range = 450,
        projectile = "bullet_small",
        accuracy = 0.92,
        impulse = 0,
    },

    light_cannon = {
        type = "shell",
        damage = 25,
        fireRate = 0.9,
        range = 600,
        projectile = "shell_light",
        accuracy = 0.85,
        impulse = 80,
    },

    shield_piercer = {
        type = "beam",
        damage = 12,
        fireRate = 0.5,
        range = 500,
        projectile = "pierce_beam",
        shieldDamage = 40,
        impulse = 0,
    },

    pulse_rifle = {
        type = "pulse",
        damage = 18,
        fireRate = 0.4,
        range = 520,
        projectile = "pulse_small",
        impulse = 20,
    },

    emp_blast = {
        type = "emp",
        damage = 0,
        fireRate = 1.5,
        range = 450,
        projectile = "emp_wave",
        disableTime = 2.0,
    },

    disruptor = {
        type = "disrupt",
        damage = 10,
        fireRate = 0.6,
        range = 480,
        projectile = "disrupt_pulse",
        impulse = 10,
    },

    scout_rifle = {
        type = "sniper",
        damage = 22,
        fireRate = 0.7,
        range = 700,
        projectile = "sniper_bolt",
        accuracy = 0.97,
        impulse = 0,
    },

    explosive_core = {
        type = "suicide",
        damage = 120,
        radius = 120,
        fireRate = 999,
        range = 0,
        projectile = "self_destruct",
    },

    ---------------------------------------------------------
    -- СРЕДНЕЕ ОРУЖИЕ (TIER 2)
    ---------------------------------------------------------

    striker_blades = {
        type = "melee",
        damage = 40,
        fireRate = 0.3,
        range = 80,
        projectile = "none",
        impulse = 120,
    },

    shotgun_burst = {
        type = "shotgun",
        damage = 8,
        pellets = 8,
        fireRate = 0.9,
        range = 350,
        projectile = "shotgun_pellet",
        impulse = 40,
    },

    phase_rifle = {
        type = "phase",
        damage = 30,
        fireRate = 0.5,
        range = 650,
        projectile = "phase_bolt",
        ignoreArmor = true,
    },

    ghost_missile = {
        type = "missile",
        damage = 45,
        fireRate = 1.2,
        range = 900,
        projectile = "missile_ghost",
        homing = true,
        turnRate = 0.9,
        impulse = 120,
    },

    artillery_cannon = {
        type = "artillery",
        damage = 80,
        fireRate = 2.5,
        range = 1400,
        projectile = "shell_heavy",
        arc = true,
        impulse = 200,
    },

    cluster_launcher = {
        type = "cluster",
        damage = 20,
        fireRate = 2.0,
        range = 1200,
        projectile = "cluster_shell",
        subProjectiles = 6,
    },

    ---------------------------------------------------------
    -- ТЯЖЁЛОЕ ОРУЖИЕ (TIER 3)
    ---------------------------------------------------------

    titan_shield = {
        type = "shield",
        damage = 0,
        fireRate = 0.1,
        range = 0,
        projectile = "none",
        shieldStrength = 300,
    },

    heavy_laser = {
        type = "beam",
        damage = 45,
        fireRate = 0.4,
        range = 900,
        projectile = "laser_heavy",
        impulse = 200, -- как лазер Birdies, толкает объекты
    },

    storm_missiles = {
        type = "swarm",
        damage = 18,
        fireRate = 0.3,
        range = 1100,
        projectile = "missile_swarm",
        homing = true,
        swarmCount = 6,
        turnRate = 1.2,
    },

    arc_blaster = {
        type = "arc",
        damage = 35,
        fireRate = 0.6,
        range = 500,
        projectile = "arc_bolt",
        chainTargets = 3,
    },

    railgun = {
        type = "rail",
        damage = 120,
        fireRate = 3.0,
        range = 1600,
        projectile = "rail_slug",
        ignoreArmor = true,
        impulse = 300,
    },

    crusher_fists = {
        type = "melee",
        damage = 70,
        fireRate = 0.5,
        range = 100,
        projectile = "none",
        impulse = 200,
    },

    sniper_lance = {
        type = "sniper",
        damage = 90,
        fireRate = 1.8,
        range = 1800,
        projectile = "lance_bolt",
        accuracy = 0.99,
        ignoreArmor = true,
    },

    hunter_missile = {
        type = "missile",
        damage = 60,
        fireRate = 1.4,
        range = 1300,
        projectile = "missile_hunter",
        homing = true,
        turnRate = 1.4,
    },

    execution_blade = {
        type = "melee",
        damage = 100,
        fireRate = 0.4,
        range = 120,
        projectile = "none",
        impulse = 250,
    },

    pulse_cannon = {
        type = "pulse",
        damage = 55,
        fireRate = 0.7,
        range = 850,
        projectile = "pulse_heavy",
        impulse = 150,
    },

    ---------------------------------------------------------
    -- СУПЕРТЯЖЁЛОЕ ОРУЖИЕ (TIER 4)
    ---------------------------------------------------------

    devastator_beam = {
        type = "beam",
        damage = 160,
        fireRate = 1.2,
        range = 2000,
        projectile = "beam_devastator",
        impulse = 600, -- как Birdies Repulsor Beam, но мощнее
    },

    obliterator_missiles = {
        type = "swarm",
        damage = 40,
        fireRate = 0.5,
        range = 1800,
        projectile = "missile_obliterator",
        homing = true,
        swarmCount = 12,
        turnRate = 1.6,
    },

    quake_hammer = {
        type = "melee",
        damage = 200,
        fireRate = 1.0,
        range = 150,
        projectile = "none",
        impulse = 800,
        shockwaveRadius = 300,
    },
}

return Weapons
