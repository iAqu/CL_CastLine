-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local t1 = {
    MediumBlueSection = images.mediumBlueSection,
    LongBlueSection = images.longBlueSection,
    LongBlackSection = images.longBlackSection,
    LongBrownSection = images.longBrownSection,
    LongGreySection = images.longGreySection,
    LongOrangeSection = images.longOrangeSection,
    XLongRainbowSection = images.xLongRainbowSection,
    LongRainbowSection = images.longRainbowSection,
    LongRainbowSectionBright = images.longRainbowSectionBright,
    LongRedSection = images.longRedSection,
    LongYellowSection = images.longYellowSection,
    LongLightPurpleSection = images.longLightPurpleSection,
    MediumButLongGreenSection = images.mediumButLongGreenSection,
    MediumGreenSection = images.mediumGreenSection,
    MediumPinkSection = images.mediumPinkSection,
    MediumPurpleSection = images.mediumPurpleSection,
    MediumYellowSection = images.mediumYellowSection,
    SmallGreySection = images.smallGreySection,
    SmallYellowSection = images.smallYellowSection
}

return {
    default = function(p1) -- ExclusiveShopSection | line: 26
        -- upvalues: react (copy), t1 (copy)
        local t2 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        }
        local image = p1.image

        t2.Image = if image == nil then t1[p1.sectionType] else image
        t2.LayoutOrder = p1.layoutOrder
        t2.Position = UDim2.fromScale(0.5, 0.5)
        t2.ScaleType = Enum.ScaleType.Stretch
        t2.Size = p1.size or UDim2.fromScale(1, 1)

        local zIndex = p1.zIndex

        t2.ZIndex = if zIndex == nil then 1 else zIndex

        return react.createElement("imagelabel", t2, if p1.aspectRatio == nil then nil else react.createElement("uiaspectratioconstraint", {
            AspectRatio = p1.aspectRatio
        }), p1.contentNode)
    end
}
