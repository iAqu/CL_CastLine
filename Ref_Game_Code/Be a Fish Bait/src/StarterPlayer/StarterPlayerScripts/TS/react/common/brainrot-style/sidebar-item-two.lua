-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSize
local getTextSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getTextSize
local default = RuntimeLib.import(script, script.Parent, "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent, "popout-text").default

return {
    default = function(p1) -- SidebarItem2 | line: 8
        -- upvalues: react (copy), useScreenSize (copy), getTextSize (copy), default (copy), default2 (copy)
        local v1 = useScreenSize()
        local zIndex = p1.zIndex

        if zIndex == nil then
            zIndex = 1
        end

        return react.createElement(default, {
            cornerRadius = 0.1,
            strokeThickness = 0.055,
            transparency = 0.4,
            backgroundColor = Color3.fromRGB(0, 0, 0),
            layoutOrder = p1.layoutOrder,
            size = p1.size or UDim2.fromScale(1, 1),
            strokeColor = Color3.fromRGB(30, 30, 30),
            zIndex = zIndex
        }, react.createElement("textbutton", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            Event = {
                Activated = p1.onClick
            },
            Size = UDim2.fromScale(1, 1),
            ZIndex = zIndex + 1
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.image,
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.65, 0.65),
            ZIndex = zIndex + 2
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))), react.createElement(default2, {
            color = Color3.fromRGB(255, 220, 50),
            overrideProps = {
                BackgroundTransparency = 1,
                TextScaled = false,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 1),
                Size = UDim2.fromScale(0.9, 0.22),
                TextSize = v1:map(function(p2) -- line: 49
                    -- upvalues: getTextSize (copy)
                    return getTextSize(p2, "sm")
                end),
                ZIndex = zIndex + 3
            },
            text = p1.text
        }))
    end
}
