-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared")
local FishModels = require(Shared.FishModels)
local Fish = require(Shared.Data.Fish)
local LocalPlayer = Players.LocalPlayer
local v1 = nil
local t2 = {}
local t3 = {}
local n1 = 0
local t4 = {}
local v2
local v3 = nil
local Y = nil
local ColorCorrectionEffect, CameraMaxZoomDistance
local t1 = {}

t1.Count = 0

local Folder, Part
local t5 = {}
local t6 = {}
local t7 = {}

t1.Rays = 0

local function setLocal(p1, p2) -- line: 35
    -- upvalues: t7 (copy)
    local t8 = {}

    for v4, v5 in pairs(p2) do
        t8[v4] = p1[v4]
        p1[v4] = v5
    end

    table.insert(t7, {
        p1,
        t8
    })
end

local function envOff() -- line: 43
    -- upvalues: t1 (copy), Folder (ref), Part (ref), t5 (copy), t6 (ref), t7 (copy)
    for _, v6 in ipairs(t7) do
        if v6[1].Parent then
            for v7, v8 in pairs(v6[2]) do
                v6[1][v7] = v8
            end
        end
    end

    table.clear(t7)
    table.clear(t5)

    if t6.gem and t6.gem.Parent then
        t6.gem.CFrame = t6.gemCF
    end

    t6 = {}

    if Folder then
        Folder:Destroy()
        Folder = nil
        Part = nil
    end

    t1.Rays = 0
end

