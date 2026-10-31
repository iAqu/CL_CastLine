-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    getToolbarSlotCount = function(p1) -- getToolbarSlotCount | line: 7
        if p1 then
            return 5
        end

        return 9
    end,
    getToolbarSlotCountForViewportWidth = function(p2) -- getToolbarSlotCountForViewportWidth | line: 11
        if p2 < 1366 then
            return 5
        end

        return 9
    end,
    getToolbarMetrics = function(p3) -- getToolbarMetrics | line: 14
        local v1 = if p3 then 1.25 else 1
        local v2 = v1 * 0.55
        local v3 = v1 * 0.064
        local v5 = if p3 then 0.04 else 0.026
        local v4 = if p3 then 1.5 else 1
        local v6 = v1 * 0.16 * v4
        local v7 = v1 * 0.025 * v4

        return {
            buttonGap = v5,
            buttonHeight = v7,
            buttonWidth = v6,
            toolbarHeight = v3,
            toolbarScale = v1,
            toolbarWidth = v2,
            unitHeight = v7 + v5 + v3
        }
    end
}
