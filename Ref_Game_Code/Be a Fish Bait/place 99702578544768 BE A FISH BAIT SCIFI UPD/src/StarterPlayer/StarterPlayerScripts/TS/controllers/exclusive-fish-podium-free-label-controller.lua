-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 22
        return "ExclusiveFishPodiumFreeLabelController"
    end
})

self.__index = self

function self.new(...) -- line: 27
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 31
    p1._originalActionTexts = {}
end

function self.onStart(p2) -- line: 34
    -- upvalues: Players (copy), Workspace (copy)
    for _, descendant in Workspace:GetDescendants() do
        p2:_tryTrack(descendant)
    end

    Workspace.DescendantAdded:Connect(function(p3) -- line: 38
        -- upvalues: p2 (copy)
        return p2:_tryTrack(p3)
    end)
    Workspace.DescendantRemoving:Connect(function(p4) -- line: 41
        -- upvalues: p2 (copy)
        if p4:IsA("ProximityPrompt") then
            p2._originalActionTexts[p4] = nil
        end
    end)
    Players.LocalPlayer:GetAttributeChangedSignal("QaFreePurchaseModeEnabled"):Connect(function() -- line: 48
        -- upvalues: p2 (copy)
        return p2:_applyLabels()
    end)
end

function self._tryTrack(p5, p6) -- line: 52
    -- upvalues: Players (copy)
    if not p6:IsA("ProximityPrompt") or p6:GetAttribute("ExclusiveFishPromptConfigured") ~= true then
        return nil
    end

    p5._originalActionTexts[p6] = p6.ActionText

    if Players.LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true then
        p6.ActionText = "FREE"
    end
end

function self._applyLabels(p7) -- line: 67
    -- upvalues: Players (copy)
    local v3 = Players.LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true

    for v4, v5 in p7._originalActionTexts do
        if v3 then
            v4.ActionText = "FREE"
        else
            v4.ActionText = v5
        end
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/exclusive-fish-podium-free-label-controller@ExclusiveFishPodiumFreeLabelController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ExclusiveFishPodiumFreeLabelController = self
}
