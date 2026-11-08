-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local BanjoCricketFlags = require(ReplicatedStorage.Shared.Flags.BanjoCricketFlags)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = Color3.fromRGB(12, 10, 24)
local v3 = Color3.fromRGB(55, 55, 65)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local t3 = {}
local v4 = false
local n1 = 0
local v5 = false
local v6, v7
local t4 = {}

t4[1] = Vector3.new(0, 0, 0)

local v8 = OverlapParams.new()

v8.FilterType = Enum.RaycastFilterType.Include

local t5 = {
    Bounce = {
        Seconds = 0.55,
        Sample = function(p1) -- Sample | line: 97
            return math.sin(p1 * 3.141592653589793 * 3) * (1 - p1) * 0.2, 0, 0, 0
        end
    },
    Hop = {
        Seconds = 0.45,
        Sample = function(p2) -- Sample | line: 103
            return math.sin(p2 * 3.141592653589793 * 2) * (1 - p2) * 0.08, math.sin(p2 * 3.141592653589793) * 0.9, 0, 0
        end
    },
    Squish = {
        Seconds = 0.3,
        Sample = function(p3) -- Sample | line: 110
            return -math.sin(p3 * 3.141592653589793) * 0.1, 0, 0, 0
        end
    },
    Breathe = {
        Seconds = 0.7,
        Sample = function(p4) -- Sample | line: 116
            return math.sin(p4 * 3.141592653589793) * 0.06, 0, 0, 0
        end
    },
    Droop = {
        Seconds = 0.9,
        Sample = function(p5) -- Sample | line: 122
            return -math.sin(p5 * 3.141592653589793) * 0.14, 0, 0, 0
        end
    },
    Shake = {
        Seconds = 0.55,
        Sample = function(p6) -- Sample | line: 128
            local v16 = (1 - p6) ^ 2 * 0.15707963267948966

            return 0, 0, math.sin(p6 * 38) * v16, math.cos(p6 * 31) * v16
        end
    }
}
local t6 = {}

local function refreshGlow(p7) -- line: 137
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    local Glow = p7.Glow
    local v20 = TweenInfo.new(if Glow == "Off" then 0.3 elseif Glow == "Dim" then 0.25 else 0.06, Enum.EasingStyle.Quad)
    local v21 = if Glow == "Lit" then 4 elseif Glow == "Soft" then 1.2 else 0
    local v22 = if Glow == "Lit" then 0.35
        elseif Glow == "Soft" then 0.75
        elseif Glow == "Dim" then 0.35
        else 1
    local v23 = if Glow == "Lit" then 0
        elseif Glow == "Soft" then 0.5
        elseif Glow ~= "Off" or not p7.Aimed then 1
        else 0.35
    local Highlight = p7.Highlight

    if Glow ~= "Off" or not p7.Aimed then
        Highlight.OutlineColor = p7.Color
    else
        Highlight.OutlineColor = v1
    end

    local t7 = {
        Brightness = v21
    }

    TweenService:Create(p7.Light, v20, t7):Play()

    local t8 = {
        FillTransparency = v22,
        OutlineTransparency = v23
    }

    if Glow ~= "Off" then
        local v24 = if Glow == "Dim" then v2 else p7.Color

        if p7.Highlight.FillTransparency >= 0.95 then
            p7.Highlight.FillColor = v24
        else
            t8.FillColor = v24
        end
    end

    TweenService:Create(p7.Highlight, v20, t8):Play()
end

local function setGlow(p8, p9, p10) -- line: 180
    -- upvalues: v4 (ref), refreshGlow (copy)
    p8.GlowId += 1
    p8.Glow = p9
    refreshGlow(p8)

    if p10 == nil then
        return
    end

    local GlowId = p8.GlowId

    task.delay(p10, function() -- line: 188
        -- upvalues: p8 (copy), GlowId (copy), v4 (ref), refreshGlow (copy)
        if p8.GlowId ~= GlowId or v4 then
            return
        end

        p8.Glow = "Off"
        refreshGlow(p8)
    end)
end

local function move(p11, p12) -- line: 196
    -- upvalues: t2 (copy)
    p11.Motions[p12] = os.clock()
    t2[p11] = true
end

local function animate() -- line: 201
    -- upvalues: t2 (copy), t5 (copy)
    if next(t2) == nil then
        return
    end

    local elapsed = os.clock()

    for v25 in t2 do
        local n2 = 1
        local n3 = 0
        local n4 = 0
        local n5 = 0

        for v26, v27 in v25.Motions do
            local v28 = t5[v26]
            local v29 = (elapsed - v27) / v28.Seconds

            if v29 >= 1 then
                v25.Motions[v26] = nil
            else
                local v30, v31, v32, v33 = v28.Sample(v29)

                n2 += v30
                n3 += v31
                n4 += v32
                n5 += v33
            end
        end

        if next(v25.Motions) == nil then
            t2[v25] = nil
        end

        if v25.Model.Parent ~= nil then
            v25.Model:ScaleTo(v25.BaseScale * n2)
            v25.Model:PivotTo(v25.BasePivot * CFrame.new(0, n3, 0) * CFrame.Angles(n4, 0, n5))
        end
    end
