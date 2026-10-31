-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players, Workspace = services.CollectionService, services.Players, services.Workspace
local orientToFishingArea = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "character-utils").orientToFishingArea
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "shiny-overlay").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent, "context", "config-context").useConfig
local reflex = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex")
local useRootProducer, useRootSelector = reflex.useRootProducer, reflex.useRootSelector
local selectTutorialStep = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "tutorial.selectors").selectTutorialStep
local selectIsNearBase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "reflex", "slices", "selectors", "near-base-ui.selectors").selectIsNearBase
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "tutorial", "pointer").default
local tutorialSteps = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "tutorial-utils").tutorialSteps
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function TopbarButton(p1) -- line: 26
    -- upvalues: react (copy), default (copy), default2 (copy), default3 (copy), useTheme (copy)
    local colorSequence, imageId, label, layoutOrder = p1.colorSequence, p1.imageId, p1.label, p1.layoutOrder
    local onClick, size, strokeColor = p1.onClick, p1.size, p1.strokeColor
    local v1 = useTheme()

    return react.createElement(default, {
        cornerRadius = 0.05,
        isStudded = true,
        strokeThickness = 0.055,
        textureTransparency = 0.6,
        transparency = 0.3,
        zIndex = 1,
        backgroundColor = colorSequence,
        layoutOrder = layoutOrder,
        onClick = onClick,
        size = size or UDim2.fromScale(0.3, 0.9),
        strokeColor = strokeColor or Color3.new(0, 0, 0)
    }, react.createElement(default2, {
        zIndex = 2,
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1)
    }), imageId ~= nil and react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = imageId,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Stretch,
        Size = UDim2.fromScale(1, 1)
    }), react.createElement(default3, {
        shadowYScale = 0.1,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            ZIndex = 6,
            Size = UDim2.fromScale(0.85, 0.7),
            Font = v1.textFont2
        },
        position = UDim2.fromScale(0.5, 0.5),
        text = label
    }))
end

UDim2.fromScale(0.055, 0.07)

