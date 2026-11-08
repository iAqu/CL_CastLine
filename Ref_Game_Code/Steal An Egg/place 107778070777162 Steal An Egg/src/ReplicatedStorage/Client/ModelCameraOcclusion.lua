-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Enum.RenderPriority.Camera.Value + 3
local t1 = {
    sweep = nil,
    sweeping = false,
    blocked = {},
    faceOwner = {},
    probeFrom = {},
    probeSkip = {},
    roster = {},
    shelved = {}
}
local v2 = Log.new()
local LocalPlayer = Players.LocalPlayer
local v3 = t.strict(t.instanceIsA("Model"))
local v4 = t.strict(t.number)
local v5 = t.strict(t.boolean)
local t2 = {}

local function repaint(p1, p2) -- line: 58
    -- upvalues: t1 (copy)
    local shelved = t1.shelved

    if p2 ~= nil then
        if p1.Transparency < 1 then
            local Transparency = p1.Transparency
            local v7 = shelved[p1]

            if v7 == nil and Transparency < p2 then
                shelved[p1] = Transparency
            else
                Transparency = v7
            end

            if Transparency ~= nil then
                p1.Transparency = math.max(Transparency, p2)
            end
        end
    else
        local v6 = shelved[p1]

        if v6 ~= nil then
            shelved[p1] = nil

            if p1.Parent then
                p1.Transparency = v6
            end
        end
    end
end

local function repaintEntry(p3, p4) -- line: 83
    -- upvalues: t1 (copy)
    p3.Faded = p4

    local Target = if p4 then p3.Target else nil

    for v8 in p3.Faces do
        local shelved = t1.shelved

        if Target ~= nil then
            if v8.Transparency < 1 then
                local Transparency = v8.Transparency
                local v10 = shelved[v8]

                if v10 == nil and Transparency < Target then
                    shelved[v8] = Transparency
                else
                    Transparency = v10
                end

                if Transparency ~= nil then
                    v8.Transparency = math.max(Transparency, Target)
                end
            end
        else
            local v9 = shelved[v8]

            if v9 ~= nil then
                shelved[v8] = nil

                if v8.Parent then
                    v8.Transparency = v9
                end
            end
        end
    end
end

local function releaseEverything() -- line: 92
    -- upvalues: t1 (copy)
    for _, v11 in t1.roster do
        v11.UnfadeAt = 0
        v11.Faded = false

        for v12 in v11.Faces do
            local shelved = t1.shelved
            local v13 = shelved[v12]

            if v13 ~= nil then
                shelved[v12] = nil

                if v12.Parent then
                    v12.Transparency = v13
                end
            end
        end
    end

    table.clear(t1.blocked)
end

local function demand(p5) -- line: 101
    -- upvalues: t1 (copy)
    return assert(t1.roster[p5], (("%* is not registered for occlusion"):format(p5.Name)))
end

local function isUnderfoot(p6, p7, p8) -- line: 107
    local v16 = p6:GetScale() / p7.RegisteredScale
    local Bounds = p7.Bounds
    local v17 = p7.Pivot.CFrame * (CFrame.new(Bounds.Position * v16) * Bounds.Rotation)
    local v18 = v17:PointToObjectSpace(p8)
    local v19 = p7.Extents * v16 * 0.5
    local v25 = v17:PointToWorldSpace((Vector3.new(math.clamp(v18.X, -v19.X, v19.X), -v19.Y, (math.clamp(v18.Z, -v19.Z, v19.Z))))) - p8

    return v25.X * v25.X + v25.Z * v25.Z <= 625
end

local function advance(p9, p10, p11) -- line: 121
    -- upvalues: t1 (copy), repaintEntry (copy)
    if p10 then
        p9.UnfadeAt = 0

        return repaintEntry(p9, true)
    end

    if not p9.Faded then
        p9.UnfadeAt = 0

        return
    end

    if p9.UnfadeAt == 0 then
        p9.UnfadeAt = p11 + 1
    elseif p9.UnfadeAt <= p11 then
        p9.UnfadeAt = 0
        p9.Faded = false

        for v26 in p9.Faces do
            local shelved = t1.shelved
            local v27 = shelved[v26]

            if v27 ~= nil then
                shelved[v26] = nil

                if v26.Parent then
                    v26.Transparency = v27
                end
            end
        end
    end
