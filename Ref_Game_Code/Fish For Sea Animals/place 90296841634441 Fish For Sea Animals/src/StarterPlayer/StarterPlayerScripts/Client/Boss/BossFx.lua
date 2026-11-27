-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local t1 = {}
local v1 = Color3.fromRGB(255, 40, 40)
local v2 = Color3.fromRGB(255, 240, 200)
local v3 = Color3.fromRGB(90, 170, 220)
local Folder

local function now() -- line: 21
    return workspace:GetServerTimeNow()
end

local function part(p1) -- line: 25
    -- upvalues: Folder (ref)
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v4, v5 in p1 do
        Part[v4] = v5
    end

    Part.Parent = Folder

    return Part
end

local function disc(p2, p3, p4, p5, p6) -- line: 41
    -- upvalues: Folder (ref)
    local t2 = {
        Shape = Enum.PartType.Cylinder,
        Size = Vector3.new(0.12, p3 * 2, p3 * 2),
        CFrame = CFrame.new(p2 + Vector3.new(0, p6, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
        Color = p4,
        Transparency = p5
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v8, v9 in t2 do
        Part[v8] = v9
    end

    Part.Parent = Folder

    return Part
end

function t1.splash(p7, p8) -- line: 52
    -- upvalues: Debris (copy), v3 (copy), Folder (ref)
    local t3 = {
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        CFrame = CFrame.new(p7)
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v10, v11 in t3 do
        Part[v10] = v11
    end

    Part.Parent = Folder

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Color = ColorSequence.new(v3, Color3.new(1, 1, 1))
    ParticleEmitter.LightEmission = 0.3
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, p8 * 0.5),
        NumberSequenceKeypoint.new(1, p8 * 0.15)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.5, 0.9)
    ParticleEmitter.Speed = NumberRange.new(p8 * 3, p8 * 6)
    ParticleEmitter.SpreadAngle = Vector2.new(35, 35)
    ParticleEmitter.Acceleration = Vector3.new(0, -80, 0)
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit((math.floor(p8 * 4 + 20)))
    Debris:AddItem(Part, 1.5)
end

local function strike(p9, p10) -- line: 70
    -- upvalues: Debris (copy), TweenService (copy), t1 (copy), v2 (copy), disc (copy)
    local v13 = disc(p9, p10, v2, 0.1, 0.12)

    TweenService:Create(v13, TweenInfo.new(0.35), {
        Transparency = 1
    }):Play()
    Debris:AddItem(v13, 0.4)
    t1.splash(p9 + Vector3.new(0, 1, 0), p10)
end

local function circle(p11, p12, p13) -- line: 78
    -- upvalues: RunService (copy), v1 (copy), disc (copy), strike (copy)
    local v14 = disc(p11, p12, v1, 0.55, 0.06)
    local v15 = disc(p11, 0.1, v1, 0.25, 0.09)
    local ServerTimeNow = workspace:GetServerTimeNow()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 83
        -- upvalues: p11 (copy), p12 (copy), p13 (copy), v14 (copy), v15 (copy), ServerTimeNow (copy), connection (ref), strike (copy)
        local v19 = math.clamp((workspace:GetServerTimeNow() - ServerTimeNow) / math.max(p13 - ServerTimeNow, 0.05), 0, 1)

        v15.Size = Vector3.new(0.12, p12 * 2 * v19, p12 * 2 * v19)
        v14.Transparency = 0.55 - math.abs((math.sin(os.clock() * 14))) * 0.25

        if not (v19 >= 1) then
            return
        end

        connection:Disconnect()
        v14:Destroy()
        v15:Destroy()
        strike(p11, p12)
    end)
end

local function strip(p14, p15, p16, p17) -- line: 97
    -- upvalues: RunService (copy), t1 (copy), v1 (copy), Folder (ref)
    local Magnitude = (p15 - p14).Magnitude
    local v24 = CFrame.lookAt(p14, p15)
    local t4 = {
        Transparency = 0.55,
        Size = Vector3.new(p16, 0.12, Magnitude),
        CFrame = v24 * CFrame.new(0, 0.06, -Magnitude / 2),
        Color = v1
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v25, v26 in t4 do
        Part[v25] = v26
    end

    Part.Parent = Folder

    local t5 = {
        Transparency = 0.25,
        Size = Vector3.new(p16, 0.12, 0.1),
        CFrame = v24,
        Color = v1
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon

    for v27, v28 in t5 do
        Part2[v27] = v28
    end

    Part2.Parent = Folder

    local ServerTimeNow = workspace:GetServerTimeNow()
    local connection

    connection = RunService.RenderStepped:Connect(function() -- line: 104
        -- upvalues: p14 (copy), p15 (copy), p16 (copy), p17 (copy), Magnitude (copy), v24 (copy), Part (copy), Part2 (copy), ServerTimeNow (copy), connection (ref), t1 (copy)
        local v32 = math.clamp((workspace:GetServerTimeNow() - ServerTimeNow) / math.max(p17 - ServerTimeNow, 0.05), 0, 1)

        Part2.Size = Vector3.new(p16, 0.12, (math.max(Magnitude * v32, 0.1)))
        Part2.CFrame = v24 * CFrame.new(0, 0.09, -Magnitude * v32 / 2)
        Part.Transparency = 0.55 - math.abs((math.sin(os.clock() * 14))) * 0.25

        if not (v32 >= 1) then
            return
        end

        connection:Disconnect()
        Part:Destroy()
        Part2:Destroy()

        for i = 0, 4 do
            t1.splash(p14 + (p15 - p14) * (i / 4) + Vector3.new(0, 1, 0), p16 * 0.6)
        end
    end)
end

local function wave(p18, p19, p20, p21, p22) -- line: 121
    -- upvalues: RunService (copy), t1 (copy), v1 (copy), v3 (copy), Folder (ref)
    local v38 = Vector3.new(-p19.Z, 0, p19.X)
    local v39 = p18 - p19 * p20
    local t6 = {
        Transparency = 0.3,
        Size = Vector3.new(p20 * 2, 0.15, 3),
        CFrame = CFrame.fromMatrix(v39 + Vector3.new(0, 0.08, 0), v38, (Vector3.new(0, 1, 0))),
        Color = v1
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon

    for v41, v42 in t6 do
        Part[v41] = v42
    end

    Part.Parent = Folder

    local Part2, connection

    connection = RunService.RenderStepped:Connect(function() -- line: 127
        -- upvalues: p18 (copy), p19 (copy), p20 (copy), p21 (copy), p22 (copy), v38 (copy), Part (copy), Part2 (ref), connection (ref), t1 (copy), v3 (copy), Folder (ref)
        local ServerTimeNow = workspace:GetServerTimeNow()

        if ServerTimeNow < p21 then
            Part.Transparency = math.abs((math.sin(os.clock() * 12))) * 0.4 + 0.3
        else
            if Part.Parent then
                Part:Destroy()

                local t7 = {
                    Transparency = 0.25,
                    Size = Vector3.new(p20 * 2 + 4, 6, 3),
                    Color = v3,
                    Material = Enum.Material.Glass
                }
                local Part3 = Instance.new("Part")

                Part3.Anchored = true
                Part3.CanCollide = false
                Part3.CanQuery = false
                Part3.CanTouch = false
                Part3.CastShadow = false
                Part3.Material = Enum.Material.Neon

                for v46, v47 in t7 do
                    Part3[v46] = v47
                end

                Part3.Parent = Folder
                Part2 = Part3
            end

            local v49 = math.clamp((ServerTimeNow - p21) / p22, 0, 1)
            local v50 = p18 - p19 * p20 + p19 * (p20 * 2 * v49) + Vector3.new(0, 3, 0)

            Part2.CFrame = CFrame.fromMatrix(v50, v38, (Vector3.new(0, 1, 0)))

            if v49 >= 1 then
                connection:Disconnect()
                Part2:Destroy()
                t1.splash(v50, 8)
            end
        end
    end)
end

function t1.warn(p23) -- line: 149
    -- upvalues: circle (copy), strip (copy), wave (copy)
    if type(p23) == "table" then
        if p23.Kind == "Slam" or p23.Kind == "Spit" then
            circle(p23.At, p23.Radius, p23.HitAt)
        elseif p23.Kind == "Lunge" then
            strip(p23.From, p23.To, p23.Width, p23.HitAt)
        elseif p23.Kind == "Wave" then
            wave(p23.Center, p23.Dir, p23.Half, p23.StartAt, p23.Sweep)
        end
    end
end

local t8 = {
    "Nessie_Tail",
    "Nessie_BodyRear",
    "Nessie_Body",
    "Nessie_Back",
    "Nessie_Neck",
    "Nessie_NeckTop",
    "Nessie_Head"
}
local t9 = {}
local Part
local t10 = {}
local Y
local n1 = 0

local function waterY() -- line: 170
    local BossArena = workspace:FindFirstChild("BossArena")

    return BossArena and BossArena:GetAttribute("WaterY") or 0
end

local function clearMonster() -- line: 175
    -- upvalues: t9 (copy), Part (ref), t10 (copy), Y (ref)
    for v51, v52 in t9 do
        v52:Destroy()
        t9[v51] = nil
    end

    if Part then
        Part:Destroy()
        Part = nil
    end

    for v53, v54 in t10 do
        v54:Destroy()
        t10[v53] = nil
    end

    Y = nil
end

local function headAttachment(p24) -- line: 191
    local v55 = p24:FindFirstChild("Nessie_Head", true)

    if not v55 then
        return nil
    end

    local BossLine = v55:FindFirstChild("BossLine")

    if not BossLine then
        BossLine = Instance.new("Attachment")
        BossLine.Name = "BossLine"
        BossLine.Parent = v55
    end

    return BossLine
end

local function rodTip(p25) -- line: 206
    local v56 = p25.Character and p25.Character:FindFirstChild("RodModel")
    local v57 = v56 and v56:FindFirstChild("Tip", true)

    return v57 and v57:FindFirstChild("RodTip")
end

function t1.update(p26, p27) -- line: 213
    -- upvalues: Players (copy), t1 (copy), Folder (ref), t8 (copy), t9 (copy), Part (ref), t10 (copy), Y (ref), n1 (ref), clearMonster (copy)
    if not p26 or not p26.Parent then
        clearMonster()

        return
    end

    local BossArena = workspace:FindFirstChild("BossArena")
    local v58 = BossArena and BossArena:GetAttribute("WaterY") or 0
    local Position = p26:GetPivot().Position
    local v59 = Position.Y < v58 - 100

    for _, v60 in t8 do
        local v61 = p26:FindFirstChild(v60, true)
        local v62 = t9[v60]

        if not v61 or v59 then
            if v62 then
                v62:Destroy()
                t9[v60] = nil
            end
        else
            local v63 = math.max(v61.Size.X, v61.Size.Z) * 0.75

            if not v62 then
                local t11 = {
                    Transparency = 0.45,
                    Shape = Enum.PartType.Cylinder,
                    Color = Color3.fromRGB(8, 22, 32),
                    Material = Enum.Material.SmoothPlastic
                }

                v62 = Instance.new("Part")
                v62.Anchored = true
                v62.CanCollide = false
                v62.CanQuery = false
                v62.CanTouch = false
                v62.CastShadow = false
                v62.Material = Enum.Material.Neon

                for v64, v65 in t11 do
                    v62[v64] = v65
                end

                v62.Parent = Folder
                t9[v60] = v62
            end

            v62.Size = Vector3.new(0.1, v63, v63)
            v62.CFrame = CFrame.new(v61.Position.X, v58 + 0.12, v61.Position.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
        end
    end

    local v66 = p26:FindFirstChild("Nessie_Head", true)

    if not v66 or v59 then
        if Part then
            Part:Destroy()
            Part = nil
        end
    else
        if not Part then
            local t12 = {
                Size = Vector3.new(1, 1, 1),
                Transparency = 1
            }
            local Part2 = Instance.new("Part")

            Part2.Anchored = true
            Part2.CanCollide = false
            Part2.CanQuery = false
            Part2.CanTouch = false
            Part2.CastShadow = false
            Part2.Material = Enum.Material.Neon

            for v67, v68 in t12 do
                Part2[v67] = v68
            end

            Part2.Parent = Folder
            Part = Part2

            local ParticleEmitter = Instance.new("ParticleEmitter")

            ParticleEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1))
            ParticleEmitter.LightEmission = 0.2
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 2),
                NumberSequenceKeypoint.new(1, 6)
            })
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            })
            ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.4)
            ParticleEmitter.Speed = NumberRange.new(3, 8)
            ParticleEmitter.SpreadAngle = Vector2.new(80, 80)
            ParticleEmitter.Acceleration = Vector3.new(0, -10, 0)
            ParticleEmitter.EmissionDirection = Enum.NormalId.Top
            ParticleEmitter.Rate = 30
            ParticleEmitter.Parent = Part
        end

        local v69 = p26:FindFirstChild("Nessie_Neck", true)
        local Position = if not (v58 < v66.Position.Y - v66.Size.Y / 2) or not v69 then v66.Position else v69.Position

        Part.CFrame = CFrame.new(Position.X, v58 + 0.5, Position.Z)
    end

    if Y and not v59 and (Position.Y - Y) / math.max(p27, 0.004166666666666667) > 14 and os.clock() - n1 > 1.2 and v66 then
        n1 = os.clock()
        t1.splash(Vector3.new(v66.Position.X, v58 + 1, v66.Position.Z), 10)
    end

    Y = Position.Y

    local v71 = p26:FindFirstChild("Nessie_Head", true)
    local BossLine

    if v71 then
        BossLine = v71:FindFirstChild("BossLine")

        if not BossLine then
            BossLine = Instance.new("Attachment")
            BossLine.Name = "BossLine"
            BossLine.Parent = v71
        end
    end

    for _, player in Players:GetPlayers() do
        local BossHooked = player:GetAttribute("BossHooked")

        if BossHooked then
            local v72 = player.Character and player.Character:FindFirstChild("RodModel")
            local v73 = v72 and v72:FindFirstChild("Tip", true)

            BossHooked = v73 and v73:FindFirstChild("RodTip")
        end

        local v74 = t10[player]

        if BossHooked and BossLine then
            if v74 then
                if v74.Attachment0 ~= BossHooked then
                    v74:Destroy()
                    v74 = Instance.new("Beam")
                    v74.Name = "BossLine"
                    v74.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                    v74.Brightness = 2
                    v74.Width0 = 0.15
                    v74.Width1 = 0.7
                    v74.FaceCamera = true
                    v74.LightInfluence = 0
                    v74.Segments = 12
                    v74.Attachment0 = BossHooked
                    v74.Attachment1 = BossLine
                    v74.Parent = Folder
                    t10[player] = v74
                end
            else
                v74 = Instance.new("Beam")
                v74.Name = "BossLine"
                v74.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
                v74.Brightness = 2
                v74.Width0 = 0.15
                v74.Width1 = 0.7
                v74.FaceCamera = true
                v74.LightInfluence = 0
                v74.Segments = 12
                v74.Attachment0 = BossHooked
                v74.Attachment1 = BossLine
                v74.Parent = Folder
                t10[player] = v74
            end

            v74.CurveSize0 = math.sin(os.clock() * 37) * 0.6
        elseif v74 then
            v74:Destroy()
            t10[player] = nil
        end
    end
end

function t1.clear() -- line: 303
    -- upvalues: Folder (ref), clearMonster (copy)
    clearMonster()

    for _, child in Folder:GetChildren() do
        child:Destroy()
    end
end

function t1.init() -- line: 310
    -- upvalues: Folder (ref)
    Folder = Instance.new("Folder")
    Folder.Name = "BossFx"
    Folder.Parent = workspace
end

return t1
