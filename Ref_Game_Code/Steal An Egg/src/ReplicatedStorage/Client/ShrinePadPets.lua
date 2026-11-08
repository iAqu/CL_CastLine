-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local FusionShrines = require(ReplicatedStorage.Shared.FusionShrines)
local Kit = require(ReplicatedStorage.Client.ShrineFusionSequences.Kit)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = table.freeze({
    Toss = 115818434760382,
    Land = 140086252907114
})
local v2 = table.freeze({
    Sparkle = "rbxasset://textures/particles/sparkles_main.dds",
    Shockwave = "rbxassetid://109600784699514",
    Energy = "rbxassetid://85003420967228"
})
local v3 = Color3.new(1, 1, 1)
local LocalPlayer = Players.LocalPlayer
local t1 = {}

t1.__index = t1

local function rigTemplate(p1) -- line: 42
    -- upvalues: ReplicatedStorage (copy)
    local FusionShrineRigs = ReplicatedStorage.Assets.Models:FindFirstChild("FusionShrineRigs")

    return if FusionShrineRigs and p1 then FusionShrineRigs:FindFirstChild(p1) else nil
end

local function padTop(p2) -- line: 47
    return p2.Position + Vector3.new(0, 1, 0) * (p2.Size.Y / 2)
end

local function footOf(p3) -- line: 51
    local BoundingBox, BoundingBox2 = p3:GetBoundingBox()

    return p3:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2)
end

local function rootNear(p4, p5) -- line: 56
    -- upvalues: Players (copy), Kit (copy)
    local v4 = if type(p4) == "number" then Players:GetPlayerByUserId(p4) else nil
    local v5 = Kit.RootOf(if v4 then v4.Character else nil)

    return if v5 and (v5.Position - p5).Magnitude <= 90 then v5 else nil
end

function t1.Size(p6, p7) -- line: 65
    local Placement = p6.Placement

    return Placement and Placement.Sizes[p7] or 8
end

function t1.Home(p8, p9, p10, p11) -- line: 70
    -- upvalues: Kit (copy)
    local Placement = p8.Placement
    local v6 = Placement and Placement.Hover[p9] or 0
    local v7 = p10.Position + Vector3.new(0, 1, 0) * (p10.Size.Y / 2) + Vector3.new(0, 1, 0) * v6
    local v8 = Kit.Flat(p11 - v7)

    if v8.Magnitude < 0.001 then
        v8 = p10.CFrame.LookVector
    end

    return CFrame.lookAt(v7, v7 + v8)
end

function t1.Template(p12) -- line: 86
    -- upvalues: ReplicatedStorage (copy)
    local FusionShrineRigs = ReplicatedStorage.Assets.Models:FindFirstChild("FusionShrineRigs")

    return if FusionShrineRigs and p12 then FusionShrineRigs:FindFirstChild(p12) else nil
end

local function emitter(p13, p14) -- line: 90
    -- upvalues: Kit (copy)
    local v9 = Kit.Emitter(p13, p14)

    v9.Enabled = false

    return v9
end

