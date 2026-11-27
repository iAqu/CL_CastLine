-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared.GameConfig)
local Zones = require(Shared.Data.Zones)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local NumberFormat = require(Shared.NumberFormat)
local Style = require(Shared.Style)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local DataClient = require(script.Parent.DataClient)
local Toasts = require(script.Parent.Toasts)
local ScreenFx = require(script.Parent.ScreenFx)
local Pad = require(script.Parent.Pad)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera, fromRGB, new = workspace.CurrentCamera, Color3.fromRGB, Vector3.new
local t1 = {
    State = "idle",
    OnCaught = nil,
    Enabled = true,
    AfterCatch = nil,
    PauseAt = nil,
    PausedAt = nil,
    AutoRun = false
}
local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12
local n1 = 0
local v13
local n2 = 1
local n3 = 0
local Model, v14, v15, v16, Waist, v17

local function getChar() -- line: 64
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v18, v19

    if Character then
        v18 = Character:FindFirstChild("HumanoidRootPart")
        v19 = Character:FindFirstChildOfClass("Humanoid")
    else
        v19 = Character
        v18 = Character
    end

    if v18 and v19 and v19.Health > 0 then
        return Character, v18, v19
    end

    return nil
end

local function inZone(p1) -- line: 74
    -- upvalues: GameConfig (copy)
    local Position = p1.Position

    if math.abs(Position.X) <= GameConfig.LANE_HALF_WIDTH - 2 and Position.Z <= 9.5 and Position.Z >= GameConfig.DOCK_Z - 1 and Position.Y < 9 then
        return Position.Y > -1
    end

    return false
end

local function checkpoint(p2) -- line: 80
    -- upvalues: CurrentCamera (copy), t1 (copy)
    if t1.PauseAt ~= p2 then
        return 0
    end

    local elapsed = os.clock()

    t1.PausedAt = p2

    local CFrame = CurrentCamera.CFrame

    while t1.PauseAt == p2 do
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.CFrame = CFrame
        task.wait()
    end

    t1.PausedAt = nil

    return os.clock() - elapsed
end

local function part(p3, p4, p5, p6, p7) -- line: 96
    -- upvalues: Style (copy)
    local Part = Instance.new("Part")

    Part.Size = p4
    Part.CFrame = p5
    Part.Color = p6
    Part.Anchored = false
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Massless = true
    Part.CastShadow = false

    if p7 then
        Part.Material = Enum.Material.Neon
    else
        Style.studPart(Part, 1)
    end

    Part.Parent = p3

    return Part
end

local Rods = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared").Data.Rods)

local function currentRod() -- line: 120
    -- upvalues: Rods (copy)
    local EquippedRod = require(script.Parent.DataClient).Get("EquippedRod")

    return Rods.ById[EquippedRod] or Rods.List[1]
end

local function rodSpeed() -- line: 124
    return 1
end

local function equipRod(p8) -- line: 128
    -- upvalues: Style (copy), fromRGB (copy), Model (ref), part (copy), Rods (copy)
    if Model and Model.Parent then
        return Model
    end

    local v20 = p8:FindFirstChild("RightHand") or p8:FindFirstChild("Right Arm")

    if not v20 then
        return nil
    end

    local v21 = v20.CFrame * CFrame.new(0, if v20.Name == "RightHand" then -0.15 else -0.9, 0)
    local Model2 = Instance.new("Model")

    Model2.Name = "FishingRod"

    local EquippedRod = require(script.Parent.DataClient).Get("EquippedRod")
    local v22 = Rods.ById[EquippedRod] or Rods.List[1]
    local v23 = part(Model2, Vector3.new(0.42, 0.42, 1.7), v21 * CFrame.new(0, 0, -0.2), fromRGB(150, 95, 55))
    local v24 = v21 * CFrame.new(0, 0, 0.7)
    local Color2 = v22.Color2
    local Part = Instance.new("Part")

    Part.Size = Vector3.new(0.5, 0.5, 0.3)
    Part.CFrame = v24
    Part.Color = Color2
    Part.Anchored = false
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Massless = true
    Part.CastShadow = false
    Style.studPart(Part, 1)
    Part.Parent = Model2

    local v25 = v21 * CFrame.new(0, 0, -2.6)
    local Color = v22.Color
    local Part2 = Instance.new("Part")

    Part2.Size = Vector3.new(0.26, 0.26, 3.2)
    Part2.CFrame = v25
    Part2.Color = Color
    Part2.Anchored = false
    Part2.CanCollide = false
    Part2.CanTouch = false
    Part2.CanQuery = false
    Part2.Massless = true
    Part2.CastShadow = false
    Style.studPart(Part2, 1)
    Part2.Parent = Model2
    part(Model2, Vector3.new(0.18, 0.18, 3.2), v21 * CFrame.new(0, 0, -5.7), v22.Color:Lerp(Color3.new(1, 1, 1), 0.35))

    local v26 = v21 * CFrame.new(0, 0, -4.2)
    local Color2_2 = v22.Color2
    local Part3 = Instance.new("Part")

    Part3.Size = Vector3.new(0.34, 0.34, 0.16)
    Part3.CFrame = v26
    Part3.Color = Color2_2
    Part3.Anchored = false
    Part3.CanCollide = false
    Part3.CanTouch = false
    Part3.CanQuery = false
    Part3.Massless = true
    Part3.CastShadow = false
    Style.studPart(Part3, 1)
    Part3.Parent = Model2

    local v27 = v21 * CFrame.new(0, 0, -7.4)
    local v28 = v22.Glow or v22.Color2
    local Part4 = Instance.new("Part")

    Part4.Size = Vector3.new(0.26, 0.26, 0.3)
    Part4.CFrame = v27
    Part4.Color = v28
    Part4.Anchored = false
    Part4.CanCollide = false
    Part4.CanTouch = false
    Part4.CanQuery = false
    Part4.Massless = true
    Part4.CastShadow = false
    Style.studPart(Part4, 1)
    Part4.Parent = Model2

    if v22.Glow then
        Part4.Material = Enum.Material.Neon

        local PointLight = Instance.new("PointLight")

        PointLight.Color = v22.Glow
        PointLight.Range = 8
        PointLight.Brightness = 1.5
        PointLight.Parent = Part4
    end

    local v29 = v21 * CFrame.new(0.32, 0, -1.3)
    local Color2_3 = v22.Color2
    local Part5 = Instance.new("Part")

    Part5.Size = Vector3.new(0.3, 0.8, 0.8)
    Part5.CFrame = v29
    Part5.Color = Color2_3
    Part5.Anchored = false
    Part5.CanCollide = false
    Part5.CanTouch = false
    Part5.CanQuery = false
    Part5.Massless = true
    Part5.CastShadow = false
    Style.studPart(Part5, 1)
    Part5.Parent = Model2
    part(Model2, Vector3.new(0.5, 0.25, 0.25), v21 * CFrame.new(0.6, 0, -1.3), fromRGB(60, 60, 72))

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Tip"
    Attachment.Parent = Part4

    for _, child in ipairs(Model2:GetChildren()) do
        local WeldConstraint = Instance.new("WeldConstraint")

        WeldConstraint.Part0 = v20
        WeldConstraint.Part1 = child
        WeldConstraint.Parent = child
    end

    Model2.PrimaryPart = v23
    Model2.Parent = p8
    Model = Model2

    return Model2
end

local function unequipRod() -- line: 171
    -- upvalues: Model (ref)
    if Model then
        Model:Destroy()
        Model = nil
    end
end

local function getShoulder(p9) -- line: 179
    local RightUpperArm = p9:FindFirstChild("RightUpperArm")

    if RightUpperArm and RightUpperArm:FindFirstChild("RightShoulder") then
        return RightUpperArm.RightShoulder, "X"
    end

    local Torso = p9:FindFirstChild("Torso")

    if not (Torso and Torso:FindFirstChild("Right Shoulder")) then
        return nil, nil
    end

    return Torso["Right Shoulder"], "Z"
end

local function makeBobber(p10) -- line: 192
    -- upvalues: fromRGB (copy), part (copy)
    local Model = Instance.new("Model")

    Model.Name = "Bobber"

    local v30 = part(Model, Vector3.new(1.5, 0.75, 1.5), CFrame.new(p10) * CFrame.new(0, 0.38, 0), fromRGB(245, 60, 60))
    local v31 = part(Model, Vector3.new(1.5, 0.75, 1.5), CFrame.new(p10) * CFrame.new(0, -0.38, 0), fromRGB(250, 250, 250))
    local v32 = part(Model, Vector3.new(0.3, 0.7, 0.3), CFrame.new(p10) * CFrame.new(0, 1.1, 0), fromRGB(60, 60, 72))
    local v33 = part(Model, Vector3.new(0.5, 0.9, 0.5), CFrame.new(p10) * CFrame.new(0, -1.5, 0), fromRGB(255, 150, 170))

    for _, v34 in ipairs({ v30, v31, v32, v33 }) do
        v34.Anchored = true
    end

    Model.PrimaryPart = v30

    local Attachment = Instance.new("Attachment")

    Attachment.Position = Vector3.new(0, 0.6, 0)
    Attachment.Parent = v30

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, -0.6, 0)
    Attachment2.Parent = v30

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.Lifetime = 0.45
    Trail.LightEmission = 1
    Trail.FaceCamera = true
    Trail.Color = ColorSequence.new(fromRGB(255, 255, 255))
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    Trail.Parent = v30

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Sparks"
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Color = ColorSequence.new(fromRGB(255, 255, 255), fromRGB(255, 230, 120))
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.35, 0.7)
    ParticleEmitter.Speed = NumberRange.new(2, 7)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.Rate = 70
    ParticleEmitter.Parent = v30

    local PointLight = Instance.new("PointLight")

    PointLight.Name = "Glow"
    PointLight.Brightness = 2.2
    PointLight.Range = 16
    PointLight.Parent = v30

    local Attachment3 = Instance.new("Attachment")

    Attachment3.Name = "Line"
    Attachment3.Position = Vector3.new(0, 1.4, 0)
    Attachment3.Parent = v30
    Model.Parent = workspace

    return Model, Attachment3
