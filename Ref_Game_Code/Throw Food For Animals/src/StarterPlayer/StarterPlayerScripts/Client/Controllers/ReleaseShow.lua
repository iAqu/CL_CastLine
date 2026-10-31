-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local FogConfig = require(ReplicatedStorage.Config.FogConfig)
local AreaUtil = require(ReplicatedStorage.Shared.AreaUtil)
local ReleaseReach = require(ReplicatedStorage.Shared.ReleaseReach)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Parent = script.Parent
local DataController = require(Parent.DataController)
local ClientState = require(Parent.ClientState)
local HUDController = require(Parent.HUDController)
local CameraRig = require(Parent.CameraRig)
local ScreenFX = require(Parent.ScreenFX)
local Sounds = require(Parent.Sounds)
local Movement = require(Parent.Movement)
local FogController = require(Parent.FogController)
local ShopUI = require(Parent.ShopUI)
local ReleaseController = require(Parent.ReleaseController)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local fromRGB = Color3.fromRGB
local v1 = Font.new("rbxasset://fonts/families/FredokaOne.json")
local v2 = Color3.new(1, 1, 1)
local v3 = Color3.new(0, 0, 0)
local t2 = {
    fromRGB(255, 140, 30),
    fromRGB(255, 196, 70),
    fromRGB(170, 80, 255),
    fromRGB(120, 230, 90)
}
local t3 = {
    "ShopOpen",
    "ExclusiveShopOpen",
    "IndexOpen",
    "AnimalsOpen",
    "SellOpen",
    "ProtectedSellOpen",
    "OfflineOpen",
    "InventoryOpen"
}
local v4 = false
local t4 = {}
local ScreenGui
local n1 = 0

local function hold(p1) -- line: 79
    -- upvalues: ClientState (copy), n1 (ref)
    local v5 = n1

    n1 = math.max(0, v5 + (if p1 then 1 else -1))
    ClientState.ReleaseShow = n1 > 0
end

