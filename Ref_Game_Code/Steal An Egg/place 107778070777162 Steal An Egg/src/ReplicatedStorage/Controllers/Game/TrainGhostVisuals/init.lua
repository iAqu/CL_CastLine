-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TrainEventFlags = require(ReplicatedStorage.Shared.Flags.TrainEventFlags)
local Ghosts = require(ReplicatedStorage.Shared.Remotes).TrainEvent.Ghosts
local SuckFX = require(script.SuckFX)
local t1 = {}
local v1 = false
local v2 = false
local v3 = false
local t2 = {}
local v4
local t3 = {}

local function setGearEffects(p1, p2) -- line: 21
    -- upvalues: v4 (ref), t3 (ref)
    if p1 ~= v4 then
        for _, v5 in t3 do
            if v5.Parent then
                v5.Enabled = false
            end
        end

        v4 = p1
        t3 = {}

        if p1 then
            for _, descendant in p1:GetDescendants() do
                if (descendant:IsA("Beam") or descendant:IsA("ParticleEmitter")) and descendant:GetAttribute("TrainVacuumActiveVFX") == true then
                    table.insert(t3, descendant)
                end
            end
        end
    end

    for _, v6 in t3 do
        if v6.Parent then
            local v7 = p2 and v6:GetAttribute("TrainVacuumAuthoredEnabled") == true

            if v6.Enabled ~= v7 then
                v6.Enabled = v7
            end
        end
    end
end

function t1.SetInput(p3) -- line: 45
    -- upvalues: v2 (ref)
    v2 = p3 == true
end

function t1.SetYield(p4) -- line: 49
    -- upvalues: v3 (ref)
    v3 = p4 == true
end

