-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local GoldenButterfly = require(ReplicatedStorage.Client.Notifications.GoldenButterfly)
local Shake = require(ReplicatedStorage.Client.Shake)
local Swarm = require(script.Parent.Swarm)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local v1 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local CurrentCamera = Workspace.CurrentCamera
local Butterflies = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("VFX"):WaitForChild("Butterflies")
local v4, tween
local tween2 = nil
local FieldOfView
local t1 = {}

local function article(p1) -- line: 55
    if string.match(p1, "^[AEIOUaeiou]") then
        return "an"
    end

    return "a"
end

local function reducedMotion() -- line: 59
    -- upvalues: GuiService (copy)
    return GuiService.ReducedMotionEnabled
end

local function emittersOf(p2) -- line: 63
    -- upvalues: Butterflies (copy)
    local v5 = Butterflies:FindFirstChild(p2)

    if v5 == nil then
        return {}
    end

    local t2 = {}

    for _, descendant in v5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t2, descendant)
        end
    end

    return t2
end

local function emit(p3, p4, p5) -- line: 77
    -- upvalues: VFX (copy), emittersOf (copy)
    VFX.EmitAt(p4, emittersOf(p3), function(p6) -- line: 78
        -- upvalues: p5 (copy)
        if p5 and p6:GetAttribute("TierTint") == true then
            p6.Color = ColorSequence.new(p5:Lerp(Color3.new(1, 1, 1), 0.35), p5)
        end
    end)
end

local function impactGrade() -- line: 85
    -- upvalues: Lighting (copy), Butterflies (copy), v4 (ref)
    if v4 and v4.Parent then
        return v4
    end

    local Impact = Butterflies:FindFirstChild("Impact")
    local v6 = if not (Impact and Impact:IsA("ColorCorrectionEffect")) then Instance.new("ColorCorrectionEffect") else Impact:Clone()

    v6.Name = "ButterflyImpact"
    v6.Enabled = true
    v6.Brightness = 0
    v6.Contrast = 0
    v6.Saturation = 0
    v6.TintColor = Color3.new(1, 1, 1)
    v6.Parent = Lighting
    v4 = v6

    return v6
end

local function impactFrame(p7, p8) -- line: 104
    -- upvalues: TweenService (copy), Flash (copy), tween (ref), impactGrade (copy)
    local v7 = impactGrade()

    if tween then
        tween:Cancel()
    end

    v7.Brightness = p8 and 0.28 or 0.18
    v7.Contrast = p8 and 0.7 or 0.45
    v7.Saturation = -0.35
    v7.TintColor = Color3.new(1, 1, 1):Lerp(p7.Color, 0.35)

    local tween2 = TweenService:Create(v7, TweenInfo.new(if p8 then 0.4 else 0.22, Enum.EasingStyle.Quad), {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    })

    tween = tween2
    tween2:Play()
    Flash.Play({
        Attack = 0.02,
        Decay = p8 and 0.45 or 0.25,
        Tint = p7.Color,
        Opacity = p8 and 0.4 or 0.22
    })
end

local function fovPulse(p9) -- line: 131
    -- upvalues: GuiService (copy), TweenService (copy), v1 (copy), v2 (copy), v3 (copy), CurrentCamera (copy), tween2 (ref), FieldOfView (ref)
    if GuiService.ReducedMotionEnabled or CurrentCamera == nil then
        return
    end

    if tween2 ~= nil then
        tween2:Cancel()
    else
        FieldOfView = CurrentCamera.FieldOfView
    end

    local v9 = FieldOfView or CurrentCamera.FieldOfView
    local tween = TweenService:Create(CurrentCamera, v1, {
        FieldOfView = v9 - (p9 and 12 or 7)
    })

    tween2 = tween
    tween:Play()
    tween.Completed:Once(function(p10) -- line: 147
        -- upvalues: p9 (copy), tween (copy), v9 (copy), TweenService (copy), v2 (copy), v3 (copy), CurrentCamera (copy), tween2 (ref), FieldOfView (ref)
        if p10 == Enum.PlaybackState.Completed and tween2 == tween then
            local tween3 = TweenService:Create(CurrentCamera, if p9 then v3 else v2, {
                FieldOfView = v9
            })

            tween2 = tween3
            tween3:Play()
            tween3.Completed:Once(function() -- line: 156
                -- upvalues: tween3 (copy), tween2 (ref), FieldOfView (ref)
                if tween2 == tween3 then
                    tween2 = nil
                    FieldOfView = nil
                end
            end)
        end
    end)
