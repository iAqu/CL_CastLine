-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local catchFadeAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "fishing-phase-atom").catchFadeAtom
local catchFadeDuration = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").catchFadeDuration

return {
    default = function() -- CatchFadeOverlay | line: 12
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), subscribe (copy), catchFadeAtom (copy), catchFadeDuration (copy)
        local idle, idle2 = useState("idle")
        local v1 = useRef(nil)
        local v2, v3 = useMotion(1)

        useEffect(function() -- line: 16
            -- upvalues: idle2 (copy), v1 (copy), subscribe (copy), catchFadeAtom (copy)
            return subscribe(catchFadeAtom, function(p1) -- line: 17
                -- upvalues: idle2 (copy), v1 (copy)
                if p1 == nil then
                    return nil
                end

                v1.current = p1.onBlack
                idle2("fadeIn")
            end)
        end, {})
        useEffect(function() -- line: 25
            -- upvalues: idle (copy), idle2 (copy), v1 (copy), v3 (copy), catchFadeAtom (copy), catchFadeDuration (copy)
            if idle == "fadeIn" then
                print("[CatchFade] phase=fadeIn — tweening to black")
                v3:set(1)
                v3:tween(0, {
                    time = catchFadeDuration,
                    style = Enum.EasingStyle.Linear
                })

                return (v3:onComplete(function() -- line: 33
                    -- upvalues: idle2 (copy), v1 (copy)
                    print("[CatchFade] screen fully black — calling onBlack")

                    local current = v1.current

                    if current ~= nil then
                        current()
                    end

                    v1.current = nil
                    idle2("fadeOut")
                end))
            end

            if idle ~= "fadeOut" then
                return
            end

            print("[CatchFade] phase=fadeOut — tweening back to clear")
            v3:tween(1, {
                time = catchFadeDuration,
                style = Enum.EasingStyle.Linear
            })

            return (v3:onComplete(function() -- line: 49
                -- upvalues: idle2 (copy), catchFadeAtom (copy)
                print("[CatchFade] fade-out complete")
                catchFadeAtom(nil)
                idle2("idle")
            end))
        end, { idle, v3 })

        if idle == "idle" then
            return nil
        end

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 1000,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = v2:map(function(p2) -- line: 62
                return p2
            end),
            Size = UDim2.fromScale(1, 1)
        })
    end
}
