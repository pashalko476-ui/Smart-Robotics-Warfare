local Weapons = require(path .. "/devices/weapons")
function CombatActions.OnProjectileHit(robot, weaponName, projectileName, target)
    local result = Weapons.ApplyDamage(weaponName, projectileName, target)

    if result then
        target:ApplyDamage(result.damage)
        target:ApplyImpulse(result.impulse)
    end
end