local function envOn(p3, p4) -- line: 63
    -- upvalues: t1 (copy), v2 (ref), Folder (ref), Part (ref), t5 (copy), t6 (ref), setLocal (copy), envOff (copy)
    envOff()

    local v9 = Color3.fromRGB(30, 98, 160)

    for _, child in ipairs(p3:GetChildren()) do
        if child:IsA("BasePart") and child.Name == "Glass" then
            setLocal(child, {
                Transparency = 0,
                Color = v9,
                Material = Enum.Material.SmoothPlastic
            })
        end
    end

    setLocal(p4, {
        Transparency = 0.15,
        Color = Color3.fromRGB(110, 195, 240),
        Material = Enum.Material.SmoothPlastic
    })

    local Deck = p3:FindFirstChild("Deck")
    local Portal = Deck and Deck:FindFirstChild("Portal")

    t6 = {}

    if Portal then
        for _, v10 in ipairs({ "PortalOuter", "PortalMid", "PortalCore" }) do
            local v11 = Portal:FindFirstChild(v10)
            local SpecialMesh = v11 and v11:FindFirstChildOfClass("SpecialMesh")

            if SpecialMesh then
                table.insert(t6, SpecialMesh)
            end
        end

        local Gem = Portal:FindFirstChild("Gem")

        if Gem then
            t6.gem = Gem

            local t11 = t6

            t11.gemCF = Gem.CFrame
        end
    end

    Folder = Instance.new("Folder")
    Folder.Name = "AquariumWater"

    local Folder2 = Folder

    Folder2.Parent = workspace

    local Part2 = Instance.new("Part")

    Part2.Name = "Rays"
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.Transparency = 1
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.CFrame = CFrame.new(v2)
    Part2.Parent = Folder

    local v12 = Random.new(7)
    local Unit = (Vector3.new(0.2, -1, 0.12)).Unit
    local v13 = p4.Position.Y - p4.Size.Y / 2 - 0.5

    for i = 1, 16 do
        local v14 = i / 16 * 3.141592653589793 * 2 + v12:NextNumber(-0.2, 0.2)
        local v15 = v12:NextNumber(50, 430)
        local v18 = Vector3.new(v2.X + math.cos(v14) * v15, v13, v2.Z + math.sin(v14) * v15)
        local v19 = v12:NextNumber(320, 520)
        local Attachment = Instance.new("Attachment")

        Attachment.Parent = Part2
        Attachment.WorldPosition = v18

        local Attachment2 = Instance.new("Attachment")

        Attachment2.Parent = Part2
        Attachment2.WorldPosition = v18 + Unit * v19

        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2

        local v20 = v12:NextNumber(6, 16)

        Beam.Width0 = v20
        Beam.Width1 = v20 * v12:NextNumber(2.4, 3.4)
        Beam.FaceCamera = true
        Beam.LightEmission = 0.7
        Beam.LightInfluence = 0
        Beam.Color = ColorSequence.new(Color3.fromRGB(200, 245, 255))

        local v21 = v12:NextNumber(0.8, 0.88)

        Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v21),
            NumberSequenceKeypoint.new(0.5, (v21 + 1) / 2),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Segments = 1
        Beam.Parent = Part2
        table.insert(t5, {
            a0 = Attachment,
            a1 = Attachment2,
            from = v18,
            to = v18 + Unit * v19,
            phase = v12:NextNumber(0, 6.3),
            speed = v12:NextNumber(0.12, 0.3)
        })
    end

    t1.Rays = #t5
    Part = Instance.new("Part")
    Part.Name = "Snow"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(130, 70, 130)
    Part.Parent = Folder

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxassetid://108857238253800"
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(210, 245, 255))
    ParticleEmitter.LightEmission = 0.6
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25),
        NumberSequenceKeypoint.new(1, 0.45)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.4),
        NumberSequenceKeypoint.new(0.8, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(6, 10)
    ParticleEmitter.Speed = NumberRange.new(0.3, 1.2)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Acceleration = Vector3.new(0, 0.25, 0)
    ParticleEmitter.Rate = 60
    ParticleEmitter.Parent = Part
end

local function add(p5) -- line: 160
    -- upvalues: FishModels (copy), Fish (copy), t1 (copy), v1 (ref), t2 (copy), t3 (copy), n1 (ref), v2 (ref), v3 (ref), Y (ref)
    if not t2[p5] and not t3[p5] and v1 then
        local Id = p5:GetAttribute("Id")

        if type(Id) ~= "string" or not Fish.ById[Id] then
            return
        end

        local Parent = p5.Parent
        local v22 = n1

        t3[p5] = true

        local Get = FishModels.Get
        local v23 = p5:GetAttribute("V") or 1
        local v24 = p5:GetAttribute("S") or 1
        local ok, result = pcall(Get, Id, v23, v24)

        t3[p5] = nil

        if ok then
            if n1 == v22 and v1 and not t2[p5] and Parent ~= nil and p5.Parent == Parent then
                local _, BoundingBox = result:GetBoundingBox()
                local v25 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 0.1)
                local v26 = math.clamp(v25, 4, 320)

                result:ScaleTo(result:GetScale() * v26 / v25)
                result:PivotTo(CFrame.new())

                local _, BoundingBox2 = result:GetBoundingBox()
                local v27 = FishModels.CenterOffset(result)

                for _, descendant in ipairs(result:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                        descendant.CastShadow = false
                    elseif descendant:IsA("PointLight") then
                        descendant:Destroy()
                    end
                end

                local v28 = tonumber(p5.Name) or 0
                local v29 = Random.new(v28 * 131 + 7)
                local v30 = math.max(BoundingBox2.X, BoundingBox2.Z)
                local v32 = math.clamp(v30 * 1.15 + 46 + v29:NextNumber(0, 30), 46, 480)
                local v33 = v3 + BoundingBox2.Y / 2 + 8
                local v35 = Y - BoundingBox2.Y / 2 - 8
                local v36 = if v33 < v35 then v33 + (v35 - v33) * v29:NextNumber(0.2, 0.8) else (v3 + Y) / 2

                if v30 < 60 then
                    v36 = math.clamp(v2.Y + v29:NextNumber(-25, 40), v33, (math.max(v33, v35)))
                end

                local v40 = Fish.ById[Id]
                local BillboardGui = Instance.new("BillboardGui")

                BillboardGui.Name = "Nameplate"
                BillboardGui.Size = UDim2.fromScale(math.clamp(v30 * 0.9, 10, 160), (math.clamp(v30 * 0.15, 1.8, 26)))
                BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, BoundingBox2.Y / 2 + math.clamp(v30 * 0.12, 1.5, 22), 0)
                BillboardGui.LightInfluence = 0
                BillboardGui.MaxDistance = 1600
                BillboardGui.Adornee = result.PrimaryPart

                local TextLabel = Instance.new("TextLabel")

                TextLabel.BackgroundTransparency = 1
                TextLabel.Size = UDim2.fromScale(1, 1)
                TextLabel.Text = v40.name
                TextLabel.TextScaled = true
                TextLabel.Font = Enum.Font.FredokaOne
                TextLabel.TextColor3 = Color3.new(1, 1, 1)

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Thickness = 3
                UIStroke.Color = Color3.fromRGB(20, 22, 34)
                UIStroke.Parent = TextLabel
                TextLabel.Parent = BillboardGui
                BillboardGui.Parent = result
                result.Parent = workspace
                t2[p5] = {
                    id = Id,
                    placeholder = result:GetAttribute("Placeholder") == true,
                    model = result,
                    offset = v27,
                    radius = v32,
                    y = v36,
                    speed = math.clamp(v30 * 0.1 + 7, 8, 40) * (v29:NextNumber() < 0.5 and 1 or -1),
                    phase = v29:NextNumber(0, 6.283185307179586),
                    bob = math.clamp(v30 * 0.04, 0.6, 10),
                    bobRate = v29:NextNumber(0.3, 0.7)
                }
                t1.Count += 1
            else
                result:Destroy()
            end
        end
    end
