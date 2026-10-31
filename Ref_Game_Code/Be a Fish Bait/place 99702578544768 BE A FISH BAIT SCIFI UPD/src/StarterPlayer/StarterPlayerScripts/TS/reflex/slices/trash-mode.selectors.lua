-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    selectTrashModeEnabled = function(p1) -- selectTrashModeEnabled | line: 2
        return p1.trashMode.isEnabled
    end,
    selectTrashModeSelectedItemIds = function(p2) -- selectTrashModeSelectedItemIds | line: 5
        return p2.trashMode.selectedItemIds
    end,
    selectIsItemSelectedForTrash = function(p3) -- selectIsItemSelectedForTrash | line: 8
        return function(p4) -- line: 9
            -- upvalues: p3 (copy)
            local selectedItemIds = p4.trashMode.selectedItemIds

            return table.find(selectedItemIds, p3) ~= nil
        end
    end
}
