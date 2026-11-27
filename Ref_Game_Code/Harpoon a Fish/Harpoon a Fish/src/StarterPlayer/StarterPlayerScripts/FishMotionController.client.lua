-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishMotionConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishMotionConfig"))
local NightcrawlDodge = require(ReplicatedStorage.Modules:WaitForChild("NightcrawlDodge"))
local MutationLook = require(ReplicatedStorage.Modules:WaitForChild("MutationLook"))
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local FishMotion = Remotes:WaitForChild("FishMotion")
local FishFocus = Remotes:WaitForChild("FishFocus")
local Fish = workspace:WaitForChild("Fish")
local t1 = {}
local t2 = {}

FishMotionConfig.entries = t1
FishMotionConfig.lastPacket = os.clock()

local v1 = nil
local n1 = 0
local v2, v3 = FishMotionConfig.FIGHT_DELAY, FishMotionConfig.DELAY
local v4 = nil
local elapsed, elapsed2
local t3 = {}

local function measure(p1) -- line: 65
    -- upvalues: FishMotionConfig (copy), v1 (ref), n1 (ref), v2 (ref), v3 (ref), v4 (ref), elapsed (ref), elapsed2 (ref), t3 (copy)
    local v5 = workspace:GetServerTimeNow() - p1

    if not v1 then
        v1 = v5
    end

    local v6 = n1

    n1 = v6 + (math.abs(v5 - v1) - n1) * 0.05

    local v8 = v1

    v1 = v8 + (v5 - v1) * 0.05

    local v10 = math.max(v1, 0)

    v3 = v10 + math.clamp(FishMotionConfig.DELAY + FishMotionConfig.JITTER_K * n1, FishMotionConfig.DELAY, FishMotionConfig.BASE_MAX_DELAY)
    FishMotionConfig.clientAge = v10
    v2 = v10 + math.clamp(FishMotionConfig.FIGHT_DELAY + FishMotionConfig.JITTER_K * n1, FishMotionConfig.FIGHT_DELAY, FishMotionConfig.FIGHT_MAX_DELAY)

    local elapsed3 = os.clock()

    if elapsed2 and elapsed3 - elapsed2 < FishMotionConfig.GAP_MIN and elapsed and elapsed3 - elapsed >= FishMotionConfig.GAP_MIN then
        t3[#t3 + 1] = {
            at = elapsed3,
            gap = elapsed3 - elapsed
        }
    end

    elapsed = elapsed3

    local v13 = v4

    if not v13 or v4 < p1 then
        v4 = p1
    end
end

local function addSample(p2, p3, p4, p5) -- line: 85
    local v14 = #p2

    if v14 > 0 and p2[v14].jump ~= p5 then
        v14 = 0
        table.clear(p2)
    end

    if v14 == 0 or p2[v14].t < p3 then
        p2[v14 + 1] = {
            t = p3,
            cf = p4,
            jump = p5
        }
    else
        for i = v14, 1, -1 do
            if p2[i].t == p3 then
                return
            end

            if p2[i].t < p3 then
                local t4 = {
                    t = p3,
                    cf = p4,
                    jump = p5
                }

                table.insert(p2, i + 1, t4)

                return
            end
        end

        table.insert(p2, 1, {
            t = p3,
            cf = p4,
            jump = p5
        })
    end
end

local v15 = RunService:IsStudio()

FishMotion.OnClientEvent:Connect(function(p6) -- line: 109
    -- upvalues: FishMotionConfig (copy), t1 (copy), t2 (copy), measure (copy), addSample (copy), v15 (copy)
    if v15 and workspace:GetAttribute("TestFishStall") or typeof(p6) ~= "buffer" then
        return
    end

    FishMotionConfig.recvBytes += buffer.len(p6)
    FishMotionConfig.lastPacket = os.clock()

    local v16 = FishMotionConfig.time(p6)

    measure(v16)

    for i = 1, FishMotionConfig.count(p6) do
        local v17, v18, v19 = FishMotionConfig.read(p6, i)
        local v20 = t1[v17]

        if v20 then
            addSample(v20.samples, v16, v18, v19)
        else
            local v21 = t2[v17]

            if not v21 then
                v21 = {
                    samples = {},
                    at = os.clock()
                }
                t2[v17] = v21
            end

            addSample(v21.samples, v16, v18, v19)
        end
    end
end)

local t6 = {
    "FadeIn",
    "FadeOut",
    "GoneAt",
    "Hooked",
    "HookedBy",
    "Spears",
    "Mutation"
}

