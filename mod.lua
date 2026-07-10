-- mod.lua
--Robotics Warfare

local mod = RegisterMod("Robotics Warfare", 1)

mod.path = "RobotsMod"     -- корневая папка мода
mod.version = "1.4.88"      -- версия мода
mod.author = "Pidors"    -- можешь заменить

-- Подключение AI
Include(mod.path .. "/ai/tier1/worker.lua")
Include(mod.path .. "/ai/tier1/gunner.lua")
Include(mod.path .. "/ai/tier1/shield_breaker.lua")
Include(mod.path .. "/ai/tier1/emp_saboteur.lua")
Include(mod.path .. "/ai/tier1/kamikaze.lua")
Include(mod.path .. "/ai/tier1/scout.lua")

Include(mod.path .. "/ai/tier2/hunter_striker.lua")
Include(mod.path .. "/ai/tier2/phantom_strider.lua")
Include(mod.path .. "/ai/tier2/artillery_walker.lua")

Include(mod.path .. "/ai/tier3/aegis_titan.lua")
Include(mod.path .. "/ai/tier3/stormbringer.lua")
Include(mod.path .. "/ai/tier3/juggernaut.lua")
Include(mod.path .. "/ai/tier3/predator.lua")
Include(mod.path .. "/ai/tier3/executioner.lua")

Include(mod.path .. "/ai/tier4/titanus_devastator.lua")

-- Подключение действий
Include(mod.path .. "/actions/thrusters.lua")
Include(mod.path .. "/actions/heavy_movement.lua")
Include(mod.path .. "/actions/movement.lua")
Include(mod.path .. "/actions/worker_actions.lua")
Include(mod.path .. "/actions/combat_actions.lua")

-- Подключение устройств
Include(mod.path .. "/devices/robot_definitions.lua")
Include(mod.path .. "/devices/weapons.lua")
Include(mod.path .. "/devices/abilities.lua")

return mod