end

local function popup(p11, p12, p13, p14) -- line: 165
    -- upvalues: TweenService (copy), Workspace (copy), VFX (copy), Butterflies (copy)
    local Popup = Butterflies:FindFirstChild("Popup")
    local Part, clone, v11

    if Popup ~= nil then
        if Popup:IsA("BillboardGui") then
            Part = Instance.new("Part")
            Part.Name = "ButterflyPopup"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.2, 0.2, 0.2)
            Part.CFrame = CFrame.new(p11)
            Part.Parent = Workspace
            clone = Popup:Clone()
            clone.Adornee = Part
            clone.Parent = Part

            local v12 = clone:FindFirstChild("Label", true)

            if v12 and v12:IsA("TextLabel") then
                v12.Text = p12
                v12.TextColor3 = p13

                local UIStroke = v12:FindFirstChildOfClass("UIStroke")

                if UIStroke then
                    UIStroke.Color = p14
                    v12.TextTransparency = 0
                    TweenService:Create(v12, TweenInfo.new(0.36000000000000004, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.54), {
                        TextTransparency = 1
                    }):Play()
                    TweenService:Create(UIStroke, TweenInfo.new(0.36000000000000004, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.54), {
                        Transparency = 1
                    }):Play()
                else
                    v12.TextTransparency = 0
                    TweenService:Create(v12, TweenInfo.new(0.36000000000000004, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.54), {
                        TextTransparency = 1
                    }):Play()
                end
            end

            v11 = false
        else
            v11 = true
        end
    else
        v11 = true
    end

    if v11 then
        return
    end

    local UIScale = clone:FindFirstChildOfClass("UIScale")

    if UIScale == nil then
        local GuiObject = clone:FindFirstChildWhichIsA("GuiObject")

        UIScale = GuiObject and GuiObject:FindFirstChildOfClass("UIScale")
    end

    if UIScale then
        UIScale.Scale = 0.4
        TweenService:Create(UIScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    TweenService:Create(Part, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = CFrame.new(p11 + Vector3.new(0, 3.5, 0))
    }):Play()
    VFX.Discard(Part, 1)
end

local function flashWhite(p15) -- line: 248
    -- upvalues: TweenService (copy), VFX (copy)
    local HitFlash = p15.Model:FindFirstChild("HitFlash")

    if HitFlash then
        HitFlash:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "HitFlash"
    Highlight.FillColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 0.1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p15.Model
    Highlight.Parent = p15.Model
    TweenService:Create(Highlight, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
        FillTransparency = 1
    }):Play()
    VFX.Discard(Highlight, 0.16999999999999998)
end

local function chaseGlow(p16, p17) -- line: 267
    -- upvalues: TweenService (copy), VFX (copy)
    local ChaseGlow = p16.Model:FindFirstChild("ChaseGlow")

    if ChaseGlow then
        ChaseGlow:Destroy()
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "ChaseGlow"
    Highlight.FillColor = p17.Color
    Highlight.FillTransparency = 0.55
    Highlight.OutlineColor = p17.Color:Lerp(Color3.new(1, 1, 1), 0.5)
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Adornee = p16.Model
    Highlight.Parent = p16.Model
    TweenService:Create(Highlight, TweenInfo.new(2.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        FillTransparency = 1,
        OutlineTransparency = 1
    }):Play()
    VFX.Discard(Highlight, 2.65)
end