function t1.Sample(p5, p6) -- line: 53
    if #p5 == 0 then
        return nil
    end

    if p6 <= p5[1].Time then
        return p5[1].Frame
    end

    for i = 2, #p5 do
        local v8 = p5[i]
        local v9 = p5[i - 1]

        if p6 <= v8.Time then
            local v10 = v8.Time - v9.Time

            return v9.Frame:Lerp(v8.Frame, if v10 > 0 then math.clamp((p6 - v9.Time) / v10, 0, 1) else 1)
        end
    end

    return p5[#p5].Frame
end

local function nozzleOf(p7) -- line: 75
    local Character = p7.Character

    if Character then
        for _, child in Character:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("GhostVacuum") then
                local v13 = child:FindFirstChild("Nozzle", true)

                if v13 and v13:IsA("Attachment") then
                    return v13
                end
            end
        end
    end

    return nil
end

local function loadTracks(p8) -- line: 90
    local v14 = p8.Model:FindFirstChildWhichIsA("AnimationController", true)
    local Animator = v14 and v14:FindFirstChildOfClass("Animator")
    local GhostAnimations = p8.Model:FindFirstChild("GhostAnimations")

    p8.Tracks = {}

    if Animator and GhostAnimations then
        for _, v15 in { "Idle", "Walk", "Attack" } do
            local v16 = GhostAnimations:FindFirstChild(v15)

            if v16 then
                local function v17() -- line: 99
                    -- upvalues: Animator (copy), v16 (copy)
                    return Animator:LoadAnimation(v16)
                end

                local ok, result = pcall(v17)

                if ok then
                    result.Looped = v15 ~= "Attack"

                    if v15 == "Attack" then
                        result.Priority = Enum.AnimationPriority.Action
                    elseif v15 == "Walk" then
                        result.Priority = Enum.AnimationPriority.Movement
                    else
                        result.Priority = Enum.AnimationPriority.Idle
                    end

                    p8.Tracks[v15] = result
                else
                    warn("[TrainGhostVisuals] " .. p8.Tier .. " " .. v15 .. ": " .. tostring(result))
                end
            end
        end
    end
end

local function stopTracks(p9) -- line: 124
    if p9.Tracks then
        for _, v18 in p9.Tracks do
            v18:Stop(0)
            v18:Destroy()
        end

        p9.Tracks = nil
    end

    if p9.FX then
        p9.FX:Destroy()
        p9.FX = nil
    end
end

local function animate(p10) -- line: 138
    -- upvalues: TrainEventFlags (copy)
    local v19 = if not p10.Moving or p10.Selected then "Idle" else "Walk"

    if v19 ~= p10.Animation then
        if p10.Animation and p10.Tracks[p10.Animation] then
            p10.Tracks[p10.Animation]:Stop(0.15)
        end

        if p10.Tracks[v19] then
            p10.Tracks[v19]:Play(0.15)
        end

        p10.Animation = v19
        p10.Model:SetAttribute("GhostAnimation", v19)
    end

    if p10.AttackSerial > (p10.PlayedAttack or 0) then
        p10.PlayedAttack = p10.AttackSerial

        if p10.Tracks.Attack then
            p10.Tracks.Attack:Play(0.08, 1, TrainEventFlags.GhostSwipeSpeed:Get())
        end
    end
end

local function suctionFX(p11) -- line: 158
    -- upvalues: SuckFX (copy)
    p11.FX = SuckFX.new(p11.Model)
end

function t1.GetAimTarget(p12) -- line: 162
    -- upvalues: t2 (copy)
    local n1 = 1e999
    local v20

    for v21, v22 in t2 do
        local Model = v22.Model

        if Model and Model.PrimaryPart then
            local v23 = Model:GetPivot().Position - p12.Origin
            local v24 = v23:Dot(p12.Direction.Unit)
            local v26 = math.clamp(Model:GetExtentsSize().Magnitude * 0.35, 2, 7)

            if v24 > 0 and v24 < n1 and (v23 - p12.Direction.Unit * v24).Magnitude <= v26 then
                n1 = v24
                v20 = v21
            end
        end
    end

    return v20
end

function t1.Start() -- line: 185
    -- upvalues: Players (copy), ReplicatedStorage (copy), Workspace (copy), RunService (copy), TrainEventFlags (copy), Ghosts (copy), SuckFX (copy), t1 (copy), v1 (ref), v2 (ref), v3 (ref), t2 (copy), setGearEffects (copy), nozzleOf (copy), loadTracks (copy), stopTracks (copy), animate (copy)
    if v1 then
        return
    end

    v1 = true

    local LocalPlayer = Players.LocalPlayer
    local Folder = Instance.new("Folder")

    Folder.Name = "TrainGhostVisuals"
    Folder.Parent = Workspace

    local t5 = {}

    local function fade(p13) -- line: 195
        -- upvalues: t5 (copy), TrainEventFlags (copy), stopTracks (copy)
        stopTracks(p13)

        if p13.Model then
            local t6 = {}

            for _, descendant in p13.Model:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    t6[descendant] = descendant.Transparency
                end
            end

            table.insert(t5, {
                Fade = true,
                Model = p13.Model,
                From = p13.Model:GetPivot(),
                Born = os.clock(),
                Parts = t6,
                Duration = TrainEventFlags.GhostFadeSeconds:Get()
            })
        end
    end

    local VisitId = nil
    local n2 = 0
    local t8 = {}

    local function clear() -- line: 219
        -- upvalues: t5 (copy), t2 (copy), stopTracks (copy)
        for v27, v28 in t2 do
            stopTracks(v28)

            if v28.Model then
                v28.Model:Destroy()
            end

            t2[v27] = nil
        end

        for i = #t5, 1, -1 do
            t5[i].Model:Destroy()
            table.remove(t5, i)
        end
    end

    local function receive(p14) -- line: 232
        -- upvalues: LocalPlayer (copy), t5 (copy), fade (copy), VisitId (ref), n2 (ref), t8 (copy), clear (copy), SuckFX (copy), t2 (copy), nozzleOf (copy), stopTracks (copy)
        if typeof(p14) ~= "table" then
            return
        end

        if typeof(p14.VisitId) == "string" and typeof(p14.Sequence) == "number" and typeof(p14.Time) == "number" and typeof(p14.Ghosts) == "table" and not t8[p14.VisitId] then
            if VisitId ~= p14.VisitId then
                clear()
                VisitId = p14.VisitId
                n2 = 0
            end

            if not (p14.Sequence <= n2) then
                n2 = p14.Sequence

                if p14.Closed then
                    t8[VisitId] = true

                    for v29, v30 in t2 do
                        fade(v30)
                        t2[v29] = nil
                    end
                else
                    local t9 = {}

                    for _, v31 in p14.Ghosts do
                        if typeof(v31.Id) == "string" and typeof(v31.Frame) == "CFrame" and ({
                            LostSpirit = true,
                            HauntedSpirit = true,
                            VengefulSpirit = true
                        })[v31.Tier] then
                            t9[v31.Id] = true

                            local v32 = t2[v31.Id]

                            if not v32 then
                                v32 = {
                                    DisplayProgress = 0,
                                    Tier = v31.Tier,
                                    Samples = {}
                                }
                                t2[v31.Id] = v32
                            end

                            v32.Progress = math.clamp(v31.Progress or 0, 0, 1)
                            v32.Selected = v31.Selected == true
                            v32.Moving = v31.Moving == true
                            v32.AttackSerial = v31.AttackSerial or 0
                            table.insert(v32.Samples, {
                                Time = p14.Time,
                                Frame = v31.Frame
                            })

                            while #v32.Samples > 6 do
                                table.remove(v32.Samples, 1)
                            end
                        end
                    end

                    for v34, v35 in t2 do
                        if not t9[v34] then
                            if v35.Model then
                                if v34 == p14.CapturedId then
                                    stopTracks(v35)
                                    SuckFX.Captured(v35.Model, (nozzleOf(LocalPlayer)))
                                    table.insert(t5, {
                                        Model = v35.Model,
                                        From = v35.Model:GetPivot(),
                                        Scale = v35.Model:GetScale(),
                                        Born = os.clock()
                                    })
                                else
                                    fade(v35)
                                end
                            end

                            t2[v34] = nil
                        end
                    end
                end
            end
        end
    end

    Ghosts.OnClientEvent:Connect(receive)
    RunService.RenderStepped:Connect(function(p15) -- line: 307
        -- upvalues: LocalPlayer (copy), Folder (copy), t5 (copy), ReplicatedStorage (copy), Workspace (copy), TrainEventFlags (copy), SuckFX (copy), t1 (copy), v2 (ref), v3 (ref), t2 (copy), setGearEffects (copy), nozzleOf (copy), loadTracks (copy), animate (copy)
        local v36 = nozzleOf(LocalPlayer)
        local v37 = v36 and v36:FindFirstAncestorOfClass("Tool")

        setGearEffects(v37, v2 and not v3 and v37 ~= nil)
        SuckFX.Step(p15)

        for i = #t5, 1, -1 do
            local v39 = t5[i]
            local v41 = math.clamp((os.clock() - v39.Born) / (v39.Duration or 0.45), 0, 1)

            if v39.Fade then
                for v42, v43 in v39.Parts do
                    v42.Transparency = v43 + (1 - v43) * v41
                end

                v39.Model:PivotTo(v39.From + Vector3.new(0, v41 * 1.5, 0))

                if v41 >= 1 then
                    v39.Model:Destroy()
                    table.remove(t5, i)
                end
            elseif not (v41 >= 1) and v36 and v36:IsA("Attachment") then
                local v45 = v41 * v41

                v39.Model:ScaleTo(v39.Scale * (1 - v45 * 0.9))
                v39.Model:PivotTo(CFrame.new(v39.From.Position:Lerp(v36.WorldPosition, v45)) * v39.From.Rotation * CFrame.Angles(0, SuckFX.CaptureSpin(v41), 0))
            else
                if v41 >= 1 and v36 then
                    SuckFX.Burst(v36, true)
                end

                v39.Model:Destroy()
                table.remove(t5, i)
            end
        end

        local TrainGhostTemplates = ReplicatedStorage:FindFirstChild("TrainGhostTemplates")
        local v46 = Workspace:GetServerTimeNow() - TrainEventFlags.GhostInterpolationSeconds:Get()

        for v47, v48 in t2 do
            if not v48.Model and TrainGhostTemplates then
                local v49 = TrainGhostTemplates:FindFirstChild(v48.Tier)

                if v49 and v49:IsA("Model") and v49.PrimaryPart then
                    local clone = v49:Clone()

                    clone.Name = v47
                    clone:SetAttribute("TrainGhost", true)
                    clone:SetAttribute("OwnerUserId", LocalPlayer.UserId)

                    for _, descendant in clone:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            descendant.Anchored = descendant == clone.PrimaryPart
                            descendant.Massless = true
                            descendant.CanCollide = false
                            descendant.CanTouch = false
                            descendant.CanQuery = false
                        end
                    end

                    clone:PivotTo(v48.Samples[#v48.Samples].Frame)
                    clone.Parent = Folder
                    v48.Model = clone
                    v48.Scale = clone:GetScale()
                    loadTracks(v48)
                    v48.FX = SuckFX.new(v48.Model)
                end
            end

            local v50 = t1.Sample(v48.Samples, v46)

            if v48.Model and v50 then
                local Selected = v48.Selected and v2 and not v3
                local v51 = if Selected then v48.Progress else 0

                v48.DisplayProgress = v48.DisplayProgress + (v51 - v48.DisplayProgress) * (1 - math.exp(-10 * p15))

                local DisplayProgress2 = v48.DisplayProgress

                v48.Model:ScaleTo(v48.Scale * v48.FX:Scale(DisplayProgress2))

                local v54 = Selected and v36 ~= nil
                local v55 = v48.FX:Pose(v50, if v54 then v36 else nil, DisplayProgress2, p15)

                v48.Pose = if v48.Pose then v48.Pose:Lerp(v55, 1 - math.exp(-24 * p15)) else v55
                v48.Model:PivotTo(v48.Pose)
                animate(v48)
                v48.Model:SetAttribute("ServerCaptureProgress", v48.Progress)
                v48.FX:Update(if v54 then v36 else nil, DisplayProgress2, p15)
            end
        end
    end)
end

return t1
