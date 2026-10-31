-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t1 = {
    buildTimeSecs = 10,
    level = 1,
    maxFish = 5
}
local Aquariums = ReplicatedStorage:FindFirstChild("Aquariums")

t1.model = if Aquariums ~= nil then Aquariums:FindFirstChild("Aquarium1") else Aquariums
t1.upgradeCost = 1E+05

local t2 = {
    buildTimeSecs = 600,
    level = 2,
    maxFish = 7
}
local Aquariums2 = ReplicatedStorage:FindFirstChild("Aquariums")

t2.model = if Aquariums2 ~= nil then Aquariums2:FindFirstChild("Aquarium2") else Aquariums2
t2.upgradeCost = 5E+05

local t3 = {
    buildTimeSecs = 1800,
    level = 3,
    maxFish = 9
}
local Aquariums3 = ReplicatedStorage:FindFirstChild("Aquariums")

t3.model = if Aquariums3 ~= nil then Aquariums3:FindFirstChild("Aquarium3") else Aquariums3
t3.upgradeCost = 5E+06

local t4 = {
    buildTimeSecs = 5400,
    level = 4,
    maxFish = 11
}
local Aquariums4 = ReplicatedStorage:FindFirstChild("Aquariums")

t4.model = if Aquariums4 ~= nil then Aquariums4:FindFirstChild("Aquarium4") else Aquariums4
t4.upgradeCost = 5E+07

local t5 = {
    buildTimeSecs = 0,
    level = 5,
    maxFish = 13
}
local Aquariums5 = ReplicatedStorage:FindFirstChild("Aquariums")

t5.model = if Aquariums5 ~= nil then Aquariums5:FindFirstChild("Aquarium5") else Aquariums5
t5.upgradeCost = 1e999

local t6 = {
    t1,
    t2,
    t3,
    t4,
    t5
}
local v1 = table.create(#t6)

local function v2(p1) -- line: 67
    return {
        p1.level,
        p1
    }
end

for v3, v4 in t6 do
    local _ = v3 - 1

    v1[v3] = {
        v4.level,
        v4
    }
end

local t7 = {}

for _, v5 in v1 do
    t7[v5[1]] = v5[2]
end

local function getAquariumData(p2) -- line: 79
    -- upvalues: t6 (copy), t7 (copy)
    local v6 = t7[p2]

    if v6 == nil then
        v6 = t6[1]
    end

    return v6
end

local t8 = {
    "Default",
    "Basketball",
    "IceHockey",
    "RaceArena",
    "Football",
    "Volcanic",
    "Gold",
    "Jurassic",
    "Fossil",
    "FOMO",
    "Castle",
    "Fantasy",
    "ModernHouse",
    "Scifi"
}

return {
    getAquariumData = getAquariumData,
    getAquariumSkinModel = function(p3, p4) -- getAquariumSkinModel | line: 88
        -- upvalues: ReplicatedStorage (copy), t6 (copy), t7 (copy)
        if p4 == "Default" then
            local v7 = t7[p3]

            if v7 == nil then
                v7 = t6[1]
            end

            return v7.model
        end

        local Aquariums = ReplicatedStorage:FindFirstChild("Aquariums")
        local Skins

        if Aquariums ~= nil then
            Skins = Aquariums:FindFirstChild("Skins")

            if Skins ~= nil then
                Skins = Skins:FindFirstChild(p4)
            end
        else
            Skins = Aquariums
        end

        if Skins then
            local v8 = Skins:FindFirstChild((("Aquarium%*"):format(p3)))

            if v8 and v8:IsA("Model") then
                return v8
            end

            local Children = Skins:GetChildren()
            local v9 = table.create(#Children)

            local function v10(p5) -- line: 114
                return p5.Name
            end

            for v11, v12 in Children do
                local _ = v11 - 1

                v9[v11] = v12.Name
            end

            warn("[src/shared/data/aquariums.ts:92]", (("[getAquariumSkinModel] Model \"Aquarium%*\" not found (or not a Model) under skin \"%*\". Children: [%*]. Falling back to Default."):format(p3, p4, (table.concat(v9, ", ")))))

            local v13 = t7[p3]

            if v13 == nil then
                v13 = t6[1]
            end

            return v13.model
        end

        warn("[src/shared/data/aquariums.ts:83]", (("[getAquariumSkinModel] Skin folder not found at ReplicatedStorage.Aquariums.Skins.%* (Aquariums exists=%*). Falling back to Default."):format(p4, Aquariums ~= nil)))

        local v14 = t7[p3]

        if v14 == nil then
            v14 = t6[1]
        end

        return v14.model
    end,
    allAquariumData = t6,
    aquariumDataByLevel = t7,
    aquariumSkinNames = t8
}
