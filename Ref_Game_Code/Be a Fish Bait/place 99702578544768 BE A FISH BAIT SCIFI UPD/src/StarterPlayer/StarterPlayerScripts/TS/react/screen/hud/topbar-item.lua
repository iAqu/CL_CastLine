-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "radial-background").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "sun-burst-background").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getTextSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getTextSize
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- TopbarItem | line: 11
        -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), useScreenSizeState (copy), getTextSize (copy), images (copy)
        local v1 = useScreenSizeState()
        local t1 = {
            anchorPoint = Vector2.new(0.5, 0.5),
            imageColor3 = Color3.fromRGB(255, 255, 255),
            imageId = images.radialBackground2
        }
        local radialXScale = p1.radialXScale

        if radialXScale == nil then
            radialXScale = 0.5
        end

        t1.position = UDim2.fromScale(radialXScale, 0.5)

        local radialSizeScale = p1.radialSizeScale

        if radialSizeScale == nil then
            radialSizeScale = 1.2
        end

        local radialSizeScale2 = p1.radialSizeScale

        if radialSizeScale2 == nil then
            radialSizeScale2 = 1.2
        end

        t1.size = UDim2.fromScale(radialSizeScale, radialSizeScale2)
        t1.zIndex = 0

        local v2 = react.createElement(default2, t1)
        local v3 = p1.sunBurstSizeScale ~= nil or p1.sunBurstSizeScale ~= 0

        if v3 then
            local t2 = {
                doRotate = true,
                anchorPoint = Vector2.new(0.5, 0.5),
                imageColor3 = Color3.fromRGB(255, 255, 255)
            }
            local sunBurstXScale = p1.sunBurstXScale

            if sunBurstXScale == nil then
                sunBurstXScale = p1.imageXScale

                if sunBurstXScale == nil then
                    sunBurstXScale = 0.5
                end
            end

            t2.position = UDim2.fromScale(sunBurstXScale, 0.5)

            local sunBurstSizeScale = p1.sunBurstSizeScale

            if sunBurstSizeScale == nil then
                sunBurstSizeScale = 1.2
            end

            local sunBurstSizeScale2 = p1.sunBurstSizeScale

            if sunBurstSizeScale2 == nil then
                sunBurstSizeScale2 = 1.2
            end

            t2.size = UDim2.fromScale(sunBurstSizeScale, sunBurstSizeScale2)
            t2.zIndex = 0
            v3 = react.createElement(default3, t2)
        end

        local t3 = {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = p1.imageId
        }
        local imageXScale = p1.imageXScale

        if imageXScale == nil then
            imageXScale = 0.5
        end

        t3.Position = UDim2.fromScale(imageXScale, 0.5)

        local imageSizeScale = p1.imageSizeScale

        if imageSizeScale == nil then
            imageSizeScale = 1
        end

        local imageSizeScale2 = p1.imageSizeScale

        if imageSizeScale2 == nil then
            imageSizeScale2 = 1
        end

        t3.Size = UDim2.fromScale(imageSizeScale, imageSizeScale2)

        return react.createElement(default, {
            darkenOnHover = false,
            uiAspectRatio = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            onClick = p1.onClick,
            position = p1.position or UDim2.fromScale(0.5, 0.5),
            size = p1.size
        }, v2, v3, react.createElement("imagelabel", t3), react.createElement(default4, {
            overrideProps = {
                TextScaled = false,
                TextSize = getTextSize(v1, "sm"),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 1)
            },
            text = p1.title,
            textColor3 = Color3.fromRGB(255, 255, 255)
        }))
    end
}
