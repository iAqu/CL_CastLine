-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Animals = require(ReplicatedStorage.Shared.Animals)
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local TripUi = require(script.Parent.TripUi)
local TripSet = require(script.Parent.TripSet)
local t1 = {}
local LocalPlayer = Players.LocalPlayer

local function lerp(p1, p2, p3) -- line: 38
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 41
    local v1 = math.clamp(p4, 0, 1)

    return v1 * v1 * (3 - v1 * 2)
end

function t1.best() -- line: 47
    -- upvalues: Config (copy), Animals (copy)
    local v2 = Config.Worlds[2]
    local v3

    for _, v4 in Animals.ByBiome[v2.Last] or {} do
        if not v3 or v4.RarityIndex > v3.RarityIndex or v4.RarityIndex == v3.RarityIndex and Animals.odds(v4.Id) > Animals.odds(v3.Id) then
            v3 = v4
        end
    end

    return v3
end

local function underLook() -- line: 61
    local Lighting = game:GetService("Lighting")
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1)
    ColorCorrectionEffect.Saturation = 0.2
    ColorCorrectionEffect.Contrast = 0.05
    ColorCorrectionEffect.Parent = Lighting

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    local t2

    if Atmosphere then
        t2 = {
            Density = Atmosphere.Density,
            Offset = Atmosphere.Offset,
            Color = Atmosphere.Color,
            Decay = Atmosphere.Decay,
            Haze = Atmosphere.Haze
        }
        Atmosphere.Density = 0.22
        Atmosphere.Offset = 0
        Atmosphere.Haze = 1

        local v5 = Color3.fromRGB(30, 60, 100)
        local v6 = Color3.fromRGB(14, 30, 60)

        Atmosphere.Color = v5
        Atmosphere.Decay = v6
    end

    return function() -- line: 75
        -- upvalues: ColorCorrectionEffect (copy), Atmosphere (copy), t2 (ref)
        ColorCorrectionEffect:Destroy()

        if Atmosphere and t2 then
            for v7, v8 in t2 do
                Atmosphere[v7] = v8
            end
        end
    end
end

local function openCrack(p5) -- line: 88
    -- upvalues: TripSet (copy)
    local Map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("World2") and workspace.Map.World2:FindFirstChild("Base")
    local Crack = Map and Map:FindFirstChild("Crack")
    local Back = Crack and Crack:FindFirstChild("Back")

    if Back and Back:IsA("BasePart") then
        Back.LocalTransparencyModifier = 1
    end

    local function piece(p6) -- line: 95
        -- upvalues: p5 (copy)
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        for v9, v10 in p6 do
            Part[v9] = v10
        end

        Part.Parent = p5

        return Part
    end

    local t3 = {
        Name = "CrackDark",
        Size = Vector3.new(90, 90, 2),
        CastShadow = false,
        CFrame = CFrame.new(6, -958, -5700),
        Color = Color3.fromRGB(3, 5, 10),
        Material = Enum.Material.SmoothPlastic
    }
    local Part = Instance.new("Part")

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false

    for v11, v12 in t3 do
        Part[v11] = v12
    end

    Part.Parent = p5

    local t4 = {
        Size = Vector3.new(1, 1, 1),
        Transparency = 1,
        CFrame = CFrame.new((Vector3.new(6, -962, -5818)))
    }
    local Part2 = Instance.new("Part")

    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false

    for v13, v14 in t4 do
        Part2[v13] = v14
    end

    Part2.Parent = p5

    local PointLight = Instance.new("PointLight")

    PointLight.Color = Color3.fromRGB(110, 200, 255)
    PointLight.Range = 24
    PointLight.Brightness = 1.5
    PointLight.Shadows = false
    PointLight.Parent = Part2
    TripSet.emitter(Part2, {
        LightEmission = 0.3,
        Acceleration = Vector3.new(0, 5, 0),
        Rate = 12,
        Color = ColorSequence.new(Color3.fromRGB(210, 235, 255)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(1, 1.5)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        }),
        Lifetime = NumberRange.new(1.5, 2.5),
        Speed = NumberRange.new(3, 7),
        SpreadAngle = Vector2.new(30, 30),
        EmissionDirection = Enum.NormalId.Front
    })

    return Part2, function() -- line: 121
        -- upvalues: Back (copy)
        if Back and Back:IsA("BasePart") then
            Back.LocalTransparencyModifier = 0
        end
    end
