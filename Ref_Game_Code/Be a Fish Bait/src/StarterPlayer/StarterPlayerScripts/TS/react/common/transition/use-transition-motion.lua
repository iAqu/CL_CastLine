-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useTransition = RuntimeLib.import(script, script.Parent, "transition").useTransition
local useTransitionMotionRaw = RuntimeLib.import(script, script.Parent, "use-transition-motion-raw").useTransitionMotionRaw

return {
    useTransitionMotion = function(p1, p2, p3) -- useTransitionMotion | line: 5
        -- upvalues: RuntimeLib (copy), useTransition (copy), useTransitionMotionRaw (copy)
        local v1 = p2
        local v2 = p2

        if p2 == nil then
            v2 = {
                motionType = "spring"
            }
            v1 = v2
        end

        local initialIsIn = useTransition().initialIsIn
        local v3 = v2.enableEnterTransition == nil or v2.enableEnterTransition
        local v4 = v2.enableExitTransition == nil or v2.enableExitTransition

        return useTransitionMotionRaw(if initialIsIn then p1.whenIn else p1.whenOut, {
            onEnter = function(p4) -- onEnter | line: 16
                -- upvalues: v1 (ref), p1 (copy), v3 (copy), RuntimeLib (copy)
                local whenIn = p1.whenIn

                if v3 then
                    local inDelay = v1.inDelay

                    if inDelay == nil then
                        inDelay = 0
                    end

                    local v6 = RuntimeLib.Promise.delay(inDelay):andThen(function() -- line: 23
                        -- upvalues: p4 (copy), whenIn (copy), v1 (ref)
                        if v1.motionType == "spring" then
                            p4:spring(whenIn, v1.springOptions)
                        elseif v1.motionType == "tween" then
                            p4:tween(whenIn, v1.tweenOptions)
                        elseif v1.motionType == "linear" then
                            p4:linear(whenIn, v1.linearOptions)
                        end
                    end)

                    return function() -- line: 32
                        -- upvalues: v6 (copy)
                        v6:cancel()
                    end
                end

                p4:immediate(whenIn)
            end,
            onExit = function(p5) -- onExit | line: 39
                -- upvalues: v1 (ref), p1 (copy), p3 (copy), v4 (copy), RuntimeLib (copy)
                local v7 = p3 or v1
                local whenOut = p1.whenOut

                if v4 then
                    local outDelay = v7.outDelay

                    if outDelay == nil then
                        outDelay = 0
                    end

                    local v8 = RuntimeLib.Promise.delay(outDelay):andThen(function() -- line: 47
                        -- upvalues: p5 (copy), whenOut (copy), v7 (copy)
                        if v7.motionType == "spring" then
                            p5:spring(whenOut, v7.springOptions)
                        elseif v7.motionType == "tween" then
                            p5:tween(whenOut, v7.tweenOptions)
                        elseif v7.motionType == "linear" then
                            p5:linear(whenOut, v7.linearOptions)
                        end
                    end)

                    return function() -- line: 56
                        -- upvalues: v8 (copy)
                        v8:cancel()
                    end
                end

                p5:immediate(whenOut)
            end
        })
    end
}
