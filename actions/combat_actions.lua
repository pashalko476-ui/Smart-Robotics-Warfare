local Weapons = require(path .. "/devices/weapons")
function CombatActions.OnProjectileHit(robot, weaponName, projectileName, target)
    local result = Weapons.ApplyDamage(weaponName, projectileName, target)

    if result then
        target:ApplyDamage(result.damage)
        target:ApplyImpulse(result.impulse)
    end
end
function CombatActions.UpdateMissiles(robot, obstacles)
    for _, missile in ipairs(robot.missiles or {}) do
        missile:Update(obstacles)

        if missile:CheckCollision() then
            missile:OnHit(missile.target)
        end
    end
end

