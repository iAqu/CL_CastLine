-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useContext = react.useContext
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "cyt-button").default
local getBorderThickness = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "responsive-utils").getBorderThickness
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local ThemeContext = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "theme-context").ThemeContext
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectTrashModeSelectedItemIds = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "trash-mode.selectors").selectTrashModeSelectedItemIds
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local selectPlayerInventory = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerInventory
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId

return {
    default = function(_) -- ItemDeleteConfirmationWindow | line: 20
        -- upvalues: react (copy), useContext (copy), default (copy), default2 (copy), default3 (copy), getBorderThickness (copy), useScreenSizeState (copy), ThemeContext (copy), useRootProducer (copy), useRootSelector (copy), selectTrashModeSelectedItemIds (copy), functions (copy), selectPlayerInventory (copy), localPlayerUserId (copy)
        local v1 = useRootProducer()
        local v2 = useScreenSizeState()

        useContext(ThemeContext)

        local v3 = useRootSelector(selectTrashModeSelectedItemIds)
        local v4 = useRootSelector(selectPlayerInventory(localPlayerUserId))

        local function v5() -- line: 26
            -- upvalues: v3 (copy), v4 (copy)
            if not v4 or not (#v3 > 0) then
                return "backpack"
            end

            local v6 = true

            for _, v7 in v3 do
                local v8 = v4[v7]

                if not v8 or v8.itemType ~= "pickaxe" then
                    v6 = false
                    break
                end
            end

            if v6 then
                return "pickaxes"
            end

            return "backpack"
        end

        local function v9() -- line: 43
            -- upvalues: v1 (copy), v3 (copy), functions (copy)
            local t1 = {}

            for _, v10 in v3 do
                table.insert(t1, v10)
            end

            functions.deleteInventoryItems(t1)
            v1.trashingCompleted({})
            v1.windowClosed({})
        end

        local function v11() -- line: 53
            -- upvalues: v1 (copy), v5 (copy)
            local v12 = v5()

            v1.windowOpened({
                currentWindow = v12
            })
        end

        local v13 = if #v3 == 1 then "Delete 1\nitem?" else ("Delete %*\nitems?"):format(#v3)

        return react.createElement(default, {
            backgroundTransparency = 0.7,
            cornerRadius = 20,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            borderColor3 = Color3.fromRGB(0, 0, 0),
            borderThickness = getBorderThickness(v2, "md"),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.3, 0.35)
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
            text = v13,
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
            onClick = v9,
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
            text = "Yes",
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
            onClick = v11,
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
            text = "No",
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
