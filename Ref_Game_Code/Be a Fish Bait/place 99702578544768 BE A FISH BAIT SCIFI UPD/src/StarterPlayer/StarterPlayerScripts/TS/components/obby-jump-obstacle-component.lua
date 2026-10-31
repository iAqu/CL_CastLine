-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component

local function parabolicJumpPoint(p1, p2, p3, p4) -- line: 10
    local v1 = 2 * (p4 - 0.5) * (p4 - 1)
    local v2 = -4 * p4 * (p4 - 1)
    local v3 = 2 * p4 * (p4 - 0.5)
    local v4 = p1 * v1
    local v5 = p2 * v2
    local v6 = p3 * v3

    return v4 + v5 + v6
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 25
        return "ObbyJumpObstacleComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 31
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p5, ...) -- line: 35
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p5, ...)
    p5._isActive = false
    p5._phaseElapsed = 0
    p5._isJumping = false
    p5._moverOrientation = CFrame.new()
end

function self.onStart(p6) -- line: 42
    if p6.attributes.obstacleType ~= "Jump" then
        return nil
    end

    p6._isActive = true
    p6._moverOrientation = p6.instance.Mover.CFrame.Rotation
    p6:_resetToStart()
end

function self.onTick(p7, p8) -- line: 51
    if not p7._isActive then
        return nil
    end

    p7._phaseElapsed += p8

    if p7._isJumping then
        local v10 = math.min(p7._phaseElapsed / p7.attributes.jumpDurationSeconds, 1)
        local WorldPosition = p7.instance.Start.WorldPosition
        local WorldPosition2 = p7.instance.Peak.WorldPosition
        local WorldPosition3 = p7.instance.End.WorldPosition
        local v11 = 2 * (v10 - 0.5) * (v10 - 1)
        local v12 = -4 * v10 * (v10 - 1)
        local v13 = 2 * v10 * (v10 - 0.5)
        local v14 = WorldPosition * v11
        local v15 = WorldPosition2 * v12
        local v16 = WorldPosition3 * v13
        local v17 = v14 + v15 + v16

        p7.instance.Mover:PivotTo(CFrame.new(v17) * p7._moverOrientation)

        if v10 >= 1 then
            p7._isJumping = false
            p7._phaseElapsed = 0
        end
    elseif p7._phaseElapsed >= p7.attributes.cooldownSeconds then
        p7:_resetToStart()
        p7._isJumping = true
        p7._phaseElapsed = 0
    end
end

function self._resetToStart(p9) -- line: 73
    p9.instance.Mover:PivotTo(CFrame.new(p9.instance.Start.WorldPosition) * p9._moverOrientation)
end

Reflect.defineMetadata(self, "identifier", "client/components/obby-jump-obstacle-component@ObbyJumpObstacleComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "ObbyObstacle",
        defaults = {
            cooldownSeconds = 1.5,
            jumpDurationSeconds = 1.5,
            obstacleType = "Jump"
        },
        attributes = {
            cooldownSeconds = t.number,
            jumpDurationSeconds = t.number,
            obstacleType = t.literal("Jump", "Rolling")
        },
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            Start = t.instanceIsA("Attachment"),
            Peak = t.instanceIsA("Attachment"),
            End = t.instanceIsA("Attachment"),
            Mover = t.instanceIsA("BasePart")
        }))
    }
})

return {
    ObbyJumpObstacleComponent = self
}
