-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local UserInputService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").UserInputService
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectPlayerMounts = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerMounts
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local getMountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").getMountFishData
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local getToolbarMetrics = RuntimeLib.import(script, script.Parent, "toolbar-metrics").getToolbarMetrics
local mountsTabOpenRequestedAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "mount-backpack-tab-request-atom").mountsTabOpenRequestedAtom

return {
    default = function(p1) -- MountIcon | line: 38
        -- upvalues: react (copy), UserInputService (copy), default (copy), images (copy), functions (copy), useRootProducer (copy), useRootSelector (copy), selectPlayerMounts (copy), localPlayerUserId (copy), getMountFishData (copy), useScreenSizeState (copy), getToolbarMetrics (copy), mountsTabOpenRequestedAtom (copy)
        local v1 = useRootProducer()
        local v2 = useRootSelector(selectPlayerMounts(localPlayerUserId))
        local v3 = useScreenSizeState()
        local v4 = v3 == "sm" or v3 == "md"
        local v5 = getToolbarMetrics(v4)
        local toolbarHeight, toolbarWidth = v5.toolbarHeight, v5.toolbarWidth
        local v6 = if v2 == nil then v2 else v2.ownedMountNames

        if v6 == nil then
            v6 = {}
        end

        local v7 = #v6 > 0
        local v8 = if (if v2 == nil then v2 else v2.activeMountName) == nil then nil else getMountFishData(v2.activeMountName)

        if v2 ~= nil then
            v2 = v2.isMounted
        end

        if v2 == nil then
            v2 = false
        end

        local v9 = if not v7 then "Equip a Mount!" elseif UserInputService.TouchEnabled then "Tap to Mount" else "[M] Mount"

        local function v10() -- line: 73
            -- upvalues: v1 (copy), v7 (copy), functions (copy), mountsTabOpenRequestedAtom (copy)
            if not v7 then
                mountsTabOpenRequestedAtom(true)
                v1.windowOpened({
                    currentWindow = "backpack"
                })

                return nil
            end

            functions.toggleMount():catch(function(p2) -- line: 81
                warn("[src/client/react/screen/toolbar/mount-icon.tsx:77]", (("Toggle mount request failed: %*"):format(p2)))
            end)
        end

        local v11 = toolbarHeight * 1.5
        local v12 = 0.5 + toolbarWidth / 2 + 0.02

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            AnchorPoint = p1.anchorPoint or Vector2.new(0, 1),
            LayoutOrder = p1.layoutOrder,
            Position = p1.position or UDim2.fromScale(v12, 0.95),
            Size = p1.size or UDim2.fromScale(v11, v11)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            Event = {
                Activated = v10
            },
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(default, {
            backgroundTransparency = 0.6,
            cornerRadius = 1000,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = Color3.fromRGB(0, 0, 0),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.92, 0.92)
        }, v2 and react.createElement(default, {
            backgroundTransparency = 1,
            cornerRadius = 1000,
            anchorPoint = Vector2.new(0.5, 0.5),
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(1, 1)
        }, react.createElement("uistroke", {
            Thickness = 0.05,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(255, 255, 255),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })), react.createElement(default, {
            cornerRadius = 1000,
            zIndex = 1,
            anchorPoint = Vector2.new(0.5, 0.5),
            backgroundColor3 = if v7 then Color3.fromRGB(41, 41, 41) else Color3.fromRGB(15, 15, 15),
            backgroundTransparency = v7 and 0.6 or 0.2,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.9, 0.9)
        }, v7 and v8 ~= nil and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 5,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = v8.iconImageId,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.9, 0.9)
        }, react.createElement("uicorner", {
            CornerRadius = UDim.new(0, 1000)
        })), not v7 and react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 6,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Image = images.plusIcon,
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.5, 0.5)
        })))), v9 ~= nil and react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0),
            Font = Enum.Font.GothamBlack,
            Position = UDim2.new(0.5, 0, 0.9, 4),
            Size = UDim2.new(2.6, 0, 0, v4 and 12 or 16),
            Text = v9,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Center
        }, react.createElement("uistroke", {
            Thickness = 0.04,
            Color = Color3.new(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        })))
    end
}
