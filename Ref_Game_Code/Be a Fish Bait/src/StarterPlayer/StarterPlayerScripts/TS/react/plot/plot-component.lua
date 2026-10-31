-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useAttribute = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-attribute").useAttribute
local useChild = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-child").useChild
local useRootSelectorCreator = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelectorCreator
local selectPlayerAquarium = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerAquarium
local moneyGradient = RuntimeLib.import(script, script.Parent.Parent, "screen", "hud", "stats-utils").moneyGradient
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local default2 = RuntimeLib.import(script, script.Parent, "aquarium-fish-manager").default
local default3 = RuntimeLib.import(script, script.Parent, "plot-interactable-area-renderer").default
local default4 = RuntimeLib.import(script, script.Parent, "plot-money-collection-area-renderer").default
local default5 = RuntimeLib.import(script, script.Parent, "aquarium-upgrade-sign-renderer").default
local default6 = RuntimeLib.import(script, script.Parent, "aquarium-money-per-second-sign-renderer").default
local default7 = RuntimeLib.import(script, script.Parent, "fish-hologram-renderer").default
local default8 = RuntimeLib.import(script, script.Parent, "showcase-fish-renderer").default
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getAquariumSkinModel = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums").getAquariumSkinModel

local function useAquariumTopAdornee(p1, p2) -- line: 27
    -- upvalues: useEffect (copy), useState (copy), getAquariumSkinModel (copy)
    local v1, v2 = useState(nil)

    useEffect(function() -- line: 29
        -- upvalues: p1 (copy), p2 (copy), v2 (copy), getAquariumSkinModel (copy)
        if p2 == nil then
            return nil
        end

        local Default = getAquariumSkinModel(p2, "Default")
        local BoundingBox, BoundingBox2 = Default:GetBoundingBox()
        local Pivot = Default:GetPivot()
        local WorldCFrame = p1.AquariumPos.WorldCFrame
        local WorldCFramePosition = WorldCFrame.Position
        local v3 = WorldCFramePosition + WorldCFrame.RightVector * (BoundingBox2.Z / 2)
        local v4 = BoundingBox.Position.Y - BoundingBox2.Y / 2
        local v5 = WorldCFramePosition.Y + (Pivot.Position.Y - v4)
        local v6 = WorldCFrame.Rotation * CFrame.Angles(0, -1.5707963267948966, 0)
        local v7 = CFrame.new(v3.X, v5, v3.Z) * v6 * Pivot:ToObjectSpace(BoundingBox)
        local Part = Instance.new("Part")

        Part.Name = "AquariumBillboardAnchor"
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Transparency = 1
        Part.Size = Vector3.new(1, 1, 1)

        local Position = v7.Position
        local v9 = Vector3.new(0, BoundingBox2.Y / 2, 0)

        Part.CFrame = CFrame.new(Position + v9)
        Part.Parent = p1
        v2(Part)

        return function() -- line: 63
            -- upvalues: Part (copy), v2 (copy)
            Part:Destroy()
            v2(nil)
        end
    end, { p2, p1 })

    return v1
end