end

local function splash(p11) -- line: 244
    -- upvalues: Debris (copy), UIKit (copy), fromRGB (copy), new (copy)
    for i = 0, 1 do
        local Part = Instance.new("Part")

        Part.Shape = Enum.PartType.Cylinder
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon
        Part.Color = fromRGB(255, 255, 255)
        Part.Transparency = i * 0.25 + 0.15
        Part.Size = Vector3.new(0.25, 3, 3)
        Part.CFrame = CFrame.new(p11 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part.Parent = workspace
        UIKit.tween(Part, i * 0.25 + 0.55, {
            Transparency = 1,
            Size = new(0.25, i * 16 + 30, i * 16 + 30)
        })
        Debris:AddItem(Part, 1.2)
    end

    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Size = Vector3.new(3, 0.2, 3)
    Part.CFrame = CFrame.new(p11)
    Part.Parent = workspace

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(fromRGB(235, 250, 255))
    ParticleEmitter.LightEmission = 0.6
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.1),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
    ParticleEmitter.Speed = NumberRange.new(14, 30)
    ParticleEmitter.SpreadAngle = Vector2.new(55, 55)
    ParticleEmitter.Acceleration = Vector3.new(0, -60, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(60)

    local clone = ParticleEmitter:Clone()

    clone.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.7),
        NumberSequenceKeypoint.new(1, 0.4)
    })
    clone.Speed = NumberRange.new(34, 52)
    clone.SpreadAngle = Vector2.new(16, 16)
    clone.Lifetime = NumberRange.new(0.7, 1.2)
    clone.Parent = Part
    clone:Emit(22)
    Debris:AddItem(Part, 2)

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.SmoothPlastic
    Part2.Color = fromRGB(225, 246, 255)
    Part2.Transparency = 0.25
    Part2.Size = Vector3.new(2, 3.4, 3.4)
    Part2.CFrame = CFrame.new(p11 + Vector3.new(0, 1, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Parent = workspace
    UIKit.tween(Part2, 0.5, {
        Size = Vector3.new(26, 0.8, 0.8),
        Transparency = 1,
        CFrame = CFrame.new(p11 + Vector3.new(0, 13, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    })
    Debris:AddItem(Part2, 0.7)
    UIKit.sound("Splash")
end

local function biteMark(p12) -- line: 310
    -- upvalues: Debris (copy), UIKit (copy), fromRGB (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(p12 + Vector3.new(0, 4.2, 0))
    Part.Parent = workspace

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromScale(5, 5)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.Parent = Part

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.Text = "!"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = fromRGB(255, 226, 70)
    TextLabel.Parent = BillboardGui

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 5
    UIStroke.Color = fromRGB(20, 20, 34)
    UIStroke.Parent = TextLabel

    local UIScale = Instance.new("UIScale")

    UIScale.Scale = 0.2
    UIScale.Parent = TextLabel
    UIKit.tween(UIScale, 0.16, {
        Scale = 1
    }, Enum.EasingStyle.Back)
    Debris:AddItem(Part, 1.2)

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = fromRGB(255, 240, 150)
    Part2.Transparency = 0.2
    Part2.Size = Vector3.new(0.2, 2, 2)
    Part2.CFrame = CFrame.new(p12 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Parent = workspace
    UIKit.tween(Part2, 0.45, {
        Size = Vector3.new(0.2, 16, 16),
        Transparency = 1
    })
    Debris:AddItem(Part2, 0.6)
end

t1.UseLucky = false
t1.NoLuckyOffer = nil
t1.LuckyPrompts = 0
t1.LuckyOffered = nil
t1.MuteLucky = false

local n4 = -1000
local v36

function t1.BuyLucky() -- line: 371
    -- upvalues: Players (copy), t1 (copy), n4 (ref)
    if os.clock() - n4 < 1.5 then
        return
    end

    local Products = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared").Data.Products)
    local v37, v38

    for _, v39 in ipairs(Products.LuckyPacks) do
        if v39.id ~= 0 then
            v37 = v39
            v38 = v39
            break
        end
    end

    if not v38 then
        require(script.Parent.Toasts).Show("red", "Not on sale yet")

        return
    end

    n4 = os.clock()
    t1.LuckyPrompts += 1
    t1.LuckyOffered = v38.key

    if not t1.MuteLucky then
        local function v40() -- line: 391
            -- upvalues: v37 (ref), Players (copy)
            game:GetService("MarketplaceService"):PromptProductPurchase(Players.LocalPlayer, v37.id)
        end

        pcall(v40)
    end
end

local function refreshLucky() -- line: 396
    -- upvalues: HUD (copy), DataClient (copy), t1 (copy), n4 (ref), v36 (ref)
    local Boosts = HUD.Boosts

    if not Boosts then
        return
    end

    local v41 = DataClient.Get("LuckyCasts") or 0

    if v41 <= 0 then
        t1.UseLucky = false
    elseif v36 == 0 and os.clock() - n4 < 180 then
        t1.UseLucky = true
        n4 = -1000
    end

    v36 = v41

    local v42 = v41 <= 0

    Boosts:SetLuck(if v42 and t1.NoLuckyOffer ~= nil and t1.NoLuckyOffer() then nil
        elseif v42 then "get"
        elseif t1.UseLucky then "on"
        else "use", v41)
end

function t1.ToggleLucky() -- line: 415
    -- upvalues: UIKit (copy), HUD (copy), DataClient (copy), t1 (copy), refreshLucky (copy)
    local Boosts = HUD.Boosts

    if Boosts and Boosts:LuckShown() then
        if (DataClient.Get("LuckyCasts") or 0) <= 0 then
            Boosts.Luck:Pop()
            t1.BuyLucky()
        else
            t1.UseLucky = not t1.UseLucky
            refreshLucky()
            Boosts.Luck:Pop()

            if t1.UseLucky then
                UIKit.sound("ToastGold")
            end
        end
    end
end

local v43 = false
local n5 = -1000

t1.AutoTarget = nil
t1.AutoPrompts = 0
t1.MuteAutoPrompt = false

local function autoPass() -- line: 446
    -- upvalues: ReplicatedStorage (copy)
    local Products = require(ReplicatedStorage:WaitForChild("Shared").Data.Products)

    for _, v44 in ipairs(Products.Gamepasses) do
        if v44.key == "AutoCast" then
            return v44
        end
    end

    return nil
end

function t1.OwnsAuto() -- line: 456
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("OwnsAutoCast") == true
end

function t1.AutoOn() -- line: 461
    -- upvalues: t1 (copy), v43 (ref)
    local v45 = v43
    local v46, v47

    if v45 then
        local v48 = t1.OwnsAuto()

        if v48 then
            v46 = t1.TutorialActive ~= nil and t1.TutorialActive()
            v47 = not v46
        else
            v47 = v48
        end
    else
        v47 = v45
    end

    return v47
end

local function refreshAuto() -- line: 465
    -- upvalues: HUD (copy), Pad (copy), t1 (copy), v6 (ref), v9 (ref), v43 (ref)
    local Boosts = HUD.Boosts

    if not (Boosts and v6) then
        return
    end

    local v49 = t1.TutorialActive ~= nil and t1.TutorialActive()
    local v50 = t1.NoLuckyOffer ~= nil and t1.NoLuckyOffer()
    local v51 = t1.OwnsAuto()
    local v52 = v51 and v43

    Boosts:SetAuto(if v49 or not v51 and v50 then nil
        elseif not v51 then "get"
        elseif v52 then "on"
        else "off")

    local v53 = v6

    if v52 then
        v53.Text = "AUTO CASTING..."
    elseif Pad.Using() then
        v53.Text = "PRESS TO CAST!"
    else
        v53.Text = "TAP TO CAST!"
    end

    if v9 then
        local v54 = v9

        v54.ImageTransparency = v52 and 1 or 0
    end
end

t1.RefreshAuto = refreshAuto

function t1.SetAuto(p13) -- line: 483
    -- upvalues: Remotes (copy), t1 (copy), v43 (ref), refreshAuto (copy)
    if v43 == p13 then
        refreshAuto()
    else
        v43 = p13
        t1.AutoTarget = nil
        refreshAuto()
        task.spawn(function() -- line: 491
            -- upvalues: p13 (copy), Remotes (copy)
            local function v55() -- line: 492
                -- upvalues: p13 (copy), Remotes (copy)
                Remotes.SetSetting:InvokeServer("AutoCast", p13)
            end

            pcall(v55)
        end)
    end
end

function t1.ToggleAuto() -- line: 499
    -- upvalues: UIKit (copy), HUD (copy), Toasts (copy), LocalPlayer (copy), t1 (copy), v43 (ref), n5 (ref), autoPass (copy)
    if HUD.Boosts then
        HUD.Boosts.Auto:Pop()
    end

    if t1.OwnsAuto() then
        t1.SetAuto(not v43)
        UIKit.sound(v43 and "ToastGold" or "Click")
    elseif not (os.clock() - n5 < 1.5) then
        local v56 = autoPass()

        if v56 and v56.id ~= 0 then
            n5 = os.clock()
            t1.AutoPrompts += 1

            if not t1.MuteAutoPrompt then
                local function v57() -- line: 515
                    -- upvalues: v56 (copy), LocalPlayer (copy)
                    game:GetService("MarketplaceService"):PromptGamePassPurchase(LocalPlayer, v56.id)
                end

                pcall(v57)
            end

            return
        end

        Toasts.Show("info", "Auto Cast isn't on sale yet!")
    end
end

local function setMeterVisible(p14) -- line: 525
    -- upvalues: UIKit (copy), v2 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), refreshLucky (copy), refreshAuto (copy)
    v2.Visible = p14
    refreshLucky()
    refreshAuto()
    v5.Visible = true
    v6.Visible = p14
    v7.Visible = false
    v8.Visible = false

    if p14 then
        UIKit.pop(v2, 0.7)
    end
end

local t3 = {}

t3.__index = t3
t3.MARGIN = 34
t3.ABOVE_JUMP = 14

function t3.new(p15) -- line: 543
    -- upvalues: UIKit (copy), Pad (copy), fromRGB (copy), t3 (copy)
    local self = setmetatable({}, t3)
    local v59 = UIKit.screenGui("CastExit", 45)

    v59.ScreenInsets = Enum.ScreenInsets.None

    local v60 = UIKit.frame(v59, {
        Name = "Corner",
        Transparency = 1,
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1)
    })
    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingRight = UDim.new(0, self.MARGIN)
    UIPadding.PaddingBottom = UDim.new(0, self.MARGIN)
    UIPadding.Parent = v60

    local v61, v62 = UIKit.button(v60, {
        Name = "Exit",
        Text = "EXIT",
        Corner = 35,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 3,
        Size = UDim2.fromOffset(196, 70),
        Position = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(1, 1),
        Color = UIKit.Colors.Red,
        Color2 = UIKit.Colors.RedDark,
        OnClick = function() -- OnClick | line: 552
            -- upvalues: p15 (copy)
            p15()
        end
    })

    v62.TextColor3 = fromRGB(255, 255, 255)
    Pad.Icon(v61, Enum.KeyCode.ButtonB, {
        ZIndex = 4,
        Size = UDim2.fromOffset(52, 52),
        Position = UDim2.new(0, -8, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    v61.Visible = false
    self.Gui = v59
    self.Padding = UIPadding
    self.Button = v61

    return self
end

function t3:Place() -- line: 564
    -- upvalues: GuiService (copy), HUD (copy), LocalPlayer (copy), CurrentCamera (copy)
    local MARGIN = self.MARGIN
    local v63 = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("TouchGui")

    v63 = v63 and v63.Enabled and v63:FindFirstChild("JumpButton", true)

    if HUD.IsTouch() and v63 and v63.Visible and v63.AbsoluteSize.Y > 0 then
        local FitScale = self.Gui:FindFirstChild("FitScale")
        local v64 = if FitScale and FitScale.Scale > 0 then FitScale.Scale else 1
        local GuiInset = GuiService:GetGuiInset()

        MARGIN = math.max(MARGIN, (CurrentCamera.ViewportSize.Y - (v63.AbsolutePosition.Y + GuiInset.Y) + self.ABOVE_JUMP) / v64)
    end

    self.Padding.PaddingBottom = UDim.new(0, MARGIN)
end

function t3:Show() -- line: 578
    -- upvalues: UIKit (copy)
    self:Place()
    self.Button.Visible = true

    local v66 = UIKit.scaleOf(self.Button)

    v66.Scale = 0
    UIKit.tween(v66, 0.3, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

function t3:Hide() -- line: 586
    self.Button.Visible = false
end

function t3:Showing() -- line: 590
    return self.Button.Visible
end

local v67
local t6 = {}

t6.__index = t6
t6.IDS = {
    idle = 134578491856974,
    cast = 116083744898324,
    lucky = 137610930356441
}
t6.RELEASE = {
    cast = 1.27,
    lucky = 1.98
}

function t6.new() -- line: 601
    -- upvalues: t6 (copy)
    local self = setmetatable({}, t6)

    self.Animator = nil
    self.Tracks = {}
    self.Anims = {}

    for v69, v70 in pairs(self.IDS) do
        local Animation = Instance.new("Animation")

        Animation.Name = "Cast_" .. v69
        Animation.AnimationId = "rbxassetid://" .. v70
        self.Anims[v69] = Animation
    end

    return self
end

function t6:Track(p21, p22) -- line: 615
    local Humanoid = p21 and p21:FindFirstChildOfClass("Humanoid")
    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        return nil
    end

    if Animator ~= self.Animator then
        self.Animator = Animator
        self.Tracks = {}
    end

    local result = self.Tracks[p22]

    if not result then
        local function v71() -- line: 627
            -- upvalues: self (copy), p22 (copy), Animator (copy)
            return Animator:LoadAnimation(self.Anims[p22])
        end

        local ok

        ok, result = pcall(v71)

        if not ok then
            return nil
        end

        if p22 == "idle" then
            result.Priority = Enum.AnimationPriority.Action
        else
            result.Priority = Enum.AnimationPriority.Action2
        end

        result.Looped = p22 == "idle"
        self.Tracks[p22] = result
    end

    return result
end

function t6:Preload(p24) -- line: 641
    for v72 in pairs(self.IDS) do
        self:Track(p24, v72)
    end
end

function t6:Idle(p26) -- line: 647
    local idle = self:Track(p26, "idle")

    if idle and not idle.IsPlaying then
        idle:Play(0.2)
    end
end

function t6:Cast(p28, p29, p30) -- line: 654
    local v73 = if p29 then "lucky" else "cast"
    local v74 = self:Track(p28, v73)
    local idle = self.Tracks.idle

    if idle and idle.IsPlaying then
        idle:Stop(0.15)
    end

    if not v74 then
        return 0.71 / p30
    end

    v74:Play(0.1, 1, p30)

    return self.RELEASE[v73] / p30
end

function t6:StopAll() -- line: 668
    for _, v75 in pairs(self.Tracks) do
        if v75.IsPlaying then
            v75:Stop(0.25)
        end
    end
end

local v76 = t6.new()
local t8 = {}

t8.__index = t8
t8.LUCK = fromRGB(90, 255, 120)
t8.LUCK2 = fromRGB(255, 230, 90)
t8.SPARKLE = "rbxasset://textures/particles/sparkles_main.dds"

local function flairPart(p32, p33) -- line: 684
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = p33
    Part.CFrame = p32
    Part.Parent = workspace

    return Part
end

local function sparkles(p34, p35, p36, p37, p38) -- line: 698
    -- upvalues: t8 (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = t8.SPARKLE
    ParticleEmitter.Color = p35
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p38),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 0.9)
    ParticleEmitter.Speed = p37
    ParticleEmitter.Rate = p36
    ParticleEmitter.Parent = p34

    return ParticleEmitter
end

function t8.Perfect(p39, p40) -- line: 711
    -- upvalues: Debris (copy), UIKit (copy), sparkles (copy)
    local v77 = CFrame.new(p39 + Vector3.new(0, 3, 0))
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(2, 2, 2)
    Part.CFrame = v77
    Part.Parent = workspace

    local v78 = sparkles(Part, ColorSequence.new(Color3.new(1, 1, 1), p40), 0, NumberRange.new(18, 34), 1.4)

    v78.SpreadAngle = Vector2.new(180, 180)
    v78.Drag = 3
    v78:Emit(46)

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = p40
    Part2.Transparency = 0.15
    Part2.Size = Vector3.new(0.2, 4, 4)
    Part2.CFrame = CFrame.new(p39 + Vector3.new(0, 3.2, 0)) * CFrame.Angles(0, 1.5707963267948966, 0)
    Part2.Parent = workspace
    UIKit.tween(Part2, 0.45, {
        Size = Vector3.new(0.2, 26, 26),
        Transparency = 1
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    UIKit.sound("RevealGood", 1.25)
    UIKit.sound("Coin", 1.4)
    Debris:AddItem(Part, 1.5)
    Debris:AddItem(Part2, 0.6)
end

function t8.LuckCharge(_, p42) -- line: 737
    -- upvalues: RunService (copy), UIKit (copy), new (copy), t8 (copy), sparkles (copy)
    local self = setmetatable({}, t8)

    self.Parts = {}

    local v80 = ColorSequence.new(t8.LUCK, t8.LUCK2)
    local v81 = CFrame.new(p42 + Vector3.new(0, 0.3, 0))
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(9, 0.2, 9)
    Part.CFrame = v81
    Part.Parent = workspace

    local v82 = sparkles(Part, v80, 55, NumberRange.new(4, 9), 0.9)

    v82.EmissionDirection = Enum.NormalId.Top
    v82.Shape = Enum.ParticleEmitterShape.Disc
    v82.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    v82.Acceleration = Vector3.new(0, 6, 0)

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = t8.SPARKLE
    ParticleEmitter.Color = v80
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.5, 1.1),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.2)
    ParticleEmitter.Speed = NumberRange.new(1, 2)
    ParticleEmitter.RotSpeed = NumberRange.new(-200, 200)
    ParticleEmitter.Rate = 30
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Cylinder
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
    ParticleEmitter.Parent = Part

    local PointLight = Instance.new("PointLight")

    PointLight.Color = t8.LUCK
    PointLight.Range = 16
    PointLight.Brightness = 0
    PointLight.Parent = Part
    UIKit.tween(PointLight, 0.8, {
        Brightness = 3
    })

    local t10 = {}

    for i = 1, 2 do
        local Part = Instance.new("Part")

        Part.Shape = Enum.PartType.Cylinder
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon

        if i == 1 then
            Part.Color = t8.LUCK
        else
            Part.Color = t8.LUCK2
        end

        Part.Transparency = 0.5
        Part.Size = new(0.15, 8 - i * 2, 8 - i * 2)
        Part.Parent = workspace
        t10[i] = Part
        table.insert(self.Parts, Part)
    end

    table.insert(self.Parts, Part)
    self.Floor = Part
    self.Rise = v82
    self.Swirl = ParticleEmitter
    self.Light = PointLight

    local elapsed = os.clock()

    self.Conn = RunService.RenderStepped:Connect(function() -- line: 785
        -- upvalues: p42 (copy), v82 (copy), ParticleEmitter (copy), t10 (copy), elapsed (copy), new (copy)
        local v83 = os.clock() - elapsed
        local v85 = math.min(v83 / 1.6, 1)

        for v86, v87 in ipairs(t10) do
            local v88 = 0.4 + v83 * (0.9 + v86 * 0.3) % 1 * 5.5
            local v89 = (8 - v86 * 2) * (1 - v85 * 0.35)

            v87.Size = new(0.15, v89, v89)
            v87.CFrame = CFrame.new((new(p42.X, p42.Y + v88, p42.Z))) * CFrame.Angles(0, v83 * (3 + v86), 1.5707963267948966)
            v87.Transparency = 0.35 + 0.5 * (v83 * (0.9 + v86 * 0.3) % 1)
        end

        ParticleEmitter.Rate = v85 * 60 + 30
        v82.Rate = v85 * 80 + 55
    end)
    UIKit.sound("Riser", 1.2)

    return self
end

function t8.Release(p43, _) -- line: 802
    -- upvalues: Debris (copy), UIKit (copy), ScreenFx (copy), t8 (copy)
    if p43.Conn then
        p43.Conn:Disconnect()
        p43.Conn = nil
    end

    p43.Rise.Rate = 0
    p43.Swirl.Rate = 0
    p43.Rise.Speed = NumberRange.new(20, 40)
    p43.Rise.SpreadAngle = Vector2.new(70, 70)
    p43.Rise:Emit(70)
    UIKit.tween(p43.Light, 0.4, {
        Brightness = 0
    })

    for _, v91 in ipairs(p43.Parts) do
        if v91 ~= p43.Floor then
            UIKit.tween(v91, 0.25, {
                Transparency = 1
            })
        end
    end

    ScreenFx.Flash(0.3, t8.LUCK)
    UIKit.sound("Unlock", 1.1)

    for _, v92 in ipairs(p43.Parts) do
        Debris:AddItem(v92, 1.5)
    end
end

function t8.Cancel(p45) -- line: 825
    if p45.Conn then
        p45.Conn:Disconnect()
        p45.Conn = nil
    end

    for _, v93 in ipairs(p45.Parts) do
        v93:Destroy()
    end
end

local v94
local v95 = false
local MoveLock = require(script.Parent.MoveLock)

local function releaseLock() -- line: 840
    -- upvalues: v94 (ref), MoveLock (copy)
    v94 = v94 and nil
    MoveLock.Free("aim")
end

local function startAiming(p46, p47) -- line: 847
    -- upvalues: UIKit (copy), HUD (copy), CurrentCamera (copy), t1 (copy), v2 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), n1 (ref), v13 (ref), v14 (ref), v15 (ref), v16 (ref), equipRod (copy), refreshLucky (copy), refreshAuto (copy), v67 (ref), v76 (copy), v94 (ref), MoveLock (copy)
    t1.State = "aiming"
    n1 = os.clock()
    t1.AutoRun = false
    t1.AutoTarget = nil
    v13 = nil

    if p46:FindFirstChildOfClass("Humanoid") then
        v94 = true
        MoveLock.Hold("aim")
    end

    p47.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    p46:PivotTo(CFrame.new(0, p47.Position.Y, 2))
    HUD.SetMode("cast")
    v2.Visible = true
    refreshLucky()
    refreshAuto()
    v5.Visible = true
    v6.Visible = true
    v7.Visible = false
    v8.Visible = false
    UIKit.pop(v2, 0.7)
    equipRod(p46)

    local RightUpperArm = p46:FindFirstChild("RightUpperArm")
    local v96, v97

    if not (RightUpperArm and RightUpperArm:FindFirstChild("RightShoulder")) then
        local Torso = p46:FindFirstChild("Torso")

        if Torso and Torso:FindFirstChild("Right Shoulder") then
            v96 = Torso["Right Shoulder"]
            v97 = "Z"
        end
    else
        v96 = RightUpperArm.RightShoulder
        v97 = "X"
    end

    v14 = v96
    v15 = v97
    v16 = nil
    v76:Preload(p46)
    v76:Idle(p46)
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    UIKit.sound("MeterShow")

    if v67 then
        v67:Show()
    end
end

local function restoreCamera() -- line: 874
    -- upvalues: LocalPlayer (copy), CurrentCamera (copy)
    local Character = LocalPlayer.Character
    local v98 = Character

    if Character then
        v98 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not (v98 and Character and Character.Health > 0) then
        Character = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if Character then
        CurrentCamera.CameraSubject = Character
    end

    CurrentCamera.FieldOfView = 70
end

local function stopAiming() -- line: 883
    -- upvalues: HUD (copy), LocalPlayer (copy), CurrentCamera (copy), t1 (copy), v2 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), Model (ref), v16 (ref), v17 (ref), refreshLucky (copy), refreshAuto (copy), v67 (ref), v76 (copy), v94 (ref), MoveLock (copy)
    t1.State = "idle"

    if v67 then
        v67:Hide()
    end

    v94 = v94 and nil
    MoveLock.Free("aim")
    v2.Visible = false
    refreshLucky()
    refreshAuto()
    v5.Visible = true
    v6.Visible = false
    v7.Visible = false
    v8.Visible = false

    if Model then
        Model:Destroy()
        Model = nil
    end

    v16 = nil
    v17 = nil
    v76:StopAll()

    local Character = LocalPlayer.Character
    local v99 = Character

    if Character then
        v99 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not (v99 and Character and Character.Health > 0) then
        Character = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if Character then
        CurrentCamera.CameraSubject = Character
    end

    CurrentCamera.FieldOfView = 70
    HUD.SetMode("normal")
end

local function ratingFor(p48) -- line: 898
    -- upvalues: fromRGB (copy)
    if p48 >= 19 then
        return "PERFECT!", fromRGB(110, 255, 90)
    end

    if p48 >= 15 then
        return "GREAT!", fromRGB(200, 255, 80)
    end

    if p48 >= 8 then
        return "GOOD", fromRGB(255, 225, 70)
    end

    return "OK", fromRGB(255, 160, 60)
end

local function finish(_, _, p51, p52) -- line: 910
    -- upvalues: HUD (copy), ScreenFx (copy), LocalPlayer (copy), CurrentCamera (copy), t1 (copy), v2 (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), n3 (ref), Model (ref), v16 (ref), v17 (ref), v76 (copy), MoveLock (copy)
    local SkipButton = require(script.Parent.SkipButton)
    local CutsceneFx = require(script.Parent.CutsceneFx)

    SkipButton.Hide("cast")

    if CutsceneFx.SkipNext then
        CutsceneFx.SkipNext = false
        SkipButton.Cover(false, 0.3)
    end

    if Model then
        Model:Destroy()
        Model = nil
    end

    v16 = nil
    v17 = nil
    v76:StopAll()
    MoveLock.Free("cast")
    MoveLock.Free("aim")

    if p51 then
        if p51.bobber then
            p51.bobber:Destroy()
        end

        if p51.line then
            p51.line:Destroy()
        end
    end

    v2.Visible = false
    v6.Visible = false
    v7.Visible = false
    v8.Visible = false
    v10.Visible = false
    t1.State = "finishing"

    local Character = LocalPlayer.Character
    local v100 = Character

    if Character then
        v100 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    if not (v100 and Character and Character.Health > 0) then
        Character = nil
    end

    CurrentCamera.CameraType = Enum.CameraType.Custom

    if Character then
        CurrentCamera.CameraSubject = Character
    end

    CurrentCamera.FieldOfView = 70

    if p52 and p52.ok and t1.AfterCatch and not t1.AutoRun then
        local AfterCatch = t1.AfterCatch
        local ok, result = pcall(AfterCatch, p52)

        if not ok then
            warn("[CastController] after-catch failed: " .. tostring(result))
        end
    end

    ScreenFx.Letterbox(false, 0.2)
    ScreenFx.Fade(0, 0.45)
    HUD.SetMode("normal")
    n3 = os.clock()
    t1.State = "idle"
end

local function sequence() -- line: 956
    -- upvalues: Players (copy), RunService (copy), Debris (copy), ReplicatedStorage (copy), Shared (copy), GameConfig (copy), Zones (copy), Variants (copy), Sizes (copy), NumberFormat (copy), Remotes (copy), UIKit (copy), HUD (copy), DataClient (copy), Toasts (copy), ScreenFx (copy), LocalPlayer (copy), CurrentCamera (copy), fromRGB (copy), new (copy), t1 (copy), v2 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v10 (ref), v11 (ref), v12 (ref), n2 (ref), Model (ref), v14 (ref), v15 (ref), v16 (ref), Waist (ref), v17 (ref), checkpoint (copy), makeBobber (copy), splash (copy), biteMark (copy), v76 (copy), t8 (copy), v94 (ref), MoveLock (copy), stopAiming (copy), ratingFor (copy), finish (copy)
    local Character = LocalPlayer.Character
    local v101, v102

    if Character then
        v101 = Character:FindFirstChild("HumanoidRootPart")
        v102 = Character:FindFirstChildOfClass("Humanoid")
    else
        v102 = Character
        v101 = Character
    end

    if not (v101 and v102 and v102.Health > 0) then
        Character = nil
        v101 = nil
        v102 = nil
    end

    if not Character then
        stopAiming()
    else
        local v103 = n2
        local t11 = {}

        MoveLock.Hold("cast")
        MoveLock.Free("aim")
        v94 = nil
        UIKit.pop(v4, 1.4)
        UIKit.sound(v103 >= 19 and "MeterPerfect" or "MeterLock")

        local v104, v105 = ratingFor(v103)

        v6.Visible = false
        v5.Visible = false
        v7.Text = v104
        v7.TextColor3 = v105
        v7.Visible = true
        UIKit.pop(v7, 1.6)

        local v106 = v8

        v106.Text = "+" .. v103 .. " POWER"
        v8.TextColor3 = v105
        v8.Visible = true
        UIKit.pop(v8, 1.5)
        HUD.SetMode("cutscene")
        ScreenFx.Letterbox(true, 0.3)
        v101.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        v101.CFrame = CFrame.new(v101.Position)

        local UseLucky = t1.UseLucky

        t1.UseLucky = false

        local v107

        task.spawn(function() -- line: 992
            -- upvalues: v103 (copy), UseLucky (copy), v107 (ref), ReplicatedStorage (copy), Remotes (copy)
            local function v108() -- line: 993
                -- upvalues: v103 (copy), UseLucky (copy), Remotes (copy)
                return Remotes.Cast:InvokeServer(v103, UseLucky)
            end

            local ok, result = pcall(v108)

            if not ok or type(result) ~= "table" then
                result = {
                    ok = false,
                    reason = "Connection problem"
                }
            end

            v107 = result

            if v107.ok and v107.fishId then
                local function v109() -- line: 1000
                    -- upvalues: v107 (ref), ReplicatedStorage (copy)
                    local FishModels = require(ReplicatedStorage.Shared.FishModels)
                    local v110 = v107.variant or 1
                    local v111 = v107.size or 1

                    if v110 ~= 1 or v111 ~= 1 then
                        FishModels.Warm(v107.fishId, 1, 1, 1)
                        FishModels.Warm(v107.fishId, v110, v111, 1)
                    else
                        FishModels.Warm(v107.fishId, 1, 1, 2)
                    end
                end

                pcall(v109)
            end

            if not (v107.ok and v107.lucky) then
                return
            end

            require(script.Parent.Toasts).Show("gold", "LUCKY CAST!  " .. tostring(v107.luckyLeft or 0) .. " left")
        end)
        task.wait(0.5 / 1)
        checkpoint("locked")
        v2.Visible = false
        v7.Visible = false
        v8.Visible = false

        local RightUpperArm = Character:FindFirstChild("RightUpperArm")
        local NumberValue2
        local NumberValue

        if not (RightUpperArm and RightUpperArm:FindFirstChild("RightShoulder")) then
            RightUpperArm = Character:FindFirstChild("Torso")

            if not (RightUpperArm and RightUpperArm:FindFirstChild("Right Shoulder")) then
                NumberValue = nil
            else
                NumberValue = RightUpperArm["Right Shoulder"]
                NumberValue2 = "Z"
            end
        else
            NumberValue = RightUpperArm.RightShoulder
            NumberValue2 = "X"
        end

        v14 = NumberValue
        v15 = NumberValue2
        NumberValue = Character:FindFirstChild("UpperTorso")
        Waist = NumberValue and NumberValue:FindFirstChild("Waist")
        v17 = nil
        v16 = nil
        NumberValue = Instance.new("NumberValue")
        NumberValue2 = Instance.new("NumberValue")
        NumberValue2.Changed:Connect(function(p53) -- line: 1031
            -- upvalues: v17 (ref)
            v17 = v17 and p53
        end)
        RightUpperArm = math.clamp(v103 / GameConfig.METER_MAX, 0, 1) * 0.45 + 0.55

        local Position = v101.Position
        local v114 = RaycastParams.new()

        v114.FilterDescendantsInstances = { Character }
        v114.FilterType = Enum.RaycastFilterType.Exclude

        local v113 = workspace:Raycast(Position, Vector3.new(0, -12, 0), v114)

        v114 = if v113 then v113.Position else Position - Vector3.new(0, 3, 0)

        local function ring(p54, p55, p56, p57, p58, p59) -- line: 1043
            -- upvalues: v114 (ref), Debris (copy), UIKit (copy), new (copy)
            local Part = Instance.new("Part")

            Part.Shape = Enum.PartType.Cylinder
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Material = Enum.Material.Neon
            Part.Color = p57
            Part.Transparency = p58
            Part.Size = new(0.2, p54, p54)
            Part.CFrame = CFrame.new(v114 + Vector3.new(0, 0.15, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
            Part.Parent = workspace
            UIKit.tween(Part, p56, {
                Size = new(0.2, p55, p55),
                Transparency = p59
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Debris:AddItem(Part, p56 + 0.1)
        end

        local v115 = Model and Model:FindFirstChild("Tip", true)
        local Part, connection, Attachment, v116

        if v115 then
            local Part2 = Instance.new("Part")

            Part = Part2
            Part2.Shape = Enum.PartType.Ball
            Part2.Anchored = true
            Part2.CanCollide = false
            Part2.CanQuery = false
            Part2.CanTouch = false
            Part2.CastShadow = false
            Part2.Material = Enum.Material.Neon
            Part2.Color = v105
            Part2.Size = Vector3.new(0.3, 0.3, 0.3)
            Part2.Position = v115.WorldPosition
            Attachment = Instance.new("PointLight")
            Attachment.Color = v105
            Attachment.Range = 14
            Attachment.Brightness = 2.5
            Attachment.Parent = Part2
            Attachment = Instance.new("ParticleEmitter")
            Attachment.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            Attachment.Color = ColorSequence.new(Color3.new(1, 1, 1), v105)
            Attachment.LightEmission = 1
            Attachment.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.7),
                NumberSequenceKeypoint.new(1, 0)
            })
            Attachment.Lifetime = NumberRange.new(0.25, 0.5)
            Attachment.Speed = NumberRange.new(4, 10)
            Attachment.SpreadAngle = Vector2.new(180, 180)
            Attachment.Rate = RightUpperArm * 60
            Attachment.Parent = Part2
            Part2.Parent = workspace
            connection = RunService.RenderStepped:Connect(function() -- line: 1091
                -- upvalues: Part (ref), v115 (copy)
                if v115.Parent then
                    Part.Position = v115.WorldPosition
                end
            end)
            UIKit.tween(Part, 0.6, {
                Size = Vector3.new(1.5, 1.5, 1.5) * RightUpperArm
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            Attachment = Instance.new("Attachment")
            Attachment.Position = Vector3.new(0, 0, 1.8)
            Attachment.Parent = v115.Parent
            v116 = Instance.new("Trail")
            v116.Attachment0 = v115
            v116.Attachment1 = Attachment
            v116.Lifetime = 0.28
            v116.LightEmission = 1
            v116.FaceCamera = true
            v116.Color = ColorSequence.new(Color3.new(1, 1, 1), v105)
            v116.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(1, 1)
            })
            v116.Parent = v115.Parent
        end

        ring(26, 5, 0.6, v105, 0.85, 0.2)
        CurrentCamera.FieldOfView = 60
        Attachment = CFrame.lookAt(Position + Vector3.new(12, -0.4, -8), Position + Vector3.new(0, 2.2, 0.5))
        v116 = CFrame.lookAt(Position + Vector3.new(9, 0.2, -6), Position + Vector3.new(0, 3.2, 1.4)) * CFrame.Angles(0, 0, -0.08726646259971647)

        local v117 = CFrame.lookAt(Position + Vector3.new(8, 1, -9.5), Position + Vector3.new(0, 2.4, -3))

        CurrentCamera.CFrame = Attachment

        local v119 = math.max(v76:Cast(Character, UseLucky == true, 1) - 0.09, 0.2)

        Attachment = if UseLucky then t8.LuckCharge(v101, v114) else nil

        if Part then
            UIKit.tween(Part, v119, {
                Size = Vector3.new(1.5, 1.5, 1.5) * RightUpperArm
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        end

        UIKit.tween(CurrentCamera, v119, {
            FieldOfView = 54,
            CFrame = v116
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        UIKit.sound("CastWindup")
        task.wait(v119)
        checkpoint("windup")

        if Part then
            UIKit.tween(Part, 0.09, {
                Size = Vector3.new(2.4, 2.4, 2.4) * RightUpperArm
            })
        end

        task.wait(0.09)
        UIKit.sound("CastRelease", 0.85)

        if Attachment then
            Attachment:Release(v105)
        end

        ring(4, RightUpperArm * 34 + 10, 0.4, Color3.new(1, 1, 1), 0.1, 1)
        ring(3, RightUpperArm * 22 + 6, 0.55, v105, 0.25, 1)

        if v103 >= 19 then
            ring(6, 70, 0.7, v105, 0.3, 1)
            ScreenFx.Flash(0.25, v105)
            t8.Perfect(v114, v105)
        end

        v119 = Instance.new("Part")
        v119.Anchored = true
        v119.CanCollide = false
        v119.CanQuery = false
        v119.CanTouch = false
        v119.Transparency = 1
        v119.Size = Vector3.new(5, 0.2, 5)
        v119.CFrame = CFrame.new(v114)
        v119.Parent = workspace

        local v118 = Instance.new("ParticleEmitter")

        v118.Color = ColorSequence.new(fromRGB(255, 255, 255))
        v118.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 2.6)
        })
        v118.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
        v118.Lifetime = NumberRange.new(0.35, 0.7)
        v118.Speed = NumberRange.new(14, 30)
        v118.SpreadAngle = Vector2.new(88, 88)
        v118.Drag = 4
        v118.EmissionDirection = Enum.NormalId.Top
        v118.Rate = 0
        v118.Parent = v119

        local v120 = RightUpperArm * 34

        v118:Emit((math.floor(v120)))
        Debris:AddItem(v119, 1.2)

        local v121

        if Part then
            v118 = Part:FindFirstChildOfClass("ParticleEmitter")

            if v118 then
                v118.Speed = NumberRange.new(20, 40)
                v120 = RightUpperArm * 40
                v118:Emit((math.floor(v120)))
                v118.Rate = 0
            end

            UIKit.tween(Part, 0.18, {
                Size = Vector3.new(0.1, 0.1, 0.1),
                Transparency = 1
            })
            v118 = Part:FindFirstChildOfClass("PointLight")

            if v118 then
                UIKit.tween(v118, 0.18, {
                    Brightness = 0
                })
            end

            local Part2 = Part

            v121 = task.delay

            local connection2 = connection

            v121(0.6, function() -- line: 1180
                -- upvalues: Part2 (copy), connection2 (copy)
                if connection2 then
                    connection2:Disconnect()
                end

                Part2:Destroy()
            end)
        end

        v118 = os.clock()

        local v122, v123, v124, v125, result, v126, v127

        while true do
            local v128 = (os.clock() - v118) / 0.09

            if v128 >= 1 then
                break
            end

            local v129 = 1 - (1 - v128) ^ 3

            v122 = (1 - v128) ^ 2 * 0.6 * RightUpperArm
            v123 = v116:Lerp(v117, v129) * CFrame.new(math.noise(v128 * 23, 1.5) * 2 * v122, math.noise(v128 * 23, 7.5) * 2 * v122, 0)
            v124 = CFrame.Angles
            result = 5 * v122
            v126 = v128 * 40
            v125 = result * math.sin(v126)
            CurrentCamera.CFrame = v123 * v124(0, 0, (math.rad(v125)))
            v124 = RightUpperArm * 24
            result = v128 * 1.5
            v127 = math.min(result, 1) * 3.141592653589793 / 2
            CurrentCamera.FieldOfView = v124 * math.sin(v127) + 54
            ScreenFx.SpeedLines((1 - v128) * RightUpperArm, v105)
            RunService.RenderStepped:Wait()
        end

        ScreenFx.SpeedLines(0)
        NumberValue2:Destroy()
        v117 = 0
        checkpoint("whip")

        while not v107 and v117 < 8 do
            v117 += task.wait()
        end

        v107 = v107 or {
            ok = false,
            reason = "Connection problem"
        }

        if not v107.ok then
            Toasts.Show("error", v107.reason or "Cast failed")

            if t1.AutoRun then
                t1.SetAuto(false)
                Toasts.Show("info", "Auto Cast turned off")
            end

            NumberValue:Destroy()
            finish(Character, v102, t11)
        else
            ScreenFx.Letterbox(false, 0.3)
            v117 = Model and Model:FindFirstChild("Tip", true)
            v116 = if v117 then v117.WorldPosition else Position + Vector3.new(0, 5, -3)
            v121 = Position.X
            v122 = math.clamp(v121, -4, 4)
            v121 = GameConfig.WATER_Y + 0.85
            v120 = GameConfig.DOCK_Z - v107.distance

            local v130 = new(v122, v121, v120)

            task.spawn(function() -- line: 1227
                -- upvalues: v130 (copy), Players (copy), GameConfig (copy), new (copy), t1 (copy)
                local v131 = new(v130.X, GameConfig.SEABED_Y, v130.Z)
                local elapsed = os.clock()

                repeat
                    local function v132() -- line: 1231
                        -- upvalues: v131 (copy), Players (copy)
                        Players.LocalPlayer:RequestStreamAroundAsync(v131, 6)
                    end

                    pcall(v132)
                    task.wait(2)
                until t1.State == "idle" or os.clock() - elapsed > 120
            end)
            v118, v122 = makeBobber(v116)
            t11.bobber = v118
            v121 = v118.PrimaryPart:FindFirstChildOfClass("Trail")

            local Sparks = v118.PrimaryPart:FindFirstChild("Sparks")
            local Glow = v118.PrimaryPart:FindFirstChild("Glow")

            if v121 then
                v121.Color = ColorSequence.new(Color3.new(1, 1, 1), v105)
            end

            if Sparks then
                Sparks.Color = ColorSequence.new(Color3.new(1, 1, 1), v105)
            end

            if Glow then
                Glow.Color = v105
            end

            if v117 then
                v121 = Instance.new("Beam")
                v121.Attachment0 = v117
                v121.Attachment1 = v122
                v121.Width0 = 0.1
                v121.Width1 = 0.1
                v121.FaceCamera = true
                v121.Segments = 1
                v121.Color = ColorSequence.new(fromRGB(255, 255, 255))
                v121.Transparency = NumberSequence.new(0.35)
                v121.Parent = workspace
                t11.line = v121
            end

            v123 = v107.distance
            v117 = math.min(v123, 2184) / 420 + 1.3
            v124 = v117 + math.max(0, v107.distance - 2184) / GameConfig.ZONE_LENGTH * 0.45
            v120 = math.clamp(v124, 1.7, 11) / 1

            local v134 = false
            local SkipButton = require(script.Parent.SkipButton)

            local function skipNow() -- line: 1275
                -- upvalues: v134 (ref), SkipButton (copy)
                v134 = true
                require(script.Parent.CutsceneFx).SkipNext = true
                SkipButton.Cover(true, 0.12)
            end

            SkipButton.Show("cast", skipNow)
            v124 = DataClient.Get("Settings")

            local v133 = LocalPlayer:GetAttribute("OwnsSkipCutscene") == true and not (v124 and v124.SkipCutscenes == false)

            v124 = (require(Shared.Roll).legend(v107.fishId) or 0) > 0

            if v133 and not v124 then
                SkipButton.Hide("cast")
                v134 = true
                require(script.Parent.CutsceneFx).SkipNext = true
                SkipButton.Cover(true, 0.12)
            end

            v124 = math.clamp(v107.distance * 0.16, 16, 130)

            local v135 = v107.luck / v107.distanceLuck

            v10.Visible = true
            UIKit.pop(v10, 0.6)
            UIKit.sound("Flight")
            v133 = 0
            v127 = nil

            local v136 = os.clock()
            local v137, v138, _CFrame, v139, v140

            while true do
                result = (os.clock() - v136) / v120
                v125 = math.min(result, 1)
                v137 = v116:Lerp(v130, v125)
                _CFrame = 4 * v124 * v125 * (1 - v125)
                result = v137 + new(0, _CFrame, 0)
                v118:PivotTo(CFrame.new(result) * CFrame.Angles(v125 * 14, 0, 0))
                v126 = v125 * 3.141592653589793
                v137 = math.sin(v126)

                local v141 = CFrame.lookAt(result + Vector3.new(0, 5.5, 16), result + Vector3.new(0, -3, -30))

                _CFrame = CFrame.Angles
                v138 = v125 * 9
                v126 = v141 * _CFrame(0, 0, math.sin(v138) * 0.04 * v137)
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v126, v125 < 0.08 and 0.12 or 0.3)
                CurrentCamera.FieldOfView += (70 + 13 * v137 - CurrentCamera.FieldOfView) * 0.14
                v141 = ScreenFx.SpeedLines
                v140 = v137 * 0.5
                v139 = v107.distance / 600
                v141(v140 * math.clamp(v139, 0.35, 1), v105)
                v141 = GameConfig.DOCK_Z - result.Z
                v140 = v107.distance
                v126 = math.clamp(v141, 0, v140)
                v137 = GameConfig.luckForDistance(v126) * v135
                v141 = v11
                v141.Text = NumberFormat.luck(v137)
                v141 = v11

                if v137 >= 2 then
                    v141.TextColor3 = fromRGB(255, 215, 60)
                else
                    v141.TextColor3 = fromRGB(255, 255, 255)
                end

                _CFrame = v137 * 10
                v141 = math.floor(_CFrame)

                if v133 < v141 then
                    v133 = v141
                    UIKit.pop(v11, 1.12)
                    UIKit.sound("LuckTick", (math.clamp(0.9 + v137 * 0.12, 0.9, 2.2)))
                end

                v141 = Zones.List
                v139 = v126 / GameConfig.ZONE_LENGTH
                v140 = math.floor(v139) + 1
                v139 = #Zones.List
                v137 = v141[math.clamp(v140, 1, v139)]

                if v137 ~= v127 then
                    v127 = v137
                    v141 = v12
                    v141.Text = v137.name .. " " .. v137.icon
                    v141 = v12
                    v141.TextColor3 = v137.Color
                    UIKit.pop(v12, 1.3)
                    UIKit.sound("ZoneChange")
                end

                if v125 >= 0.5 then
                    v136 += checkpoint("midflight")
                end

                if v125 >= 1 or v134 then
                    break
                end

                RunService.RenderStepped:Wait()
            end

            if v134 then
                v118:PivotTo(CFrame.new(v130))
            end

            ScreenFx.SpeedLines(0)
            v136 = v118.PrimaryPart:FindFirstChild("Sparks")

            if v136 then
                v136.Enabled = false
            end

            v125 = v11
            v125.Text = NumberFormat.luck(v107.luck)
            UIKit.pop(v11, 1.3)
            splash(v130)
            CurrentCamera.FieldOfView = 65
            UIKit.tween(CurrentCamera, 0.35, {
                FieldOfView = 70
            }, Enum.EasingStyle.Back)
            v125 = CFrame.lookAt(v130 + Vector3.new(0, 7, 15), v130 + Vector3.new(0, 0, -4))
            v133 = os.clock()
            v124 = 0.9 / 1
            v120 = false

            while os.clock() - v133 < v124 and not v134 do
                local v143 = os.clock() - v133
                local v144 = v143 / v124

                if not v120 then
                    UIKit.sound("Reel", 0.8 + 0.9 * v144)
                end

                local v145, v146, v147

                if v144 > 0.6 then
                    local v148, v149

                    if v120 then
                        v148 = v133
                        v149 = v120
                    else
                        if UIKit.SoundStopHandler then
                            UIKit.SoundStopHandler("Reel", 0.12)
                        end

                        UIKit.sound("MeterLock", 1.5)
                        UIKit.sound("BiteHit", 1.3)
                        biteMark(v130)
                        require(script.Parent.CutsceneFx).Haptic(2)
                        task.wait(0.06)
                        v148 = v133 + 0.06
                        v149 = true
                    end

                    v146 = v148
                    _CFrame = (v144 - 0.6) / 0.3
                    v137 = math.min(_CFrame, 1) * 3.141592653589793 * 0.8
                    v145 = -1.5 * math.sin(v137)
                    v147 = v149
                else
                    v146 = v133
                    v145 = 0
                    v147 = v120
                end

                v133 = v146
                v137 = CFrame.new
                v139 = math.sin(v143 * 9) * 0.35
                v138 = 1 - v143
                v140 = v139 * math.max(0, v138) + v145
                v118:PivotTo(v137(v130 + new(0, v140, 0)))
                v137 = 1 - v143 / 0.25
                v117 = math.max(0, v137) * 0.6
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v125, 0.1) * CFrame.new((math.random() - 0.5) * v117, (math.random() - 0.5) * v117, 0)
                RunService.RenderStepped:Wait()
                v120 = v147
            end

            checkpoint("landed")
            SkipButton.Hide("cast")
            ScreenFx.Fade(1, v134 and 0.05 or 0.5, Color3.new(0, 0, 0))
            task.wait(v134 and 0.05 or 0.5)

            if UIKit.SoundStopHandler then
                UIKit.SoundStopHandler("Reel", 0.1)
            end

            v125 = v10
            v125.Visible = false

            if t11.bobber then
                t11.bobber:Destroy()
                t11.bobber = nil
            end

            if t11.line then
                t11.line:Destroy()
                t11.line = nil
            end

            NumberValue:Destroy()

            if t1.OnCaught then
                result = t1.OnCaught

                local v151 = v107
                local ok

                ok, result = pcall(result, v151, v130)

                if not ok then
                    warn("[CastController] reveal failed: " .. tostring(result))
                end
            else
                v127 = Variants.List[v107.variant]

                local v152 = Sizes.List[v107.size]
                local v153 = if v127.index > 1 then v127.id .. " " else ""

                result = if v152.index == Sizes.NORMAL_INDEX then "" else v152.id .. " "
                v153 ..= result .. v107.name
                Toasts.Show("gold", "Caught " .. v153 .. "!  " .. NumberFormat.rate(v107.income))
            end

            finish(Character, v102, t11, v107)
        end
    end
end

function t1.Exit() -- line: 1417
    -- upvalues: UIKit (copy), t1 (copy), v95 (ref), stopAiming (copy)
    if t1.State ~= "aiming" then
        return false
    end

    v95 = true
    stopAiming()
    UIKit.sound("Click")

    return true
end

function t1.Tap(p60) -- line: 1427
    -- upvalues: LocalPlayer (copy), t1 (copy), v67 (ref), finish (copy), sequence (copy)
    if t1.State ~= "aiming" then
        return false
    end

    t1.State = "busy"

    if v67 then
        v67:Hide()
    end

    t1.AutoRun = p60 == true
    task.spawn(function() -- line: 1436
        -- upvalues: LocalPlayer (copy), finish (copy), sequence (copy)
        local ok, result = pcall(sequence)

        if ok then
            return
        end

        warn("[CastController] sequence error: " .. tostring(result))

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if not (HumanoidRootPart and Humanoid and Humanoid.Health > 0) then
            Character = nil
            Humanoid = nil
        end

        finish(Character, Humanoid, nil)
    end)

    return true
end

local function buildGui() -- line: 1448
    -- upvalues: UIKit (copy), HUD (copy), DataClient (copy), Pad (copy), LocalPlayer (copy), fromRGB (copy), t1 (copy), v1 (ref), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), refreshLucky (copy), v43 (ref), n5 (ref), refreshAuto (copy)
    v1 = UIKit.screenGui("Cast", 8)
    v2 = UIKit.frame(v1, {
        Name = "Meter",
        Transparency = 1,
        Size = UDim2.fromOffset(700, 460),
        Position = UDim2.fromScale(0.5, 0.44),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    v3 = UIKit.frame(v2, {
        Name = "Bar",
        Corner = 48,
        Stroke = 9,
        Size = UDim2.fromOffset(96, 440),
        Position = UDim2.new(0.5, 0, 0, 10),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(255, 255, 255)
    })

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, fromRGB(110, 235, 70)),
        ColorSequenceKeypoint.new(0.3, fromRGB(190, 235, 70)),
        ColorSequenceKeypoint.new(0.55, fromRGB(255, 215, 60)),
        ColorSequenceKeypoint.new(0.8, fromRGB(255, 140, 50)),
        ColorSequenceKeypoint.new(1, fromRGB(240, 70, 60))
    })
    UIGradient.Parent = v3

    for i = 1, 7 do
        UIKit.frame(v3, {
            Name = "Tick",
            Transparency = 0.72,
            Size = UDim2.new(1, -8, 0, 4),
            Position = UDim2.new(0, 4, i / 8, -2),
            Color = fromRGB(20, 20, 30)
        })
    end

    v4 = UIKit.frame(v3, {
        Name = "Slider",
        Corner = 15,
        Stroke = 7,
        ZIndex = 3,
        Size = UDim2.new(1, 44, 0, 30),
        Position = UDim2.fromScale(0.5, 0.96),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(255, 255, 255)
    })
    v5 = UIKit.text(v2, {
        Name = "Bonus",
        Text = "+1",
        TextSize = 56,
        Stroke = 6,
        ZIndex = 3,
        Size = UDim2.fromOffset(160, 60),
        Position = UDim2.new(0.5, 86, 0, 430),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    })
    v8 = UIKit.text(v2, {
        Name = "Power",
        Text = "+1 POWER",
        TextSize = 60,
        Stroke = 6,
        ZIndex = 3,
        Size = UDim2.fromOffset(420, 70),
        Position = UDim2.new(0.5, 86, 0, 210),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left
    })
    v8.Visible = false
    v2.Visible = false
    v6 = UIKit.text(v1, {
        Name = "Prompt",
        Text = "TAP TO CAST!",
        TextSize = 72,
        Stroke = 7,
        Size = UDim2.fromOffset(900, 90),
        Position = UDim2.new(0.5, 0, 0.44, 250),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v9 = Pad.IconBeside(v6, Enum.KeyCode.ButtonA, 76)
    v6.Visible = false
    v7 = UIKit.text(v1, {
        Name = "Rating",
        Text = "GREAT!",
        TextSize = 84,
        Stroke = 8,
        Size = UDim2.fromOffset(900, 100),
        Position = UDim2.new(0.5, 0, 0.44, 244),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v7.Visible = false
    v10 = UIKit.frame(v1, {
        Name = "Luck",
        Transparency = 1,
        Size = UDim2.fromOffset(700, 250),
        Position = UDim2.new(0.5, 0, 0, 70),
        AnchorPoint = Vector2.new(0.5, 0)
    })
    v11 = UIKit.text(v10, {
        Name = "Number",
        Text = "1.00X",
        TextSize = 104,
        Stroke = 9,
        Size = UDim2.new(1, 0, 0, 110)
    })
    UIKit.text(v10, {
        Name = "Caption",
        Text = "LUCK",
        TextSize = 36,
        Stroke = 5,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.fromOffset(0, 106)
    })

    local v154 = UIKit.frame(v10, {
        Name = "Zone",
        Transparency = 0.4,
        Corner = 31,
        Size = UDim2.fromOffset(460, 62),
        Position = UDim2.new(0.5, 0, 0, 156),
        AnchorPoint = Vector2.new(0.5, 0),
        Color = fromRGB(20, 22, 34)
    })

    v12 = UIKit.text(v154, {
        Name = "ZoneName",
        Text = "",
        TextSize = 42,
        Stroke = 5
    })
    v10.Visible = false

    local Boosts = HUD.Boosts

    Boosts.OnLuck = function() -- line: 1488
        -- upvalues: t1 (copy)
        t1.ToggleLucky()
    end

    Boosts.OnAuto = function() -- line: 1491
        -- upvalues: t1 (copy)
        t1.ToggleAuto()
    end

    DataClient.Observe("LuckyCasts", refreshLucky)
    Pad.Changed:Connect(function() -- line: 1495
        -- upvalues: refreshAuto (copy)
        refreshAuto()
    end)
    task.spawn(function() -- line: 1498
        -- upvalues: v1 (ref), refreshLucky (copy), refreshAuto (copy)
        while v1.Parent do
            task.wait(1)
            refreshLucky()
            refreshAuto()
        end
    end)
    DataClient.Observe("Settings", function(p61) -- line: 1505
        -- upvalues: v43 (ref), refreshAuto (copy)
        v43 = type(p61) == "table" and p61.AutoCast == true
        refreshAuto()
    end)
    LocalPlayer:GetAttributeChangedSignal("OwnsAutoCast"):Connect(function() -- line: 1509
        -- upvalues: t1 (copy), n5 (ref), refreshAuto (copy)
        if t1.OwnsAuto() and os.clock() - n5 < 300 then
            t1.SetAuto(true)
            n5 = -1000
        end

        refreshAuto()
    end)
end

function t1.Init() -- line: 1518
    -- upvalues: RunService (copy), UserInputService (copy), GuiService (copy), GameConfig (copy), UIKit (copy), HUD (copy), DataClient (copy), LocalPlayer (copy), CurrentCamera (copy), new (copy), t1 (copy), v4 (ref), v5 (ref), v6 (ref), n1 (ref), v13 (ref), n2 (ref), n3 (ref), v14 (ref), v15 (ref), v16 (ref), Waist (ref), v17 (ref), t3 (copy), v67 (ref), v95 (ref), startAiming (copy), stopAiming (copy), buildGui (copy)
    buildGui()
    v67 = t3.new(t1.Exit)
    UserInputService.InputBegan:Connect(function(p62, p63) -- line: 1522
        -- upvalues: GuiService (copy), HUD (copy), t1 (copy), n1 (ref)
        if t1.State == "aiming" then
            if p62.KeyCode == Enum.KeyCode.ButtonB or p62.KeyCode == Enum.KeyCode.Q and not p63 then
                t1.Exit()
            elseif p62.KeyCode == Enum.KeyCode.ButtonY then
                t1.ToggleLucky()
            elseif p62.KeyCode == Enum.KeyCode.ButtonX then
                if HUD.Boosts and HUD.Boosts:AutoShown() then
                    t1.ToggleAuto()
                end
            else
                local UserInputType = p62.UserInputType
                local v155, v156

                if UserInputType == Enum.UserInputType.MouseButton1 then
                    local v157 = not p63

                    if v157 then
                        v155 = v157
                        v156 = true
                    elseif UserInputType == Enum.UserInputType.Touch then
                        local v158 = not p63

                        if v158 then
                            v155 = v158
                            v156 = true
                        else
                            v156 = false
                        end
                    else
                        v156 = false
                    end
                elseif UserInputType == Enum.UserInputType.Touch then
                    local v159 = not p63

                    if v159 then
                        v155 = v159
                        v156 = true
                    else
                        v156 = false
                    end
                else
                    v156 = false
                end

                if not v156 then
                    v155 = p62.KeyCode == Enum.KeyCode.ButtonA and GuiService.SelectedObject == nil or p62.KeyCode == Enum.KeyCode.ButtonR2 or p62.KeyCode == Enum.KeyCode.E and not p63
                end

                if v155 and os.clock() - n1 > 0.25 then
                    t1.Tap()
                end
            end
        end
    end)
    RunService.RenderStepped:Connect(function(p64) -- line: 1554
        -- upvalues: GameConfig (copy), UIKit (copy), HUD (copy), DataClient (copy), LocalPlayer (copy), CurrentCamera (copy), new (copy), t1 (copy), v4 (ref), v5 (ref), v6 (ref), n1 (ref), v13 (ref), n2 (ref), n3 (ref), v95 (ref), startAiming (copy), stopAiming (copy)
        local Character = LocalPlayer.Character
        local v160, v161

        if Character then
            v160 = Character:FindFirstChild("HumanoidRootPart")
            v161 = Character:FindFirstChildOfClass("Humanoid")
        else
            v161 = Character
            v160 = Character
        end

        if not (v160 and v161 and v161.Health > 0) then
            Character = nil
            v160 = nil
        end

        if t1.State == "busy" then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
        elseif t1.State == "idle" then
            if v95 then
                if v160 then
                    local Position = v160.Position

                    if not (math.abs(Position.X) <= GameConfig.LANE_HALF_WIDTH - 2 and Position.Z <= 9.5 and Position.Z >= GameConfig.DOCK_Z - 1 and Position.Y < 9 and Position.Y > -1) then
                        v95 = false
                    end
                else
                    v95 = false
                end
            end

            if Character and not v95 and t1.Enabled and DataClient.IsReady() then
                local Position = v160.Position
                local v162 = math.abs(Position.X) <= GameConfig.LANE_HALF_WIDTH - 2 and Position.Z <= 9.5 and Position.Z >= GameConfig.DOCK_Z - 1 and Position.Y < 9 and Position.Y > -1

                if v162 and not UIKit.anyWindowOpen() and HUD.GetMode() == "normal" and os.clock() - n3 > 0.6 then
                    startAiming(Character, v160)
                end
            end
        elseif t1.State == "aiming" then
            local v163 = false

            if Character then
                local Position = v160.Position

                if math.abs(Position.X) <= GameConfig.LANE_HALF_WIDTH - 2 and Position.Z <= 9.5 and Position.Z >= GameConfig.DOCK_Z - 1 and Position.Y < 9 and Position.Y > -1 then
                    v163 = not UIKit.anyWindowOpen()
                end
            end

            if not v163 then
                stopAiming()
            else
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid and Humanoid.MoveDirection.Magnitude > 0.2 and os.clock() - n1 > 0.5 then
                    v95 = true
                    stopAiming()
                else
                    local v164 = (os.clock() - n1) / 1 % 2

                    if not (v164 < 1) then
                        v164 = 2 - v164
                    end

                    n2 = math.clamp(math.floor(GameConfig.METER_MIN + v164 * (GameConfig.METER_MAX - GameConfig.METER_MIN) + 0.5), GameConfig.METER_MIN, GameConfig.METER_MAX)

                    local v167 = 0.96 - 0.92 * v164

                    v4.Position = UDim2.fromScale(0.5, v167)
                    v5.Position = UDim2.new(0.5, 86, 0, 10 + 440 * v167)

                    local v170 = "+" .. n2

                    if v5.Text ~= v170 then
                        v5.Text = v170
                        UIKit.sound("MeterTick", n2 * 0.04 + 0.8)
                    end

                    local v171 = v13

                    v13 = n2

                    if t1.AutoOn() and os.clock() - n1 > 1.2 then
                        t1.AutoTarget = t1.AutoTarget or math.random(9, 16)

                        local AutoTarget = t1.AutoTarget

                        if v171 ~= nil and (v171 - AutoTarget) * (n2 - AutoTarget) <= 0 or os.clock() - n1 > 6 then
                            n2 = AutoTarget
                            t1.Tap(true)

                            return
                        end
                    end

                    UIKit.scaleOf(v6).Scale = math.sin(os.clock() * 6) * 0.05 + 1

                    local Position = v160.Position
                    local v179 = CFrame.lookAt(Position + Vector3.new(4.2, 2.4, 9), (new(Position.X + 1.8, Position.Y + 0.6, Position.Z - 45)))

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v179, 1 - math.exp(-9 * p64))
                end
            end
        end
    end)
    RunService.Stepped:Connect(function() -- line: 1615
        -- upvalues: v14 (ref), v15 (ref), v16 (ref), Waist (ref), v17 (ref)
        if v17 and Waist and Waist.Parent then
            local v181 = v17

            Waist.Transform = Waist.Transform * (if v181 < 0 then CFrame.Angles(0.2792526803190927 * -v181, -0.6632251157578453 * -v181, 0) else CFrame.Angles(-0.4537856055185257 * v181, 0.4886921905584123 * v181, 0))
        end

        if not (v16 and v14 and v14.Parent) then
            return
        end

        local v182 = v14

        if v15 == "X" then
            v182.Transform = CFrame.Angles(v16, 0, 0)
        else
            v182.Transform = CFrame.Angles(0, 0, v16)
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 1625
        -- upvalues: t1 (copy), stopAiming (copy)
        if t1.State == "aiming" then
            stopAiming()
        end
    end)
end

return t1
