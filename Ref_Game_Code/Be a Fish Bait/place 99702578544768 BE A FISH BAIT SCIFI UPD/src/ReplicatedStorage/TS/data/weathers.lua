-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t1 = {
    cooldown = 0
}
local Weathers = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers ~= nil then
    Weathers = Weathers:FindFirstChild("Delulu")

    if Weathers ~= nil then
        Weathers = Weathers:FindFirstChild("DeluluRift")
    end
end

t1.deluluRift = Weathers
t1.duration = 4
t1.name = "Delulu"

local Weathers2 = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers2 ~= nil then
    Weathers2 = Weathers2:FindFirstChild("Delulu")

    if Weathers2 ~= nil then
        Weathers2 = Weathers2:FindFirstChild("Skybox")
    end
end

t1.skybox = Weathers2

local Weathers3 = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers3 ~= nil then
    Weathers3 = Weathers3:FindFirstChild("Delulu")

    if Weathers3 ~= nil then
        Weathers3 = Weathers3:FindFirstChild("VFX")
    end
end

t1.vfxModel = Weathers3
t1.title = "Delulu"
t1.weatherIcon = "rbxassetid://81598789062816"
t1.description = "Chance to spawn a delulu rift!"
t1.rollSchedule = {
    minMinutesBeforeRoll = 5,
    baseChancePerMinute = 0.1,
    chanceIncreasePerMinutePastThreshold = 0.1
}

local t2 = {
    "Delulu",
    t1
}
local t3 = {
    cooldown = 30,
    duration = 10,
    name = "Glitched"
}
local Weathers4 = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers4 ~= nil then
    Weathers4 = Weathers4:FindFirstChild("Glitched")

    if Weathers4 ~= nil then
        Weathers4 = Weathers4:FindFirstChild("Skybox")
    end
end

t3.skybox = Weathers4

local Weathers5 = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers5 ~= nil then
    Weathers5 = Weathers5:FindFirstChild("Glitched")

    if Weathers5 ~= nil then
        Weathers5 = Weathers5:FindFirstChild("VFX")
    end
end

t3.vfxModel = Weathers5
t3.title = "Glitched"
t3.weatherIcon = "rbxassetid://70481882196291"
t3.description = "10% chance for Glitched mutation"
t3.lightingOverride = {
    atmosphereDensity = 0.2,
    atmosphereOffset = 0.15,
    brightness = 0.61,
    fogEnd = 1000,
    fogStart = 100,
    ambient = Color3.fromRGB(200, 200, 200),
    atmosphereColor = Color3.fromRGB(5, 5, 5),
    colorShiftBottom = Color3.fromRGB(20, 0, 30),
    colorShiftTop = Color3.fromRGB(0, 10, 20),
    fogColor = Color3.fromRGB(70, 192, 13),
    outdoorAmbient = Color3.fromRGB(5, 0, 10)
}

local t4 = {
    "Glitched",
    t3
}
local t5 = {
    buffText = "x2 Mutation Chance, x10 Chance to catch \"Unc-thulu\"",
    cooldown = 45,
    description = "x2 Mutation Luck\nx10 Unc-thulu Luck",
    duration = 10,
    hudBuffText = "Unc's Calling: <font color=\"rgb(78,254,86)\">x2 Mutation Luck</font> &amp; <font color=\"rgb(78,254,86)\">x10 Encounter Luck</font> for <font color=\"rgb(255,100,55)\">Unc-thulu</font>",
    name = "Unc's Calling"
}
local Weathers6 = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers6 ~= nil then
    Weathers6 = Weathers6:FindFirstChild("UncsCalling")

    if Weathers6 ~= nil then
        Weathers6 = Weathers6:FindFirstChild("Skybox")
    end
end

t5.skybox = Weathers6
t5.title = "Unc's Calling"

local Weathers7 = ReplicatedStorage:FindFirstChild("Weathers")

if Weathers7 ~= nil then
    Weathers7 = Weathers7:FindFirstChild("UncsCalling")

    if Weathers7 ~= nil then
        Weathers7 = Weathers7:FindFirstChild("VFX")
    end
end

t5.vfxModel = Weathers7
t5.weatherIcon = "rbxassetid://84369342899004"

local t6 = {}

for _, v1 in {
        t2,
        t4,
        { "Unc's Calling", t5 }
    } do
    t6[v1[1]] = v1[2]
end

local t7 = {
    cooldown = 0,
    duration = 0,
    name = "None"
}
local Weathers8 = ReplicatedStorage:FindFirstChild("Weathers")

t7.skybox = if Weathers8 ~= nil then Weathers8:FindFirstChild("DefaultSky") else Weathers8
t7.title = "None"
t7.weatherIcon = ""
t7.description = ""

return {
    weathers = t6,
    noneWeatherInfo = t7
}
