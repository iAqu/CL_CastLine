-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    stockName = "TutorialBeam",
    anchorPin = "TutorialBeamTargetAttachment",
    followerPin = "TutorialBeamPlayerAttachment",
    rootPart = "HumanoidRootPart",
    rootPartTimeout = 5,
    drifterProperties = {
        Anchored = true,
        CanCollide = false,
        Name = "TutorialBeamContainer",
        Size = Vector3.new(1, 1, 1),
        Transparency = 1
    },
    beamProperties = {
        Enabled = false,
        FaceCamera = true
    }
}
local t2 = {}
local LocalPlayer = Players.LocalPlayer
local TutorialBeam = ReplicatedStorage.Assets.Extra.TutorialBeam

local function dress(p1, p2) -- line: 51
    for v1, v2 in p2 do
        p1[v1] = v2
    end

    return p1
end

local function demandAnchor(p3, p4) -- line: 58
    assert(typeof(p3) == "Vector3" or typeof(p3) == "Instance" and p3:IsA("BasePart"), (("%* needs a BasePart or a Vector3"):format(p4)))
end

local function pinTo(p5, p6) -- line: 64
    -- upvalues: t1 (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = t1.anchorPin

    if typeof(p5) == "Vector3" then
        local Part = Instance.new("Part")

        for v5, v6 in t1.drifterProperties do
            Part[v5] = v6
        end

        Part.Position = p5
        Part.Parent = workspace
        p6:Add(Part)
        Attachment.Parent = Part

        return Attachment, Part
    end

    Attachment.Parent = p5

    return Attachment, nil
end

local function rideCharacter(p7) -- line: 82
    -- upvalues: t1 (copy)
    local Character = p7.owner.Character
    local v7 = if Character then Character:WaitForChild(t1.rootPart, t1.rootPartTimeout) else nil
    local pins, v8

    if v7 ~= nil then
        if v7:IsA("BasePart") then
            pins = p7.pins

            if pins.follower then
                p7.scope:Remove(pins.follower)
            end

            v8 = false
        else
            v8 = true
        end
    else
        v8 = true
    end

    if v8 then
        p7.beam.Enabled = false

        return
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = t1.followerPin
    Attachment.Parent = v7
    pins.follower = p7.scope:Add(Attachment)
    p7.beam.Attachment0 = Attachment
    p7.beam.Enabled = true
end

function t2.Retarget(p8, p9) -- line: 105
    -- upvalues: t (copy), pinTo (copy)
    t.strict(t.table)(p8)
    assert(typeof(p9) == "Vector3" or typeof(p9) == "Instance" and p9:IsA("BasePart"), "beam retarget needs a BasePart or a Vector3")

    local pins = p8.pins

    if typeof(p9) == "Vector3" and pins.drifter ~= nil then
        pins.drifter.Position = p9

        return
    end

    if p9 ~= pins.anchor.Parent then
        p8.scope:Remove(pins.anchor)

        if pins.drifter ~= nil then
            p8.scope:Remove(pins.drifter)
        end

        local v10, v11 = pinTo(p9, p8.scope)

        pins.anchor = v10
        pins.drifter = v11
        p8.scope:Add(pins.anchor)
        p8.beam.Attachment1 = pins.anchor
    end
end

function t2.Destroy(p10) -- line: 128
    -- upvalues: t (copy)
    t.strict(t.table)(p10)
    p10.scope:Destroy()
end

function t2.Attach(p11, p12) -- line: 133
    -- upvalues: Trove (copy), t1 (copy), LocalPlayer (copy), TutorialBeam (copy), pinTo (copy), rideCharacter (copy)
    assert(typeof(p11) == "Vector3" or typeof(p11) == "Instance" and p11:IsA("BasePart"), "beam anchor needs a BasePart or a Vector3")

    local v13 = Trove.new()
    local v14, v15 = pinTo(p11, v13)

    v13:Add(v14)

    local clone = (if not (p12 and p12.Template) then TutorialBeam else p12.Template):Clone()

    for v16, v17 in t1.beamProperties do
        clone[v16] = v17
    end

    if not (p12 and p12.BeamName) then
        clone.Name = t1.stockName
    else
        clone.Name = p12.BeamName
    end

    clone.Attachment1 = v14
    clone.Parent = workspace
    v13:Add(clone)

    local t3 = {
        scope = v13,
        beam = clone,
        owner = LocalPlayer,
        pins = {
            follower = nil,
            anchor = v14,
            drifter = v15
        }
    }

    rideCharacter(t3)

    local function remountOn(p13) -- line: 155
        -- upvalues: t3 (copy), t1 (copy), rideCharacter (copy)
        if p13:WaitForChild(t1.rootPart, t1.rootPartTimeout) then
            rideCharacter(t3)
        end
    end

    v13:Connect(LocalPlayer.CharacterAdded, function(p14) -- line: 161
        -- upvalues: remountOn (copy)
        task.spawn(remountOn, p14)
    end)

    return t3
end

return t2
