-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BaseUpgrade = require(ReplicatedStorage.Client.BaseUpgrade)
local ConcertReveal = require(ReplicatedStorage.Shared.Modules.ConcertReveal)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)
local VFX = require(ReplicatedStorage.Shared.Utils.VFX)
local v1 = Color3.fromRGB(255, 250, 235)
local v2 = Color3.fromRGB(255, 236, 200)
local v3 = Color3.fromRGB(255, 220, 120)
local v4 = Color3.fromRGB(255, 196, 64)
local v5 = Color3.fromRGB(255, 240, 170)
local v6 = Color3.fromRGB(255, 120, 30)
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 175
        -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), BaseUpgrade (copy), ConcertReveal (copy), Remotes (copy), Save (copy), Trove (copy), VFX (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), LocalPlayer (copy)
        local v7 = Workspace:WaitForChild("Sign", 30)

        if v7 ~= nil then
            local v8 = v7:WaitForChild("FlyingCurtain", 10)

            if v8 ~= nil then
                local Assets = ReplicatedStorage:WaitForChild("Assets")
                local v9 = v8
                local Plane = v8:WaitForChild("Plane")
                local Plane2 = Plane
                local CurtainCountdown = Plane:WaitForChild("CurtainCountdown")
                local CurtainCountdown2 = CurtainCountdown
                local CurtainRevealed = Plane:WaitForChild("CurtainRevealed")
                local Timer = CurtainCountdown:WaitForChild("Timer")
                local clone = v8:Clone()
                local v10 = Trove.new()
                local v11 = v10:Add(Trove.new())
                local t2 = {}
                local t3 = {}
                local t4 = {}
                local v12 = false
                local v13 = false

                local function hidePart(p1) -- line: 207
                    -- upvalues: t2 (copy)
                    local Transparency, CanCollide, CanQuery, CanTouch = p1.Transparency, p1.CanCollide, p1.CanQuery, p1.CanTouch

                    p1.Transparency = 1
                    p1.CanCollide = false
                    p1.CanQuery = false
                    p1.CanTouch = false
                    table.insert(t2, function() -- line: 216
                        -- upvalues: p1 (copy), Transparency (copy), CanCollide (copy), CanQuery (copy), CanTouch (copy)
                        p1.Transparency = Transparency
                        p1.CanCollide = CanCollide
                        p1.CanQuery = CanQuery
                        p1.CanTouch = CanTouch
                    end)
                end

                local function hideEmitter(p2) -- line: 224
                    -- upvalues: t3 (copy)
                    local Enabled = p2.Enabled

                    p2.Enabled = false
                    p2:Clear()
                    table.insert(t3, function() -- line: 230
                        -- upvalues: p2 (copy), Enabled (copy)
                        p2.Enabled = Enabled
                    end)
                end

                local function hideBeam(p3) -- line: 235
                    -- upvalues: t2 (copy)
                    local Enabled = p3.Enabled

                    p3.Enabled = false
                    table.insert(t2, function() -- line: 240
                        -- upvalues: p3 (copy), Enabled (copy)
                        p3.Enabled = Enabled
                    end)
                end

                local function hideSign() -- line: 245
                    -- upvalues: v7 (copy), CurtainCountdown2 (ref), CurtainRevealed (ref), t2 (copy), t3 (copy)
                    for _, descendant in v7:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            local Transparency, CanCollide, CanQuery, CanTouch = descendant.Transparency, descendant.CanCollide, descendant.CanQuery, descendant.CanTouch

                            descendant.Transparency = 1
                            descendant.CanCollide = false
                            descendant.CanQuery = false
                            descendant.CanTouch = false
                            table.insert(t2, function() -- line: 216
                                -- upvalues: descendant (copy), Transparency (copy), CanCollide (copy), CanQuery (copy), CanTouch (copy)
                                descendant.Transparency = Transparency
                                descendant.CanCollide = CanCollide
                                descendant.CanQuery = CanQuery
                                descendant.CanTouch = CanTouch
                            end)
                        elseif descendant:IsA("ParticleEmitter") then
                            local Enabled = descendant.Enabled

                            descendant.Enabled = false
                            descendant:Clear()
                            table.insert(t3, function() -- line: 230
                                -- upvalues: descendant (copy), Enabled (copy)
                                descendant.Enabled = Enabled
                            end)
                        elseif descendant:IsA("Beam") then
                            local Enabled = descendant.Enabled

                            descendant.Enabled = false
                            table.insert(t2, function() -- line: 240
                                -- upvalues: descendant (copy), Enabled (copy)
                                descendant.Enabled = Enabled
                            end)
                        end
                    end

                    CurtainCountdown2.Enabled = false
                    CurtainRevealed.Enabled = false
                end

                local function formatRemaining(p4) -- line: 260
                    local v21 = math.max(0, (math.floor(p4)))
                    local v22 = v21 // 86400
                    local v23 = v21 // 3600 % 24
                    local v24 = v21 // 60 % 60

                    return string.format("%dD %02d:%02d:%02d", v22, v23, v24, v21 % 60)
                end

                local function formatConcertRemaining(p5) -- line: 269
                    local v26 = math.max(0, (math.floor(p5)))
                    local v27 = v26 // 86400
                    local v28 = string.format("%02d:%02d:%02d", v26 // 3600 % 24, v26 // 60 % 60, v26 % 60)

                    if v27 > 0 then
                        return (string.format("%dD %s", v27, v28))
                    end

                    return v28
                end

                local function startConcertCountdown(p6) -- line: 278
                    -- upvalues: v10 (copy), Workspace (copy), ConcertReveal (copy)
                    local TimerPanel = p6:FindFirstChild("TimerPanel")
                    local Countdown = if TimerPanel == nil then nil else TimerPanel:FindFirstChild("Countdown")
                    local Timer = if Countdown == nil then nil else Countdown:FindFirstChild("Timer")
                    local v29, v30

                    if Timer ~= nil then
                        if Timer:IsA("TextLabel") then
                            local function refresh() -- line: 286
                                -- upvalues: Timer (copy), Workspace (copy), ConcertReveal (copy)
                                local v33 = math.max(0, (math.floor(ConcertReveal.ConcertAt - Workspace:GetServerTimeNow())))
                                local v34 = v33 // 86400
                                local v35 = string.format("%02d:%02d:%02d", v33 // 3600 % 24, v33 // 60 % 60, v33 % 60)

                                Timer.Text = if v34 > 0 then string.format("%dD %s", v34, v35) else v35
                            end

                            local v38 = math.max(0, (math.floor(ConcertReveal.ConcertAt - Workspace:GetServerTimeNow())))
                            local v39 = v38 // 86400

                            v29 = string.format("%02d:%02d:%02d", v38 // 3600 % 24, v38 // 60 % 60, v38 % 60)

                            if v39 > 0 then
                                v29 = string.format("%dD %s", v39, v29)
                            end

                            v30 = false
                        else
                            v30 = true
                        end
                    else
                        v30 = true
                    end

                    if v30 then
                        return
                    end

                    Timer.Text = v29
                    v10:Add(task.spawn(function() -- line: 292
                        -- upvalues: Timer (copy), Workspace (copy), ConcertReveal (copy)
                        while Timer.Parent ~= nil do
                            task.wait(1 - Workspace:GetServerTimeNow() % 1)

                            local v42 = math.max(0, (math.floor(ConcertReveal.ConcertAt - Workspace:GetServerTimeNow())))
                            local v43 = v42 // 86400
                            local v44 = string.format("%02d:%02d:%02d", v42 // 3600 % 24, v42 // 60 % 60, v42 % 60)

                            Timer.Text = if v43 > 0 then string.format("%dD %s", v43, v44) else v44
                        end
                    end))
                end

                local function isRevealed() -- line: 300
                    -- upvalues: Workspace (copy), ConcertReveal (copy)
                    return Workspace:GetServerTimeNow() >= ConcertReveal.RevealAt()
                end

                local function fetchSeen() -- line: 304
                    -- upvalues: Remotes (copy)
                    local function v45() -- line: 305
                        -- upvalues: Remotes (copy)
                        return Remotes.ConcertReveal.FetchSeen:InvokeServer()
                    end

                    local ok, result = pcall(v45)

                    return ok and result == true
                end

                local function flagSeen() -- line: 312
                    -- upvalues: Remotes (copy)
                    local function v46() -- line: 313
                        -- upvalues: Remotes (copy)
                        Remotes.ConcertReveal.FlagSeen:InvokeServer()
                    end

                    pcall(v46)
                end

                local function eased(p7, p8, p9) -- line: 318
                    -- upvalues: TweenService (copy)
                    return TweenService:GetValue(math.clamp(p7, 0, 1), p8, p9)
                end

                local function progress(p10, p11, p12) -- line: 326
                    return (math.clamp((p10 - p11) / (p12 - p11), 0, 1))
                end

                local function wobbleAt(p13, p14) -- line: 330
                    local v49 = math.sin(p14 * 6.283185307179586 / 3.1) * 1.4
                    local v51 = math.sin(p14 * 6.283185307179586 / 4.3) * 0.06981317007977318
                    local v53 = math.sin(p14 * 6.283185307179586 / 3.7 + 1.3) * 0.027925268031909273
                    local v55 = math.sin(p14 * 6.283185307179586 / 5.9 + 2.1) * 0.041887902047863905

                    return CFrame.new(p13.Position + Vector3.new(0, v49, 0)) * CFrame.Angles(v51, v55, v53) * p13.Rotation
                end

                local function floatAt(p15) -- line: 342
                    local v57 = (math.sin(p15 * 6.283185307179586 / 2.4 + 0.8) * 0.5 + 0.5) * 1.1
                    local v59 = math.sin(p15 * 6.283185307179586 / 6.7) * 0.10471975511965978

                    return CFrame.new(0, v57, 0) * CFrame.Angles(0, v59, 0)
                end

                local function startWobble(p16, p17, p18, p19, p20) -- line: 351
                    -- upvalues: v11 (copy), wobbleAt (copy), floatAt (copy), RunService (copy), Workspace (copy)
                    v11:Clean()

                    local v60 = p19 or p16:GetPivot()
                    local v61

                    if p20 then
                        v61 = p20
                    elseif p17 ~= nil then
                        v61 = v60:Inverse() * p17:GetPivot()
                    end

                    local v62 = os.clock() - (p18 or 0)

                    v11:Connect(RunService.RenderStepped, function() -- line: 365
                        -- upvalues: p16 (copy), p17 (copy), v62 (copy), v61 (ref), v60 (copy), wobbleAt (copy), floatAt (copy), Workspace (copy)
                        local CurrentCamera = Workspace.CurrentCamera

                        if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - v60.Position).Magnitude > 900 then
                            return
                        end

                        local v63 = os.clock() - v62
                        local v64 = wobbleAt(v60, v63)

                        p16:PivotTo(v64)

                        if p17 ~= nil and v61 ~= nil then
                            p17:PivotTo(v64 * v61 * floatAt(v63))
                        end
                    end)
                end

                local function playPoof() -- line: 384
                    -- upvalues: Plane2 (ref), ReplicatedStorage (copy), Audio (copy), VFX (copy)
                    local X = Plane2.Size.X
                    local EggPoof = ReplicatedStorage.Assets:FindFirstChild("EggPoof")
                    local TreadmillUpgrade = ReplicatedStorage.Assets.Particles:FindFirstChild("TreadmillUpgrade")

                    if EggPoof ~= nil then
                        for i = 1, 5 do
                            local v65 = ((i - 1) / 4 - 0.5) * X * 0.9
                            local v66 = Plane2.CFrame * CFrame.new(v65, 0, 0)

                            VFX.EmitAt(v66, EggPoof:GetChildren(), function(p21) -- line: 394
                                -- upvalues: VFX (copy)
                                VFX.Rescale(p21, 20)
                                p21:SetAttribute("EmitCount", 40)
                            end)
                        end
                    end

                    if TreadmillUpgrade ~= nil then
                        VFX.EmitAt(Plane2.CFrame, TreadmillUpgrade:GetChildren(), function(p22) -- line: 402
                            -- upvalues: VFX (copy)
                            VFX.Rescale(p22, 8)
                        end)
                    end

                    Audio.Play("rbxassetid://102267539121951", Plane2, {
                        MaxDistance = 500,
                        Volume = 1.2
                    })
                end

                local function centrePivot(p23) -- line: 410
                    local BoundingBox = p23:GetBoundingBox()

                    p23.WorldPivot = CFrame.new(BoundingBox.Position)
                end

                local function silenceEmitters(p24) -- line: 415
                    local t5 = {}

                    for _, descendant in p24:GetDescendants() do
                        if descendant:IsA("ParticleEmitter") then
                            t5[descendant] = descendant.Enabled
                            descendant.Enabled = false
                        end
                    end

                    return function() -- line: 425
                        -- upvalues: t5 (copy)
                        for v67, v68 in t5 do
                            v67.Enabled = v68
                        end
                    end
                end

                local function awaitRevealAssets() -- line: 432
                    -- upvalues: Assets (copy)
                    local ConcertReveal = Assets:FindFirstChild("ConcertReveal")

                    while ConcertReveal == nil do
                        Assets.ChildAdded:Wait()
                        ConcertReveal = Assets:FindFirstChild("ConcertReveal")
                    end

                    return ConcertReveal
                end

                local function spawnFinale() -- line: 442
                    -- upvalues: v10 (copy), t4 (copy), startConcertCountdown (copy), awaitRevealAssets (copy)
                    local v69 = awaitRevealAssets()
                    local clone = v69:WaitForChild("FlyingCurtain2"):Clone()
                    local clone2 = v69:WaitForChild("Emblem"):Clone()
                    local BoundingBox = clone2:GetBoundingBox()

                    clone2.WorldPivot = CFrame.new(BoundingBox.Position)
                    v10:Add(clone)
                    v10:Add(clone2)
                    table.insert(t4, clone)
                    table.insert(t4, clone2)
                    startConcertCountdown(clone)

                    return clone, clone2
                end

                local function fadeLight(p25) -- line: 457
                    -- upvalues: v7 (copy), v10 (copy), RunService (copy)
                    local Light = v7:FindFirstChild("Light")

                    if Light == nil then
                        return
                    end

                    local t6 = {}

                    for _, descendant in Light:GetDescendants() do
                        if descendant:IsA("Beam") and descendant.Enabled then
                            t6[descendant] = descendant.Transparency
                        end
                    end

                    local elapsed = os.clock()
                    local connection

                    local function step() -- line: 473
                        -- upvalues: p25 (copy), t6 (copy), elapsed (copy), connection (ref)
                        local v70 = if p25 > 0 then math.min(1, (os.clock() - elapsed) / p25) else 1

                        for v72, v73 in t6 do
                            if v70 >= 1 then
                                v72.Enabled = false
                                v72.Transparency = v73
                            else
                                local t7 = {}

                                for _, v74 in v73.Keypoints do
                                    table.insert(t7, NumberSequenceKeypoint.new(v74.Time, v74.Value + (1 - v74.Value) * v70, v74.Envelope))
                                end

                                v72.Transparency = NumberSequence.new(t7)
                            end
                        end

                        if v70 >= 1 and connection ~= nil then
                            connection:Disconnect()
                        end
                    end

                    if p25 <= 0 then
                        step()
                    else
                        connection = RunService.RenderStepped:Connect(step)
                        v10:Add(connection)
                    end
                end

                local function popScale(p26) -- line: 510
                    -- upvalues: TweenService (copy)
                    local Back = Enum.EasingStyle.Back
                    local Out = Enum.EasingDirection.Out

                    return (math.max(0.05, TweenService:GetValue(math.clamp(p26, 0, 1), Back, Out) * 0.95 + 0.05))
                end

                local function showFinale() -- line: 515
                    -- upvalues: v7 (copy), v9 (ref), t2 (copy), startWobble (copy), playPoof (copy), silenceEmitters (copy), spawnFinale (copy), fadeLight (copy), RunService (copy), TweenService (copy)
                    for _, v77 in t2 do
                        v77()
                    end

                    fadeLight(0)
                    v9:Destroy()

                    local v78, v79 = spawnFinale()
                    local Scale = v78:GetScale()
                    local Scale2 = v79:GetScale()
                    local v80 = silenceEmitters(v78)
                    local v81 = silenceEmitters(v79)

                    v78:ScaleTo(Scale * 0.05)
                    v79:ScaleTo(Scale2 * 0.05)
                    v78.Parent = v7
                    v79.Parent = v7
                    playPoof()

                    local elapsed = os.clock()

                    while true do
                        local v83 = math.min(1, (os.clock() - elapsed) / 0.75)
                        local Back = Enum.EasingStyle.Back
                        local Out = Enum.EasingDirection.Out

                        v78:ScaleTo(Scale * math.max(0.05, TweenService:GetValue(math.clamp(v83, 0, 1), Back, Out) * 0.95 + 0.05))

                        local Back2 = Enum.EasingStyle.Back
                        local Out2 = Enum.EasingDirection.Out

                        v79:ScaleTo(Scale2 * math.max(0.05, TweenService:GetValue(math.clamp(v83, 0, 1), Back2, Out2) * 0.95 + 0.05))

                        if v83 >= 1 then
                            break
                        end

                        RunService.RenderStepped:Wait()
                    end

                    v80()
                    v81()
                    startWobble(v78, v79)
                end

                local function spawnRing(p27, p28, p29, p30) -- line: 550
                    -- upvalues: v7 (copy), TweenService (copy), VFX (copy), v4 (copy)
                    local Part = Instance.new("Part")

                    Part.Name = "RevealRing"
                    Part.Shape = Enum.PartType.Cylinder
                    Part.Material = Enum.Material.Neon
                    Part.Color = v4
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanQuery = false
                    Part.CanTouch = false
                    Part.CastShadow = false
                    Part.Transparency = 0.2
                    Part.Size = Vector3.new(p30, p28 * 0.1, p28 * 0.1)
                    Part.CFrame = p27
                    Part.Parent = v7
                    TweenService:Create(Part, TweenInfo.new(p29, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = 1,
                        Size = Vector3.new(p30 * 0.3, p28, p28)
                    }):Play()
                    VFX.Discard(Part, p29 + 0.1)
                end

                local function attachEmblemTrail() -- line: 579
                    -- upvalues: v5 (copy), v6 (copy)
                    local Part = Instance.new("Part")

                    Part.Name = "EmblemTrailAnchor"
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanQuery = false
                    Part.CanTouch = false
                    Part.CastShadow = false
                    Part.Transparency = 1
                    Part.Size = Vector3.new(1, 1, 1)

                    local Attachment = Instance.new("Attachment")

                    Attachment.Name = "TrailLeft"
                    Attachment.Position = Vector3.new(-4.5, 0, 0)
                    Attachment.Parent = Part

                    local Attachment2 = Instance.new("Attachment")

                    Attachment2.Name = "TrailRight"
                    Attachment2.Position = Vector3.new(4.5, 0, 0)
                    Attachment2.Parent = Part

                    local Trail = Instance.new("Trail")

                    Trail.Name = "FlightTrail"
                    Trail.Attachment0 = Attachment
                    Trail.Attachment1 = Attachment2
                    Trail.FaceCamera = true
                    Trail.LightEmission = 1
                    Trail.LightInfluence = 0
                    Trail.Lifetime = 0.35
                    Trail.MinLength = 0.1
                    Trail.Color = ColorSequence.new(v5, v6)
                    Trail.Transparency = NumberSequence.new(0.15, 1)
                    Trail.WidthScale = NumberSequence.new(1, 0)
                    Trail.Parent = Part

                    return Part, Trail
                end

                local function shakeCamera() -- line: 617
                    -- upvalues: v10 (copy), RunService (copy), Workspace (copy)
                    local elapsed = os.clock()

                    local function stop() -- line: 620
                        -- upvalues: RunService (copy)
                        RunService:UnbindFromRenderStep("ConcertRevealShake")
                    end

                    RunService:UnbindFromRenderStep("ConcertRevealShake")
                    RunService:BindToRenderStep("ConcertRevealShake", Enum.RenderPriority.Camera.Value + 1, function() -- line: 625
                        -- upvalues: elapsed (copy), RunService (copy), Workspace (copy)
                        local CurrentCamera = Workspace.CurrentCamera
                        local v91 = os.clock() - elapsed

                        if CurrentCamera == nil or v91 >= 0.35 then
                            RunService:UnbindFromRenderStep("ConcertRevealShake")
                        else
                            local v92 = (1 - v91 / 0.35) ^ 2
                            local v93 = 0.3 * v92

                            CurrentCamera.CFrame = CurrentCamera.CFrame * (CFrame.new(math.sin(v91 * 71) * v93, math.sin(v91 * 89 + 1.3) * v93, 0) * CFrame.Angles(0, 0, 0.006108652381980153 * v92 * math.sin(v91 * 53)))
                        end
                    end)
                    v10:Add(stop)
                end

                local function landEmblem(p31, p32, p33) -- line: 644
                    -- upvalues: fadeLight (copy), spawnRing (copy), shakeCamera (copy), ReplicatedStorage (copy), Workspace (copy), Audio (copy), VFX (copy)
                    if p33 ~= nil then
                        p33.Enabled = false
                    end

                    if p32 ~= nil then
                        VFX.Discard(p32, 0.44999999999999996)
                    end

                    local BoundingBox = p31:GetBoundingBox()
                    local TreadmillUpgrade = ReplicatedStorage.Assets.Particles:FindFirstChild("TreadmillUpgrade")

                    if TreadmillUpgrade ~= nil then
                        VFX.EmitAt(BoundingBox, TreadmillUpgrade:GetChildren(), function(p34) -- line: 655
                            -- upvalues: VFX (copy)
                            VFX.Rescale(p34, 8)
                        end)
                    end

                    spawnRing(CFrame.new(BoundingBox.Position), 80, 0.35, 3.5999999999999996)
                    Audio.Play("rbxassetid://77791314689160", BoundingBox.Position, {
                        MaxDistance = 1000,
                        Volume = 1
                    })
                    fadeLight(0.45)

                    local CurrentCamera = Workspace.CurrentCamera

                    if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - BoundingBox.Position).Magnitude <= 600 then
                        shakeCamera()
                    end
                end

                local function playReveal() -- line: 678
                    -- upvalues: v7 (copy), v9 (ref), CurtainCountdown2 (ref), CurtainRevealed (ref), v10 (copy), v11 (copy), wobbleAt (copy), floatAt (copy), startWobble (copy), playPoof (copy), silenceEmitters (copy), awaitRevealAssets (copy), spawnFinale (copy), attachEmblemTrail (copy), landEmblem (copy), ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), VFX (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
                    local clone = awaitRevealAssets():WaitForChild("Envelope"):Clone()
                    local v100, v101 = spawnFinale()

                    v10:Add(clone)

                    local BoundingBox = clone:GetBoundingBox()

                    clone.WorldPivot = CFrame.new(BoundingBox.Position)
                    v11:Clean()

                    local Pivot = v9:GetPivot()
                    local Scale = v9:GetScale()
                    local t9 = {}

                    for _, descendant in v9:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            t9[descendant] = descendant.Transparency
                        elseif descendant:IsA("ParticleEmitter") then
                            descendant.Enabled = false
                        end
                    end

                    local Pivot2 = clone:GetPivot()
                    local Scale2 = clone:GetScale()
                    local t10 = {}

                    for _, descendant in clone:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            t10[descendant] = descendant.Transparency
                        end
                    end

                    local v102 = clone:FindFirstChild("Cube.002", true)
                    local v103 = clone:FindFirstChild("Cube.003", true)
                    local v104, v105

                    if v102 ~= nil then
                        v104 = Pivot2:PointToObjectSpace(v102.Position + Vector3.new(0, v102.Size.Y / 2, 0))
                        v105 = Pivot2:VectorToObjectSpace((Vector3.new(0, 0, 1)))
                    end

                    local v107 = if v102 == nil then CFrame.identity else v102.CFrame
                    local Pivot3 = v100:GetPivot()
                    local Scale3 = v100:GetScale()
                    local Pivot4 = v101:GetPivot()
                    local Scale4 = v101:GetScale()
                    local v108 = silenceEmitters(v100)
                    local v109 = silenceEmitters(v101)
                    local v110 = Pivot3:Inverse() * Pivot4

                    local function swayFrame(p35) -- line: 725
                        -- upvalues: Pivot3 (copy), wobbleAt (copy)
                        return (wobbleAt(Pivot3, (math.max(0, p35 - 3.2))))
                    end

                    local function emblemTarget(p36) -- line: 729
                        -- upvalues: Pivot3 (copy), v110 (copy), wobbleAt (copy), floatAt (copy)
                        return wobbleAt(Pivot3, (math.max(0, p36 - 3.2))) * v110 * floatAt((math.max(0, p36 - 3.2)))
                    end

                    local function envelopeFrame(p37, p38) -- line: 733
                        -- upvalues: Pivot2 (copy)
                        return CFrame.new(Pivot2.Position + p37) * p38 * Pivot2.Rotation
                    end

                    local function placeEnvelope(p39, p40, p41) -- line: 737
                        -- upvalues: clone (copy), Scale2 (copy), v102 (copy), v104 (ref), v105 (ref), v107 (ref)
                        if v102 ~= nil then
                            v102.CFrame = v107
                        end

                        clone:ScaleTo(Scale2 * p40)
                        clone:PivotTo(p39)

                        if v102 == nil or v104 == nil or v105 == nil then
                            return
                        end

                        v107 = v102.CFrame

                        local v115 = p39:PointToWorldSpace(v104 * p40)
                        local v116 = p39:VectorToWorldSpace(v105)

                        v102.CFrame = CFrame.new(v115) * CFrame.fromAxisAngle(v116, p41) * CFrame.new(-v115) * v107
                    end

                    local function quickFade(p42) -- line: 755
                        local v118 = math.min(1, 0.7 / p42.Lifetime.Max)

                        p42.Lifetime = NumberRange.new(p42.Lifetime.Min * v118, p42.Lifetime.Max * v118)
                    end

                    local function burstEffects(p43) -- line: 761
                        -- upvalues: v103 (copy), v7 (copy), v10 (copy), ReplicatedStorage (copy), TweenService (copy), Workspace (copy), Audio (copy), VFX (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy)
                        if v103 ~= nil then
                            VFX.EmitAt(p43, v103:GetChildren(), function(p44) -- line: 763
                                p44:SetAttribute("EmitCount", p44.Rate * 6)

                                local v120 = math.min(1, 0.7 / p44.Lifetime.Max)

                                p44.Lifetime = NumberRange.new(p44.Lifetime.Min * v120, p44.Lifetime.Max * v120)
                            end)
                        end

                        local TreadmillUpgrade = ReplicatedStorage.Assets.Particles:FindFirstChild("TreadmillUpgrade")

                        if TreadmillUpgrade ~= nil then
                            VFX.EmitAt(p43, TreadmillUpgrade:GetChildren(), function(p45) -- line: 772
                                -- upvalues: VFX (copy)
                                VFX.Rescale(p45, 12)

                                local v122 = math.min(1, 0.7 / p45.Lifetime.Max)

                                p45.Lifetime = NumberRange.new(p45.Lifetime.Min * v122, p45.Lifetime.Max * v122)
                            end)
                        end

                        local function glowPart(p46, p47, p48, p49, p50, p51) -- line: 778
                            -- upvalues: v7 (copy)
                            local Part = Instance.new("Part")

                            Part.Name = p46
                            Part.Shape = p47
                            Part.Material = Enum.Material.Neon
                            Part.Color = p48
                            Part.Anchored = true
                            Part.CanCollide = false
                            Part.CanQuery = false
                            Part.CanTouch = false
                            Part.CastShadow = false
                            Part.Transparency = p49
                            Part.Size = p50
                            Part.CFrame = p51
                            Part.Parent = v7

                            return Part
                        end

                        local Ball = Enum.PartType.Ball
                        local Part = Instance.new("Part")

                        Part.Name = "RevealFlash"
                        Part.Shape = Ball
                        Part.Material = Enum.Material.Neon
                        Part.Color = v3
                        Part.Anchored = true
                        Part.CanCollide = false
                        Part.CanQuery = false
                        Part.CanTouch = false
                        Part.CastShadow = false
                        Part.Transparency = 0.15
                        Part.Size = Vector3.new(8, 8, 8)
                        Part.CFrame = p43
                        Part.Parent = v7

                        local Ball2 = Enum.PartType.Ball
                        local Part2 = Instance.new("Part")

                        Part2.Name = "RevealFlashCore"
                        Part2.Shape = Ball2
                        Part2.Material = Enum.Material.Neon
                        Part2.Color = v1
                        Part2.Anchored = true
                        Part2.CanCollide = false
                        Part2.CanQuery = false
                        Part2.CanTouch = false
                        Part2.CastShadow = false
                        Part2.Transparency = 0
                        Part2.Size = Vector3.new(6, 6, 6)
                        Part2.CFrame = p43
                        Part2.Parent = v7

                        local PointLight = Instance.new("PointLight")

                        PointLight.Color = v3
                        PointLight.Brightness = 12
                        PointLight.Range = 90
                        PointLight.Shadows = false
                        PointLight.Parent = Part2
                        TweenService:Create(Part2, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = Vector3.new(70, 70, 70),
                            Transparency = 1
                        }):Play()
                        TweenService:Create(PointLight, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Brightness = 0
                        }):Play()
                        VFX.Discard(Part2, 0.44999999999999996)

                        local v123 = TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

                        for i = 1, 12 do
                            local v124 = (i - 1) / 12 * 3.141592653589793 * 2
                            local v125 = if i % 2 == 0 then 60 else 110
                            local v126 = CFrame.new(p43.Position) * CFrame.Angles(v124, 0, 0)
                            local Block = Enum.PartType.Block
                            local v127 = if i % 2 == 0 then v3 else v1
                            local v128 = v126 * CFrame.new(0, 0.5, 0)
                            local Part = Instance.new("Part")

                            Part.Name = "RevealSpike"
                            Part.Shape = Block
                            Part.Material = Enum.Material.Neon
                            Part.Color = v127
                            Part.Anchored = true
                            Part.CanCollide = false
                            Part.CanQuery = false
                            Part.CanTouch = false
                            Part.CastShadow = false
                            Part.Transparency = 0.1
                            Part.Size = Vector3.new(2.4, 1, 2.4)
                            Part.CFrame = v128
                            Part.Parent = v7
                            TweenService:Create(Part, v123, {
                                Transparency = 1,
                                Size = Vector3.new(0.48, v125, 0.48),
                                CFrame = v126 * CFrame.new(0, v125 / 2, 0)
                            }):Play()
                            VFX.Discard(Part, 0.55)
                        end

                        local CurrentCamera = Workspace.CurrentCamera

                        if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - p43.Position).Magnitude <= 600 then
                            local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

                            ColorCorrectionEffect.Name = "RevealScreenFlash"
                            ColorCorrectionEffect.Brightness = 0.35
                            ColorCorrectionEffect.TintColor = v2
                            ColorCorrectionEffect.Parent = CurrentCamera
                            TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Brightness = 0,
                                TintColor = Color3.new(1, 1, 1)
                            }):Play()
                            VFX.Discard(ColorCorrectionEffect, 0.55)
                            v10:Add(ColorCorrectionEffect)
                        end

                        local Part3 = Instance.new("Part")

                        Part3.Name = "RevealRing"
                        Part3.Shape = Enum.PartType.Cylinder
                        Part3.Material = Enum.Material.Neon
                        Part3.Color = v4
                        Part3.Anchored = true
                        Part3.CanCollide = false
                        Part3.CanQuery = false
                        Part3.CanTouch = false
                        Part3.CastShadow = false
                        Part3.Transparency = 0.2
                        Part3.Size = Vector3.new(6, 10, 10)
                        Part3.CFrame = p43
                        Part3.Parent = v7
                        TweenService:Create(Part, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = Vector3.new(150, 150, 150),
                            Transparency = 1
                        }):Play()
                        TweenService:Create(Part3, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = Vector3.new(1.8, 210, 210),
                            Transparency = 1
                        }):Play()
                        VFX.Discard(Part, 0.7)
                        VFX.Discard(Part3, 0.7)
                        Audio.Play("rbxassetid://85887503985998", p43.Position, {
                            MaxDistance = 1000,
                            Volume = 1.3
                        })
                    end

                    local v130 = false
                    local v131 = false
                    local v132 = false
                    local v133 = false
                    local v134 = false
                    local v135 = false
                    local v136, v137
                    local v138 = CFrame.identity
                    local BindableEvent = Instance.new("BindableEvent")
                    local ConcertRevealTimeScale = if RunService:IsStudio() then Workspace:GetAttribute("ConcertRevealTimeScale") else nil
                    local n1 = 0
                    local connection

                    connection = RunService.RenderStepped:Connect(function(p52) -- line: 938
                        -- upvalues: clone (copy), v100 (copy), v101 (copy), Pivot (copy), Scale (copy), t9 (copy), Pivot2 (copy), t10 (copy), Pivot3 (copy), Scale3 (copy), Pivot4 (copy), Scale4 (copy), v109 (copy), v110 (copy), placeEnvelope (copy), burstEffects (copy), v130 (ref), v131 (ref), v132 (ref), v133 (ref), v134 (ref), v135 (ref), v136 (ref), v137 (ref), v138 (ref), BindableEvent (copy), n1 (ref), connection (ref), ConcertRevealTimeScale (copy), v7 (copy), v9 (ref), CurtainCountdown2 (ref), CurtainRevealed (ref), wobbleAt (copy), floatAt (copy), playPoof (copy), attachEmblemTrail (copy), landEmblem (copy), TweenService (copy), Audio (copy)
                        local v139 = n1
                        local v140 = if type(ConcertRevealTimeScale) == "number" then ConcertRevealTimeScale else 1

                        n1 = v139 + p52 * v140

                        local Quad, v141, Value, v142, v143, v144

                        if v9.Parent ~= nil then
                            if n1 < 0.22 then
                                local v145 = n1 / 0.22

                                v140 = Enum.EasingStyle.Quad
                                v142 = Enum.EasingDirection.Out
                                Value = TweenService:GetValue(math.clamp(v145, 0, 1), v140, v142)
                                v145 = v9
                                v145:ScaleTo(Scale * (1 - Value * 0.07))
                                v145 = v9
                                v145:PivotTo(Pivot * CFrame.new(0, Value * -5, 0))
                            elseif n1 < 1.05 then
                                if not v130 then
                                    v130 = true
                                    playPoof()
                                    Audio.Play("rbxassetid://124899059042473", Pivot.Position, {
                                        MaxDistance = 1000,
                                        Volume = 1.5
                                    })
                                end

                                v142 = (n1 - 0.22) / 0.8300000000000001
                                v140 = math.clamp(v142, 0, 1)
                                Quad = Enum.EasingStyle.Quad
                                v142 = Enum.EasingDirection.In
                                v143 = TweenService:GetValue(math.clamp(v140, 0, 1), Quad, v142)
                                v144 = (n1 - 0.62) / 0.43000000000000005
                                Value = math.clamp(v144, 0, 1)
                                v144 = Pivot.Position
                                v141 = v143 * 170 - (1 - v140) * 5
                                v142 = v144 + Vector3.new(0, v141, 0) + Vector3.new(90, 0, 70) * v143

                                local v146 = v9

                                v146:ScaleTo(Scale * (v143 * -0.7 + 1 - (1 - v140) * 0.07))
                                v146 = v9
                                v146:PivotTo(CFrame.new(v142) * CFrame.Angles(0, v143 * 3.839724354387525, v140 * 0.4886921905584123) * Pivot.Rotation)

                                for v147, v148 in t9 do
                                    v147.Transparency = v148 + (1 - v148) * Value
                                end

                                if Value > 0.4 then
                                    Value = CurtainCountdown2
                                    Value.Enabled = false
                                    Value = CurtainRevealed
                                    Value.Enabled = false
                                end
                            else
                                v9:Destroy()
                            end
                        end

                        local v149, v150, v151, v152, v153

                        if n1 >= 0.65 and n1 < 3.15 then
                            if not v131 then
                                v131 = true
                                clone.Parent = v7
                                Audio.Play("rbxassetid://79252278894180", Pivot2.Position, {
                                    MaxDistance = 1000,
                                    Volume = 1.5
                                })
                            end

                            v142 = (n1 - 0.65) / 1.65
                            Quad = math.clamp(v142, 0, 1)
                            v140 = Enum.EasingStyle.Cubic
                            v142 = Enum.EasingDirection.Out
                            Value = TweenService:GetValue(math.clamp(Quad, 0, 1), v140, v142)
                            v140 = 1 - Value
                            v142 = Quad * 3.141592653589793 * 2 * 2.25
                            v149 = (n1 - 2.3) / 0.31999999999999984
                            v144 = math.clamp(v149, 0, 1)

                            if n1 >= 2.3 then
                                v144 *= 3.141592653589793
                                v143 = math.sin(v144)
                            else
                                v143 = 0
                            end

                            v141 = (n1 - 2.3) / 0.8500000000000001
                            v139 = math.clamp(v141, 0, 1) ^ 2
                            v151 = v139 * 2.4
                            v152 = n1 * 61
                            v149 = v151 * math.sin(v152)
                            v141 = v140 * 150 - v143 * 2.2

                            local v154 = v139 * 2.4

                            v150 = n1 * 47
                            v151 = v141 + v154 * math.sin(v150)
                            v152 = math.sin(v142) * 18 * v140
                            v153 = v139 * 2.4
                            v141 = v152 + v153 * math.sin(n1 * 53)
                            v144 = Vector3.new(v149, v151, v141)
                            v149 = CFrame.Angles
                            v153 = v142 + 0.6
                            v141 = math.sin(v153) * 0.3839724354387525 * v140
                            v154 = v139 * 0.08726646259971647
                            v150 = n1 * 57
                            v149 = v149(v141 + v154 * math.sin(v150), 0, 0)
                            v142 = Value * 0.5 + 0.5 + v143 * 0.1 + v139 * 0.12
                            v153 = (n1 - 2.72) / 0.2799999999999998
                            v154 = math.clamp(v153, 0, 1)
                            v152 = Enum.EasingStyle.Back

                            local Out = Enum.EasingDirection.Out

                            Value = TweenService:GetValue(math.clamp(v154, 0, 1), v152, Out) * -3.5779249665883754
                            placeEnvelope(CFrame.new(Pivot2.Position + v144) * v149 * Pivot2.Rotation, v142, Value)
                        elseif n1 >= 3.15 and clone.Parent ~= nil then
                            if not v132 then
                                v132 = true

                                for _, descendant in clone:GetDescendants() do
                                    if descendant:IsA("Beam") then
                                        descendant.Enabled = false
                                    elseif descendant:IsA("ParticleEmitter") then
                                        descendant.Enabled = false
                                        descendant:Clear()
                                    end
                                end

                                burstEffects(Pivot2)
                            end

                            v142 = (n1 - 3.15) / 0.14000000000000012
                            v140 = math.clamp(v142, 0, 1)
                            Value = (n1 - 3.22) / 1.3000000000000003
                            v142 = math.clamp(Value, 0, 1)
                            v149 = Enum.EasingStyle.Quad
                            v151 = Enum.EasingDirection.Out

                            local v156 = TweenService:GetValue(math.clamp(v140, 0, 1), v149, v151) * 0.15 + 0.12

                            v149 = Enum.EasingStyle.Quad
                            v151 = Enum.EasingDirection.Out
                            v140 = v156 * (1 - TweenService:GetValue(math.clamp(v142, 0, 1), v149, v151))
                            v144 = v142 * 0 * (1 - v142) - v142 * 70 * v142
                            v156 = Vector3.new(0, v144, 0)
                            v151 = Enum.EasingStyle.Quad
                            v141 = Enum.EasingDirection.Out
                            v139 = v156 + Vector3.new(14, 0, 0) * TweenService:GetValue(math.clamp(v142, 0, 1), v151, v141)
                            v156 = CFrame.Angles(v142 ^ 1.5 * 0.9599310885968813, v142 * 0.6981317007977318, 0)
                            placeEnvelope(CFrame.new(Pivot2.Position + v139) * v156 * Pivot2.Rotation, (v140 + 1) * (v142 * -0.25 + 1), -3.5779249665883754)
                            Value = (v142 - 0.05) / 0.95
                            v156 = math.clamp(Value, 0, 1)

                            for v157, v158 in t10 do
                                v157.Transparency = v158 + (1 - v158) * v156
                            end

                            if v142 >= 1 then
                                clone:Destroy()
                            end
                        end

                        if n1 >= 3.2 then
                            if not v133 then
                                v133 = true
                                v100:ScaleTo(Scale3 * 0.35)
                                v100.Parent = v7
                            end

                            v142 = (n1 - 3.2) / 1.6000000000000005
                            v140 = math.clamp(v142, 0, 1)
                            Quad = Enum.EasingStyle.Back
                            v142 = Enum.EasingDirection.Out
                            Value = TweenService:GetValue(math.clamp(v140, 0, 1), Quad, v142)
                            v142 = Enum.EasingStyle.Sine
                            v143 = Enum.EasingDirection.InOut
                            v144 = TweenService:GetValue(math.clamp(v140, 0, 1), v142, v143)
                            v149 = v140 * 3.141592653589793 * 2.5
                            v142 = math.sin(v149) * 0.12217304763960307 * (1 - v140)
                            v151 = n1
                            v150 = v151 - 3.2
                            v143 = Pivot3:Lerp(wobbleAt(Pivot3, (math.max(0, v150))), v144)
                            v149 = (v140 - 0) / 0.5
                            v144 = math.clamp(v149, 0, 1)
                            v149 = Enum.EasingStyle.Quad
                            v151 = Enum.EasingDirection.Out
                            v141 = TweenService:GetValue(math.clamp(v144, 0, 1), v149, v151)
                            v151 = (v140 - 0.5) / 0.5
                            v149 = math.clamp(v151, 0, 1)
                            v151 = Enum.EasingStyle.Back

                            local InOut = Enum.EasingDirection.InOut

                            v139 = (v141 - TweenService:GetValue(math.clamp(v149, 0, 1), v151, InOut)) * 65
                            v144 = Value * 0.65 + 0.35
                            v140 = CFrame.new(v143.Position + Vector3.new(0, v139, 0)) * CFrame.Angles(v142, 0, 0) * v143.Rotation
                            v100:ScaleTo(Scale3 * v144)
                            v100:PivotTo(v140)
                        end

                        if n1 >= 4.7 then
                            local v159 = n1

                            v151 = v159 - 3.2
                            v140 = wobbleAt(Pivot3, (math.max(0, v151))) * v110
                            v149 = v159 - 3.2

                            local v160 = v140 * floatAt((math.max(0, v149)))

                            v159 = v160.Position + Vector3.new(-16, 18, 0)

                            if not v134 then
                                v134 = true
                                Audio.Play("rbxassetid://93743867394761", Pivot4.Position, {
                                    MaxDistance = 1000,
                                    Volume = 1.5
                                })
                                v101:ScaleTo(Scale4 * 0.35)
                                v101:PivotTo(CFrame.new(Pivot4.Position + Vector3.new(160, 210, 330)) * CFrame.Angles(0, 12.566370614359172, 0) * Pivot4.Rotation)
                                v101.Parent = v7
                                v109()
                                v136, v137 = attachEmblemTrail()

                                if v136 ~= nil then
                                    v140 = v136
                                    v140.CFrame = CFrame.new(v101:GetPivot().Position)
                                    v140 = v136
                                    v140.Parent = v7
                                end
                            end

                            if n1 < 5.800000000000001 then
                                v144 = (n1 - 4.7) / 1.1000000000000005
                                Value = math.clamp(v144, 0, 1)
                                v143 = Enum.EasingStyle.Quad
                                v144 = Enum.EasingDirection.Out
                                v149 = TweenService:GetValue(math.clamp(Value, 0, 1), v143, v144)
                                v143 = 1 - v149
                                v144 = Pivot4.Position + Vector3.new(160, 210, 330) * v143 ^ 3 + Vector3.new(-180, 780, -840) * v143 ^ 2 * v149 + Vector3.new(-330, 90, -420) * v143 * v149 ^ 2 + (v159 - Pivot4.Position) * v149 ^ 3
                                v141 = Enum.EasingStyle.Cubic
                                v152 = Enum.EasingDirection.Out
                                v143 = (1 - TweenService:GetValue(math.clamp(Value, 0, 1), v141, v152)) * 12.566370614359172
                                v141 = Value * 3.141592653589793

                                local v161 = math.sin(v141) * -0.6108652381980153

                                v101:ScaleTo(Scale4 * (v149 * 0.7700000000000001 + 0.35))
                                v101:PivotTo(CFrame.new(v144) * CFrame.Angles(v161, v143, 0) * v160.Rotation)
                            elseif n1 < 6.0600000000000005 then
                                v149 = (n1 - 5.800000000000001) / 0.2599999999999998
                                v144 = math.clamp(v149, 0, 1)
                                Value = Enum.EasingStyle.Sine

                                local Out = Enum.EasingDirection.Out

                                v149 = TweenService:GetValue(math.clamp(v144, 0, 1), Value, Out)
                                v101:ScaleTo(Scale4 * 1.12 * (v149 * 0.04 + 1))
                                v151 = CFrame.new
                                v153 = v149 * 3
                                v101:PivotTo(v151(v159 + Vector3.new(0, v153, 0)) * CFrame.Angles(0, 0, v149 * -0.17453292519943295) * v160.Rotation)
                            elseif n1 < 6.19 then
                                v149 = (n1 - 6.0600000000000005) / 0.1299999999999999
                                v144 = math.clamp(v149, 0, 1)
                                Value = Enum.EasingStyle.Quad

                                local Out = Enum.EasingDirection.In

                                v149 = TweenService:GetValue(math.clamp(v144, 0, 1), Value, Out)
                                v142 = v159 + Vector3.new(0, 3, 0)
                                v101:ScaleTo(Scale4 * (v149 * -0.16480000000000006 + 1.1648))
                                v101:PivotTo(CFrame.new(v142:Lerp(v160.Position, v149)) * CFrame.Angles(0, 0, (1 - v149) * -0.17453292519943295) * v160.Rotation)
                            else
                                if not v135 then
                                    v135 = true
                                    landEmblem(v101, v136, v137)
                                    v136 = nil
                                    v137 = nil
                                end

                                v144 = (n1 - 6.19) / 0.3200000000000003
                                Value = math.clamp(v144, 0, 1)
                                v144 = Enum.EasingStyle.Back
                                v149 = Enum.EasingDirection.Out
                                v142 = 1 - TweenService:GetValue(math.clamp(Value, 0, 1), v144, v149)
                                v101:ScaleTo(Scale4 * (v142 * 0.14 + 1))
                                v151 = CFrame.new
                                v152 = v160.Position
                                v150 = v142 * 2.5
                                v101:PivotTo(v151(v152 - Vector3.new(0, v150, 0)) * v160.Rotation)
                            end

                            if v136 ~= nil then
                                local Position = v101:GetPivot().Position

                                v160 = Position - v136.Position

                                if v160.Magnitude > 0.05 then
                                    v138 = CFrame.lookAt(Vector3.new(0, 0, 0), v160.Unit)
                                end

                                v140 = v136
                                v140.CFrame = CFrame.new(Position) * v138
                            end
                        end

                        if not (n1 >= 6.9) then
                            return
                        end

                        connection:Disconnect()
                        BindableEvent:Fire()
                    end)
                    v10:Add(connection)
                    BindableEvent.Event:Wait()
                    BindableEvent:Destroy()

                    if v9.Parent ~= nil then
                        v9:Destroy()
                    end

                    if clone.Parent ~= nil then
                        clone:Destroy()
                    end

                    if v136 ~= nil then
                        v136:Destroy()
                    end

                    v100:ScaleTo(Scale3)

                    local v162 = n1

                    v100:PivotTo((wobbleAt(Pivot3, (math.max(0, v162 - 3.2)))))
                    v101:ScaleTo(Scale4)

                    local v164 = n1

                    v101:PivotTo(wobbleAt(Pivot3, (math.max(0, v164 - 3.2))) * v110 * floatAt((math.max(0, v164 - 3.2))))
                    v108()
                    v109()
                    startWobble(v100, v101, n1 - 3.2, Pivot3, v110)
                end

                local function clearFinale() -- line: 1239
                    -- upvalues: v11 (copy), t4 (copy)
                    if #t4 == 0 then
                        return
                    end

                    v11:Clean()

                    for _, v168 in t4 do
                        v168:Destroy()
                    end

                    table.clear(t4)
                end

                local function ensureBanner() -- line: 1251
                    -- upvalues: v7 (copy), v9 (ref), Plane2 (ref), CurtainCountdown2 (ref), CurtainRevealed (ref), Timer (ref), clone (copy), v10 (copy), v11 (copy), wobbleAt (copy), floatAt (copy), RunService (copy), Workspace (copy), ConcertReveal (copy)
                    if v9.Parent ~= nil then
                        return
                    end

                    v9 = v10:Add(clone:Clone())
                    Plane2 = v9:WaitForChild("Plane")
                    CurtainCountdown2 = Plane2:WaitForChild("CurtainCountdown")
                    CurtainRevealed = Plane2:WaitForChild("CurtainRevealed")
                    Timer = CurtainCountdown2:WaitForChild("Timer")
                    CurtainCountdown2.Enabled = true
                    CurtainRevealed.Enabled = false

                    local Timer2 = Timer
                    local v171 = math.max(0, (math.floor(ConcertReveal.RevealAt() - Workspace:GetServerTimeNow())))
                    local v172 = v171 // 86400
                    local v173 = v171 // 3600 % 24
                    local v174 = v171 // 60 % 60

                    Timer2.Text = string.format("%dD %02d:%02d:%02d", v172, v173, v174, v171 % 60)
                    v9.Parent = v7

                    local v175 = v9

                    v11:Clean()

                    local Pivot = v175:GetPivot()
                    local v176 = os.clock() - 0
                    local RenderStepped = RunService.RenderStepped
                    local v177, v178

                    v11:Connect(RenderStepped, function() -- line: 365
                        -- upvalues: v175 (copy), Pivot (copy), v176 (copy), v177 (copy), v178 (copy), wobbleAt (copy), floatAt (copy), Workspace (copy)
                        local CurrentCamera = Workspace.CurrentCamera

                        if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - Pivot.Position).Magnitude > 900 then
                            return
                        end

                        local v179 = os.clock() - v176
                        local v180 = wobbleAt(Pivot, v179)

                        v175:PivotTo(v180)

                        if v177 ~= nil and v178 ~= nil then
                            v177:PivotTo(v180 * v178 * floatAt(v179))
                        end
                    end)
                end

                local function runSequence(p53) -- line: 1269
                    -- upvalues: t2 (copy), v13 (ref), playReveal (copy), clearFinale (copy), ensureBanner (copy)
                    while v13 do
                        task.wait()
                    end

                    v13 = true

                    for _, v181 in t2 do
                        v181()
                    end

                    clearFinale()
                    ensureBanner()
                    task.wait(p53)
                    playReveal()
                    v13 = false
                end

                local function awaitInRange() -- line: 1286
                    -- upvalues: v9 (ref), Workspace (copy)
                    local Position = v9:GetPivot().Position

                    while true do
                        local CurrentCamera = Workspace.CurrentCamera

                        if CurrentCamera == nil then
                            task.wait(0.5)
                            continue
                        end

                        if (CurrentCamera.CFrame.Position - Position).Magnitude <= 900 then
                            break
                        end

                        task.wait(0.5)
                    end
                end

                local function beginReveal(p54) -- line: 1298
                    -- upvalues: v12 (ref), runSequence (copy), awaitInRange (copy), Remotes (copy)
                    if v12 then
                        return
                    end

                    v12 = true
                    awaitInRange()
                    runSequence(p54)

                    local function v182() -- line: 313
                        -- upvalues: Remotes (copy)
                        Remotes.ConcertReveal.FlagSeen:InvokeServer()
                    end

                    pcall(v182)
                end

                local function refreshCountdown() -- line: 1309
                    -- upvalues: CurtainCountdown2 (ref), CurtainRevealed (ref), Timer (ref), Workspace (copy), ConcertReveal (copy)
                    local v183 = Workspace:GetServerTimeNow() >= ConcertReveal.RevealAt()

                    CurtainCountdown2.Enabled = true
                    CurtainRevealed.Enabled = false

                    local Timer2 = Timer
                    local v186 = math.max(0, (math.floor(ConcertReveal.RevealAt() - Workspace:GetServerTimeNow())))
                    local v187 = v186 // 86400
                    local v188 = v186 // 3600 % 24
                    local v189 = v186 // 60 % 60

                    Timer2.Text = string.format("%dD %02d:%02d:%02d", v187, v188, v189, v186 % 60)

                    return v183
                end

                local function startCountdown() -- line: 1319
                    -- upvalues: CurtainCountdown2 (ref), CurtainRevealed (ref), Timer (ref), v10 (copy), v12 (ref), runSequence (copy), awaitInRange (copy), beginReveal (copy), Workspace (copy), ConcertReveal (copy), Remotes (copy)
                    local v190 = Workspace:GetServerTimeNow() >= ConcertReveal.RevealAt()

                    CurtainCountdown2.Enabled = true
                    CurtainRevealed.Enabled = false

                    local Timer2 = Timer
                    local v193 = math.max(0, (math.floor(ConcertReveal.RevealAt() - Workspace:GetServerTimeNow())))
                    local v194 = v193 // 86400
                    local v195 = v193 // 3600 % 24
                    local v196 = v193 // 60 % 60

                    Timer2.Text = string.format("%dD %02d:%02d:%02d", v194, v195, v196, v193 % 60)

                    if v190 then
                        v10:Add(task.spawn(beginReveal, 1.2))
                    else
                        v10:Add(task.spawn(function() -- line: 1325
                            -- upvalues: CurtainCountdown2 (ref), CurtainRevealed (ref), Timer (ref), v12 (ref), runSequence (copy), awaitInRange (copy), Workspace (copy), ConcertReveal (copy), Remotes (copy)
                            repeat
                                task.wait(1 - Workspace:GetServerTimeNow() % 1)

                                if v12 then
                                    break
                                end

                                local v197 = Workspace:GetServerTimeNow() >= ConcertReveal.RevealAt()

                                CurtainCountdown2.Enabled = true
                                CurtainRevealed.Enabled = false

                                local Timer2 = Timer
                                local v200 = math.max(0, (math.floor(ConcertReveal.RevealAt() - Workspace:GetServerTimeNow())))
                                local v201 = v200 // 86400
                                local v202 = v200 // 3600 % 24
                                local v203 = v200 // 60 % 60

                                Timer2.Text = string.format("%dD %02d:%02d:%02d", v201, v202, v203, v200 % 60)
                            until v197

                            if v12 then
                                return
                            end

                            v12 = true
                            awaitInRange()
                            runSequence(0.15)

                            local function v204() -- line: 313
                                -- upvalues: Remotes (copy)
                                Remotes.ConcertReveal.FlagSeen:InvokeServer()
                            end

                            pcall(v204)
                        end))
                    end
                end

                local function popIn() -- line: 1334
                    -- upvalues: v9 (ref), v11 (copy), t2 (copy), t3 (copy), wobbleAt (copy), floatAt (copy), playPoof (copy), startCountdown (copy), RunService (copy), TweenService (copy), Workspace (copy)
                    local elapsed = os.clock()
                    local Pivot = v9:GetPivot()
                    local Scale = v9:GetScale()
                    local v205 = v9

                    v11:Clean()

                    local Pivot2 = v205:GetPivot()
                    local v206 = os.clock() - 0
                    local RenderStepped = RunService.RenderStepped
                    local v207, v208

                    v11:Connect(RenderStepped, function() -- line: 365
                        -- upvalues: v205 (copy), Pivot2 (copy), v206 (copy), v207 (copy), v208 (copy), wobbleAt (copy), floatAt (copy), Workspace (copy)
                        local CurrentCamera = Workspace.CurrentCamera

                        if CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - Pivot2.Position).Magnitude > 900 then
                            return
                        end

                        local v209 = os.clock() - v206
                        local v210 = wobbleAt(Pivot2, v209)

                        v205:PivotTo(v210)

                        if v207 ~= nil and v208 ~= nil then
                            v207:PivotTo(v210 * v208 * floatAt(v209))
                        end
                    end)

                    local v211 = v9

                    v211:ScaleTo(Scale * 0.05)

                    local v212 = v9

                    v212:PivotTo(CFrame.new(Pivot.Position + Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0.03615802939698666, 0.026907620592115246) * Pivot.Rotation)

                    for _, v213 in t2 do
                        v213()
                    end

                    playPoof()
                    startCountdown()

                    while true do
                        local v215 = math.min(1, (os.clock() - elapsed) / 0.75)
                        local v216 = v9
                        local Back = Enum.EasingStyle.Back
                        local Out = Enum.EasingDirection.Out

                        v216:ScaleTo(Scale * math.max(0.05, TweenService:GetValue(math.clamp(v215, 0, 1), Back, Out) * 0.95 + 0.05))

                        if v215 >= 1 then
                            break
                        end

                        RunService.RenderStepped:Wait()
                    end

                    v9:ScaleTo(Scale)

                    for _, v218 in t3 do
                        v218()
                    end
                end

                local function awaitFirstTreadmill() -- line: 1365
                    -- upvalues: BaseUpgrade (copy), Save (copy)
                    if Save.Await().BaseUpgradeLevel > 0 then
                        return
                    end

                    local BindableEvent = Instance.new("BindableEvent")
                    local connection = Save.Watch("BaseUpgradeLevel"):Connect(function(p55) -- line: 1372
                        -- upvalues: BindableEvent (copy)
                        if p55 > 0 then
                            BindableEvent:Fire()
                        end
                    end)

                    BindableEvent.Event:Wait()
                    connection:Disconnect()
                    BindableEvent:Destroy()

                    if BaseUpgrade.Transition.IsPlaying() then
                        BaseUpgrade.Transition.Completed:Wait()
                    end

                    task.wait(2.5)
                end

                hideSign()
                v10:Add(task.spawn(function() -- line: 1394
                    -- upvalues: awaitRevealAssets (copy), ContentProvider (copy)
                    local v219 = awaitRevealAssets()

                    local function v220() -- line: 1396
                        -- upvalues: v219 (copy), ContentProvider (copy)
                        ContentProvider:PreloadAsync({
                            v219
                        })
                    end

                    pcall(v220)
                end))
                v10:Add(task.spawn(function() -- line: 1401
                    -- upvalues: ContentProvider (copy)
                    local function v221() -- line: 1402
                        -- upvalues: ContentProvider (copy)
                        ContentProvider:PreloadAsync({
                            "rbxassetid://124899059042473",
                            "rbxassetid://79252278894180",
                            "rbxassetid://85887503985998",
                            "rbxassetid://93743867394761",
                            "rbxassetid://77791314689160"
                        })
                    end

                    pcall(v221)
                end))
                v10:Connect(Remotes.ConcertReveal.Replay.OnClientEvent, function() -- line: 1413
                    -- upvalues: runSequence (copy)
                    task.spawn(runSequence, 1.2)
                end)

                if not game:IsLoaded() then
                    game.Loaded:Wait()
                end

                if LocalPlayer.Character == nil then
                    LocalPlayer.CharacterAdded:Wait()
                end

                awaitFirstTreadmill()
                task.wait(1.5)

                if Workspace:GetServerTimeNow() >= ConcertReveal.RevealAt() then
                    local function v222() -- line: 305
                        -- upvalues: Remotes (copy)
                        return Remotes.ConcertReveal.FetchSeen:InvokeServer()
                    end

                    local ok, result = pcall(v222)

                    if ok and result == true then
                        showFinale()

                        return
                    end
                end

                popIn()
            end
        end
    end
}