local function register(p7) -- line: 135
    -- upvalues: MutationLook (copy), t1 (copy), t2 (copy), t6 (copy)
    local NetId = p7:GetAttribute("NetId")
    local v22 = p7.PrimaryPart or p7:FindFirstChildWhichIsA("BasePart")

    if type(NetId) ~= "number" or not v22 then
        return
    end

    local v23 = t2[NetId]

    t2[NetId] = nil

    local t7 = {
        drawn = nil,
        corr = nil,
        alpha = nil,
        model = p7,
        mesh = v22,
        samples = v23 and v23.samples or {},
        attrs = {},
        at = os.clock(),
        phase = math.random(0, 2)
    }

    for _, v24 in ipairs(t6) do
        t7.attrs[v24] = p7:GetAttribute(v24)
    end

    t7.base = MutationLook.Alpha(t7.attrs.Mutation)
    p7.AttributeChanged:Connect(function(p8) -- line: 145
        -- upvalues: p7 (copy), t7 (copy), MutationLook (copy), t6 (copy)
        if table.find(t6, p8) then
            t7.attrs[p8] = p7:GetAttribute(p8)
        end

        if p8 == "Mutation" then
            t7.base = MutationLook.Alpha(t7.attrs.Mutation)
        end
    end)
    t1[NetId] = t7
    v22.Transparency = 1
end

Fish.ChildAdded:Connect(register)

for _, child in ipairs(Fish:GetChildren()) do
    register(child)
end

Fish.ChildRemoved:Connect(function(p9) -- line: 154
    -- upvalues: t1 (copy)
    local NetId = p9:GetAttribute("NetId")

    if NetId and t1[NetId] and t1[NetId].model == p9 then
        t1[NetId] = nil
    end
end)

local Name
local n2 = 0

local function myPlotName() -- line: 161
    -- upvalues: LocalPlayer (copy), Name (ref), n2 (ref)
    if not (os.clock() - n2 > 1) then
        return Name
    end

    n2 = os.clock()
    Name = nil

    local Plots = workspace:FindFirstChild("Plots")

    for _, v25 in ipairs(Plots and Plots:GetChildren() or {}) do
        local Harpoon = v25:FindFirstChild("Harpoon")

        if Harpoon and Harpoon:GetAttribute("OccupantUserId") == LocalPlayer.UserId then
            Name = v25.Name
        end
    end

    return Name
end

local function fighting(p10) -- line: 173
    -- upvalues: LocalPlayer (copy), myPlotName (copy)
    if not p10.Hooked then
        return false
    end

    if p10.HookedBy == LocalPlayer.UserId then
        return true
    end

    local Spears = p10.Spears
    local v26 = myPlotName()

    if type(Spears) ~= "string" or v26 == nil then
        return false
    end

    return table.find(Spears:split(","), v26) ~= nil
end

local function poseAt(p11, p12) -- line: 182
    -- upvalues: FishMotionConfig (copy)
    local v27 = #p11
    local v28 = p11[v27]

    if v28.t <= p12 then
        local v29 = p11[v27 - 1]

        if not v29 then
            return v28.cf, (Vector3.new(0, 0, 0))
        end

        local v32 = (v28.cf.Position - v29.cf.Position) / math.max(v28.t - v29.t, 0.001)
        local v34 = math.min(p12 - v28.t, FishMotionConfig.MAX_EXTRAP)
        local v35 = v28.cf + v32 * v34

        if not (p12 - v28.t < FishMotionConfig.MAX_EXTRAP) or not v32 then
            v32 = Vector3.new(0, 0, 0)
        end

        return v35, v32
    end

    if p12 <= p11[1].t then
        return p11[1].cf, (Vector3.new(0, 0, 0))
    end

    local n3 = 1

    while v27 - n3 > 1 do
        local v36 = (n3 + v27) // 2

        if p11[v36].t <= p12 then
            n3 = v36
        else
            v27 = v36
        end
    end

    local v37 = p11[n3]
    local v38 = p11[v27]
    local v40 = math.max(v38.t - v37.t, 0.001)

    return v37.cf:Lerp(v38.cf, (p12 - v37.t) / v40), (v38.cf.Position - v37.cf.Position) / v40
end

local function hideAmount(p13, p14) -- line: 204
    -- upvalues: FishMotionConfig (copy)
    local FadeIn, FadeOut, GoneAt = p13.FadeIn, p13.FadeOut, p13.GoneAt
    local v41 = if type(FadeIn) == "number" then 1 - math.clamp((p14 - FadeIn) / FishMotionConfig.FADE, 0, 1) else 0

    if type(FadeOut) == "number" then
        v41 = math.max(v41, (math.clamp((p14 - FadeOut) / FishMotionConfig.FADE, 0, 1)))
    end

    if type(GoneAt) == "number" and GoneAt <= p14 then
        v41 = 1
    end

    return v41
