-- projectiles.lua
-- Описание всех типов снарядов для роботов

local Projectiles = {

    ---------------------------------------------------------
    -- МАЛЫЕ СНАРЯДЫ (TIER 1)
    ---------------------------------------------------------

    bullet_small = {
        speed = 900,
        gravity = 0,
        size = 4,
        trail = "bullet_trail",
        hitEffect = "impact_small",
    },

    shell_light = {
        speed = 600,
        gravity = 0.4,
        size = 10,
        trail = "shell_trail",
        hitEffect = "impact_shell",
        explosion = "small_explosion",
    },

    pierce_beam = {
        speed = 9999,
        gravity = 0,
        size = 0,
        beam = true,
        hitEffect = "beam_hit",
        shieldDamage = 40,
    },

    pulse_small = {
        speed = 700,
        gravity = 0,
        size = 6,
        trail = "pulse_trail",
        hitEffect = "pulse_hit",
        impulse = 20,
    },

    emp_wave = {
        speed = 500,
        gravity = 0,
        size = 12,
        aoeRadius = 120,
        hitEffect = "emp_blast",
        disableTime = 2.0,
    },

    disrupt_pulse = {
        speed = 650,
        gravity = 0,
        size = 6,
        trail = "disrupt_trail",
        hitEffect = "disrupt_hit",
    },

    sniper_bolt = {
        speed = 1400,
        gravity = 0,
        size = 4,
        trail = "sniper_trail",
        hitEffect = "sniper_hit",
        ignoreArmor = true,
    },

    self_destruct = {
        speed = 0,
        gravity = 0,
        size = 0,
        explosion = "kamikaze_explosion",
    },

    ---------------------------------------------------------
    -- СРЕДНИЕ СНАРЯДЫ (TIER 2)
    ---------------------------------------------------------

    shotgun_pellet = {
        speed = 800,
        gravity = 0.2,
        size = 3,
        spread = 0.15,
        hitEffect = "pellet_hit",
    },

    phase_bolt = {
        speed = 1000,
        gravity = 0,
        size = 5,
        trail = "phase_trail",
        hitEffect = "phase_hit",
        ignoreArmor = true,
    },

    missile_ghost = {
        speed = 450,
        gravity = 0,
        size = 12,
        homing = true,
        turnRate = 0.9,
        trail = "ghost_trail",
        hitEffect = "missile_hit",
        explosion = "ghost_explosion",
    },

    shell_heavy = {
        speed = 500,
        gravity = 0.6,
        size = 14,
        arc = true,
        trail = "heavy_shell_tr
