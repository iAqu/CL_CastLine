-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Ghosts = {
        LostSpirit = {
            Model = "Ghost1",
            AnimationRoot = "Armature",
            Idle = 83195814978221,
            Walk = 110476420994709,
            Attack = 121163208323387
        },
        HauntedSpirit = {
            Model = "Ghost2",
            AnimationRoot = "Armature.001",
            Idle = 96923738184871,
            Walk = 128935996676112,
            Attack = 110706809339821
        },
        VengefulSpirit = {
            Model = "Ghost3",
            AnimationRoot = "Armature.002.R.R",
            Idle = 92799674822941,
            Walk = 83240968311331,
            Attack = 86700689938095
        }
    }
}

local function clean(p1) -- line: 9
    for _, descendant in p1:GetDescendants() do
        assert(not descendant:IsA("LuaSourceContainer"), "Train artwork must not contain scripts")
    end
end

function t1.Sources(p2) -- line: 12
    -- upvalues: t1 (copy), clean (copy)
    assert(p2, "ServerStorage.TrainEventAssets.HalloweenEventAssets is missing")

    local Ghosts = p2:FindFirstChild("Ghosts")

    assert(Ghosts, "HalloweenEventAssets.Ghosts missing")

    local t2 = {}

    for v2, v3 in t1.Ghosts do
        local v4 = Ghosts:FindFirstChild(v3.Model)

        assert(v4 and v4:IsA("Model") and v4.PrimaryPart and v4:FindFirstChildWhichIsA("AnimationController", true), "Invalid ghost rig: " .. v3.Model)
        clean(v4)
        t2[v2] = v4
    end

    local v6 = p2:FindFirstChild("Ghost Vacuum")

    assert(v6 and v6:IsA("Tool") and v6:FindFirstChild("Handle") and v6.Handle:IsA("BasePart"), "Ghost Vacuum needs a Tool with Handle")

    local v7 = p2:FindFirstChild("Ghost Backpack")

    assert(v7 and v7:IsA("Model") and v7:FindFirstChildWhichIsA("BasePart", true), "Ghost Backpack model missing")
    clean(v6)
    clean(v7)
    t2.GhostVacuum = v6
    t2.GhostBackpack = v7

    return t2
end

local function visibleBounds(p3, p4) -- line: 28
    local v9 = Vector3.new(1e999, 1e999, 1e999)
    local v10 = -Vector3.new(1e999, 1e999, 1e999)

    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 then
            local v11 = v9
            local v12 = v10

            for _, v13 in { -1, 1 } do
                local v14 = v11
                local v15 = v12

                for _, v16 in { -1, 1 } do
                    for _, v19 in { -1, 1 } do
                        local v20 = p4.CFrame:PointToObjectSpace(descendant.CFrame:PointToWorldSpace(descendant.Size * Vector3.new(v13, v16, v19) / 2))

                        v14 = Vector3.new(math.min(v14.X, v20.X), math.min(v14.Y, v20.Y), (math.min(v14.Z, v20.Z)))
                        v15 = Vector3.new(math.max(v15.X, v20.X), math.max(v15.Y, v20.Y), (math.max(v15.Z, v20.Z)))
                    end

                    v12 = v15
                    v11 = v14
                end

                v10 = v12
                v9 = v11
            end
        end
    end

    assert(v9.X < 1e999, "Artwork has no visible geometry")

    return (v9 + v10) / 2, v10 - v9
end

function t1.GhostTemplate(p5, p6) -- line: 40
    -- upvalues: t1 (copy), visibleBounds (copy)
    local clone = p5:Clone()

    clone.Name = p6

    local PrimaryPart = clone.PrimaryPart

    PrimaryPart.Name = t1.Ghosts[p6].AnimationRoot

    if p6 == "LostSpirit" then
        local v28 = assert(PrimaryPart:FindFirstChild("Body"), "Lost Spirit body bone missing")

        assert(v28:IsA("Bone"), "Lost Spirit body must be a Bone")

        local Bone2 = Instance.new("Bone")

        Bone2.Name = "Root"
        Bone2.Parent = PrimaryPart
        v28.Parent = Bone2
    end

    local v29, v30 = visibleBounds(clone, PrimaryPart)

    PrimaryPart.PivotOffset = CFrame.new(v29)
    clone:SetAttribute("GhostHalfHeight", v30.Y / 2)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == PrimaryPart
            descendant.Massless = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
        end
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "GhostAnimations"
    Folder.Parent = clone

    for _, v31 in { "Idle", "Walk", "Attack" } do
        local Animation = Instance.new("Animation")

        Animation.Name = v31
        Animation.AnimationId = "rbxassetid://" .. tostring(t1.Ghosts[p6][v31])
        Animation.Parent = Folder
    end

    local v33 = clone:FindFirstChildWhichIsA("AnimationController", true)

    if not v33:FindFirstChildOfClass("Animator") then
        Instance.new("Animator", v33)
    end

    clone:PivotTo(CFrame.identity)

    return clone
end

