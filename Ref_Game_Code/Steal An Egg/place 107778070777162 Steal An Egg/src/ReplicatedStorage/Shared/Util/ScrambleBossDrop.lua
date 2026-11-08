-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    HasObtained = function(p1) -- HasObtained | line: 3
        if p1.MechaScramblerObtained == true or p1.Index and p1.Index["Mecha Scrambler"] == true then
            return true
        end

        for _, v1 in p1.Inventory or {} do
            if v1.Category == "Mecha Scrambler" and v1.CreatorTemporary ~= true then
                return true
            end
        end

        for _, v2 in p1.EggInventory or {} do
            if v2.AssetCategory == "Mecha Scrambler" and v2.CreatorTemporary ~= true then
                return true
            end
        end

        return false
    end
}

return table.freeze(t1)
