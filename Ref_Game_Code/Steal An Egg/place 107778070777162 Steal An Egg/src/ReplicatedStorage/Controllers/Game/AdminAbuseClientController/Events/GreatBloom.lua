-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)

require(ReplicatedStorage.Shared.Globals.Constants)

local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local GUI = require(ReplicatedStorage.Client.GUI)
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Lanes = require(ReplicatedStorage.Client.Notifications.Lanes)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraBloomPolicy = require(ReplicatedStorage.Client.Modules.SakuraBloomPolicy)
local SakuraBloomVisibility = require(ReplicatedStorage.Client.SakuraBloomVisibility)
local SakuraFX = require(ReplicatedStorage.Client.SakuraFX)
local SakuraSignals = require(ReplicatedStorage.Client.SakuraSignals)
local Save = require(ReplicatedStorage.Shared.Save)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)

if not GameFlags.GreatBloomEnabled:Get() then
    return {
        StartEvent = function() -- StartEvent | line: 36
        end,
        StopEvent = function() -- StopEvent | line: 37
        end
    }
end

local v1 = Color3.fromRGB(255, 120, 200)
local v2 = Color3.fromRGB(120, 20, 70)
local v3 = Color3.fromRGB(255, 170, 220)
local v4 = Color3.fromRGB(120, 255, 140)
local v5 = Color3.fromRGB(255, 90, 110)
local LocalPlayer = Players.LocalPlayer
local Sakura2 = ReplicatedStorage.Assets.Models.Sakura
local BloomWaypoint = Sakura2.BloomWaypoint

assert(BloomWaypoint:IsA("BillboardGui"), "Sakura.BloomWaypoint must be a BillboardGui")

local Sparkles = ReplicatedStorage.Assets.VFX.Sakura.Hit:FindFirstChild("Sparkles")

assert(Sparkles and Sparkles:IsA("ParticleEmitter"), "VFX.Sakura.Hit.Sparkles must be a ParticleEmitter")
ReplicatedStorage = Sakura2.Crystal
assert(ReplicatedStorage:IsA("Model") and ReplicatedStorage.PrimaryPart, "Sakura.Crystal needs a PrimaryPart")

local Name = ReplicatedStorage.PrimaryPart.Name
local Bounds = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("CherryBlossom"):WaitForChild("Bounds")

assert(Bounds:IsA("BasePart"), "CherryBlossom.Bounds must be a BasePart")

local v6 = GUI.SakuraEventTutorialFrame()
local SakuraEventTutorialFrame = v6.SakuraEventTutorialFrame

assert(SakuraEventTutorialFrame:IsA("Frame"), "SakuraEventTutorialFrame.SakuraEventTutorialFrame must be a Frame")

local Ok = SakuraEventTutorialFrame.Ok

assert(Ok:IsA("ImageButton"), "SakuraEventTutorialFrame.Ok must be an ImageButton")

local v7 = GUI.GreatBloomBanner()
local Banner = v7:FindFirstChild("Banner")

assert(Banner and Banner:IsA("Frame"), "GreatBloomBanner needs a Banner Frame")

local BannerPosition = Banner.Position
local n1 = 0
local v9 = GUI.SakuraCrystalCounter()
local GuiObject = v9:FindFirstChildWhichIsA("GuiObject")

assert(GuiObject, "SakuraCrystalCounter needs a root Frame")

local v10 = v9:FindFirstChild("Count", true)

assert(v10 and v10:IsA("TextLabel"), "SakuraCrystalCounter needs a TextLabel named Count")

local v11 = v9:FindFirstChild("Gain", true)
local v12 = GuiObject:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

v12.Parent = GuiObject

local GuiObjectPosition = GuiObject.Position
local v13 = false
local UIStroke, v14

if v11 then
    UIStroke = v11:FindFirstChildOfClass("UIStroke")
    v14 = v11.Position
else
    v14 = UDim2.new()
end

local n2 = 0
local v15 = false
local t1 = {}

for _, descendant in ipairs(GuiObject:GetDescendants()) do
    if not v11 or descendant ~= v11 and not descendant:IsDescendantOf(v11) then
        local t3

        if descendant:IsA("TextLabel") then
            t3 = {
                Property = "TextTransparency",
                Instance = descendant
            }
            t3.Value = descendant.TextTransparency
            table.insert(t1, t3)
            t3 = {
                Property = "TextStrokeTransparency",
                Instance = descendant
            }
            t3.Value = descendant.TextStrokeTransparency
            table.insert(t1, t3)
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            t3 = {
                Property = "ImageTransparency",
                Instance = descendant
            }
            t3.Value = descendant.ImageTransparency
            table.insert(t1, t3)
        elseif descendant:IsA("UIStroke") then
            t3 = {
                Property = "Transparency",
                Instance = descendant
            }
            t3.Value = descendant.Transparency
            table.insert(t1, t3)
        end

        if descendant:IsA("GuiObject") and descendant.BackgroundTransparency < 1 then
            t3 = {
                Property = "BackgroundTransparency",
                Instance = descendant
            }
            t3.Value = descendant.BackgroundTransparency
            table.insert(t1, t3)
        end
    end
end

if GuiObject.BackgroundTransparency < 1 then
    table.insert(t1, {
        Property = "BackgroundTransparency",
        Instance = GuiObject,
        Value = GuiObject.BackgroundTransparency
    })
end

local n3 = 0
local SakuraCrystals
local n4 = 0
local v16 = Trove.new()
local v17 = CameraShaker.new()
local t5 = {}
local t6 = {}
local t7 = {}
local t8 = {}
local t9 = {}
local t10 = {}
local t11 = {}
local t12 = {}
local t13 = {}
local t14 = {}
local t15 = {}
local t16 = {}
local t17 = {}
local n5 = 0
local v18 = false
local v19 = false
local v20 = false
local v21, clone, Part
local v22 = false
local v23 = false
local v24 = false
local t18 = {}
local t19 = {}

local function isUnlocked() -- line: 219
    -- upvalues: SakuraBloomPolicy (copy), Save (copy)
    local v25 = Save.IsLoaded()
    local v26 = if v25 then Save.Peek() else nil

    return SakuraBloomPolicy.HasBloomUnlocked(v25, v26)
end

local function shouldPresent() -- line: 225
    -- upvalues: SakuraBloomPolicy (copy), Save (copy), v18 (ref)
    local v27 = Save.IsLoaded()
    local v28 = if v27 then Save.Peek() else nil

    return SakuraBloomPolicy.CanShowBloom(v18, v27, v28)
end

local function setBloomInstanceHidden(p1, p2) -- line: 231
    -- upvalues: SakuraBloomVisibility (copy), t18 (copy)
    local v29 = t18[p1]

    if v29 then
        v29:Clean()
        t18[p1] = nil
    end

    if p2 then
        t18[p1] = SakuraBloomVisibility.Conceal(p1)
    end
end

local function setWorldVFXEnabled(p3) -- line: 243
    -- upvalues: CollectionService (copy)
    for _, v30 in CollectionService:GetTagged("GreatBloomVFX") do
        for _, descendant in v30:GetDescendants() do
            if descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = p3
            end
        end
    end
