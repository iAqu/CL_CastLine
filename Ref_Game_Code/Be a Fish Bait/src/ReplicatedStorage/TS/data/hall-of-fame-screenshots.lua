-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    {
        id = "communityScreenshotPlaceholder1",
        section = "community",
        imageAssetId = "rbxassetid://0",
        caption = "PLACEHOLDER_CAPTION"
    },
    {
        id = "creatorsScreenshotPlaceholder1",
        section = "creators",
        imageAssetId = "rbxassetid://0",
        caption = "PLACEHOLDER_CAPTION"
    },
    {
        id = "developersScreenshotPlaceholder1",
        section = "developers",
        imageAssetId = "rbxassetid://0",
        caption = "PLACEHOLDER_CAPTION"
    }
}

local function getHallOfFameScreenshotsForSection(p1) -- line: 24
    -- upvalues: t1 (copy)
    local t2 = {}
    local n1 = 0

    for v1, v2 in t1 do
        local _ = v1 - 1

        if v2.section == p1 == true then
            n1 += 1
            t2[n1] = v2
        end
    end

    return t2
end

local v3 = table.create(#t1)

local function v4(p2) -- line: 42
    return {
        p2.id,
        p2
    }
end

for v5, v6 in t1 do
    local _ = v5 - 1

    v3[v5] = {
        v6.id,
        v6
    }
end

local t3 = {}

for _, v7 in v3 do
    t3[v7[1]] = v7[2]
end

return {
    getHallOfFameScreenshotsForSection = getHallOfFameScreenshotsForSection,
    getHallOfFameScreenshotData = function(p3) -- getHallOfFameScreenshotData | line: 54
        -- upvalues: t3 (copy)
        return t3[p3]
    end,
    hallOfFameScreenshotsData = t1,
    hallOfFameScreenshotsById = t3
}
