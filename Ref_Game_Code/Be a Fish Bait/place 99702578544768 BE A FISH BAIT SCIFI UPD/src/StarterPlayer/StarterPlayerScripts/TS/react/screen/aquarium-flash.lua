-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local aquariumFlashAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "aquarium-flash-atom").aquariumFlashAtom

return {
    default = function() -- AquariumFlash | line: 11
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), subscribe (copy), aquariumFlashAtom (copy)
        local v1, v2 = useState(false)
        local v3, v4 = useMotion(0)
        local v5 = useRef({})

        useEffect(function() -- line: 15
            -- upvalues: v2 (copy), subscribe (copy), aquariumFlashAtom (copy)
            return subscribe(aquariumFlashAtom, function(p1) -- line: 16
                -- upvalues: v2 (copy)
                if p1 then
                    v2(true)
                end
            end)
        end, {})
        useEffect(function() -- line: 22
            -- upvalues: v1 (copy), v2 (copy), v4 (copy), v5 (copy), aquariumFlashAtom (copy)
            if not v1 then
                return nil
            end

            local current = v5.current

            v4:set(1)
            v4:tween(0, {
                time = 1,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad
            })
            table.insert(current, (task.delay(1, function() -- line: 33
                -- upvalues: v2 (copy), aquariumFlashAtom (copy)
                v2(false)
                aquariumFlashAtom(false)
            end)))

            return function() -- line: 38
                -- upvalues: current (copy), v5 (copy)
                for _, v7 in current do
                    task.cancel(v7)
                end

                v5.current = {}
            end
        end, { v1 })

        if not v1 then
            return nil
        end

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 999,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = v3:map(function(p2) -- line: 50
                return 1 - p2
            end),
            Size = UDim2.fromScale(1, 1)
        })
    end
}
