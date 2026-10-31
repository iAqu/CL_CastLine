-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ContentProvider, ReplicatedFirst, ReplicatedStorage = services.ContentProvider, services.ReplicatedFirst, services.ReplicatedStorage
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local soundNames = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "components", "sound-component").soundNames
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local giantRigCutsceneConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "giant-rig-cutscene-config").giantRigCutsceneConfig
local t1 = {
    "rbxassetid://17063077953",
    "rbxassetid://16950679789",
    "rbxassetid://1215684307",
    "rbxassetid://15893708166",
    "rbxassetid://14431663347",
    "rbxassetid://16477162837",
    "rbxassetid://6763809313",
    "rbxassetid://17087151546"
}
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 18
        return "PreloadController"
    end
})

self.__index = self

function self.new(...) -- line: 23
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 27
    p1._soundController = p2
end

function self.onStart(p3) -- line: 30
    -- upvalues: ContentProvider (copy), ReplicatedFirst (copy), ReplicatedStorage (copy), animations (copy), soundNames (copy), clientProducer (copy), images (copy), giantRigCutsceneConfig (copy), t1 (copy)
    ReplicatedFirst:RemoveDefaultLoadingScreen()

    local t5 = {}

    for _, v3 in pairs(animations) do
        local Animation = Instance.new("Animation")

        Animation.AnimationId = v3
        table.insert(t5, Animation)
    end

    local t6 = {}

    for _, v4 in pairs(soundNames) do
        local function v5() -- line: 41
            -- upvalues: p3 (copy), v4 (copy)
            return p3._soundController:getSound(v4)
        end

        local ok, result = pcall(v5)

        if ok then
            table.insert(t6, result)
        else
            warn((("[PreloadController] Skipping missing sound \"%*\": %*"):format(v4, result)))
        end
    end

    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

    for _, v6 in { "sfx", "SFX" } do
        local v7 = if Sounds == nil then Sounds else Sounds:FindFirstChild(v6)

        if v7 then
            for _, descendant in v7:GetDescendants() do
                if descendant:IsA("Sound") then
                    table.insert(t6, descendant)
                end
            end
        end
    end

    local CastCutScene = ReplicatedStorage:FindFirstChild("CastCutScene")

    if CastCutScene then
        for _, v8 in { "NonPerfectSounds", "PerfectSounds" } do
            local v9 = CastCutScene:FindFirstChild(v8)

            if v9 then
                for _, child in v9:GetChildren() do
                    if child:IsA("StringValue") then
                        local Sound = Instance.new("Sound")

                        Sound.SoundId = child.Value
                        table.insert(t6, Sound)
                    end
                end
            end
        end
    end

    local v10 = ReplicatedStorage:FindFirstChild(giantRigCutsceneConfig.soundFolderName)

    if v10 ~= nil then
        for _, child in v10:GetChildren() do
            if child:IsA("StringValue") then
                local Sound = Instance.new("Sound")

                Sound.SoundId = child.Value
                table.insert(t6, Sound)
            end
        end
    end

    local t7 = {}

    for _, v11 in pairs(images) do
        table.insert(t7, v11)
    end

    local function v12() -- line: 100
        -- upvalues: t5 (copy), t6 (copy), t7 (copy), ContentProvider (copy), t1 (copy)
        local t8 = {}
        local v13 = #t8
        local v14 = #t5

        table.move(t5, 1, v14, v13 + 1, t8)

        local v15 = v13 + v14
        local v16 = #t6

        table.move(t6, 1, v16, v15 + 1, t8)

        local v17 = v15 + v16
        local v18 = #t7

        table.move(t7, 1, v18, v17 + 1, t8)

        local v19 = v17 + v18

        table.move(t1, 1, #t1, v19 + 1, t8)

        return ContentProvider:PreloadAsync(t8)
    end

    local ok, result = pcall(v12)

    if not ok then
        warn((("[PreloadController] Asset preload failed: %*"):format(result)))
    end

    clientProducer.windowClosed({})
end

Reflect.defineMetadata(self, "identifier", "client/controllers/preload-controller@PreloadController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    PreloadController = self
}
