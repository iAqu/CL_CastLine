-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "qte-key-image").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local useQteConsoleKey = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-qte-console-key").useQteConsoleKey
local getActionLabel = RuntimeLib.import(script, script.Parent, "rare-fish-skillcheck.config").getActionLabel

return {
    default = function(p1) -- RareFishTargetCircle | line: 15
        -- upvalues: react (copy), default (copy), useIsUsingGamepad (copy), useQteConsoleKey (copy), getActionLabel (copy)
        local v1 = useQteConsoleKey(p1.onAttempt)
        local v2 = useIsUsingGamepad()

        return react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(p1.targetPos.x, p1.targetPos.y),
            Size = UDim2.fromOffset(p1.containerPad, p1.containerPad)
        }, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p1.ringSize
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = p1.approachRingColor,
            Thickness = p1.approachRingWidth
        })), react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = p1.glowColor,
            BackgroundTransparency = p1.glowTransparency,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = p1.glowSize
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), react.createElement("frame", {
            Active = false,
            BorderSizePixel = 0,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = p1.innerFillColor,
            BackgroundTransparency = p1.innerFillTransparency,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p1.size, p1.size)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        }), react.createElement("uistroke", {
            Color = p1.innerBorderColor,
            Thickness = p1.innerBorderWidth
        })), p1.showActionLabels and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.28),
            Size = UDim2.fromOffset(p1.size * 0.85, p1.size * 0.22),
            Text = getActionLabel(p1.actionType),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Thickness = 1.5,
            Color = Color3.fromRGB(0, 0, 0)
        })), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            ZIndex = 4,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.5, 0.56),
            Size = UDim2.fromOffset(p1.size * 0.5, p1.size * 0.5),
            Text = tostring(p1.circleNumber % 9 + 1),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, react.createElement("uistroke", {
            Thickness = 1.5,
            Color = Color3.fromRGB(0, 0, 0)
        })), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Event = {
                Activated = p1.onAttempt
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(p1.hitboxSize, p1.hitboxSize)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0.5, 0)
        })), v2 and react.createElement(default, {
            keyCode = v1,
            radius = p1.size / 2,
            size = p1.size * 0.4
        }))
    end
}
