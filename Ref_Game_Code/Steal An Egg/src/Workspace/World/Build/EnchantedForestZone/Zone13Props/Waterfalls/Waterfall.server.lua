-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Texture = script.Parent:QueryDescendants("Texture")

task.spawn(function() -- line: 7
    -- upvalues: Texture (copy)
    while true do
        local v1 = task.wait()

        for _, v2 in Texture do
            v2.OffsetStudsV = (v2.OffsetStudsV - v1 * 15) % -v2.StudsPerTileV
        end
    end
end)
