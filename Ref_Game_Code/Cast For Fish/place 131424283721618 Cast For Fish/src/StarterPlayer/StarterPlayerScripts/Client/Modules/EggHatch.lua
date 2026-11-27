-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local FishModels = require(Shared.FishModels)
local NumberFormat = require(Shared.NumberFormat)
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local ScreenFx = require(script.Parent.ScreenFx)
local Pad = require(script.Parent.Pad)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera, fromRGB, new = workspace.CurrentCamera, Color3.fromRGB, Vector3.new
local v1 = fromRGB(255, 255, 255)
local v2, v3, v4, v5, v6, v7, v8
local v9 = false
local t1 = {}

t1.Playing = false
t1.Played = 0
t1.Stage = nil

local function ownStand() -- line: 35
    -- upvalues: LocalPlayer (copy)
    for _, child in ipairs(workspace.World.Plots:GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child
        end
    end

    return nil
end

local function ringAt(p1, p2, p3, p4) -- line: 44
    -- upvalues: Debris (copy), UIKit (copy), new (copy)
    local Part = Instance.new("Part")

    Part.Shape = Enum.PartType.Cylinder
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = p2
    Part.Transparency = 0.15
    Part.Size = Vector3.new(0.25, 3, 3)
    Part.CFrame = CFrame.new(p1) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = workspace
    UIKit.tween(Part, p4, {
        Transparency = 1,
        Size = new(0.25, p3, p3)
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    Debris:AddItem(Part, p4 + 0.1)
end

local function sparkEmitter(p5, p6) -- line: 62
    -- upvalues: v1 (copy)
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(v1, p6)
    ParticleEmitter.LightEmission = 1
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.1),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 1.1)
    ParticleEmitter.Speed = NumberRange.new(5, 14)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Drag = 2
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = p5

    return ParticleEmitter
end

local t2 = {
    fromRGB(255, 90, 90),
    fromRGB(255, 200, 60),
    fromRGB(110, 225, 110),
    fromRGB(90, 180, 255),
    fromRGB(200, 120, 255)
}
local t3 = {
    GoldenHarvest = {
        fromRGB(255, 206, 70),
        fromRGB(255, 150, 40),
        fromRGB(230, 90, 40),
        fromRGB(196, 50, 50),
        fromRGB(255, 240, 170),
        fromRGB(150, 90, 40)
    }
}

local function screenConfetti(p7) -- line: 81
    -- upvalues: UIKit (copy), v2 (ref)
    local v10 = Random.new()

    for i = 1, 90 do
        local v11 = i % 2 == 0
        local v12 = if v11 then v10:NextNumber(-0.05, 0.25) else v10:NextNumber(0.75, 1.05)
        local v13 = UIKit.frame(v2, {
            Name = "Confetti",
            ZIndex = 40,
            Size = UDim2.fromOffset(v10:NextInteger(12, 22), v10:NextInteger(8, 14)),
            Position = UDim2.fromScale(v12, 1.05),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Color = p7[v10:NextInteger(1, #p7)]
        })

        v13.Rotation = v10:NextInteger(0, 360)

        local v14 = v12 + (if v11 then 1 else -1) * v10:NextNumber(0.05, 0.45)
        local v15 = v10:NextNumber(0.05, 0.45)

        UIKit.tween(v13, v10:NextNumber(0.45, 0.7), {
            Position = UDim2.fromScale(v14, v15),
            Rotation = v13.Rotation + v10:NextInteger(-240, 240)
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out).Completed:Once(function() -- line: 91
            -- upvalues: v10 (copy), v13 (copy), v14 (copy), UIKit (copy)
            if v13.Parent then
                UIKit.tween(v13, v10:NextNumber(1.4, 2.4), {
                    BackgroundTransparency = 0.6,
                    Position = UDim2.fromScale(v14 + v10:NextNumber(-0.08, 0.08), 1.1),
                    Rotation = v13.Rotation + v10:NextInteger(-360, 360)
                }, Enum.EasingStyle.Sine, Enum.EasingDirection.In).Completed:Once(function() -- line: 96
                    -- upvalues: v13 (copy)
                    v13:Destroy()
                end)
            end
        end)
    end
end

local function confetti(p8, p9) -- line: 102
    -- upvalues: Debris (copy), t2 (copy)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(3, 1, 3)
    Part.CFrame = CFrame.new(p8)
    Part.Parent = workspace

    for _, v16 in ipairs(t2) do
        local ParticleEmitter = Instance.new("ParticleEmitter")

        ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        ParticleEmitter.Color = ColorSequence.new(v16)
        ParticleEmitter.LightEmission = 0.35
        ParticleEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(1, 0.5)
        })
        ParticleEmitter.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.8, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        ParticleEmitter.Lifetime = NumberRange.new(1.6, 2.6)
        ParticleEmitter.Speed = NumberRange.new(24, 42)
        ParticleEmitter.SpreadAngle = Vector2.new(50, 50)
        ParticleEmitter.Acceleration = Vector3.new(0, -42, 0)
        ParticleEmitter.Drag = 1.4
        ParticleEmitter.Rotation = NumberRange.new(0, 360)
        ParticleEmitter.RotSpeed = NumberRange.new(-320, 320)
        ParticleEmitter.EmissionDirection = Enum.NormalId.Top
        ParticleEmitter.Rate = 0
        ParticleEmitter.Parent = Part
        ParticleEmitter:Emit(p9)
    end

    Debris:AddItem(Part, 3.5)
end

function t1.Play(p10) -- line: 134
    -- upvalues: Players (copy), RunService (copy), Debris (copy), Fish (copy), Rarities (copy), FishModels (copy), NumberFormat (copy), UIKit (copy), HUD (copy), ScreenFx (copy), Pad (copy), t1 (copy), LocalPlayer (copy), CurrentCamera (copy), fromRGB (copy), new (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), ownStand (copy), ringAt (copy), sparkEmitter (copy), t3 (copy), screenConfetti (copy), confetti (copy)
    local result, v17, v18, v19

    if t1.Playing then
        v19 = true
    elseif type(p10) == "table" then
        if type(p10.result) == "table" then
            t1.Playing = true
            t1.Played += 1
            result = p10.result
            v17 = Fish.ById[result.fishId]
            v18 = v17 and Rarities.ById[v17.rarity]
            v19 = false
        else
            v19 = true
        end
    else
        v19 = true
    end

    if v19 then
        return
    end

    local Color = v18 and v18.Color or fromRGB(255, 215, 60)
    local v20 = ownStand()
    local v21 = v20 and v20:FindFirstChild("Eggs")
    local v22

    if v21 then
        v22 = p10.uid
        v21 = v21:FindFirstChild((tostring(v22)))
    end

    local Character, v23, v24, v25, v26

    if v21 then
        Character, v24 = v21:GetBoundingBox()
        v25 = {
            Size = Vector3.new(0, 0, 0)
        }
        v26 = Character.Position
        v23 = v24.Y / 2 - 0.7
        v25.Position = v26 - new(0, v23, 0)
    end

    Character = LocalPlayer.Character
    v24 = Character and Character:FindFirstChild("HumanoidRootPart")

    if v25 then
        v22 = v25.Position

        local v27 = v25.Size.Y / 2

        v25 = v22 + new(0, v27, 0)
    else
        v25 = if v24 then v24.Position + Vector3.new(0, -2, -8) else Vector3.new(0, 3, 70)
    end

    if v21 then
        v24 = v21:Clone()
        v21:Destroy()
    else
        v24 = v21
    end

    local t4 = {}
    local v28

    if v24 then
        v24.Parent = workspace

        for _, descendant in ipairs(v24:GetDescendants()) do
            if descendant:IsA("ProximityPrompt") or descendant:IsA("BillboardGui") then
                descendant:Destroy()
            end
        end

        for _, descendant in ipairs(v24:GetDescendants()) do
            if descendant:IsA("BasePart") then
                v28 = {
                    part = descendant,
                    color = descendant.Color
                }
                table.insert(t4, v28)
            end
        end

        v20 = v24:GetScale()
    else
        v20 = 1
    end

    v22 = v24 ~= nil and v24:FindFirstChild("Shell") == nil
    v26 = if v24 then v24:GetPivot() else CFrame.new(v25 + Vector3.new(0, 3, 0))

    local v29 = v25 + Vector3.new(0, 3.3, 0)

    HUD.SetMode("cutscene")
    t1.Stage = "charge"

    local t5 = {}

    for _, descendant in ipairs(workspace.World.Plots:GetDescendants()) do
        if descendant:IsA("BillboardGui") and descendant.Enabled then
            table.insert(t5, descendant)
            descendant.Enabled = false
        end
    end

    v23 = RunService.RenderStepped:Connect(function() -- line: 188
        -- upvalues: Players (copy)
        for _, player in ipairs(Players:GetPlayers()) do
            local Character = player.Character

            if Character then
                for _, descendant in ipairs(Character:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        descendant.LocalTransparencyModifier = 1
                    end
                end
            end
        end
    end)

    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local MoveLock = require(script.Parent.MoveLock)

    MoveLock.Hold("hatch")
    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local v30 = CFrame.lookAt(v29 + Vector3.new(7, 3.5, -15), v29 + Vector3.new(0, 0.6, 0))

    v28 = CFrame.lookAt(v29 + Vector3.new(4, 1.8, -10.5), v29 + Vector3.new(0, 0.4, 0))
    CurrentCamera.CFrame = v30
    CurrentCamera.FieldOfView = 60

    local Part = v3

    Part.Text = string.upper(p10.name or "Egg")
    v3.Visible = true
    v4.Visible = true
    v5.Visible = false
    v6.Visible = false
    v7.Visible = false
    v8.Visible = false
    v2.Enabled = true
    UIKit.pop(v3, 0.6)
    UIKit.sound("EggStart")
    UIKit.sound("EggRise")
    ringAt(v25 + Vector3.new(0, 0.2, 0), Color, 30, 0.7)
    Part = Instance.new("Part")
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(5, 6, 5)
    Part.CFrame = CFrame.new(v29)
    Part.Parent = workspace

    local v31 = sparkEmitter(Part, Color)
    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Range = 0
    PointLight.Brightness = 3
    PointLight.Shadows = false
    PointLight.Parent = Part

    local Part2 = Instance.new("Part")

    Part2.Shape = Enum.PartType.Cylinder
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v1
    Part2.Transparency = 1
    Part2.Size = Vector3.new(4, 1, 1)
    Part2.CFrame = CFrame.new(v29) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part2.Parent = workspace

    local t6 = {}

    for i = 1, 8 do
        local Part = Instance.new("Part")

        Part.Shape = Enum.PartType.Ball
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Material = Enum.Material.Neon

        if i % 2 == 0 then
            Part.Color = Color
        else
            Part.Color = v1
        end

        Part.Size = Vector3.new(0.7, 0.7, 0.7)
        Part.Transparency = 1
        Part.Parent = workspace
        t6[i] = Part
    end

    local v32 = false
    local SkipButton = require(script.Parent.SkipButton)

    SkipButton.Show("hatch", function() -- line: 273
        -- upvalues: v32 (ref)
        v32 = true
    end)

    local elapsed = os.clock()
    local n1 = 0
    local n2 = 0
    local n3 = 0
    local n4 = 0
    local rep, v33, result2, ok, v34, v35, v36, v37, v38, v39, ok2

    while true do
        local v40 = os.clock() - elapsed

        if v32 then
            ok2 = 1
        else
            v34 = v40 / 3.8
            ok2 = math.clamp(v34, 0, 1)
        end

        v34 = v4
        v39 = if v22 then "OPENING" else "HATCHING"
        rep = string.rep
        v33 = v40 * 2.5
        v34.Text = v39 .. rep(".", math.floor(v33) % 3 + 1)

        if v24 then
            v39 = v40 * (ok2 * 26 + 9)
            v38 = math.sin(v39)
            rep = ok2 * 15 * ok2 + 3
            v34 = v38 * math.rad(rep)
            result2 = v40 * (ok2 * 14 + 6)
            ok = math.sin(result2)
            v38 = math.abs(ok) * 0.5 * ok2
            v24:ScaleTo(v20 * (ok2 * 0.38 * ok2 + 1))
            v24:PivotTo(v26 * CFrame.new(0, v38, 0) * CFrame.Angles(0, 0, v34) * CFrame.Angles(v34 * 0.5, v40 * ok2 * 2, 0))
            v38 = ok2 ^ 1.6

            for _, v41 in ipairs(t4) do
                v41.part.Color = v41.color:Lerp(v1, v38)

                if ok2 > 0.55 and v41.part.Material ~= Enum.Material.Neon then
                    v41.part.Material = Enum.Material.Neon
                end
            end
        end

        v31.Rate = ok2 * 150 * ok2 + 6
        v34 = ok2 * 46 * ok2 + 4
        rep = ok2 * 3.2 + 1.2
        ok = ok2 * 3.2 + 1.2
        Part2.Size = new(v34, rep, ok)
        v39 = CFrame.new
        v35 = v34 / 2
        Part2.CFrame = v39(v29 + new(0, v35, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
        Part2.Transparency = 1 - ok2 * 0.55

        for v42, v43 in ipairs(t6) do
            v34 = v40 * (ok2 * 5 + 2) + v42 * (6.283185307179586 / #t6)
            v35 = 9 - ok2 * 6.5

            local v44 = math.cos(v34) * v35

            v36 = math.sin(v40 * 3 + v42) * 1.5 + 0.5
            v37 = math.sin(v34) * v35
            v43.Position = v29 + new(v44, v36, v37)
            v43.Transparency = 0.55 - ok2 * 0.5
        end

        if n1 <= v40 then
            n1 = v40 + (0.7 - ok2 * 0.5)
            ringAt(v25 + Vector3.new(0, 0.2, 0), Color, ok2 * 24 + 16, 0.6)
        end

        if n2 < 2 and n2 * 0.28 + 0.45 <= ok2 then
            n2 += 1
            v31:Emit(35)
            n3 = 1
            UIKit.sound("EggCrack", n2 * 0.25 + 0.9)
        end

        rep = n3 - 0.06
        n3 = math.max(0, rep)
        PointLight.Range = ok2 * 40
        v38 = ok2 * 0.18 * ok2 + n3 * 0.5
        CurrentCamera.CFrame = v30:Lerp(v28, 1 - (1 - ok2) ^ 2) * CFrame.new(math.noise(v40 * 14, 3.3) * v38, math.noise(v40 * 14, 9.1) * v38, 0)
        CurrentCamera.FieldOfView = 60 - ok2 * 12

        if 0.42 - ok2 * 0.34 <= v40 - n4 then
            n4 = v40
            UIKit.sound("EggShake", ok2 * 1.1 + 0.8)
        end

        if ok2 >= 1 then
            break
        end

        RunService.RenderStepped:Wait()
    end

    t1.Stage = "flash"
    v31:Emit(120)
    v31.Rate = 0
    ScreenFx.Fade(1, 0.14, v1)
    UIKit.sound("EggBurst")
    UIKit.sound("EggShine")
    n4 = require(script.Parent.CutsceneFx)
    n4.Crack()
    n4.Duck(2.5)
    task.wait(0.22)

    for _, v46 in ipairs(t6) do
        v46:Destroy()
    end

    UIKit.tween(Part2, 1.1, {
        Size = Vector3.new(140, 16, 16),
        Transparency = 1,
        CFrame = CFrame.new(v29 + Vector3.new(0, 70, 0)) * CFrame.Angles(0, 0, 1.5707963267948966)
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    Part2.Color = Color
    Debris:AddItem(Part2, 1.2)

    if v24 then
        elapsed = Random.new()

        for _, v47 in ipairs(t4) do
            n3 = v47.part

            if n3.Parent and n3.Transparency < 1 then
                ok = elapsed:NextNumber(-1, 1)
                result2 = elapsed:NextNumber(0.1, 1.1)
                n2 = new(ok, result2, elapsed:NextNumber(-1, 1)).Unit
                rep = UIKit.tween
                v35 = {
                    Transparency = 1,
                    Position = n3.Position + n2 * elapsed:NextNumber(12, 28) - Vector3.new(0, 5, 0)
                }
                v33 = n3.Orientation
                v36 = elapsed:NextNumber(-360, 360)
                v37 = elapsed:NextNumber(-360, 360)
                v35.Orientation = v33 + new(v36, v37, elapsed:NextNumber(-360, 360))
                rep(n3, 0.95, v35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            end
        end

        Debris:AddItem(v24, 1.05)
    end

    v3.Visible = false
    v4.Visible = false

    local result3

    v34 = FishModels.Get
    v38 = result.fishId
    v39 = result.variant
    rep = result.size

    local result4

    ok2, result4 = pcall(v34, v38, v39, rep)

    if ok2 and result4 then
        result3 = result4
        v38 = result4:GetExtentsSize()
        v39 = v38.X
        rep = v38.Y
        ok = v38.Z
        v38 = math.max(v39, rep, ok, 0.1)
        result4:ScaleTo(result4:GetScale() * 11 / v38)
        result4.Parent = workspace
    end

    local v48 = v29 + Vector3.new(0, 8, 0)
    local elapsed2 = os.clock()

    local function placeFish() -- line: 383
        -- upvalues: result3 (ref), v48 (copy), elapsed2 (copy), FishModels (copy), new (copy)
        if not result3 then
            return
        end

        local v49 = os.clock() - elapsed2
        local result = result3

        result:PivotTo(CFrame.new(v48 + new(0, math.sin(v49 * 1.8) * 0.35, 0)) * CFrame.Angles(0, v49 * 0.9, 0))

        local Animate = FishModels.Animate

        pcall(Animate, result, v49)
    end

    placeFish()

    local v52 = CFrame.lookAt(v29 + Vector3.new(3, -1, -13), v48 + Vector3.new(0, -1.2, 0))

    CurrentCamera.CFrame = v52
    CurrentCamera.FieldOfView = 58
    PointLight.Color = Color
    PointLight.Range = 30
    v38 = RunService.RenderStepped:Connect(placeFish)

    local v53 = os.clock() + 0.55

    v39 = RunService.RenderStepped:Connect(function() -- line: 398
        -- upvalues: v52 (copy), v53 (ref), CurrentCamera (copy)
        local v54 = v53 - os.clock()
        local elapsed = os.clock()

        CurrentCamera.CFrame = if v54 > 0 then v52 * CFrame.new(math.noise(elapsed * 30, 1.1) * v54 * 2.4, math.noise(elapsed * 30, 5.5) * v54 * 2.4, 0) else v52
    end)
    ScreenFx.Fade(0, 0.55)
    ringAt(v25 + Vector3.new(0, 0.3, 0), Color, 60, 0.9)
    ringAt(v25 + Vector3.new(0, 0.3, 0), v1, 36, 0.6)
    v31.Color = ColorSequence.new(v1, Color)
    Part.Size = Vector3.new(9, 6, 9)
    Part.CFrame = CFrame.new(v48)
    v31:Emit(80)
    v31.Rate = 24
    ringAt(v25 + Vector3.new(0, 0.3, 0), Color, 90, 1.2)
    confetti(v25 + Vector3.new(0, 1, 0), 16)
    ScreenFx.Flash(0.35, Color)
    UIKit.tween(CurrentCamera, 0.8, {
        FieldOfView = 50
    }, Enum.EasingStyle.Back)
    t1.Stage = "letters"

    local v56 = string.upper(v17 and v17.name or "???")
    local t7 = {}
    local name = {}
    local part

    for i = 1, #v56 do
        part = v56:sub(i, i)
        t7[i] = part == " " and " " or "_"

        if part ~= " " then
            table.insert(name, i)
        end
    end

    v5.TextColor3 = Color
    ok = v5
    ok.Text = table.concat(t7)
    ok = v5
    ok.Visible = true

    local CutsceneFx = require(script.Parent.CutsceneFx)

    result2 = function() -- line: 432
        -- upvalues: CutsceneFx (copy)
        return (math.max(2, CutsceneFx.Thrill("minnow", 1, 1)))
    end

    ok, result2 = pcall(result2)

    if not ok then
        result2 = 2
    end

    CutsceneFx.Sting(result2)
    CutsceneFx.Grade(Color, 0.5 + 0.1 * result2, 0.3)
    CutsceneFx.Haptic(1 + result2)
    task.delay(4, CutsceneFx.GradeOff, 0.6)

    part = function() -- line: 440
        -- upvalues: CutsceneFx (copy)
        local v57 = require(game:GetService("ReplicatedStorage").Shared.Data.Variants).List[1]

        if v57 then
            CutsceneFx.Mutation(v57.id)
        end
    end

    pcall(part)
    task.wait(v32 and 0.05 or 0.35)
    ok = Random.new()

    while #name > 0 and not v32 do
        local wait = table.remove(name, ok:NextInteger(1, #name))

        t7[wait] = v56:sub(wait, wait)
        wait = v5
        wait.Text = table.concat(t7)
        UIKit.sound("LetterPop", (1 - #name / #v56) * 0.9 + 1)
        wait = task.wait
        v35 = 1.1 / #v56
        wait((math.clamp(v35, 0.05, 0.13)))
    end

    v5.Text = v56
    SkipButton.Hide("hatch")
    UIKit.pop(v5, 1.25)
    UIKit.sound(not result.isNew and (not v18 or not ((v18.order or 0) >= 5)) and "RevealGood" or "RevealRare")
    confetti(v25 + Vector3.new(0, 1, 0), 12)

    if t3[p10.key] then
        screenConfetti(t3[p10.key])
    end

    v53 = os.clock() + 0.3
    ringAt(v25 + Vector3.new(0, 0.3, 0), Color, 44, 0.7)
    v31:Emit(40)
    t1.Stage = "result"
    ok = v6
    v35 = if result.pct then result.pct .. "%   " else ""
    ok.Text = v35 .. NumberFormat.rate(result.income or 0)
    v6.Visible = true
    UIKit.pop(v6, 0.8)
    UIKit.sound("Cash")
    ok = v7
    ok.Visible = result.isNew == true

    if v7.Visible then
        UIKit.pop(v7, 1.4)
    end

    task.wait(0.7)
    name = if Pad.Using() then "press" else "tap"
    ok = v8

    if not (p10.more and p10.more > 0) then
        ok.Text = name .. " to continue"
    else
        ok.Text = name .. " to continue  (" .. p10.more .. " more to hatch)"
    end

    v8.Visible = true
    v9 = false
    name = os.clock()

    while not v9 and os.clock() - name < 12 do
        task.wait()
    end

    UIKit.sound("Continue")
    t1.Stage = nil
    v38:Disconnect()
    v39:Disconnect()
    v23:Disconnect()

    for _, player in ipairs(Players:GetPlayers()) do
        name = player.Character

        if name then
            for _, descendant in ipairs(name:GetDescendants()) do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end
    end

    for _, v58 in ipairs(t5) do
        if v58.Parent then
            v58.Enabled = true
        end
    end

    v2.Enabled = false

    if result3 then
        result3:Destroy()
    end

    Part:Destroy()
    MoveLock.Free("hatch")
    CurrentCamera.CameraType = Enum.CameraType.Custom

    if Humanoid then
        CurrentCamera.CameraSubject = Humanoid
    end

    CurrentCamera.FieldOfView = 70
    HUD.SetMode("normal")
    t1.Playing = false
end

function t1.Tap() -- line: 524
    -- upvalues: v9 (ref)
    v9 = true
end

function t1.Init() -- line: 528
    -- upvalues: UserInputService (copy), ReplicatedStorage (copy), Shared (copy), FishModels (copy), UIKit (copy), HUD (copy), ScreenFx (copy), Pad (copy), t1 (copy), CurrentCamera (copy), fromRGB (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref)
    v2 = UIKit.screenGui("EggHatch", 30)
    v2.Enabled = false
    v3 = UIKit.text(v2, {
        Name = "Title",
        Text = "",
        TextSize = 54,
        Stroke = 6,
        Size = UDim2.new(1, -40, 0, 60),
        Position = UDim2.new(0, 20, 0, 70),
        Color = fromRGB(190, 120, 255)
    })
    v4 = UIKit.text(v2, {
        Name = "Status",
        Text = "HATCHING",
        TextSize = 30,
        Stroke = 4,
        Size = UDim2.new(1, -40, 0, 34),
        Position = UDim2.new(0, 20, 0, 132)
    })
    v5 = UIKit.text(v2, {
        Name = "Name",
        Text = "",
        TextSize = 84,
        Stroke = 7,
        Size = UDim2.new(1, -40, 0, 96),
        Position = UDim2.new(0, 20, 1, -290)
    })
    v5.TextScaled = true
    v6 = UIKit.text(v2, {
        Name = "Earn",
        Text = "",
        TextSize = 40,
        Stroke = 5,
        Size = UDim2.new(1, -40, 0, 46),
        Position = UDim2.new(0, 20, 1, -190),
        Color = fromRGB(255, 215, 60)
    })
    v7 = UIKit.text(v2, {
        Name = "New",
        Text = "NEW!",
        TextSize = 40,
        Stroke = 5,
        Rotation = 12,
        Size = UDim2.fromOffset(150, 50),
        Position = UDim2.new(0.5, 280, 1, -320),
        Color = fromRGB(255, 150, 40)
    })
    v8 = UIKit.text(v2, {
        Name = "Tap",
        Text = "tap to continue",
        TextSize = 24,
        Stroke = 4,
        Size = UDim2.new(1, -40, 0, 28),
        Position = UDim2.new(0, 20, 1, -136)
    })
    Pad.IconBeside(v8, Enum.KeyCode.ButtonA, 38)
    UserInputService.InputBegan:Connect(function(p11) -- line: 539
        -- upvalues: t1 (copy), v9 (ref)
        if t1.Stage == "result" and (p11.UserInputType == Enum.UserInputType.MouseButton1 or p11.UserInputType == Enum.UserInputType.Touch or p11.KeyCode == Enum.KeyCode.Space or p11.KeyCode == Enum.KeyCode.ButtonA) then
            v9 = true
        end
    end)
    ReplicatedStorage.Remotes.EggHatched.OnClientEvent:Connect(function(p12) -- line: 544
        -- upvalues: HUD (copy), ScreenFx (copy), t1 (copy), CurrentCamera (copy), v2 (ref)
        local Play = t1.Play
        local ok, result = pcall(Play, p12)

        if ok then
            return
        end

        warn("[EggHatch] " .. tostring(result))
        require(script.Parent.SkipButton).Hide("hatch")
        require(script.Parent.MoveLock).Free("hatch")
        t1.Playing = false
        t1.Stage = nil
        v2.Enabled = false
        ScreenFx.Fade(0, 0.2)
        CurrentCamera.CameraType = Enum.CameraType.Custom
        HUD.SetMode("normal")
    end)

    local Products = require(Shared.Data.Products)
    local DataClient = require(script.Parent.DataClient)
    local t8 = {}

    local function prepare(p13) -- line: 561
        -- upvalues: Products (copy), t8 (copy), FishModels (copy)
        if type(p13) == "string" and not t8[p13] then
            local v59 = Products.CrateByKey(p13)

            if v59 then
                t8[p13] = true

                local t9 = {}

                for _, v60 in ipairs(v59.pool) do
                    table.insert(t9, v60.fish)
                end

                task.spawn(pcall, FishModels.Prepare, t9)
            end
        end
    end

    local function prepareAll() -- line: 576
        -- upvalues: DataClient (copy), prepare (copy)
        for _, v61 in ipairs(DataClient.Get("Eggs") or {}) do
            prepare(v61)
        end

        for _, v62 in ipairs(DataClient.Get("EggsPlaced") or {}) do
            prepare(type(v62) == "table" and v62.key)
        end
    end

    DataClient.Observe("Eggs", prepareAll)
    DataClient.Observe("EggsPlaced", prepareAll)
end

return t1
