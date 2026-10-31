-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local pinataBossLaunchingAtom = RuntimeLib.import(script, script.Parent.Parent, "pinata-boss-launching-atom").pinataBossLaunchingAtom
local selectPinataBossState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss.selectors").selectPinataBossState
local selectActiveSpecialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "active-special-event.selectors").selectActiveSpecialEvents
local selectPinataBossScheduleOverride = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "pinata-boss-schedule-override.selectors").selectPinataBossScheduleOverride
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pinata-nest-utils")
local getNextPinataBossSchedule, pinataWhirlpoolSpinWindowSeconds = v1.getNextPinataBossSchedule, v1.pinataWhirlpoolSpinWindowSeconds
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 23
        return "PinataNestComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 29
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 33
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1)
    p1._isWhirlpoolVisible = false
    p1._originalPartTransparency = p1.instance.whirlpool.Transparency
    p1._originalDecalTransparency = p1.instance.whirlpool.WhirlpoolDecal.Transparency
    p1:_setWhirlpoolVisible(false)
end

function self.onTick(p2, p3) -- line: 40
    -- upvalues: Workspace (copy), clientProducer (copy), pinataBossLaunchingAtom (copy), selectPinataBossState (copy), selectActiveSpecialEvents (copy), selectPinataBossScheduleOverride (copy), getNextPinataBossSchedule (copy), pinataWhirlpoolSpinWindowSeconds (copy)
    local v4 = selectPinataBossScheduleOverride(clientProducer:getState())
    local PinataBoss = selectActiveSpecialEvents(clientProducer:getState()).PinataBoss
    local v5 = getNextPinataBossSchedule(Workspace:GetServerTimeNow(), PinataBoss, v4)
    local isActive = selectPinataBossState(clientProducer:getState()).isActive
    local v6 = if v5.isLive then not isActive else v5.timeRemaining <= pinataWhirlpoolSpinWindowSeconds
    local v7 = pinataBossLaunchingAtom() or v6

    if v7 ~= p2._isWhirlpoolVisible then
        p2:_setWhirlpoolVisible(v7)
    end

    if not v7 then
        return nil
    end

    local Pivot = p2.instance.whirlpool:GetPivot()
    local v8 = Pivot - Pivot.Position
    local v10 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(360 * p3)))

    p2.instance.whirlpool:PivotTo(v10 * v8 + Pivot.Position)
end

function self._setWhirlpoolVisible(p4, p5) -- line: 71
    p4._isWhirlpoolVisible = p5

    local whirlpool = p4.instance.whirlpool

    if p5 then
        whirlpool.Transparency = p4._originalPartTransparency
    else
        whirlpool.Transparency = 1
    end

    local WhirlpoolDecal = p4.instance.whirlpool.WhirlpoolDecal

    if p5 then
        WhirlpoolDecal.Transparency = p4._originalDecalTransparency
    else
        WhirlpoolDecal.Transparency = 1
    end
end

Reflect.defineMetadata(self, "identifier", "client/components/pinata-nest-component@PinataNestComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "PinataNest",
        attributes = {},
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            whirlpool = t.intersection(t.instanceIsA("BasePart"), t.children({
                WhirlpoolDecal = t.instanceIsA("Decal")
            }))
        }))
    }
})

return {
    PinataNestComponent = self
}
