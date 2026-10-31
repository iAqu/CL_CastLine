-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useRootProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootProducer
local default = RuntimeLib.import(script, script.Parent, "sidebar-item").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

return {
    default = function(p1) -- LikeRewardButton | line: 7
        -- upvalues: react (copy), useRootProducer (copy), default (copy), images (copy)
        local v1 = useRootProducer()
        local fillParent = p1.fillParent

        if fillParent == nil then
            fillParent = false
        end

        local v2, v3, v4

        if fillParent then
            v3 = Vector2.new(0.5, 0.5)
            v4 = UDim2.fromScale(0.5, 0.5)
            v2 = UDim2.fromScale(1, 1)
        else
            v3 = Vector2.new(1, 0.5)
            v4 = UDim2.fromScale(0.98, 0.5)
            v2 = UDim2.fromScale(0.12, 0.1)
        end

        local function v5() -- line: 17
            -- upvalues: v1 (copy)
            v1.windowToggled({
                currentWindow = "freeReward"
            })
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = v3,
            LayoutOrder = p1.layoutOrder,
            Position = v4,
            Size = v2
        }, react.createElement(default, {
            imageSizeScale = 1.5,
            richText = true,
            sunBurstSizeScale = 2,
            textSize = "sm",
            title = "<font color='#ab05ab'>OP RABBIT GEM</font>\n<font color='#00FF00'>FREE</font>",
            titleXPosition = 0.475,
            titleYScale = 0.95,
            imageId = images.rabbitGemIcon,
            onClick = v5,
            size = UDim2.fromScale(1, 1)
        }))
    end
}
