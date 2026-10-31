-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local RunService, Workspace = services.RunService, services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-gacha-equipment")
local getZoneGachaMachineItems, zoneGachaEquipmentData, zoneGachaMachineData, zoneGachaMachineOrder = v1.getZoneGachaMachineItems, v1.zoneGachaEquipmentData, v1.zoneGachaMachineData, v1.zoneGachaMachineOrder
local zoneTokenDisplayNames = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "zone-token-trader").zoneTokenDisplayNames
local default5 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "zone-token-balance-rows").default
local default6 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "transition", "transition").default
local FeedbackDisplay = RuntimeLib.import(script, script.Parent.Parent, "hud", "feedback-manager").FeedbackDisplay
local default7 = RuntimeLib.import(script, script.Parent, "zone-gacha-card").default
local default8 = RuntimeLib.import(script, script.Parent, "zone-gacha-tooltip").default

local function canAffordRoll(p1, p2) -- line: 27
    return p1 ~= nil and p2[p1.costTokenType] >= p1.costPerRoll
end

local v2 = Color3.fromRGB(55, 65, 90)
local v3 = Color3.fromRGB(80, 95, 130)

local function getCameraCFrameFromInstance(p3) -- line: 36
    return if (if p3 == nil then p3 else p3:IsA("Camera")) or (if p3 == nil then p3 else p3:IsA("BasePart")) then p3.CFrame else nil
end

local function getZoneGachaCameraCFrame() -- line: 57
    -- upvalues: Workspace (copy)
    local v4 = Workspace:FindFirstChild("ZoneGachaCamera", true)

    return if (if v4 == nil then v4 else v4:IsA("Camera")) or (if v4 == nil then v4 else v4:IsA("BasePart")) then v4.CFrame else nil
end

local function useZoneGachaCamera(p4) -- line: 64
    -- upvalues: useEffect (copy), RunService (copy), Workspace (copy)
    useEffect(function() -- line: 65
        -- upvalues: p4 (copy), RunService (copy), Workspace (copy)
        if not p4 then
            return nil
        end

        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera == nil then
            return nil
        end

        local CameraType, CameraSubject, CFrame, FieldOfView = CurrentCamera.CameraType, CurrentCamera.CameraSubject, CurrentCamera.CFrame, CurrentCamera.FieldOfView
        local v5 = Workspace:FindFirstChild("ZoneGachaCamera", true)
        local v6 = if v5 == nil then v5 else v5:IsA("Camera")
        local v7, v8

        if v6 then
            v8 = true
        else
            v7 = if v5 ~= nil then v5:IsA("BasePart") else v5
            v8 = false
        end

        local CFrame2 = if v8 or v7 then v5.CFrame else nil

        if CFrame2 ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CameraSubject = nil
            CurrentCamera.CFrame = CFrame2
        end

        local connection = RunService.RenderStepped:Connect(function() -- line: 86
            -- upvalues: CurrentCamera (copy), Workspace (copy)
            local v9 = Workspace:FindFirstChild("ZoneGachaCamera", true)
            local v10 = if v9 == nil then v9 else v9:IsA("Camera")
            local v11, v12

            if v10 then
                v12 = true
            else
                v11 = if v9 ~= nil then v9:IsA("BasePart") else v9
                v12 = false
            end

            local CFrame = if v12 or v11 then v9.CFrame else nil

            if CFrame == nil then
                return
            end

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CameraSubject = nil
            CurrentCamera.CFrame = CFrame
        end)

        return function() -- line: 92
            -- upvalues: CurrentCamera (copy), CameraType (copy), CameraSubject (copy), CFrame (copy), FieldOfView (copy), connection (copy)
            connection:Disconnect()
            CurrentCamera.CameraType = CameraType
            CurrentCamera.CameraSubject = CameraSubject
            CurrentCamera.CFrame = CFrame
            CurrentCamera.FieldOfView = FieldOfView
        end
    end, { p4 })
end