local function buildHost(p15, p16, p17, p18) -- line: 96
    -- upvalues: Kit (copy), v2 (copy), v3 (copy)
    local Part = Kit.Part
    local t2 = {
        Transparency = 1,
        Size = Vector3.new(0.2, 0.2, 0.2),
        Name = "PadPetHost_" .. p15.Name
    }
    local new = CFrame.new
    local Pad = p15.Pad

    t2.CFrame = new(Pad.Position + Vector3.new(0, 1, 0) * (Pad.Size.Y / 2) + Vector3.new(0, 0.15, 0))

    local v10 = Part(t2)

    v10.Parent = p17
    p18:Add(v10)

    local t3 = {
        LightEmission = 1,
        LightInfluence = 0,
        ZOffset = 2,
        Texture = v2.Shockwave,
        Color = ColorSequence.new(p16),
        Orientation = Enum.ParticleOrientation.VelocityPerpendicular,
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(0.01),
        Lifetime = NumberRange.new(0.55),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.2),
            NumberSequenceKeypoint.new(1, 15)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.6, 0.35),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local v11 = Kit.Emitter(v10, t3)

    v11.Enabled = false

    local t4 = {
        Drag = 3.5,
        Acceleration = Vector3.new(0, -6, 0),
        LightEmission = 1,
        LightInfluence = 0,
        ZOffset = 1,
        Texture = v2.Sparkle,
        Color = ColorSequence.new(v3, p16),
        SpreadAngle = Vector2.new(70, 70),
        EmissionDirection = Enum.NormalId.Top,
        Speed = NumberRange.new(7, 17),
        Lifetime = NumberRange.new(0.6, 1.2),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(1, 0)
        })
    }
    local v12 = Kit.Emitter(v10, t4)

    v12.Enabled = false

    local PointLight = Instance.new("PointLight")

    PointLight.Color = p16
    PointLight.Range = 14
    PointLight.Brightness = 0
    PointLight.Shadows = false
    PointLight.Parent = v10

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "TetherBase"
    Attachment.Parent = v10

    return {
        Part = v10,
        Wave = v11,
        Sparkles = v12,
        Light = PointLight,
        Base = Attachment
    }
end

function t1.new(p19, p20, p21, p22) -- line: 154
    -- upvalues: Workspace (copy), Trove (copy), v3 (copy), t1 (copy), buildHost (copy)
    local v13 = Trove.new()
    local Folder = Instance.new("Folder")

    Folder.Name = "ShrinePadPets"
    Folder.Parent = Workspace:FindFirstChild("Transient") or Workspace
    v13:Add(Folder)

    local v14 = setmetatable({
        Hidden = false,
        Model = p19,
        Kind = p20,
        Center = p22,
        Trove = v13,
        Folder = Folder,
        Slots = {},
        Leaving = {}
    }, t1)

    for _, v15 in p21 do
        local v16 = p20.Colors[v15.Side] or v3
        local t6 = {
            Flash = 0,
            Slot = v15,
            Name = v15.Name,
            Side = v15.Side,
            Pad = v15.Pad,
            Color = v16,
            Host = buildHost(v15, v16, Folder, v13),
            Prompt = v15.Pad:FindFirstChild("PlacePrompt", true)
        }

        table.insert(v14.Slots, t6)

        for _, v17 in { "PlacedCategory", "PlacedUserId", "PlacedAt" } do
            v13:Connect(v15.Pad:GetAttributeChangedSignal(v17), function() -- line: 189
                -- upvalues: v14 (copy), t6 (copy)
                if t6.Queued then
                    return
                end

                t6.Queued = true
                task.defer(function() -- line: 192
                    -- upvalues: v14 (copy), t6 (copy)
                    t6.Queued = false
                    v14:Sync(t6)
                end)
            end)
        end

        v14:Sync(t6)
    end

    return v14
end

function t1.Silent(p23) -- line: 204
    local FusionPhase = p23.Model:GetAttribute("FusionPhase")
    local Hidden = p23.Hidden

    if not Hidden then
        Hidden = FusionPhase == "Ritual" or FusionPhase == "Committing"
    end

    return Hidden
end

