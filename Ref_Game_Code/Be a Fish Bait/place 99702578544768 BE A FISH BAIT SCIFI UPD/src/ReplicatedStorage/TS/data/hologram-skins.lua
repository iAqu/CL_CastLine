-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    name = "Default",
    displayName = "Default",
    imageId = images.DefaultFishHologram
}
local PlotStuff = ReplicatedStorage:FindFirstChild("PlotStuff")

if PlotStuff ~= nil then
    PlotStuff = PlotStuff:FindFirstChild("HologramBase")

    if PlotStuff ~= nil then
        PlotStuff = PlotStuff:FindFirstChild("DefaultBase")
    end
end

t1.model = PlotStuff
t1.rarity = "common"

local t2 = {
    "Default",
    t1
}
local t3 = {
    name = "Cake",
    displayName = "Cake",
    imageId = images.CakeFishHologram
}
local PlotStuff2 = ReplicatedStorage:FindFirstChild("PlotStuff")

if PlotStuff2 ~= nil then
    PlotStuff2 = PlotStuff2:FindFirstChild("HologramBase")

    if PlotStuff2 ~= nil then
        PlotStuff2 = PlotStuff2:FindFirstChild("CakeBase")
    end
end

t3.model = PlotStuff2
t3.rarity = "rare"

local t4 = {
    "Cake",
    t3
}
local t5 = {
    name = "PremiumCake",
    displayName = "Premium Cake",
    imageId = images.FOMOCakeFishHologram
}
local PlotStuff3 = ReplicatedStorage:FindFirstChild("PlotStuff")

if PlotStuff3 ~= nil then
    PlotStuff3 = PlotStuff3:FindFirstChild("HologramBase")

    if PlotStuff3 ~= nil then
        PlotStuff3 = PlotStuff3:FindFirstChild("PremiumCakeBase")
    end
end

t5.model = PlotStuff3
t5.rarity = "epic"

local t6 = {}

for _, v1 in {
        t2,
        t4,
        { "PremiumCake", t5 }
    } do
    t6[v1[1]] = v1[2]
end

return {
    getHologramSkinData = function(p1) -- getHologramSkinData | line: 57
        -- upvalues: t6 (copy)
        return t6[p1]
    end,
    hologramSkinsData = t6
}
