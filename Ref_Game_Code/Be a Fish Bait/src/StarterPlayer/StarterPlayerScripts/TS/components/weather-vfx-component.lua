-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "WeatherVFXComponent"
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
    -- upvalues: BaseComponent (copy), Maid (copy)
    BaseComponent.constructor(p1, ...)
    p1._weatherMaid = Maid.new()
end

function self.onStart(_) -- line: 28
end

function self.setWeather(p3, p4) -- line: 30
    -- upvalues: ReplicatedStorage (copy)
    p3._weatherMaid:DoCleaning()

    if p4 == "None" then
        return nil
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("WeatherVFX")

        if VFX ~= nil then
            VFX = VFX:FindFirstChild(p4)
        end
    end

    if not VFX then
        return nil
    end

    local VFXPart = p3.instance.VFXPart

    for _, child in VFX:GetChildren() do
        if child:IsA("ParticleEmitter") then
            local clone = child:Clone()

            clone.Parent = VFXPart
            p3._weatherMaid:GiveTask(clone)
        end
    end
end

function self.destroy(p5) -- line: 56
    -- upvalues: BaseComponent (copy)
    p5._weatherMaid:Destroy()
    BaseComponent.destroy(p5)
end

Reflect.defineMetadata(self, "identifier", "client/components/weather-vfx-component@WeatherVFXComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "WeatherVFX",
        attributes = {},
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            VFXPart = t.instanceIsA("BasePart")
        }))
    }
})

return {
    WeatherVFXComponent = self
}