end

local function onFrame() -- line: 137
    -- upvalues: Workspace (copy), Player (copy), t1 (copy), LocalPlayer (copy), releaseEverything (copy), isUnderfoot (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v28 = Player.FindCharacter(LocalPlayer)
    local v29 = Player.FindHead(LocalPlayer)
    local v30 = Player.FindRootPart(LocalPlayer)

    if not (t1.sweeping and CurrentCamera and v28 and v29 and v30) then
        return releaseEverything()
    end

    local blocked, faceOwner = t1.blocked, t1.faceOwner

    t1.probeFrom[1] = v29.Position
    t1.probeSkip[1] = v28
    table.clear(blocked)

    for _, v31 in CurrentCamera:GetPartsObscuringTarget(t1.probeFrom, t1.probeSkip) do
        local v32 = faceOwner[v31]

        if v32 then
            blocked[v32] = true
        end
    end

    local Position = v30.Position
    local ServerTimeNow = Workspace:GetServerTimeNow()

    for v33, v34 in t1.roster do
        if not v34.Muted then
            if blocked[v33] == true or isUnderfoot(v33, v34, Position) then
                v34.UnfadeAt = 0
                v34.Faded = true

                local Target = v34.Target

                for v35 in v34.Faces do
                    local shelved = t1.shelved

                    if Target ~= nil then
                        if v35.Transparency < 1 then
                            local Transparency = v35.Transparency
                            local v37 = shelved[v35]

                            if v37 == nil and Transparency < Target then
                                shelved[v35] = Transparency
                            else
                                Transparency = v37
                            end

                            if Transparency ~= nil then
                                v35.Transparency = math.max(Transparency, Target)
                            end
                        end
                    else
                        local v36 = shelved[v35]

                        if v36 ~= nil then
                            shelved[v35] = nil

                            if v35.Parent then
                                v35.Transparency = v36
                            end
                        end
                    end
                end
            elseif v34.Faded then
                if v34.UnfadeAt == 0 then
                    v34.UnfadeAt = ServerTimeNow + 1
                elseif v34.UnfadeAt <= ServerTimeNow then
                    v34.UnfadeAt = 0
                    v34.Faded = false

                    for v38 in v34.Faces do
                        local shelved = t1.shelved
                        local v39 = shelved[v38]

                        if v39 ~= nil then
                            shelved[v38] = nil

                            if v38.Parent then
                                v38.Transparency = v39
                            end
                        end
                    end
                end
            else
                v34.UnfadeAt = 0
            end
        end
    end
end

function t2.Register(p12, p13) -- line: 165
    -- upvalues: ModelBounds (copy), Trove (copy), t1 (copy), v3 (copy), v4 (copy)
    v3(p12)
    v4(p13)
    assert(p13 >= 0 and p13 <= 1, "an occlusion fade target has to land between 0 and 1")
    assert(t1.roster[p12] == nil, (("%* is being registered for occlusion twice"):format(p12.Name)))

    local v44 = assert(p12.PrimaryPart, (("%* has no PrimaryPart to measure against"):format(p12.Name)))
    local Scale = p12:GetScale()

    assert(Scale > 0, (("%* reports a scale of %*, which cannot be normalised"):format(p12.Name, Scale)))

    local v47, v48 = ModelBounds(p12)
    local t3 = {
        Faded = false,
        Muted = false,
        UnfadeAt = 0,
        Bounds = v44.CFrame:ToObjectSpace(v47),
        Extents = v48,
        Faces = {},
        Lifetime = Trove.new(),
        Pivot = v44,
        RegisteredScale = Scale,
        Target = p13
    }

    t1.roster[p12] = t3

    local function adopt(p14) -- line: 193
        -- upvalues: p12 (copy), t3 (copy), t1 (copy)
        if not p14:IsA("BasePart") then
            return
        end

        assert(t1.faceOwner[p14] == nil, (("%* is claimed by two occlusion models"):format((p14:GetFullName()))))
        t3.Faces[p14] = true
        t1.faceOwner[p14] = p12

        if t3.Faded then
            local Target = t3.Target
            local shelved = t1.shelved

            if Target ~= nil then
                if p14.Transparency < 1 then
                    local Transparency = p14.Transparency
                    local v52 = shelved[p14]

                    if v52 == nil and Transparency < Target then
                        shelved[p14] = Transparency
                    else
                        Transparency = v52
                    end

                    if Transparency ~= nil then
                        p14.Transparency = math.max(Transparency, Target)
                    end
                end
            else
                local v51 = shelved[p14]

                if v51 ~= nil then
                    shelved[p14] = nil

                    if p14.Parent then
                        p14.Transparency = v51
                    end
                end
            end
        end
    end

    local function drop(p15) -- line: 207
        -- upvalues: t3 (copy), t1 (copy)
        if not (p15:IsA("BasePart") and t3.Faces[p15]) then
            return
        end

        local shelved = t1.shelved
        local v53 = shelved[p15]

        if v53 ~= nil then
            shelved[p15] = nil

            if p15.Parent then
                p15.Transparency = v53
            end
        end

        t3.Faces[p15] = nil
        t1.faceOwner[p15] = nil
    end

    for _, descendant in p12:GetDescendants() do
        adopt(descendant)
    end

    t3.Lifetime:Connect(p12.DescendantAdded, adopt)
    t3.Lifetime:Connect(p12.DescendantRemoving, drop)
end

function t2.Forget(p16) -- line: 223
    -- upvalues: t1 (copy), v3 (copy)
    v3(p16)

    local v56 = assert(t1.roster[p16], (("%* is not registered for occlusion"):format(p16.Name)))

    v56.UnfadeAt = 0
    v56.Faded = false

    for v57 in v56.Faces do
        local shelved = t1.shelved
        local v58 = shelved[v57]

        if v58 ~= nil then
            shelved[v57] = nil

            if v57.Parent then
                v57.Transparency = v58
            end
        end
    end

    for v59 in v56.Faces do
        t1.faceOwner[v59] = nil
    end

    v56.Lifetime:Destroy()
    table.clear(v56.Faces)
    t1.roster[p16] = nil
    t1.blocked[p16] = nil
end

function t2.SetIgnored(p17, p18) -- line: 240
    -- upvalues: t1 (copy), v3 (copy), v5 (copy)
    v3(p17)
    v5(p18)

    local v62 = assert(t1.roster[p17], (("%* is not registered for occlusion"):format(p17.Name)))

    if v62.Muted ~= p18 then
        v62.Muted = p18

        if p18 then
            v62.UnfadeAt = 0
            v62.Faded = false

            for v63 in v62.Faces do
                local shelved = t1.shelved
                local v64 = shelved[v63]

                if v64 ~= nil then
                    shelved[v63] = nil

                    if v63.Parent then
                        v63.Transparency = v64
                    end
                end
            end

            t1.blocked[p17] = nil
        end
    end
end

local function standDown() -- line: 255
    -- upvalues: RunService (copy), t1 (copy), v2 (copy), releaseEverything (copy)
    local sweeping = t1.sweeping

    t1.sweeping = false

    local sweep = t1.sweep

    t1.sweep = nil

    if sweep then
        task.defer(RunService.UnbindFromRenderStep, RunService, sweep)
    end

    releaseEverything()

    if sweeping then
        v2:AtDebug():Log("Occlusion sweep released the camera")
    end
end

function t2.SetEnabled(p19) -- line: 271
    -- upvalues: HttpService (copy), RunService (copy), v1 (copy), t1 (copy), v2 (copy), v5 (copy), releaseEverything (copy), onFrame (copy)
    v5(p19)

    if not p19 or t1.sweeping then
        if p19 then
            return
        end

        local sweeping = t1.sweeping

        t1.sweeping = false

        local sweep = t1.sweep

        t1.sweep = nil

        if sweep then
            task.defer(RunService.UnbindFromRenderStep, RunService, sweep)
        end

        releaseEverything()

        if sweeping then
            v2:AtDebug():Log("Occlusion sweep released the camera")
        end
    else
        local v65 = t1.sweep == nil

        assert(v65, "an occlusion sweep is bound while the system reads as idle")
        t1.sweeping = true

        local v67 = ("ModelCameraOcclusion.%*"):format((HttpService:GenerateGUID(false)))

        RunService:BindToRenderStep(v67, v1, onFrame)
        t1.sweep = v67
        v2:AtDebug():Log("Occlusion sweep took the camera")
    end
end

return t2
