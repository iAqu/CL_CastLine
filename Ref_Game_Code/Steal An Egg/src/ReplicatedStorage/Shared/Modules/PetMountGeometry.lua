-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local t1 = {
    AttachmentNames = table.freeze({ "MountSeat", "MountLeftHand", "MountRightHand", "MountLeftFoot", "MountRightFoot" }),
    DefaultGripOffsets = table.freeze({
        MountLeftHand = CFrame.new(-0.8, 0.5, -0.8),
        MountRightHand = CFrame.new(0.8, 0.5, -0.8),
        MountLeftFoot = CFrame.new(-0.75, -1.6, -0.65),
        MountRightFoot = CFrame.new(0.75, -1.6, -0.65)
    })
}

local function finiteFrame(p1) -- line: 18
    -- upvalues: t1 (copy)
    for _, v1 in { p1:GetComponents() } do
        if not t1.IsFinite(v1) then
            return false
        end
    end

    return true
end

function t1.IsFinite(p2) -- line: 27
    if typeof(p2) == "number" and p2 == p2 and p2 > (-1e999) then
        return p2 < 1e999
    end

    return false
end

function t1.ResolveHeight(p3, p4) -- line: 30
    -- upvalues: t1 (copy)
    assert(t1.IsFinite(p3) and p3 > 0, "Pet scale must be positive and finite")

    local MinimumPetScale, MaximumPetScale = p4.MinimumPetScale, p4.MaximumPetScale
    local v3 = p4.ReferenceCharacterHeight * p4.MinimumHeightRatio
    local v4 = p4.ReferenceCharacterHeight * p4.MaximumHeightRatio

    assert(t1.IsFinite(MinimumPetScale) and t1.IsFinite(MaximumPetScale) and MinimumPetScale < MaximumPetScale, "Invalid mount scale range")

    local v6 = t1.IsFinite(v3) and t1.IsFinite(v4) and v3 > 0 and v3 <= v4

    assert(v6, "Invalid mount height range")

    local v8 = math.clamp((p3 - MinimumPetScale) / (MaximumPetScale - MinimumPetScale), 0, 1)

    return v3 + (v4 - v3) * v8
end

function t1.FindAttachment(p5, p6) -- line: 49
    local descendant

    for _, descendant2 in p5:GetDescendants() do
        if descendant2.Name == p6 and descendant2:IsA("Attachment") and not descendant2:IsA("Bone") then
            local v9 = descendant == nil

            descendant = descendant2
            assert(v9, "Duplicate " .. p6 .. " attachments")
        end
    end

    return descendant
end

function t1.AnimatedWorld(p7) -- line: 59
    -- upvalues: t1 (copy)
    local Parent = p7.Parent

    if Parent and Parent:IsA("Bone") then
        return Parent.TransformedWorldCFrame * p7.CFrame
    end

    if not (Parent and Parent:IsA("Attachment")) then
        return p7.WorldCFrame
    end

    return t1.AnimatedWorld(Parent) * p7.CFrame
end

function t1.ClampAnimatedSeat(p8, p9, p10, p11) -- line: 70
    -- upvalues: t1 (copy), finiteFrame (copy)
    assert(finiteFrame(p8), "Invalid animated mount seat")
    assert(t1.IsFinite(p10) and p10 >= 0, "Invalid animation seat offset limit")

    local v13 = t1.IsFinite(p11) and p11 >= 0 and p11 <= 180

    assert(v13, "Invalid animation seat tilt limit")

    if not finiteFrame(p9) then
        return p8
    end

    local v14 = p9.Position - p8.Position

    if p10 < v14.Magnitude then
        v14 = v14.Unit * p10
    end

    local v15, v16 = p8.Rotation:ToObjectSpace(p9.Rotation):Orthonormalize():ToAxisAngle()
    local Rotation = p8.Rotation

    if v15.Magnitude > 1E-06 and v16 == v16 then
        Rotation = p8.Rotation * CFrame.fromAxisAngle(v15.Unit, (math.min(v16, (math.rad(p11)))))
    end

    return Rotation + p8.Position + v14
end

