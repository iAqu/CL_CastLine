-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Fishing = require(ReplicatedStorage.Shared.Util.Fishing)
local FishingFlags = require(ReplicatedStorage.Shared.Flags.FishingFlags)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(120, 255, 175)
local t1 = {}

local function isWater(p1) -- line: 70
    -- upvalues: CollectionService (copy), Fishing (copy)
    if not p1:IsA("BasePart") then
        return false
    end

    if p1.Material == Enum.Material.Water or p1:GetAttribute("TerrainRole") == "Basin" or p1:GetAttribute(Fishing.WaterTag) == true then
        return true
    end

    return (CollectionService:HasTag(p1, Fishing.WaterTag))
end

local function bounds(p2) -- line: 80
    local CFrame, Size = p2.CFrame, p2.Size
    local RightVector, UpVector, LookVector = CFrame.RightVector, CFrame.UpVector, CFrame.LookVector
    local v11 = Vector3.new(math.abs(RightVector.X) * Size.X + math.abs(UpVector.X) * Size.Y + math.abs(LookVector.X) * Size.Z, math.abs(RightVector.Y) * Size.X + math.abs(UpVector.Y) * Size.Y + math.abs(LookVector.Y) * Size.Z, math.abs(RightVector.Z) * Size.X + math.abs(UpVector.Z) * Size.Y + math.abs(LookVector.Z) * Size.Z) / 2

    return CFrame.Position, v11
end

local function footprint(p3) -- line: 94
    if not p3:IsA("BasePart") or p3:IsA("Terrain") then
        return 1e999
    end

    local Size = p3.Size
    local t2 = {
        Size.X,
        Size.Y,
        Size.Z
    }

    table.sort(t2)

    return t2[2] * t2[3]
end

local function surfaceAt(p4, p5, p6, p7) -- line: 104
    -- upvalues: Workspace (copy), isWater (copy), bounds (copy), footprint (copy)
    local v12, v13 = bounds(p4)
    local v14 = v12.Y + v13.Y
    local v15 = table.clone(p7)
    local v16 = RaycastParams.new()

    v16.FilterType = Enum.RaycastFilterType.Exclude
    v16.IgnoreWater = false
    v16.FilterDescendantsInstances = v15

    local v18 = Vector3.new(p5, v14 + 30, p6)
    local v20 = Vector3.new(0, -(30 + v13.Y * 2 + 6), 0)

    for _ = 1, 4 do
        local v21 = Workspace:Raycast(v18, v20, v16)

        if v21 == nil then
            return nil
        end

        local Instance = v21.Instance

        if Instance == p4 then
            local v22 = table.clone(v15)

            table.insert(v22, p4)
            v16.FilterDescendantsInstances = v22

            local v23 = Workspace:Raycast(v21.Position, Vector3.new(0, -3, 0), v16)

            return if v23 == nil or not isWater(v23.Instance) or not (footprint(v23.Instance) >= footprint(p4) * 1.5) then v21.Position else nil
        end

        if not Instance:IsA("BasePart") or not (Instance.Transparency >= 0.95) or isWater(Instance) then
            return nil
        end

        table.insert(v15, Instance)
        v16.FilterDescendantsInstances = v15
    end

    return nil
end

local function rippleAt(p8, p9, p10, p11) -- line: 144
    -- upvalues: surfaceAt (copy)
    local v24 = surfaceAt(p8, p9, p10, p11)

    if v24 == nil then
        return nil
    end

    for _, v25 in { Vector3.new(2.5, 0, 0), Vector3.new(-2.5, 0, 0), Vector3.new(0, 0, 2.5), (Vector3.new(0, 0, -2.5)) } do
        local v26 = surfaceAt(p8, p9 + v25.X, p10 + v25.Z, p11)

        if v26 == nil or math.abs(v26.Y - v24.Y) > 1.5 then
            return nil
        end
    end

    return v24 + Vector3.new(0, 0.25, 0)