local function CloseXButton(p5) -- line: 101
    -- upvalues: react (copy), default2 (copy), default3 (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 140,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.975, 0.025),
        Size = UDim2.fromScale(0.055, 0.085)
    }, react.createElement(default2, {
        aspectRatio = 1,
        cornerRadius = 0.1,
        zIndex = 140,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 43, 43),
        onClick = p5.onClick,
        popoutColor = Color3.fromRGB(122, 31, 31),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(255, 179, 179)
    }, react.createElement(default3, {
        shadowYScale = 0.075,
        text = "X",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 144,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0.78, 0.78)
        },
        position = UDim2.fromScale(0.5, 0.5)
    })))
end

return {
    default = function(p6) -- ZoneGachaWindow | line: 134
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), RunService (copy), Workspace (copy), default (copy), default3 (copy), default4 (copy), useTheme (copy), getZoneGachaMachineItems (copy), zoneGachaEquipmentData (copy), zoneGachaMachineData (copy), zoneGachaMachineOrder (copy), zoneTokenDisplayNames (copy), default5 (copy), default6 (copy), FeedbackDisplay (copy), default7 (copy), default8 (copy), v2 (copy), v3 (copy), CloseXButton (copy)
        local v13 = useTheme()
        local v14, v15 = useState(zoneGachaMachineOrder[1])
        local v16, v17 = useState(nil)
        local v18, v19 = useState(nil)
        local v20, v21 = useState(false)
        local v22, v23 = useState(false)
        local v24 = useRef(false)
        local v25 = useRef()
        local v26 = p6.disableSceneCamera ~= true

        useEffect(function() -- line: 65
            -- upvalues: v26 (copy), RunService (copy), Workspace (copy)
            if not v26 then
                return nil
            end

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera == nil then
                return nil
            end

            local CameraType, CameraSubject, CFrame, FieldOfView = CurrentCamera.CameraType, CurrentCamera.CameraSubject, CurrentCamera.CFrame, CurrentCamera.FieldOfView
            local v27 = Workspace:FindFirstChild("ZoneGachaCamera", true)
            local v28 = if v27 == nil then v27 else v27:IsA("Camera")
            local v29, v30

            if v28 then
                v30 = true
            else
                v29 = if v27 ~= nil then v27:IsA("BasePart") else v27
                v30 = false
            end

            local CFrame2 = if v30 or v29 then v27.CFrame else nil

            if CFrame2 ~= nil then
                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.CameraSubject = nil
                CurrentCamera.CFrame = CFrame2
            end

            local connection = RunService.RenderStepped:Connect(function() -- line: 86
                -- upvalues: Workspace (copy), CurrentCamera (copy)
                local v31 = Workspace:FindFirstChild("ZoneGachaCamera", true)
                local v32 = if v31 == nil then v31 else v31:IsA("Camera")
                local v33, v34

                if v32 then
                    v34 = true
                else
                    v33 = if v31 ~= nil then v31:IsA("BasePart") else v31
                    v34 = false
                end

                local CFrame = if v34 or v33 then v31.CFrame else nil

                if CFrame == nil then
                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.CameraSubject = nil
                CurrentCamera.CFrame = CFrame
            end)

            return function() -- line: 92
                -- upvalues: CurrentCamera (copy), CameraType (copy), CameraSubject (copy), CFrame (copy), FieldOfView (copy), connection (copy)
                connection:Disconnect()
                CurrentCamera.CameraType = CameraType
                CurrentCamera.CameraSubject = CameraSubject
                CurrentCamera.CFrame = CFrame
                CurrentCamera.FieldOfView = FieldOfView
            end
        end, { v26 })

        local v35 = useRef(p6.tokenBalances)

        v35.current = p6.tokenBalances

        local v36, v37 = useState(nil)
        local v38, v39 = useState(false)
        local v40 = useRef(nil)

        useEffect(function() -- line: 151
            -- upvalues: v40 (copy)
            return function() -- line: 152
                -- upvalues: v40 (copy)
                if v40.current ~= nil then
                    task.cancel(v40.current)
                end
            end
        end, {})

        local function v41(p7, p8) -- line: 158
            -- upvalues: v37 (copy), v39 (copy), v40 (copy)
            if v40.current ~= nil then
                task.cancel(v40.current)
            end

            v37({
                message = p7,
                type = p8
            })
            v39(true)
            v40.current = task.delay(2, function() -- line: 167
                -- upvalues: v39 (copy), v40 (copy)
                v40.current = nil
                v39(false)
            end)
        end

        local v42 = zoneGachaMachineData[v14]
        local v43 = getZoneGachaMachineItems(v14)
        local v44 = if v16 == nil then nil else zoneGachaEquipmentData[v16]
        local v45 = RuntimeLib.async(function() -- line: 175
            -- upvalues: p6 (copy), v14 (copy), v41 (copy), v42 (copy), RuntimeLib (copy)
            if not v42 then
                return nil
            end

            local v46 = RuntimeLib.await(p6.onRoll(v14))

            if v46 ~= nil then
                v41(("Got: %*"):format(v46.displayName), "success")
            end
        end)
        local v47 = RuntimeLib.async(function() -- line: 184
            -- upvalues: v20 (copy), v21 (copy), v22 (copy), v35 (copy), v41 (copy), v42 (copy), v45 (copy), RuntimeLib (copy)
            if v20 or v22 then
                return nil
            end

            local current = v35.current

            if v42 == nil or not (current[v42.costTokenType] >= v42.costPerRoll) then
                v41("You do not have enough Tokens!", "error")

                return nil
            end

            v21(true)
            RuntimeLib.await(v45())
            v21(false)
        end)
        local v48 = RuntimeLib.async(function() -- line: 196
            -- upvalues: v20 (copy), v22 (copy), v23 (copy), v24 (copy), v35 (copy), v41 (copy), v42 (copy), v45 (copy), RuntimeLib (copy)
            if v20 then
                return nil
            end

            if v22 then
                v24.current = false
                v23(false)
            else
                local current = v35.current

                if v42 ~= nil and current[v42.costTokenType] >= v42.costPerRoll then
                    v24.current = true
                    v23(true)

                    while true do
                        if v24.current then
                            local current = v35.current

                            if v42 ~= nil and current[v42.costTokenType] >= v42.costPerRoll then
                                RuntimeLib.await(v45())

                                if v24.current then
                                    task.wait(0.35)
                                    continue
                                end
                            else
                                v41("You do not have enough Tokens!", "error")
                            end
                        end

                        break
                    end

                    v24.current = false
                    v23(false)

                    return
                end

                v41("You do not have enough Tokens!", "error")
            end

            return nil
        end)

        local function v49(p9) -- line: 225
            -- upvalues: v15 (copy), v17 (copy), v19 (copy), v23 (copy), v24 (copy)
            v24.current = false
            v23(false)
            v15(p9)
            v17(nil)
            v19(nil)
        end

        local function v50(p10, p11) -- line: 232
            -- upvalues: v17 (copy), v19 (copy), v25 (copy)
            local current = v25.current

            if current == nil then
                v17(p10)
                v19(nil)

                return nil
            end

            local AbsolutePosition, AbsoluteSize = current.AbsolutePosition, current.AbsoluteSize
            local AbsolutePosition2, AbsoluteSize2 = p11.AbsolutePosition, p11.AbsoluteSize
            local v51 = (AbsolutePosition2.X - AbsolutePosition.X) / AbsoluteSize.X
            local v52 = (AbsolutePosition2.Y + AbsoluteSize2.Y * 0.5 - AbsolutePosition.Y) / AbsoluteSize.Y

            v17(p10)
            v19(UDim2.new(v51, -8, v52, 0))
        end

        local function v53() -- line: 250
            -- upvalues: v17 (copy), v19 (copy)
            v17(nil)
            v19(nil)
        end

        local v54 = react.createElement(CloseXButton, {
            onClick = p6.onClose
        })
        local v55 = react.createElement(default3, {
            text = "Zone Gacha",
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.fromRGB(235, 235, 235),
            overrideProps = {
                TextScaled = true,
                ZIndex = 130,
                Font = v13.textFont2,
                Size = UDim2.fromScale(0.32, 0.055)
            },
            position = UDim2.fromScale(0.5, 0.03)
        })
        local v56 = react.createElement(default3, {
            text = "SELECT GACHA",
            color = Color3.new(1, 1, 1),
            overrideProps = {
                TextScaled = true,
                ZIndex = 124,
                Font = v13.textFont2,
                Position = UDim2.fromScale(0.06, 0.03),
                Size = UDim2.fromScale(0.85, 0.09),
                TextXAlignment = Enum.TextXAlignment.Left
            }
        })
        local v57 = table.create(#zoneGachaMachineOrder)

        local function v58(p12, p13) -- line: 283
            -- upvalues: v14 (copy), v49 (copy), react (copy), default4 (copy), zoneGachaMachineData (copy)
            local v59 = zoneGachaMachineData[p12]

            if not v59 then
                return nil
            end

            local v60 = p12 == v14
            local v61 = p13 * 0.2

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 125,
                Position = UDim2.fromScale(0, v61),
                Size = UDim2.fromScale(1, 0.16),
                key = p12
            }, react.createElement(default4, {
                zIndex = 126,
                anchorPoint = Vector2.new(0.5, 0.5),
                color = Color3.fromRGB(105, 232, 255),
                cornerRadius = v60 and 0.12 or 0.09,
                frameSize = UDim2.fromScale(1, v60 and 1 or 0.9),
                label = v59.displayName,
                onClick = function() -- onClick | line: 303
                    -- upvalues: p12 (copy), v49 (copy)
                    return v49(p12)
                end,
                popoutColor = if v60 then Color3.fromRGB(18, 18, 18) else Color3.fromRGB(45, 45, 45),
                position = UDim2.fromScale(0.5, 0.5)
            }))
        end

        for v62, v63 in zoneGachaMachineOrder do
            v57[v62] = v58(v63, v62 - 1, zoneGachaMachineOrder)
        end

        local v64 = react.createElement(default, {
            cornerRadius = 0.025,
            isStudded = true,
            strokeThickness = 0.005,
            textureTransparency = 0.4,
            transparency = 0.08,
            zIndex = 120,
            backgroundColor = v2,
            position = UDim2.fromScale(0.035, 0.15),
            size = UDim2.fromScale(0.24, 0.66),
            strokeColor = v3
        }, v56, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 125,
            Position = UDim2.fromScale(0.06, 0.17),
            Size = UDim2.fromScale(0.88, 0.8)
        }, v57))
        local v67 = react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 120,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.98),
            Size = UDim2.fromScale(0.36, 0.22)
        }, react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            TextStrokeTransparency = 0.2,
            ZIndex = 120,
            AnchorPoint = Vector2.new(0.5, 0),
            Font = Enum.Font.GothamBold,
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromScale(0.9, 0.2),
            Text = if v42 == nil then "Costs: 0" else ("Costs: %* %*"):format(v42.costPerRoll, zoneTokenDisplayNames[v42.costTokenType]),
            TextColor3 = Color3.fromRGB(220, 220, 230)
        }), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 120,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 0.5)
        }, react.createElement(default4, {
            zIndex = 121,
            anchorPoint = Vector2.new(1, 0.5),
            color = Color3.fromRGB(95, 255, 130),
            disabled = v22,
            frameSize = UDim2.fromScale(0.46, 1),
            label = v20 and "..." or "Roll",
            onClick = v47,
            popoutColor = Color3.fromRGB(22, 120, 52),
            position = UDim2.fromScale(0.48, 0.5)
        }), react.createElement(default4, {
            zIndex = 121,
            anchorPoint = Vector2.new(0, 0.5),
            color = if v22 then Color3.fromRGB(255, 100, 180) else Color3.fromRGB(255, 184, 41),
            disabled = v20,
            frameSize = UDim2.fromScale(0.46, 1),
            label = v22 and "Stop" or "Auto Roll",
            onClick = v48,
            popoutColor = if v22 then Color3.fromRGB(140, 20, 80) else Color3.fromRGB(160, 100, 0),
            position = UDim2.fromScale(0.52, 0.5)
        })))
        local v68 = react.createElement("uigridlayout", {
            FillDirectionMaxCells = 3,
            CellPadding = UDim2.fromScale(0.04, 0.04),
            CellSize = UDim2.fromScale(0.3, 0.4),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        local v69 = table.create(#v43)

        local function v70(p14, p15) -- line: 385
            -- upvalues: p6 (copy), v50 (copy), react (copy), default7 (copy)
            local t8 = {
                data = p14
            }
            local ownedItemIds = p6.ownedItemIds
            local id = p14.id

            t8.isOwned = table.find(ownedItemIds, id) ~= nil
            t8.key = p14.id
            t8.layoutOrder = p15

            t8.onClick = function(p16) -- line: 394
                -- upvalues: p14 (copy), v50 (copy)
                return v50(p14.id, p16)
            end

            return react.createElement(default7, t8)
        end

        for v71, v72 in v43 do
            v69[v71] = v70(v72, v71 - 1, v43)
        end

        local v74 = react.createElement(default, {
            cornerRadius = 0.025,
            isStudded = true,
            strokeThickness = 0.005,
            textureTransparency = 0.4,
            transparency = 0.08,
            zIndex = 120,
            backgroundColor = v2,
            position = UDim2.fromScale(0.725, 0.15),
            size = UDim2.fromScale(0.24, 0.66),
            strokeColor = v3
        }, react.createElement("scrollingframe", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ZIndex = 125,
            CanvasSize = UDim2.new(0, 0, math.ceil(#v43 / 3) * 0.42, 0),
            Position = UDim2.fromScale(0.06, 0.03),
            ScrollBarImageColor3 = Color3.fromRGB(97, 211, 232),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Size = UDim2.fromScale(0.88, 0.66)
        }, v68, v69), react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 125,
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.fromScale(0.5, 0.97),
            Size = UDim2.fromScale(0.88, 0.16)
        }, react.createElement(default4, {
            label = "Buy more tokens",
            zIndex = 126,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 184, 41),
            frameSize = UDim2.fromScale(0.9, 0.8),
            onClick = p6.onBuyMoreTokens,
            popoutColor = Color3.fromRGB(160, 100, 0),
            position = UDim2.fromScale(0.5, 0.5)
        })))
        local v75 = react.createElement(default5, {
            zIndex = 120,
            anchorPoint = Vector2.new(1, 1),
            position = UDim2.fromScale(0.965, 0.98),
            size = UDim2.fromScale(0.22, 0.14)
        })
        local v76 = v44 ~= nil

        if v76 then
            local v77 = react.createElement("imagebutton", {
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                ZIndex = 99,
                Event = {
                    Activated = v53
                },
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1)
            })
            local t11 = {
                anchorPoint = if v18 == nil then nil else Vector2.new(1, 0.5),
                data = v44,
                isEquippedAsBuff = p6.equippedBuffIdByCategory[v44.category] == v44.id,
                isEquippedAsSkin = p6.equippedSkinIdByCategory[v44.category] == v44.id
            }
            local ownedItemIds = p6.ownedItemIds
            local id = v44.id

            t11.isOwned = table.find(ownedItemIds, id) ~= nil

            t11.onEquipAsBuff = function() -- line: 467
                -- upvalues: p6 (copy), v44 (copy)
                return p6.onEquipAsBuff(v44.category, v44.id)
            end

            t11.onEquipAsSkin = function() -- line: 470
                -- upvalues: p6 (copy), v44 (copy)
                return p6.onEquipAsSkin(v44.category, v44.id)
            end

            t11.position = v18
            v76 = react.createElement(react.Fragment, nil, v77, react.createElement(default8, t11))
        end

        return react.createElement("screengui", {
            DisplayOrder = 1000,
            IgnoreGuiInset = true,
            ResetOnSpawn = false
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 100,
            Size = UDim2.fromScale(1, 1),
            ref = v25
        }, v54, v55, v64, v67, v74, v75, v76, v36 ~= nil and react.createElement(default6, {
            doEnterTransitionOnFirstMount = true,
            ["in"] = v38
        }, react.createElement(FeedbackDisplay, {
            count = 1,
            zIndex = 150,
            message = v36.message,
            position = UDim2.fromScale(0.5, 0.1),
            type = v36.type
        }))))
    end
}