end

local function refreshReplicatedVisibility() -- line: 253
    -- upvalues: CollectionService (copy), Sakura (copy), SakuraBloomPolicy (copy), SakuraBloomVisibility (copy), Save (copy), v18 (ref), t18 (copy), setWorldVFXEnabled (copy)
    local v31 = Save.IsLoaded()
    local v32 = if v31 then Save.Peek() else nil
    local v33 = SakuraBloomPolicy.HasBloomUnlocked(v31, v32)

    for _, v34 in CollectionService:GetTagged(Sakura.TreeTag) do
        local v35 = not v33
        local v36 = t18[v34]

        if v36 then
            v36:Clean()
            t18[v34] = nil
        end

        if v35 then
            t18[v34] = SakuraBloomVisibility.Conceal(v34)
        end
    end

    for _, v37 in CollectionService:GetTagged(Sakura.CrystalTag) do
        local v38 = not v33
        local v39 = t18[v37]

        if v39 then
            v39:Clean()
            t18[v37] = nil
        end

        if v38 then
            t18[v37] = SakuraBloomVisibility.Conceal(v37)
        end
    end

    setWorldVFXEnabled(v18 and v33)
end

local function distanceFromCharacter(p4) -- line: 264
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v40 = Player.FindPrimaryPart(LocalPlayer)

    if v40 == nil then
        return 1e999
    end

    return (v40.Position - p4).Magnitude
end

local function shakeIfNear(p5, p6, p7, p8) -- line: 272
    -- upvalues: Player (copy), LocalPlayer (copy), v17 (copy)
    local v41 = Player.FindPrimaryPart(LocalPlayer)

    if (if v41 == nil then 1e999 else (v41.Position - p5).Magnitude) <= p6 then
        v17:ShakeOnce(p7, p8, 0.1, 0.6)
    end
end

local function notifyTop(p9, p10) -- line: 278
    -- upvalues: Toast (copy), v1 (copy), v2 (copy)
    Toast.Show({
        Lane = "Banner",
        Text = p9,
        Color = v1,
        StrokeColor = v2,
        Seconds = p10
    })
end

local function showCrystalPopup(p11, p12) -- line: 329
    -- upvalues: Debris (copy), TweenService (copy), Workspace (copy), Simple (copy), v1 (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Position = p12 + Vector3.new(0, 4, 0)
    Part.Parent = Workspace

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Size = UDim2.fromOffset(140, 40)
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Parent = Part

    local TextLabel = Instance.new("TextLabel")

    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.Font = Enum.Font.GothamBlack
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = v1
    TextLabel.TextStrokeTransparency = 0.2
    TextLabel.Text = ("+%* Crystals"):format((Simple.FormatCompact(p11)))
    TextLabel.Parent = BillboardGui
    TweenService:Create(Part, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = Part.Position + Vector3.new(0, 6, 0)
    }):Play()
    TweenService:Create(TextLabel, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    }):Play()
    Debris:AddItem(Part, 1.2000000000000002)
end

