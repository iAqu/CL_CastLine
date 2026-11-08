-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenManor = require(ReplicatedStorage.Data.HalloweenManor)
local Log = require(ReplicatedStorage.Packages.Log)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)
local PumpkinBossFlags = require(ReplicatedStorage.Shared.Flags.PumpkinBossFlags)
local PumpkinBossSchedule = require(ReplicatedStorage.Shared.Util.PumpkinBossSchedule)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VoidFusionSounds = require(ReplicatedStorage.Shared.Util.VoidFusionSounds)
local v1 = Color3.fromRGB(120, 52, 14)
local v2 = Color3.fromRGB(255, 140, 40)
local v3 = TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0.2)
local v4 = TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local v6 = TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local Sounds = ManorInterior.Sounds
local BossPortal = HalloweenManor.BossPortal
local v7 = Log.new()
local t1 = {}
local Assets = ReplicatedStorage:WaitForChild("Assets")
local t2 = {}

local function clock(p1) -- line: 94
    if p1 >= 3600 then
        return string.format("%d:%02d:%02d", p1 // 3600, p1 % 3600 // 60, p1 % 60)
    end

    return string.format("%02d:%02d", p1 // 60, p1 % 60)
end

local function returnsAt(p2) -- line: 106
    -- upvalues: Workspace (copy), PumpkinBossFlags (copy), PumpkinBossState (copy)
    local Attribute = Workspace:GetAttribute(PumpkinBossState.DefeatedUntilAttribute)

    return if PumpkinBossFlags.DailyKillLimitEnabled:Get() and type(Attribute) == "number" and p2 < Attribute then Attribute else nil
end

local function isOpen(p3) -- line: 114
    -- upvalues: Workspace (copy), ManorInterior (copy), PumpkinBossFlags (copy), PumpkinBossSchedule (copy), PumpkinBossState (copy)
    local v8 = ManorInterior.GateOpen()
    local v9

    if not v8 then
        v9 = v8

        return v9
    end

    local v10 = PumpkinBossSchedule.IsOpen(p3)

    if not v10 then
        v9 = v10

        return v9
    end

    local Attribute = Workspace:GetAttribute(PumpkinBossState.DefeatedUntilAttribute)

    if not PumpkinBossFlags.DailyKillLimitEnabled:Get() or type(Attribute) ~= "number" or not (p3 < Attribute) then
        Attribute = nil
    end

    return Attribute == nil
end

local function statusText(p4) -- line: 118
    -- upvalues: Workspace (copy), ManorInterior (copy), PumpkinBossFlags (copy), PumpkinBossSchedule (copy), PumpkinBossState (copy), BossPortal (copy), clock (copy)
    if ManorInterior.GateOpen() then
        if not PumpkinBossSchedule.Enabled() then
            return BossPortal.ScheduleOff, nil
        end

        local Attribute = Workspace:GetAttribute(PumpkinBossState.DefeatedUntilAttribute)

        if not PumpkinBossFlags.DailyKillLimitEnabled:Get() or type(Attribute) ~= "number" or not (p4 < Attribute) then
            Attribute = nil
        end

        if Attribute == nil then
            if PumpkinBossSchedule.IsOpen(p4) then
                local v13 = math.max(0, (math.ceil(PumpkinBossSchedule.ClosesAt(p4) - p4)))

                return BossPortal.Open, string.format(BossPortal.Closes, clock(v13))
            end

            return string.format(BossPortal.Countdown, clock((math.max(0, (math.ceil((PumpkinBossSchedule.SecondsUntilOpen(p4)))))))), nil
        end

        return string.format(BossPortal.Returns, clock((math.max(0, (math.ceil(Attribute - p4)))))), nil
    end

    local v18 = ManorInterior.GateOpensAt(p4)

    if v18 == nil then
        return BossPortal.GateLocked, nil
    end

    return string.format(BossPortal.GateCountdown, clock((math.max(0, (math.ceil(v18 - p4)))))), nil
end

local function tinted(p5, p6) -- line: 144
    -- upvalues: v2 (copy)
    local t3 = {}

    for _, v21 in p5.Keypoints do
        table.insert(t3, ColorSequenceKeypoint.new(v21.Time, v21.Value:Lerp(v2, p6)))
    end

    return ColorSequence.new(t3)
end

local function captureSwirl(p7) -- line: 155
    local t4 = {
        Lights = {},
        Emitters = {},
        Color = p7.Color
    }

    for _, descendant in p7:GetDescendants() do
        if descendant:IsA("Light") then
            t4.Lights[descendant] = {
                Brightness = descendant.Brightness,
                Color = descendant.Color
            }
        elseif descendant:IsA("ParticleEmitter") then
            t4.Emitters[descendant] = {
                Rate = descendant.Rate,
                TimeScale = descendant.TimeScale,
                Color = descendant.Color
            }
        end
    end

    return t4
end

local function restoreSwirl(p8, p9) -- line: 172
    p8.Color = p9.Color

    for v22, v23 in p9.Lights do
        v22.Brightness = v23.Brightness
        v22.Color = v23.Color
    end

    for v24, v25 in p9.Emitters do
        v24.Rate = v25.Rate
        v24.TimeScale = v25.TimeScale
        v24.Color = v25.Color
    end
end

local function paintSwirl(p10, p11) -- line: 185
    -- upvalues: v1 (copy), v2 (copy), tinted (copy)
    local Swirl = p10.Swirl
    local v26 = math.clamp(p11, 0, 1)

    p10.Disc.Color = Swirl.Color:Lerp(v1, v26)

    for v27, v28 in Swirl.Lights do
        v27.Brightness = v28.Brightness * (v26 * -0.7 + 1) * (1 + p10.Flash.Value)
        v27.Color = v28.Color:Lerp(v2, v26)
    end

    for v29, v30 in Swirl.Emitters do
        v29.Rate = v30.Rate * (v26 * -0.85 + 1)
        v29.TimeScale = v30.TimeScale * (v26 * -0.65 + 1)
        v29.Color = tinted(v30.Color, v26 * 0.8)
    end
end

local function paintSeal(p12) -- line: 202
    -- upvalues: paintSwirl (copy)
    local Value = p12.Alpha.Value
    local v31 = 1 - Value
    local v32 = math.clamp(Value, 0, 1)
    local _CFrame = p12.Disc.CFrame

    for _, v33 in p12.Pieces do
        local v34 = CFrame.new(v33.Drop * v31) * CFrame.Angles(v33.Tilt * v31, 0, 0)

        v33.Part.CFrame = _CFrame * v34 * v33.Rest
        v33.Part.Transparency = 1 - (1 - v33.Transparency) * v32
    end

    local Barrier = p12.Barrier

    if Barrier ~= nil then
        Barrier.Transparency = 1 - (1 - math.min(p12.BarrierTransparency + 0.3 * p12.Pulse.Value, 1)) * v32
    end

    local Glow = p12.Glow

    if Glow ~= nil then
        Glow.Brightness = p12.GlowBrightness * (1 - 0.5 * p12.Pulse.Value) * v32 + 9 * p12.Flash.Value
    end

    paintSwirl(p12, Value)
end

local function burst(p13) -- line: 225
    for v36 in p13.Swirl.Emitters do
        v36:Emit(24)
    end
end

local function feedback(p14, p15) -- line: 231
    -- upvalues: TweenService (copy), Audio (copy), Shake (copy), VoidFusionSounds (copy), v3 (copy), v4 (copy), v6 (copy), Sounds (copy)
    local DiscPosition = p14.Disc.Position
    local tween = TweenService:Create(p14.Flash, v6, {
        Value = 0
    })

    p14.Motion:Add(function() -- line: 234
        -- upvalues: tween (copy)
        tween:Cancel()
    end)

    if p15 then
        Audio.Play(Sounds.ChainRattle, DiscPosition, {
            Volume = 0.9,
            MaxDistance = 260
        })
        p14.Motion:Add(task.delay(v4.Time * 0.6, function() -- line: 239
            -- upvalues: p14 (copy), DiscPosition (copy), tween (copy), Audio (copy), Shake (copy), Sounds (copy)
            Audio.Play(Sounds.PadlockClunk, DiscPosition, {
                Volume = 1.1,
                MaxDistance = 260
            })
            p14.Flash.Value = 0.6
            tween:Play()
            Shake.Play({
                Seconds = 0.4,
                Magnitude = 0.4,
                Range = {
                    Near = 40,
                    Far = 110,
                    Center = DiscPosition
                }
            })
        end))
    else
        Audio.Play(Sounds.PadlockClunk, DiscPosition, {
            Volume = 1.2,
            MaxDistance = 260
        })
        p14.Motion:Add(task.delay(v3.DelayTime, function() -- line: 252
            -- upvalues: DiscPosition (copy), Audio (copy), Sounds (copy)
            Audio.Play(Sounds.ChainRattle, DiscPosition, {
                Volume = 1,
                MaxDistance = 260
            })
        end))
        p14.Motion:Add(task.delay(v3.DelayTime + v3.Time * 0.7, function() -- line: 255
            -- upvalues: p14 (copy), DiscPosition (copy), tween (copy), Audio (copy), Shake (copy), VoidFusionSounds (copy)
            local RiftOpen = VoidFusionSounds.RiftOpen

            Audio.Play(RiftOpen.Id, DiscPosition, {
                MaxDistance = 260,
                Volume = RiftOpen.Volume
            })
            p14.Flash.Value = 1
            tween:Play()

            for v37 in p14.Swirl.Emitters do
                v37:Emit(24)
            end

            Shake.Play({
                Seconds = 0.9,
                Magnitude = 0.6,
                Shape = "Pulse",
                Range = {
                    Near = 40,
                    Far = 110,
                    Center = DiscPosition
                }
            })
        end))
    end
end

local function setSealed(p16, p17, p18) -- line: 270
    -- upvalues: TweenService (copy), v3 (copy), v4 (copy), paintSeal (copy), feedback (copy)
    if p16.Sealed == p17 then
        return
    end

    p16.Sealed = p17
    p16.Motion:Clean()
    p16.Flash.Value = 0

    local v38 = if p17 then 1 else 0

    if not p18 then
        p16.Alpha.Value = v38
        paintSeal(p16)

        return
    end

    local tween = TweenService:Create(p16.Alpha, if p17 then v4 else v3, {
        Value = v38
    })

    p16.Motion:Add(function() -- line: 288
        -- upvalues: tween (copy)
        tween:Cancel()
    end)
    tween:Play()
    feedback(p16, p17)
end

local function piecesOf(p19) -- line: 295
    local WorldPivot = p19.WorldPivot
    local t5 = {}
    local n1 = 0
    local descendant

    for _, descendant2 in p19:GetDescendants() do
        if descendant2:IsA("BasePart") then
            descendant2.Anchored = true
            descendant2.CanCollide = false
            descendant2.CanQuery = false
            descendant2.CanTouch = false

            if descendant2.Name == "Barrier" then
                descendant = descendant2
                n1 = descendant2.Transparency
            else
                local v40 = WorldPivot:ToObjectSpace(descendant2.CFrame)
                local v41 = descendant2.Parent ~= p19
                local v42 = if v40.Position.Z < 0 then -1 else 1
                local t6 = {
                    Part = descendant2,
                    Rest = v40,
                    Transparency = descendant2.Transparency
                }

                if v41 then
                    t6.Drop = Vector3.new(0, -6, 7) * Vector3.new(1, 1, v42)
                    t6.Tilt = v42 * -0.9599310885968813
                else
                    t6.Drop = Vector3.new(0, -9, 0)
                    t6.Tilt = 0
                end

                table.insert(t5, t6)
            end
        end
    end

    return t5, descendant, n1
end

local function forget(p20) -- line: 327
    -- upvalues: t1 (copy), restoreSwirl (copy)
    local v43 = t1[p20]

    if v43 == nil then
        return
    end

    t1[p20] = nil
    v43.Motion:Destroy()
    v43.Trove:Destroy()

    if v43.Disc.Parent ~= nil then
        restoreSwirl(v43.Disc, v43.Swirl)
    end
end

local function track(p21) -- line: 340
    -- upvalues: TweenService (copy), Workspace (copy), ManorInterior (copy), PumpkinBossFlags (copy), PumpkinBossSchedule (copy), PumpkinBossState (copy), Trove (copy), v5 (copy), BossPortal (copy), v7 (copy), t1 (copy), Assets (copy), captureSwirl (copy), restoreSwirl (copy), paintSeal (copy), piecesOf (copy)
    if p21:IsA("Model") and p21:IsDescendantOf(Workspace) and t1[p21] == nil then
        local v44 = p21:FindFirstChild("Cylinder.001")
        local v45 = Assets:FindFirstChild("HalloweenDimension") and Assets.HalloweenDimension:FindFirstChild("BossPortalSeal")
        local v46 = Assets:FindFirstChild("Billboards") and Assets.Billboards:FindFirstChild("BossPortalBillboard")

        if v44 == nil or not v44:IsA("BasePart") then
            v7:AtWarning():Log((("%* has no Cylinder.001; skipping its seal"):format((p21:GetFullName()))))
        elseif v45 == nil or not v45:IsA("Model") then
            v7:AtWarning():Log("Assets.HalloweenDimension.BossPortalSeal is missing")
        else
            local v47, clone, v48, v49, v50, PointLight, v51

            if v46 ~= nil then
                if v46:IsA("BillboardGui") then
                    v47 = Trove.new()
                    clone = v47:Clone(v45)
                    v48, v49, v50 = piecesOf(clone)

                    if v49 ~= nil then
                        PointLight = v49:FindFirstChildWhichIsA("PointLight")
                    end

                    v51 = false
                else
                    v51 = true
                end
            else
                v51 = true
            end

            if not v51 then
                local clone2 = v47:Clone(v46)
                local Title = clone2:FindFirstChild("Title")
                local Status = clone2:FindFirstChild("Status")
                local Sub = clone2:FindFirstChild("Sub")

                if Status and Status:IsA("TextLabel") and Sub and Sub:IsA("TextLabel") then
                    if Title ~= nil and Title:IsA("TextLabel") then
                        Title.Text = BossPortal.Title
                    end

                    local t7 = {
                        Sealed = nil,
                        Trove = v47,
                        Motion = Trove.new(),
                        Disc = v44,
                        Swirl = captureSwirl(v44),
                        Pieces = v48,
                        Barrier = v49,
                        BarrierTransparency = v50,
                        Glow = PointLight,
                        GlowBrightness = if PointLight == nil then 0 else PointLight.Brightness,
                        Board = clone2,
                        Status = Status,
                        Sub = Sub,
                        Alpha = v47:Add(Instance.new("NumberValue")),
                        Pulse = v47:Add(Instance.new("NumberValue")),
                        Flash = v47:Add(Instance.new("NumberValue"))
                    }

                    t1[p21] = t7
                    v47:Connect(t7.Alpha.Changed, function() -- line: 400
                        -- upvalues: t7 (copy), paintSeal (copy)
                        paintSeal(t7)
                    end)
                    v47:Connect(t7.Pulse.Changed, function() -- line: 403
                        -- upvalues: t7 (copy), paintSeal (copy)
                        if t7.Alpha.Value > 0 then
                            paintSeal(t7)
                        end
                    end)
                    v47:Connect(t7.Flash.Changed, function() -- line: 408
                        -- upvalues: t7 (copy), paintSeal (copy)
                        paintSeal(t7)
                    end)

                    local tween = TweenService:Create(t7.Pulse, v5, {
                        Value = 1
                    })

                    v47:Add(function() -- line: 412
                        -- upvalues: tween (copy)
                        tween:Cancel()
                    end)
                    v47:Connect(p21.AncestryChanged, function() -- line: 415
                        -- upvalues: p21 (copy), Workspace (copy), t1 (copy), restoreSwirl (copy)
                        if p21:IsDescendantOf(Workspace) then
                            return
                        end

                        local v53 = t1[p21]

                        if v53 == nil then
                            return
                        end

                        t1[p21] = nil
                        v53.Motion:Destroy()
                        v53.Trove:Destroy()

                        if v53.Disc.Parent ~= nil then
                            restoreSwirl(v53.Disc, v53.Swirl)
                        end
                    end)
                    clone.Parent = p21
                    clone2.Adornee = v44
                    clone2.Parent = v44

                    local ServerTimeNow = Workspace:GetServerTimeNow()
                    local v54 = ManorInterior.GateOpen()
                    local Attribute, v55

                    if v54 then
                        local v56 = PumpkinBossSchedule.IsOpen(ServerTimeNow)

                        if v56 then
                            Attribute = Workspace:GetAttribute(PumpkinBossState.DefeatedUntilAttribute)

                            if not PumpkinBossFlags.DailyKillLimitEnabled:Get() or type(Attribute) ~= "number" or not (ServerTimeNow < Attribute) then
                                Attribute = nil
                            end

                            v55 = Attribute == nil
                        else
                            v55 = v56
                        end
                    else
                        v55 = v54
                    end

                    local v57 = not v55

                    if t7.Sealed ~= v57 then
                        t7.Sealed = v57
                        t7.Motion:Clean()
                        t7.Flash.Value = 0

                        local v58 = v57 and 1 or 0

                        t7.Alpha.Value = v58
                        paintSeal(t7)
                    end

                    tween:Play()
                else
                    v7:AtWarning():Log("BossPortalBillboard is missing Status/Sub; skipping")
                    v47:Destroy()
                end
            else
                v7:AtWarning():Log("Assets.Billboards.BossPortalBillboard is missing")
            end
        end
    end
end

local function refresh(p22) -- line: 427
    -- upvalues: CollectionService (copy), Workspace (copy), ManorInterior (copy), PumpkinBossFlags (copy), PumpkinBossSchedule (copy), PumpkinBossState (copy), t1 (copy), statusText (copy), restoreSwirl (copy), setSealed (copy), track (copy)
    if PumpkinBossFlags.ContentEnabled:Get() then
        for _, v59 in CollectionService:GetTagged(p22) do
            track(v59)
        end

        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v60 = ManorInterior.GateOpen()
        local Attribute, v61

        if v60 then
            local v62 = PumpkinBossSchedule.IsOpen(ServerTimeNow)

            if v62 then
                Attribute = Workspace:GetAttribute(PumpkinBossState.DefeatedUntilAttribute)

                if not PumpkinBossFlags.DailyKillLimitEnabled:Get() or type(Attribute) ~= "number" or not (ServerTimeNow < Attribute) then
                    Attribute = nil
                end

                v61 = Attribute == nil
            else
                v61 = v62
            end
        else
            v61 = v60
        end

        local v63 = not v61
        local v64, v65 = statusText(ServerTimeNow)

        for _, v66 in t1 do
            setSealed(v66, v63, true)

            if v66.Status.Text ~= v64 then
                v66.Status.Text = v64
            end

            v66.Sub.Visible = v65 ~= nil

            if v65 ~= nil and v66.Sub.Text ~= v65 then
                v66.Sub.Text = v65
            end
        end
    else
        for v67 in t1 do
            local v68 = t1[v67]

            if v68 ~= nil then
                t1[v67] = nil
                v68.Motion:Destroy()
                v68.Trove:Destroy()

                if v68.Disc.Parent ~= nil then
                    restoreSwirl(v68.Disc, v68.Swirl)
                end
            end
        end
    end
end

function t2.Start(p23) -- line: 456
    -- upvalues: CollectionService (copy), HalloweenManor (copy), BossPortal (copy), v7 (copy), t1 (copy), restoreSwirl (copy), refresh (copy)
    local Portal = HalloweenManor.Tags.Portal

    if Portal == nil or BossPortal == nil then
        v7:AtWarning():Log("HalloweenManor.Tags.Portal or .BossPortal is missing; no portal seal")
    else
        p23:Connect(CollectionService:GetInstanceAddedSignal(Portal), function() -- line: 463
            -- upvalues: Portal (copy), refresh (copy)
            refresh(Portal)
        end)
        p23:Connect(CollectionService:GetInstanceRemovedSignal(Portal), function(p24) -- line: 466
            -- upvalues: t1 (copy), restoreSwirl (copy)
            if p24:IsA("Model") then
                local v69 = t1[p24]

                if v69 == nil then
                    return
                end

                t1[p24] = nil
                v69.Motion:Destroy()
                v69.Trove:Destroy()

                if v69.Disc.Parent ~= nil then
                    restoreSwirl(v69.Disc, v69.Swirl)
                end
            end
        end)
        p23:Add(function() -- line: 471
            -- upvalues: t1 (copy), restoreSwirl (copy)
            for v70 in t1 do
                local v71 = t1[v70]

                if v71 ~= nil then
                    t1[v70] = nil
                    v71.Motion:Destroy()
                    v71.Trove:Destroy()

                    if v71.Disc.Parent ~= nil then
                        restoreSwirl(v71.Disc, v71.Swirl)
                    end
                end
            end
        end)
        p23:Add(task.spawn(function() -- line: 476
            -- upvalues: Portal (copy), refresh (copy)
            while true do
                refresh(Portal)
                task.wait(1)
            end
        end))
    end
end

return table.freeze(t2)
