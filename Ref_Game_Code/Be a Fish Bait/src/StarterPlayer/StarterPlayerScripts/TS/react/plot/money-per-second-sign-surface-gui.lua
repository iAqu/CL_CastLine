-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 150, 10))
})

return {
    default = function(p1) -- MoneyPerSecondSignSurfaceGui | line: 11
        -- upvalues: react (copy), createPortal (copy), abbreviate (copy), default (copy), default2 (copy), useTheme (copy), v1 (copy), v2 (copy)
        local adornPart, moneyPerSecond, signInstance = p1.adornPart, p1.moneyPerSecond, p1.signInstance
        local v3 = useTheme()

        return createPortal(react.createElement("surfacegui", {
            LightInfluence = 0,
            PixelsPerStud = 20,
            ResetOnSpawn = false,
            Adornee = adornPart,
            Face = Enum.NormalId.Left,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.05, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("uipadding", {
            PaddingBottom = UDim.new(0.01, 0),
            PaddingLeft = UDim.new(0.01, 0),
            PaddingRight = UDim.new(0.01, 0),
            PaddingTop = UDim.new(0.01, 0)
        }), react.createElement(default, {
            shadowYScale = 0.05,
            text = "TOTAL MONEY PER SECOND",
            color = v2,
            overrideProps = {
                LayoutOrder = 1,
                TextScaled = true,
                ZIndex = 5,
                Font = v3.textFont2,
                Size = UDim2.fromScale(1, 0.5),
                TextXAlignment = Enum.TextXAlignment.Center
            }
        }), react.createElement(default2, {
            overrideProps = {
                LayoutOrder = 2,
                TextScaled = true,
                Font = v3.textFont2,
                Size = UDim2.fromScale(1, 0.45),
                TextXAlignment = Enum.TextXAlignment.Center
            },
            strokeProps = {
                Thickness = 0.075
            },
            text = ("$%*/s"):format((abbreviate(moneyPerSecond))),
            textColor3 = v1
        }))), signInstance)
    end
}