end

local function beadFolder() -- line: 234
    -- upvalues: Workspace (copy), v6 (ref)
    local v34 = v6

    if v34 and v34.Parent then
        return v34
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "BanjoCricketRings"
    Folder.Parent = Workspace
    v6 = Folder

    return Folder
end

local function makeBeads(p13, p14, p15) -- line: 247
    -- upvalues: Workspace (copy), BanjoCricketFlags (copy), v6 (ref)
    local v35 = BanjoCricketFlags.Stages:Get()
    local v36 = math.max(p13.Size.X, p13.Size.Z) / 2 + 0.7
    local v37 = table.create(v35)

    for i = 1, v35 do
        local v38 = (i - 1) / v35 * 3.141592653589793 * 2
        local v39 = p15:Add(Instance.new("Part"))

        v39.Name = "Bead"
        v39.Shape = Enum.PartType.Ball
        v39.Size = Vector3.new(0.55, 0.55, 0.55)
        v39.Anchored = true
        v39.CanCollide = false
        v39.CanQuery = false
        v39.CanTouch = false
        v39.CastShadow = false
        v39.Transparency = 1
        v39.CFrame = p14 * CFrame.new(math.cos(v38) * v36, 0.3, math.sin(v38) * v36)

        local v40 = v6

        if not (v40 and v40.Parent) then
            v40 = Instance.new("Folder")
            v40.Name = "BanjoCricketRings"
            v40.Parent = Workspace
            v6 = v40
        end

        v39.Parent = v40
        table.insert(v37, v39)
    end

    return v37
end

local function paintBeads(p16, p17) -- line: 271
    -- upvalues: TweenService (copy), v3 (copy), n1 (ref), v5 (ref)
    for v41, v42 in p16.Beads do
        local v43 = v41 <= n1

        if v5 then
            if v43 then
                v42.Transparency = 0
            else
                v42.Transparency = 0.55
            end
        else
            v42.Transparency = 1
        end

        if v43 then
            v42.Color = p16.Color
            v42.Material = Enum.Material.Neon
        else
            v42.Color = v3
            v42.Material = Enum.Material.SmoothPlastic
        end

        if v41 == p17 and v5 then
            v42.Size = Vector3.new(1.1, 1.1, 1.1)
            TweenService:Create(v42, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
                Size = Vector3.new(0.55, 0.55, 0.55)
            }):Play()
        end
    end
end

local function isNear(p18, p19) -- line: 288
    -- upvalues: Workspace (copy), v8 (copy)
    v8.FilterDescendantsInstances = { p19 }

    local BoundingBox, BoundingBox2 = p18.Model:GetBoundingBox()

    return #Workspace:GetPartBoundsInBox(BoundingBox, BoundingBox2 + Vector3.new(2, 2, 2), v8) > 0
end

