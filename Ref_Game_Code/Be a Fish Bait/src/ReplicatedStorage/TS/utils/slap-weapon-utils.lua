-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    slapToolName = "Slap",
    slapWeaponItemId = "SlapWeapon",
    pinataBossEquipRestrictionReason = "Must have the Slap weapon equipped during the pinata boss fight",
    slapHitCooldown = 1,
    slapForwardOffset = 4,
    slapHitboxSize = Vector3.new(8, 8, 8),
    computeSlapCFrame = function(p1) -- computeSlapCFrame | line: 16
        return p1.CFrame * CFrame.new(0, 0, -4)
    end,
    isPositionWithinHitbox = function(p2, p3, p4, p5) -- isPositionWithinHitbox | line: 28
        local v1 = if p5 == nil then 0 else p5
        local v2 = p3:PointToObjectSpace(p2)

        if math.abs(v2.X) <= p4.X / 2 + v1 then
            if not (math.abs(v2.Y) <= p4.Y / 2 + v1) then
                return false
            end

            return math.abs(v2.Z) <= p4.Z / 2 + v1
        end

        return false
    end
}