local function suckInto(p18, p19) -- line: 289
    local Model, Position = p18.Model, p18.Position
    local v13 = p19 or Position + Vector3.new(0, -1, 0)
    local elapsed = os.clock()
    local Scale = Model:GetScale()

    task.spawn(function() -- line: 295
        -- upvalues: Model (copy), Position (copy), elapsed (copy), Scale (copy), v13 (copy)
        while Model.Parent do
            local v15 = math.clamp((os.clock() - elapsed) / 0.18, 0, 1)
            local v16 = v15 * v15

            Model:ScaleTo((math.max(0.05, Scale * (1 - v16 * 0.95))))
            Model:PivotTo(CFrame.new(Position:Lerp(v13, v16)) * CFrame.Angles(0, v15 * 3.141592653589793 * 3, 0))

            if v15 >= 1 then
                break
            end

            task.wait()
        end

        Model:Destroy()
    end)
end

function t1.Swing(p20) -- line: 316
    -- upvalues: Audio (copy), ButterflyCatalog (copy)
    Audio.Play(ButterflyCatalog.Sounds.Swing, p20, {
        Volume = 0.55,
        MaxDistance = 60,
        PlaybackSpeed = { 0.92, 1.12 }
    })
end

function t1.Contact(p21) -- line: 324
    -- upvalues: Swarm (copy), flashWhite (copy)
    Swarm.Hold(p21.Flight.Id, 0.08)
    flashWhite(p21)
end

function t1.Snag(p22, p23, p24, p25) -- line: 329
    -- upvalues: GuiService (copy), Audio (copy), ButterflyCatalog (copy), Shake (copy), Swarm (copy), flashWhite (copy), chaseGlow (copy)
    local v18 = ButterflyCatalog.Get(p23)

    Audio.Play(ButterflyCatalog.Sounds.Snag, p24 or script, {
        Volume = 0.7,
        MaxDistance = 60,
        PlaybackSpeed = { 0.97, 1.05 }
    })

    if not GuiService.ReducedMotionEnabled then
        Shake.Play({
            Magnitude = 0.12,
            Shape = "Fade",
            Seconds = ButterflyCatalog.SnagSeconds + 0.04
        })
    end

    if p22 == nil then
        return
    end

    flashWhite(p22)
    chaseGlow(p22, v18)

    if not p25 or p24 == nil then
        return
    end

    Swarm.PlayTrack(p22, "Struggle", 1)

    local Model = p22.Model
    local elapsed = os.clock()

    task.spawn(function() -- line: 359
        -- upvalues: p22 (copy), p24 (copy), Model (copy), elapsed (copy), ButterflyCatalog (copy)
        while Model.Parent and os.clock() - elapsed < ButterflyCatalog.SnagSeconds do
            p22.Position = p24.Position
            Model:PivotTo(CFrame.lookAt(p24.Position, p24.Position + p22.Heading))
            task.wait()
        end
    end)
end

function t1.Caught(p26, p27, p28, p29, p30) -- line: 368
    -- upvalues: GuiService (copy), Audio (copy), ButterflyCatalog (copy), Shake (copy), Toast (copy), VFX (copy), emittersOf (copy), impactFrame (copy), fovPulse (copy), popup (copy), suckInto (copy)
    local v19 = ButterflyCatalog.Get(p27)
    local v20 = p27 == "Golden"
    local v21 = if p26 then p26.Position elseif p30 then p30.Position else Vector3.new(0, 0, 0)

    if p29 and p29.IsPlaying then
        p29:AdjustSpeed(0)
        task.delay(v20 and 0.16 or 0.07, function() -- line: 382
            -- upvalues: p29 (copy)
            if p29.IsPlaying then
                p29:AdjustSpeed(1)
            end
        end)
    end

    impactFrame(v19, v20)
    fovPulse(v20)

    if not GuiService.ReducedMotionEnabled then
        Shake.Play({
            Shape = "Fade",
            Seconds = v20 and 0.45 or 0.22,
            Magnitude = v20 and 0.9 or 0.35
        })
    end

    Audio.Play(v19.CatchSound, script, {
        Volume = v20 and 0.95 or 0.75
    })

    local Color = v19.Color

    VFX.EmitAt(v21, emittersOf("Catch"), function(p31) -- line: 78
        -- upvalues: Color (copy)
        if Color and p31:GetAttribute("TierTint") == true then
            p31.Color = ColorSequence.new(Color:Lerp(Color3.new(1, 1, 1), 0.35), Color)
        end
    end)

    if v20 then
        local Color = v19.Color

        VFX.EmitAt(v21, emittersOf("CatchGolden"), function(p32) -- line: 78
            -- upvalues: Color (copy)
            if Color and p32:GetAttribute("TierTint") == true then
                p32.Color = ColorSequence.new(Color:Lerp(Color3.new(1, 1, 1), 0.35), Color)
            end
        end)
    end

    if p26 then
        suckInto(p26, if p30 then p30.Position else nil)
    end

    popup(v21 + Vector3.new(0, 1.2, 0), ("+1 %*"):format(v19.DisplayName), v19.Color, v19.StrokeColor)

    local v22 = if p28 then (" (%* owned)"):format(p28) else ""
    local Show = Toast.Show
    local t7 = {
        ShowShadow = true
    }

    t7.Lane = v20 and "Banner" or "Feed"

    local DisplayName = v19.DisplayName

    t7.Text = ("Caught %* %*!%*"):format(string.match(DisplayName, "^[AEIOUaeiou]") and "an" or "a", v19.DisplayName, v22)
    t7.Seconds = v20 and 4 or 2.5
    t7.Color = v19.Color
    t7.StrokeColor = v19.StrokeColor
    t7.Image = v19.Icon
    Show(t7)
