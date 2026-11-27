-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Effects = require(script.Parent.Effects)
local Skip = require(script.Parent.Skip)
local NewBest = require(script.Parent.NewBest)
local BestMarker = require(script.Parent.Parent.World.BestMarker)
local t1 = {}
local v1 = Random.new()
local v2 = Color3.new(1, 1, 1)
local t2 = {
    0, 2, 4, 5, 7, 9, 11
}

local function makeBobber() -- line: 39
    -- upvalues: Effects (copy)
    local v3 = Effects.part({
        Name = "Bobber",
        Size = Vector3.new(0.9, 0.9, 0.9),
        Shape = Enum.PartType.Ball,
        Color = Color3.fromRGB(235, 45, 45),
        Parent = workspace
    })
    local v4 = Effects.part({
        Name = "Cap",
        Size = Vector3.new(0.62, 0.62, 0.62),
        Shape = Enum.PartType.Ball,
        Color = Color3.new(1, 1, 1),
        Parent = v3
    })
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Line"
    Attachment.Position = Vector3.new(0, 0.4, 0)
    Attachment.Parent = v3

    local Attachment2 = Instance.new("Attachment")
    local Attachment3 = Instance.new("Attachment")

    Attachment2.Position = Vector3.new(0, 0.5, 0)
    Attachment3.Position = Vector3.new(0, -0.5, 0)
    Attachment2.Parent = v3
    Attachment3.Parent = v3

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment2
    Trail.Attachment1 = Attachment3
    Trail.Lifetime = 0.6
    Trail.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(255, 200, 120))
    Trail.Transparency = NumberSequence.new(0.1, 1)
    Trail.WidthScale = NumberSequence.new(1, 0)
    Trail.LightEmission = 1
    Trail.FaceCamera = true
    Trail.Parent = v3

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(255, 220, 160)
    PointLight.Range = 10
    PointLight.Brightness = 2
    PointLight.Parent = v3

    return v3, v4, Trail, PointLight
end

local function attachLine(p1, p2) -- line: 67
    local Beam = Instance.new("Beam")

    Beam.Attachment0 = p1
    Beam.Attachment1 = p2
    Beam.Width0 = 0.05
    Beam.Width1 = 0.05
    Beam.Color = ColorSequence.new(Color3.fromRGB(240, 240, 240))
    Beam.Transparency = NumberSequence.new(0.15)
    Beam.FaceCamera = true
    Beam.LightInfluence = 0
    Beam.Segments = 1
    Beam.Parent = p2.Parent

    return Beam
end

local function luckText(p3) -- line: 84
    if p3 < 10 then
        return (string.format("Luck x%.1f", p3))
    end

    return (("Luck x%*"):format((math.floor(p3))))
end

local function luckIcon(p4) -- line: 89
    -- upvalues: Config (copy)
    if p4:FindFirstChild("Icon") then
        return
    end

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = Config.Icons.Luck
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.AnchorPoint = Vector2.new(1, 0.5)
    ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.Parent = p4

    local function place() -- line: 102
        -- upvalues: p4 (copy), ImageLabel (copy)
        local v5 = if p4.Size.Y.Offset > 0 then p4.AbsoluteSize.Y / p4.Size.Y.Offset else 1
        local v6 = p4.TextBounds.X / math.max(v5, 0.01)

        ImageLabel.Position = UDim2.new(0.5, -v6 / 2 - 8, 0.5, 0)
    end

    p4:GetPropertyChangedSignal("TextBounds"):Connect(place)
    p4:GetPropertyChangedSignal("AbsoluteSize"):Connect(place)
    place()
end

local function luckStep(p5) -- line: 114
    if p5 < 10 then
        return 1
    end

    if p5 < 40 then
        return 2
    end

    if p5 < 100 then
        return 5
    end

    return 10 ^ math.floor(math.log10(p5) - 1)
end