end

local function remove(p6) -- line: 238
    -- upvalues: t1 (copy), t2 (copy)
    local v49 = t2[p6]

    if not v49 then
        return
    end

    t2[p6] = nil
    v49.model:Destroy()
    t1.Count -= 1
end

local function leave() -- line: 247
    -- upvalues: t1 (copy), LocalPlayer (copy), v1 (ref), t2 (copy), n1 (ref), t4 (copy), ColorCorrectionEffect (ref), CameraMaxZoomDistance (ref), envOff (copy)
    v1 = nil
    n1 += 1

    for _, v50 in ipairs(t4) do
        v50:Disconnect()
    end

    table.clear(t4)

    for v51 in pairs(t2) do
        local v52 = t2[v51]

        if v52 then
            t2[v51] = nil
            v52.model:Destroy()
            t1.Count -= 1
        end
    end

    if ColorCorrectionEffect then
        ColorCorrectionEffect:Destroy()
        ColorCorrectionEffect = nil
    end

    envOff()

    if CameraMaxZoomDistance then
        LocalPlayer.CameraMaxZoomDistance = CameraMaxZoomDistance
        CameraMaxZoomDistance = nil
    end
end

local function enter(p7) -- line: 268
    -- upvalues: Lighting (copy), LocalPlayer (copy), v1 (ref), t4 (copy), v2 (ref), v3 (ref), Y (ref), ColorCorrectionEffect (ref), CameraMaxZoomDistance (ref), envOn (copy), add (copy), remove (copy), leave (copy)
    leave()

    local World = workspace:WaitForChild("World")
    local v53 = World:WaitForChild("Aquariums"):FindFirstChild("Aquarium" .. p7)
    local v54 = World:WaitForChild("Plots"):FindFirstChild("Plot" .. p7)
    local v55, v56, v57

    if v53 then
        v55 = v53:FindFirstChild("Floor")
        v56 = v53:FindFirstChild("Surface")
        v57 = v53:FindFirstChild("Platform")
    else
        v57 = v53
        v55 = v53
        v56 = v53
    end

    if not (v54 and v55 and v56 and v57) then
        return
    end

    v1 = p7
    v2 = v57.Position + Vector3.new(0, 6, 0)
    v3 = v55.Position.Y + v55.Size.Y / 2
    Y = v56.Position.Y
    ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
    ColorCorrectionEffect.Name = "AquariumTint"

    local ColorCorrectionEffect2 = ColorCorrectionEffect

    ColorCorrectionEffect2.TintColor = Color3.fromRGB(205, 232, 255)
    ColorCorrectionEffect.Saturation = 0.08
    ColorCorrectionEffect.Contrast = 0.04
    ColorCorrectionEffect.Parent = Lighting
    envOn(v53, v56)
    CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
    LocalPlayer.CameraMaxZoomDistance = math.max(CameraMaxZoomDistance, 500)

    local function watch(p8) -- line: 290
        -- upvalues: t4 (copy), add (copy), remove (copy)
        table.insert(t4, p8.ChildAdded:Connect(function(p9) -- line: 291
            -- upvalues: add (copy)
            task.defer(add, p9)
        end))
        table.insert(t4, p8.ChildRemoved:Connect(remove))

        for _, child in ipairs(p8:GetChildren()) do
            task.spawn(add, child)
        end
    end

    for _, v59 in ipairs({ "Placed", "Display" }) do
        task.spawn(function() -- line: 300
            -- upvalues: p7 (copy), v54 (copy), watch (copy), v59 (copy), v1 (ref)
            local v60 = v54:FindFirstChild(v59)

            if not v60 then
                os.clock()

                while v1 == p7 and not v60 do
                    v60 = v54:FindFirstChild(v59)
                    task.wait(0.5)
                end
            end

            if v60 and v1 == p7 then
                watch(v60)
            end
        end)
    end
