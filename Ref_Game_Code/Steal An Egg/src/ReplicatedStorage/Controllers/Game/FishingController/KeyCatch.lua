-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GearToolLookup = require(ReplicatedStorage.Shared.Util.GearToolLookup)
local HalloweenManor = require(ReplicatedStorage.Data.HalloweenManor)
local Line = require(script.Parent.Line)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(255, 205, 60)
local v2 = Color3.fromRGB(255, 240, 170)
local v3 = CFrame.Angles(0, 1.5707963267948966, -0.3490658503988659)
local t1 = {}

local function reducedMotion() -- line: 74
    -- upvalues: GuiService (copy)
    return GuiService.ReducedMotionEnabled
end

local function sound(p1) -- line: 78
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    for _, v4 in p1 do
        Assets = Assets and Assets:FindFirstChild(v4)
    end

    return if Assets ~= nil and Assets:IsA("Sound") then Assets else nil
end

local function play(p2, p3, p4) -- line: 86
    -- upvalues: SoundService (copy), Audio (copy), sound (copy)
    local v5 = sound(p2)

    if v5 == nil then
        return
    end

    local v6 = table.clone(p4 or {})

    v6.SoundGroup = v6.SoundGroup or "SFX"

    if p3 ~= nil then
        v6.MaxDistance = v6.MaxDistance or 250
    end

    local Play = Audio.Play

    p3 = p3 or SoundService
    pcall(Play, v5, p3, v6)
end

local function effect(p5, p6, ...) -- line: 99
    if p5 ~= nil and type(p5[p6]) == "function" then
        local v9 = p5[p6]

        pcall(v9, ...)
    end
end

local function screen() -- line: 105
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local GenericRewardScreen2 = PlayerGui and PlayerGui:FindFirstChild("GenericRewardScreen2")
    local ShowReward = GenericRewardScreen2 and GenericRewardScreen2:FindFirstChild("ShowReward")

    if GenericRewardScreen2 ~= nil and GenericRewardScreen2:IsA("ScreenGui") and ShowReward ~= nil and ShowReward:IsA("BindableEvent") then
        return GenericRewardScreen2, ShowReward
    end

    return nil, nil
end

local function overlay(p7, p8) -- line: 115
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui == nil then
        return nil
    end

    local v10 = p7:Add(Instance.new("ScreenGui"))

    v10.Name = "ManorKeyCatch"
    v10.DisplayOrder = 30
    v10.IgnoreGuiInset = p8
    v10.ResetOnSpawn = false
    v10.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    v10.Parent = PlayerGui

    return v10
end

local function shield(p9) -- line: 130
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Shield"
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.Position = UDim2.fromScale(0.5, 0.5)
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton.Selectable = false
    TextButton.Text = ""
    TextButton.Parent = p9

    return TextButton
end

local function keyModel(p10, p11) -- line: 144
    -- upvalues: Workspace (copy), GearToolLookup (copy), HalloweenManor (copy), v1 (copy), v2 (copy)
    local v11 = GearToolLookup(HalloweenManor.GearId)

    if v11 == nil then
        return nil
    end

    local v12 = p10:Add(Instance.new("Model"))

    v12.Name = "ManorKeyCatch"

    for _, descendant in v11:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local clone = descendant:Clone()

            for _, child in clone:GetChildren() do
                if child:IsA("JointInstance") or child:IsA("WeldConstraint") then
                    child:Destroy()
                end
            end

            clone.Anchored = true
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
            clone.CastShadow = false
            clone.Parent = v12
        end
    end

    if #v12:GetChildren() == 0 then
        v12:Destroy()

        return nil
    end

    local BoundingBox, BoundingBox2 = v12:GetBoundingBox()
    local Part = Instance.new("Part")

    Part.Name = "Core"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.CFrame = CFrame.new(BoundingBox.Position)
    Part.Parent = v12
    v12.PrimaryPart = Part
    v12:ScaleTo(3.4 / math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z, 0.01))

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Brightness = 4
    PointLight.Range = 16
    PointLight.Parent = Part

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Trail"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v2, v1)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Rate = 80
    ParticleEmitter.Lifetime = NumberRange.new(0.35, 0.7)
    ParticleEmitter.Speed = NumberRange.new(0.5, 2.5)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 3
    ParticleEmitter.Size = NumberSequence.new(0.7, 0)
    ParticleEmitter.Transparency = NumberSequence.new(0, 1)
    ParticleEmitter.Parent = Part

    local Highlight = Instance.new("Highlight")

    Highlight.Adornee = v12
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillColor = v1
    Highlight.FillTransparency = 0.75
    Highlight.OutlineColor = v2
    Highlight.OutlineTransparency = 0
    Highlight.Parent = v12
    v12:PivotTo(CFrame.new(p11))
    v12.Parent = Workspace

    return v12
