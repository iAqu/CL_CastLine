-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local deluluRiftScreenFlashAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-screen-flash-atom").deluluRiftScreenFlashAtom
local deluluRiftBaitPauseAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "delulu-rift-bait-pause-atom").deluluRiftBaitPauseAtom

return {
    default = function() -- DeluluRiftScreenFlash | line: 15
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), subscribe (copy), deluluRiftScreenFlashAtom (copy), deluluRiftBaitPauseAtom (copy)
        local v1, v2 = useState(false)
        local v3, v4 = useMotion(0)
        local v5 = useRef({})

        useEffect(function() -- line: 19
            -- upvalues: v2 (copy), subscribe (copy), deluluRiftScreenFlashAtom (copy)
            local v6 = subscribe(deluluRiftScreenFlashAtom, function(p1) -- line: 20
                -- upvalues: v2 (copy)
                if p1 then
                    v2(true)
                end
            end)

            return function() -- line: 25
                -- upvalues: v6 (copy), deluluRiftScreenFlashAtom (copy)
                v6()
                deluluRiftScreenFlashAtom(false)
            end
        end, {})
        useEffect(function() -- line: 30
            -- upvalues: v1 (copy), v2 (copy), v4 (copy), v5 (copy), deluluRiftScreenFlashAtom (copy), deluluRiftBaitPauseAtom (copy)
            if not v1 then
                return nil
            end

            local current = v5.current

            v4:immediate(0)
            v4:tween(1, {
                time = 0.3,
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad
            })
            table.insert(current, (task.delay(0.3, function() -- line: 47
                -- upvalues: deluluRiftBaitPauseAtom (copy)
                deluluRiftBaitPauseAtom(true)
            end)))
            table.insert(current, (task.delay(0.7, function() -- line: 51
                -- upvalues: v4 (copy), deluluRiftBaitPauseAtom (copy)
                v4:tween(0, {
                    time = 1.5,
                    direction = Enum.EasingDirection.Out,
                    style = Enum.EasingStyle.Quad
                })
                deluluRiftBaitPauseAtom(false)
            end)))
            table.insert(current, (task.delay(2.2, function() -- line: 60
                -- upvalues: v2 (copy), deluluRiftScreenFlashAtom (copy)
                v2(false)
                deluluRiftScreenFlashAtom(false)
            end)))

            return function() -- line: 65
                -- upvalues: current (copy), v5 (copy), deluluRiftBaitPauseAtom (copy)
                for _, v10 in current do
                    task.cancel(v10)
                end

                v5.current = {}
                deluluRiftBaitPauseAtom(false)
            end
        end, { v1 })

        if not v1 then
            return nil
        end

        return react.createElement("frame", {
            BorderSizePixel = 0,
            ZIndex = 999,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = v3:map(function(p2) -- line: 78
                return 1 - p2
            end),
            Size = UDim2.fromScale(1, 1)
        })
    end
}