end

local function cellRipple(p12, p13, p14, p15) -- line: 164
    -- upvalues: rippleAt (copy)
    for _, v28 in {
            Vector2.zero,
            Vector2.new(10, 10),
            Vector2.new(-10, 10),
            Vector2.new(10, -10),
            Vector2.new(-10, -10)
        } do
        local v29 = rippleAt(p12, p13 + v28.X, p14 + v28.Y, p15)

        if v29 then
            return v29
        end
    end

    return nil
end

local function spread(p16, p17) -- line: 182
    if #p16 == 0 then
        return {}
    end

    local v30 = Vector3.new(0, 0, 0)

    for _, v31 in p16 do
        v30 += v31
    end

    local v32 = v30 / #p16
    local v33 = p16[1]

    for _, v34 in p16 do
        if (v34 - v32).Magnitude < (v33 - v32).Magnitude then
            v33 = v34
        end
    end

    local t3 = {
        v33
    }

    while #t3 < p17 do
        local n1 = 8
        local v35

        for _, v36 in p16 do
            local n2 = 1e999

            for _, v37 in t3 do
                n2 = math.min(n2, (v36 - v37).Magnitude)
            end

            if n1 <= n2 then
                n1 = n2
                v35 = v36
            end
        end

        if v35 == nil then
            break
        end

        table.insert(t3, v35)
    end

    return t3
end

local function smallPoints(p18, p19) -- line: 219
    -- upvalues: bounds (copy), footprint (copy), rippleAt (copy), spread (copy)
    local v38, v39 = bounds(p18)
    local v42 = math.clamp(math.ceil(v39.X * 2 / 4), 3, 12)
    local v45 = math.clamp(math.ceil(v39.Z * 2 / 4), 3, 12)
    local t4 = {}

    for i = 1, v42 do
        for j = 1, v45 do
            local v48 = rippleAt(p18, v38.X - v39.X + (i - 0.5) * (v39.X * 2 / v42), v38.Z - v39.Z + (j - 0.5) * (v39.Z * 2 / v45), p19)

            if v48 then
                table.insert(t4, v48)
            end
        end
    end

    return (spread(t4, (math.clamp(math.floor(footprint(p18) / 800 + 0.5), 1, 3))))
end

local function ownsRod(p20) -- line: 238
    -- upvalues: Fishing (copy), LocalPlayer (copy)
    if Fishing.EquippedRod(p20) ~= nil then
        return true
    end

    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack ~= nil then
        for _, child in Backpack:GetChildren() do
            if Fishing.IsRod(child) then
                return true
            end
        end
    end

    return false
end

local function rootPart() -- line: 254
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if Character ~= nil and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        return Character, HumanoidRootPart
    end

    return nil, nil
end

local function characters() -- line: 263
    -- upvalues: Players (copy)
    local t5 = {}

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t5, player.Character)
        end
    end

    return t5
end