local function setCounterShown(p13, p14) -- line: 374
    -- upvalues: TweenService (copy), v9 (copy), GuiObject (copy), v12 (copy), GuiObjectPosition (copy), v13 (ref), t1 (copy)
    local v42 = TweenInfo.new(p14, Enum.EasingStyle.Quad, if p13 then Enum.EasingDirection.Out else Enum.EasingDirection.In)

    for _, v43 in t1 do
        local Instance = v43.Instance
        local t20 = {}
        local Property = v43.Property

        if p13 then
            t20[Property] = v43.Value
        else
            t20[Property] = 1
        end

        TweenService:Create(Instance, v42, t20):Play()
    end

    if p13 == v13 then
        return
    end

    v13 = p13

    local v44 = UDim2.fromScale(0, -GuiObject.Size.Y.Scale * 0.6)

    if p13 then
        v9.Enabled = true
        GuiObject.Position = GuiObjectPosition + v44
        v12.Scale = 0.8
        TweenService:Create(GuiObject, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = GuiObjectPosition
        }):Play()
        TweenService:Create(v12, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    else
        TweenService:Create(GuiObject, TweenInfo.new(p14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = GuiObjectPosition + v44
        }):Play()
        TweenService:Create(v12, TweenInfo.new(p14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0.85
        }):Play()
        task.delay(p14, function() -- line: 419
            -- upvalues: v9 (copy), v13 (ref)
            if not v13 then
                v9.Enabled = false
            end
        end)
    end
end

local function hideCounter() -- line: 427
    -- upvalues: v15 (ref), n4 (ref), setCounterShown (copy)
    setCounterShown(false, 0.5)
    n4 = 0
    v15 = false
end

local function animateGain(p15) -- line: 433
    -- upvalues: TweenService (copy), Simple (copy), v4 (copy), v5 (copy), v11 (copy), n2 (ref), v15 (ref), UIStroke (ref), v14 (ref)
    local v45, v46, v47

    if v11 ~= nil then
        if v11:IsA("TextLabel") then
            n2 += 1
            v45 = n2
            v46 = p15 > 0
            v47 = false
        else
            v47 = true
        end
    else
        v47 = true
    end

    if v47 then
        return
    end

    v11.Text = ("%*%*"):format(v46 and "+" or "-", (Simple.FormatCompact((math.abs(p15)))))
    v11.TextColor3 = if v46 then v4 else v5

    local v49 = v11.Size.Y.Scale * 0.9
    local v50 = if v46 then -1 else 1
    local v51 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if v15 then
        v11.Position = v14 + UDim2.fromScale(0, -v50 * v49 * 0.2)
        TweenService:Create(v11, v51, {
            TextTransparency = 0,
            Position = v14
        }):Play()
    else
        v11.Position = v14 + UDim2.fromScale(0, -v50 * v49 * 0.5)
        v11.TextTransparency = 1

        if UIStroke then
            UIStroke.Transparency = 1
        end

        TweenService:Create(v11, v51, {
            TextTransparency = 0,
            Position = v14
        }):Play()

        if UIStroke then
            TweenService:Create(UIStroke, v51, {
                Transparency = 0
            }):Play()
        end
    end

    v15 = true
    task.delay(1.8000000000000003, function() -- line: 466
        -- upvalues: v45 (ref), v49 (copy), v50 (copy), TweenService (copy), v11 (copy), n2 (ref), v15 (ref), UIStroke (ref), v14 (ref)
        if n2 ~= v45 then
            return
        end

        v15 = false

        local v52 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        TweenService:Create(v11, v52, {
            TextTransparency = 1,
            Position = v14 + UDim2.fromScale(0, v50 * v49)
        }):Play()

        if UIStroke then
            TweenService:Create(UIStroke, v52, {
                Transparency = 1
            }):Play()
        end
    end)
end

local function popCounter() -- line: 483
    -- upvalues: TweenService (copy), Workspace (copy), Save (copy), Simple (copy), v10 (copy), v12 (copy), v13 (ref), v15 (ref), n3 (ref), SakuraCrystals (ref), n4 (ref), setCounterShown (copy), animateGain (copy)
    local v53 = Save.Await()

    if v53 == nil then
        return
    end

    local SakuraCrystals2 = v53.SakuraCrystals
    local SakuraCrystals3 = SakuraCrystals

    SakuraCrystals = SakuraCrystals2

    if SakuraCrystals3 == nil or SakuraCrystals2 == SakuraCrystals3 then
        return
    end

    local v54 = SakuraCrystals2 - SakuraCrystals3

    if Workspace:GetServerTimeNow() > n3 then
        n4 = 0
    elseif n4 > 0 then
        if not (v54 > 0) then
            n4 = 0
        end
    elseif v54 > 0 then
        n4 = 0
    end

    n4 += v54
    v10.Text = Simple.FormatCompact(SakuraCrystals2)
    animateGain(n4)
    n3 = Workspace:GetServerTimeNow() + 2.2

    local v55 = v13

    setCounterShown(true, 0.15)

    if v55 then
        v12.Scale = 1.12
        TweenService:Create(v12, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    task.delay(2.2, function() -- line: 512
        -- upvalues: Workspace (copy), v15 (ref), n3 (ref), n4 (ref), setCounterShown (copy)
        if not (Workspace:GetServerTimeNow() >= n3 - 0.05) then
            return
        end

        setCounterShown(false, 0.5)
        n4 = 0
        v15 = false
    end)
end

local function decorateTree(p16) -- line: 519
    -- upvalues: v3 (copy), Sparkles (copy), t9 (copy)
    local PrimaryPart = p16.PrimaryPart

    assert(PrimaryPart, (("%* needs a PrimaryPart"):format(p16.Name)))

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "BloomOutline"
    Highlight.FillColor = Color3.new(0, 0, 0)
    Highlight.FillTransparency = 1
    Highlight.OutlineColor = v3
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Enabled = false
    Highlight.Parent = p16
    t9[p16] = Highlight

    local clone = Sparkles:Clone()

    clone.Name = "BloomSparkles"
    clone.Rate = 14
    clone.Enabled = true
    clone.Parent = PrimaryPart
end

local function damageFraction(p17) -- line: 539
    local Hits = p17:GetAttribute("Hits")
    local HitsRequired = p17:GetAttribute("HitsRequired")

    if typeof(Hits) ~= "number" or typeof(HitsRequired) ~= "number" or HitsRequired <= 1 then
        return 0
    end

    return (math.clamp(Hits / HitsRequired, 0, 1))
end

local function renderDamage(p18) -- line: 548
    -- upvalues: TweenService (copy), t9 (copy)
    local v58 = t9[p18]

    if v58 == nil then
        return
    end

    local v59 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local Hits = p18:GetAttribute("Hits")
    local HitsRequired = p18:GetAttribute("HitsRequired")

    TweenService:Create(v58, v59, {
        FillTransparency = 1 - (if typeof(Hits) == "number" and typeof(HitsRequired) == "number" and not (HitsRequired <= 1) then math.clamp(Hits / HitsRequired, 0, 1) else 0) * 0.85
    }):Play()
end

local function shakeTree(p19) -- line: 560
    -- upvalues: t6 (copy), t7 (copy), t8 (copy)
    local v62 = t6[p19]

    if v62 == nil or t8[p19] then
        return
    end

    local v63 = (t7[p19] or 0) + 1

    t7[p19] = v63

    local Radius = p19:GetAttribute("Radius")

    if typeof(Radius) ~= "number" then
        Radius = 10
    end

    local v65 = math.clamp(Radius / 10, 0.8, 1.6) * 0.06981317007977318
    local v66 = math.random() * 100

    task.spawn(function() -- line: 571
        -- upvalues: p19 (copy), v62 (copy), v63 (copy), v65 (copy), v66 (copy), t7 (copy)
        local n6 = 0

        while n6 < 0.7 and p19.Parent and t7[p19] == v63 do
            n6 += task.wait()

            local v67 = (1 - n6 / 0.7) ^ 2
            local v68 = n6 * 9
            local v69 = math.noise(v66, v68) * 2 * v65 * v67
            local v70 = math.noise(v68, v66) * 2 * v65 * v67

            p19:PivotTo(v62 * CFrame.Angles(v69, 0, v70))
        end

        if p19.Parent and t7[p19] == v63 then
            p19:PivotTo(v62)
        end
    end)
end

local function clampTreeHeight(p20) -- line: 593
    local Y = p20:GetExtentsSize().Y

    if Y > 30 then
        p20:ScaleTo(p20:GetScale() * (30 / Y))
    end
end

local function growTree(p21) -- line: 602
    -- upvalues: TweenService (copy), t8 (copy), decorateTree (copy), renderDamage (copy)
    if not p21 or p21:GetAttribute("TreeLoaded") then
        warn(p21, "already loaded")
    else
        p21:SetAttribute("TreeLoaded", true)
        t8[p21] = true

        local Scale = p21:GetScale()

        task.spawn(function() -- line: 611
            -- upvalues: p21 (copy), Scale (copy), TweenService (copy), t8 (copy), decorateTree (copy), renderDamage (copy)
            p21:ScaleTo(Scale * 0.05)

            local n7 = 0

            while n7 < 0.55 and p21.Parent do
                n7 += task.wait()
                p21:ScaleTo(Scale * math.max(0.05, (TweenService:GetValue(math.clamp(n7 / 0.55, 0, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out))))

                local Y = p21:GetExtentsSize().Y

                if Y > 30 then
                    p21:ScaleTo(p21:GetScale() * (30 / Y))
                end
            end

            if p21.Parent then
                p21:ScaleTo(Scale)

                local Y = p21:GetExtentsSize().Y

                if Y > 30 then
                    p21:ScaleTo(p21:GetScale() * (30 / Y))
                end

                decorateTree(p21)
                renderDamage(p21)
            end

            t8[p21] = nil
        end)
    end
end

local function fallTree(p22, p23) -- line: 634
    -- upvalues: TweenService (copy), Workspace (copy), Sakura (copy)
    local clone = p22:Clone()

    clone.Name = "SakuraTreeFalling"
    clone:RemoveTag(Sakura.TreeTag)

    for _, v73 in ipairs(clone:GetTags()) do
        clone:RemoveTag(v73)
    end

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        elseif descendant:IsA("ProximityPrompt") then
            descendant:Destroy()
        elseif descendant:IsA("BillboardGui") then
            descendant:Destroy()
        elseif descendant:IsA("ParticleEmitter") then
            descendant:Destroy()
        elseif descendant:IsA("Highlight") then
            descendant:Destroy()
        end
    end

    clone.Parent = Workspace

    local Scale = clone:GetScale()
    local v74 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)

    task.spawn(function() -- line: 659
        -- upvalues: p23 (copy), clone (copy), Scale (copy), v74 (copy), TweenService (copy)
        local n8 = 0

        while n8 < 0.6 do
            n8 += task.wait()

            local v76 = math.clamp(n8 / 0.6, 0, 1)
            local v77 = TweenService:GetValue(v76, Enum.EasingStyle.Quad, Enum.EasingDirection.In) * 0.6108652381980153

            clone:PivotTo(p23 * v74 * CFrame.Angles(v77, 0, 0) * v74:Inverse())
            clone:ScaleTo(Scale * math.max(0.05, 1 - v76 * v76))
        end

        clone:Destroy()
    end)
end

local function onTreeHit(p24) -- line: 676
    -- upvalues: Player (copy), SakuraFX (copy), LocalPlayer (copy), v17 (copy), renderDamage (copy), shakeTree (copy)
    shakeTree(p24)
    renderDamage(p24)

    local Position = p24:GetPivot().Position
    local Height = p24:GetAttribute("Height")

    if typeof(Height) ~= "number" then
        Height = 20
    end

    local v80 = Position + Vector3.new(0, Height * 0.6, 0)

    SakuraFX.EmitBurst("Hit", v80, 30, 8)
    SakuraFX.PlayCue("TreeHit", Position, 0.9, 0.9 + math.random() * 0.2)

    local v81 = Player.FindPrimaryPart(LocalPlayer)

    if (if v81 == nil then 1e999 else (v81.Position - Position).Magnitude) <= 30 then
        v17:ShakeOnce(0.8, 6, 0.1, 0.6)
    end
end

local function updateHighlights() -- line: 688
    -- upvalues: Player (copy), LocalPlayer (copy), t9 (copy)
    local v82 = Player.FindPrimaryPart(LocalPlayer)
    local t22 = {}

    for v83, v84 in t9 do
        if v83.Parent ~= nil then
            local v85 = if v82 then (v82.Position - v83:GetPivot().Position).Magnitude else 1e999
            local Hits = v83:GetAttribute("Hits")
            local HitsRequired = v83:GetAttribute("HitsRequired")
            local n9 = 0

            if typeof(Hits) == "number" and typeof(HitsRequired) == "number" then
                n9 = if HitsRequired <= 1 then 0 else math.clamp(Hits / HitsRequired, 0, 1)
            end

            if n9 > 0 then
                v85 = 0
            end

            if v85 <= 160 then
                table.insert(t22, {
                    Tree = v83,
                    Distance = v85
                })
            else
                v84.Enabled = false
            end
        end
    end

    table.sort(t22, function(p25, p26) -- line: 707
        return p25.Distance < p26.Distance
    end)

    for v87, v88 in t22 do
        t9[v88.Tree].Enabled = v87 <= 24
    end
end

local function onTreeAdded(p27) -- line: 715
    -- upvalues: Player (copy), Sakura (copy), SakuraBloomPolicy (copy), SakuraFX (copy), Save (copy), LocalPlayer (copy), v17 (copy), t5 (copy), t6 (copy), t10 (copy), growTree (copy), onTreeHit (copy)
    local v89 = Save.IsLoaded()
    local v90 = if v89 then Save.Peek() else nil
    local Position, SpawnShakeRadius, v91

    if not SakuraBloomPolicy.HasBloomUnlocked(v89, v90) or not p27:IsA("Model") or p27.Name == "SakuraTreeFalling" then
        return
    else
        Position = p27:GetPivot().Position
        t5[p27] = Position
        t6[p27] = p27:GetPivot()
        SpawnShakeRadius = Sakura.Bloom.SpawnShakeRadius

        local v93 = Player.FindPrimaryPart(LocalPlayer)

        v91 = if v93 ~= nil then (v93.Position - Position).Magnitude else 1e999
    end

    if v91 <= SpawnShakeRadius then
        v17:ShakeOnce(1.5, 8, 0.1, 0.6)
    end

    SakuraFX.EmitBurst("Spawn", Position + Vector3.new(0, 1, 0), 40, 10)
    SakuraFX.PlayCue("TreeSpawn", Position, 0.7, 0.75)
    growTree(p27)

    local v94 = t10[p27]

    if v94 then
        v94:Disconnect()
    end

    t10[p27] = p27:GetAttributeChangedSignal("Hits"):Connect(function() -- line: 731
        -- upvalues: p27 (copy), onTreeHit (copy)
        onTreeHit(p27)
    end)
end

local function onTreeRemoved(p28) -- line: 736
    -- upvalues: Player (copy), SakuraFX (copy), LocalPlayer (copy), v17 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), fallTree (copy)
    local v95 = t5[p28]
    local v96 = t6[p28]

    t5[p28] = nil
    t6[p28] = nil
    t7[p28] = nil
    t8[p28] = nil
    t9[p28] = nil

    local v97 = t10[p28]

    if v97 then
        v97:Disconnect()
        t10[p28] = nil
    end

    if v95 == nil then
        return
    end

    if p28:IsA("Model") and v96 then
        fallTree(p28, v96)
    end

    local v98 = Player.FindPrimaryPart(LocalPlayer)

    if (if v98 == nil then 1e999 else (v98.Position - v95).Magnitude) <= 60 then
        v17:ShakeOnce(2, 10, 0.1, 0.6)
    end

    SakuraFX.EmitBurst("Break", v95 + Vector3.new(0, 8, 0), 90, 12)
    SakuraFX.PlayCue("TreeBreak", v95, 1, 1)
end

local function onCrystalAdded(p29) -- line: 760
    -- upvalues: Players (copy), SakuraBloomPolicy (copy), Save (copy), v1 (copy), Name (copy), t12 (copy), t13 (copy), t14 (copy), t15 (copy), t16 (copy)
    local v99 = Save.IsLoaded()
    local v100 = if v99 then Save.Peek() else nil

    if not (SakuraBloomPolicy.HasBloomUnlocked(v99, v100) and p29:IsA("Model")) then
        return
    end

    local v101 = p29.PrimaryPart or p29:WaitForChild(Name, 5)

    if v101 == nil or p29.Parent == nil or t12[p29] then
        return
    end

    t12[p29] = p29:GetPivot()

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Brightness = 1.2
    PointLight.Range = 8
    PointLight.Parent = v101
    t13[p29] = PointLight

    local Owner = p29:GetAttribute("Owner")
    local v102 = if typeof(Owner) == "number" then Players:GetPlayerByUserId(Owner) else nil
    local Origin = p29:GetAttribute("Origin")

    if v102 and typeof(Origin) == "Vector3" then
        t14[p29] = v102
        t15[p29] = Origin
        t16[p29] = 0
        p29:PivotTo(CFrame.new(Origin))
    end
end

local function onCrystalRemoved(p30) -- line: 787
    -- upvalues: t11 (copy), t12 (copy), t13 (copy), t14 (copy), t15 (copy), t16 (copy), t17 (copy)
    if p30:IsA("Model") then
        t12[p30] = nil
        t13[p30] = nil
        t14[p30] = nil
        t15[p30] = nil
        t16[p30] = nil
        t17[p30] = nil
    end

    t11[p30] = nil
end

local function hideCrystal(p31) -- line: 799
    -- upvalues: t12 (copy), t17 (copy)
    t12[p31] = nil
    t17[p31] = nil

    for _, descendant in ipairs(p31:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        elseif descendant:IsA("PointLight") then
            descendant.Enabled = false
        end
    end
end

local function requestCollect(p32, p33) -- line: 811
    -- upvalues: Remotes (copy), t11 (copy), t12 (copy), t17 (copy)
    task.spawn(function() -- line: 812
        -- upvalues: p32 (copy), p33 (copy), Remotes (copy), t11 (copy), t12 (copy), t17 (copy)
        if Remotes.Bloomery.AskGatherPetal:InvokeServer(p32) then
            return
        end

        task.wait(1)
        t11[p32] = nil

        if p32.Parent then
            t12[p32] = p33
            t17[p32] = 0
        end
    end)
end

local function animateCrystals(p34, p35) -- line: 825
    -- upvalues: TweenService (copy), Player (copy), Remotes (copy), Sakura (copy), LocalPlayer (copy), t11 (copy), t12 (copy), t13 (copy), t14 (copy), t15 (copy), t16 (copy), t17 (copy), hideCrystal (copy)
    local v103 = Player.FindPrimaryPart(LocalPlayer)

    for v104, v105 in t12 do
        if v104.Parent ~= nil then
            local v106 = t16[v104]
            local v107 = t15[v104]

            if v106 ~= nil then
                if v107 then
                    local v129 = v106 + p35

                    t16[v104] = v129

                    local v131 = math.clamp(v129 / 0.5, 0, 1)
                    local Value = TweenService:GetValue(v131, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local v133 = math.sin(v131 * 3.141592653589793) * 6
                    local v134 = v107:Lerp(v105.Position, Value) + Vector3.new(0, v133, 0)

                    v104:PivotTo(CFrame.new(v134) * CFrame.Angles(0, p34 * 1.2 * 3, 0))

                    if v129 >= 0.7 then
                        t16[v104] = nil
                        t17[v104] = 0
                        t11[v104] = true
                    end
                else
                    local v135 = t14[v104]
                    local v136 = if v135 then Player.FindPrimaryPart(v135) else nil
                    local v137 = t17[v104]

                    if v137 ~= nil then
                        if v136 then
                            local v143 = v137 + p35

                            t17[v104] = v143

                            local v145 = math.clamp(v143 / 0.7, 0, 1)
                            local v146 = v145 * v145
                            local v147 = v136.Position + Vector3.new(0, 1, 0)
                            local v149 = v104:GetPivot().Position:Lerp(v147, (math.min(1, v146 * 0.5 + p35 * 6)))

                            v104:PivotTo(CFrame.new(v149) * CFrame.Angles(0, p34 * 1.2 * 4, 0))
                            v104:ScaleTo((math.max(0.2, Sakura.Bloom.CrystalScale * (1 - v146 * 0.6))))

                            if v145 >= 1 or (v149 - v147).Magnitude < 1 then
                                if v135 == LocalPlayer then
                                    t17[v104] = nil
                                    t12[v104] = nil
                                    task.spawn(function() -- line: 812
                                        -- upvalues: v104 (copy), v105 (copy), Remotes (copy), t11 (copy), t12 (copy), t17 (copy)
                                        if Remotes.Bloomery.AskGatherPetal:InvokeServer(v104) then
                                            return
                                        end

                                        task.wait(1)
                                        t11[v104] = nil

                                        if v104.Parent then
                                            t12[v104] = v105
                                            t17[v104] = 0
                                        end
                                    end)
                                else
                                    hideCrystal(v104)
                                end
                            end
                        else
                            local v151 = v103 ~= nil and (v103.Position - v105.Position).Magnitude <= 22
                            local v153 = math.sin(p34 * (if v151 then 4 else 2) + v105.Position.X) * 0.35

                            v104:PivotTo(v105 * CFrame.new(0, v153, 0) * CFrame.Angles(0, p34 * 1.2 * (v151 and 2.5 or 1), 0))

                            local v154 = t13[v104]

                            if v154 then
                                if v151 then
                                    v154.Brightness = math.sin(p34 * 6) * 0.8 + 2.5
                                else
                                    v154.Brightness = 1.2
                                end
                            end
                        end
                    else
                        local v138 = v103 ~= nil and (v103.Position - v105.Position).Magnitude <= 22
                        local v140 = math.sin(p34 * (if v138 then 4 else 2) + v105.Position.X) * 0.35

                        v104:PivotTo(v105 * CFrame.new(0, v140, 0) * CFrame.Angles(0, p34 * 1.2 * (v138 and 2.5 or 1), 0))

                        local v141 = t13[v104]

                        if v141 then
                            if v138 then
                                v141.Brightness = math.sin(p34 * 6) * 0.8 + 2.5
                            else
                                v141.Brightness = 1.2
                            end
                        end
                    end
                end
            else
                local v108 = t14[v104]
                local v109 = if v108 then Player.FindPrimaryPart(v108) else nil
                local v110 = t17[v104]

                if v110 ~= nil then
                    if v109 then
                        local v116 = v110 + p35

                        t17[v104] = v116

                        local v118 = math.clamp(v116 / 0.7, 0, 1)
                        local v119 = v118 * v118
                        local v120 = v109.Position + Vector3.new(0, 1, 0)
                        local v122 = v104:GetPivot().Position:Lerp(v120, (math.min(1, v119 * 0.5 + p35 * 6)))

                        v104:PivotTo(CFrame.new(v122) * CFrame.Angles(0, p34 * 1.2 * 4, 0))
                        v104:ScaleTo((math.max(0.2, Sakura.Bloom.CrystalScale * (1 - v119 * 0.6))))

                        if v118 >= 1 or (v122 - v120).Magnitude < 1 then
                            if v108 == LocalPlayer then
                                t17[v104] = nil
                                t12[v104] = nil
                                task.spawn(function() -- line: 812
                                    -- upvalues: v104 (copy), v105 (copy), Remotes (copy), t11 (copy), t12 (copy), t17 (copy)
                                    if Remotes.Bloomery.AskGatherPetal:InvokeServer(v104) then
                                        return
                                    end

                                    task.wait(1)
                                    t11[v104] = nil

                                    if v104.Parent then
                                        t12[v104] = v105
                                        t17[v104] = 0
                                    end
                                end)
                            else
                                hideCrystal(v104)
                            end
                        end
                    else
                        local v124 = v103 ~= nil and (v103.Position - v105.Position).Magnitude <= 22
                        local v126 = math.sin(p34 * (if v124 then 4 else 2) + v105.Position.X) * 0.35

                        v104:PivotTo(v105 * CFrame.new(0, v126, 0) * CFrame.Angles(0, p34 * 1.2 * (v124 and 2.5 or 1), 0))

                        local v127 = t13[v104]

                        if v127 then
                            if v124 then
                                v127.Brightness = math.sin(p34 * 6) * 0.8 + 2.5
                            else
                                v127.Brightness = 1.2
                            end
                        end
                    end
                else
                    local v111 = v103 ~= nil and (v103.Position - v105.Position).Magnitude <= 22
                    local v113 = math.sin(p34 * (if v111 then 4 else 2) + v105.Position.X) * 0.35

                    v104:PivotTo(v105 * CFrame.new(0, v113, 0) * CFrame.Angles(0, p34 * 1.2 * (v111 and 2.5 or 1), 0))

                    local v114 = t13[v104]

                    if v114 then
                        if v111 then
                            v114.Brightness = math.sin(p34 * 6) * 0.8 + 2.5
                        else
                            v114.Brightness = 1.2
                        end
                    end
                end
            end
        end
    end
end

local function findTreeInReach(p36) -- line: 896
    -- upvalues: Sakura (copy), t6 (copy), t8 (copy)
    local n10 = 1e999
    local v156

    for v157, v158 in t6 do
        if v157.Parent ~= nil and not t8[v157] then
            local Radius = v157:GetAttribute("Radius")

            assert(typeof(Radius) == "number", (("%* needs a Radius attribute"):format(v157.Name)))

            local Magnitude = Vector3.new(p36.Position.X - v158.Position.X, 0, p36.Position.Z - v158.Position.Z).Magnitude

            if Magnitude <= Radius + Sakura.Bloom.HitRange and Magnitude < n10 then
                n10 = Magnitude
                v156 = v157
            end
        end
    end

    return v156
end

local function tryAutoSwing() -- line: 916
    -- upvalues: Player (copy), Remotes (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), LocalPlayer (copy), v23 (ref), findTreeInReach (copy)
    if v23 then
        return
    end

    local v163 = Player.FindCharacter(LocalPlayer)
    local v164 = Player.FindPrimaryPart(LocalPlayer)
    local v165 = Player.FindHumanoid(LocalPlayer)

    if v163 ~= nil and v164 ~= nil and v165 ~= nil and not (v165.Health <= 0) then
        local Tool = v163:FindFirstChildOfClass("Tool")

        if Tool ~= nil and Sakura.IsBatTool(Tool) then
            local v166 = findTreeInReach(v164)

            if v166 ~= nil then
                local v167 = Save.IsLoaded()
                local v168 = if v167 then Save.Peek() else nil

                if SakuraBloomPolicy.HasBloomUnlocked(v167, v168) then
                    local Animator = v165:FindFirstChildOfClass("Animator")
                    local HitAnim = Tool:FindFirstChild("HitAnim")

                    assert(Animator and HitAnim and HitAnim:IsA("Animation"), (("%* needs a HitAnim and the character an Animator"):format(Tool.Name)))
                    v23 = true

                    local track = Animator:LoadAnimation(HitAnim)

                    track.Priority = Enum.AnimationPriority.Action
                    track:Play()
                    Remotes.Bloomery.AskStrikeTree:FireServer(v166)
                    task.spawn(function() -- line: 948
                        -- upvalues: track (copy), v23 (ref)
                        local v171 = os.clock() + 3

                        repeat
                            task.wait()
                        until not track.IsPlaying or v171 <= os.clock()

                        track:Stop()
                        track:Destroy()
                        v23 = false
                    end)
                end
            end
        end
    end
end

local function isInsideBounds(p37) -- line: 959
    -- upvalues: Bounds (copy)
    local v172 = Bounds.CFrame:PointToObjectSpace(p37)

    if not (math.abs(v172.X) <= Bounds.Size.X / 2 + 90) then
        return false
    end

    return math.abs(v172.Z) <= Bounds.Size.Z / 2 + 90
end

local function buildWaypoint() -- line: 965
    -- upvalues: Workspace (copy), BloomWaypoint (copy), Bounds (copy), v16 (copy), clone (ref), Part (ref), v22 (ref)
    local Part2 = Instance.new("Part")

    Part2.Name = "BloomWaypointHost"
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Transparency = 1
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.Position = Bounds.Position + Vector3.new(0, 24, 0)
    Part2.Parent = Workspace

    local clone2 = BloomWaypoint:Clone()

    clone2.Enabled = false

    for _, child in clone2:GetChildren() do
        if child:IsA("TextLabel") then
            child.TextTransparency = 1

            local UIStroke = child:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Transparency = 1
            end
        end
    end

    clone2.Parent = Part2
    Part = Part2
    clone = clone2
    v22 = false
    v16:Add(Part2)
    v16:Add(function() -- line: 992
        -- upvalues: clone (ref), Part (ref), v22 (ref)
        clone = nil
        Part = nil
        v22 = false
    end)
end

local function setWaypointShown(p38, p39) -- line: 999
    -- upvalues: TweenService (copy), v22 (ref)
    if v22 == p39 then
        return
    end

    v22 = p39

    local v173 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v174

    if p39 then
        v174 = 0
        p38.Enabled = true
    else
        v174 = 1
    end

    for _, child in p38:GetChildren() do
        if child:IsA("TextLabel") then
            TweenService:Create(child, v173, {
                TextTransparency = v174
            }):Play()

            local UIStroke = child:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                TweenService:Create(UIStroke, v173, {
                    Transparency = v174
                }):Play()
            end
        end
    end

    if not p39 then
        task.delay(0.5, function() -- line: 1020
            -- upvalues: p38 (copy), v22 (ref)
            if not v22 and p38.Parent then
                p38.Enabled = false
            end
        end)
    end
end

local function renderWaypoint() -- line: 1028
    -- upvalues: Player (copy), LocalPlayer (copy), Bounds (copy), clone (ref), Part (ref), setWaypointShown (copy)
    local clone2 = clone
    local Part2 = Part

    if clone2 ~= nil and Part2 ~= nil then
        local v175 = Player.FindPrimaryPart(LocalPlayer)

        if v175 ~= nil then
            local Position = v175.Position
            local v176 = Bounds.CFrame:PointToObjectSpace(Position)

            if not (math.abs(v176.X) <= Bounds.Size.X / 2 + 90 and math.abs(v176.Z) <= Bounds.Size.Z / 2 + 90) and LocalPlayer:GetAttribute("AreaId") == "Prehistoric" then
                setWaypointShown(clone2, true)

                local Countdown = clone2:FindFirstChild("Countdown")

                if Countdown and Countdown:IsA("TextLabel") then
                    Countdown.Text = ("%* studs"):format((math.floor((v175.Position - Part2.Position).Magnitude)))
                end

                return
            end
        end

        setWaypointShown(clone2, false)
    end
end

local function toggleMusic(p40) -- line: 1050
    if p40 then
        script.SakuraEventMusic:Play()
    else
        script.SakuraEventMusic:Stop()
    end
end

local function hideTutorial() -- line: 1058
    -- upvalues: v6 (copy), v21 (ref)
    if not v6.Enabled and v21 == nil then
        return
    end

    v6.Enabled = false

    local v178 = v21

    v21 = nil

    if v178 ~= nil then
        v178()
    end
end

local function showTutorialManually() -- line: 1070
    -- upvalues: HiddenUIHandler (copy), SakuraBloomPolicy (copy), SakuraFX (copy), Save (copy), Tabs (copy), LocalPlayer (copy), v6 (copy), v21 (ref)
    local v179 = Save.IsLoaded()
    local v180 = if v179 then Save.Peek() else nil

    if not SakuraBloomPolicy.HasBloomUnlocked(v179, v180) or v6.Enabled then
        return
    end

    Tabs.Deactivate({
        instant = true
    })
    v21 = HiddenUIHandler.Acquire()
    v6.Enabled = true
    SakuraFX.PlayCue("TutorialOpen", LocalPlayer, 0.8)
end

local function acknowledgeTutorial() -- line: 1080
    -- upvalues: CollectionService (copy), Remotes (copy), Save (copy), Tabs (copy), LocalPlayer (copy), v6 (copy), v20 (ref), v21 (ref)
    if v20 then
        return
    end

    v20 = true

    if v6.Enabled or v21 ~= nil then
        v6.Enabled = false

        local v181 = v21

        v21 = nil

        if v181 ~= nil then
            v181()
        end
    end

    local v182 = Save.Await()

    if v182 and not v182.Sakura.TutorialSeen then
        Remotes.Bloomery.AskBriefingConfirm:InvokeServer()
    end

    v20 = false

    local v183 = CollectionService:GetTagged("MainSakuraTree")[1]

    if not (v183 and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart) then
        return
    end

    local Magnitude = (LocalPlayer.Character.PrimaryPart.Position - v183:GetPivot().Position).Magnitude
    local v184 = Save.Await()

    if Magnitude < 100 and v184 and v184.Sakura.Unlocked then
        LocalPlayer:SetAttribute("SakuraTutorialSkip", true)
        Tabs.Activate("SakuraEggCharge")
    end
end

local function stopPresentation() -- line: 1120
    -- upvalues: Save (copy), v6 (copy), v7 (copy), n1 (ref), v15 (ref), SakuraCrystals (ref), n4 (ref), v16 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), t9 (copy), t10 (copy), v21 (ref), v23 (ref), v24 (ref), setWorldVFXEnabled (copy), setCounterShown (copy)
    v16:Clean()
    v24 = false
    n1 += 1
    v7.Enabled = false

    if v6.Enabled or v21 ~= nil then
        v6.Enabled = false

        local v185 = v21

        v21 = nil

        if v185 ~= nil then
            v185()
        end
    end

    setCounterShown(false, 0.5)
    n4 = 0
    v15 = false

    for v186, v187 in t10 do
        v187:Disconnect()
        t10[v186] = nil
    end

    for _, v188 in t9 do
        if v188.Parent then
            v188:Destroy()
        end
    end

    for v189 in t6 do
        if v189.Parent then
            v189:SetAttribute("TreeLoaded", nil)

            for _, descendant in v189:GetDescendants() do
                if descendant.Name == "BloomSparkles" then
                    descendant:Destroy()
                end
            end
        end
    end

    table.clear(t5)
    table.clear(t6)
    table.clear(t7)
    table.clear(t8)
    table.clear(t9)
    v23 = false

    local v190 = Save.Peek()

    SakuraCrystals = if v190 then v190.SakuraCrystals else nil
    setWorldVFXEnabled(false)
    script.SakuraEventMusic:Stop()
end

local function startPresentation() -- line: 1158
    -- upvalues: CollectionService (copy), RunService (copy), TweenService (copy), Workspace (copy), Lanes (copy), Toast (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), v1 (copy), v2 (copy), LocalPlayer (copy), Bounds (copy), v7 (copy), Banner (copy), BannerPosition (copy), n1 (ref), SakuraCrystals (ref), v16 (copy), n5 (ref), v18 (ref), v19 (ref), v24 (ref), setWorldVFXEnabled (copy), updateHighlights (copy), onTreeAdded (copy), onTreeRemoved (copy), onCrystalAdded (copy), animateCrystals (copy), tryAutoSwing (copy), buildWaypoint (copy), renderWaypoint (copy)
    if v24 then
        return
    end

    local v191 = Save.IsLoaded()
    local v192 = if v191 then Save.Peek() else nil

    if not SakuraBloomPolicy.CanShowBloom(v18, v191, v192) then
        return
    end

    v24 = true
    setWorldVFXEnabled(true)
    script.SakuraEventMusic:Play()

    for _, v193 in ipairs(CollectionService:GetTagged(Sakura.TreeTag)) do
        onTreeAdded(v193)
    end

    v16:Add(CollectionService:GetInstanceAddedSignal(Sakura.TreeTag):Connect(onTreeAdded))
    v16:Add(CollectionService:GetInstanceRemovedSignal(Sakura.TreeTag):Connect(onTreeRemoved))
    buildWaypoint()
    SakuraCrystals = if Save.Await() then Save.Await().SakuraCrystals else nil

    local n11 = 0
    local n12 = 0

    v16:Add(RunService.Heartbeat:Connect(function(p41) -- line: 1177
        -- upvalues: n11 (ref), n12 (ref), Workspace (copy), Toast (copy), Sakura (copy), v1 (copy), v2 (copy), LocalPlayer (copy), Bounds (copy), n5 (ref), v19 (ref), updateHighlights (copy), animateCrystals (copy), tryAutoSwing (copy), renderWaypoint (copy)
        n12 += p41
        n11 += p41
        animateCrystals(n12, p41)

        if n11 >= 0.15 then
            n11 = 0
            updateHighlights()
            tryAutoSwing()
            renderWaypoint()

            if not v19 then
                local v194 = n5 - Workspace:GetServerTimeNow()

                if v194 <= Sakura.Bloom.EndingWarningSeconds and v194 > 0 then
                    v19 = true

                    local v196 = ("🌸 The Great Bloom ends in %* seconds!"):format(Sakura.Bloom.EndingWarningSeconds)

                    Toast.Show({
                        Lane = "Banner",
                        Seconds = 4,
                        Text = v196,
                        Color = v1,
                        StrokeColor = v2
                    })
                end
            end
        end

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            local Position = HumanoidRootPart.Position
            local v197 = Bounds.CFrame:PointToObjectSpace(Position)

            if math.abs(v197.X) <= Bounds.Size.X / 2 + 90 and math.abs(v197.Z) <= Bounds.Size.Z / 2 + 90 and Workspace:GetAttribute("AdminAbuseOnTop") ~= true then
                script.SakuraEventMusic.Volume = 0.5

                return
            end
        end

        script.SakuraEventMusic.Volume = 0
    end))

    for _, v198 in CollectionService:GetTagged(Sakura.CrystalTag) do
        onCrystalAdded(v198)
    end

    n1 += 1

    local v199 = n1
    local v200 = Lanes.HoldBanner()

    task.spawn(function() -- line: 292
        -- upvalues: v199 (copy), v200 (copy), TweenService (copy), Lanes (copy), v7 (copy), Banner (copy), BannerPosition (copy), n1 (ref)
        while Lanes.IsBannerShowing() and n1 == v199 do
            task.wait(0.1)
        end

        if n1 ~= v199 then
            v200()

            return
        end

        local v201 = BannerPosition - UDim2.fromScale(0, BannerPosition.Y.Scale + Banner.Size.Y.Scale)

        Banner.Position = v201
        v7.Enabled = true
        TweenService:Create(Banner, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = BannerPosition
        }):Play()
        task.wait(7)

        if n1 ~= v199 then
            v200()

            return
        end

        local tween = TweenService:Create(Banner, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = v201
        })

        tween.Completed:Once(function() -- line: 319
            -- upvalues: v199 (copy), v200 (copy), v7 (copy), n1 (ref)
            if n1 == v199 then
                v7.Enabled = false
            end

            v200()
        end)
        tween:Play()
    end)