function t1.Spawn(p24, p25, p26, p27, p28) -- line: 209
    -- upvalues: Players (copy), ReplicatedStorage (copy), Workspace (copy), Assets (copy), Kit (copy), v1 (copy), v2 (copy), v3 (copy), t1 (copy)
    local v18 = Assets.Directory[p26] or {}
    local v19 = t1.Size(p24.Kind, p25.Side)
    local PetModel = Kit.PetModel
    local FusionShrineRigs = ReplicatedStorage.Assets.Models:FindFirstChild("FusionShrineRigs")
    local v20 = PetModel(p26, v19, if not FusionShrineRigs or not p26 then nil else FusionShrineRigs:FindFirstChild(p26))

    if not v20 then
        return
    end

    local v21 = t1.Home(p24.Kind, p25.Side, p25.Pad, p24.Center)
    local BoundingBox, BoundingBox2 = v20:GetBoundingBox()
    local v22 = v20:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2)
    local Scale = v20:GetScale()
    local v23 = v18.Animations or {}
    local v24

    if type(p28) == "number" and Workspace:GetServerTimeNow() - p28 < 2 then
        local Position = v21.Position
        local v25 = if type(p27) == "number" then Players:GetPlayerByUserId(p27) else nil

        v24 = Kit.RootOf(if v25 then v25.Character else nil)

        if not (v24 and (v24.Position - Position).Magnitude <= 90) then
            v24 = nil
        end
    end

    local t7 = {
        Model = v20,
        Full = Scale,
        Foot = v22,
        Home = v21,
        Category = p26,
        UserId = p27,
        Started = os.clock(),
        Mode = v24 and "Fly" or "Pop",
        From = if v24 then (v24.CFrame * CFrame.new(1, 0.6, -1.6)).Position else v21.Position,
        Spin = p25.Side == "Whale" and 1 or -1
    }

    v20:ScaleTo(Scale * 0.2)
    v20:PivotTo(v21)
    v20.Parent = p24.Folder
    t7.Track = Kit.PlayAnimation(v20, v23.Idle or v23.Walk, 1)

    if p25.Side == "Whale" then
        local v26 = v20.PrimaryPart or v20:FindFirstChildWhichIsA("BasePart", true)

        if v26 then
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "TetherTip"
            Attachment.Parent = v26

            local Beam = Instance.new("Beam")

            Beam.Attachment0 = p25.Host.Base
            Beam.Attachment1 = Attachment
            Beam.Texture = v2.Energy
            Beam.TextureMode = Enum.TextureMode.Stretch
            Beam.TextureSpeed = 1.4
            Beam.Color = ColorSequence.new(p25.Color, v3)
            Beam.LightEmission = 1
            Beam.LightInfluence = 0
            Beam.FaceCamera = true
            Beam.Segments = 12
            Beam.Width0 = 2.4
            Beam.Width1 = 0.5
            Beam.Transparency = NumberSequence.new(1)
            Beam.Parent = p25.Host.Part
            t7.Beam = Beam
        end
    end

    if p24.Hidden then
        Kit.Hide(v20)
    end

    p25.Pet = t7

    if not p24.Hidden then
        Kit.Sound(v1.Toss, v24 or p25.Host.Part, 0.45, 1.15)
    end
end

function t1.Release(p29, p30, p31) -- line: 271
    -- upvalues: Players (copy), Kit (copy), v1 (copy)
    local Pet = p30.Pet

    if not Pet then
        return
    end

    p30.Pet = nil

    if Pet.Beam then
        Pet.Beam:Destroy()
    end

    if p31 or p29.Hidden then
        Pet.Model:Destroy()

        return
    end

    local UserId = Pet.UserId
    local Position = Pet.Model:GetPivot().Position
    local v27 = if type(UserId) == "number" then Players:GetPlayerByUserId(UserId) else nil
    local v28 = Kit.RootOf(if v27 then v27.Character else nil)

    if not (v28 and (v28.Position - Position).Magnitude <= 90) then
        v28 = nil
    end

    Pet.Mode = "Leave"
    Pet.Started = os.clock()
    Pet.From = Pet.Model:GetPivot().Position

    if v28 then
        Pet.To = v28.Position + Vector3.new(0, 1.5, 0)
    else
        Pet.To = Pet.From + Vector3.new(0, 9, 0)
    end

    Pet.Rotation = Pet.Model:GetPivot().Rotation
    Pet.Size = Pet.Model:GetScale()
    p30.Host.Sparkles:Emit(10)
    table.insert(p29.Leaving, Pet)
    Kit.Sound(v1.Toss, p30.Host.Part, 0.35, 0.9)
end

function t1.Sync(p32, p33) -- line: 296
    local Pad = p33.Pad
    local PlacedCategory = Pad:GetAttribute("PlacedCategory")
    local PlacedUserId = Pad:GetAttribute("PlacedUserId")
    local PlacedAt = Pad:GetAttribute("PlacedAt")
    local Pet = p33.Pet
    local Pet2

    if not Pet or Pet.Category == PlacedCategory and Pet.UserId == PlacedUserId and Pet.At == PlacedAt then
        Pet2 = Pet
    else
        Pet2 = nil
        p32:Release(p33, p32:Silent())
    end

    if not Pet2 and type(PlacedCategory) == "string" then
        p32:Spawn(p33, PlacedCategory, PlacedUserId, PlacedAt)

        if p33.Pet then
            p33.Pet.At = PlacedAt
        end
    end