end

local function ease(p12, p13, p14) -- line: 216
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p12, 0, 1), p13, p14)
end

local function yank(p15, p16, p17) -- line: 220
    -- upvalues: Line (copy)
    if p16 == nil then
        return
    end

    p15:Add(p16)
    p15:Add(task.spawn(function() -- line: 225
        -- upvalues: p16 (copy), p17 (copy), Line (copy)
        Line.Return(p16, p17, 0.25)
        p16:Destroy()
    end))
end

local function lens(p18) -- line: 231
    -- upvalues: GuiService (copy), TweenService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil or GuiService.ReducedMotionEnabled then
        return function() -- line: 234
        end, function() -- line: 234
        end
    end

    local FieldOfView = CurrentCamera.FieldOfView
    local v13

    local function swap(p19) -- line: 238
        -- upvalues: v13 (ref)
        if v13 then
            v13:Cancel()
        end

        v13 = p19
        p19:Play()
    end

    p18:Add(function() -- line: 245
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), v13 (ref)
        if v13 then
            v13:Cancel()
        end

        CurrentCamera.FieldOfView = FieldOfView
    end)

    return function() -- pull | line: 251
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), v13 (ref), TweenService (copy)
        local tween = TweenService:Create(CurrentCamera, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            FieldOfView = FieldOfView - 7
        })

        if v13 then
            v13:Cancel()
        end

        v13 = tween
        tween:Play()
    end, function() -- kick | line: 260
        -- upvalues: CurrentCamera (copy), FieldOfView (copy), v13 (ref), TweenService (copy)
        CurrentCamera.FieldOfView = FieldOfView + 9

        local tween = TweenService:Create(CurrentCamera, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            FieldOfView = FieldOfView
        })

        if v13 then
            v13:Cancel()
        end

        v13 = tween
        tween:Play()
    end
end

local function fly(p20, p21) -- line: 273
    -- upvalues: GuiService (copy), TweenService (copy), Workspace (copy), v3 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    local function target() -- line: 278
        -- upvalues: CurrentCamera (copy)
        local _CFrame = CurrentCamera.CFrame

        return (_CFrame * CFrame.new(0, 0.35, -6.5)).Position, _CFrame.Position
    end

    local _CFrame = CurrentCamera.CFrame
    local Position = (_CFrame * CFrame.new(0, 0.35, -6.5)).Position
    local _ = _CFrame.Position
    local v14 = p21:Lerp(Position, 0.5) + Vector3.new(0, 9, 0)
    local v15 = if GuiService.ReducedMotionEnabled then 0 else 3
    local elapsed = os.clock()

    while p20.Parent ~= nil do
        local v17 = math.min((os.clock() - elapsed) / 0.9, 1)
        local Cubic = Enum.EasingStyle.Cubic
        local Out = Enum.EasingDirection.Out
        local Value = TweenService:GetValue(math.clamp(v17, 0, 1), Cubic, Out)
        local _CFrame = CurrentCamera.CFrame
        local Position = (_CFrame * CFrame.new(0, 0.35, -6.5)).Position
        local CFramePosition = _CFrame.Position
        local v18 = p21:Lerp(v14, Value):Lerp(v14:Lerp(Position, Value), Value)
        local v19 = (1 - (1 - v17) ^ 3) * v15 * 2 * 3.141592653589793

        p20:PivotTo(CFrame.lookAt(v18, CFramePosition) * CFrame.Angles(0, v19, 0) * v3)

        if v17 >= 1 then
            break
        end

        task.wait()
    end
end

