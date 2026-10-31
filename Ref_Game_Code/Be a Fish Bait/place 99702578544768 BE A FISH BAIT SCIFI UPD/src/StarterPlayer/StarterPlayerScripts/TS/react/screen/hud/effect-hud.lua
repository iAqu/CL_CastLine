-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local fishImages = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").fishImages
local selectPlayerEquippedTitle = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerEquippedTitle

return {
    default = function(p1) -- EffectHud | line: 13
        -- upvalues: react (copy), useEffect (copy), useState (copy), useRootSelector (copy), localPlayerUserId (copy), default (copy), fishImages (copy), selectPlayerEquippedTitle (copy)
        local layoutOrder = p1.layoutOrder

        if layoutOrder == nil then
            layoutOrder = 0
        end

        local v1 = useRootSelector(selectPlayerEquippedTitle(localPlayerUserId))
        local v2, v3 = useState(false)

        useEffect(function() -- line: 20
            -- upvalues: v2 (copy), v3 (copy)
            if not v2 then
                return nil
            end

            local v4 = task.delay(2.5, function() -- line: 24
                -- upvalues: v3 (copy)
                return v3(false)
            end)

            return function() -- line: 27
                -- upvalues: v4 (copy)
                return task.cancel(v4)
            end
        end, { v2 })

        if v1 ~= "icyFingers" then
            return nil
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            LayoutOrder = layoutOrder,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1,
            DominantAxis = Enum.DominantAxis.Height
        }), react.createElement("imagebutton", {
            BackgroundTransparency = 0.3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Event = {
                Activated = function() -- Activated | line: 48
                    -- upvalues: v2 (copy), v3 (copy)
                    if not v2 then
                        v3(true)
                    end
                end
            },
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("uicorner", {
            CornerRadius = UDim.new(0.15, 0)
        }), react.createElement("uistroke", {
            Thickness = 3,
            Transparency = 0.2,
            Color = Color3.fromRGB(0, 0, 0)
        }), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = fishImages.frostwyrm,
            ImageColor3 = Color3.fromRGB(5, 18, 28),
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        })), react.createElement(default, {
            text = "x1.25",
            overrideProps = {
                TextWrap = false,
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.7),
                Size = UDim2.fromScale(1.05, 0.6)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        })), v2 and react.createElement("frame", {
            BackgroundTransparency = 0.3,
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Position = UDim2.fromScale(0.5, 1.2),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.2
        }), react.createElement("uicorner", {
            CornerRadius = UDim.new(0.15, 0)
        }), react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0.2,
            Color = Color3.fromRGB(0, 0, 0)
        }), react.createElement(default, {
            text = "x1.25 Frostwyrm encounter luck",
            overrideProps = {
                TextWrap = true,
                TextScaled = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.9, 0.8)
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        })))
    end
}
