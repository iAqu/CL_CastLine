-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasiteWindow = require(ReplicatedStorage.Shared.Util.MonsterParasiteWindow)
local PartBounds = require(ReplicatedStorage.Shared.Utils.PartBounds)
local t1 = {}
local v1
local self = setmetatable({}, {
    __mode = "k"
})

local function resolveTemplate() -- line: 67
    -- upvalues: ReplicatedStorage (copy), MonsterParasite (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Models = if Assets then Assets:FindFirstChild("Models") else nil
    local v3 = if Models then Models:FindFirstChild(MonsterParasite.AssetsFolderName) else nil
    local v4 = if v3 then v3:FindFirstChild(MonsterParasite.ParasiteModelName) else nil

    return if v4 and v4:IsA("Model") and v4.PrimaryPart then v4 else nil
end

local function getIdleAnimation() -- line: 83
    -- upvalues: MonsterParasite (copy), v1 (ref)
    local v5 = v1

    if v5 == nil then
        v5 = Instance.new("Animation")
        v5.Name = "ParasiteIdle"
        v5.AnimationId = ("rbxassetid://%*"):format(MonsterParasite.ParasiteIdleAnimationId)
        v1 = v5
    end

    return v5
end

local function stripEditorOnly(p1) -- line: 95
    local InitialPoses = p1:FindFirstChild("InitialPoses")

    if InitialPoses then
        InitialPoses:Destroy()
    end

    local AnimSaves = p1:FindFirstChild("AnimSaves")

    if AnimSaves then
        AnimSaves:Destroy()
    end
end

local function configureParts(p2, p3) -- line: 106
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = p3
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        end
    end
end

local function partInside(p4, p5) -- line: 118
    return p5 ~= nil and (p5:IsDescendantOf(p4))
end

local function destroyIfExternalJoint(p6, p7, p8, p9) -- line: 122
    if p6.Name == "ParasiteEggWeld" or p7 == nil or not p7:IsDescendantOf(p9) or not (p8 ~= nil and p8:IsDescendantOf(p9)) then
        p6:Destroy()
    end
end

local function stripExternalJointsAndBillboards(p10) -- line: 137
    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("BillboardGui") or descendant:IsA("Attachment") and descendant.Name == "MonsterParasiteIconAnchor" then
            descendant:Destroy()
        elseif descendant:IsA("Motor6D") or descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
            local Part0, Part1 = descendant.Part0, descendant.Part1

            if descendant.Name == "ParasiteEggWeld" then
                descendant:Destroy()
            elseif Part0 == nil or not Part0:IsDescendantOf(p10) or Part1 == nil or not Part1:IsDescendantOf(p10) then
                descendant:Destroy()
            end
        end
    end
end

local function weldToEgg(p11, p12) -- line: 157
    local ParasiteEggWeld = p12:FindFirstChild("ParasiteEggWeld")

    if ParasiteEggWeld then
        ParasiteEggWeld:Destroy()
    end

    local Motor6D = Instance.new("Motor6D")

    Motor6D.Name = "ParasiteEggWeld"
    Motor6D.Part0 = p11
    Motor6D.Part1 = p12
    Motor6D.C0 = p11.CFrame:Inverse() * p12.CFrame
    Motor6D.Parent = p12

    return Motor6D
end

local function poseDrift(p13) -- line: 178
    local PrimaryPart = p13.PrimaryPart
    local Bone = if PrimaryPart then PrimaryPart:FindFirstChildWhichIsA("Bone") else nil

    if PrimaryPart == nil or Bone == nil then
        return (Vector3.new(0, 0, 0))
    end

    return Bone.TransformedWorldCFrame.Position - (PrimaryPart.CFrame * Bone.CFrame).Position
end

local function poseTransform(p14) -- line: 193
    local PrimaryPart = p14.PrimaryPart
    local Bone = if PrimaryPart then PrimaryPart:FindFirstChildWhichIsA("Bone") else nil

    if PrimaryPart == nil or Bone == nil then
        return CFrame.identity
    end

    return PrimaryPart.CFrame:Inverse() * Bone.TransformedWorldCFrame * Bone.CFrame:Inverse()
end

local function poseMoved(p15, p16) -- line: 205
    if p15 == nil or (p15.RightVector - p16.RightVector).Magnitude + (p15.UpVector - p16.UpVector).Magnitude + (p15.LookVector - p16.LookVector).Magnitude > 0.001 then
        return true
    end

    return (p15.Position - p16.Position).Magnitude > 0.001
end

local function visibleParts(p17) -- line: 216
    local t4 = {}

    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            table.insert(t4, descendant)
        end
    end

    return t4
end

local function resolveSeat(p18, p19, p20) -- line: 233
    -- upvalues: Workspace (copy), MonsterParasite (copy), PartBounds (copy), visibleParts (copy)
    local PrimaryPart = p20.PrimaryPart

    if PrimaryPart == nil or not p18:IsDescendantOf(Workspace) then
        return nil
    end

    local v6 = visibleParts(p18)
    local v7 = visibleParts(p20)

    if #v6 == 0 or #v7 == 0 then
        return nil
    end

    local Rotation = p19.CFrame.Rotation
    local v8, v9 = PartBounds(v6, Rotation)

    if v9.Magnitude < 0.001 then
        return nil
    end

    local v10, v11 = PartBounds(v7, PrimaryPart.CFrame.Rotation)
    local v12 = PrimaryPart.CFrame:PointToObjectSpace(v10.Position)
    local UpVector, RightVector, LookVector = Rotation.UpVector, Rotation.RightVector, Rotation.LookVector
    local v13 = RaycastParams.new()

    v13.FilterType = Enum.RaycastFilterType.Include
    v13.FilterDescendantsInstances = v6
    v13.RespectCanCollide = false

    local Magnitude = v9.Magnitude
    local ParasiteCrownOffset = MonsterParasite.ParasiteCrownOffset
    local v14 = v8.Position + RightVector * (ParasiteCrownOffset.X * v9.X) + LookVector * (ParasiteCrownOffset.Y * v9.Z) + UpVector * Magnitude
    local v15 = UpVector * -Magnitude

    local function probe(p21) -- line: 283
        -- upvalues: v13 (copy), v14 (copy), v15 (copy), Workspace (copy)
        return Workspace:Raycast(v14 + p21, v15, v13)
    end

    local v16 = Workspace:Raycast(v14 + Vector3.new(0, 0, 0), v15, v13)

    if v16 == nil then
        return nil
    end

    local v17 = (v14 - v16.Position):Dot(UpVector)
    local v18 = math.min(v11.X, v11.Z) * 0.4

    for _, v19 in {
            RightVector * v18,
            RightVector * -v18,
            LookVector * v18,
            LookVector * -v18
        } do
        local v20 = Workspace:Raycast(v14 + v19, v15, v13)

        if v20 then
            v17 = math.min(v17, (v14 + v19 - v20.Position):Dot(UpVector))
        end
    end

    local v22 = CFrame.fromMatrix(Vector3.new(0, 0, 0), UpVector:Cross(-LookVector), UpVector, -LookVector)
    local PrimaryPart2 = p20.PrimaryPart
    local Bone = if PrimaryPart2 then PrimaryPart2:FindFirstChildWhichIsA("Bone") else nil
    local v23 = if PrimaryPart2 == nil or Bone == nil then CFrame.identity else PrimaryPart2.CFrame:Inverse() * Bone.TransformedWorldCFrame * Bone.CFrame:Inverse()
    local v24 = v22 * v23.Rotation:Inverse()

    return v24 + (v14 - UpVector * (v17 - v11.Y * 0.04999999999999999) - v24:VectorToWorldSpace(v23 * v12))
end

local function removeIcon(p22) -- line: 330
    for _, descendant in p22:GetDescendants() do
        if descendant:IsA("BillboardGui") or descendant:IsA("Attachment") and descendant.Name == "MonsterParasiteIconAnchor" then
            descendant:Destroy()
        end
    end
end

local self2 = setmetatable({}, {
    __mode = "k"
})

local function holdSeat(p23, p24, p25, p26) -- line: 353
    -- upvalues: RunService (copy), resolveSeat (copy), self2 (copy)
    if p26.PrimaryPart == nil then
        return
    end

    local v26 = (self2[p25] or 0) + 1

    self2[p25] = v26

    local v27
    local v28 = false
    local v29
    local v30 = false
    local v31 = os.clock() + 30
    local connection

    connection = RunService.PostSimulation:Connect(function() -- line: 373
        -- upvalues: p23 (copy), p24 (copy), p25 (copy), p26 (copy), v26 (copy), v27 (ref), v28 (ref), v29 (ref), v30 (ref), v31 (copy), connection (ref), resolveSeat (copy), self2 (copy)
        if self2[p25] ~= v26 or p25.Parent == nil or p24.Parent == nil or p26.Parent == nil then
            connection:Disconnect()

            return
        end

        if v30 then
            connection:Disconnect()
        else
            local PrimaryPart = p26.PrimaryPart
            local Bone = if PrimaryPart then PrimaryPart:FindFirstChildWhichIsA("Bone") else nil
            local v32 = if PrimaryPart == nil or Bone == nil then CFrame.identity else PrimaryPart.CFrame:Inverse() * Bone.TransformedWorldCFrame * Bone.CFrame:Inverse()
            local v33 = v27
            local v34, v35

            if v33 == nil or (v33.RightVector - v32.RightVector).Magnitude + (v33.UpVector - v32.UpVector).Magnitude + (v33.LookVector - v32.LookVector).Magnitude > 0.001 or (v33.Position - v32.Position).Magnitude > 0.001 then
                v34 = resolveSeat(p23, p24, p26)

                if v34 then
                    v27 = v32
                    v35 = v28

                    if not v35 then
                        local identity = CFrame.identity

                        v35 = identity == nil or (identity.RightVector - v32.RightVector).Magnitude + (identity.UpVector - v32.UpVector).Magnitude + (identity.LookVector - v32.LookVector).Magnitude > 0.001 or (identity.Position - v32.Position).Magnitude > 0.001
                    end

                    v28 = v35
                    p25.C0 = p24.CFrame:Inverse() * v34
                end
            end

            local elapsed = os.clock()

            if v29 == nil and v28 then
                v29 = elapsed + 0.35
            end

            if (v29 or v31) <= elapsed then
                v30 = true
            end
        end
    end)
end

local function seatWhenReachable(p27, p28, p29, p30) -- line: 411
    -- upvalues: resolveSeat (copy), holdSeat (copy)
    if p29.PrimaryPart == nil then
        return
    end

    local connection

    connection = p27.AncestryChanged:Connect(function() -- line: 422
        -- upvalues: p27 (copy), p28 (copy), p29 (copy), p30 (copy), connection (ref), resolveSeat (copy), holdSeat (copy)
        if p30.Parent == nil or p29.Parent ~= p27 then
            connection:Disconnect()
        else
            local v36 = resolveSeat(p27, p28, p29)

            if v36 ~= nil then
                connection:Disconnect()
                p30.C0 = p28.CFrame:Inverse() * v36
                holdSeat(p27, p28, p30, p29)
            end
        end
    end)
end

local function attachOutline(p31) -- line: 443
    -- upvalues: MonsterParasite (copy)
    if p31:FindFirstChild(MonsterParasite.ParasiteHighlightName) then
        return
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = MonsterParasite.ParasiteHighlightName
    Highlight.Adornee = p31
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillColor = MonsterParasite.ParasiteHighlightColor
    Highlight.FillTransparency = MonsterParasite.ParasiteHighlightFillTransparency
    Highlight.OutlineColor = MonsterParasite.ParasiteHighlightColor
    Highlight.OutlineTransparency = MonsterParasite.ParasiteHighlightTransparency
    Highlight.Parent = p31
end

local function playIdle(p32) -- line: 459
    -- upvalues: Workspace (copy), MonsterParasite (copy), v1 (ref)
    local function tryPlay() -- line: 460
        -- upvalues: p32 (copy), Workspace (copy), MonsterParasite (copy), v1 (ref)
        if p32.Parent == nil or not p32:IsDescendantOf(Workspace) then
            return false
        end

        local v37 = p32:FindFirstChildWhichIsA("Animator", true)

        if v37 ~= nil and v37:IsA("Animator") then
            local v38 = v1

            if v38 == nil then
                v38 = Instance.new("Animation")
                v38.Name = "ParasiteIdle"
                v38.AnimationId = ("rbxassetid://%*"):format(MonsterParasite.ParasiteIdleAnimationId)
                v1 = v38
            end

            local AnimationId = v38.AnimationId

            for _, v39 in v37:GetPlayingAnimationTracks() do
                local Animation = v39.Animation

                if Animation and Animation.AnimationId == AnimationId then
                    return true
                end
            end

            local function v40() -- line: 481
                -- upvalues: v37 (copy), MonsterParasite (copy), v1 (ref)
                local v41 = v1

                if v41 == nil then
                    v41 = Instance.new("Animation")
                    v41.Name = "ParasiteIdle"
                    v41.AnimationId = ("rbxassetid://%*"):format(MonsterParasite.ParasiteIdleAnimationId)
                    v1 = v41
                end

                return v37:LoadAnimation(v41)
            end

            local ok, result = pcall(v40)

            if ok then
                result.Looped = true
                result.Priority = Enum.AnimationPriority.Idle
                result:Play()
            else
                warn((("[MonsterParasite] Failed to load parasite idle: %*"):format(result)))
            end

            return true
        end

        warn((("[MonsterParasite] Missing Animator in %*"):format((p32:GetFullName()))))

        return true
    end

    if tryPlay() then
        return
    end

    local connection

    connection = p32.AncestryChanged:Connect(function() -- line: 501
        -- upvalues: tryPlay (copy), connection (ref)
        if tryPlay() then
            connection:Disconnect()
        end
    end)
end

local function decorate(p33) -- line: 508
    -- upvalues: MonsterParasite (copy), resolveTemplate (copy), configureParts (copy), weldToEgg (copy), resolveSeat (copy), removeIcon (copy), holdSeat (copy), attachOutline (copy), playIdle (copy)
    local v42 = p33:FindFirstChild(MonsterParasite.ParasiteVisualName)

    if not (v42 and v42:IsA("Model")) then
        local v43 = resolveTemplate()
        local PrimaryPart = p33.PrimaryPart

        if v43 == nil or PrimaryPart == nil then
            return nil
        end

        local clone = v43:Clone()

        clone.Name = MonsterParasite.ParasiteVisualName

        local InitialPoses = clone:FindFirstChild("InitialPoses")

        if InitialPoses then
            InitialPoses:Destroy()
        end

        local AnimSaves = clone:FindFirstChild("AnimSaves")

        if AnimSaves then
            AnimSaves:Destroy()
        end

        clone:ScaleTo(v43:GetScale() * p33:GetScale() * MonsterParasite.ParasiteScaleMultiplier)
        configureParts(clone, true)

        local ParasiteCrownOffset = MonsterParasite.ParasiteCrownOffset
        local Size = PrimaryPart.Size

        clone:PivotTo(PrimaryPart.CFrame * CFrame.new(ParasiteCrownOffset.X * Size.X, Size.Y * 0.5, ParasiteCrownOffset.Y * Size.Z))

        local PrimaryPart2 = clone.PrimaryPart

        assert(PrimaryPart2 ~= nil, "Parasite template requires a PrimaryPart")

        local v45 = resolveSeat(p33, PrimaryPart, clone)

        if v45 then
            clone:PivotTo(v45 * (PrimaryPart2.CFrame:Inverse() * clone:GetPivot()))
        end

        clone.Parent = p33

        local v46 = weldToEgg(PrimaryPart, PrimaryPart2)

        holdSeat(p33, PrimaryPart, v46, clone)

        if v45 == nil and clone.PrimaryPart ~= nil then
            local connection

            connection = p33.AncestryChanged:Connect(function() -- line: 422
                -- upvalues: p33 (copy), PrimaryPart (copy), clone (copy), v46 (copy), connection (ref), resolveSeat (copy), holdSeat (copy)
                if v46.Parent == nil or clone.Parent ~= p33 then
                    connection:Disconnect()
                else
                    local v47 = resolveSeat(p33, PrimaryPart, clone)

                    if v47 ~= nil then
                        connection:Disconnect()
                        v46.C0 = PrimaryPart.CFrame:Inverse() * v47
                        holdSeat(p33, PrimaryPart, v46, clone)
                    end
                end
            end)
        end

        configureParts(clone, false)
        attachOutline(clone)
        playIdle(clone)

        return clone
    end

    attachOutline(v42)
    removeIcon(v42)
    playIdle(v42)

    return v42
end

local function applyDecoration(p34) -- line: 563
    -- upvalues: MonsterParasiteWindow (copy), t1 (copy), self (copy), decorate (copy)
    if self[p34] == true and MonsterParasiteWindow.IsActive() then
        return (decorate(p34))
    end

    t1.Clear(p34)

    return nil
end

function t1.PoseDrift(p35) -- line: 579
    local PrimaryPart = p35.PrimaryPart
    local Bone = if PrimaryPart then PrimaryPart:FindFirstChildWhichIsA("Bone") else nil

    if PrimaryPart == nil or Bone == nil then
        return (Vector3.new(0, 0, 0))
    end

    return Bone.TransformedWorldCFrame.Position - (PrimaryPart.CFrame * Bone.CFrame).Position
end

function t1.Clear(p36) -- line: 583
    -- upvalues: MonsterParasite (copy)
    local v48 = p36:FindFirstChild(MonsterParasite.ParasiteVisualName, true)

    if v48 then
        v48:Destroy()
    end

    for _, descendant in p36:GetDescendants() do
        if descendant:IsA("BillboardGui") and descendant.Name == MonsterParasite.ParasiteBillboardName or descendant:IsA("Highlight") and descendant.Name == MonsterParasite.ParasiteHighlightName then
            descendant:Destroy()
        end
    end
end

function t1.PrepareYankClone(p37) -- line: 604
    -- upvalues: Workspace (copy), configureParts (copy), stripExternalJointsAndBillboards (copy), playIdle (copy)
    if p37.PrimaryPart == nil then
        return nil
    end

    local Pivot = p37:GetPivot()
    local clone = p37:Clone()
    local InitialPoses = clone:FindFirstChild("InitialPoses")

    if InitialPoses then
        InitialPoses:Destroy()
    end

    local AnimSaves = clone:FindFirstChild("AnimSaves")

    if AnimSaves then
        AnimSaves:Destroy()
    end

    stripExternalJointsAndBillboards(clone)
    configureParts(clone, true)
    clone.Parent = Workspace
    clone:PivotTo(Pivot)
    playIdle(clone)
    p37:Destroy()

    return clone
end

function t1.Attach(p38, p39) -- line: 621
    -- upvalues: MonsterParasiteWindow (copy), t1 (copy), self (copy), decorate (copy)
    self[p38] = p39 == true or nil

    if self[p38] == true and MonsterParasiteWindow.IsActive() then
        return (decorate(p38))
    end

    t1.Clear(p38)

    return nil
end

MonsterParasiteWindow.Changed:Connect(function() -- line: 630
    -- upvalues: MonsterParasiteWindow (copy), t1 (copy), self (copy), decorate (copy)
    for v50 in self do
        if v50.Parent ~= nil then
            if self[v50] == true and MonsterParasiteWindow.IsActive() then
                decorate(v50)
            else
                t1.Clear(v50)
            end
        end
    end
end)

return table.freeze(t1)