function t1.EnsureSeat(p12, p13) -- line: 99
    -- upvalues: t1 (copy)
    local MountSeat = t1.FindAttachment(p12, "MountSeat")
    local v18 = p12.PrimaryPart.CFrame * p13
    local v19 = MountSeat and MountSeat.Parent

    if not v19 then
        local t2 = {
            upperbody = 1,
            torso = 2,
            chest = 3,
            body = 4,
            lowerbody = 5,
            spine = 6
        }
        local n1 = 1e999

        for _, descendant in p12:GetDescendants() do
            if descendant:IsA("Bone") then
                local v20 = t2[descendant.Name:lower()] or 100

                if v20 < n1 then
                    n1 = v20
                    v19 = descendant
                end
            end
        end

        if not v19 then
            for _, descendant in p12:GetDescendants() do
                if descendant:IsA("BasePart") and t2[descendant.Name:lower()] then
                    v19 = descendant
                    break
                end
            end
        end

        v19 = v19 or p12.PrimaryPart
    end

    if not v19:IsA("Bone") then
        local Bone = Instance.new("Bone")

        Bone.Name = "MountSeatBone"
        Bone.Parent = v19
        v19 = Bone
    end

    local v21 = MountSeat or Instance.new("Attachment")

    v21.Name = "MountSeat"
    v21.CFrame = v19.WorldCFrame:ToObjectSpace(v18)
    v21.Parent = v19

    return v21
end

function t1.EnsureGrip(p14, p15, p16, p17) -- line: 139
    -- upvalues: t1 (copy)
    local v22 = t1.FindAttachment(p14, p15) or Instance.new("Attachment")

    v22.Name = p15
    v22.Parent = p17.Parent
    v22.CFrame = p17.Parent.WorldCFrame:ToObjectSpace(p14.PrimaryPart.CFrame * p16)

    return v22
end

function t1.LimbReach(p18, p19, p20, p21, p22) -- line: 148
    local v23 = p21 .. (if p22 == "Arm" then "Shoulder" else "Hip") .. "RigAttachment"
    local v24 = p21 .. (if p22 == "Arm" then "Elbow" else "Knee") .. "RigAttachment"
    local v25 = p21 .. (if p22 == "Arm" then "Wrist" else "Ankle") .. "RigAttachment"
    local v26 = p18:FindFirstChild(v23)
    local v27 = p18:FindFirstChild(v24)
    local v28 = p19 and p19:FindFirstChild(v24)
    local v29 = p19 and p19:FindFirstChild(v25)
    local v30 = p20:FindFirstChild(v25)

    if v26 and v27 and v28 and v29 and v30 then
        return v26, ((v27.Position - v26.Position).Magnitude + (v29.Position - v28.Position).Magnitude + v30.Position.Magnitude) * 0.95
    end

    return nil, (p18.Size.Y + (p19 and p19.Size.Y or 1) + p20.Size.Y * 0.5) * 0.95
end