end

function t1.SetHidden(p34, p35) -- line: 314
    -- upvalues: Kit (copy)
    if p34.Hidden == p35 then
        return
    end

    p34.Hidden = p35

    for _, v29 in p34.Slots do
        local Pet = v29.Pet

        if Pet then
            if p35 then
                Kit.Hide(Pet.Model)
            else
                Kit.Show(Pet.Model)
            end

            if Pet.Beam then
                Pet.Beam.Enabled = not p35
            end
        end

        v29.Host.Light.Enabled = not p35
    end
end

local function landed(p36) -- line: 335
    -- upvalues: Kit (copy), v1 (copy)
    p36.Host.Wave:Emit(1)
    p36.Host.Sparkles:Emit(26)
    p36.Flash = 1
    Kit.Sound(v1.Land, p36.Host.Part, 0.6, 1)
end

function t1.StepPet(p37, p38, p39, p40) -- line: 342
    -- upvalues: Kit (copy), v1 (copy)
    local Pet = p38.Pet

    if not Pet then
        return
    end

    local Home = Pet.Home
    local v30 = Kit.ReducedMotion()
    local v31 = p40 - Pet.Started
    local n1 = 1

    if Pet.Mode == "Fly" or Pet.Mode == "Pop" then
        local v32 = if Pet.Mode ~= "Fly" then 0.38 elseif v30 then 0.38 else 0.62
        local v33 = Kit.Clamp01(v31 / v32)

        if Pet.Mode ~= "Fly" or v30 then
            n1 = Kit.Lerp(0.2, 1, Kit.BackOut(v33))
            Home += Vector3.new(0, 1, 0) * ((1 - v33) * 1.5)
        else
            local v34 = Kit.Ease(v33, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            local Magnitude = (Home.Position - Pet.From).Magnitude
            local v35 = (Pet.From + Home.Position) / 2 + Vector3.new(0, 1, 0) * (5 + Magnitude * 0.3)
            local v36 = Kit.Bezier(Pet.From, v35, Home.Position, v34)
            local v37 = (1 - Kit.Ease(v33, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)) * 3.141592653589793 * 2 * Pet.Spin

            Home = CFrame.new(v36) * Home.Rotation * CFrame.Angles(0, v37, 0)
            n1 = Kit.Lerp(0.2, 1, Kit.BackOut(v33))
        end

        if v33 >= 1 then
            Pet.Mode = "Settle"
            Pet.Started = p40

            if not p37.Hidden then
                p38.Host.Wave:Emit(1)
                p38.Host.Sparkles:Emit(26)
                p38.Flash = 1
                Kit.Sound(v1.Land, p38.Host.Part, 0.6, 1)
            end
        end
    elseif Pet.Mode == "Settle" then
        local v38 = Kit.Clamp01(v31 / 0.45)
        local v40 = math.sin(v38 * 3.141592653589793) * (1 - v38)

        n1 = 1 + 0.14 * v40
        Home -= Vector3.new(0, 1, 0) * (0.45 * v40)

        if v38 >= 1 then
            Pet.Mode = "Idle"
            Pet.Started = p40
        end
    end

    local v41 = Home

    if Pet.Mode == "Idle" or Pet.Mode == "Settle" then
        local v42 = if Pet.Mode == "Idle" then Kit.Smooth(Kit.Clamp01(v31 / 1.2)) else 0

        if p38.Side == "Whale" and not v30 then
            local v44 = math.sin(p39 * 1.7) * 0.6 * v42
            local v46 = math.sin(p39 * 0.55) * 0.12 * v42

            v41 = Home * CFrame.new(0, v44, 0) * CFrame.Angles(0, v46, 0)
        end
    end

    if Pet.Beam then
        local v47 = (Pet.Mode == "Fly" or Pet.Mode == "Pop") and 0 or 1

        Pet.BeamT = Kit.Lerp(Pet.BeamT or 0, v47, 0.12)

        local v48 = 1 - Pet.BeamT * 0.55

        Pet.Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v48),
            NumberSequenceKeypoint.new(1, 1)
        })
    end

    local v49 = Pet.Full * math.max(n1, 0.05)

    if math.abs(v49 - Pet.Model:GetScale()) > 1E-04 then
        Pet.Model:ScaleTo(v49)
    end

    Pet.Model:PivotTo(v41 + Vector3.new(0, 1, 0) * (Pet.Foot * n1))