end

local function refreshAccess() -- line: 1206
    -- upvalues: SakuraBloomPolicy (copy), Save (copy), v18 (ref), refreshReplicatedVisibility (copy), stopPresentation (copy), startPresentation (copy)
    refreshReplicatedVisibility()

    local v202 = Save.IsLoaded()
    local v203 = if v202 then Save.Peek() else nil

    if SakuraBloomPolicy.CanShowBloom(v18, v202, v203) then
        startPresentation()
    else
        stopPresentation()
    end
end

function t19.StartEvent(_, p43, _) -- line: 1215
    -- upvalues: Workspace (copy), SakuraBloomPolicy (copy), Save (copy), n5 (ref), v18 (ref), v19 (ref), refreshReplicatedVisibility (copy), stopPresentation (copy), startPresentation (copy)
    stopPresentation()
    v18 = true
    v19 = false
    n5 = Workspace:GetServerTimeNow() + p43
    refreshReplicatedVisibility()

    local v204 = Save.IsLoaded()
    local v205 = if v204 then Save.Peek() else nil

    if SakuraBloomPolicy.CanShowBloom(v18, v204, v205) then
        startPresentation()
    else
        stopPresentation()
    end
end

function t19.StopEvent(_) -- line: 1223
    -- upvalues: v18 (ref), refreshReplicatedVisibility (copy), stopPresentation (copy)
    v18 = false
    stopPresentation()
    refreshReplicatedVisibility()
