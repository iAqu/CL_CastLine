-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TopBarPlus = require(ReplicatedStorage.Packages.TopBarPlus)

return {
    Start = function() -- Start | line: 14
        -- upvalues: Players (copy), ReplicatedStorage (copy), TweenService (copy), UserInputService (copy), TopBarPlus (copy)
        local v1 = TopBarPlus.new()

        v1:setName("Settings"):setImage(101403250204482):modifyTheme({
            "IconImage",
            "ScaleType",
            Enum.ScaleType.Fit
        }):setImageScale(0.8)

        local function toggleUI() -- line: 21
            -- upvalues: ReplicatedStorage (copy)
            local Audio = require(ReplicatedStorage.Shared.Audio)
            local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
            local Tabs = require(ReplicatedStorage.Client.Tabs)

            Audio.Play(Constants.BUTTON_FX.BUTTON_MOUSE_DOWN_SOUND, script, {
                Volume = 1.8,
                PlaybackSpeed = math.random(95, 105) / 100
            })
            Tabs.Toggle("Settings")
        end

        v1:bindEvent("toggled", toggleUI)

        local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
        local GUI = require(ReplicatedStorage.Client.GUI)
        local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
        local Preferences = require(ReplicatedStorage.Shared.Preferences)
        local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
        local TreadmillVideoGate = require(ReplicatedStorage.Client.TreadmillVideoGate)
        local AudioSettingsController = require(ReplicatedStorage.Controllers.Game.AudioSettingsController)
        local v2 = UDim2.fromScale(0.75, 0.5)
        local v3 = UDim2.fromScale(0.25, 0.5)
        local v4 = ColorSequence.new(Color3.fromRGB(212, 255, 0), Color3.fromRGB(0, 255, 8))
        local v5 = ColorSequence.new(Color3.fromRGB(255, 58, 61), Color3.fromRGB(255, 2, 6))
        local v6 = TweenInfo.new(0.15, Enum.EasingStyle.Circular, Enum.EasingDirection.Out)

        local function updateIconEnabled() -- line: 72
            -- upvalues: v1 (copy), HiddenUIHandler (copy)
            v1:setEnabled(not HiddenUIHandler.IsHidden())
        end

        HiddenUIHandler.Changed:Connect(updateIconEnabled)
        v1:setEnabled(not HiddenUIHandler.IsHidden())

        local ScrollingFrame = GUI.Settings().Frame.ScrollingFrame

        assert(ScrollingFrame:IsA("ScrollingFrame"), "Settings scrolling frame must be a ScrollingFrame")

        local t2 = {}
        local t3 = {}
        local t4 = {}

        local function displayedState(p1, p2) -- line: 92
            -- upvalues: Preferences (copy)
            local v7 = Preferences.IsOn(p1)

            if p2 then
                return not v7
            end

            return v7
        end

        local function applyToggleVisuals(p3, p4, p5) -- line: 97
            -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), TweenService (copy)
            p3.Status.Text = p4 and "ON" or "OFF"

            local KnobGradient = p3.KnobGradient
            local v8

            if p4 then
                KnobGradient.Color = v4
                v8 = v2
            else
                KnobGradient.Color = v5
                v8 = v3
            end

            if p5 then
                p3.Knob.Position = v8
            else
                TweenService:Create(p3.Knob, v6, {
                    Position = v8
                }):Play()
            end
        end

        local function refreshToggle(p6) -- line: 108
            -- upvalues: Preferences (copy), t3 (copy), applyToggleVisuals (copy)
            local v9 = t3[p6]

            if not v9 then
                return
            end

            local Inverted = v9.Inverted
            local v10 = Preferences.IsOn(p6)

            if Inverted then
                v10 = not v10
            end

            applyToggleVisuals(v9, v10)
        end

        local function attemptToggle(p7) -- line: 115
            -- upvalues: Preferences (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy)
            if t2[p7] then
                return
            end

            t2[p7] = true

            local v11 = Preferences.Toggle(p7)

            t2[p7] = nil

            local v12, applyToggleVisuals2, v13

            if not v11 then
                v12 = t3[p7]

                if v12 then
                    applyToggleVisuals2 = applyToggleVisuals

                    local Inverted = v12.Inverted

                    v13 = Preferences.IsOn(p7)

                    if Inverted then
                        v13 = not v13
                    end

                    applyToggleVisuals2(v12, v13)
                end
            end
        end

        local function registerToggleRow(p8, p9) -- line: 129
            -- upvalues: ButtonFX (copy), Preferences (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), ScrollingFrame (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy)
            local v14 = ScrollingFrame:FindFirstChild(p8)

            if v14 and v14:IsA("GuiObject") then
                local ControlBar = v14:FindFirstChild("ControlBar")
                local Btn = if ControlBar then ControlBar:FindFirstChild("Btn") else nil
                local Description = v14:FindFirstChild("Description")

                if Btn and Btn:IsA("ImageButton") and Description and Description:IsA("TextLabel") then
                    local UIGradient = Btn:FindFirstChildOfClass("UIGradient")

                    if UIGradient then
                        local t5 = {
                            Row = v14,
                            Knob = Btn,
                            KnobGradient = UIGradient,
                            Status = Description,
                            Inverted = p9
                        }

                        t3[p8] = t5
                        ButtonFX(Btn, nil, function() -- line: 156
                            -- upvalues: p8 (copy), Preferences (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy)
                            if t2[p8] then
                                return
                            end

                            t2[p8] = true

                            local v15 = Preferences.Toggle(p8)

                            t2[p8] = nil

                            local v16, applyToggleVisuals2, v17

                            if not v15 then
                                v16 = t3[p8]

                                if v16 then
                                    applyToggleVisuals2 = applyToggleVisuals

                                    local Inverted = v16.Inverted

                                    v17 = Preferences.IsOn(p8)

                                    if Inverted then
                                        v17 = not v17
                                    end

                                    applyToggleVisuals2(v16, v17)
                                end
                            end
                        end)

                        local v18 = Preferences.IsOn(p8)

                        if p9 then
                            v18 = not v18
                        end

                        t5.Status.Text = v18 and "ON" or "OFF"

                        local KnobGradient = t5.KnobGradient
                        local v19

                        if v18 then
                            KnobGradient.Color = v4
                            v19 = v2
                        else
                            KnobGradient.Color = v5
                            v19 = v3
                        end

                        t5.Knob.Position = v19
                    end
                end
            end
        end

        local function applySliderVisuals(p10, p11) -- line: 160
            p10.Fill.Size = UDim2.new(p11, 0, 1, 0)
            p10.Fill.Position = UDim2.new(p11 / 2, 0, 0.5, 0)
            p10.Stick.Position = UDim2.new(p11, 0, 0.4887853, 0)
            p10.Handle.Position = p10.Stick.Position
        end

        local function settleSliderBoolean(p12, p13) -- line: 169
            -- upvalues: Preferences (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy)
            local v20 = p13 > 0

            if Preferences.IsOn(p12) == v20 or t2[p12] then
                return
            end

            t2[p12] = true

            local v21 = Preferences.Toggle(p12)

            t2[p12] = nil

            local v22, applyToggleVisuals2, v23

            if not v21 then
                v22 = t3[p12]

                if v22 then
                    applyToggleVisuals2 = applyToggleVisuals

                    local Inverted = v22.Inverted

                    v23 = Preferences.IsOn(p12)

                    if Inverted then
                        v23 = not v23
                    end

                    applyToggleVisuals2(v22, v23)
                end
            end
        end

        local function registerSliderRow(p14, p15) -- line: 176
            -- upvalues: Preferences (copy), AudioSettingsController (copy), ScrollingFrame (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy), applySliderVisuals (copy), UserInputService (copy)
            local v24 = ScrollingFrame:FindFirstChild(p14)

            if v24 and v24:IsA("GuiObject") then
                local ControlBar = v24:FindFirstChild("ControlBar")
                local Fill, Stick

                if ControlBar then
                    Fill = ControlBar:FindFirstChild("Fill")
                    Stick = ControlBar:FindFirstChild("Stick")
                end

                if ControlBar and ControlBar:IsA("GuiObject") and Fill and Fill:IsA("Frame") and Stick and Stick:IsA("Frame") then
                    local TextButton = Instance.new("TextButton")

                    TextButton.Name = "VolumeDragHandle"
                    TextButton.Text = ""
                    TextButton.BackgroundTransparency = 1
                    TextButton.AnchorPoint = Stick.AnchorPoint
                    TextButton.Size = Stick.Size
                    TextButton.ZIndex = Stick.ZIndex + 1
                    TextButton.Active = true
                    TextButton.Selectable = true
                    TextButton.Parent = ControlBar

                    local t6 = {
                        Row = v24,
                        Bar = ControlBar,
                        Fill = Fill,
                        Stick = Stick,
                        Handle = TextButton,
                        Category = p15
                    }
                    local v25 = false
                    local UIDragDetector = Instance.new("UIDragDetector")

                    UIDragDetector.Name = "VolumeDragDetector"
                    UIDragDetector.DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine
                    UIDragDetector.DragAxis = Vector2.new(1, 0)
                    UIDragDetector.ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale
                    UIDragDetector.BoundingUI = ControlBar
                    UIDragDetector.BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.HitPoint
                    UIDragDetector.SelectionModeDragSpeed = UDim2.fromScale(0.15, 0)
                    UIDragDetector.Parent = TextButton
                    UIDragDetector.DragStart:Connect(function() -- line: 226
                        -- upvalues: v25 (ref)
                        v25 = true
                    end)
                    TextButton:GetPropertyChangedSignal("Position"):Connect(function() -- line: 229
                        -- upvalues: p15 (copy), ControlBar (copy), TextButton (copy), t6 (copy), v25 (ref), AudioSettingsController (copy), applySliderVisuals (copy)
                        if not v25 then
                            return
                        end

                        local v27 = math.clamp(TextButton.Position.X.Scale + TextButton.Position.X.Offset / math.max(ControlBar.AbsoluteSize.X, 1), 0, 1)

                        applySliderVisuals(t6, v27)
                        AudioSettingsController.Set(p15, v27)
                    end)
                    UIDragDetector.DragEnd:Connect(function() -- line: 238
                        -- upvalues: p14 (copy), p15 (copy), v25 (ref), Preferences (copy), AudioSettingsController (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy)
                        v25 = false

                        local v28 = AudioSettingsController.Get(p15) > 0

                        if Preferences.IsOn(p14) == v28 or t2[p14] then
                            return
                        end

                        t2[p14] = true

                        local v29 = Preferences.Toggle(p14)

                        t2[p14] = nil

                        local v30, applyToggleVisuals2, v31

                        if not v29 then
                            v30 = t3[p14]

                            if v30 then
                                applyToggleVisuals2 = applyToggleVisuals

                                local Inverted = v30.Inverted

                                v31 = Preferences.IsOn(p14)

                                if Inverted then
                                    v31 = not v31
                                end

                                applyToggleVisuals2(v30, v31)
                            end
                        end
                    end)

                    local Frame = Instance.new("Frame")

                    Frame.Name = "VolumeTrackInput"
                    Frame.BackgroundTransparency = 1
                    Frame.Size = UDim2.fromScale(1, 1)
                    Frame.ZIndex = math.max(Fill.ZIndex, Stick.ZIndex) + 1
                    Frame.Active = true
                    Frame.Selectable = false
                    Frame.Parent = ControlBar
                    TextButton.ZIndex = Frame.ZIndex + 1

                    local v32
                    local v33 = Vector3.new(0, 0, 0)
                    local v34 = false

                    local function setFromPointer(p16) -- line: 259
                        -- upvalues: p15 (copy), ControlBar (copy), t6 (copy), AudioSettingsController (copy), applySliderVisuals (copy)
                        local v37 = math.clamp((p16.X - ControlBar.AbsolutePosition.X) / math.max(ControlBar.AbsoluteSize.X, 1), 0, 1)

                        applySliderVisuals(t6, v37)
                        AudioSettingsController.Set(p15, v37)
                    end

                    Frame.InputBegan:Connect(function(p17) -- line: 265
                        -- upvalues: p15 (copy), ControlBar (copy), t6 (copy), v25 (ref), v32 (ref), v33 (ref), v34 (ref), AudioSettingsController (copy), applySliderVisuals (copy)
                        if v32 or v25 or p17.UserInputType ~= Enum.UserInputType.MouseButton1 and p17.UserInputType ~= Enum.UserInputType.Touch then
                            return
                        end

                        v32 = p17
                        v33 = p17.Position
                        v34 = false

                        if p17.UserInputType ~= Enum.UserInputType.MouseButton1 then
                            return
                        end

                        local v40 = math.clamp((p17.Position.X - ControlBar.AbsolutePosition.X) / math.max(ControlBar.AbsoluteSize.X, 1), 0, 1)

                        applySliderVisuals(t6, v40)
                        AudioSettingsController.Set(p15, v40)
                    end)
                    UserInputService.InputChanged:Connect(function(p18) -- line: 277
                        -- upvalues: p15 (copy), ControlBar (copy), t6 (copy), v32 (ref), v33 (ref), v34 (ref), AudioSettingsController (copy), applySliderVisuals (copy)
                        local v41 = v32

                        if v41 then
                            if v41.UserInputType == Enum.UserInputType.MouseButton1 then
                                if p18.UserInputType == Enum.UserInputType.MouseMovement then
                                    local v44 = math.clamp((p18.Position.X - ControlBar.AbsolutePosition.X) / math.max(ControlBar.AbsoluteSize.X, 1), 0, 1)

                                    applySliderVisuals(t6, v44)
                                    AudioSettingsController.Set(p15, v44)
                                end
                            elseif p18 == v41 then
                                if not v34 then
                                    local v45 = p18.Position - v33

                                    if v45.Magnitude < 8 then
                                        return
                                    end

                                    if math.abs(v45.Y) >= math.abs(v45.X) then
                                        v32 = nil

                                        return
                                    end

                                    v34 = true
                                end

                                local v49 = math.clamp((p18.Position.X - ControlBar.AbsolutePosition.X) / math.max(ControlBar.AbsoluteSize.X, 1), 0, 1)

                                applySliderVisuals(t6, v49)
                                AudioSettingsController.Set(p15, v49)
                            end
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(p19) -- line: 298
                        -- upvalues: p14 (copy), p15 (copy), ControlBar (copy), t6 (copy), v32 (ref), Preferences (copy), AudioSettingsController (copy), t2 (copy), t3 (copy), applyToggleVisuals (copy), applySliderVisuals (copy)
                        if p19 ~= v32 then
                            return
                        end

                        v32 = nil

                        if p19.UserInputState ~= Enum.UserInputState.Cancel then
                            if p19.UserInputType == Enum.UserInputType.Touch then
                                local v52 = math.clamp((p19.Position.X - ControlBar.AbsolutePosition.X) / math.max(ControlBar.AbsoluteSize.X, 1), 0, 1)

                                applySliderVisuals(t6, v52)
                                AudioSettingsController.Set(p15, v52)
                            end

                            local v53 = AudioSettingsController.Get(p15) > 0

                            if Preferences.IsOn(p14) ~= v53 then
                                if t2[p14] then
                                    return
                                end

                                t2[p14] = true

                                local v54 = Preferences.Toggle(p14)

                                t2[p14] = nil

                                local v55, applyToggleVisuals2, v56

                                if not v54 then
                                    v55 = t3[p14]

                                    if v55 then
                                        applyToggleVisuals2 = applyToggleVisuals

                                        local Inverted = v55.Inverted

                                        v56 = Preferences.IsOn(p14)

                                        if Inverted then
                                            v56 = not v56
                                        end

                                        applyToggleVisuals2(v55, v56)
                                    end
                                end
                            end
                        end
                    end)
                    Preferences.Observe(p14, function(p20) -- line: 310
                        -- upvalues: p15 (copy), t6 (copy), v25 (ref), v32 (ref), AudioSettingsController (copy), applySliderVisuals (copy)
                        if not (v25 or v32) then
                            if p20 then
                                if AudioSettingsController.Get(p15) == 0 then
                                    AudioSettingsController.Set(p15, 1)
                                end

                                applySliderVisuals(t6, AudioSettingsController.Get(p15))
                            else
                                applySliderVisuals(t6, 0)
                            end
                        end
                    end)
                end
            end
        end

        local function applyCreatorSettingVisibility() -- line: 326
            -- upvalues: ScrollingFrame (copy), Players (copy), UserInputService (copy)
            local CreatorPanel = ScrollingFrame:FindFirstChild("CreatorPanel")

            if CreatorPanel and CreatorPanel:IsA("GuiObject") then
                if Players.LocalPlayer:GetAttribute("CreatorPanelAccess") == true then
                    CreatorPanel.Visible = not UserInputService.KeyboardEnabled
                else
                    CreatorPanel.Visible = false
                end
            end
        end

        local function applyVideoSettingVisibility() -- line: 336
            -- upvalues: TreadmillVideoGate (copy), ScrollingFrame (copy)
            local DisableVideos = ScrollingFrame:FindFirstChild("DisableVideos")

            if DisableVideos and DisableVideos:IsA("GuiObject") then
                DisableVideos.Visible = not TreadmillVideoGate.IsVideoPlayerDisabled()
            end
        end

        local function registerNavigationRow() -- line: 347
            -- upvalues: ButtonFX (copy), MenuNavigation (copy), ScrollingFrame (copy), UserInputService (copy)
            local MenuNavigation2 = ScrollingFrame:WaitForChild("MenuNavigation")
            local Buttons = MenuNavigation2:WaitForChild("Buttons")
            local Cursor = MenuNavigation2:WaitForChild("Cursor")

            local function refresh() -- line: 351
                -- upvalues: MenuNavigation2 (copy), Buttons (copy), Cursor (copy), MenuNavigation (copy), UserInputService (copy)
                MenuNavigation2.Visible = UserInputService.GamepadEnabled

                local v57 = MenuNavigation.PrefersCursor()

                for _, v58 in { Buttons, Cursor } do
                    local v59 = v58 == Cursor == v57

                    if v59 then
                        v58.BackgroundColor3 = Color3.fromRGB(112, 255, 24)
                    else
                        v58.BackgroundColor3 = Color3.fromRGB(68, 68, 86)
                    end

                    v58:FindFirstChild("Caption").Text = v58.Name .. (v59 and " (Selected)" or "")
                end
            end

            ButtonFX(Buttons, nil, function() -- line: 361
                -- upvalues: MenuNavigation (copy)
                MenuNavigation.SetPreference(false)
            end)
            ButtonFX(Cursor, nil, function() -- line: 362
                -- upvalues: MenuNavigation (copy)
                MenuNavigation.SetPreference(true)
            end)
            MenuNavigation.Changed:Connect(refresh)
            UserInputService.GamepadConnected:Connect(refresh)
            UserInputService.GamepadDisconnected:Connect(refresh)
            refresh()
        end

        function t4.Init() -- line: 369
            -- upvalues: Preferences (copy), TreadmillVideoGate (copy), ScrollingFrame (copy), t3 (copy), applyToggleVisuals (copy), registerToggleRow (copy), registerSliderRow (copy), applyCreatorSettingVisibility (copy), applyVideoSettingVisibility (copy), registerNavigationRow (copy), Players (copy), UserInputService (copy)
            registerNavigationRow()
            registerSliderRow("Music", "Music")
            registerSliderRow("SFX", "SFX")
            registerToggleRow("HideOtherPets", true)
            registerToggleRow("HideSelfPets", true)
            registerToggleRow("DisableVideos", true)
            registerToggleRow("CreatorPanel", false)

            for _, v60 in { "HideOtherPets", "HideSelfPets", "DisableVideos", "CreatorPanel" } do
                Preferences.Observe(v60, function() -- line: 380
                    -- upvalues: v60 (copy), Preferences (copy), t3 (copy), applyToggleVisuals (copy)
                    local v61 = t3[v60]

                    if not v61 then
                        return
                    end

                    local Inverted = v61.Inverted
                    local v62 = Preferences.IsOn(v60)

                    if Inverted then
                        v62 = not v62
                    end

                    applyToggleVisuals(v61, v62)
                end)
            end

            TreadmillVideoGate.Changed:Connect(applyVideoSettingVisibility)

            local DisableVideos = ScrollingFrame:FindFirstChild("DisableVideos")

            if DisableVideos and DisableVideos:IsA("GuiObject") then
                DisableVideos.Visible = not TreadmillVideoGate.IsVideoPlayerDisabled()
            end

            Players.LocalPlayer:GetAttributeChangedSignal("CreatorPanelAccess"):Connect(applyCreatorSettingVisibility)

            local CreatorPanel = ScrollingFrame:FindFirstChild("CreatorPanel")

            if CreatorPanel and CreatorPanel:IsA("GuiObject") then
                if Players.LocalPlayer:GetAttribute("CreatorPanelAccess") == true then
                    CreatorPanel.Visible = not UserInputService.KeyboardEnabled
                else
                    CreatorPanel.Visible = false
                end
            end
        end

        t4.Init()
    end
}