end

function t1.Init() -- line: 316
    -- upvalues: RunService (copy), FishModels (copy), t1 (copy), LocalPlayer (copy), v1 (ref), t2 (copy), v2 (ref), Part (ref), t5 (copy), t6 (ref), add (copy), leave (copy), enter (copy)
    local function changed() -- line: 317
        -- upvalues: LocalPlayer (copy), leave (copy), enter (copy)
        local InAquarium = LocalPlayer:GetAttribute("InAquarium")

        if type(InAquarium) == "number" then
            enter(InAquarium)
        else
            leave()
        end
    end

    LocalPlayer:GetAttributeChangedSignal("InAquarium"):Connect(changed)

    local InAquarium = LocalPlayer:GetAttribute("InAquarium")

    if type(InAquarium) == "number" then
        enter(InAquarium)
    else
        leave()
    end

    local n2 = 0

    RunService.RenderStepped:Connect(function() -- line: 328
        -- upvalues: n2 (ref), FishModels (copy), t1 (copy), v1 (ref), t2 (copy), v2 (ref), Part (ref), t5 (copy), t6 (ref), add (copy)
        if not v1 then
            return
        end

        if os.clock() - n2 > 2 then
            n2 = os.clock()

            for v61, v62 in pairs(t2) do
                if v62.placeholder then
                    if FishModels.Has(v62.id) then
                        local v63 = t2[v61]

                        if v63 then
                            t2[v61] = nil
                            v63.model:Destroy()
                            t1.Count -= 1
                        end

                        task.spawn(add, v61)
                    else
                        FishModels.Prepare({ v62.id })
                    end
                end
            end
        end

        local ServerTimeNow = workspace:GetServerTimeNow()
        local CurrentCamera = workspace.CurrentCamera

        if Part then
            Part.CFrame = CFrame.new(CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 40)
        end

        for _, v64 in ipairs(t5) do
            local v69 = Vector3.new(math.sin(ServerTimeNow * v64.speed + v64.phase) * 6, 0, math.cos(ServerTimeNow * v64.speed * 0.8 + v64.phase) * 5)

            v64.a0.WorldPosition = v64.from + v69
            v64.a1.WorldPosition = v64.to + v69 * 4
        end

        for v70, v71 in ipairs(t6) do
            local v73 = math.sin(ServerTimeNow * 2.4 - v70 * 0.9) * 0.05 + 1

            v71.Scale = Vector3.new(v73, v73, 1)
        end

        if t6.gem then
            t6.gem.CFrame = CFrame.new(t6.gemCF.Position + Vector3.new(0, math.sin(ServerTimeNow * 1.5) * 0.4, 0)) * CFrame.Angles(0, ServerTimeNow * 1.2, 0) * CFrame.Angles(0.7853981633974483, 0, 0.7853981633974483)
        end

        for _, v76 in pairs(t2) do
            local v77 = v76.phase + ServerTimeNow % 1E+05 * v76.speed / v76.radius
            local v78 = if v76.speed > 0 then 1 else -1
            local v83 = Vector3.new(v2.X + math.cos(v77) * v76.radius, v76.y + math.sin(ServerTimeNow * v76.bobRate + v76.phase) * v76.bob, v2.Z + math.sin(v77) * v76.radius)
            local v86 = Vector3.new(-math.sin(v77), 0, (math.cos(v77))) * v78

            v76.model:PivotTo(CFrame.lookAt(v83, v83 + v86) * CFrame.Angles(0, 0, -v78 * 0.12) * CFrame.new(-v76.offset))
            FishModels.Animate(v76.model, ServerTimeNow % 1E+05, math.clamp(60 / (v76.radius * 0.1 + 5), 1.5, 7), 0.3)
        end
    end)
end

return t1
