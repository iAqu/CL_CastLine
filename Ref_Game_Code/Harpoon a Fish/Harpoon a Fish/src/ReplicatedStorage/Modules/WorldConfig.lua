-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    HUB_PLACE_ID = 113384248926706,
    JURASSIC_PLACE_ID = 125360944450831
}

function t1.IsJurassic() -- line: 12
    -- upvalues: t1 (copy)
    if t1.JURASSIC_PLACE_ID == 0 then
        return false
    end

    return game.PlaceId == t1.JURASSIC_PLACE_ID
end

t1.HUB_CENTER = Vector3.new(50, 0, 0)
t1.JURASSIC_CENTER = Vector3.new(0, 0, 0)
t1.CENTER = t1.IsJurassic() and t1.JURASSIC_CENTER or t1.HUB_CENTER
t1.HUB_PIT = {
    PLANKS = -2104,
    DECOR = "Zone7Decor",
    SAND = -149
}
t1.JURASSIC_PIT = {
    PLANKS = -900,
    DECOR = "TitanPit",
    SAND = -60
}
t1.PIT = t1.IsJurassic() and t1.JURASSIC_PIT or t1.HUB_PIT
t1.PIT_DROP = t1.PIT.PLANKS - t1.HUB_PIT.PLANKS

return t1