local function PlotBillboardGui(p3) -- line: 70
    -- upvalues: react (copy), useEffect (copy), useState (copy), createPortal (copy), Players (copy), useChild (copy), useRootSelectorCreator (copy), selectPlayerAquarium (copy), moneyGradient (copy), abbreviate (copy), default (copy), localPlayerUserId (copy), images (copy), useAquariumTopAdornee (copy)
    local ownerUserId, plotInstance = p3.ownerUserId, p3.plotInstance
    local Attachment = useChild(plotInstance, "OwnerDetails", "Attachment")
    local v10, v11 = useState(nil)
    local v12, v13 = useState(nil)
    local v14 = useRootSelectorCreator(selectPlayerAquarium, (tostring(ownerUserId)))
    local v15 = if v14 == nil then v14 else v14.moneyPerSecond

    if v15 == nil then
        v15 = 0
    end

    if v14 ~= nil then
        v14 = v14.aquariumLevel
    end

    local v16 = useAquariumTopAdornee(plotInstance, v14)

    useEffect(function() -- line: 93
        -- upvalues: ownerUserId (copy), v11 (copy), v13 (copy), Players (copy)
        if ownerUserId > -10 and ownerUserId < 0 then
            v11(nil)
            v13((("Test Player %*"):format(ownerUserId)))

            return nil
        end

        if ownerUserId > 0 then
            local v17 = task.spawn(function() -- line: 102
                -- upvalues: ownerUserId (copy), v11 (copy), v13 (copy), Players (copy)
                local function v18() -- line: 104
                    -- upvalues: ownerUserId (copy), Players (copy)
                    return (Players:GetUserThumbnailAsync(ownerUserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100))
                end

                local ok, result = pcall(v18)

                if ok then
                    v11(result)
                end

                local function v19() -- line: 113
                    -- upvalues: ownerUserId (copy), Players (copy)
                    return Players:GetNameFromUserIdAsync(ownerUserId)
                end

                local ok2, result2 = pcall(v19)

                if ok2 then
                    v13(result2)
                end
            end)

            return function() -- line: 121
                -- upvalues: v17 (copy)
                task.cancel(v17)
            end
        end
    end, { ownerUserId })

    local v20 = tostring(ownerUserId) == localPlayerUserId
    local v21 = v16 or Attachment

    if Attachment and v21 then
        local v22 = v20 and v21 ~= nil and createPortal(react.createElement("billboardgui", {
            AlwaysOnTop = true,
            StudsOffsetWorldSpace = Vector3.new(0, 20, 0),
            Adornee = v21,
            Size = UDim2.fromScale(28, 28),
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            ZIndex = 10,
            Image = images.houseIcon,
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.fromScale(1, 1)
        }, react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1
        }))), plotInstance)
        local v23 = not v20

        if v23 then
            local v24 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 4),
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local v25 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local t1 = {
                BackgroundTransparency = 1
            }

            t1.Image = if v10 == nil then "" else v10
            t1.Size = UDim2.fromScale(0.4, 1)

            local v26 = react.createElement("imagelabel", t1, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            }), react.createElement("uicorner", {
                CornerRadius = UDim.new(0.5, 0)
            }))
            local v27 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                Padding = UDim.new(0, 2),
                VerticalAlignment = Enum.VerticalAlignment.Center
            })
            local t2 = {
                overrideProps = {
                    BackgroundTransparency = 1,
                    LayoutOrder = 0,
                    TextScaled = true,
                    Size = UDim2.fromScale(1, 0.5),
                    TextColor3 = Color3.new(1, 1, 1),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center
                }
            }

            if v12 == nil then
                v12 = ""
            end

            t2.text = v12
            v23 = createPortal(react.createElement("billboardgui", {
                AlwaysOnTop = false,
                StudsOffsetWorldSpace = Vector3.new(0, 11, 0),
                Adornee = v21,
                Size = UDim2.new(26, 0, 9, 0)
            }, react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, v24, react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, v25, v26, react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0.55, 1)
            }, v27, react.createElement(default, t2), react.createElement(default, {
                overrideProps = {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    TextScaled = true,
                    Size = UDim2.fromScale(1, 0.35),
                    TextColor3 = Color3.fromRGB(26, 255, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center
                },
                text = ("$%*/s"):format((abbreviate(v15)))
            }, react.createElement("uigradient", {
                Rotation = 90,
                Color = moneyGradient
            })))))), plotInstance)
        end

        return react.createElement(react.Fragment, nil, v22, v23)
    end

    return react.createElement(react.Fragment)
end

local function PlotWithValidOwner(p4) -- line: 228
    -- upvalues: react (copy), default2 (copy), default3 (copy), default4 (copy), default5 (copy), default6 (copy), default7 (copy), default8 (copy)
    local ownerUserId, plotInstance = p4.ownerUserId, p4.plotInstance

    return react.createElement(react.Fragment, nil, react.createElement(default2, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }), react.createElement(default3, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }), react.createElement(default4, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }), react.createElement(default5, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }), react.createElement(default6, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }), react.createElement(default7, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }), react.createElement(default8, {
        ownerUserId = ownerUserId,
        plotInstance = plotInstance
    }))
end

return {
    default = function(p5) -- PlotComponent | line: 255
        -- upvalues: react (copy), useAttribute (copy), PlotBillboardGui (copy), PlotWithValidOwner (copy)
        local plotInstance = p5.plotInstance
        local v29 = tonumber((useAttribute(plotInstance, "ownerUserId", "-10")))

        if v29 == nil then
            v29 = -10
        end

        if v29 <= -10 then
            return react.createElement(react.Fragment)
        end

        return react.createElement(react.Fragment, nil, react.createElement(PlotBillboardGui, {
            ownerUserId = v29,
            plotInstance = plotInstance
        }), react.createElement(PlotWithValidOwner, {
            ownerUserId = v29,
            plotInstance = plotInstance
        }))
    end
}
