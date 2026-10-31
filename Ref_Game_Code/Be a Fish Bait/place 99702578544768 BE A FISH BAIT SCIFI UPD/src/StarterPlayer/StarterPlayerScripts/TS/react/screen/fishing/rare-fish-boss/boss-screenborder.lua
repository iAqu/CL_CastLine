-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local bossScreenBorderAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "fishing-phase-atom").bossScreenBorderAtom

return {
    default = function() -- RareFishBossScreenBorder | line: 19
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), subscribe (copy), images (copy), bossScreenBorderAtom (copy)
        local v1, v2 = useState(Color3.fromRGB(255, 255, 255))
        local v3, v4 = useMotion(1)

        useEffect(function() -- line: 22
            -- upvalues: v2 (copy), v4 (copy), subscribe (copy), bossScreenBorderAtom (copy)
            return subscribe(bossScreenBorderAtom, function(p1) -- line: 23
                -- upvalues: v2 (copy), v4 (copy)
                if p1 == nil then
                    return nil
                end

                v2(p1.color)
                v4:set(0)
                v4:tween(1, {
                    time = 0.8,
                    direction = Enum.EasingDirection.Out,
                    style = Enum.EasingStyle.Quad
                })
            end)
        end, {})

        return react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 500,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.screenBorder,
            ImageColor3 = v1,
            ImageTransparency = v3,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        })
    end
}
