-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local giantRigCutsceneConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "giant-rig-cutscene-config").giantRigCutsceneConfig
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 10
        return "CutsceneController"
    end
})

self.__index = self

function self.new(...) -- line: 15
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 19
    p1._soundController = p2
end

function self.onStart(p3) -- line: 22
    -- upvalues: ReplicatedStorage (copy), giantRigCutsceneConfig (copy)
    local CastCutScene = ReplicatedStorage:FindFirstChild("CastCutScene")

    if CastCutScene ~= nil then
        local t4 = {
            "NonPerfectSounds",
            "PerfectSounds"
        }
        local v3 = table.create(#t4)

        for v4, v5 in t4 do
            local _ = v4 - 1

            v3[v4] = CastCutScene:FindFirstChild(v5)
        end

        p3:_registerSoundFolders(v3)
    end

    p3:_registerSoundFolders({ ReplicatedStorage:FindFirstChild(giantRigCutsceneConfig.soundFolderName) })
end

function self._registerSoundFolders(p4, p5) -- line: 40
    for _, v6 in p5 do
        if v6 ~= nil then
            for _, child in v6:GetChildren() do
                if child:IsA("StringValue") then
                    p4._soundController:registerSound(child.Value)
                end
            end
        end
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/cutscene-controller@CutsceneController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    CutsceneController = self
}