local function makeSlot(p21) -- line: 273
    -- upvalues: v1 (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "Spot"

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Texture = "rbxassetid://90951481407921"
    ParticleEmitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
    ParticleEmitter.EmissionDirection = Enum.NormalId.Top
    ParticleEmitter.Color = ColorSequence.new(v1)
    ParticleEmitter.LightEmission = 0.6
    ParticleEmitter.Size = NumberSequence.new(0.8999999999999999, 6.6)
    ParticleEmitter.Transparency = NumberSequence.new(0.55, 1)
    ParticleEmitter.Lifetime = NumberRange.new(1.3, 1.6)
    ParticleEmitter.Speed = NumberRange.new(0.01, 0.01)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.LockedToPart = false
    ParticleEmitter.Rate = 0
    ParticleEmitter.Parent = Attachment
    Attachment.Parent = p21

    return {
        Point = nil,
        Attachment = Attachment,
        Emitter = ParticleEmitter
    }
end

function t1.Start(p22, p23) -- line: 294
    -- upvalues: CollectionService (copy), RunService (copy), Workspace (copy), Fishing (copy), FishingFlags (copy), LocalPlayer (copy), isWater (copy), bounds (copy), cellRipple (copy), smallPoints (copy), ownsRod (copy), characters (copy), makeSlot (copy)
    local v52 = p22:Extend()
    local t6 = {}
    local t7 = {}
    local n3 = 0
    local v53 = v52:Add(Instance.new("Part"))

    v53.Name = "FishingSpotRipples"
    v53.Anchored = true
    v53.CanCollide = false
    v53.CanQuery = false
    v53.CanTouch = false
    v53.CastShadow = false
    v53.Transparency = 1
    v53.Size = Vector3.new(1, 1, 1)
    v53.CFrame = CFrame.identity

    for _ = 1, 6 do
        table.insert(t7, (makeSlot(v53)))
    end

    v53.Parent = Workspace

    local function track(p24) -- line: 315
        -- upvalues: t6 (copy), Workspace (copy), isWater (copy), bounds (copy)
        if p24:IsA("BasePart") and t6[p24] == nil and p24:IsDescendantOf(Workspace) and isWater(p24) then
            local _, v55 = bounds(p24)

            t6[p24] = {
                Tries = 0,
                RetryAt = 0,
                Part = p24,
                Large = math.max(v55.X, v55.Z) * 2 > 160,
                Points = {},
                Cells = {}
            }
        end
    end

    local function untrack(p25) -- line: 333
        -- upvalues: t6 (copy)
        if p25:IsA("BasePart") then
            t6[p25] = nil
        end
    end

    local function within(p26, p27) -- line: 339
        -- upvalues: bounds (copy)
        local v56, v57 = bounds(p26.Part)
        local v60 = math.max(math.abs(p27.X - v56.X) - v57.X, 0)
        local v63 = math.max(math.abs(p27.Z - v56.Z) - v57.Z, 0)

        if not (math.sqrt(v60 * v60 + v63 * v63) <= 75) then
            return false
        end

        return math.abs(p27.Y - v56.Y) <= v57.Y + 80
    end

    local function scanCells(p28, p29, p30, p31) -- line: 347
        -- upvalues: bounds (copy), cellRipple (copy)
        local v66, v67 = bounds(p28.Part)
        local v69 = math.floor((p29.X - 75) / 40)
        local v71 = math.floor((p29.X + 75) / 40)
        local v73 = math.floor((p29.Z - 75) / 40)
        local v75 = math.floor((p29.Z + 75) / 40)
        local v76 = p31

        for i = v69, v71 do
            for j = v73, v75 do
                if v76 <= 0 then
                    return v76
                end

                local v77 = ("%*:%*"):format(i, j)

                if p28.Cells[v77] == nil then
                    local v78 = (i + 0.5) * 40
                    local v79 = (j + 0.5) * 40
                    local v81 = math.abs(v78 - v66.X) <= v67.X and math.abs(v79 - v66.Z) <= v67.Z
                    local v83 = Vector2.new(v78 - p29.X, v79 - p29.Z).Magnitude <= 75

                    if v81 and v83 then
                        v76 -= 1
                        p28.Cells[v77] = cellRipple(p28.Part, v78, v79, p30) or false
                    end
                end
            end
        end

        return v76
    end

    local function refresh(p32, p33, p34, p35) -- line: 380
        -- upvalues: scanCells (copy), smallPoints (copy)
        if p32.Large then
            return (scanCells(p32, p33, p34, p35))
        end

        if #p32.Points > 0 or p32.Tries >= 2 or os.clock() < p32.RetryAt then
            return p35
        end

        p32.Tries += 1
        p32.RetryAt = os.clock() + 8
        p32.Points = smallPoints(p32.Part, p34)

        return p35 - 1
    end

    local function allowed() -- line: 393
        -- upvalues: p23 (copy), FishingFlags (copy), LocalPlayer (copy), ownsRod (copy)
        if p23() or not FishingFlags.Enabled:Get() or FishingFlags.DimensionOnly:Get() and LocalPlayer:GetAttribute("InHalloweenDimension") ~= true then
            return nil
        end

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if Character == nil or HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
            Character = nil
            HumanoidRootPart = nil
        end

        return if Character ~= nil and HumanoidRootPart ~= nil and ownsRod(Character) then HumanoidRootPart else nil
    end

    local function wantedPoints(p36) -- line: 407
        -- upvalues: t6 (copy), v53 (copy), within (copy), refresh (copy), Workspace (copy), Fishing (copy), FishingFlags (copy), characters (copy)
        local GhostDogCastRipples = Workspace:FindFirstChild("GhostDogCastRipples")
        local Position = if GhostDogCastRipples == nil or not GhostDogCastRipples:IsA("BasePart") then nil else GhostDogCastRipples.Position
        local v84 = FishingFlags.QuestRadius:Get() + 4
        local v85 = characters()

        table.insert(v85, v53)

        local t9 = {}
        local n4 = 8

        for _, v86 in t6 do
            if v86.Part.Parent ~= nil and within(v86, p36) then
                n4 = refresh(v86, p36, v85, n4)

                local Points = v86.Points

                if v86.Large then
                    Points = {}

                    for _, v87 in v86.Cells do
                        if v87 then
                            table.insert(Points, v87)
                        end
                    end
                end

                for _, v88 in Points do
                    if not ((v88 - p36).Magnitude > 60) and (not Position or not (Fishing.FlatDistance(v88, Position) <= v84)) then
                        table.insert(t9, v88)
                    end
                end
            end
        end

        table.sort(t9, function(p37, p38) -- line: 439
            -- upvalues: p36 (copy)
            return (p37 - p36).Magnitude < (p38 - p36).Magnitude
        end)

        local t10 = {}

        for i = 1, math.min(#t9, 6) do
            t10[i] = t9[i]
        end

        return t10
    end

    local function apply(p39) -- line: 449
        -- upvalues: t7 (copy)
        local t11 = {}

        for _, v90 in p39 do
            t11[v90] = true
        end

        for _, v91 in t7 do
            local Point = v91.Point

            if Point then
                if t11[Point] then
                    t11[Point] = nil
                else
                    v91.Point = nil
                    v91.Emitter.Rate = 0
                end
            end
        end

        for _, v92 in t7 do
            if v92.Point == nil then
                local v93 = next(t11)

                if v93 == nil then
                    break
                end

                t11[v93] = nil
                v92.Point = v93
                v92.Attachment.Position = v93
                v92.Emitter.Rate = 0.5
            end
        end
    end

    v52:Connect(CollectionService:GetInstanceAddedSignal(Fishing.WaterTag), track)
    v52:Connect(CollectionService:GetInstanceRemovedSignal(Fishing.WaterTag), untrack)
    v52:Connect(Workspace.DescendantAdded, track)
    v52:Connect(Workspace.DescendantRemoving, untrack)

    for _, v94 in CollectionService:GetTagged(Fishing.WaterTag) do
        track(v94)
    end

    v52:Add(task.defer(function() -- line: 484
        -- upvalues: track (copy), Workspace (copy)
        for v95, descendant in Workspace:GetDescendants() do
            track(descendant)

            if v95 % 4000 == 0 then
                task.wait()
            end
        end
    end))
    v52:Connect(RunService.Heartbeat, function() -- line: 493
        -- upvalues: n3 (ref), allowed (copy), wantedPoints (copy), apply (copy)
        if os.clock() < n3 then
            return
        end

        n3 = os.clock() + 0.25

        local v96 = allowed()

        apply(if v96 then wantedPoints(v96.Position) else {})
    end)

    return v52
end

return t1
