-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 8
        return "CustomAnimationController"
    end
})

self.__index = self

function self.new(...) -- line: 13
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 17
    p1._characterController = p2
end

function self.onStart(_) -- line: 20
end

self.playAnimation = RuntimeLib.async(function(p4, p5, p6) -- line: 22
    -- upvalues: RuntimeLib (copy)
    local _characterController = p4._characterController
    local v4 = if p6 == nil then p6 else p6.animationPriority

    if v4 == nil then
        v4 = Enum.AnimationPriority.Action
    end

    local v5 = if p6 == nil then p6 else p6.expectedAnimationDuration
    local v6 = if p6 == nil then p6 else p6.looped

    if v6 == nil then
        v6 = false
    end

    local v7 = RuntimeLib.await(_characterController:playAnimation(p5, v4, v5, v6))

    if v7 and (if p6 == nil then p6 else p6.pauseAtLastFrame) then
        local v8 = if p6 == nil then p6 else p6.expectedAnimationDuration
        local v9

        if v8 ~= nil then
            v9 = v8
        else
            local v10 = if v7 == nil then v7 else v7.Length

            v9 = if v10 ~= nil then v10 else 0
        end

        local v11 = false

        v7.Stopped:Once(function() -- line: 69
            -- upvalues: v11 (ref)
            v11 = true
        end)
        task.delay(v9 - 0.1, function() -- line: 72
            -- upvalues: p5 (copy), v7 (copy), v11 (ref)
            if v11 then
                return nil
            end

            v7:Play(0, 1, 0)
            v7.TimePosition = v7.Length - 0.01
            print("[src/client/controllers/custom-animation-controller.ts:42] `animationTrack stopped ${animationId} ${animationTrack} ${animationTrack.IsPlaying}` =", (("animationTrack stopped %* %* %*"):format(p5, v7, v7.IsPlaying)))
        end)
    end

    return v7
end)
self.playAnimationIfNotPlaying = RuntimeLib.async(function(p7, p8, p9) -- line: 85
    if p7._characterController:isAnimationPlaying(p8) then
        return nil
    end

    return p7:playAnimation(p8, p9)
end)

function self.stopAnimationsById(p10, p11) -- line: 91
    p10._characterController:stopAnimationsById(p11)
end

function self.stopAllAnimations(p12) -- line: 94
    p12._characterController:stopAllAnimations()
end

Reflect.defineMetadata(self, "identifier", "client/controllers/custom-animation-controller@CustomAnimationController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/character-controller@CharacterController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    CustomAnimationController = self
}
