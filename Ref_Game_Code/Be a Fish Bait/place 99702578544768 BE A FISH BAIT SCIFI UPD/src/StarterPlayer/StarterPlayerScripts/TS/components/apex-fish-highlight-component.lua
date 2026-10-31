-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "ApexFishHighlightComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, ...) -- line: 24
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1, ...)
end

function self.onStart(p2) -- line: 27
    p2._highlight = p2.instance:FindFirstChildOfClass("Highlight")
end

function self.onTick(p3) -- line: 30
    -- upvalues: Workspace (copy)
    local _highlight = p3._highlight

    if _highlight == nil then
        return nil
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil
    end

    _highlight.Enabled = (CurrentCamera.CFrame.Position - p3.instance:GetPivot().Position).Magnitude <= 200
end

Reflect.defineMetadata(self, "identifier", "client/components/apex-fish-highlight-component@ApexFishHighlightComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "ApexFishHighlight",
        attributes = {},
        instanceGuard = t.instanceIsA("Model")
    }
})

return {
    ApexFishHighlightComponent = self
}