end

CameraShakerDriver.Start(v17, Enum.RenderPriority.Camera.Value + 2)
v6.Enabled = false
v7.Enabled = false

for _, v206 in t1 do
    v206.Instance[v206.Property] = 1
end

if v11 and v11:IsA("TextLabel") then
    v11.TextTransparency = 1

    if UIStroke then
        UIStroke.Transparency = 1
    end
end

GUI.OnActivated(Ok, acknowledgeTutorial)
ButtonFX(Ok)
CollectionService:GetInstanceAddedSignal(Sakura.TreeTag):Connect(function(p46) -- line: 1248
    -- upvalues: SakuraBloomPolicy (copy), SakuraBloomVisibility (copy), Save (copy), t18 (copy)
    local v207 = Save.IsLoaded()
    local v208 = if v207 then Save.Peek() else nil
    local v209 = not SakuraBloomPolicy.HasBloomUnlocked(v207, v208)
    local v210 = t18[p46]

    if v210 then
        v210:Clean()
        t18[p46] = nil
    end

    if v209 then
        t18[p46] = SakuraBloomVisibility.Conceal(p46)
    end
end)
CollectionService:GetInstanceRemovedSignal(Sakura.TreeTag):Connect(function(p47) -- line: 1251
    -- upvalues: t18 (copy)
    local v211 = t18[p47]

    if v211 then
        v211:Clean()
        t18[p47] = nil
    end
end)
CollectionService:GetInstanceAddedSignal(Sakura.CrystalTag):Connect(function(p48) -- line: 1254
    -- upvalues: SakuraBloomPolicy (copy), SakuraBloomVisibility (copy), Save (copy), t18 (copy), onCrystalAdded (copy)
    local v212 = Save.IsLoaded()
    local v213 = if v212 then Save.Peek() else nil
    local v214 = not SakuraBloomPolicy.HasBloomUnlocked(v212, v213)
    local v215 = t18[p48]

    if v215 then
        v215:Clean()
        t18[p48] = nil
    end

    if v214 then
        t18[p48] = SakuraBloomVisibility.Conceal(p48)
    end

    onCrystalAdded(p48)
end)
CollectionService:GetInstanceRemovedSignal(Sakura.CrystalTag):Connect(onCrystalRemoved)
CollectionService:GetInstanceRemovedSignal(Sakura.CrystalTag):Connect(function(p49) -- line: 1259
    -- upvalues: t18 (copy)
    local v216 = t18[p49]

    if v216 then
        v216:Clean()
        t18[p49] = nil
    end
end)
CollectionService:GetInstanceAddedSignal("GreatBloomVFX"):Connect(function() -- line: 1262
    -- upvalues: refreshReplicatedVisibility (copy)
    task.defer(refreshReplicatedVisibility)
end)
Remotes.Bloomery.PetalsGathered.OnClientEvent:Connect(function(p50, p51) -- line: 1266
    -- upvalues: SakuraBloomPolicy (copy), SakuraFX (copy), Save (copy), LocalPlayer (copy), showCrystalPopup (copy)
    local v217 = Save.IsLoaded()
    local v218 = if v217 then Save.Peek() else nil

    if not SakuraBloomPolicy.HasBloomUnlocked(v217, v218) then
        return
    end

    showCrystalPopup(p50, p51)
    SakuraFX.EmitBurst("Pickup", p51 + Vector3.new(0, 2, 0), 14, 3)
    SakuraFX.PlayCue("CrystalPickup", LocalPlayer, 0.6, 0.95 + math.random() * 0.15)
end)
Save.WatchFields("SakuraCrystals", function() -- line: 1275
    -- upvalues: SakuraBloomPolicy (copy), Save (copy), v15 (ref), n4 (ref), setCounterShown (copy), popCounter (copy)
    local v219 = Save.IsLoaded()
    local v220 = if v219 then Save.Peek() else nil

    if SakuraBloomPolicy.HasBloomUnlocked(v219, v220) then
        popCounter()
    else
        setCounterShown(false, 0.5)
        n4 = 0
        v15 = false
    end
end)
Save.WatchFields("Sakura", refreshAccess)
Save.Loaded:Connect(function(p52) -- line: 1283
    -- upvalues: SakuraBloomPolicy (copy), Save (copy), LocalPlayer (copy), v18 (ref), refreshReplicatedVisibility (copy), stopPresentation (copy), startPresentation (copy)
    if p52 ~= LocalPlayer then
        return
    end

    refreshReplicatedVisibility()

    local v221 = Save.IsLoaded()
    local v222 = if v221 then Save.Peek() else nil

    if SakuraBloomPolicy.CanShowBloom(v18, v221, v222) then
        startPresentation()
    else
        stopPresentation()
    end
end)
SakuraSignals.ShowTutorial:Connect(showTutorialManually)
refreshReplicatedVisibility()
task.spawn(function() -- line: 1292
    -- upvalues: Remotes (copy), Sakura (copy), t19 (copy)
    local v223 = Remotes.LiveEvents.FetchRunning:InvokeServer()
    local v224 = if typeof(v223) == "table" then v223[Sakura.EventName] else nil

    if typeof(v224) == "number" and v224 - os.time() > 0 then
        t19:StartEvent(v224 - os.time())
    end
end)

return t19