end

function t1.Step(p41, p42, p43) -- line: 411
    -- upvalues: Kit (copy)
    local elapsed = os.clock()

    for _, v51 in p41.Slots do
        p41:StepPet(v51, p42, elapsed)
        v51.Flash = math.max(v51.Flash - p43 * 2.4, 0)

        local v53 = if not v51.Pet then 0 elseif p41.Hidden then 0 else 1.1

        v51.Host.Light.Brightness = v53 + 7 * v51.Flash * v51.Flash
    end

    for i = #p41.Leaving, 1, -1 do
        local v54 = p41.Leaving[i]
        local v55 = Kit.Clamp01((elapsed - v54.Started) / 0.45)
        local v56 = Kit.Ease(v55, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v57 = (v54.From + v54.To) / 2 + Vector3.new(0, 6, 0)
        local v58 = Kit.Bezier(v54.From, v57, v54.To, v56)

        v54.Model:ScaleTo((math.max(v54.Size * (1 - 0.85 * v56), 0.01)))
        v54.Model:PivotTo(CFrame.new(v58) * v54.Rotation * CFrame.Angles(0, v56 * 3.141592653589793, 0))

        if v55 >= 1 or p41.Hidden then
            v54.Model:Destroy()
            table.remove(p41.Leaving, i)
        end
    end
end

function t1.UpdatePrompts(p44, p45, p46) -- line: 434
    -- upvalues: FusionShrines (copy), LocalPlayer (copy)
    local v60 = p44.Kind.Tiers[1]
    local Recipes = if p45.Ready then p45.Recipes else nil
    local Ready = p45.Ready and p45.Status and p45.Status[v60] == "COMPLETED"
    local Copy = p44.Kind.Copy
    local t8 = {}
    local t9 = {}

    for _, v61 in p44.Slots do
        t9[v61.Name] = v61.Side
        t8[v61.Name] = v61.Pad:GetAttribute("PlacedUserId")
    end

    for _, v62 in p44.Slots do
        local Prompt = v62.Prompt

        if Prompt and Prompt:IsA("ProximityPrompt") then
            local PlacedUserId = v62.Pad:GetAttribute("PlacedUserId")

            Prompt.ObjectText = ("%* Pad"):format(v62.Side)

            if p46 then
                Prompt.Enabled = false
            elseif PlacedUserId == LocalPlayer.UserId then
                Prompt.ActionText = "Take Back"
                Prompt.Enabled = true
            elseif PlacedUserId ~= nil then
                Prompt.Enabled = false
            else
                local v63 = FusionShrines.Claim(p44.Kind, t8, t9, LocalPlayer.UserId, v62.Name)

                if Ready then
                    Prompt.ActionText = "Already Fused"
                elseif v63 == "Open" then
                    if Recipes then
                        Prompt.ActionText = Copy.Place(v62.Side, Recipes)
                    else
                        Prompt.ActionText = ("Place %*"):format(v62.Side)
                    end
                else
                    Prompt.ActionText = "Partner's Pad"
                end

                Prompt.Enabled = true
            end
        end
    end
end

function t1.Destroy(p47) -- line: 471
    for _, v64 in p47.Slots do
        if v64.Pet then
            v64.Pet.Model:Destroy()
            v64.Pet = nil
        end
    end

    for _, v65 in p47.Leaving do
        v65.Model:Destroy()
    end

    table.clear(p47.Leaving)
    p47.Trove:Destroy()
end

return table.freeze(t1)