end

function t1.Escaped(p33, p34) -- line: 418
    -- upvalues: GuiService (copy), Audio (copy), ButterflyCatalog (copy), Shake (copy), VFX (copy), emittersOf (copy), popup (copy), flashWhite (copy), chaseGlow (copy)
    local v23 = ButterflyCatalog.Get(p34)
    local Position

    if p33 then
        Position = p33.Position
        flashWhite(p33)
        chaseGlow(p33, v23)
    end

    Audio.Play(ButterflyCatalog.Sounds.Escape, Position or script, {
        Volume = 0.6,
        MaxDistance = 80,
        PlaybackSpeed = { 0.95, 1.1 }
    })

    if Position then
        local Color = v23.Color

        VFX.EmitAt(Position, emittersOf("Escape"), function(p35) -- line: 78
            -- upvalues: Color (copy)
            if Color and p35:GetAttribute("TierTint") == true then
                p35.Color = ColorSequence.new(Color:Lerp(Color3.new(1, 1, 1), 0.35), Color)
            end
        end)
        popup(Position + Vector3.new(0, 1.2, 0), "Escaped!", Color3.new(1, 1, 1), v23.StrokeColor)
    end

    if not GuiService.ReducedMotionEnabled then
        Shake.Play({
            Seconds = 0.12,
            Magnitude = 0.15,
            Shape = "Fade"
        })
    end
end

function t1.Announce(p36) -- line: 439
    -- upvalues: Audio (copy), ButterflyCatalog (copy), GoldenButterfly (copy), Toast (copy)
    if p36 == "Start" then
        Audio.Play(ButterflyCatalog.Sounds.BloomStart, script, {
            Volume = 0.8
        })
        Toast.Show({
            Lane = "Banner",
            Text = "THE BUTTERFLY BLOOM HAS BEGUN!\nGrab your net and catch butterflies in the Enchanted Forest!",
            Seconds = 5,
            ShowShadow = true,
            Color = Color3.fromRGB(255, 180, 255),
            StrokeColor = Color3.fromRGB(80, 20, 90),
            Image = ButterflyCatalog.Tiers.Blue.Icon,
            Size = UDim2.fromScale(1.5, 0.45)
        })
    elseif p36 == "Golden" then
        GoldenButterfly.Show()
    elseif p36 == "Ending" then
        Toast.Show({
            Lane = "Feed",
            Text = "The butterflies are leaving in 30 seconds!",
            Seconds = 3,
            Color = Color3.fromRGB(255, 200, 255)
        })
    elseif p36 == "End" then
        Toast.Show({
            Lane = "Feed",
            Text = "The Butterfly Bloom has ended",
            Seconds = 3,
            Color = Color3.fromRGB(255, 200, 255)
        })
    end
end

return t1