local function tween(p2, p3, p4, p5, p6) -- line: 88
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p2, TweenInfo.new(p4, p5 or Enum.EasingStyle.Quad, p6 or Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

local function getGui() -- line: 94
    -- upvalues: LocalPlayer (copy), ScreenGui (ref)
    if ScreenGui and ScreenGui.Parent then
        return ScreenGui
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReleaseShow"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 160

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")

    return ScreenGui
end

local function frame(p7, p8) -- line: 106
    local Frame = Instance.new("Frame")

    Frame.BorderSizePixel = 0
    Frame.BackgroundTransparency = 1

    for v7, v8 in pairs(p8 or {}) do
        Frame[v7] = v8
    end

    Frame.Parent = p7

    return Frame
end

local function label(p9, p10, p11, p12) -- line: 116
    -- upvalues: v1 (copy), v2 (copy), v3 (copy)
    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = p10
    TextLabel.FontFace = v1
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = v2

    for v9, v10 in pairs(p11 or {}) do
        TextLabel[v9] = v10
    end

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = v3
    UIStroke.Thickness = p12 or 3
    UIStroke.LineJoinMode = Enum.LineJoinMode.Round
    UIStroke.Parent = TextLabel
    TextLabel.Parent = p9

    return TextLabel, UIStroke
end

local function fadeText(p13, p14, p15) -- line: 133
    -- upvalues: TweenService (copy)
    local t5 = {
        TextTransparency = p14
    }

    TweenService:Create(p13, TweenInfo.new(p15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t5):Play()

    local UIStroke = p13:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        local t6 = {
            Transparency = p14
        }

        TweenService:Create(UIStroke, TweenInfo.new(p15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t6):Play()
    end
end

local function areaIndex(p16) -- line: 139
    -- upvalues: AreasConfig (copy)
    for v11, v12 in ipairs(AreasConfig.All) do
        if v12.Key == p16 then
            return v11, v12
        end
    end

    return nil
end

local function areaGeometry(p17) -- line: 146
    -- upvalues: AreaUtil (copy)
    if not p17 then
        return nil
    end

    local Get = AreaUtil.Get
    local ok, result = pcall(Get, p17)

    if not ok or not result then
        result = nil
    end

    return result
end

local function level() -- line: 152
    -- upvalues: DataController (copy)
    return DataController:Get("Level") or 1
end

local function screenFree() -- line: 156
    -- upvalues: ClientState (copy), HUDController (copy), t3 (copy)
    if ClientState.Busy then
        return false
    end

    for _, v13 in ipairs(t3) do
        if ClientState[v13] then
            return false
        end
    end

    return not HUDController.IsGameplayHidden()
end

local function inLobby() -- line: 164
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return false
    end

    local Position = HumanoidRootPart.Position

    if not (Position.Z > -60 and Position.Z < 80) then
        return false
    end

    return math.abs(Position.X) < 130
end

local function lobbyFree() -- line: 172
    -- upvalues: ClientState (copy), HUDController (copy), LocalPlayer (copy), t3 (copy)
    local v14

    if ClientState.Busy then
        v14 = false
    else
        local v15 = false

        for _, v16 in ipairs(t3) do
            if ClientState[v16] then
                v14 = false
                v15 = true
                break
            end
        end

        if not v15 then
            v14 = not HUDController.IsGameplayHidden()
        end
    end

    if not v14 then
        return v14
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return false
    end

    local Position = HumanoidRootPart.Position

    if not (Position.Z > -60 and Position.Z < 80) then
        return false
    end

    return math.abs(Position.X) < 130
end

local function waitFor(p18, p19) -- line: 180
    if p18() then
        return true
    end

    local elapsed = os.clock()
    local v17

    while true do
        task.wait(0.25)

        local v18

        if p18() then
            local v19 = v17 or os.clock()

            if os.clock() - v19 >= 1.5 then
                break
            else
                v18 = v19
            end
        end

        if p19 and p19 < os.clock() - elapsed then
            return false
        end

        v17 = v18
    end

    return true
end

function t1.TierFor(p20, p21) -- line: 196
    -- upvalues: ReleaseConfig (copy), ReleaseReach (copy), DataController (copy)
    local v20 = ReleaseConfig.Show[p20]

    if v20 then
        local v21 = ReleaseReach.AreaForLevel(p21 or DataController:Get("Level") or 1)

        if (v20.CutsceneFromArea or 1e999) <= v21 then
            return "Cutscene"
        end

        if (v20.BigFromArea or 1e999) <= v21 then
            return "Big"
        end
    end

    return "Small"
end

local function findDecor(p22) -- line: 209
    -- upvalues: Workspace (copy)
    local Lobby = Workspace:FindFirstChild("Lobby")
    local HalloweenDecor = Lobby and Lobby:FindFirstChild("HalloweenDecor")

    return if HalloweenDecor and (HalloweenDecor:GetAttribute("Release") == nil or HalloweenDecor:GetAttribute("Release") == p22) then HalloweenDecor else nil
end

local function popDecor(p23) -- line: 217
    -- upvalues: TweenService (copy), Workspace (copy), Sounds (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local Position = CurrentCamera and CurrentCamera.CFrame.Position or Vector3.new(0, 0, 0)
    local t7 = {}

    for _, descendant in ipairs(p23:GetDescendants()) do
        local Parent = descendant.Parent

        if Parent and (Parent == p23 or Parent:IsA("Folder")) then
            if descendant:IsA("Model") then
                table.insert(t7, {
                    Model = descendant,
                    Scale = descendant:GetScale(),
                    Distance = (descendant:GetPivot().Position - Position).Magnitude
                })
            elseif descendant:IsA("BasePart") then
                table.insert(t7, {
                    Part = descendant,
                    Transparency = descendant.Transparency,
                    Distance = (descendant.Position - Position).Magnitude
                })
            end
        end
    end

    table.sort(t7, function(p24, p25) -- line: 231
        return p24.Distance < p25.Distance
    end)

    for _, v22 in ipairs(t7) do
        if v22.Model then
            v22.Model:ScaleTo(v22.Scale * 0.02)
        else
            v22.Part.Transparency = 1
        end
    end

    for v23, v24 in ipairs(t7) do
        task.delay((v23 - 1) / math.max(#t7 - 1, 1) * 2.6, function() -- line: 237
            -- upvalues: t7 (copy), v23 (copy), v24 (copy), TweenService (copy), Sounds (copy)
            local Model = v24.Model
            local v27

            if Model then
                if not v24.Model.Parent then
                    return
                end

                local NumberValue = Instance.new("NumberValue")

                NumberValue.Value = 0.02
                NumberValue.Changed:Connect(function(p26) -- line: 242
                    -- upvalues: v24 (copy)
                    if v24.Model.Parent then
                        v24.Model:ScaleTo(v24.Scale * math.max(p26, 0.02))
                    end
                end)

                local t10 = {
                    Value = 1
                }
                local Back = Enum.EasingStyle.Back
                local tween = TweenService:Create(NumberValue, TweenInfo.new(0.5, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10)

                tween:Play()
                tween.Completed:Once(function() -- line: 246
                    -- upvalues: NumberValue (copy), v24 (copy)
                    if v24.Model.Parent then
                        v24.Model:ScaleTo(v24.Scale)
                    end

                    NumberValue:Destroy()
                end)
                v27 = v23 % 4 == 1
            else
                v24.Part.Transparency = v24.Transparency
            end

            if (not Model or v27) and Model then
                Sounds.Play("Pop", {
                    Volume = 0.35,
                    Pitch = 0.9 + 0.5 * v23 / #t7
                })
            end
        end)
    end

    return 3.1
end

local function turnLobbyAir(p27) -- line: 261
    -- upvalues: FogConfig (copy), ClientState (copy), FogController (copy)
    if FogController.GetZone() ~= "Lobby" or ClientState.Busy then
        FogController.RefreshZone(p27)
    else
        FogController.SetOverride(FogConfig.Get("Lobby"), p27)
        task.delay(p27 + 0.2, function() -- line: 267
            -- upvalues: FogController (copy)
            FogController.ClearOverride()
        end)
    end
end

local function turnLobby(p28, p29) -- line: 271
    -- upvalues: Workspace (copy), ClientState (copy), HUDController (copy), ScreenFX (copy), Sounds (copy), LocalPlayer (copy), fromRGB (copy), t3 (copy), n1 (ref), hold (copy), popDecor (copy), turnLobbyAir (copy)
    n1 = math.max(0, n1 + 1)
    ClientState.ReleaseShow = n1 > 0

    local v29

    if p29 then
        v29 = p29
    else
        local Lobby = Workspace:FindFirstChild("Lobby")
        local HalloweenDecor = Lobby and Lobby:FindFirstChild("HalloweenDecor")

        if HalloweenDecor and (HalloweenDecor:GetAttribute("Release") == nil or HalloweenDecor:GetAttribute("Release") == p28) then
            v29 = HalloweenDecor
        end
    end

    local v30

    if v29 then
        v30 = v29
    else
        local Lobby = Workspace:FindFirstChild("Lobby")
        local elapsed = os.clock()

        while true do
            if Lobby then
                local HalloweenDecor, v31

                if v29 then
                    v30 = v29
                    v31 = true
                elseif os.clock() - elapsed < 6 then
                    task.wait(0.1)

                    local Lobby = Workspace:FindFirstChild("Lobby")

                    HalloweenDecor = Lobby and Lobby:FindFirstChild("HalloweenDecor")
                    v31 = false
                else
                    v30 = v29
                    v31 = true
                end

                if v31 then
                    break
                end

                v29 = if HalloweenDecor and (HalloweenDecor:GetAttribute("Release") == nil or HalloweenDecor:GetAttribute("Release") == p28) then HalloweenDecor else nil
                continue
            end

            v30 = v29
            break
        end
    end

    local v32

    if ClientState.Busy then
        v32 = false
    else
        local v33 = false

        for _, v34 in ipairs(t3) do
            if ClientState[v34] then
                v32 = false
                v33 = true
                break
            end
        end

        if not v33 then
            v32 = not HUDController.IsGameplayHidden()
        end
    end

    local v35

    if v32 then
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        v35 = false

        if HumanoidRootPart then
            local Position = HumanoidRootPart.Position

            if Position.Z > -60 and Position.Z < 80 then
                v35 = math.abs(Position.X) < 130
            end
        end
    else
        v35 = v32
    end

    if v30 and v35 then
        Sounds.Play("Riser", {
            Volume = 0.5
        })
        ScreenFX.Flash(fromRGB(255, 150, 60), 0.35, 0.8)
        popDecor(v30)
    end

    turnLobbyAir(v35 and 3.5 or 1)
    task.delay(v35 and 3.5 or 0, hold, false)
end

local function smallLine(p30, p31) -- line: 296
    -- upvalues: TweenService (copy), Sounds (copy), LocalPlayer (copy), ScreenGui (ref), label (copy), fadeText (copy)
    if not (ScreenGui and ScreenGui.Parent) then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "ReleaseShow"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 160

        local ScreenGui2 = ScreenGui

        ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local ScreenGui3 = ScreenGui

        ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local ScreenGui2 = ScreenGui
    local v36 = label(ScreenGui2, p30, {
        Name = "SmallLine",
        TextTransparency = 1,
        ZIndex = 20,
        Size = UDim2.fromScale(0.62, 0.05),
        Position = UDim2.fromScale(0.5, 0.2),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, 3)

    v36:FindFirstChildOfClass("UIStroke").Transparency = 1

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.8
    UIScale.Parent = v36
    fadeText(v36, 0, 0.3)

    local t11 = {
        Scale = 1
    }
    local Back = Enum.EasingStyle.Back

    TweenService:Create(UIScale, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
    Sounds.Play("Pop")
    task.delay(p31 or 5, function() -- line: 309
        -- upvalues: v36 (copy), fadeText (copy)
        fadeText(v36, 1, 0.5)
        task.wait(0.6)
        v36:Destroy()
    end)
end

local function flyingBats(p32, p33) -- line: 320
    -- upvalues: TweenService (copy), label (copy)
    local AbsoluteSize = p32.AbsoluteSize

    for i = 1, p33 do
        task.delay((i - 1) * 0.35, function() -- line: 323
            -- upvalues: p32 (copy), i (copy), TweenService (copy), label (copy)
            local v37 = i % 2 == 1
            local v38 = math.random(8, 30) / 100
            local v39 = label(p32, "🦇", {
                ZIndex = 6,
                TextStrokeTransparency = 1,
                Size = UDim2.fromScale(0.06, 0.08),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(v37 and -0.05 or 1.05, v38)
            }, 0)

            Instance.new("UIAspectRatioConstraint").Parent = v39

            local t13 = {
                Position = UDim2.fromScale(v37 and 1.08 or -0.08, v38 + math.random(-6, 10) / 100)
            }
            local v40 = 2.4 + math.random()
            local Sine = Enum.EasingStyle.Sine
            local InOut = Enum.EasingDirection.InOut
            local tween = TweenService:Create(v39, TweenInfo.new(v40, Sine or Enum.EasingStyle.Quad, InOut or Enum.EasingDirection.Out), t13)

            tween:Play()
            tween.Completed:Once(function() -- line: 333
                -- upvalues: v39 (copy)
                v39:Destroy()
            end)
        end)
    end

    return AbsoluteSize
end

local function titleCard(_, p35, p36) -- line: 341
    -- upvalues: TweenService (copy), AreasConfig (copy), Sounds (copy), ShopUI (copy), LocalPlayer (copy), fromRGB (copy), v2 (copy), t2 (copy), ScreenGui (ref), frame (copy), label (copy), fadeText (copy), flyingBats (copy)
    p36 = p36 or {}

    if not (ScreenGui and ScreenGui.Parent) then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "ReleaseShow"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.DisplayOrder = 160

        local ScreenGui2 = ScreenGui

        ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local ScreenGui3 = ScreenGui

        ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local ScreenGui2 = ScreenGui
    local v42 = frame(ScreenGui2, {
        Name = "Announcement",
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1)
    })
    local v43

    if p36.Dim ~= false then
        local v44 = frame(v42, {
            Name = "Dim",
            BackgroundTransparency = 1,
            ZIndex = 1,
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = fromRGB(24, 8, 36)
        })

        v43 = v44

        local t14 = {
            BackgroundTransparency = 0.38
        }

        TweenService:Create(v44, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t14):Play()
    end

    local v45 = p36.TitleY or 0.34
    local v46 = ShopUI.Rays(v42, fromRGB(255, 150, 40), {
        Count = 9,
        Alpha = 0.5,
        Speed = 18,
        ZIndex = 2,
        Size = UDim2.fromScale(0.62, 0.62),
        Position = UDim2.fromScale(0.5, v45)
    })
    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0
    UIScale.Parent = v46

    local t15 = {
        Scale = 1
    }
    local Back = Enum.EasingStyle.Back

    TweenService:Create(UIScale, TweenInfo.new(0.6, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()

    local v47 = label(v42, p35.Title or "NEW MAPS!", {
        Name = "Title",
        Rotation = -3,
        ZIndex = 5,
        Size = UDim2.fromScale(0.86, 0.19),
        Position = UDim2.fromScale(0.5, v45),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, 6)
    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0
    UIScale2.Parent = v47

    local t16 = {
        Scale = 1
    }
    local Back2 = Enum.EasingStyle.Back

    TweenService:Create(UIScale2, TweenInfo.new(0.5, Back2 or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t16):Play()
    Sounds.Play("AnnounceBass")
    Sounds.Play("SuperChime")
    task.defer(function() -- line: 369
        -- upvalues: v42 (copy), v45 (copy), ShopUI (copy), t2 (copy)
        local AbsoluteSize = v42.AbsoluteSize

        ShopUI.Confetti(v42, Vector2.new(AbsoluteSize.X * 0.5, AbsoluteSize.Y * v45), 70, {
            Spread = 75,
            MinSpeed = 420,
            MaxSpeed = 900,
            ZIndex = 4,
            Colors = t2
        })
        task.delay(0.25, function() -- line: 372
            -- upvalues: AbsoluteSize (copy), v42 (copy), ShopUI (copy), t2 (copy)
            ShopUI.Confetti(v42, Vector2.new(AbsoluteSize.X * 0.12, AbsoluteSize.Y * 0.95), 30, {
                Spread = 25,
                Direction = -70,
                ZIndex = 4,
                Colors = t2
            })
            ShopUI.Confetti(v42, Vector2.new(AbsoluteSize.X * 0.88, AbsoluteSize.Y * 0.95), 30, {
                Spread = 25,
                Direction = -110,
                ZIndex = 4,
                Colors = t2
            })
        end)
    end)
    flyingBats(v42, 4)

    local t17 = {}

    for v48, v49 in ipairs(p35.Maps or {}) do
        local v50 = false
        local v51

        for _, v52 in ipairs(AreasConfig.All) do
            if v52.Key == v49 then
                v51 = v52
                v50 = true
                break
            end
        end

        if not v50 then
            v51 = nil
        end

        local v53 = v45 + 0.17 + (v48 - 1) * 0.085
        local v54 = v48 % 2 == 1
        local v55 = frame(v42, {
            ZIndex = 3,
            Name = "Map" .. v48,
            Size = UDim2.fromScale(0.5, 0.075),
            Position = UDim2.fromScale(v54 and -0.4 or 1.4, v53),
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        local v56 = frame(v55, {
            Name = "Glow",
            BackgroundTransparency = 0,
            ZIndex = 3,
            Size = UDim2.fromScale(1, 0.9),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = v51 and v51.Color or v2
        })
        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0.5, 0)
        UICorner.Parent = v56

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.25),
            NumberSequenceKeypoint.new(1, 1)
        })
        UIGradient.Parent = v56
        label(v55, "???", {
            ZIndex = 4,
            Size = UDim2.fromScale(1, 1)
        }, 4)
        table.insert(t17, v55)
        task.delay(0.45 + (v48 - 1) * 0.4, function() -- line: 394
            -- upvalues: v53 (copy), v55 (copy), TweenService (copy), Sounds (copy)
            if v55.Parent then
                local t20 = {
                    Position = UDim2.fromScale(0.5, v53)
                }
                local Back = Enum.EasingStyle.Back

                TweenService:Create(v55, TweenInfo.new(0.45, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t20):Play()
                Sounds.Play("CardPop")
            end
        end)
    end

    local v57

    if p36.Footer then
        local v58 = label(v42, p36.Footer, {
            Name = "Footer",
            TextTransparency = 1,
            ZIndex = 4,
            Size = UDim2.fromScale(0.6, 0.048),
            Position = UDim2.fromScale(0.5, v45 + 0.2 + #t17 * 0.085),
            AnchorPoint = Vector2.new(0.5, 0.5)
        }, 3)

        v57 = v58
        v58:FindFirstChildOfClass("UIStroke").Transparency = 1
        task.delay(#t17 * 0.4 + 0.6, function() -- line: 404
            -- upvalues: v57 (ref), fadeText (copy)
            if v57.Parent then
                fadeText(v57, 0, 0.4)
            end
        end)
    end

    local v59 = true

    task.spawn(function() -- line: 408
        -- upvalues: v47 (copy), v59 (ref)
        local n2 = 0

        while v59 and v47.Parent do
            n2 += task.wait()
            v47.Rotation = math.sin(n2 * 2.2) * 1.6 + -3
        end
    end)

    return {
        Close = function() -- Close | line: 416
            -- upvalues: v42 (copy), v43 (ref), UIScale (copy), UIScale2 (copy), t17 (copy), v57 (ref), v59 (ref), TweenService (copy), fadeText (copy)
            v59 = false

            local t22 = {
                Scale = 0
            }
            local Back = Enum.EasingStyle.Back
            local In = Enum.EasingDirection.In

            TweenService:Create(UIScale2, TweenInfo.new(0.3, Back or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t22):Play()

            local t23 = {
                Scale = 0
            }

            TweenService:Create(UIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t23):Play()

            for v61, v62 in ipairs(t17) do
                local t24 = {
                    Position = UDim2.fromScale(v61 % 2 == 1 and -0.4 or 1.4, v62.Position.Y.Scale)
                }
                local Back = Enum.EasingStyle.Back
                local In = Enum.EasingDirection.In

                TweenService:Create(v62, TweenInfo.new(0.3, Back or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t24):Play()
            end

            if v57 then
                fadeText(v57, 1, 0.25)
            end

            if v43 then
                local v63 = v43
                local t25 = {
                    BackgroundTransparency = 1
                }

                TweenService:Create(v63, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t25):Play()
            end

            task.delay(0.45, function() -- line: 425
                -- upvalues: v42 (copy)
                v42:Destroy()
            end)
        end
    }
end

local function bigAnnouncement(p37, p38) -- line: 430
    -- upvalues: ScreenFX (copy), Sounds (copy), fromRGB (copy), titleCard (copy)
    Sounds.Play("Riser", {
        Volume = 0.6
    })
    ScreenFX.Flash(fromRGB(255, 170, 80), 0.45, 0.5)

    local v64 = titleCard(p37, p38, {
        Footer = p38.BigText
    })

    task.wait(5)
    v64.Close()
    task.wait(0.5)
end

local function emitter(p39, p40) -- line: 443
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Enabled = false

    for v65, v66 in pairs(p40) do
        ParticleEmitter[v65] = v66
    end

    ParticleEmitter.Parent = p39

    return ParticleEmitter
end

local function wallFX(p41, p42, p43) -- line: 452
    -- upvalues: fromRGB (copy)
    local Part = Instance.new("Part")

    Part.Name = "Dust"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(80, 1, 2)
    Part.CFrame = CFrame.new(0, p42 + 1, p41.Z + 4)
    Part.Parent = p43

    local clone = Part:Clone()

    clone.Name = "Face"
    clone.Size = Vector3.new(80, 46, 2)
    clone.CFrame = CFrame.new(0, p42 + 24, p41.Z + 2)
    clone.Parent = p43

    local v67 = ColorSequence.new(fromRGB(150, 118, 92), fromRGB(96, 78, 70))
    local t26 = {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        LightInfluence = 0.6,
        Rate = 40,
        Color = v67,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 3),
            NumberSequenceKeypoint.new(1, 9)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.2, 2),
        Speed = NumberRange.new(2, 6),
        SpreadAngle = Vector2.new(70, 20),
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-30, 30)
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Enabled = false

    for v68, v69 in pairs(t26) do
        ParticleEmitter[v68] = v69
    end

    ParticleEmitter.Parent = Part

    local t27 = {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        LightInfluence = 0.5,
        Drag = 2,
        Color = v67,
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 6),
            NumberSequenceKeypoint.new(1, 18)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.6, 2.8),
        Speed = NumberRange.new(10, 30),
        SpreadAngle = Vector2.new(40, 40),
        EmissionDirection = Enum.NormalId.Front,
        Rotation = NumberRange.new(0, 360),
        RotSpeed = NumberRange.new(-40, 40)
    }
    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Enabled = false

    for v70, v71 in pairs(t27) do
        ParticleEmitter2[v70] = v71
    end

    ParticleEmitter2.Parent = clone

    local t28 = {
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        LightEmission = 1,
        LightInfluence = 0,
        Acceleration = Vector3.new(0, -40, 0),
        Drag = 1,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, fromRGB(255, 190, 80)),
            ColorSequenceKeypoint.new(0.5, fromRGB(255, 120, 40)),
            ColorSequenceKeypoint.new(1, fromRGB(170, 80, 255))
        }),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.6),
            NumberSequenceKeypoint.new(1, 0)
        }),
        Lifetime = NumberRange.new(0.8, 1.6),
        Speed = NumberRange.new(30, 70),
        SpreadAngle = Vector2.new(70, 70)
    }
    local ParticleEmitter3 = Instance.new("ParticleEmitter")

    ParticleEmitter3.Enabled = false

    for v72, v73 in pairs(t28) do
        ParticleEmitter3[v72] = v73
    end

    ParticleEmitter3.Parent = clone

    return {
        Rumble = function() -- Rumble | line: 490
            -- upvalues: ParticleEmitter (copy)
            ParticleEmitter.Enabled = true
        end,
        Burst = function() -- Burst | line: 491
            -- upvalues: ParticleEmitter (copy), ParticleEmitter2 (copy), ParticleEmitter3 (copy)
            ParticleEmitter.Enabled = false
            ParticleEmitter2:Emit(70)
            ParticleEmitter3:Emit(120)
        end
    }
end

local function breakWall(p44, p45, p46) -- line: 503
    -- upvalues: TweenService (copy), fromRGB (copy)
    local Position = p44.Position

    p44.Transparency = 1

    for _, descendant in ipairs(p44:GetDescendants()) do
        if descendant:IsA("Texture") then
            descendant.Transparency = 1
        elseif descendant:IsA("SurfaceGui") then
            descendant.Enabled = false
        end
    end

    local t30 = {}

    for i = 1, 10 do
        for j = 1, 7 do
            local Part = Instance.new("Part")

            Part.Name = "Chunk"
            Part.Size = Vector3.new(7.6, 6.457142857142856, 3 + math.random() * 3)
            Part.CFrame = CFrame.new((i - 0.5) * 8 + -40, p45 + (j - 0.5) * 6.857142857142857, Position.Z)
            Part.Color = fromRGB(96, 70, 50):Lerp(fromRGB(60, 44, 34), math.random())
            Part.Material = Enum.Material.Plastic
            Part.MaterialVariant = "Studs"
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Anchored = false
            Part.Parent = p46
            Part.AssemblyLinearVelocity = Vector3.new((i - 5.5) / 5 * 45 + math.random(-6, 6), 25 + math.random() * 35 + j * 3, -(40 + math.random() * 45))
            Part.AssemblyAngularVelocity = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
            table.insert(t30, Part)
        end
    end

    task.delay(0.9, function() -- line: 531
        -- upvalues: t30 (copy), TweenService (copy)
        for _, v80 in ipairs(t30) do
            if v80.Parent then
                local t31 = {
                    Transparency = 1,
                    Size = v80.Size * 0.4
                }
                local Quad = Enum.EasingStyle.Quad
                local In = Enum.EasingDirection.In

                TweenService:Create(v80, TweenInfo.new(0.7, Quad or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t31):Play()
            end
        end

        task.delay(0.75, function() -- line: 535
            -- upvalues: t30 (copy)
            for _, v81 in ipairs(t30) do
                v81:Destroy()
            end
        end)
    end)
end

local function glide(p47, p48, p49, p50) -- line: 542
    -- upvalues: TweenService (copy)
    return function(p51) -- line: 543
        -- upvalues: p47 (copy), p48 (copy), p49 (copy), p50 (copy), TweenService (copy)
        local v83 = p47:Lerp(p48, (TweenService:GetValue(math.clamp(p51 / p49, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)))

        return CFrame.lookAt(v83, v83 + p50)
    end
end

local function runCutscene(p52, p53) -- line: 551
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), Workspace (copy), AreasConfig (copy), AreaUtil (copy), ClientState (copy), HUDController (copy), CameraRig (copy), ScreenFX (copy), Sounds (copy), Movement (copy), fromRGB (copy), v3 (copy), titleCard (copy), wallFX (copy), breakWall (copy)
    local ReleaseShowAssets = ReplicatedStorage:FindFirstChild("ReleaseShowAssets")

    ReleaseShowAssets = ReleaseShowAssets and ReleaseShowAssets:FindFirstChild(p52) and ReleaseShowAssets[p52]:FindFirstChild("EndWall")

    local v84 = p53.Maps and p53.Maps[1]
    local v85 = false
    local v86

    for v87, v88 in ipairs(AreasConfig.All) do
        if v88.Key == v84 then
            v86 = v87
            v85 = true
            break
        end
    end

    if not v85 then
        v86 = nil
    end

    local result

    if v86 then
        local Get = AreaUtil.Get
        local ok

        ok, result = pcall(Get, v86)

        if not ok or not result then
            result = nil
        end

        v86 -= 1
    end

    local result2

    if v86 then
        local Get = AreaUtil.Get
        local ok

        ok, result2 = pcall(Get, v86)

        if not ok or not result2 then
            result2 = nil
        end
    end

    if not (ReleaseShowAssets and result and result2) then
        return false
    end

    ClientState.Busy = "Release"
    Movement.Lock()

    local Folder = Instance.new("Folder")

    Folder.Name = "ReleaseCutscene"

    local v89 = false
    local v90

    local function cleanup() -- line: 565
        -- upvalues: Folder (copy), v89 (ref), v90 (ref), ClientState (copy), HUDController (copy), CameraRig (copy), ScreenFX (copy), Movement (copy)
        if v89 then
            return
        end

        v89 = true

        if v90 then
            v90.Close()
        end

        Folder:Destroy()
        CameraRig.Release()
        ScreenFX.HideBars(0.2)
        HUDController.SetGameplayVisible(true)
        Movement.Unlock()

        if ClientState.Busy == "Release" then
            ClientState.Busy = nil
        end
    end

    local function v91() -- line: 577
        -- upvalues: p52 (copy), p53 (copy), ReleaseShowAssets (ref), result (ref), result2 (ref), Folder (copy), v90 (ref), TweenService (copy), Workspace (copy), HUDController (copy), CameraRig (copy), ScreenFX (copy), Sounds (copy), fromRGB (copy), v3 (copy), titleCard (copy), wallFX (copy), breakWall (copy)
        ScreenFX.FadeOut(v3, 0.45)
        HUDController.SetGameplayVisible(false, {
            ReleaseShow = true
        })
        Folder.Parent = Workspace

        local clone = ReleaseShowAssets:Clone()

        clone.Parent = Folder

        local v92 = clone:FindFirstChild("Time", true)
        local Position = clone.Position
        local FloorY = result2.FloorY
        local v93 = wallFX(Position, FloorY, Folder)

        CameraRig.Take()
        CameraRig.SetHandheld(0.5)

        local v96 = Vector3.new(10, FloorY + 13, Position.Z + 125)
        local v99 = Vector3.new(3, FloorY + 15, Position.Z + 78)
        local v101 = Vector3.new(0, FloorY + 19, Position.Z)

        CameraRig.SetShot(function(p54) -- line: 594
            -- upvalues: v96 (copy), v99 (copy), v101 (copy), TweenService (copy)
            local Value = TweenService:GetValue(math.clamp(p54 / 4.6, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

            return CFrame.lookAt(v96:Lerp(v99, Value), v101)
        end)
        ScreenFX.ShowBars(0.3)
        task.wait(0.2)
        ScreenFX.FadeIn(0.5)

        for i = 3, 1, -1 do
            if v92 then
                v92.Text = "0:0" .. i
            end

            Sounds.Play("TimerTick", {
                Pitch = (3 - i) * 0.15 + 1
            })
            CameraRig.Shake((3 - i) * 0.14 + 0.12, 0.8)
            task.wait(0.85)
        end

        if v92 then
            v92.Text = "0:00"
        end

        v93.Rumble()
        Sounds.Play("SuperRiser")
        CameraRig.Shake(0.75, 1.1, 18)
        task.wait(0.9)
        breakWall(clone, FloorY, Folder)
        v93.Burst()
        ScreenFX.Flash(fromRGB(255, 190, 110), 0.8, 0.6)
        Sounds.Play("SuperSlam")
        Sounds.Play("GroundSmash")
        Sounds.Play("LuckyBurst")
        CameraRig.Shake(1.7, 1.1, 14)
        CameraRig.PunchFOV(14, 0.06, 0.7)
        v90 = titleCard(p52, p53, {
            Dim = false,
            TitleY = 0.2
        })
        task.wait(1.1)

        local Position2 = CameraRig.GetCFrame().Position
        local v105 = Vector3.new(0, result.FloorY + 13, result.ZStart - 70)
        local BlendTo = CameraRig.BlendTo
        local n3 = 3.2
        local v106 = Vector3.new(0, -0.1, -1)

        BlendTo(function(p55) -- line: 543
            -- upvalues: Position2 (copy), v105 (copy), n3 (copy), v106 (copy), TweenService (copy)
            local v108 = Position2:Lerp(v105, (TweenService:GetValue(math.clamp(p55 / n3, 0, 1), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)))

            return CFrame.lookAt(v108, v108 + v106)
        end, 0.35)
        Sounds.Play("CameraWhoosh")
        task.wait(1.1)

        if v90 then
            v90.Close()
            v90 = nil
        end

        task.wait(2.75)
        ScreenFX.FadeOut(v3, 0.4)
    end

    local ok, result3 = pcall(v91)

    cleanup()
    ScreenFX.FadeIn(0.45)

    if not ok then
        warn("[ReleaseShow] cutscene failed: " .. tostring(result3))
    end

    return ok
end

local function markSeen(p56) -- line: 647
    -- upvalues: Remotes (copy)
    Remotes.Event("Release_Seen"):FireServer(p56)
end

function t1.Play(p57, p58) -- line: 652
    -- upvalues: ReleaseConfig (copy), Remotes (copy), ClientState (copy), HUDController (copy), ReleaseController (copy), t1 (copy), LocalPlayer (copy), t3 (copy), v4 (ref), n1 (ref), screenFree (copy), lobbyFree (copy), waitFor (copy), smallLine (copy), bigAnnouncement (copy), runCutscene (copy)
    local v109 = p58 or {}
    local v110 = ReleaseConfig.Show[p57]

    if not v110 or v4 then
        return
    end

    v4 = true
    task.spawn(function() -- line: 657
        -- upvalues: v109 (copy), p57 (copy), v110 (copy), Remotes (copy), ClientState (copy), HUDController (copy), ReleaseController (copy), t1 (copy), LocalPlayer (copy), t3 (copy), v4 (ref), n1 (ref), screenFree (copy), lobbyFree (copy), waitFor (copy), smallLine (copy), bigAnnouncement (copy), runCutscene (copy)
        n1 = math.max(0, n1 + 1)
        ClientState.ReleaseShow = n1 > 0

        local function waitUntil(p59, p60) -- line: 660
            -- upvalues: ClientState (copy), n1 (ref), waitFor (copy)
            if p59() then
                return
            end

            n1 = math.max(0, n1 + -1)
            ClientState.ReleaseShow = n1 > 0
            waitFor(p59, p60)
            n1 = math.max(0, n1 + 1)
            ClientState.ReleaseShow = n1 > 0
        end

        local function v114() -- line: 666
            -- upvalues: v109 (copy), p57 (copy), v110 (copy), Remotes (copy), ClientState (copy), HUDController (copy), ReleaseController (copy), t1 (copy), LocalPlayer (copy), t3 (copy), n1 (ref), screenFree (copy), lobbyFree (copy), waitFor (copy), smallLine (copy), bigAnnouncement (copy), runCutscene (copy)
            local v115 = v109.Tier or t1.TierFor(p57)

            if v115 == "Small" then
                local v116

                if ClientState.Busy then
                    v116 = false
                else
                    local v117 = false

                    for _, v118 in ipairs(t3) do
                        if ClientState[v118] then
                            v116 = false
                            v117 = true
                            break
                        end
                    end

                    if not v117 then
                        v116 = not HUDController.IsGameplayHidden()
                    end
                end

                if not v116 then
                    n1 = math.max(0, n1 + -1)
                    ClientState.ReleaseShow = n1 > 0
                    waitFor(screenFree, 300)
                    n1 = math.max(0, n1 + 1)
                    ClientState.ReleaseShow = n1 > 0
                end

                smallLine(v110.SmallText or "New maps are out!")
                task.wait(5)
            else
                local v122

                if ClientState.Busy then
                    v122 = false
                else
                    local v123 = false

                    for _, v124 in ipairs(t3) do
                        if ClientState[v124] then
                            v122 = false
                            v123 = true
                            break
                        end
                    end

                    if not v123 then
                        v122 = not HUDController.IsGameplayHidden()
                    end
                end

                local v125

                if v122 then
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                    v125 = false

                    if HumanoidRootPart then
                        local Position = HumanoidRootPart.Position

                        if Position.Z > -60 and Position.Z < 80 then
                            v125 = math.abs(Position.X) < 130
                        end
                    end
                else
                    v125 = v122
                end

                if not v125 then
                    n1 = math.max(0, n1 + -1)
                    ClientState.ReleaseShow = n1 > 0
                    waitFor(lobbyFree, nil)
                    n1 = math.max(0, n1 + 1)
                    ClientState.ReleaseShow = n1 > 0
                end

                local v129 = false

                if v115 == "Cutscene" and ReleaseController.WaitForMap(p57, 40) then
                    local v130

                    if ClientState.Busy then
                        v130 = false
                    else
                        local v131 = false

                        for _, v132 in ipairs(t3) do
                            if ClientState[v132] then
                                v130 = false
                                v131 = true
                                break
                            end
                        end

                        if not v131 then
                            v130 = not HUDController.IsGameplayHidden()
                        end
                    end

                    local v133

                    if v130 then
                        local Character = LocalPlayer.Character
                        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                        v133 = false

                        if HumanoidRootPart then
                            local Position = HumanoidRootPart.Position

                            if Position.Z > -60 and Position.Z < 80 then
                                v133 = math.abs(Position.X) < 130
                            end
                        end
                    else
                        v133 = v130
                    end

                    if not v133 then
                        n1 = math.max(0, n1 + -1)
                        ClientState.ReleaseShow = n1 > 0
                        waitFor(lobbyFree, nil)
                        n1 = math.max(0, n1 + 1)
                        ClientState.ReleaseShow = n1 > 0
                    end

                    v129 = runCutscene(p57, v110)
                end

                if not v129 then
                    bigAnnouncement(p57, v110)
                end
            end

            if not v109.Test then
                Remotes.Event("Release_Seen"):FireServer(p57)
            end
        end

        local ok, result = pcall(v114)

        if not ok then
            warn("[ReleaseShow] " .. tostring(result))
        end

        n1 = math.max(0, n1 + -1)
        ClientState.ReleaseShow = n1 > 0
        v4 = false
    end)
end

function t1.Test(p61, p62) -- line: 692
    -- upvalues: Workspace (copy), ReleaseConfig (copy), FogConfig (copy), Remotes (copy), FogController (copy), ReleaseController (copy), t1 (copy), v4 (ref), turnLobby (copy)
    if v4 then
        warn("[ReleaseShow] a release show is still playing - try again in a moment")

        return false
    end

    if not ReleaseConfig.Show[p61] then
        return false
    end

    print("[ReleaseShow] dev test: " .. tostring(p61) .. " (" .. tostring(p62) .. ")")
    v4 = true

    local function v138() -- line: 700
        -- upvalues: p61 (copy), p62 (copy), Workspace (copy), FogConfig (copy), Remotes (copy), FogController (copy), ReleaseController (copy), t1 (copy), v4 (ref), turnLobby (copy)
        local v139 = "Preview_" .. p61

        ReleaseController.ClearGroup(v139)
        Remotes.Invoke("Dev_Action", "PreviewRelease", p61)

        local Lobby = Workspace:WaitForChild("Lobby")
        local elapsed = os.clock()

        while not Lobby:FindFirstChild("HalloweenUpdateBoard") and os.clock() - elapsed < 8 do
            task.wait(0.1)
        end

        local Lobby2 = Workspace:FindFirstChild("Lobby")
        local HalloweenDecor = Lobby2 and Lobby2:FindFirstChild("HalloweenDecor")

        if not (HalloweenDecor and (HalloweenDecor:GetAttribute("Release") == nil or HalloweenDecor:GetAttribute("Release") == p61)) then
            HalloweenDecor = nil
        end

        if HalloweenDecor then
            HalloweenDecor.Parent = nil
        end

        FogController.SetOverride(FogConfig.Presets.Lobby, 0.6)
        ReleaseController.SetTestCountdown(p61, 10)
        task.wait(10)
        ReleaseController.SetTestCountdown(p61, nil)
        ReleaseController.ClearGroup(v139)

        if HalloweenDecor then
            HalloweenDecor.Parent = Lobby
        end

        v4 = false
        turnLobby(p61, HalloweenDecor)
        task.delay(4, function() -- line: 720
            -- upvalues: FogController (copy)
            FogController.ClearOverride()
        end)
        task.wait(3)
        t1.Play(p61, {
            Test = true,
            Tier = p62
        })
    end

    local ok, result = pcall(v138)

    if not ok then
        v4 = false
        warn("[ReleaseShow] test failed: " .. tostring(result))
    end

    return ok
end

function t1.Init() -- line: 731
    -- upvalues: ReleaseConfig (copy), Remotes (copy), DataController (copy), ClientState (copy), t1 (copy), t4 (copy), n1 (ref), hold (copy), turnLobby (copy)
    ReleaseConfig.OnChanged(function(p63, p64) -- line: 732
        -- upvalues: ReleaseConfig (copy), ClientState (copy), t1 (copy), t4 (copy), n1 (ref), hold (copy), turnLobby (copy)
        if not (p64 and ReleaseConfig.Show[p63]) then
            return
        end

        t4[p63] = true
        n1 = math.max(0, n1 + 1)
        ClientState.ReleaseShow = n1 > 0
        task.delay(4, hold, false)
        task.spawn(turnLobby, p63)
        task.delay(3.5, t1.Play, p63, {})
    end)
    task.spawn(function() -- line: 741
        -- upvalues: ReleaseConfig (copy), Remotes (copy), DataController (copy), t1 (copy), t4 (copy)
        DataController:WaitForReady()
        task.wait(6)

        for v142 in pairs(ReleaseConfig.Show) do
            local Seen = DataController:Get("Seen")

            if not t4[v142] and ReleaseConfig.IsUnlocked(v142) and (type(Seen) ~= "table" or not Seen[v142]) then
                local Tutorial = DataController:Get("Tutorial")

                if type(Tutorial) ~= "table" or Tutorial.Done == true then
                    t1.Play(v142, {})
                else
                    Remotes.Event("Release_Seen"):FireServer(v142)
                end
            end
        end
    end)
end

return t1