local function trackPlayer() -- line: 298
    -- upvalues: Workspace (copy), LocalPlayer (copy), t1 (copy), t4 (copy), v8 (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    t4[1] = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then Vector3.new(0, 0, 0) else HumanoidRootPart.AssemblyLinearVelocity

    for _, v46 in t1 do
        if v46.Pressed then
            if Character ~= nil then
                v8.FilterDescendantsInstances = { Character }

                local BoundingBox, BoundingBox2 = v46.Model:GetBoundingBox()

                v46.Pressed = #Workspace:GetPartBoundsInBox(BoundingBox, BoundingBox2 + Vector3.new(2, 2, 2), v8) > 0
            else
                v46.Pressed = false
            end
        end
    end
end

local function approachSpeed(p20, p21) -- line: 311
    -- upvalues: t4 (copy)
    local HumanoidRootPart = p21:FindFirstChild("HumanoidRootPart")
    local v48, v49

    if HumanoidRootPart ~= nil then
        if HumanoidRootPart:IsA("BasePart") then
            local v50 = (p20.Anchor.Position - HumanoidRootPart.Position) * Vector3.new(1, 0, 1)

            v48 = if v50.Magnitude > 0.001 then t4[1]:Dot(v50.Unit) else 0
            v49 = false
        else
            v49 = true
        end
    else
        v49 = true
    end

    if v49 then
        return 0
    end

    return (math.max(v48, -t4[1].Y))
end

local function watchBumps(p22) -- line: 321
    -- upvalues: LocalPlayer (copy), v7 (ref), approachSpeed (copy)
    for _, descendant in p22.Model:GetDescendants() do
        if descendant:IsA("BasePart") then
            p22.Trove:Connect(descendant.Touched, function(p23) -- line: 326
                -- upvalues: p22 (copy), LocalPlayer (copy), v7 (ref), approachSpeed (copy)
                local Character = LocalPlayer.Character
                local elapsed = os.clock()

                if Character ~= nil and not p22.Pressed and p23:IsDescendantOf(Character) and p23:FindFirstAncestorOfClass("Tool") == nil and next(p22.Motions) == nil and not (elapsed - p22.BumpedAt < 0.6 or approachSpeed(p22, Character) < 3) then
                    p22.BumpedAt = elapsed
                    p22.Pressed = true

                    local v52 = v7

                    if v52 then
                        v52(p22.Index)
                    end
                end
            end)
        end
    end
end

local function anchorOf(p24) -- line: 353
    local Hitbox = p24:FindFirstChild("Hitbox")

    if not (Hitbox and Hitbox:IsA("BasePart")) then
        return p24.PrimaryPart
    end

    return Hitbox
end

local function bind(p25) -- line: 361
    -- upvalues: Workspace (copy), BanjoCricket (copy), Trove (copy), t1 (copy), t3 (copy), makeBeads (copy), paintBeads (copy), watchBumps (copy)
    local Attribute, Hitbox

    if not t1[p25] and p25:IsA("Model") and p25:IsDescendantOf(Workspace) then
        Attribute = p25:GetAttribute(BanjoCricket.Attributes.MushroomIndex)
        Hitbox = p25:FindFirstChild("Hitbox")

        if not Hitbox or not Hitbox:IsA("BasePart") then
            Hitbox = p25.PrimaryPart
        end

        if Hitbox ~= nil and typeof(Attribute) == "number" then
            local v53 = BanjoCricket.Mushrooms[Attribute]

            if v53 ~= nil then
                local v54 = Trove.new()
                local v55 = v54:Add(Instance.new("PointLight"))

                v55.Brightness = 0
                v55.Range = 16
                v55.Color = v53.Color
                v55.Shadows = false
                v55.Parent = Hitbox

                local v56 = v54:Add(Instance.new("Highlight"))

                v56.Adornee = p25
                v56.DepthMode = Enum.HighlightDepthMode.Occluded
                v56.FillColor = v53.Color
                v56.OutlineColor = v53.Color
                v56.FillTransparency = 1
                v56.OutlineTransparency = 1
                v56.Parent = p25

                local Pivot = p25:GetPivot()
                local t9 = {
                    Glow = "Off",
                    GlowId = 0,
                    Aimed = false,
                    BumpedAt = 0,
                    Pressed = false,
                    Model = p25,
                    Anchor = Hitbox,
                    Index = Attribute,
                    Color = v53.Color,
                    Light = v55,
                    Highlight = v56,
                    Beads = makeBeads(Hitbox, Pivot, v54),
                    BasePivot = Pivot,
                    BaseScale = p25:GetScale(),
                    Motions = {},
                    Trove = v54
                }

                paintBeads(t9)
                watchBumps(t9)
                t1[p25] = t9
                table.insert(t3, {
                    Index = Attribute,
                    Anchor = Hitbox
                })
            end
        end
    end
end

local function unbind(p26) -- line: 418
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local v57 = t1[p26]

    if v57 == nil then
        return
    end

    t1[p26] = nil
    t2[v57] = nil

    for v58, v59 in t3 do
        if v59.Anchor == v57.Anchor then
            table.remove(t3, v58)
            break
        end
    end

    v57.Trove:Destroy()
end

local function each(p27, p28) -- line: 434
    -- upvalues: t1 (copy)
    for _, v60 in t1 do
        if v60.Index == p27 then
            p28(v60)
        end
    end
end

function t6.Start(p29) -- line: 442
    -- upvalues: CollectionService (copy), RunService (copy), BanjoCricket (copy), v7 (ref), animate (copy), trackPlayer (copy), bind (copy), unbind (copy)
    v7 = p29

    local Mushroom = BanjoCricket.Tags.Mushroom

    CollectionService:GetInstanceAddedSignal(Mushroom):Connect(bind)
    CollectionService:GetInstanceRemovedSignal(Mushroom):Connect(unbind)

    for _, v61 in CollectionService:GetTagged(Mushroom) do
        bind(v61)
    end

    RunService.PreRender:Connect(animate)
    RunService.PreSimulation:Connect(trackPlayer)
end

function t6.Anchor(p30) -- line: 454
    -- upvalues: t3 (copy)
    for _, v62 in t3 do
        if v62.Index == p30 then
            return v62.Anchor
        end
    end

    return nil
end

function t6.Targets() -- line: 463
    -- upvalues: t3 (copy)
    return t3
end

function t6.DistanceFrom(p31) -- line: 467
    -- upvalues: t3 (copy)
    local n6 = 1e999

    for _, v63 in t3 do
        n6 = math.min(n6, (v63.Anchor.Position - p31).Magnitude)
    end

    return n6
end

function t6.RandomIndex(p32) -- line: 476
    -- upvalues: t3 (copy)
    return if #t3 ~= 0 then t3[p32:NextInteger(1, #t3)].Index else nil
end

function t6.Flash(p33, p34) -- line: 483
    -- upvalues: t1 (copy), v4 (ref), refreshGlow (copy)
    for _, v64 in t1 do
        if v64.Index == p33 then
            v64.GlowId += 1
            v64.Glow = "Lit"
            refreshGlow(v64)

            if p34 ~= nil then
                local GlowId = v64.GlowId

                task.delay(p34, function() -- line: 188
                    -- upvalues: v64 (copy), GlowId (copy), v4 (ref), refreshGlow (copy)
                    if v64.GlowId ~= GlowId or v4 then
                        return
                    end

                    v64.Glow = "Off"
                    refreshGlow(v64)
                end)
            end
        end
    end
end

function t6.Move(p35, p36) -- line: 489
    -- upvalues: t1 (copy), t2 (copy)
    for _, v65 in t1 do
        if v65.Index == p35 then
            v65.Motions[p36] = os.clock()
            t2[v65] = true
        end
    end
end

function t6.MoveAll(p37) -- line: 495
    -- upvalues: t1 (copy), t2 (copy)
    for _, v66 in t1 do
        v66.Motions[p37] = os.clock()
        t2[v66] = true
    end
end

function t6.Squish(p38) -- line: 502
    -- upvalues: Workspace (copy), t1 (copy), t2 (copy)
    local CurrentCamera = Workspace.CurrentCamera

    for _, v67 in t1 do
        if v67.Index == p38 and (CurrentCamera == nil or (CurrentCamera.CFrame.Position - v67.Anchor.Position).Magnitude <= 150) then
            v67.Motions.Squish = os.clock()
            t2[v67] = true
        end
    end
end

function t6.Pulse() -- line: 515
    -- upvalues: t1 (copy), t2 (copy), v4 (ref), refreshGlow (copy)
    for _, v68 in t1 do
        v68.GlowId += 1
        v68.Glow = "Soft"
        refreshGlow(v68)

        local GlowId = v68.GlowId

        task.delay(0.45, function() -- line: 188
            -- upvalues: v68 (copy), GlowId (copy), v4 (ref), refreshGlow (copy)
            if v68.GlowId ~= GlowId or v4 then
                return
            end

            v68.Glow = "Off"
            refreshGlow(v68)
        end)
        v68.Motions.Breathe = os.clock()
        t2[v68] = true
    end
end

function t6.Dim() -- line: 522
    -- upvalues: t1 (copy), v4 (ref), refreshGlow (copy)
    v4 = false

    for _, v69 in t1 do
        v69.GlowId += 1
        v69.Glow = "Dim"
        refreshGlow(v69)
    end
end

function t6.Darken() -- line: 529
    -- upvalues: t1 (copy), v4 (ref), refreshGlow (copy)
    v4 = false

    for _, v70 in t1 do
        v70.GlowId += 1
        v70.Glow = "Off"
        refreshGlow(v70)
    end
end

function t6.SetAllLit(p39) -- line: 537
    -- upvalues: t1 (copy), t2 (copy), v4 (ref), refreshGlow (copy)
    v4 = p39

    for _, v71 in t1 do
        local v72 = if p39 then "Lit" else "Off"

        v71.GlowId += 1
        v71.Glow = v72
        refreshGlow(v71)

        if p39 then
            v71.Motions.Bounce = os.clock()
            t2[v71] = true
        end
    end
end

function t6.ShowAim(p40) -- line: 547
    -- upvalues: t1 (copy), refreshGlow (copy)
    for _, v73 in t1 do
        local v74 = v73.Index == p40

        if v73.Aimed ~= v74 then
            v73.Aimed = v74
            refreshGlow(v73)
        end
    end
end

function t6.SetProgress(p41, p42) -- line: 557
    -- upvalues: t1 (copy), n1 (ref), v5 (ref), paintBeads (copy)
    local v75 = if n1 < p41 then p41 else nil

    n1 = p41
    v5 = p42

    for _, v76 in t1 do
        paintBeads(v76, v75)
    end
end

return table.freeze(t6)
