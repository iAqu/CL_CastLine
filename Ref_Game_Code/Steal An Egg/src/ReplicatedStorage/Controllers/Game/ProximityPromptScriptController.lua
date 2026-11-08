-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)

return {
    Start = function() -- Start | line: 14
        -- upvalues: Players (copy), ProximityPromptService (copy), RunService (copy), TextService (copy), TweenService (copy), UserInputService (copy), Workspace (copy), InputIconsConfig (copy)
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local v1 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local t2 = {
            prompt = nil,
            baseFov = nil,
            tween = nil
        }

        local function cleanupWildEggTween() -- line: 37
            -- upvalues: t2 (copy)
            if t2.tween then
                t2.tween:Cancel()
                t2.tween = nil
            end
        end

        local function isWildEggPrompt(p1) -- line: 44
            if typeof(p1:GetAttribute("Progress")) == "number" then
                local Parent = p1.Parent

                if Parent then
                    return Parent.Name == "WildAssetEgg"
                end
            end

            return false
        end

        local function applyWildEggZoom(p2, p3) -- line: 57
            -- upvalues: v1 (copy), t2 (copy), TweenService (copy), Workspace (copy)
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera then
                local v2 = math.clamp(p3, 0, 1)

                if v2 <= 0 then
                    if t2.prompt == p2 and t2.baseFov then
                        if t2.tween then
                            t2.tween:Cancel()
                            t2.tween = nil
                        end

                        t2.tween = TweenService:Create(CurrentCamera, v1, {
                            FieldOfView = t2.baseFov
                        })
                        assert(t2.tween, "luau")
                        t2.tween:Play()
                        t2.prompt = nil
                        t2.baseFov = nil
                    end
                else
                    if t2.prompt ~= p2 then
                        t2.prompt = p2
                        t2.baseFov = CurrentCamera.FieldOfView
                    end

                    local baseFov = t2.baseFov

                    if baseFov then
                        local v4 = baseFov + (math.max(40, baseFov - 30) - baseFov) * v2

                        if not (math.abs(CurrentCamera.FieldOfView - v4) < 0.001) then
                            if t2.tween then
                                t2.tween:Cancel()
                                t2.tween = nil
                            end

                            t2.tween = TweenService:Create(CurrentCamera, v1, {
                                FieldOfView = v4
                            })
                            assert(t2.tween, "luau")
                            t2.tween:Play()
                        end
                    end
                end
            end
        end

        local function gamepadButtonImage(p4) -- line: 104
            -- upvalues: InputIconsConfig (copy)
            return InputIconsConfig.Image(p4)
        end

        local t3 = {
            [Enum.KeyCode.Backspace] = "rbxasset://textures/ui/Controls/backspace.png",
            [Enum.KeyCode.Return] = "rbxasset://textures/ui/Controls/return.png",
            [Enum.KeyCode.LeftShift] = "rbxasset://textures/ui/Controls/shift.png",
            [Enum.KeyCode.RightShift] = "rbxasset://textures/ui/Controls/shift.png",
            [Enum.KeyCode.Tab] = "rbxasset://textures/ui/Controls/tab.png"
        }
        local t4 = {
            ["'"] = "rbxasset://textures/ui/Controls/apostrophe.png",
            [","] = "rbxasset://textures/ui/Controls/comma.png",
            ["`"] = "rbxasset://textures/ui/Controls/graveaccent.png",
            ["."] = "rbxasset://textures/ui/Controls/period.png",
            [" "] = "rbxasset://textures/ui/Controls/spacebar.png"
        }
        local t5 = {
            [Enum.KeyCode.LeftControl] = "Ctrl",
            [Enum.KeyCode.RightControl] = "Ctrl",
            [Enum.KeyCode.LeftAlt] = "Alt",
            [Enum.KeyCode.RightAlt] = "Alt",
            [Enum.KeyCode.F1] = "F1",
            [Enum.KeyCode.F2] = "F2",
            [Enum.KeyCode.F3] = "F3",
            [Enum.KeyCode.F4] = "F4",
            [Enum.KeyCode.F5] = "F5",
            [Enum.KeyCode.F6] = "F6",
            [Enum.KeyCode.F7] = "F7",
            [Enum.KeyCode.F8] = "F8",
            [Enum.KeyCode.F9] = "F9",
            [Enum.KeyCode.F10] = "F10",
            [Enum.KeyCode.F11] = "F11",
            [Enum.KeyCode.F12] = "F12"
        }

        local function getScreenGui() -- line: 143
            -- upvalues: PlayerGui (copy)
            local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")

            if ProximityPrompts == nil then
                ProximityPrompts = Instance.new("ScreenGui")
                ProximityPrompts.Name = "ProximityPrompts"
                ProximityPrompts.ResetOnSpawn = false
                ProximityPrompts.Parent = PlayerGui
            end

            return ProximityPrompts
        end

        local function setUpCircularProgressBar(p5) -- line: 154
            local UIGradient = p5.LeftGradient.ProgressBarImage.UIGradient
            local UIGradient2 = p5.RightGradient.ProgressBarImage.UIGradient

            p5.Progress.Changed:Connect(function(p6) -- line: 159
                -- upvalues: UIGradient (copy), UIGradient2 (copy)
                local v7 = math.clamp(p6 * 360, 0, 360)

                UIGradient.Rotation = math.clamp(v7, 180, 360)
                UIGradient2.Rotation = math.clamp(v7, 0, 180)
            end)
        end

        local function createPrompt(p7, p8, p9) -- line: 166
            -- upvalues: LocalPlayer (copy), v1 (copy), t2 (copy), applyWildEggZoom (copy), t3 (copy), t4 (copy), t5 (copy), RunService (copy), TextService (copy), TweenService (copy), UserInputService (copy), Workspace (copy), InputIconsConfig (copy)
            local t6 = {}
            local t7 = {}
            local t8 = {}
            local t9 = {}
            local v8 = TweenInfo.new(p7.HoldDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            local v9 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local v10 = TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local v11 = TweenInfo.new(0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
            local clone
            local PromptFrame = p7:GetAttribute("Theme")
            local clone2, InputFrame

            if PromptFrame then
                InputFrame = script:FindFirstChild(PromptFrame)

                if InputFrame then
                    clone2 = InputFrame:Clone()
                    clone = clone2
                end
            end

            if clone2 == nil then
                clone2 = script.Default:Clone()
                clone = clone2
            end

            clone2.Enabled = false
            PromptFrame = clone2.PromptFrame
            InputFrame = PromptFrame.InputFrame

            local ActionText, ObjectText, BackgroundTransparency, ImageTransparency = PromptFrame.ActionText, PromptFrame.ObjectText, PromptFrame.BackgroundTransparency, PromptFrame.ImageTransparency

            PromptFrame.BackgroundTransparency = 1
            PromptFrame.ImageTransparency = 1
            table.insert(t6, TweenService:Create(PromptFrame, v9, {
                BackgroundTransparency = 1,
                ImageTransparency = 1,
                Size = UDim2.fromScale(0.5, 1)
            }))
            table.insert(t7, TweenService:Create(PromptFrame, v9, {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = BackgroundTransparency,
                ImageTransparency = ImageTransparency
            }))
            table.insert(t8, TweenService:Create(PromptFrame, v9, {
                BackgroundTransparency = 1,
                ImageTransparency = 1,
                Size = UDim2.fromScale(0.5, 1)
            }))

            local v12 = {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = BackgroundTransparency,
                ImageTransparency = ImageTransparency
            }

            table.insert(t9, TweenService:Create(PromptFrame, v9, v12))

            local function setupUIStrokeTweens(p10) -- line: 238
                -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), v9 (copy), TweenService (copy)
                local Transparency = p10.Transparency

                p10.Transparency = 1
                table.insert(t6, TweenService:Create(p10, v9, {
                    Transparency = 1
                }))
                table.insert(t7, TweenService:Create(p10, v9, {
                    Transparency = Transparency
                }))
                table.insert(t8, TweenService:Create(p10, v9, {
                    Transparency = 1
                }))
                table.insert(t9, TweenService:Create(p10, v9, {
                    Transparency = Transparency
                }))
            end

            local function setupGUIObjectTweens(p11) -- line: 259
                -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), v9 (copy), TweenService (copy)
                local BackgroundTransparency = p11.BackgroundTransparency

                p11.BackgroundTransparency = 1
                table.insert(t6, TweenService:Create(p11, v9, {
                    BackgroundTransparency = 1
                }))
                table.insert(t7, TweenService:Create(p11, v9, {
                    BackgroundTransparency = BackgroundTransparency
                }))
                table.insert(t8, TweenService:Create(p11, v9, {
                    BackgroundTransparency = 1
                }))
                table.insert(t9, TweenService:Create(p11, v9, {
                    BackgroundTransparency = BackgroundTransparency
                }))
            end

            local function setupTextLabelTweens(p12) -- line: 288
                -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), v9 (copy), TweenService (copy)
                local TextTransparency, TextStrokeTransparency = p12.TextTransparency, p12.TextStrokeTransparency

                p12.TextTransparency = 1
                p12.TextStrokeTransparency = 1
                table.insert(t6, TweenService:Create(p12, v9, {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1
                }))
                table.insert(t7, TweenService:Create(p12, v9, {
                    TextTransparency = TextTransparency,
                    TextStrokeTransparency = TextStrokeTransparency
                }))
                table.insert(t8, TweenService:Create(p12, v9, {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1
                }))
                table.insert(t9, TweenService:Create(p12, v9, {
                    TextTransparency = TextTransparency,
                    TextStrokeTransparency = TextStrokeTransparency
                }))
            end

            local function setupImageLabelTweens(p13) -- line: 327
                -- upvalues: t6 (copy), t7 (copy), t8 (copy), t9 (copy), v9 (copy), TweenService (copy)
                local ImageTransparency = p13.ImageTransparency

                p13.ImageTransparency = 1
                table.insert(t6, TweenService:Create(p13, v9, {
                    ImageTransparency = 1
                }))
                table.insert(t7, TweenService:Create(p13, v9, {
                    ImageTransparency = ImageTransparency
                }))
                table.insert(t8, TweenService:Create(p13, v9, {
                    ImageTransparency = 1
                }))
                table.insert(t9, TweenService:Create(p13, v9, {
                    ImageTransparency = ImageTransparency
                }))
            end

            local function setupUnexpectedChildTweens(p14) -- line: 348
                -- upvalues: setupUIStrokeTweens (copy), setupGUIObjectTweens (copy), setupTextLabelTweens (copy), setupImageLabelTweens (copy), setupUnexpectedChildTweens (copy)
                if p14:IsA("UIStroke") then
                    setupUIStrokeTweens(p14)
                elseif not p14:IsA("UIGradient") and p14:IsA("GuiObject") then
                    setupGUIObjectTweens(p14)

                    if p14:IsA("TextLabel") then
                        setupTextLabelTweens(p14)
                    elseif p14:IsA("ImageLabel") then
                        setupImageLabelTweens(p14)
                    end
                end

                for _, child in pairs(p14:GetChildren()) do
                    setupUnexpectedChildTweens(child)
                end
            end

            local Frame = {
                [InputFrame] = false,
                [ActionText] = true,
                [ObjectText] = true
            }

            for _, child in pairs(PromptFrame:GetChildren()) do
                if Frame[child] ~= nil then
                    if Frame[child] == true then
                        for _, child in pairs(child:GetChildren()) do
                            setupUnexpectedChildTweens(child)
                        end
                    end
                else
                    setupUnexpectedChildTweens(child)
                end
            end

            Frame = InputFrame.Frame
            InputFrame = Frame.UIScale
            PromptFrame = if p8 == Enum.ProximityPromptInputType.Touch then 1.6 else 1.33
            table.insert(t6, TweenService:Create(InputFrame, v9, {
                Scale = PromptFrame
            }))
            table.insert(t7, TweenService:Create(InputFrame, v9, {
                Scale = 1
            }))
            setupTextLabelTweens(ActionText)
            setupTextLabelTweens(ObjectText)

            local ButtonFrame = Frame.ButtonFrame

            local function setupButtonFrameTweens() -- line: 401
                -- upvalues: t8 (copy), t9 (copy), v10 (copy), ButtonFrame (copy), TweenService (copy)
                local BackgroundTransparency, ImageTransparency = ButtonFrame.BackgroundTransparency, ButtonFrame.ImageTransparency

                table.insert(t8, TweenService:Create(ButtonFrame, v10, {
                    BackgroundTransparency = 1,
                    ImageTransparency = 1
                }))
                table.insert(t9, TweenService:Create(ButtonFrame, v10, {
                    BackgroundTransparency = BackgroundTransparency,
                    ImageTransparency = ImageTransparency
                }))

                for _, v13 in pairs(ButtonFrame:getChildren()) do
                    if v13:IsA("UIStroke") then
                        local Transparency = v13.Transparency

                        table.insert(t8, TweenService:Create(v13, v10, {
                            Transparency = 1
                        }))
                        table.insert(t9, TweenService:Create(v13, v10, {
                            Transparency = Transparency
                        }))
                    end
                end
            end

            setupButtonFrameTweens()

            local ButtonImage, ButtonText, ButtonTextImage = Frame.ButtonImage, Frame.ButtonText, Frame.ButtonTextImage

            local function setupButtonTextTweens() -- line: 442
                -- upvalues: t8 (copy), t9 (copy), v10 (copy), ButtonText (copy), TweenService (copy)
                local TextTransparency, TextStrokeTransparency, BackgroundTransparency = ButtonText.TextTransparency, ButtonText.TextStrokeTransparency, ButtonText.BackgroundTransparency

                ButtonText.BackgroundTransparency = 1
                ButtonText.TextStrokeTransparency = 1
                ButtonText.TextTransparency = 1
                table.insert(t8, TweenService:Create(ButtonText, v10, {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1,
                    BackgroundTransparency = 1
                }))
                table.insert(t9, TweenService:Create(ButtonText, v10, {
                    TextTransparency = TextTransparency,
                    TextStrokeTransparency = TextStrokeTransparency,
                    BackgroundTransparency = BackgroundTransparency
                }))

                for _, v14 in pairs(ButtonText:getChildren()) do
                    if v14:IsA("UIStroke") then
                        local Transparency = v14.Transparency

                        table.insert(t8, TweenService:Create(v14, v10, {
                            Transparency = 1
                        }))
                        table.insert(t9, TweenService:Create(v14, v10, {
                            Transparency = Transparency
                        }))
                    end
                end
            end

            local function setupButtonImageTweens() -- line: 482
                -- upvalues: t8 (copy), t9 (copy), v10 (copy), ButtonImage (copy), TweenService (copy)
                local ImageTransparency, BackgroundTransparency = ButtonImage.ImageTransparency, ButtonImage.BackgroundTransparency

                ButtonImage.BackgroundTransparency = 1
                ButtonImage.ImageTransparency = 1
                table.insert(t8, TweenService:Create(ButtonImage, v10, {
                    ImageTransparency = 1,
                    BackgroundTransparency = 1
                }))
                table.insert(t9, TweenService:Create(ButtonImage, v10, {
                    ImageTransparency = ImageTransparency,
                    BackgroundTransparency = BackgroundTransparency
                }))
            end

            local function setupIconTweens() -- line: 504
                -- upvalues: t8 (copy), t9 (copy), v10 (copy), ButtonTextImage (copy), TweenService (copy)
                local BackgroundTransparency, ImageTransparency = ButtonTextImage.BackgroundTransparency, ButtonTextImage.ImageTransparency

                ButtonTextImage.BackgroundTransparency = 1
                ButtonTextImage.ImageTransparency = 1
                table.insert(t8, TweenService:Create(ButtonTextImage, v10, {
                    ImageTransparency = 1,
                    BackgroundTransparency = 1
                }))
                table.insert(t9, TweenService:Create(ButtonTextImage, v10, {
                    ImageTransparency = ImageTransparency,
                    BackgroundTransparency = BackgroundTransparency
                }))
            end

            local KeyboardKeyCode

            if p8 == Enum.ProximityPromptInputType.Gamepad then
                local GamepadKeyCode = p7.GamepadKeyCode
                local v15 = InputIconsConfig.Image(GamepadKeyCode)

                if v15 then
                    setupIconTweens()
                    ButtonTextImage.Image = v15
                    ButtonText.Visible = false
                    ButtonImage.Visible = false
                    ButtonTextImage.Visible = true
                end
            elseif p8 == Enum.ProximityPromptInputType.Touch then
                setupButtonImageTweens()
                ButtonImage.Image = "rbxasset://textures/ui/Controls/TouchTapIcon.png"
                ButtonText.Visible = false
                ButtonTextImage.Visible = false
                ButtonImage.Visible = true
            else
                setupButtonImageTweens()
                ButtonImage.Visible = true

                local StringForKeyCode = UserInputService:GetStringForKeyCode(p7.KeyboardKeyCode)
                local v16 = t3[p7.KeyboardKeyCode]

                if v16 == nil then
                    v16 = t4[StringForKeyCode]
                end

                if v16 == nil then
                    StringForKeyCode = t5[p7.KeyboardKeyCode] or StringForKeyCode
                end

                if v16 then
                    setupIconTweens()
                    ButtonTextImage.Image = v16
                    ButtonText.Visible = false
                    ButtonTextImage.Visible = true
                elseif StringForKeyCode == nil or StringForKeyCode == "" then
                    local v17 = error
                    local Name = p7.Name

                    KeyboardKeyCode = p7.KeyboardKeyCode
                    v17("ProximityPrompt '" .. Name .. "' has an unsupported keycode for rendering UI: " .. tostring(KeyboardKeyCode))
                else
                    if string.len(StringForKeyCode) > 2 then
                        ButtonText.TextSize = math.round(ButtonText.TextSize * 6 / 7)
                    end

                    setupButtonTextTweens()
                    ButtonText.Text = StringForKeyCode
                    ButtonTextImage.Visible = false
                    ButtonText.Visible = true
                end
            end

            if p8 == Enum.ProximityPromptInputType.Touch or p7.ClickablePrompt then
                local TextButton = clone2.TextButton
                local v19 = false

                TextButton.InputBegan:Connect(function(p15) -- line: 597
                    -- upvalues: p7 (copy), v19 (ref)
                    if (p15.UserInputType == Enum.UserInputType.Touch or p15.UserInputType == Enum.UserInputType.MouseButton1) and p15.UserInputState ~= Enum.UserInputState.Change then
                        p7:InputHoldBegin()
                        v19 = true
                    end
                end)
                TextButton.InputEnded:Connect(function(p16) -- line: 608
                    -- upvalues: p7 (copy), v19 (ref)
                    if (p16.UserInputType == Enum.UserInputType.Touch or p16.UserInputType == Enum.UserInputType.MouseButton1) and v19 then
                        v19 = false
                        p7:InputHoldEnd()
                    end
                end)
                clone2.Active = true
            end

            local v20

            if typeof(p7:GetAttribute("Progress")) == "number" then
                v12 = p7.Parent
                v20 = if v12 then v12.Name == "WildAssetEgg" else false
            else
                v20 = false
            end

            local connection, connection2

            if p7.HoldDuration > 0 then
                local ProgressBar = Frame.ProgressBar
                local UIGradient = ProgressBar.LeftGradient.ProgressBarImage.UIGradient
                local UIGradient2 = ProgressBar.RightGradient.ProgressBarImage.UIGradient

                ProgressBar.Progress.Changed:Connect(function(p17) -- line: 159
                    -- upvalues: UIGradient (copy), UIGradient2 (copy)
                    local v22 = math.clamp(p17 * 360, 0, 360)

                    UIGradient.Rotation = math.clamp(v22, 180, 360)
                    UIGradient2.Rotation = math.clamp(v22, 0, 180)
                end)

                local v23 = "Progress_" .. LocalPlayer.UserId

                if typeof(p7:GetAttribute("Progress")) == "number" then
                    local v24 = v20

                    local function syncProgress() -- line: 633
                        -- upvalues: p7 (copy), ProgressBar (copy), v23 (copy), v24 (copy), applyWildEggZoom (copy)
                        local Attribute = p7:GetAttribute(v23)

                        if typeof(Attribute) ~= "number" then
                            Attribute = 0
                        end

                        ProgressBar.Progress.Value = Attribute

                        if v24 then
                            applyWildEggZoom(p7, Attribute)
                        end
                    end

                    local Attribute = p7:GetAttribute(v23)

                    if typeof(Attribute) ~= "number" then
                        Attribute = 0
                    end

                    ProgressBar.Progress.Value = Attribute

                    if v20 then
                        applyWildEggZoom(p7, Attribute)
                    end

                    connection = p7:GetAttributeChangedSignal(v23):Connect(syncProgress)

                    if v20 then
                        connection2 = p7.AncestryChanged:Connect(function(_, p19) -- line: 650
                            -- upvalues: p7 (copy), v1 (copy), t2 (copy), TweenService (copy), Workspace (copy)
                            if p19 ~= nil then
                                return
                            end

                            local CurrentCamera = Workspace.CurrentCamera

                            if not CurrentCamera or t2.prompt ~= p7 or not t2.baseFov then
                                return
                            end

                            if t2.tween then
                                t2.tween:Cancel()
                                t2.tween = nil
                            end

                            t2.tween = TweenService:Create(CurrentCamera, v1, {
                                FieldOfView = t2.baseFov
                            })
                            assert(t2.tween, "luau")
                            t2.tween:Play()
                            t2.prompt = nil
                            t2.baseFov = nil
                        end)
                    end
                else
                    KeyboardKeyCode = ProgressBar.Progress
                    table.insert(t6, TweenService:Create(KeyboardKeyCode, v8, {
                        Value = 1
                    }))
                    KeyboardKeyCode = ProgressBar.Progress
                    table.insert(t7, TweenService:Create(KeyboardKeyCode, v11, {
                        Value = 0
                    }))
                end
            end

            local connection3, connection4

            if p7.HoldDuration > 0 then
                connection3 = p7.PromptButtonHoldBegan:Connect(function() -- line: 674
                    -- upvalues: t6 (copy)
                    for _, v25 in ipairs(t6) do
                        v25:Play()
                    end
                end)
                connection4 = p7.PromptButtonHoldEnded:Connect(function() -- line: 680
                    -- upvalues: t7 (copy)
                    for _, v26 in ipairs(t7) do
                        v26:Play()
                    end
                end)
            end

            local connection5 = p7.Triggered:Connect(function() -- line: 687
                -- upvalues: t8 (copy)
                for _, v27 in ipairs(t8) do
                    v27:Play()
                end
            end)
            local connection6 = p7.TriggerEnded:Connect(function() -- line: 693
                -- upvalues: t9 (copy)
                for _, v28 in ipairs(t9) do
                    v28:Play()
                end
            end)

            local function getTextBoundsForLabel(p20, p21) -- line: 699
                -- upvalues: TextService (copy)
                local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

                GetTextBoundsParams.Font = p20.FontFace
                GetTextBoundsParams.Size = p20.TextSize
                GetTextBoundsParams.Width = 1000
                p21 = p21 or ""
                GetTextBoundsParams.Text = if p20.RichText then p21:gsub("<[^>]->", "") else p21

                local TextBoundsAsync = TextService:GetTextBoundsAsync(GetTextBoundsParams)

                GetTextBoundsParams:Destroy()

                return TextBoundsAsync
            end

            local function updateUIFromPrompt() -- line: 718
                -- upvalues: p7 (copy), clone (ref), ActionText (copy), ObjectText (copy), getTextBoundsForLabel (copy)
                local v30 = getTextBoundsForLabel(ActionText, p7.ActionText)
                local v31 = getTextBoundsForLabel(ObjectText, p7.ObjectText)
                local v32 = math.max(v30.X, v31.X)
                local v33 = if (p7.ActionText == nil or p7.ActionText == "") and (p7.ObjectText == nil or p7.ObjectText == "") then 72 else v32 + 72 + 24
                local v34, v35

                if p7.ObjectText == nil or p7.ObjectText == "" then
                    v35 = -10
                    v34 = 0
                elseif p7:GetAttribute("ObjectTextBelow") == true then
                    v34 = -9
                    v35 = 12
                else
                    v34 = 9
                    v35 = -10
                end

                ActionText.Position = UDim2.new(0.5, 72 - v33 / 2, 0, v34)
                ObjectText.Position = UDim2.new(0.5, 72 - v33 / 2, 0, v35)
                ActionText.Text = p7.ActionText
                ObjectText.Text = p7.ObjectText
                ActionText.AutoLocalize = p7.AutoLocalize
                ActionText.RootLocalizationTable = p7.RootLocalizationTable
                ObjectText.AutoLocalize = p7.AutoLocalize
                ObjectText.RootLocalizationTable = p7.RootLocalizationTable

                local clone2 = clone

                clone2.Size = UDim2.fromOffset(v33, 72)
                clone2.SizeOffset = Vector2.new(p7.UIOffset.X / clone.Size.Width.Offset, p7.UIOffset.Y / clone.Size.Height.Offset)
            end

            local connection7 = p7.Changed:Connect(updateUIFromPrompt)

            updateUIFromPrompt()
            clone.MaxDistance = 0

            local function syncDistance() -- line: 764
                -- upvalues: p7 (copy), clone (ref), LocalPlayer (copy), Workspace (copy)
                local Parent = p7.Parent
                local clone2 = clone

                clone2.Adornee = Parent
                clone2.Enabled = p7.Enabled and p7:IsDescendantOf(Workspace)

                if p7.Name == "RideMount" then
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                    local v36

                    if not (Parent and Parent:IsA("Attachment")) then
                        local BasePart = if Parent then Parent:IsA("BasePart") else nil

                        if not Parent or not BasePart then
                            local Model = if Parent then Parent:IsA("Model") else nil

                            if Parent and Model then
                                v36 = Parent:GetPivot().Position
                            end
                        else
                            v36 = Parent.Position
                        end
                    else
                        v36 = Parent.WorldPosition
                    end

                    local Enabled = clone.Enabled and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") and v36 ~= nil and (HumanoidRootPart.Position - v36).Magnitude <= p7.MaxActivationDistance

                    clone2.Enabled = Enabled
                end
            end

            syncDistance()

            local connection8 = RunService.RenderStepped:Connect(syncDistance)

            clone.Parent = p9

            for _, v37 in ipairs(t9) do
                v37:Play()
            end

            local function cleanup() -- line: 788
                -- upvalues: p7 (copy), t8 (copy), clone (ref), connection (ref), connection2 (ref), connection3 (ref), connection4 (ref), connection5 (copy), connection6 (copy), connection7 (copy), connection8 (copy), v20 (ref), v1 (copy), t2 (copy), TweenService (copy), Workspace (copy)
                connection8:Disconnect()

                local clone2 = clone

                clone2.Enabled = false

                if connection3 then
                    connection3:Disconnect()
                end

                if connection4 then
                    connection4:Disconnect()
                end

                if connection then
                    connection:Disconnect()
                end

                if connection2 then
                    connection2:Disconnect()
                end

                connection5:Disconnect()
                connection6:Disconnect()
                connection7:Disconnect()

                for _, v38 in ipairs(t8) do
                    v38:Play()
                end

                if v20 then
                    local CurrentCamera = Workspace.CurrentCamera

                    if CurrentCamera and t2.prompt == p7 and t2.baseFov then
                        if t2.tween then
                            t2.tween:Cancel()
                            t2.tween = nil
                        end

                        t2.tween = TweenService:Create(CurrentCamera, v1, {
                            FieldOfView = t2.baseFov
                        })
                        assert(t2.tween, "luau")
                        t2.tween:Play()
                        t2.prompt = nil
                        t2.baseFov = nil
                    end
                end

                wait(0.2)
                clone2:Destroy()
            end

            return cleanup
        end

        local function onLoad() -- line: 827
            -- upvalues: PlayerGui (copy), createPrompt (copy), ProximityPromptService (copy)
            ProximityPromptService.PromptShown:Connect(function(p22, p23) -- line: 828
                -- upvalues: PlayerGui (copy), createPrompt (copy)
                if p22.Style == Enum.ProximityPromptStyle.Default then
                    return
                end

                local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")

                if ProximityPrompts == nil then
                    ProximityPrompts = Instance.new("ScreenGui")
                    ProximityPrompts.Name = "ProximityPrompts"
                    ProximityPrompts.ResetOnSpawn = false
                    ProximityPrompts.Parent = PlayerGui
                end

                local v39 = createPrompt(p22, p23, ProximityPrompts)

                p22.PromptHidden:Wait()
                v39()
            end)
        end

        ProximityPromptService.PromptShown:Connect(function(p24, p25) -- line: 828
            -- upvalues: PlayerGui (copy), createPrompt (copy)
            if p24.Style == Enum.ProximityPromptStyle.Default then
                return
            end

            local ProximityPrompts = PlayerGui:FindFirstChild("ProximityPrompts")

            if ProximityPrompts == nil then
                ProximityPrompts = Instance.new("ScreenGui")
                ProximityPrompts.Name = "ProximityPrompts"
                ProximityPrompts.ResetOnSpawn = false
                ProximityPrompts.Parent = PlayerGui
            end

            local v40 = createPrompt(p24, p25, ProximityPrompts)

            p24.PromptHidden:Wait()
            v40()
        end)
    end
}