local function arrive(p22) -- line: 302
    -- upvalues: TweenService (copy)
    local Scale = p22:GetScale()
    local elapsed = os.clock()

    while p22.Parent ~= nil do
        local v21 = math.min((os.clock() - elapsed) / 0.14, 1)
        local Back = Enum.EasingStyle.Back
        local Out = Enum.EasingDirection.Out

        p22:ScaleTo(Scale * (TweenService:GetValue(math.clamp(v21, 0, 1), Back, Out) * 0.25 + 1))

        if v21 >= 1 then
            break
        end

        task.wait()
    end
end

local function waitClosed(p23) -- line: 316
    local elapsed = os.clock()

    while not p23.Enabled and p23.Parent ~= nil and os.clock() - elapsed < 1 do
        task.wait()
    end

    local elapsed2 = os.clock()

    while p23.Enabled and p23.Parent ~= nil and os.clock() - elapsed2 < 15 do
        task.wait(0.1)
    end
end

local function shown(p24) -- line: 327
    local v22 = p24

    while v22 ~= nil and not v22:IsA("LayerCollector") do
        if v22:IsA("GuiObject") and not v22.Visible then
            return false
        end

        v22 = v22.Parent
    end

    return v22 ~= nil and v22.Enabled and p24.AbsoluteSize.X > 0
end

local function findSlot(p25) -- line: 338
    -- upvalues: LocalPlayer (copy), shown (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local BackpackGui = PlayerGui and PlayerGui:FindFirstChild("BackpackGui")

    if BackpackGui ~= nil then
        for _, descendant in BackpackGui:GetDescendants() do
            if descendant:IsA("ImageLabel") and descendant.Name == "Icon" and descendant.Image == p25 and shown(descendant) then
                return descendant
            end
        end
    end

    return nil
end

local function stow(p26) -- line: 357
    -- upvalues: GuiService (copy), TweenService (copy), Trove (copy), LocalPlayer (copy), v1 (copy), play (copy), findSlot (copy)
    local elapsed = os.clock()
    local v23

    while v23 == nil and os.clock() - elapsed < 1 do
        v23 = findSlot(p26)

        if v23 == nil then
            task.wait(0.1)
        end
    end

    if v23 == nil then
        return
    end

    local LayerCollector = v23:FindFirstAncestorWhichIsA("LayerCollector")
    local v25 = LayerCollector ~= nil and LayerCollector:IsA("ScreenGui") and LayerCollector.IgnoreGuiInset
    local v26 = Trove.new()
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v27

    if PlayerGui ~= nil then
        v27 = v26:Add(Instance.new("ScreenGui"))
        v27.Name = "ManorKeyCatch"
        v27.DisplayOrder = 30
        v27.IgnoreGuiInset = v25
        v27.ResetOnSpawn = false
        v27.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v27.Parent = PlayerGui
    end

    if v27 ~= nil then
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Key"
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
        ImageLabel.Size = UDim2.fromScale(0.16, 0.16)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = p26
        ImageLabel.ZIndex = 2

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.AspectRatio = 1
        UIAspectRatioConstraint.Parent = ImageLabel
        ImageLabel.Parent = v27
        task.wait()

        local AbsoluteSize = v27.AbsoluteSize

        if not (AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0) then
            local v28 = v23.AbsolutePosition + v23.AbsoluteSize / 2
            local v29 = UDim2.fromScale(v28.X / AbsoluteSize.X, v28.Y / AbsoluteSize.Y)
            local v30 = v23.AbsoluteSize.X / AbsoluteSize.X
            local v31 = if GuiService.ReducedMotionEnabled then 0.275 else 0.55
            local tween = TweenService:Create(ImageLabel, TweenInfo.new(v31, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Rotation = 0,
                Position = v29,
                Size = UDim2.fromScale(v30, v30)
            })

            ImageLabel.Rotation = GuiService.ReducedMotionEnabled and 0 or -25
            tween:Play()
            tween.Completed:Wait()
            play({ "Sounds", "ScrambleBoss", "Pop" }, nil, {
                Volume = 0.8,
                PlaybackSpeed = 1.15
            })
            ImageLabel.Visible = false

            local ImageLabel2 = Instance.new("ImageLabel")

            ImageLabel2.Name = "Ring"
            ImageLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel2.Position = v29
            ImageLabel2.Size = UDim2.fromScale(v30, v30)
            ImageLabel2.BackgroundTransparency = 1
            ImageLabel2.Image = "rbxassetid://123171646849062"
            ImageLabel2.ImageColor3 = v1

            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

            UIAspectRatioConstraint.AspectRatio = 1
            UIAspectRatioConstraint.Parent = ImageLabel2
            ImageLabel2.Parent = v27

            local tween2 = TweenService:Create(ImageLabel2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 1,
                Size = UDim2.fromScale(v30 * 2.6, v30 * 2.6)
            })

            tween2:Play()
            tween2.Completed:Wait()
            v26:Destroy()

            return
        end
    end

    v26:Destroy()