return {
    topbarRestY = 0.05,
    topbarOffscreenY = -0.15,
    topbarHeight = 0.08,
    topbarWidth = 0.62,
    topbarCenterY = 0.09,
    default = function(p2) -- TopbarFishing | line: 89
        -- upvalues: react (copy), useEffect (copy), useState (copy), useMotion (copy), CollectionService (copy), Players (copy), Workspace (copy), orientToFishingArea (copy), useTheme (copy), useConfig (copy), useRootProducer (copy), useRootSelector (copy), selectTutorialStep (copy), selectIsNearBase (copy), default4 (copy), tutorialSteps (copy), images (copy), TopbarButton (copy)
        local onBaseClick, onBuyClick, visible = p2.onBaseClick, p2.onBuyClick, p2.visible
        local v4 = visible

        if visible == nil then
            v4 = true
            visible = true
        end

        local colorSequences = useTheme().colorSequences
        local teleportToHome = useConfig().teleportToHome

        useRootProducer()

        local v5 = useRootSelector(selectTutorialStep)
        local v6 = useRootSelector(selectIsNearBase)
        local v8, v9 = useMotion(UDim2.fromScale(0.5, if visible then -0.15 else 0.05))

        useEffect(function() -- line: 104
            -- upvalues: v4 (ref), v9 (copy)
            v9:tween(UDim2.fromScale(0.5, if v4 then 0.05 else -0.15), {
                time = 0.3,
                style = Enum.EasingStyle.Back,
                direction = if v4 then Enum.EasingDirection.Out else Enum.EasingDirection.In
            })
        end, { v4, v9 })

        local function v11() -- line: 111
            -- upvalues: CollectionService (copy), Players (copy), orientToFishingArea (copy)
            local v12 = CollectionService:GetTagged("FishingArea")[1]

            if v12 == nil or not v12:IsA("Model") then
                return nil
            end

            local DetectableArea = v12:FindFirstChild("DetectableArea")

            if DetectableArea == nil or not DetectableArea:IsA("BasePart") then
                return nil
            end

            local Character = Players.LocalPlayer.Character

            if Character == nil then
                return nil
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                HumanoidRootPart.CFrame = CFrame.new(DetectableArea.Position)
                orientToFishingArea()
            end
        end

        local function v13() -- line: 131
            -- upvalues: onBaseClick (copy), teleportToHome (copy)
            if onBaseClick ~= nil then
                onBaseClick()

                return nil
            end

            teleportToHome()
        end

        local function v14() -- line: 138
            -- upvalues: onBuyClick (copy), CollectionService (copy), Players (copy), Workspace (copy)
            if onBuyClick ~= nil then
                onBuyClick()

                return nil
            end

            local v15 = CollectionService:GetTagged("ShopTeleport")[1]

            if v15 ~= nil and v15:IsA("Attachment") then
                local Character = Players.LocalPlayer.Character

                if Character ~= nil then
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                        local WorldPosition = v15.WorldPosition
                        local v16 = v15.WorldCFrame.LookVector * -1

                        HumanoidRootPart.CFrame = CFrame.new(WorldPosition, WorldPosition + v16)

                        local CurrentCamera = Workspace.CurrentCamera

                        if CurrentCamera ~= nil then
                            local v17 = WorldPosition - v16 * 16 + Vector3.new(0, 6, 0)

                            CurrentCamera.CFrame = CFrame.lookAt(v17, WorldPosition + v16)
                        end

                        return
                    end
                end
            end

            return nil
        end

        local v18 = v5 == tutorialSteps.addFishToAquarium and not v6
        local v19, v20 = useState(false)

        useEffect(function() -- line: 170
            -- upvalues: v20 (copy), v18 (copy)
            if v18 then
                local v21 = task.delay(2, function() -- line: 175
                    -- upvalues: v20 (copy)
                    return v20(true)
                end)

                return function() -- line: 178
                    -- upvalues: v21 (copy)
                    return task.cancel(v21)
                end
            end

            v20(false)

            return nil
        end, { v18 })

        local createElement, Fragment = react.createElement, react.Fragment
        local v22 = react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = v8,
            Size = UDim2.fromScale(0.62, 0.08)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement(TopbarButton, {
            label = "Aquarium",
            layoutOrder = 1,
            colorSequence = colorSequences.purpleGradient,
            onClick = v13,
            size = UDim2.fromScale(0.225, 0.9),
            strokeColor = Color3.new(0.44, 0.11, 0.92)
        }), react.createElement(TopbarButton, {
            label = "Fish!",
            layoutOrder = 2,
            colorSequence = colorSequences.lightBlue,
            imageId = images.fishBackground,
            onClick = v11,
            size = UDim2.fromScale(0.25, 1),
            strokeColor = Color3.fromRGB(46, 140, 255)
        }), react.createElement(TopbarButton, {
            label = "Buy",
            layoutOrder = 3,
            colorSequence = colorSequences.yellowGradient,
            onClick = v14,
            size = UDim2.fromScale(0.225, 0.9),
            strokeColor = Color3.fromRGB(250, 181, 46)
        }))

        v19 = v19 and react.createElement(react.Fragment, nil, react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 0),
            Size = v8:map(function(p3) -- line: 221
                return UDim2.new(1, 0, p3.Y.Scale - 0.005, 0)
            end)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = v8:map(function(p4) -- line: 230
                return UDim2.new(0, 0, p4.Y.Scale + 0.085, 0)
            end),
            Size = v8:map(function(p5) -- line: 233
                return UDim2.new(1, 0, 1 - (p5.Y.Scale + 0.085), 0)
            end)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = v8:map(function(p6) -- line: 242
                return UDim2.new(0, 0, p6.Y.Scale - 0.005, 0)
            end),
            Size = UDim2.fromScale(0.2475, 0.09)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0,
            ZIndex = 200,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = v8:map(function(p7) -- line: 252
                return UDim2.new(0.427, 0, p7.Y.Scale - 0.005, 0)
            end),
            Size = UDim2.fromScale(0.573, 0.09)
        }), react.createElement("frame", {
            Active = false,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 202,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = v8:map(function(p8) -- line: 262
                return UDim2.new(0.345, 0, p8.Y.Scale + 0.2, 0)
            end),
            Size = UDim2.fromScale(0.09, 0.12)
        }, react.createElement(default4, {
            direction = "up",
            zIndex = 202,
            size = UDim2.fromScale(1, 1)
        })))

        return createElement(Fragment, nil, v22, v19)
    end
}