function t1.Measure(p23, p24, p25) -- line: 166
    -- upvalues: ModelBounds (copy), t1 (copy), finiteFrame (copy)
    local v31 = p23:FindFirstChild("Segment1", true) or p23.PrimaryPart

    assert(v31 and v31:IsA("BasePart"), "Pet template has no root")

    local v33, v34 = ModelBounds(p23)
    local MountBoundsCFrame = p23:GetAttribute("MountBoundsCFrame")
    local MountBoundsSize = p23:GetAttribute("MountBoundsSize")
    local v35, v36

    if MountBoundsCFrame == nil and MountBoundsSize == nil then
        v35 = v34
        v36 = v33
    else
        local MountBoundsReferenceScale = p23:GetAttribute("MountBoundsReferenceScale")

        assert(typeof(MountBoundsCFrame) == "CFrame" and finiteFrame(MountBoundsCFrame), "Invalid MountBoundsCFrame")

        local v38

        if typeof(MountBoundsSize) == "Vector3" then
            v38 = t1.IsFinite(MountBoundsSize.X)

            if v38 then
                v38 = t1.IsFinite(MountBoundsSize.Y)

                if v38 then
                    v38 = t1.IsFinite(MountBoundsSize.Z)

                    if v38 then
                        v38 = MountBoundsSize.X > 0 and MountBoundsSize.Y > 0 and MountBoundsSize.Z > 0
                    end
                end
            end
        else
            v38 = false
        end

        assert(v38, "Invalid MountBoundsSize")
        assert(t1.IsFinite(MountBoundsReferenceScale) and MountBoundsReferenceScale > 0, "Invalid MountBoundsReferenceScale")

        local v40 = p23:GetScale() / MountBoundsReferenceScale

        v36 = v31.CFrame * (MountBoundsCFrame.Rotation + MountBoundsCFrame.Position * v40)
        v35 = MountBoundsSize * v40
    end

    assert(t1.IsFinite(v35.Y) and v35.Y > 0.01, "Pet template has no visible height")

    local v42 = t1.ResolveHeight(p24, p25)
    local v43 = p25.SpeciesSizeMultipliers and p25.SpeciesSizeMultipliers[p23.Name] or 1
    local v44 = t1.IsFinite(v43) and v43 >= 0.5 and v43 <= 4

    assert(v44, "Invalid species mount size multiplier")

    local v48 = math.clamp(v42 * v43, p25.ReferenceCharacterHeight * p25.MinimumHeightRatio, p25.ReferenceCharacterHeight * p25.MaximumHeightRatio)
    local v49 = v48 / v35.Y
    local v50 = v31.CFrame:PointToObjectSpace(v36.Position).Y - v35.Y * 0.5
    local t3 = {}
    local t4 = {}

    for _, v51 in t1.AttachmentNames do
        local v52 = t1.FindAttachment(p23, v51)

        if v52 then
            assert(finiteFrame(v52.WorldCFrame), v51 .. " has an invalid transform")
            t4[v51] = v52
        else
            table.insert(t3, v51)
        end
    end

    local MountSetupVersion = p23:GetAttribute("MountSetupVersion")
    local v55 = MountSetupVersion ~= 1 or p23:GetAttribute("MountNeedsReview") ~= false

    assert(#t3 == 0 and MountSetupVersion == 1 or p25.AllowPrototypeAttachments, "Mount attachments need setup: " .. p23.Name)

    local MountReferenceHeight = p23:GetAttribute("MountReferenceHeight")
    local v58 = if MountSetupVersion == 1 then MountReferenceHeight else MountReferenceHeight or v35.Y

    assert(t1.IsFinite(v58) and v58 > 0, "Invalid MountReferenceHeight")

    local MountSeat = t4.MountSeat
    local v60 = MountSeat and v31.CFrame:ToObjectSpace(MountSeat.WorldCFrame)
    local v61 = v60 and v60.Rotation + v60.Position * v49 or CFrame.new(0, v50 * v49 + v48 * 0.75, 0)

    if MountSeat then
        assert(MountSeat.Parent:IsA("Bone"), "MountSeat must be directly inside a body Bone")
        assert(v61.UpVector:Dot((Vector3.new(0, 1, 0))) > 0.9, "MountSeat must be upright")

        local v63 = v36:PointToObjectSpace(MountSeat.WorldPosition)
        local v64 = v35.Y * 0.05

        assert(math.abs(v63.X) <= v35.X * 0.5 + v64 and math.abs(v63.Z) <= v35.Z * 0.5 + v64, "MountSeat is outside the pet's horizontal bounds")
    end

    local t5 = {
        MountSeat = v61
    }

    for v66, v67 in t1.DefaultGripOffsets do
        local v68 = t4[v66]
        local v69 = v67

        if v68 and MountSeat then
            assert(v68.Parent == MountSeat.Parent, v66 .. " must share the MountSeat body Bone")

            local v72 = MountSeat.WorldCFrame:ToObjectSpace(v68.WorldCFrame)

            v69 = v72.Rotation + v72.Position * (v58 / v35.Y)
        end

        local _ = v69.Position

        if v66:find("Hand") == nil then
        end

        if v66:find("Left") == nil then
        end

        t5[v66] = v61 * v69
    end

    local v73 = v61.Position.Y - v50 * v49
    local v74 = t1.IsFinite(v73) and v73 > 0 and v73 <= v48 + 5

    assert(v74, "MountSeat is outside the pet bounds")

    local v75 = p25.FlyingPets ~= nil and p25.FlyingPets[p23.Name] == true
    local v76 = if v75 then p25.FlyingHeightStuds else 0
    local v77 = t1.IsFinite(v76) and v76 >= 0 and v76 <= 12

    assert(v77, "Invalid mount flying height")

    return {
        Flying = v75,
        FlyingHeight = v76,
        Height = v48,
        ModelScale = p23:GetScale() * v49,
        Seat = v61,
        LeftHand = t5.MountLeftHand,
        RightHand = t5.MountRightHand,
        LeftFoot = t5.MountLeftFoot,
        RightFoot = t5.MountRightFoot,
        SeatHeight = v73,
        Missing = t3,
        NeedsReview = v55,
        Prototype = #t3 > 0 or MountSetupVersion ~= 1
    }
end

return t1
