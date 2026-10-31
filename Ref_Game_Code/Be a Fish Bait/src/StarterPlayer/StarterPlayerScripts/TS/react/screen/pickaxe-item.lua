-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local getBorderThickness = RuntimeLib.import(script, script.Parent.Parent, "utils", "responsive-utils").getBorderThickness
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent, "context", "theme-context").ThemeContext
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local TouchEnabled = UserInputService.TouchEnabled

return {
    default = function(p1) -- PickaxeItem | line: 15
        -- upvalues: react (copy), useContext (copy), default (copy), default2 (copy), getBorderThickness (copy), useScreenSizeState (copy), ThemeContext (copy), images (copy), TouchEnabled (copy)
        local v1 = useScreenSizeState()
        local v2 = useContext(ThemeContext)

        return react.createElement(default, {
            cornerRadius = 5,
            darkenOnHover = false,
            uiAspectRatio = 1,
            colorSequence = ColorSequence.new(Color3.fromRGB(30, 30, 30)),
            onClick = p1.onClick or function() -- line: 22
            end,
            onMouseButton1Down = if TouchEnabled then p1.onShowStats else nil,
            onMouseButton1Up = if TouchEnabled then p1.onHideStats else nil,
            onMouseEnter = if TouchEnabled then nil else p1.onShowStats,
            onMouseLeave = if TouchEnabled then nil else p1.onHideStats,
            size = UDim2.fromScale(1, 1)
        }, react.createElement(default2, {
            backgroundTransparency = 0.6,
            cornerRadius = 5,
            zIndex = 0,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v1, "sm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.imageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(1.5, 1.5)
        }), p1.isSelectedForDeletion and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.trashIcon,
            ImageColor3 = Color3.fromRGB(255, 0, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 0.7)
        })), p1.equipped and react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromScale(0.4, 0.4)
        }, react.createElement(default2, {
            cornerRadius = 25,
            zIndex = 10,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColorSequence = v2.colorSequences.CYTDarkGreenGradient,
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v1, "xsm"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.tickIcon,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 0.7)
        }))))
    end
}
