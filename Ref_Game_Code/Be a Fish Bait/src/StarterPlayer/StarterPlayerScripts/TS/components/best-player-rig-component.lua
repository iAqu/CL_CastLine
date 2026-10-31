-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 14
        return "BestPlayerRigComponent"
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
    p1._angle = 0
end

function self.onStart(_) -- line: 28
end

function self.onTick(p3, p4) -- line: 30
    local HumanoidRootPart = p3.instance.HumanoidRootPart
    local BestPlayerName = HumanoidRootPart.BestPlayerName

    if not HumanoidRootPart then
        return nil
    end

    p3._angle = (p3._angle - 1.0471975511965976 * p4) % 6.283185307179586

    local v3 = CFrame.Angles(0, p3._angle, 0)
    local attributes = p3.attributes
    local basePivotX, basePivotY, basePivotZ = attributes.basePivotX, attributes.basePivotY, attributes.basePivotZ
    local v4 = CFrame.new((Vector3.new(basePivotX, basePivotY, basePivotZ)))

    p3.instance:PivotTo(v4 * v3)

    local _CFrame = HumanoidRootPart.CFrame

    if math.abs(_CFrame.Position.Y - basePivotY) > 0.05 then
        HumanoidRootPart.CFrame = CFrame.fromMatrix(Vector3.new(_CFrame.Position.X, basePivotY, _CFrame.Position.Z), _CFrame.XVector, _CFrame.YVector, _CFrame.ZVector)
    end

    if BestPlayerName then
        BestPlayerName.StudsOffsetWorldSpace = Vector3.new(0, 20, 0)
    end
end

Reflect.defineMetadata(self, "identifier", "client/components/best-player-rig-component@BestPlayerRigComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "BestPlayerRig",
        defaults = {
            basePivotX = 0,
            basePivotY = 0,
            basePivotZ = 0
        },
        attributes = {
            basePivotX = t.number,
            basePivotY = t.number,
            basePivotZ = t.number
        },
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            Head = t.instanceIsA("BasePart"),
            HumanoidRootPart = t.intersection(t.instanceIsA("BasePart"), t.children({
                BestPlayerName = t.instanceIsA("BillboardGui")
            }))
        }))
    }
})

return {
    BestPlayerRigComponent = self
}