end

local t5 = {
    { 1, (Vector3.new(6, -963, -5750)) },
    { 3, (Vector3.new(6, -963, -5848)) },
    { 4.8, (Vector3.new(-8, -963, -5905)) },
    { 8.8, (Vector3.new(-28, -962, -6012)) },
    { 11.8, (Vector3.new(-28, -997, -6088)) }
}

local function subPos(p7) -- line: 139
    -- upvalues: Canyon (copy), t5 (copy)
    local v15 = t5[1][2]
    local v16 = t5[#t5]

    if v16[1] <= p7 then
        local v17 = v16[2].Z - (p7 - v16[1]) * 24

        return (Vector3.new(v16[2].X, Canyon.glide(-v17, 40) + 3, v17))
    end

    for i = 2, #t5 do
        local v19 = t5[i - 1]
        local v20 = t5[i]

        if p7 < v20[1] then
            local v22 = math.clamp((p7 - v19[1]) / (v20[1] - v19[1]), 0, 1)
            local v23

            if i == 2 then
                v23 = 1 - (1 - v22) ^ 2
            else
                local v24 = math.clamp(v22, 0, 1)

                v23 = v24 * v24 * (3 - v24 * 2)
            end

            return (v19[2]:Lerp(v20[2], v23))
        end
    end

    return v15
end

local function subAt(p8) -- line: 159
    -- upvalues: subPos (copy)
    local v25 = subPos(p8)
    local v26 = subPos(p8 + 0.15) - v25
    local v27 = Vector3.new(v26.X, 0, v26.Z)
    local v28 = if v27.Magnitude > 0.05 then v27.Unit else Vector3.new(0, 0, -1)
    local v31 = v25 + Vector3.new(0, math.sin(p8 * 1.6) * 0.4, 0)

    return CFrame.lookAt(v31, v31 + v28) * CFrame.Angles(0, 0, math.sin(p8 * 1.1) * 0.03490658503988659)
end

local function lowerBeds() -- line: 170
    local t6 = {}
    local t7 = {}
    local t8 = {}
    local Map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("World2") and workspace.Map.World2:FindFirstChild("Biomes")
    local v34 = if Map then Map:GetChildren() else {}

    for _, v35 in v34 do
        for _, child in v35:GetChildren() do
            local v36 = if child.Name == "PoolBed" and child:IsA("BasePart") then { child } elseif child.Name == "SeaFloor" then child:GetDescendants() else {}

            for _, v37 in v36 do
                if v37:IsA("BasePart") and v37.Anchored then
                    table.insert(t6, v37)
                    table.insert(t7, v37.CFrame)
                    table.insert(t8, v37.CFrame - Vector3.new(0, 56, 0))
                end
            end
        end
    end

    workspace:BulkMoveTo(t6, t8, Enum.BulkMoveMode.FireCFrameChanged)

    return function() -- line: 186
        -- upvalues: t6 (copy), t7 (copy)
        local t9 = {}
        local t10 = {}

        for v39, v40 in t6 do
            if v40.Parent then
                table.insert(t9, v40)
                table.insert(t10, t7[v39])
            end
        end

        workspace:BulkMoveTo(t9, t10, Enum.BulkMoveMode.FireCFrameChanged)
    end
end

function t1.play(p9, p10) -- line: 198
    -- upvalues: RunService (copy), Config (copy), Animals (copy), AnimalModel (copy), Canyon (copy), Format (copy), UIUtil (copy), TripUi (copy), TripSet (copy), t1 (copy), underLook (copy), openCrack (copy), subPos (copy), subAt (copy), lowerBeds (copy)
    local camera, folder = p9.camera, p9.folder
    local v42 = Config.Worlds[2]
    local v43 = t1.best()
    local v44 = lowerBeds()
    local sub = p9.sub
    local v45, v46 = openCrack(folder)
    local v47 = Canyon.starts[v42.Last] + Canyon.lengths[v42.Last] * 0.72
    local v48 = Canyon.surface(v47) - 8 - 56
    local v49, v50, v51
    local v54 = Vector3.new(0, v48 + 20, -v47)
    local v55 = v54
    local n1 = 80
    local v56, v58, v59
    local v57 = v54

    if v43 then
        v56 = AnimalModel.clone(v43.Id, 160)
        v49 = v56

        if v56 then
            local _, BoundingBox = v56:GetBoundingBox()

            if BoundingBox.Y > 40 then
                v56:ScaleTo(v56:GetScale() * 40 / BoundingBox.Y)
            end

            for _, descendant in v56:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanQuery = false
                    descendant.CanTouch = false
                end
            end

            local BoundingBox2, BoundingBox3 = v56:GetBoundingBox()
            local v60 = v56:GetPivot().Position.Y - (BoundingBox2.Position.Y - BoundingBox3.Y / 2)
            local v63 = Vector3.new(0, v48 + 4 + v60, -v47)
            local v64 = CFrame.lookAt(v63, v63 - Vector3.new(0, 0, 1)) * CFrame.Angles(0, 0.6108652381980153, 0)

            v51 = v64
            v59 = math.max(BoundingBox3.X, BoundingBox3.Z) / 2
            n1 = v59
            v56:PivotTo(v64)

            local BoundingBox4 = v56:GetBoundingBox()

            v57 = Vector3.new(BoundingBox4.Position.X, v48 + 4 + BoundingBox3.Y / 2, BoundingBox4.Position.Z)
            v55 = v57

            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.Transparency = 1
            Part.Size = Vector3.new(1, 1, 1)
            Part.CFrame = CFrame.new(v57 + Vector3.new(20, 24, v59 * 0.8))
            Part.Parent = folder

            local PointLight = Instance.new("PointLight")

            PointLight.Color = Color3.fromRGB(235, 240, 255)
            PointLight.Range = 50
            PointLight.Brightness = 0.5
            PointLight.Shadows = false
            PointLight.Parent = Part
            v56.Parent = folder
            v50 = AnimalModel.rig(v56)
            v58 = v64
        else
            v59 = 80
        end
    else
        v59 = 80
    end

    local v69 = v57 + (if v58 then Vector3.new(v58.ZVector.X, 0, v58.ZVector.Z).Unit else Vector3.new(0, 0, 1)) * v59
    local v70 = v69 + Vector3.new(0, 4, 32)
    local v71 = v69 + Vector3.new(0, 7, 0)
    local v72 = -v70.Z
    local v73 = (v72 - 5885) / 11.3

    local function sAt(p11) -- line: 269
        -- upvalues: v72 (copy), v73 (copy)
        local v74 = math.clamp(p11, 0, 14.5)

        if v74 < 2.2 then
            return 5885 + v73 * v74 * v74 / 4.4
        end

        if v74 < 10.3 then
            return 5885 + v73 * (v74 + 1.1 - 2.2)
        end

        local v75 = 14.5 - v74

        return v72 - v73 * v75 * v75 / 8.4
    end

    local v76 = UIUtil.sound("BubbleSwell", 0.3, 0.8, 120)

    if v76 then
        v76.Looped = true
    end

    local elapsed = os.clock()
    local t11 = {}

    local function once(p12, p13) -- line: 288
        -- upvalues: t11 (copy)
        if not t11[p12] then
            t11[p12] = true
            p13()
        end
    end

    local v77 = nil
    local v78, v79
    local v80 = false
    local v81 = TripSet.snow(folder)
    local n2 = 0

    task.spawn(TripUi.wash, false, 1)

    local function watchCam(p14) -- line: 302
        -- upvalues: subPos (copy)
        local v82 = subPos((math.max(p14, 1.2)))
        local v84 = math.clamp(p14 / 4.8, 0, 1)
        local v85 = (Vector3.new(30, -966, -5885)):Lerp(Vector3.new(6, -958, -5810), v84 * v84 * (3 - v84 * 2) * 0.06)
        local v86 = v82 + Vector3.new(0, 4, 0)
        local v88 = math.clamp((p14 - 1) / 1.6, 0, 1)

        return v85, (Vector3.new(6, -958, -5810)):Lerp(v86, v88 * v88 * (3 - v88 * 2))
    end

    local connection = RunService.RenderStepped:Connect(function(p15) -- line: 307
        -- upvalues: p9 (copy), camera (copy), v43 (copy), sub (copy), v45 (copy), v47 (copy), v49 (ref), v50 (ref), v51 (ref), v55 (ref), n1 (ref), v70 (copy), v71 (copy), v72 (copy), v73 (copy), elapsed (copy), t11 (copy), v77 (ref), v78 (ref), v79 (ref), v80 (ref), v81 (copy), n2 (ref), Config (copy), Animals (copy), AnimalModel (copy), Canyon (copy), Format (copy), UIUtil (copy), TripUi (copy), TripSet (copy), underLook (copy), subPos (copy), subAt (copy)
        local v89 = os.clock() - elapsed

        if sub then
            local v90 = subAt(v89)

            n2 += (v89 < 3 and 30 or 10) * p15
            TripSet.placeSub(sub, v90, n2, 0)

            if sub.bubbles then
                sub.bubbles.Rate = v89 < 7.8 and 60 or 20
            end

            if p9.root and p9.root.Parent then
                p9.root.CFrame = TripSet.seat(sub, v90) * CFrame.new(0, p9.sitAbove, 0)
            end
        end

        if v89 > 0.7 then
            local function v92() -- line: 322
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Rumble", 0.7, 0.6)
            end

            if not t11.rumble then
                t11.rumble = true
                UIUtil.sound("Rumble", 0.7, 0.6)
            end
        end

        if v89 > 1.3 then
            local function v93() -- line: 327
                -- upvalues: v45 (copy), UIUtil (copy)
                UIUtil.sound("SubBoom", 0.6, 0.7)
                UIUtil.sound("Whoosh", 0.6, 0.8)
                UIUtil.sound("Bubbles", 0.6, 1)

                if v45 then
                    local ParticleEmitter = v45:FindFirstChildOfClass("ParticleEmitter")

                    if ParticleEmitter then
                        ParticleEmitter:Emit(40)
                    end
                end
            end

            if not t11["break out"] then
                t11["break out"] = true
                v93()
            end
        end

        if v89 > 3 then
            local function v94() -- line: 341
                -- upvalues: UIUtil (copy), TripUi (copy)
                TripUi.title("WORLD 2", "THE DEEP SEA", 2.6, Color3.fromRGB(120, 200, 255))
                UIUtil.sound("Reveal", 0.8, 0.8)
            end

            if not t11.title then
                t11.title = true
                TripUi.title("WORLD 2", "THE DEEP SEA", 2.6, Color3.fromRGB(120, 200, 255))
                UIUtil.sound("Reveal", 0.8, 0.8)
            end
        end

        if v49 and v50 and v51 then
            local v96 = math.sin(v89 * 0.9)

            AnimalModel.pose(v50, v51 * CFrame.new(0, v96 * 0.6, 0), v89 * 0.25, 0)
        end

        local v98 = math.max(0, v89 - 4.8)
        local v99 = math.clamp(v98, 0, 14.5)
        local v100

        if v99 < 2.2 then
            v100 = 5885 + v73 * v99 * v99 / 4.4
        elseif v99 < 10.3 then
            v100 = 5885 + v73 * (v99 + 1.1 - 2.2)
        else
            local v101 = 14.5 - v99

            v100 = v72 - v73 * v101 * v101 / 8.4
        end

        local v104 = math.min(v100 + 90, v47 - n1)
        local v107 = Vector3.new(0, Canyon.glide(v100, 160) + 36, -v100)
        local v110 = Vector3.new(0, Canyon.glide(v104, 160) + 4, -v104)
        local v112 = math.clamp((v98 - 10.3) / 4.2, 0, 1)
        local v113 = v112 * v112 * (3 - v112 * 2)

        if v113 > 0 then
            local X = v107.X
            local v114 = X + (v70.X - X) * v113
            local Y = v107.Y

            v107 = Vector3.new(v114, Y + (v70.Y - Y) * v113, v107.Z)
            v110 = v110:Lerp(v71, v113)
        end

        local v117 = math.clamp((v89 - 4.8) / 2.4, 0, 1)
        local v118 = 1 - v117 * v117 * (3 - v117 * 2)

        if v118 > 0 then
            local v119 = math.min(v89, 7.199999999999999)
            local v120 = subPos((math.max(v119, 1.2)))
            local v122 = math.clamp(v119 / 4.8, 0, 1)
            local v123 = (Vector3.new(30, -966, -5885)):Lerp(Vector3.new(6, -958, -5810), v122 * v122 * (3 - v122 * 2) * 0.06)
            local v124 = v120 + Vector3.new(0, 4, 0)
            local v126 = math.clamp((v119 - 1) / 1.6, 0, 1)
            local v127 = (Vector3.new(6, -958, -5810)):Lerp(v124, v126 * v126 * (3 - v126 * 2))

            v107 = v107:Lerp(v123, v118)
            v110 = v110:Lerp(v127, v118)
        end

        v77 = v107
        v78 = v110
        camera.CFrame = CFrame.lookAt(v77, v78)
        camera.Focus = camera.CFrame

        local v128 = 72 + 4 * v113
        local v129 = math.max(v118, 0)

        camera.FieldOfView = v128 + (62 - v128) * v129
        v81.CFrame = camera.CFrame

        local v130 = v77.Y < Canyon.surface(-v77.Z) - 8

        if not v130 or v79 then
            if not v130 and v79 then
                v79()
                v79 = nil
            end
        else
            v79 = underLook()
            UIUtil.sound("BigSplash", 0.5, 0.6)
            UIUtil.sound("Bubbles", 0.6, 0.8)
        end

        local call = p9.call

        if call then
            local v132 = math.clamp(1 - (v77 - v55).Magnitude / 900, 0, 1)

            call.Volume = v132 * v132 * 2.2 + 0.6
        end

        if v89 > 19.900000000000002 and not v80 and v43 then
            v80 = true

            local v133 = Config.RarityByName[v43.Rarity]

            TripUi.stack({
                {
                    size = 54,
                    text = string.upper(v43.Rarity),
                    rarity = v133
                },
                {
                    size = 112,
                    text = string.upper(v43.Name)
                },
                {
                    size = 76,
                    text = "1 in " .. Format.short(Animals.odds(v43.Id)),
                    color = Color3.fromRGB(255, 215, 90)
                },
                {
                    size = 52,
                    text = Format.money(v43.Income) .. "/s",
                    color = Color3.fromRGB(110, 255, 110)
                }
            }, 0.5)
        end
    end)

    while os.clock() - elapsed < 25.300000000000004 and not p10() do
        RunService.RenderStepped:Wait()
    end

    TripUi.fade(true, 0.5)
    connection:Disconnect()

    if v79 then
        v79()
    end

    if v76 then
        v76:Destroy()
    end

    v44()
    v46()
end

function t1.arrive(p16) -- line: 422
    -- upvalues: Config (copy), UIUtil (copy), LocalPlayer (copy)
    local root, humanoid = p16.root, p16.humanoid
    local v134 = Config.plotOf(LocalPlayer.UserId, 2)
    local Spawn = v134 and v134:FindFirstChild("Spawn")

    root.Anchored = false
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    if Spawn and root.Parent then
        local v135 = humanoid.HipHeight + root.Size.Y / 2

        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        p16.character:PivotTo(Spawn.CFrame + Vector3.new(0, v135, 0))
        p16.camera.CFrame = Spawn.CFrame * CFrame.new(0, v135 + 6, 14) * CFrame.Angles(-0.24434609527920614, 0, 0)
    end

    task.delay(1.2, function() -- line: 434
        -- upvalues: UIUtil (copy)
        UIUtil.toast("Welcome to the Deep Sea! 🌊", "info")
    end)
end

return t1
