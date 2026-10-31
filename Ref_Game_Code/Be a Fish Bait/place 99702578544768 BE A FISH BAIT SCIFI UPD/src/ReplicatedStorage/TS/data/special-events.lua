-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local pinataBossFightDurationSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pinata-boss-utils").pinataBossFightDurationSeconds
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    "TicketRain",
    {
        cooldown = 600,
        description = "Tickets are raining on the dance floor — grab as many as you can!",
        duration = 60,
        feedbackMessage = "Ticket Rain has begun, find where it's raining!",
        hueCycleSeconds = 8,
        title = "Ticket Rain",
        lightingOverride = {
            brightness = 3,
            fogEnd = 1000,
            fogStart = 0,
            ambient = Color3.new(0.2745098, 0.2745098, 0.2745098),
            colorShiftBottom = Color3.new(0, 0, 0),
            colorShiftTop = Color3.new(0, 0, 0),
            fogColor = Color3.new(0.1803922, 0.6941177, 0.7529413),
            outdoorAmbient = Color3.new(0.5960785, 0.5960785, 0.5960785)
        },
        icon = images.ticketRainIcon
    }
}
local t2 = {
    cooldown = 300,
    description = "A giant pinata has appeared! Slap it before it disappears!",
    duration = pinataBossFightDurationSeconds,
    icon = images.pinataBossIcon
}
local Weathers = ReplicatedStorage:FindFirstChild("Weathers")

t2.skybox = if Weathers ~= nil then Weathers:FindFirstChild("PinataBashSkybox") else Weathers
t2.title = "Pinata Boss"

local t3 = {}

for _, v1 in {
        t1,
        { "PinataBoss", t2 }
    } do
    t3[v1[1]] = v1[2]
end

return {
    specialEvents = t3
}