function t1.Tool(p7, p8, p9) -- line: 65
    local clone = p7:Clone()

    clone.Name = "Ghost Vacuum"
    clone.CanBeDropped = false
    clone:SetAttribute("GhostVacuum", true)
    clone:SetAttribute("TrainVacuumVisit", p9)
    clone:SetAttribute("DisplayName", "Ghost Vacuum")

    local Handle = clone.Handle
    local _CFrame = Handle.CFrame
    local t3 = {}

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t3, {
                Part = descendant,
                Frame = p8 * _CFrame:ToObjectSpace(descendant.CFrame)
            })
        end
    end

    for _, v34 in t3 do
        v34.Part.Anchored = true
    end

    for _, v35 in t3 do
        v35.Part.CFrame = v35.Frame
    end

    for _, v36 in t3 do
        v36.Part.Anchored = false
        v36.Part.Massless = true
        v36.Part.CanCollide = false
        v36.Part.CanTouch = false
        v36.Part.CanQuery = false
    end

    if not clone:FindFirstChild("Nozzle", true) then
        local n1 = (-1e999)

        for _, v37 in t3 do
            local Part = v37.Part
            local v38 = Handle.CFrame:ToObjectSpace(Part.CFrame)
            local v39 = n1

            for _, v40 in { -1, 1 } do
                local v41 = v39

                for _, v42 in { -1, 1 } do
                    for _, v44 in { -1, 1 } do
                        v41 = math.max(v41, v38:PointToWorldSpace(Part.Size * Vector3.new(v40, v42, v44) / 2).X)
                    end

                    v39 = v41
                end

                n1 = v39
            end
        end

        local Attachment = Instance.new("Attachment")

        Attachment.Name = "Nozzle"

        local v45 = Vector3.new(n1, 0.27, 0)

        Attachment.CFrame = CFrame.lookAt(v45, v45 + Vector3.new(1, 0, 0))
        Attachment.Parent = Handle
    end

    return clone
end

function t1.Display(p10, p11) -- line: 85
    local clone = p10:Clone()
    local Model = Instance.new("Model")

    Model.Name = "GhostVacuum"

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
        end
    end

    local Handle = clone.Handle

    for _, child in clone:GetChildren() do
        child.Parent = Model
    end

    clone:Destroy()
    Model.PrimaryPart = Handle
    Model:PivotTo(p11)

    return Model
end

function t1.Backpack(p12, p13, p14, p15) -- line: 93
    local v46 = p13:FindFirstChild("UpperTorso") or p13:FindFirstChild("Torso")

    if not (v46 and v46:IsA("BasePart")) then
        return nil
    end

    local clone = p12:Clone()

    clone.Name = "TrainVacuumBackpack"
    clone:SetAttribute("TrainVacuumVisit", p15)

    local v47 = clone:FindFirstChildWhichIsA("BasePart", true)

    clone.PrimaryPart = v47

    local BoundingBox, BoundingBox2 = clone:GetBoundingBox()

    v47.PivotOffset = v47.CFrame:ToObjectSpace(CFrame.new(BoundingBox.Position) * v47.CFrame.Rotation)

    local Humanoid = p13:FindFirstChildOfClass("Humanoid")
    local BodyHeightScale = Humanoid and Humanoid:FindFirstChild("BodyHeightScale")

    clone:ScaleTo(clone:GetScale() * p14 * (if not (BodyHeightScale and BodyHeightScale:IsA("NumberValue")) then 1 else BodyHeightScale.Value) / BoundingBox2.Y)

    local _, BoundingBox3 = clone:GetBoundingBox()

    clone:PivotTo(v46.CFrame * CFrame.new(0, -0.15, (v46.Size.Z + BoundingBox3.Z) / 2 + 0.12))

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false
            descendant.Massless = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false

            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = v46
            WeldConstraint.Part1 = descendant
            WeldConstraint.Parent = descendant
        end
    end

    clone.Parent = p13

    return clone
end

function t1.Ticket(p16, p17) -- line: 109
    -- upvalues: clean (copy)
    clean(p16)

    local clone = p16:Clone()
    local _, BoundingBox = clone:GetBoundingBox()

    clone:ScaleTo(clone:GetScale() * 1.8 / BoundingBox.X)

    local v48 = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true)
    local CFrame = v48.CFrame
    local Tool = Instance.new("Tool")

    Tool.CanBeDropped = false
    Tool:SetAttribute("TrainTicketArtVersion", 1)

    local t5 = {}

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t5, {
                Part = descendant,
                Frame = p17 * CFrame:ToObjectSpace(descendant.CFrame)
            })
        end
    end

    for _, v49 in t5 do
        v49.Part.Anchored = true
    end

    for _, v50 in t5 do
        v50.Part.CFrame = v50.Frame
        v50.Part.CanCollide = false
        v50.Part.CanTouch = false
        v50.Part.CanQuery = false
        v50.Part.Massless = true
        v50.Part.Parent = Tool
    end

    v48.Name = "Handle"

    for _, v51 in t5 do
        if v51.Part ~= v48 then
            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Part0 = v48
            WeldConstraint.Part1 = v51.Part
            WeldConstraint.Parent = v48
        end
    end

    for _, v52 in t5 do
        v52.Part.Anchored = false
    end

    clone:Destroy()

    return Tool
end

return t1
