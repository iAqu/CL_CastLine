-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "cyt-button").default
local getBorderThickness = RuntimeLib.import(script, script.Parent.Parent, "utils", "responsive-utils").getBorderThickness
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector, useRootSelectorCreator = reflex.useRootProducer, reflex.useRootSelector, reflex.useRootSelectorCreator
local selectEquippedInventoryItem = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedInventoryItem
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions

return {
    default = function(_) -- GiftConfirmationWindow | line: 18
        -- upvalues: react (copy), Players (copy), default (copy), default2 (copy), default3 (copy), getBorderThickness (copy), useScreenSizeState (copy), useRootProducer (copy), useRootSelector (copy), useRootSelectorCreator (copy), selectEquippedInventoryItem (copy), localPlayerUserId (copy), functions (copy)
        local v1 = useRootProducer()
        local v2 = useScreenSizeState()
        local v3 = useRootSelector(function(p2) -- line: 21
            return p2.giftUi.targetPlayerUserId
        end)
        local v4 = useRootSelectorCreator(selectEquippedInventoryItem, localPlayerUserId)
        local v5

        if v3 ~= nil then
            local v6 = tonumber(v3)

            if v6 == nil then
                v6 = -1
            end

            v5 = Players:GetPlayerByUserId(v6)
        end

        if v5 ~= nil then
            v5 = v5.DisplayName
        end

        if v5 == nil then
            v5 = "Unknown"
        end

        local v7 = if v4 == nil then v4 else v4.itemName

        if v7 == nil then
            v7 = "Unknown Item"
        end

        local function v8() -- line: 55
            -- upvalues: v1 (copy), v3 (copy), v4 (copy), functions (copy)
            if v3 == nil or v4 == nil then
                return nil
            end

            functions.requestGiftItem(v3, v4.itemId)
            v1.giftTargetCleared({})
            v1.windowClosed({})
        end

        local function v9() -- line: 63
            -- upvalues: v1 (copy)
            v1.giftTargetCleared({})
            v1.windowClosed({})
        end

        local v10 = ("Gift %*\nto %*?"):format(v7, v5)

        return react.createElement(default, {
            backgroundTransparency = 0.7,
            cornerRadius = 20,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "md"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.35, 0.35)
        }, react.createElement(default2, {
            hasStroke = true,
            overrideProps = {
                ZIndex = 2,
                AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.fromScale(0.5, 0.05),
                Size = UDim2.fromScale(0.9, 0.5)
            },
            strokeProps = {
                Thickness = getBorderThickness(v2, "md")
            },
            text = v10,
            textColor3 = Color3.fromRGB(255, 255, 255)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.92),
            Size = UDim2.fromScale(0.9, 0.35)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.05, 0),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(default3, {
            cornerRadius = 15,
            borderThickness = getBorderThickness(v2, "md"),
            onClick = v8,
            size = UDim2.fromScale(0.45, 0.9)
        }, react.createElement(default, {
            cornerRadius = 15,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(120, 230, 50),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "md"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 255, 120)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 230, 50)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 180, 30))
            })
        }), react.createElement(default2, {
            hasStroke = true,
            text = "Gift",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.6)
            },
            strokeProps = {
                Thickness = getBorderThickness(v2, "md")
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        }))), react.createElement(default3, {
            cornerRadius = 15,
            borderThickness = getBorderThickness(v2, "md"),
            onClick = v9,
            size = UDim2.fromScale(0.45, 0.9)
        }, react.createElement(default, {
            cornerRadius = 15,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(255, 80, 120),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "md"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uigradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 180)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 120)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 50, 90))
            })
        }), react.createElement(default2, {
            hasStroke = true,
            text = "Cancel",
            overrideProps = {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.6)
            },
            strokeProps = {
                Thickness = getBorderThickness(v2, "md")
            },
            textColor3 = Color3.fromRGB(255, 255, 255)
        })))))
    end
}