end

local function run(p27, p28, p29, p30) -- line: 435
    -- upvalues: HalloweenManor (copy), Line (copy), LocalPlayer (copy), v1 (copy), v2 (copy), play (copy), effect (copy), shield (copy), keyModel (copy), lens (copy), fly (copy), arrive (copy), waitClosed (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local v32

    if PlayerGui ~= nil then
        v32 = p27:Add(Instance.new("ScreenGui"))
        v32.Name = "ManorKeyCatch"
        v32.DisplayOrder = 30
        v32.IgnoreGuiInset = true
        v32.ResetOnSpawn = false
        v32.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        v32.Parent = PlayerGui
    end

    local v33 = if v32 == nil then nil else shield(v32)
    local Fx, Landing = p28.Fx, p28.Landing
    local v34 = Landing - Vector3.new(0, 0.5, 0)
    local Bobber, Tip = p28.Bobber, p28.Tip

    if Bobber ~= nil then
        p27:Add(Bobber)
        p27:Add(task.spawn(function() -- line: 225
            -- upvalues: Bobber (copy), Tip (copy), Line (copy)
            Line.Return(Bobber, Tip, 0.25)
            Bobber:Destroy()
        end))
    end

    local v35, v36 = lens(p27)

    play({ "Fishing", "Sounds", "Splash" }, Landing, {
        Volume = 0.9
    })
    play({ "Sounds", "ScrambleBoss", "Swoosh" }, nil, {
        Volume = 0.9,
        PlaybackSpeed = 0.8
    })
    effect(Fx, "Splash", Landing + Vector3.new(0, 0.3, 0), 1.4)
    effect(Fx, "Ring", CFrame.new(Landing + Vector3.new(0, 0.2, 0)), v1, 2, 16, 0.6)
    effect(Fx, "Burst", Landing + Vector3.new(0, 1, 0), v1, 40, 24, 0.9)
    effect(Fx, "Shake", 0.35, 0.3)

    local v37 = keyModel(p27, v34)

    v35()

    if v37 then
        fly(v37, v34)
        arrive(v37)
        v37:Destroy()
    else
        task.wait(0.9)
    end

    play({ "Sounds", "LightVsDarknessSounds", "CollectSecretRing" }, nil, {
        Volume = 0.8
    })
    effect(Fx, "Flash", v2, 0.6, 0.03, 0.45)
    v36()

    local Reward = p28.Reward

    p30:Fire({
        title = HalloweenManor.RewardTitle,
        item = Reward.DisplayName,
        rarity = Reward.Rarity,
        image = Reward.Icon
    })

    if v33 then
        p27:Add(task.delay(0.7, function() -- line: 469
            -- upvalues: v33 (copy)
            v33:Destroy()
        end))
    end

    waitClosed(p29)
end

function t1.Play(p31) -- line: 480
    -- upvalues: Trove (copy), screen (copy), run (copy)
    local v38, v39 = screen()
    local v40 = false

    if v38 == nil or v39 == nil then
        v40 = true
    else
        local v41 = Trove.new()
        local ok, result = pcall(run, v41, p31, v38, v39)

        v41:Destroy()

        if not ok then
            warn((("[Fishing] Manor Key catch stopped early: %*"):format(result)))
        end
    end

    return not v40
end

function t1.Stow(p32) -- line: 494
    -- upvalues: stow (copy)
    if type(p32) == "string" and p32 ~= "" then
        task.spawn(stow, p32)
    end
end

return table.freeze(t1)
