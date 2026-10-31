-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSize
local usePulseAnimation = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-pulse-animation").usePulseAnimation
local default = RuntimeLib.import(script, script.Parent, "poison-treat-style", "tile-background").default
local default2 = RuntimeLib.import(script, script.Parent, "styled-text-label").default

return {
    default = function(p1) -- NotificationBubble | line: 9
        -- upvalues: react (copy), useScreenSize (copy), usePulseAnimation (copy), default (copy), default2 (copy)
        local v1 = useScreenSize()
        local v2 = v1:map(function(p2) -- line: 11
            if p2 == "sm" then
                return 2
            end

            if p2 == "md" then
                return 3
            end

            return 4
        end)

        v1:map(function(p3) -- line: 14
            if p3 == "sm" then
                return 12
            end

            if p3 == "md" then
                return 18
            end

            return 24
        end)

        local v3 = usePulseAnimation({
            interval = 5,
            peakScale = 1.2,
            peakDuration = 0.3,
            damping = 0.3
        })
        local t1 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = p1.position or UDim2.fromScale(1.1, -0.1),
            Size = p1.size or UDim2.fromScale(0.3, 0.3)
        }
        local zIndex = p1.zIndex

        t1.ZIndex = if zIndex == nil then 2 else zIndex

        local t2 = {
            anchorPoint = Vector2.new(0.5, 0.5),
            borderColor = Color3.fromRGB(0, 0, 0),
            color = Color3.new(1, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }
        local zIndex2 = p1.zIndex

        t2.zIndex = if zIndex2 == nil then 2 else zIndex2

        local v4 = react.createElement("uicorner", {
            CornerRadius = UDim.new(1, 0)
        })
        local v5 = react.createElement("uistroke", {
            Thickness = v2
        })
        local v6 = react.createElement("uiscale", {
            Scale = v3:map(function(p4) -- line: 54
                return p4
            end)
        })
        local t4 = {
            hasStroke = true
        }
        local t5 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }
        local zIndex3 = p1.zIndex

        t5.ZIndex = if zIndex3 == nil then 2 else zIndex3
        t4.overrideProps = t5
        t4.strokeProps = {
            Thickness = v2
        }

        local text = p1.text

        t4.text = if text == nil then "1" else text
        t4.textColor3 = Color3.new(1, 1, 1)

        return react.createElement("frame", t1, react.createElement(default, t2, v4, v5, v6, react.createElement(default2, t4)))
    end
}
