-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "like-reward-button").default
local default2 = RuntimeLib.import(script, script.Parent, "claim-codes-button").default

return {
    default = function() -- RightSidebar | line: 6
        -- upvalues: react (copy), default (copy), default2 (copy)
        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(0.98, 0.5),
            Size = UDim2.fromScale(0.12, 1)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.05, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.fromScale(1, 0.1)
        }, react.createElement(default, {
            fillParent = true
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 3,
            Size = UDim2.fromScale(1, 0.1)
        }, react.createElement(default2, {
            fillParent = true
        })))
    end
}