end

local function drawPose(p15, p16, p17, p18, p19, p20) -- line: 217
    -- upvalues: v2 (ref), poseAt (copy)
    local v45 = p16[#p16]
    local v46 = p19 and p17 - v2 or p18
    local v47, v48 = poseAt(p16, v46)

    if v45.jump == p15.jump and p15.drawn then
        local corr = p15.corr

        if ((corr and v47 * corr or v47).Position - p15.drawn.Position).Magnitude > v48.Magnitude * p20 * 2 + 0.25 then
            corr = v47:Inverse() * p15.drawn
        end

        if corr then
            corr = CFrame.identity:Lerp(corr, (math.exp(-12 * p20)))

            if corr.Position.Magnitude < 0.01 and corr.LookVector:Dot((Vector3.new(0, 0, -1))) > 0.99999 then
                corr = nil
            end
        end

        p15.corr = corr

        local v50 = if corr then v47 * corr else nil

        if corr and v50 then
            v47 = v50
        end

        return v47, v48, v46
    end

    p15.jump = v45.jump
    p15.corr = nil

    return v47, v48, v46
end

local t8 = {}
local t9 = {}
local v51 = nil
local n4 = 0
local t10 = {
    tanV = 1,
    tanH = 1,
    cf = CFrame.identity
}

local function offView(p21) -- line: 250
    -- upvalues: t10 (copy)
    local v52 = t10.cf:PointToObjectSpace(p21.drawn.Position)

    p21.pad = p21.pad or p21.mesh.Size.Magnitude * 2

    local pad = p21.pad
    local v53 = -v52.Z
    local v54 = false

    if -pad < v53 and math.abs(v52.X) <= v53 * t10.tanH + pad then
        v54 = math.abs(v52.Y) <= v53 * t10.tanV + pad
    end

    return not v54
end

RunService:BindToRenderStep("FishMotion", Enum.RenderPriority.First.Value, function(p22) -- line: 256
    -- upvalues: FishMotionConfig (copy), NightcrawlDodge (copy), t1 (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), elapsed (ref), elapsed2 (ref), t3 (copy), fighting (copy), hideAmount (copy), drawPose (copy), t8 (copy), t9 (copy), v51 (ref), n4 (ref), t10 (copy), offView (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()
    local elapsed3 = os.clock()
    local v55 = #t3
    local n5 = 0

    for i = v55, 1, -1 do
        if elapsed3 - t3[i].at > FishMotionConfig.GAP_MEMORY then
            table.remove(t3, i)
        else
            n5 = math.max(n5, t3[i].gap)
        end
    end

    local v57 = math.min(v3 + n5, FishMotionConfig.MAX_DELAY)

    if v51 and (not elapsed2 or not (elapsed3 - elapsed2 >= FishMotionConfig.GAP_MIN)) then
        v51 += p22 * (math.clamp((ServerTimeNow - v51 - v57) * 0.5, -FishMotionConfig.CATCHUP, FishMotionConfig.CATCHUP) + 1)
    else
        v51 = ServerTimeNow - v57
        elapsed = nil
    end

    elapsed2 = elapsed3

    local v62 = v4

    v62 = v62 and v51 > v4 + FishMotionConfig.MAX_EXTRAP

    if not v62 then
        FishMotionConfig.holdSince = nil
    else
        v51 = v4 + FishMotionConfig.MAX_EXTRAP
        FishMotionConfig.holdSince = FishMotionConfig.holdSince or elapsed3
    end

    if ServerTimeNow - v51 > FishMotionConfig.MAX_DELAY then
        v51 = ServerTimeNow - FishMotionConfig.MAX_DELAY
    end

    FishMotionConfig.clientDelay = ServerTimeNow - v51
    table.clear(t8)
    table.clear(t9)
    n4 += 1

    local CurrentCamera = workspace.CurrentCamera

    t10.cf = CurrentCamera.CFrame
    t10.tanV = math.tan(math.rad(CurrentCamera.FieldOfView) / 2)
    t10.tanH = t10.tanV * CurrentCamera.ViewportSize.X / math.max(CurrentCamera.ViewportSize.Y, 1)

    for _, v68 in pairs(t1) do
        local samples, mesh, model = v68.samples, v68.mesh, v68.model
        local v69 = FishMotionConfig.override[model]
        local v70, v71

        if v69 and model.Parent then
            v70, v71 = v69(p22)
        end

        local v72

        if v70 then
            v68.drawn = v70
            v68.corr = nil
            t8[#t8 + 1] = mesh
            t9[#t9 + 1] = v70
            mesh.AssemblyLinearVelocity = v71
            v72 = hideAmount(v68.attrs, ServerTimeNow - v2)

            while #samples > 3 and samples[2].t < v51 - 0.5 do
                table.remove(samples, 1)
            end
        else
            local v73 = #samples == 0

            if not v73 then
                v73 = v51 - samples[#samples].t > FishMotionConfig.STALE
            end

            if v73 then
                v72 = 1
            elseif model.Parent then
                if v68.drawn then
                    if (n4 + v68.phase) % 3 == 0 or fighting(v68.attrs) then
                        local v77, v78, v79 = drawPose(v68, samples, ServerTimeNow, v51, fighting(v68.attrs), p22 + (v68.skipDt or 0))

                        v68.skipDt = nil
                        v68.drawn = v77
                        t8[#t8 + 1] = mesh

                        local v80 = FishMotionConfig.nudge[model]

                        if v80 then
                            local v81 = elapsed3 - v80.at

                            if v80.lag + NightcrawlDodge.TIME + 0.1 < v81 then
                                FishMotionConfig.nudge[model] = nil
                            else
                                v77 += v80.off * (NightcrawlDodge.progress(v81) - NightcrawlDodge.progress(v81 - v80.lag))
                            end
                        end

                        t9[#t9 + 1] = v77
                        mesh.AssemblyLinearVelocity = v78
                        v72 = hideAmount(v68.attrs, v79)

                        while true and #samples > 3 and samples[2].t < v51 - 0.5 do
                            table.remove(samples, 1)
                        end
                    elseif offView(v68) then
                        v68.skipDt = (v68.skipDt or 0) + p22
                        v72 = v68.alpha
                    else
                        local v84, v85, v86 = drawPose(v68, samples, ServerTimeNow, v51, fighting(v68.attrs), p22 + (v68.skipDt or 0))

                        v68.skipDt = nil
                        v68.drawn = v84
                        t8[#t8 + 1] = mesh

                        local v87 = FishMotionConfig.nudge[model]

                        if v87 then
                            local v88 = elapsed3 - v87.at

                            if v87.lag + NightcrawlDodge.TIME + 0.1 < v88 then
                                FishMotionConfig.nudge[model] = nil
                            else
                                v84 += v87.off * (NightcrawlDodge.progress(v88) - NightcrawlDodge.progress(v88 - v87.lag))
                            end
                        end

                        t9[#t9 + 1] = v84
                        mesh.AssemblyLinearVelocity = v85
                        v72 = hideAmount(v68.attrs, v86)

                        while true and #samples > 3 and samples[2].t < v51 - 0.5 do
                            table.remove(samples, 1)
                        end
                    end
                else
                    local v91, v92, v93 = drawPose(v68, samples, ServerTimeNow, v51, fighting(v68.attrs), p22 + (v68.skipDt or 0))

                    v68.skipDt = nil
                    v68.drawn = v91
                    t8[#t8 + 1] = mesh

                    local v94 = FishMotionConfig.nudge[model]

                    if v94 then
                        local v95 = elapsed3 - v94.at

                        if v94.lag + NightcrawlDodge.TIME + 0.1 < v95 then
                            FishMotionConfig.nudge[model] = nil
                        else
                            v91 += v94.off * (NightcrawlDodge.progress(v95) - NightcrawlDodge.progress(v95 - v94.lag))
                        end
                    end

                    t9[#t9 + 1] = v91
                    mesh.AssemblyLinearVelocity = v92
                    v72 = hideAmount(v68.attrs, v93)

                    while true and #samples > 3 and samples[2].t < v51 - 0.5 do
                        table.remove(samples, 1)
                    end
                end
            else
                v72 = 1
            end
        end

        if v72 ~= v68.alpha or v68.base ~= v68.shownBase then
            v68.alpha = v72
            v68.shownBase = v68.base
            mesh.Transparency = v72 + (1 - v72) * v68.base
        end
    end

    if #t8 > 0 then
        workspace:BulkMoveTo(t8, t9, Enum.BulkMoveMode.FireCFrameChanged)
    end

    local elapsed4 = os.clock()

    for v97, v98 in pairs(t2) do
        if elapsed4 - v98.at > 5 then
            t2[v97] = nil
        end
    end
end)
task.spawn(function() -- line: 349
    -- upvalues: FishMotionConfig (copy), FishFocus (copy)
    while true do
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            FishFocus:FireServer(CurrentCamera.CFrame.Position, FishMotionConfig.renderLag())
        end

        task.wait(0.2)
    end
end)