local function windLines(p6) -- line: 127
    -- upvalues: Debris (copy), UIUtil (copy), v1 (copy)
    local Frame = Instance.new("Frame")

    Frame.Name = "WindLines"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.Parent = p6

    local n1 = 0

    return function(p7, p8) -- line: 134
        -- upvalues: Frame (copy), n1 (ref), Debris (copy), UIUtil (copy), v1 (copy)
        local v8 = n1

        n1 = v8 + p7 * 34 * p8

        while n1 >= 1 do
            n1 -= 1

            local v9 = v1:NextNumber(0, 6.283185307179586)
            local v10 = Vector2.new(math.cos(v9), (math.sin(v9)))
            local v11 = v1:NextNumber(0.22, 0.42)
            local v12 = v1:NextNumber(40, 110)
            local Frame2 = Instance.new("Frame")

            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = Color3.new(1, 1, 1)
            Frame2.BackgroundTransparency = v1:NextNumber(0.35, 0.6)
            Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame2.Position = UDim2.fromScale(0.5 + v10.X * v11, 0.5 + v10.Y * v11)
            Frame2.Size = UDim2.fromOffset(v12, v1:NextInteger(2, 3))
            Frame2.Rotation = math.deg(v9)
            Frame2.Parent = Frame

            local v13 = v1:NextNumber(0.18, 0.3)
            local v14 = v11 + 0.2

            UIUtil.tween(Frame2, v13, {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5 + v10.X * v14, 0.5 + v10.Y * v14),
                Size = UDim2.fromOffset(v12 * 1.8, 1)
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            Debris:AddItem(Frame2, v13 + 0.05)
        end
    end, function() -- line: 160
        -- upvalues: Frame (copy)
        task.delay(0.4, function() -- line: 161
            -- upvalues: Frame (copy)
            Frame:Destroy()
        end)
    end
end

local function moveBobber(p9, p10, p11) -- line: 167
    p9.CFrame = CFrame.new(p11)
    p10.CFrame = CFrame.new(p11 + Vector3.new(0, 0.22, 0))
end

function t1.fightSide(p12) -- line: 174
    -- upvalues: Canyon (copy)
    if p12.Z + 14 > -Canyon.dockS(-p12.Z) - 3 then
        return -1
    end

    return 1
end

function t1.fightView(p13) -- line: 180
    -- upvalues: Canyon (copy), t1 (copy)
    local v15 = t1.fightSide(p13)

    return CFrame.lookAt(Canyon.clearView(p13 + Vector3.new(5, 5.5, 11 * v15), p13), p13 + Vector3.new(0, 0.3, 0))
end

local function throwText(p14, p15) -- line: 188
    -- upvalues: Config (copy), Format (copy)
    local v17 = Config.nextBiome(p14)
    local v18 = ("<font color=\"#%*\">%*m</font>"):format(if p15 then "FFFFFF" else "FFE15A", (Format.short((math.floor(p14)))))

    if v17 then
        return (("%* <font color=\"#C8D2E6\">/ %*m to %*</font>"):format(v18, Format.short(v17.Start), v17.Name))
    end

    return v18
end

local function roundStep(p16) -- line: 198
    local v21 = 10 ^ math.floor((math.log10((math.max(p16, 1)))))
    local v22 = p16 / v21

    return (if v22 < 2 then 1 elseif v22 < 5 then 2 else 5) * v21
end

local function biomePitch(p17) -- line: 205
    -- upvalues: t2 (copy)
    local v23 = p17 - 2

    return 0.85 * 2 ^ ((t2[v23 % 7 + 1] + math.floor(v23 / 7) * 12) / 12)
end

local function flashText(p18, p19, p20) -- line: 212
    -- upvalues: UIUtil (copy), v2 (copy)
    p18.TextColor3 = v2
    UIUtil.tween(p18, p20, {
        TextColor3 = p19
    }, Enum.EasingStyle.Quad)
end

t1.makeBobber = makeBobber
t1.attachLine = attachLine
t1.moveBobber = moveBobber

function t1.flightTime(p21) -- line: 224
    -- upvalues: Config (copy), Canyon (copy)
    local v26 = Config.toStuds(p21)

    return (1.8 + (v26 - Canyon.dockS(v26)) / 450) * Config.CastPace * 1.35
end

function t1.arcHeight(p22) -- line: 231
    -- upvalues: Config (copy), Canyon (copy)
    return (math.min(12 + Canyon.worldProgress(Config.toStuds(p22)) * 4, 36))
end

function t1.landing(p23, p24) -- line: 237
    -- upvalues: Config (copy), Canyon (copy), Effects (copy)
    local v28 = Canyon.landing(Config.toStuds(p23))

    return Vector3.new(math.clamp(p24, -38, 38), Canyon.surface(v28), -v28), Effects.liquidAt(v28)
end

local function arc(p25) -- line: 254
    return p25 * 1 * (1 - p25) + p25 * 5.0625 * (1 - p25) * (1 - p25)
end

function t1.flightPoint(p26, p27, p28, p29) -- line: 257
    -- upvalues: Canyon (copy)
    local v32 = p26:Lerp(p27, p29 + p29 * 0.8 * (1 - p29))
    local v34 = p26.Y - Canyon.surface((math.max(-p26.Z, 0)))
    local v36 = math.max((p26.Z - p27.Z) * 0.12, 40)
    local v38 = Canyon.flightLine(math.max(-v32.Z, 0), -p27.Z, v36)

    return (Vector3.new(v32.X, v38 + v34 * (1 - p29) ^ 1.6 + p28 * (p29 * 1 * (1 - p29) + p29 * 5.0625 * (1 - p29) * (1 - p29)), v32.Z))
end

function t1.run(p30, p31, p32, p33) -- line: 272
    -- upvalues: RunService (copy), Config (copy), Canyon (copy), Format (copy), UIUtil (copy), Effects (copy), Skip (copy), NewBest (copy), BestMarker (copy), t1 (copy), v1 (copy), v2 (copy), t2 (copy), makeBobber (copy), attachLine (copy), luckIcon (copy), windLines (copy)
    local CurrentCamera = workspace.CurrentCamera
    local CastInfo = p32.CastInfo
    local WorldPosition = p31.WorldPosition
    local v40, v41 = t1.landing(p30.Distance, p30.LandX or WorldPosition.X + v1:NextNumber(-14, 14))
    local Y = v40.Y
    local v42 = if v41 then v41.Color else Color3.fromRGB(80, 170, 230)
    local v43, v44, v45, v46 = makeBobber()
    local v47 = attachLine(p31, v43.Line)

    v43.CFrame = CFrame.new(WorldPosition)
    v44.CFrame = CFrame.new(WorldPosition + Vector3.new(0, 0.22, 0))

    local v48 = t1.flightTime(p30.Distance)
    local v49 = t1.arcHeight(p30.Distance)
    local _CFrame = CurrentCamera.CFrame
    local v50 = (p30.Luck or 1) / Config.castLuck(p30.Distance)

    CastInfo.Visible = true
    CastInfo.Distance.RichText = true

    local Distance = CastInfo.Distance
    local v51 = Config.nextBiome(0)
    local CastPace = ("<font color=\"#FFE15A\">%*m</font>"):format((Format.short(0)))

    if v51 then
        CastPace = ("%* <font color=\"#C8D2E6\">/ %*m to %*</font>"):format(CastPace, Format.short(v51.Start), v51.Name)
    end

    Distance.Text = CastPace
    Distance = CastInfo.Luck

    if v50 < 10 then
        Distance.Text = string.format("Luck x%.1f", v50)
    else
        Distance.Text = ("Luck x%*"):format((math.floor(v50)))
    end

    luckIcon(CastInfo.Luck)
    Distance = CastInfo.Luck:GetAttribute("BaseHeight") or CastInfo.Luck.Size.Y.Offset
    CastInfo.Luck:SetAttribute("BaseHeight", Distance)

    local v52 = Distance * 1.6

    CastInfo.Luck.Size = UDim2.new(CastInfo.Luck.Size.X, UDim.new(0, v52))
    Distance = CastInfo.Biome
    v51 = Distance.Position.Y.Offset + Distance.Size.Y.Offset * (1 - Distance.AnchorPoint.Y)
    CastInfo.Luck.AnchorPoint = Vector2.new(CastInfo.Luck.AnchorPoint.X, 0)
    CastInfo.Luck.Position = UDim2.new(CastInfo.Luck.Position.X, UDim.new(0, v51 + 4))
    v51 = CastInfo.Luck:GetAttribute("BaseColor") or CastInfo.Luck.TextColor3
    CastInfo.Luck:SetAttribute("BaseColor", v51)
    CastInfo.Luck.TextColor3 = v51
    CastInfo.Distance.Visible = false

    local v53, v54

    for v55, v56 in {
            CastInfo.Biome,
            CastInfo.Luck
        } do
        v56.Visible = false
        v53 = task.delay
        v54 = (v55 - 1) * 0.07
        v53(v54, function() -- line: 313
            -- upvalues: v56 (copy), UIUtil (copy)
            v56.Visible = true
            UIUtil.pop(v56, 0.35)
        end)
    end

    CurrentCamera.FieldOfView = 96
    UIUtil.tween(CurrentCamera, v48, {
        FieldOfView = 80
    }, Enum.EasingStyle.Quad)

    local v57 = UIUtil.sound("BaitFlight", 0.1, 1, v48 + 1)

    if v57 then
        v57.Looped = true
    end

    CastPace = Config.CastPace

    local elapsed = os.clock()

    v54 = p30.Distance / 10

    local v58
    local v60 = 10 ^ math.floor((math.log10((math.max(v54, 1)))))
    local v61 = v54 / v60

    v53 = (if v61 < 2 then 1 elseif v61 < 5 then 2 else 5) * v60

    local v63

    if v50 < 10 then
        v58 = 1
    elseif v50 < 40 then
        v58 = 2
    elseif v50 < 100 then
        v58 = 5
    else
        v63 = math.log10(v50) - 1
        v58 = 10 ^ math.floor(v63)
    end

    local v59 = v50 + v58
    local v64

    v58, v64 = windLines(p32)

    local v65 = p30.Best or 0

    v63 = v65 > 0 and v65 < p30.Distance and (game:GetService("Players").LocalPlayer:GetAttribute("Tutorial") or 0) >= Config.TutorialDone

    local v70 = 0
    local v68 = 0
    local v67 = 0
    local v69 = 0

    v54 = 0
    v60 = 0
    v61 = 0

    local v62 = 0
    local v66 = os.clock()
    local v71, v72, v73, v74, v75, v76, v77, v78, v79

    while true do
        v71 = os.clock()

        local v80 = v71 - v66

        if v71 < v67 then
            v68 += v80
        end

        v73 = (v71 - elapsed - v68) / v48
        v72 = math.min(v73, 1)
        v73 = t1.flightPoint(WorldPosition, v40, v49, v72)
        v43.CFrame = CFrame.new(v73)
        v44.CFrame = CFrame.new(v73 + Vector3.new(0, 0.22, 0))

        local v81, v82

        if v72 >= 1 then
            v81 = p30.Distance
        else
            v81 = Config.toMeters
            v82 = -v73.Z
            v81 = v81((math.max(0, v82)))
        end

        local v83 = CastInfo.Distance

        v82 = Config.nextBiome(v81)

        local v84 = ("<font color=\"#FFE15A\">%*m</font>"):format((Format.short((math.floor(v81)))))

        if v82 then
            v84 = ("%* <font color=\"#C8D2E6\">/ %*m to %*</font>"):format(v84, Format.short(v82.Start), v82.Name)
        end

        v83.Text = v84

        if v63 and v65 <= v81 then
            v67 = v71 + 0.16 * CastPace
            BestMarker.burst()
            v69 = 2.2
            v63 = false
            NewBest.play(p32, v65)
        end

        local v85 = v81 / v53

        v83 = math.floor(v85)

        if v54 < v83 then
            v54 = v83
            UIUtil.pop(CastInfo.Luck, 1.05)
        end

        v83 = v50 * Config.castLuck(v81)

        local v86 = false
        local v87 = false
        local v88 = false
        local v89 = false
        local v90 = false
        local v91 = false
        local v92, v93, v94, v95

        if v83 == v70 then
            v92 = v70
            v95 = v61
            v94 = v62
            v93 = v59
            v91 = true
        else
            v86 = true
        end

        local v96

        if v86 then
            v74 = os.clock()

            if v59 <= v83 then
                v87 = true
            else
                v96 = v61
                v78 = v62
                v77 = v59
                v91 = false
            end
        end

        v86 = false

        if v87 then
            if v74 - v62 > 0.11 then
                v86 = true
            else
                v96 = v61
                v78 = v62
                v77 = v59
                v91 = false
            end
        end

        v87 = false

        local v97

        if v86 then
            v97 = v61 + 1

            if v83 < 10 then
                v88 = true
            else
                v87 = true
            end
        end

        v86 = false

        if v87 then
            if v83 < 40 then
                v89 = true
            else
                v86 = true
            end
        end

        v87 = false

        if v86 then
            if v83 < 100 then
                v90 = true
            else
                v87 = true
            end
        end

        v86 = false

        local v98, v99

        if v87 then
            v98 = math.log10(v83) - 1
            v99 = 10 ^ math.floor(v98)
            v86 = true
        end

        v87 = false

        if v90 then
            v99 = 5
            v86 = true
        end

        v90 = false

        if v89 then
            v99 = 2
            v86 = true
        end

        v89 = false

        if v88 then
            v99 = 1
            v86 = true
        end

        v88 = false

        local v100, v101

        if v86 then
            v100 = v83 / v99
            v101 = math.floor(v100) + 1

            if v83 < 10 then
                v87 = true
            else
                v90 = true
            end
        end

        v86 = false

        if v90 then
            if v83 < 40 then
                v89 = true
            else
                v86 = true
            end
        end

        v90 = false

        if v86 then
            if v83 < 100 then
                v88 = true
            else
                v90 = true
            end
        end

        v86 = false

        if v90 then
            v75 = math.log10(v83) - 1
            v76 = 10 ^ math.floor(v75)
            v86 = true
        end

        if v88 then
            v76 = 5
            v86 = true
        end

        if v89 then
            v76 = 2
            v86 = true
        end

        if v87 then
            v76 = 1
            v86 = true
        end

        if v86 then
            v77 = v101 * v76
            v82 = UIUtil.sound
            v75 = v97 * 0.03 + 0.9
            v82("Tick", 0.35, (math.min(v75, 1.8)))
            UIUtil.pop(CastInfo.Luck, 1.12)
            v82 = CastInfo.Luck
            v82.TextColor3 = v2
            UIUtil.tween(v82, 0.18, {
                TextColor3 = v51
            }, Enum.EasingStyle.Quad)
            v96 = v97
            v78 = v74
            v91 = false
        end

        local Y

        if not v91 then
            v93 = v77
            v82 = CastInfo.Luck

            if v83 < 10 then
                v82.Text = string.format("Luck x%.1f", v83)
            else
                v82.Text = ("Luck x%*"):format((math.floor(v83)))
            end

            Y = v83 / v50
            v82 = math.log10(Y) * 0.3 + 1
            v85 = math.min(v82, 1.4)
            CastInfo.Luck.Size = UDim2.new(CastInfo.Luck.Size.X, UDim.new(0, v52 * v85))
            v92 = v83
            v95 = v96
            v94 = v78
        end

        v83 = Config.biomeAt(v81)

        local v103, v104
        local v102 = v67

        if v83 == v60 then
            v104 = v60
            v103 = v69
        else
            v104 = v83
            v79 = v60 == 0
            v85 = Effects.liquid(v83)
            CastInfo.Biome.Text = Config.Biomes[v83].Name
            v82 = if v85 then v85.Color:Lerp(v2, 0.65) else v2

            if v79 then
                v103 = v69
                CastInfo.Biome.TextColor3 = v82
            else
                v102 = v71 + 0.07 * CastPace
                v69 = CastInfo.Biome
                v69.TextColor3 = v2
                UIUtil.tween(v69, 0.3, {
                    TextColor3 = v82
                }, Enum.EasingStyle.Quad)
                UIUtil.pop(CastInfo.Biome, 1.7)
                CastInfo.Biome.Rotation = -6
                UIUtil.tween(CastInfo.Biome, 0.45, {
                    Rotation = 0
                }, Enum.EasingStyle.Elastic)
                v69 = UIUtil.sound
                v85 = v83 - 2
                v98 = t2[v85 % 7 + 1]

                local v105 = v85 / 7

                v103 = 1
                v69("Click", 0.6, 0.85 * 2 ^ ((v98 + math.floor(v105) * 12) / 12))
            end
        end

        v83 = os.clock() - elapsed
        v85 = v73 + Vector3.new(4, 5 + v49 * 0.06, 15)
        v69 = v85.X
        Y = v85.Y
        v75 = Canyon.glide(math.max(-v85.Z, 0), 30) + 3
        v82 = Vector3.new(v69, math.max(Y, v75), v85.Z)
        v69 = CFrame.lookAt(v82, v73 + Vector3.new(0, -1.5, -8))
        v69 = _CFrame:Lerp(v69 * CFrame.Angles(0, 0, math.sin(v83 / CastPace * 2.5) * 0.06981317007977318), 1 - (1 - math.min(v83 / (0.35 * CastPace), 1)) ^ 3)
        CurrentCamera.CFrame = Effects.shake(v69, math.max(0, 1 - v83 / (0.6 * CastPace)) * 0.9 + v103 * 0.35)
        v69 = math.max(0, v103 - v80 * 5)
        v75 = 1.2 - v72
        v58(v80, (math.clamp(v75, 0, 1)))

        if v72 >= 1 or Skip.requested() then
            break
        end

        v66 = v71
        RunService.Heartbeat:Wait()
        v70 = v92
        v67 = v102
        v60 = v104
        v61 = v95
        v62 = v94
        v59 = v93
    end

    v64()
    v45.Enabled = false
    v46:Destroy()

    if v57 then
        v57:Destroy()
    end

    if Skip.requested() then
        v43.CFrame = CFrame.new(v40)
        v44.CFrame = CFrame.new(v40 + Vector3.new(0, 0.22, 0))
        CastInfo.Visible = false

        return {
            landing = v40,
            surfaceY = Y,
            liquid = v41,
            color = v42,
            bobber = v43,
            cap = v44,
            line = v47
        }
    end

    v71 = CastInfo.Luck
    v71.TextColor3 = v2
    UIUtil.tween(v71, 0.3, {
        TextColor3 = v51
    }, Enum.EasingStyle.Quad)
    UIUtil.pop(CastInfo.Luck, 1.4)
    v66 = os.clock()
    Effects.splash(v40, v42, 1.5)
    UIUtil.sound("Splash", 1)
    task.wait(0.06 * CastPace)
    v63 = CurrentCamera.CFrame
    v71 = os.clock()
    v64 = 0.2 * CastPace

    while os.clock() - v71 < v64 do
        CurrentCamera.CFrame = Effects.shake(v63, (1 - (os.clock() - v71) / v64) * 0.6)
        RunService.Heartbeat:Wait()
    end

    v71 = CFrame.lookAt(v40 + Vector3.new(7, 6, 16), v40 + Vector3.new(0, 0.5, 0))
    v71 = UIUtil.tween(CurrentCamera, 0.6 * CastPace, {
        FieldOfView = 60,
        CFrame = v71
    }, Enum.EasingStyle.Sine)

    if p33 then
        v63 = 1
        v64 = {}
    else
        v63 = v1:NextNumber(1.3, 2.1) * CastPace
        v64 = {
            v63 * 0.35,
            v63 * 0.7
        }
    end

    local elapsed2 = os.clock()
    local v107

    while os.clock() - elapsed2 < v63 and not Skip.requested() do
        v77 = os.clock() - elapsed2
        v78 = 0

        for _, v108 in v64 do
            v75 = v77 - v108
            v76 = 1 - math.abs(v75) / (0.12 * CastPace)
            v78 += math.max(0, v76) * 0.45
        end

        v74 = v77 / CastPace * 5
        v73 = math.sin(v74) * 0.12 - v78
        v107 = v40 + Vector3.new(0, v73, 0)
        v43.CFrame = CFrame.new(v107)
        v44.CFrame = CFrame.new(v107 + Vector3.new(0, 0.22, 0))
        RunService.Heartbeat:Wait()
    end

    if Skip.requested() then
        v71:Cancel()
    elseif not p33 then
        Effects.exclaim(v43)
        UIUtil.sound("Splash", 0.5, 1.4)
    end

    elapsed2 = os.clock()

    while not p33 and os.clock() - elapsed2 < 0.9 * CastPace do
        if Skip.requested() then
            break
        end

        v64 = (os.clock() - elapsed2) / (0.9 * CastPace)
        v79 = v64 * 40
        v72 = math.sin(v79) * 0.15
        v73 = -v64 * 1.2
        v107 = v40 + Vector3.new(v72, v73, 0)
        v43.CFrame = CFrame.new(v107)
        v44.CFrame = CFrame.new(v107 + Vector3.new(0, 0.22, 0))
        RunService.Heartbeat:Wait()
    end

    CastInfo.Visible = false

    return {
        landing = v40,
        surfaceY = Y,
        liquid = v41,
        color = v42,
        bobber = v43,
        cap = v44,
        line = v47,
        splashAt = v66,
        settling = v71
    }
end

return t1
