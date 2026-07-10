-- effects.lua
-- Визуальные эффекты для всех типов оружия и снарядов

local Effects = {

    ---------------------------------------------------------
    -- СЛЕДЫ СНАРЯДОВ
    ---------------------------------------------------------

    bullet_trail = {
        type = "trail",
        color = {1.0, 0.9, 0.6},
        width = 2,
        duration = 0.15,
    },

    shell_trail = {
        type = "trail",
        color = {1.0, 0.8, 0.4},
        width = 4,
        duration = 0.25,
    },

    heavy_shell_trail = {
        type = "trail",
        color = {1.0, 0.7, 0.3},
        width = 6,
        duration = 0.35,
    },

    pulse_trail = {
        type = "trail",

