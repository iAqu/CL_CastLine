-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local LeaveCutscene = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("LeaveCutscene")
local HarpoonDive = ReplicatedStorage.Remotes:WaitForChild("HarpoonDive")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local VFXBurst = require(Modules:WaitForChild("VFXBurst"))
local VFX = ReplicatedStorage:WaitForChild("VFX")
local WaterBoom = VFX:WaitForChild("WaterBoom")
local Splash = VFX:WaitForChild("Splash")
local Leviathan = ReplicatedStorage:WaitForChild("Cinematics"):WaitForChild("Leviathan")
local CineFX = PlayerGui:WaitForChild("CineFX")
local Plots = workspace:WaitForChild("Plots")
local _ = {
    JUMP = "rbxassetid://126105529228330",
    SPLASH = "rbxassetid://83673781452193"
}
local t1 = {
    MUSIC = 72995265072887,
    MUSIC_LEAD = 1.2,
    END_LEAD = 3,
    ROAR_AFTER = 0.35,
    VOLUME = 1.6,
    NEAR = 40,
    FAR = 1000,
    ROARS = { "rbxassetid://108022440433249", "rbxassetid://73766323948093", "rbxassetid://89752769132407", "rbxassetid://105692784988636" },
    PITCH = { 0.98, 1.02 },
    EVERY = { 3, 6 },
    EQ = {
        HIGH = -10,
        MID = -2,
        LOW = 2
    },
    REVERB = {
        DECAY = 2.2,
        WET = -8
    },
    HOOK_PITCH = { 1.5, 1.5 }
}
local t2 = {
    BREATH = 1.6,
    OFF = 22,
    RANGE = 60,
    COLOR = Color3.fromRGB(110, 120, 255),
    LIGHTS = { "Spine_06" },
    BRIGHT = { 3, 5 },
    HALO = {
        TEX = "rbxassetid://14204497474",
        SIZE = 32,
        RATE = 6,
        LIFE = 0.6,
        ALPHA = 0.6,
        BONES = { "Spine_04", "Spine_09" }
    }
}
local _ = {
    VOLUME = 0.35,
    SPEED = 0.9,
    PEAK = 0.3,
    PERIOD = 1.4,
    EASE = 2
}
local _ = {
    LEN = 72,
    BOOM = 2.4,
    SPLASH = 1.8,
    BIG = 2.6
}
local t3 = {
    BAR = 0.11,
    BAR_TIME = 0.5,
    STREAKS = 44,
    SHAKE_FREQ = 14,
    ROAR = {
        SHAKE = 3.2,
        EASE = 12,
        FLOOR = 100
    }
}
local t4 = {
    PUSH = {
        TIME = 3.4,
        D0 = 130,
        D1 = 40,
        FOV0 = 30,
        ELEV = 16
    },
    BREACH = {
        TIME = 3.8,
        LOW = -90,
        APEX = 95,
        R = 32,
        RISE = 82,
        HANG = 0.42,
        BACK = 75,
        FOV = 70
    },
    SPRINT = {
        DIST = 26,
        GAP = 4,
        TIME = 1.5,
        LATE = 6,
        SPEED = 34,
        FOV = 72
    },
    LEAP = {
        SIDE = 30,
        UP = 8,
        FOV = 72,
        MAX = 5
    },
    DESCENT = {
        SIDE = 24,
        UP = 4,
        FOV = 74,
        MAX = 14
    }
}
local t5 = {
    HOLD = 1,
    CAM = {
        UP = 10,
        DIST = 90,
        FOLLOW = 8,
        SURFACE = 30,
        FOV = 70
    },
    RISE = {
        FROM = 330,
        SPEED = 120,
        OFF = 2
    },
    AIR = {
        APEX = 72,
        R = 26,
        SLOW = 0.35
    }
}
local v1 = false
local v2 = false
local t6 = {}
local Drivers = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("FishRenderController"):WaitForChild("Drivers")
local t7 = {
    fightHooked = function() -- fightHooked | line: 174
        return false
    end,
    attr = function(p1, p2) -- attr | line: 175
        return p1:GetAttribute(p2)
    end
}

for _, v3 in ipairs({ "EelSwim", "HydraSwim", "EelDart" }) do
    local function result() -- line: 178
        -- upvalues: t6 (copy), Drivers (copy), t7 (copy), v3 (copy)
        require(Drivers:WaitForChild(v3))(t6, t7)
    end

    local ok

    ok, result = pcall(result)

    if not ok then
        warn("[LeaveCutscene] driver " .. v3 .. ": " .. tostring(result))
    end
end

local function bodyOf(p3) -- line: 184
    return p3.PrimaryPart or p3:FindFirstChildWhichIsA("BasePart")
end

local function legendary(p4) -- line: 190
    -- upvalues: LocalPlayer (copy), t2 (copy)
    local v4 = p4.PrimaryPart or p4:FindFirstChildWhichIsA("BasePart")

    if not v4 then
        return nil
    end

    local COLOR = t2.COLOR
    local t8 = {
        model = p4,
        body = v4,
        lights = {},
        emitters = {}
    }
    local AnatomyInverse = p4:GetAttribute("AnatomyInverse")
    local UpVector = typeof(AnatomyInverse) == "CFrame" and (p4:GetPivot() * AnatomyInverse:Inverse()).UpVector or v4.CFrame.UpVector

    for _, v5 in ipairs(t2.LIGHTS) do
        local v6 = v4:FindFirstChild(v5, true)

        if v6 then
            for _, v7 in ipairs({ 1, -1 }) do
                local Bone = Instance.new("Bone")

                Bone.Name = "LegendLight"
                Bone.CFrame = CFrame.new(v6.WorldCFrame:VectorToObjectSpace(UpVector * v7 * t2.OFF))
                Bone.Parent = v6

                local PointLight = Instance.new("PointLight")
                local RANGE = t2.RANGE
                local v8 = LocalPlayer:GetAttribute("Potato") ~= true

                PointLight.Color = COLOR
                PointLight.Range = RANGE
                PointLight.Shadows = v8
                PointLight.Brightness = 0
                PointLight.Enabled = false
                PointLight.Parent = Bone
                table.insert(t8.lights, PointLight)
            end
        end
    end

    local HALO = t2.HALO

    for _, v9 in ipairs(HALO.BONES) do
        local v10 = v4:FindFirstChild(v9, true)

        if v10 then
            local ParticleEmitter = Instance.new("ParticleEmitter")

            ParticleEmitter.Texture = HALO.TEX
            ParticleEmitter.Color = ColorSequence.new(COLOR)
            ParticleEmitter.LightEmission = 1
            ParticleEmitter.LockedToPart = true
            ParticleEmitter.Speed = NumberRange.new(0)
            ParticleEmitter.Rate = HALO.RATE
            ParticleEmitter.Lifetime = NumberRange.new(HALO.LIFE)
            ParticleEmitter.Rotation = NumberRange.new(0, 360)
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, HALO.SIZE * 0.8),
                NumberSequenceKeypoint.new(0.5, HALO.SIZE),
                NumberSequenceKeypoint.new(1, HALO.SIZE * 0.9)
            })
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.35, HALO.ALPHA),
                NumberSequenceKeypoint.new(1, 1)
            })
            ParticleEmitter.Enabled = false
            ParticleEmitter.Parent = v10
            table.insert(t8.emitters, ParticleEmitter)
        end
    end

    return t8
end

local function stepLegend(p5) -- line: 237
    -- upvalues: t2 (copy)
    local body = p5.body
    local v11 = (1 - body.Transparency) * (1 - body.LocalTransparencyModifier)
    local v13 = 0.5 - math.cos(os.clock() * 3.141592653589793 * 2 / t2.BREATH) * 0.5
    local v14 = (t2.BRIGHT[1] + (t2.BRIGHT[2] - t2.BRIGHT[1]) * v13) * v11

    for _, v15 in ipairs(p5.lights) do
        v15.Brightness = v14
        v15.Enabled = v14 > 0.01
    end

    local v16 = v11 > 0.5

    for _, v17 in ipairs(p5.emitters) do
        v17.Enabled = v16
    end
end

local v18 = CFrame.new((Vector3.new(50, 20000, 0)))

local function park(p6) -- line: 256
    -- upvalues: v18 (copy)
    p6.model:PivotTo(v18)

    if not p6.parked then
        p6.parked = {}

        for _, descendant in ipairs(p6.model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                p6.parked[descendant] = {
                    descendant.LocalTransparencyModifier,
                    descendant.CanQuery,
                    descendant.CanTouch,
                    descendant.CanCollide
                }
                descendant.LocalTransparencyModifier = 1
                descendant.CanQuery = false
                descendant.CanTouch = false
                descendant.CanCollide = false
            elseif descendant:IsA("Decal") then
                p6.parked[descendant] = { descendant.LocalTransparencyModifier }
                descendant.LocalTransparencyModifier = 1
            end
        end
    end

    if p6.look then
        for _, v19 in ipairs(p6.look.lights) do
            v19.Enabled = false
        end

        for _, v20 in ipairs(p6.look.emitters) do
            v20.Enabled = false
        end
    end
end

local function unpark(p7) -- line: 275
    if p7.parked then
        for v21, v22 in pairs(p7.parked) do
            if v21:IsA("BasePart") then
                local v23 = v22[1]
                local v24 = v22[2]
                local v25 = v22[3]
                local v26 = v22[4]

                v21.LocalTransparencyModifier = v23
                v21.CanQuery = v24
                v21.CanTouch = v25
                v21.CanCollide = v26
                continue
            end

            v21.LocalTransparencyModifier = v22[1]
        end

        p7.parked = nil
    end
end

local function newPuppet() -- line: 287
    -- upvalues: Leviathan (copy), t6 (copy), legendary (copy), v18 (copy)
    local clone = Leviathan:Clone()

    clone:PivotTo(v18)
    clone.Parent = workspace

    local v27 = legendary(clone)
    local result

    if t6.EelDart then
        local register = t6.EelDart.register
        local ok

        ok, result = pcall(register, clone)

        if not ok then
            result = nil
        end
    end

    return {
        model = clone,
        state = result,
        look = v27,
        ainv = clone:GetAttribute("AnatomyInverse") or CFrame.identity
    }
end

local v28

local function takePuppet() -- line: 301
    -- upvalues: unpark (copy), newPuppet (copy), v28 (ref)
    local v29 = v28 or newPuppet()

    v28 = nil
    unpark(v29)

    return v29
end

local function posePuppet(p8, p9, p10, p11, p12) -- line: 309
    -- upvalues: t6 (copy), stepLegend (copy)
    if p10.Magnitude < 1E-04 then
        return
    end

    local Unit = p10.Unit
    local v30 = p11 - Unit * p11:Dot(Unit)

    if v30.Magnitude < 0.001 then
        v30 = Vector3.new(0, 0, 1) - Unit * Unit.Z
    end

    local Unit2 = v30.Unit

    p8.model:PivotTo(CFrame.new(p9) * CFrame.fromMatrix(Vector3.new(0, 0, 0), Unit, Unit2) * p8.ainv)

    if p8.state then
        local update = t6.EelDart.update
        local state = p8.state

        pcall(update, state, p12)
    end

    if p8.look then
        stepLegend(p8.look)
    end
end

local function newArch(p13, p14, p15, p16, p17, p18) -- line: 326
    local v31 = math.rad(p18)
    local v33 = Vector3.new(p13.X, p16 - p17, p13.Z)
    local v34 = v33 - p14 * (p17 * math.sin(v31)) + Vector3.new(0, 1, 0) * (p17 * math.cos(v31))
    local v35 = v33 + p14 * (p17 * math.sin(v31)) + Vector3.new(0, 1, 0) * (p17 * math.cos(v31))
    local v36 = (v34.Y - p15) / math.sin(v31)
    local v37 = v31 * 2 * p17

    return function(p19) -- at | line: 334
        -- upvalues: p14 (copy), p17 (copy), v31 (copy), v33 (copy), v34 (copy), v35 (copy), v36 (copy), v37 (copy)
        if p19 < v36 then
            local v38 = p14 * math.cos(v31) + Vector3.new(0, 1, 0) * math.sin(v31)

            return v34 - v38 * (v36 - p19), v38, Vector3.new(0, 1, 0) * math.cos(v31) - p14 * math.sin(v31)
        end

        if p19 <= v36 + v37 then
            local v39 = v31 - (p19 - v36) / p17
            local v40 = Vector3.new(0, 1, 0) * math.cos(v39) - p14 * math.sin(v39)

            return v33 + v40 * p17, p14 * math.cos(v39) + Vector3.new(0, 1, 0) * math.sin(v39), v40
        end

        local v41 = p14 * math.cos(v31) - Vector3.new(0, 1, 0) * math.sin(v31)

        return v35 + v41 * (p19 - v36 - v37), v41, Vector3.new(0, 1, 0) * math.cos(v31) + p14 * math.sin(v31)
    end, 2 * v36 + v37, v36
end

local CurrentCamera = workspace.CurrentCamera
local v42
local n1 = 0
local n2 = 0
local n3 = 0
local n4 = 0
local v43 = t3.ROAR.FLOOR
local n5 = 0
local t10 = {}

for i = 1, t3.STREAKS do
    local clone = CineFX:WaitForChild("Streak"):Clone()

    clone.Parent = CineFX:WaitForChild("Streaks")
    t10[i] = {
        f = clone,
        ang = math.random() * 3.141592653589793 * 2,
        r = math.random(),
        speed = 0.9 + math.random() * 0.9
    }
end

local function setShot(p20) -- line: 363
    -- upvalues: v42 (ref), n1 (ref)
    v42 = p20
    n1 = os.clock()
end

local function kick(p21) -- line: 367
    -- upvalues: n3 (ref)
    n3 = math.max(n3, p21)
end

local function flash(p22, p23) -- line: 370
    -- upvalues: TweenService (copy), CineFX (copy)
    local Flash = CineFX:WaitForChild("Flash")

    Flash.BackgroundTransparency = 1 - p22
    TweenService:Create(Flash, TweenInfo.new(p23, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play()
end

local function bars(p24) -- line: 375
    -- upvalues: TweenService (copy), CineFX (copy), t3 (copy)
    local v45 = TweenInfo.new(t3.BAR_TIME, Enum.EasingStyle.Quart, p24 and Enum.EasingDirection.Out or Enum.EasingDirection.In)

    TweenService:Create(CineFX.BarTop, v45, {
        Position = UDim2.fromScale(0.5, p24 and t3.BAR or 0)
    }):Play()
    TweenService:Create(CineFX.BarBottom, v45, {
        Position = UDim2.fromScale(0.5, p24 and 1 - t3.BAR or 1)
    }):Play()
end

local function sound(p25, p26, p27) -- line: 380
    -- upvalues: SoundService (copy), Debris (copy)
    local Sound = Instance.new("Sound")

    Sound.SoundId = p25
    Sound.Volume = p26 or 1

    if p27 then
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Transparency = 1
        Part.Size = Vector3.new(1, 1, 1)
        Part.Position = p27
        Part.Parent = workspace
        Sound.RollOffMaxDistance = 800
        Sound.Parent = Part
        Debris:AddItem(Part, 12)
    else
        Sound.Parent = SoundService
        Debris:AddItem(Sound, 12)
    end

    Sound:Play()
end

local function burst(p28, p29, p30, p31) -- line: 400
    -- upvalues: VFXBurst (copy), sound (copy)
    local function v46() -- line: 401
        -- upvalues: p28 (copy), p29 (copy), p30 (copy), VFXBurst (copy)
        VFXBurst.Play(p28, CFrame.new(p29), p30)
    end

    local v47 = pcall(v46)

    if p31 then
        sound(p31, 1.4, p29)
    end

    return v47
end

local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://130131630350027"
Sound.Parent = SoundService

local v48 = "off"
local elapsed

local function musicIn() -- line: 414
    -- upvalues: TweenService (copy), LocalPlayer (copy), t1 (copy), Sound (copy), v48 (ref), elapsed (ref)
    if v48 ~= "pending" then
        return
    end

    v48 = "on"
    elapsed = os.clock()
    LocalPlayer:SetAttribute("MusicDuck", nil)
    LocalPlayer:SetAttribute("MusicTrack", t1.MUSIC)

    if Sound.IsPlaying and not Sound.Looped then
        local tween = TweenService:Create(Sound, TweenInfo.new(t1.MUSIC_LEAD, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Volume = 0
        })

        tween.Completed:Once(function() -- line: 423
            -- upvalues: Sound (copy)
            if not Sound.Looped then
                Sound:Stop()
            end
        end)
        tween:Play()
    end
end

local function visitOver() -- line: 428
    -- upvalues: LocalPlayer (copy), v48 (ref)
    v48 = "off"
    LocalPlayer:SetAttribute("MusicTrack", nil)
    LocalPlayer:SetAttribute("Dread", nil)
end

local v49 = false

local function warm() -- line: 435
    -- upvalues: LocalPlayer (copy), Sound (copy), v49 (ref)
    local v50 = LocalPlayer:GetAttribute("LeaveReady") == true

    if not v50 or v49 then
        if not v50 and v49 and Sound.Looped then
            v49 = false
            Sound.Looped = false
            Sound:Stop()
        end
    else
        v49 = true
        Sound.Looped = true
        Sound.Volume = 1E-04
        Sound:Play()
    end
end

LocalPlayer:GetAttributeChangedSignal("LeaveReady"):Connect(warm)

local LeaveReady = LocalPlayer:GetAttribute("LeaveReady") == true

if not LeaveReady or v49 then
    if not LeaveReady and v49 and Sound.Looped then
        v49 = false
        Sound.Looped = false
        Sound:Stop()
    end
else
    v49 = true
    Sound.Looped = true
    Sound.Volume = 1E-04
    Sound:Play()
end

local function roar(p32) -- line: 450
    -- upvalues: RunService (copy), LocalPlayer (copy), t1 (copy), Sound (copy), v48 (ref), musicIn (copy)
    local elapsed = os.clock()

    Sound.Looped = false
    Sound.TimePosition = 0
    Sound.Volume = p32

    if not Sound.IsPlaying then
        Sound:Play()
    end

    LocalPlayer:SetAttribute("MusicDuck", 0)
    v48 = "pending"

    if RunService:IsStudio() then
        task.spawn(function() -- line: 459
            -- upvalues: elapsed (copy), RunService (copy), Sound (copy)
            while true do
                if Sound.IsPlaying and os.clock() - elapsed < 2 then
                    if Sound.PlaybackLoudness > 5 then
                        break
                    end

                    RunService.Heartbeat:Wait()
                    continue
                end

                return
            end

            print(("[LeaveCutscene] the roar was heard %.3f s after the press, %.2f s into its file (ROAR_SKIP)"):format(os.clock() - elapsed, Sound.TimePosition))
        end)
    end

    task.spawn(function() -- line: 469
        -- upvalues: t1 (copy), Sound (copy), musicIn (copy)
        if not Sound.IsLoaded then
            Sound.Loaded:Wait()
        end

        task.wait((math.max(0, Sound.TimeLength - 0 - t1.MUSIC_LEAD)))
        musicIn()
    end)
end

local function splash(p33, p34) -- line: 475
    -- upvalues: VFXBurst (copy), WaterBoom (copy), Splash (copy), n3 (ref), flash (copy), sound (copy)
    if p34 then
        local n6 = 6.24

        local function v52() -- line: 401
            -- upvalues: p33 (copy), n6 (copy), VFXBurst (copy), WaterBoom (copy)
            VFXBurst.Play(WaterBoom, CFrame.new(p33), n6)
        end

        pcall(v52)
        sound("rbxassetid://126105529228330", 1.4, p33)

        local n7 = 2.8080000000000003

        local function v53() -- line: 401
            -- upvalues: p33 (copy), n7 (copy), VFXBurst (copy), Splash (copy)
            VFXBurst.Play(Splash, CFrame.new(p33), n7)
        end

        pcall(v53)
        n3 = math.max(n3, 4)
    else
        local n8 = 5.1480000000000015

        local function v55() -- line: 401
            -- upvalues: p33 (copy), n8 (copy), VFXBurst (copy), Splash (copy)
            VFXBurst.Play(Splash, CFrame.new(p33), n8)
        end

        pcall(v55)
        sound("rbxassetid://83673781452193", 1.4, p33)

        local n9 = 5.304

        local function v56() -- line: 401
            -- upvalues: p33 (copy), n9 (copy), VFXBurst (copy), WaterBoom (copy)
            VFXBurst.Play(WaterBoom, CFrame.new(p33), n9)
        end

        pcall(v56)
        n3 = math.max(n3, 5)
        flash(0.35, 0.45)
    end

    task.delay(0.12, function() -- line: 486
        -- upvalues: p33 (copy), VFXBurst (copy), WaterBoom (copy)
        local n10 = 3.7439999999999998

        local function v58() -- line: 401
            -- upvalues: n10 (copy), p33 (copy), VFXBurst (copy), WaterBoom (copy)
            VFXBurst.Play(WaterBoom, CFrame.new(p33), n10)
        end

        pcall(v58)
    end)
end

local _ = {
    SHOW = 0.5,
    DIST = 120
}

local function warmUp() -- line: 503
    -- upvalues: RunService (copy), ContentProvider (copy), LocalPlayer (copy), VFXBurst (copy), WaterBoom (copy), Splash (copy), Leviathan (copy), CineFX (copy), t1 (copy), v2 (ref), park (copy), newPuppet (copy), v28 (ref), posePuppet (copy), CurrentCamera (copy), Sound (copy)
    if LocalPlayer:GetAttribute("LeaveReady") ~= true or v28 then
        return
    end

    local t13 = {
        Leviathan,
        WaterBoom,
        Splash,
        CineFX,
        Sound,
        "rbxassetid://126105529228330",
        "rbxassetid://83673781452193",
        "rbxassetid://" .. t1.MUSIC
    }

    for _, v59 in ipairs(t1.ROARS) do
        table.insert(t13, v59)
    end

    local function v60() -- line: 507
        -- upvalues: t13 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t13)
    end

    pcall(v60)

    if v28 or v2 then
        return
    end

    v28 = newPuppet()
    LocalPlayer:SetAttribute("Warm_LeaveCutscene", false)

    if not LocalPlayer:GetAttribute("LoadingDone") then
        local _CFrame = CurrentCamera.CFrame
        local v61 = _CFrame.Position + _CFrame.LookVector * 120

        posePuppet(v28, v61, _CFrame.RightVector, Vector3.new(0, 1, 0), 0.016666666666666666)

        local n11 = 2.4

        local function v62() -- line: 401
            -- upvalues: v61 (copy), n11 (copy), VFXBurst (copy), WaterBoom (copy)
            VFXBurst.Play(WaterBoom, CFrame.new(v61), n11)
        end

        pcall(v62)

        local n12 = 1.8

        local function v63() -- line: 401
            -- upvalues: v61 (copy), n12 (copy), VFXBurst (copy), Splash (copy)
            VFXBurst.Play(Splash, CFrame.new(v61), n12)
        end

        pcall(v63)

        local elapsed = os.clock()

        while os.clock() - elapsed < 0.5 do
            RunService.Heartbeat:Wait()
        end
    end

    park(v28)
    LocalPlayer:SetAttribute("Warm_LeaveCutscene", true)
end

task.spawn(function() -- line: 525
    -- upvalues: LocalPlayer (copy), warmUp (copy)
    if LocalPlayer:GetAttribute("LeaveReady") == nil then
        LocalPlayer:GetAttributeChangedSignal("LeaveReady"):Wait()
    end

    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end

    warmUp()
end)

local function smooth(p35) -- line: 531
    return p35 * p35 * (3 - 2 * p35)
end

local function stepStreaks(p36, p37) -- line: 533
    -- upvalues: CineFX (copy), n5 (ref), t10 (copy)
    local AbsoluteSize = CineFX.AbsoluteSize
    local v64 = p37 > 0.02

    for _, v65 in ipairs(t10) do
        v65.f.Visible = v64

        if v64 then
            v65.r += v65.speed * p36 * (0.6 + p37 * 1.6 + n5 * 1.4)

            if v65.r > 1.3 then
                v65.r = 0.18 + math.random() * 0.25
                v65.ang = math.random() * 3.141592653589793 * 2
            end

            local v66 = math.cos(v65.ang)
            local v67 = math.sin(v65.ang)

            v65.f.Position = UDim2.fromOffset(AbsoluteSize.X / 2 + v66 * v65.r * AbsoluteSize.X * 0.6, AbsoluteSize.Y / 2 + v67 * v65.r * AbsoluteSize.Y * 0.6)
            v65.f.Rotation = math.deg(v65.ang)
            v65.f.Size = UDim2.fromScale(0.08 + 0.2 * p37 + n5 * 0.14, 0.004 + 0.004 * p37)
            v65.f.BackgroundTransparency = 1 - p37 * 0.95 * math.clamp((v65.r - 0.12) * 4, 0, 1)
        end
    end
end

local function onRender(p38) -- line: 553
    -- upvalues: LocalPlayer (copy), t3 (copy), CurrentCamera (copy), v42 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), v43 (ref), Sound (copy), stepStreaks (copy)
    if not v42 then
        return
    end

    local v70, v71 = v42(os.clock() - n1, p38)
    local PlaybackLoudness = Sound.IsPlaying and Sound.PlaybackLoudness or 0

    v43 = math.max(v43, PlaybackLoudness)
    n4 += (PlaybackLoudness / v43 - n4) * (1 - math.exp(-t3.ROAR.EASE * p38))
    n3 += (n2 + n4 * t3.ROAR.SHAKE - n3) * (1 - math.exp(-5 * p38))

    local v81 = if LocalPlayer:GetAttribute("SetReduceFx") == true then 0 else math.rad(n3)
    local v83 = os.clock() * t3.SHAKE_FREQ

    CurrentCamera.CFrame = v70 * CFrame.Angles(math.noise(v83, 0.3) * v81, math.noise(v83, 7.1) * v81, math.noise(v83, 13.7) * v81 * 0.6)
    CurrentCamera.FieldOfView = v71
    stepStreaks(p38, n4)
end

local function myHarpoon() -- line: 570
    -- upvalues: LocalPlayer (copy), Plots (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child:FindFirstChild("Harpoon"), child
        end
    end

    return nil
end

local function flat(p39) -- line: 576
    return (Vector3.new(p39.X, 0, p39.Z))
end

local function planLand(p40, p41) -- line: 581
    -- upvalues: LocalPlayer (copy), t4 (copy)
    local StandPoint = p40:FindFirstChild("StandPoint")
    local Character = LocalPlayer.Character
    local v85 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v86 = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (StandPoint and v85 and v86) then
        return nil
    end

    local v87 = StandPoint.Position - Vector3.new(50, 0, 0)
    local v88 = Vector3.new(v87.X, 0, v87.Z)
    local v89 = v88.Magnitude > 1 and v88.Unit or Vector3.new(0, 0, 1)
    local SpawnPoint = p41 and p41:FindFirstChild("SpawnPoint")
    local v90 = v89

    if SpawnPoint then
        local v91 = SpawnPoint.Position - StandPoint.Position

        v90 = Vector3.new(v91.X, 0, v91.Z) or v89
    end

    v89 = v90.Magnitude > 1 and v90.Unit or v89

    local v92 = RaycastParams.new()

    v92.FilterType = Enum.RaycastFilterType.Exclude
    v92.FilterDescendantsInstances = { Character }

    local function standing(p42) -- line: 595
        -- upvalues: StandPoint (copy), v92 (copy), v85 (copy), v86 (copy)
        local v93 = workspace:Raycast(p42 + Vector3.new(0, 40, 0), Vector3.new(0, -120, 0), v92)

        return (Vector3.new(p42.X, (v93 and v93.Position.Y or StandPoint.Position.Y) + v86.HipHeight + v85.Size.Y / 2, p42.Z))
    end

    local v95 = StandPoint.Position + v89 * t4.SPRINT.GAP
    local v96 = workspace:Raycast(v95 + Vector3.new(0, 40, 0), Vector3.new(0, -120, 0), v92)
    local v98 = Vector3.new(v95.X, (v96 and v96.Position.Y or StandPoint.Position.Y) + v86.HipHeight + v85.Size.Y / 2, v95.Z)
    local v99 = StandPoint.Position + v89 * t4.SPRINT.DIST
    local v100 = workspace:Raycast(v99 + Vector3.new(0, 40, 0), Vector3.new(0, -120, 0), v92)

    return {
        start = Vector3.new(v99.X, (v100 and v100.Position.Y or StandPoint.Position.Y) + v86.HipHeight + v85.Size.Y / 2, v99.Z),
        from = CFrame.lookAt(v98, (Vector3.new(StandPoint.Position.X, v98.Y, StandPoint.Position.Z))),
        diveAt = workspace:GetServerTimeNow() + t4.PUSH.TIME + t4.BREACH.TIME + 0.5 + t4.SPRINT.TIME
    }
end

local t15 = {}
local t16 = {}
local t17 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}

local function sweepGuis() -- line: 611
    -- upvalues: PlayerGui (copy), CineFX (copy), t15 (copy)
    for _, child in ipairs(PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child ~= CineFX and child.Enabled then
            t15[child] = true
            child.Enabled = false
        end
    end
end

local function hideHud() -- line: 619
    -- upvalues: StarterGui (copy), t16 (copy), t17 (copy), sweepGuis (copy)
    sweepGuis()

    for _, v102 in ipairs(t17) do
        local function v103() -- line: 622
            -- upvalues: v102 (copy), StarterGui (copy)
            return StarterGui:GetCoreGuiEnabled(v102)
        end

        local ok, result = pcall(v103)

        if ok then
            t16[v102] = result

            local function v104() -- line: 625
                -- upvalues: v102 (copy), StarterGui (copy)
                StarterGui:SetCoreGuiEnabled(v102, false)
            end

            pcall(v104)
        end
    end
end

local function showHud() -- line: 629
    -- upvalues: StarterGui (copy), t15 (copy), t16 (copy)
    for v105 in pairs(t15) do
        if v105.Parent then
            v105.Enabled = true
        end
    end

    table.clear(t15)

    for v106, v107 in pairs(t16) do
        local function v108() -- line: 634
            -- upvalues: v106 (copy), v107 (copy), StarterGui (copy)
            StarterGui:SetCoreGuiEnabled(v106, v107)
        end

        pcall(v108)
    end

    table.clear(t16)
end

local ContextActionService = game:GetService("ContextActionService")

local function controls(p43) -- line: 643
    -- upvalues: LocalPlayer (copy), ContextActionService (copy)
    if p43 then
        ContextActionService:UnbindAction("LeaveCutsceneBlock")
    else
        ContextActionService:BindActionAtPriority("LeaveCutsceneBlock", function() -- line: 647
            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value + 1000, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump)
    end

    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local v109 = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule", true)

    if v109 then
        local function v110() -- line: 654
            -- upvalues: p43 (copy), v109 (copy)
            local Controls = require(v109):GetControls()

            if p43 then
                Controls:Enable()
            else
                Controls:Disable()
            end
        end

        pcall(v110)
    end
end

local function setCharacterShown(p44) -- line: 661
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character then
        for _, descendant in ipairs(Character:GetDescendants()) do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                if p44 then
                    descendant.LocalTransparencyModifier = 0
                else
                    descendant.LocalTransparencyModifier = descendant.LocalTransparencyModifier
                end
            end
        end
    end
end

local n13 = 0

local function waitFor(p45, p46) -- line: 671
    -- upvalues: RunService (copy), n13 (ref)
    local elapsed = os.clock()

    while true do
        if p45() then
            return true
        end

        if p46 < os.clock() - elapsed or os.clock() > n13 then
            break
        end

        RunService.Heartbeat:Wait()
    end

    return false
end

local function waitTime(p47) -- line: 679
    -- upvalues: RunService (copy), n13 (ref)
    local elapsed = os.clock()

    while os.clock() - elapsed < p47 and os.clock() <= n13 do
        RunService.Heartbeat:Wait()
    end
end

local function landCutscene(p48, p49) -- line: 685
    -- upvalues: LocalPlayer (copy), t4 (copy), unpark (copy), newPuppet (copy), v28 (ref), posePuppet (copy), newArch (copy), v42 (ref), n1 (ref), n2 (ref), n3 (ref), n5 (ref), flash (copy), splash (copy), setCharacterShown (copy), waitFor (copy), waitTime (copy)
    local StandPoint = p48:FindFirstChild("StandPoint")
    local Character = LocalPlayer.Character
    local v111 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v112 = Character and Character:FindFirstChildOfClass("Humanoid")

    if not (StandPoint and v111 and v112 and p49) then
        return
    end

    local v113 = StandPoint.Position - Vector3.new(50, 0, 0)
    local v114 = Vector3.new(v113.X, 0, v113.Z)
    local v115 = v114.Magnitude > 1 and v114.Unit or Vector3.new(0, 0, 1)
    local Unit = v115:Cross((Vector3.new(0, 1, 0))).Unit

    CFrame.fromMatrix(Vector3.new(50, 0, 0), Unit, (Vector3.new(0, 1, 0)))

    local PUSH = t4.PUSH
    local v116 = math.rad(PUSH.ELEV)
    local Unit2 = (v115 * math.cos(v116) + Vector3.new(0, 1, 0) * math.sin(v116)).Unit
    local v118 = PUSH.D0 * math.tan(math.rad(PUSH.FOV0) / 2)

    local function vertigo(p50) -- line: 702
        -- upvalues: v118 (copy)
        return math.deg((math.atan(v118 / p50))) * 2
    end

    n2 = 0

    v42 = function(p51) -- line: 704
        -- upvalues: PUSH (copy), Unit2 (copy), v118 (copy), n2 (ref), n5 (ref)
        local v122 = math.clamp(p51 / PUSH.TIME, 0, 1)
        local v123 = v122 * v122 * (3 - 2 * v122)
        local v124 = PUSH.D0 + (PUSH.D1 - PUSH.D0) * v123

        n2 = 0.6 + 1.6 * v123
        n5 = v123

        return CFrame.lookAt(Vector3.new(50, 4, 0) + Unit2 * v124, (Vector3.new(50, 4, 0))), math.deg((math.atan(v118 / v124))) * 2
    end

    n1 = os.clock()
    n3 = math.max(n3, 4.5)
    waitTime(PUSH.TIME)
    n5 = 0

    local BREACH = t4.BREACH
    local v129 = v28 or newPuppet()

    v28 = nil
    unpark(v129)
    LocalPlayer:SetAttribute("Dread", 1)

    local v130, v131 = newArch(Vector3.new(50, 0, 0), Unit, BREACH.LOW, BREACH.APEX, BREACH.R, BREACH.RISE)
    local v132 = Vector3.new(50, 4, 0)
    local v133 = false
    local v136 = math.deg((math.atan(v118 / PUSH.D1))) * 2

    v42 = function(p52, p53) -- line: 724
        -- upvalues: PUSH (copy), Unit2 (copy), BREACH (copy), v129 (copy), v130 (copy), v131 (copy), v132 (ref), v133 (ref), v136 (copy), posePuppet (copy), n2 (ref), splash (copy)
        local v138 = math.clamp(p52 / BREACH.TIME, 0, 1)
        local v140 = (v138 + BREACH.HANG * math.sin(6.283185307179586 * v138) / 6.283185307179586) * v131
        local v141, v142, v143 = v130(v140)

        posePuppet(v129, v141, v142, v143, p53)

        local v144 = v130(v140 + 32.4)
        local v145 = v144.Y > 0

        if v145 ~= v133 then
            splash(Vector3.new(v144.X, 0, v144.Z), v145)
            v133 = v145
        end

        v132 = v132:Lerp(v141 + v142 * 72 * 0.15, 1 - math.exp(-10 * p53))

        local v150 = 1 - math.abs(v140 / v131 - 0.5) * 2
        local v152 = math.clamp(p52 / 0.9, 0, 1)
        local v153 = v152 * v152 * (3 - 2 * v152)

        n2 = v150 * 1.2 + 0.8

        local v156 = Vector3.new(50, 4, 0) + Unit2 * (PUSH.D1 + (BREACH.BACK - PUSH.D1) * v153) + Vector3.new(0, 12 * v153, 0)

        return CFrame.lookAt(v156, v132), v136 + (BREACH.FOV - v136) * v153
    end

    n1 = os.clock()
    waitTime(BREACH.TIME + 0.5)
    v129.model:Destroy()
    flash(0.9, 0.35)

    local start, from = p49.start, p49.from

    waitFor(function() -- line: 749
        -- upvalues: LocalPlayer (copy)
        return not LocalPlayer:GetAttribute("LocalEating")
    end, 1)
    v111.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

    local lookAt = CFrame.lookAt
    local X2 = StandPoint.Position.X
    local Y = start.Y
    local Z2 = StandPoint.Position.Z

    v111.CFrame = lookAt(start, (Vector3.new(X2, Y, Z2)))

    local WalkSpeed = v112.WalkSpeed > 0 and v112.WalkSpeed or game:GetService("StarterPlayer").CharacterWalkSpeed

    task.delay(0.3, function() -- line: 754
        -- upvalues: v112 (copy), t4 (copy)
        if v112.Parent then
            v112.WalkSpeed = t4.SPRINT.SPEED
        end
    end)
    v112:MoveTo(from.Position)

    local v157

    v42 = function(p54, p55) -- line: 757
        -- upvalues: StandPoint (copy), v157 (ref), v111 (copy), t4 (copy), n2 (ref)
        local v158 = StandPoint.Position - v111.Position
        local v159 = Vector3.new(v158.X, 0, v158.Z)
        local v160 = v159.Magnitude > 0.5
        local Unit = if v160 then v159.Unit else nil

        if not v160 or not Unit then
            local LookVector = v111.CFrame.LookVector

            Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
        end

        local v161 = Unit:Cross((Vector3.new(0, 1, 0)))
        local v162 = CFrame.lookAt(v111.Position + Unit * 8 + v161 * 4 + Vector3.new(0, 1.4, 0), v111.Position + Vector3.new(0, 1.6, 0))
        local v163 = v157
        local v164 = if v163 then v157:Lerp(v162, 1 - math.exp(-8 * p55)) else nil

        if v163 and v164 then
            v162 = v164
        end

        v157 = v162
        n2 = math.abs((math.sin(p54 * 9))) * 0.25 + 0.5

        return v157, t4.SPRINT.FOV
    end

    n1 = os.clock()
    waitFor(function() -- line: 768
        -- upvalues: p49 (copy)
        return workspace:GetServerTimeNow() >= p49.diveAt
    end, t4.SPRINT.TIME + 1)

    if v112.Parent then
        v112.WalkSpeed = WalkSpeed
    end

    if not waitFor(function() -- line: 771
        -- upvalues: Character (copy)
        return Character:GetAttribute("DiveT0") ~= nil
    end, t4.SPRINT.LATE) then
        return
    end

    local DiveFrom = Character:GetAttribute("DiveFrom")

    if typeof(DiveFrom) == "CFrame" then
        v111.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        v111.CFrame = DiveFrom
    end

    v111.Anchored = true
    LocalPlayer:SetAttribute("AutoDive", false)
    LocalPlayer:SetAttribute("AutoDive", true)
    LocalPlayer:SetAttribute("AutoDive", nil)

    local DiveFrom2 = Character:GetAttribute("DiveFrom")
    local DiveTo = Character:GetAttribute("DiveTo")
    local v169, v170

    if typeof(DiveFrom2) == "CFrame" and typeof(DiveTo) == "CFrame" then
        local v171 = (DiveFrom2.Position + DiveTo.Position) / 2

        if v171 then
            v169 = v171
            v170 = true
        else
            v170 = false
        end
    else
        v170 = false
    end

    if not v170 then
        v169 = v111.Position
    end

    local v172, v173

    if typeof(DiveFrom2) == "CFrame" and typeof(DiveTo) == "CFrame" then
        local v174 = DiveTo.Position - DiveFrom2.Position
        local v175 = Vector3.new(v174.X, 0, v174.Z)

        if v175 then
            v172 = v175
            v173 = true
        else
            v173 = false
        end
    else
        v173 = false
    end

    if not v173 then
        v172 = v115
    end

    Unit = v172.Magnitude > 0.5 and v172.Unit:Cross((Vector3.new(0, 1, 0))) or Unit

    local v177 = v169 + Unit * t4.LEAP.SIDE + Vector3.new(0, t4.LEAP.UP, 0)
    local v178 = v111.Position

    v42 = function(_, p57) -- line: 791
        -- upvalues: v177 (copy), v178 (ref), v111 (copy), t4 (copy), n2 (ref)
        v178 = v178:Lerp(v111.Position, 1 - math.exp(-9 * p57))
        n2 = 0.4

        return CFrame.lookAt(v177, v178), t4.LEAP.FOV
    end

    n1 = os.clock()

    if waitFor(function() -- line: 796
        -- upvalues: v111 (copy)
        return v111.Position.Y < 0
    end, t4.LEAP.MAX) then
        n3 = math.max(n3, 2)
        flash(0.3, 0.3)
    end

    local v182

    v42 = function(_, p59) -- line: 803
        -- upvalues: p48 (copy), Unit (ref), v182 (ref), t4 (copy), n2 (ref), setCharacterShown (copy)
        local Position = p48:GetPivot().Position
        local v184 = CFrame.lookAt(Position + Unit * t4.DESCENT.SIDE + Vector3.new(0, t4.DESCENT.UP, 0), Position - Vector3.new(0, 6, 0))
        local v185 = v182
        local v186 = if v185 then v182:Lerp(v184, 1 - math.exp(-5 * p59)) else nil

        if v185 and v186 then
            v184 = v186
        end

        v182 = v184
        setCharacterShown(true)
        n2 = 0.35

        return v182, t4.DESCENT.FOV
    end

    n1 = os.clock()

    local v189

    waitFor(function() -- line: 813
        -- upvalues: p48 (copy), v189 (ref)
        local SinkT0 = p48:GetAttribute("SinkT0")
        local SinkTime = p48:GetAttribute("SinkTime")
        local SinkPop = p48:GetAttribute("SinkPop")

        if SinkT0 and SinkTime and SinkPop then
            v189 = SinkT0 + SinkTime + SinkPop
        end

        if p48:GetAttribute("Arrived") == true then
            return true
        end

        return v189 ~= nil and workspace:GetServerTimeNow() >= v189
    end, t4.DESCENT.MAX)
    waitTime(0.4)
end

local function seaCutscene(p60) -- line: 822
    -- upvalues: LocalPlayer (copy), t5 (copy), unpark (copy), newPuppet (copy), v28 (ref), posePuppet (copy), v42 (ref), n1 (ref), n2 (ref), n3 (ref), splash (copy), waitFor (copy)
    local Position = p60:GetPivot().Position
    local v190 = Position - Vector3.new(50, 0, 0)
    local v191 = Vector3.new(v190.X, 0, v190.Z)
    local Unit = v191.Magnitude > 1 and v191.Unit or Vector3.new(0, 0, 1)
    local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit
    local CAM, AIR = t5.CAM, t5.AIR
    local v192 = v28 or newPuppet()

    v28 = nil
    unpark(v192)
    LocalPlayer:SetAttribute("Dread", 1)

    local v193 = Vector3.new(50, 0, 0) + Unit2 * t5.RISE.OFF
    local v194 = Position.Y - t5.RISE.FROM
    local APEX, R = AIR.APEX, AIR.R
    local v196 = Vector3.new(v193.X, APEX - R, v193.Z)
    local v197 = v196 - Unit2 * (R * 1) + Vector3.new(0, 1, 0) * (R * 6.123233995736766E-17)
    local v198 = v196 + Unit2 * (R * 1) + Vector3.new(0, 1, 0) * (R * 6.123233995736766E-17)
    local v199 = (v197.Y - v194) / 1
    local v200 = 3.141592653589793 * R
    local n14 = 1.5707963267948966

    local function at(p61) -- line: 334
        -- upvalues: Unit2 (copy), R (copy), v196 (copy), v197 (copy), v198 (copy), v199 (copy), v200 (copy), n14 (copy)
        if p61 < v199 then
            local v201 = Unit2 * math.cos(n14) + Vector3.new(0, 1, 0) * math.sin(n14)

            return v197 - v201 * (v199 - p61), v201, Vector3.new(0, 1, 0) * math.cos(n14) - Unit2 * math.sin(n14)
        end

        if p61 <= v199 + v200 then
            local v202 = n14 - (p61 - v199) / R
            local v203 = Vector3.new(0, 1, 0) * math.cos(v202) - Unit2 * math.sin(v202)

            return v196 + v203 * R, Unit2 * math.cos(v202) + Vector3.new(0, 1, 0) * math.sin(v202), v203
        end

        local v204 = Unit2 * math.cos(n14) - Vector3.new(0, 1, 0) * math.sin(n14)

        return v198 + v204 * (p61 - v199 - v200), v204, Vector3.new(0, 1, 0) * math.cos(n14) + Unit2 * math.sin(n14)
    end

    local _ = 2 * v199 + v200
    local v205 = v199 + AIR.R * 3.141592653589793 / 2
    local v206 = Position.Y + CAM.UP
    local v207 = Vector3.new(50, v206, 0)
    local n15 = 0
    local v208 = false
    local v209

    v42 = function(_, p63) -- line: 841
        -- upvalues: Unit (copy), CAM (copy), AIR (copy), v192 (copy), at (copy), v205 (copy), v206 (copy), v207 (ref), n15 (ref), v208 (ref), v209 (ref), t5 (copy), posePuppet (copy), n2 (ref), splash (copy)
        local _, v210 = at(n15)
        local v211 = if at(n15 + 32.4).Y > 0 then p63 * (AIR.SLOW + (1 - AIR.SLOW) * math.abs(v210.Y)) else p63

        n15 += t5.RISE.SPEED * v211

        local v214, v215, v216 = at(n15)
        local v217 = at(n15 + 32.4)

        posePuppet(v192, v214, v215, v216, v211)

        local v218 = v217.Y > 0

        if v218 ~= v208 then
            splash(Vector3.new(v217.X, 0, v217.Z), v218)

            if not v218 then
                v209 = os.clock() + t5.HOLD
            end

            v208 = v218
        end

        n2 = math.abs(v215.Y) * 0.6 + 0.6

        local v219 = v214:Lerp(v217, 0.5)
        local v220 = n15 < v205 and v206 or 0 + CAM.SURFACE
        local v223 = Vector3.new(v219.X, math.max(v219.Y + CAM.DIST, v220), v219.Z)

        v207 = v207:Lerp(v223, 1 - math.exp(-CAM.FOLLOW * v211))

        return CFrame.lookAt(v207, v219, Unit), CAM.FOV
    end

    n1 = os.clock()
    n3 = math.max(n3, 4)
    waitFor(function() -- line: 867
        -- upvalues: v209 (ref)
        return v209 ~= nil and os.clock() >= v209
    end, 15)
    v192.model:Destroy()
end

local function fighting() -- line: 872
    -- upvalues: PlayerGui (copy)
    local ReelGui = PlayerGui:FindFirstChild("ReelGui")

    return ReelGui ~= nil and ReelGui.Enabled
end

local function note(p64) -- line: 878
    -- upvalues: RunService (copy)
    if RunService:IsStudio() then
        print("[LeaveCutscene] " .. p64)
    end
end

local function play() -- line: 882
    -- upvalues: RunService (copy), SoundService (copy), LocalPlayer (copy), PlayerGui (copy), LeaveCutscene (copy), HarpoonDive (copy), CineFX (copy), t1 (copy), t3 (copy), v1 (ref), v2 (ref), CurrentCamera (copy), v42 (ref), n2 (ref), n3 (ref), n4 (ref), n5 (ref), t10 (copy), bars (copy), v48 (ref), elapsed (ref), musicIn (copy), roar (copy), onRender (copy), myHarpoon (copy), planLand (copy), sweepGuis (copy), hideHud (copy), showHud (copy), ContextActionService (copy), controls (copy), n13 (ref), waitFor (copy), landCutscene (copy), seaCutscene (copy)
    local v227, v228 = myHarpoon()

    if v227 then
        local Character = LocalPlayer.Character

        if not Character or Character:GetAttribute("ReturnT0") then
            if RunService:IsStudio() then
                print("[LeaveCutscene] not played: no character, or leaping out of the water")
            end
        else
            local ReelGui = PlayerGui:FindFirstChild("ReelGui")
            local v229 = ReelGui ~= nil and ReelGui.Enabled

            if v229 then
                if RunService:IsStudio() then
                    print("[LeaveCutscene] not played: mid-fight")
                end
            elseif LocalPlayer:GetAttribute("Cinematic") then
                if RunService:IsStudio() then
                    print("[LeaveCutscene] not played: another cutscene is on")
                end
            elseif LocalPlayer:GetAttribute("TurkeyRun") ~= nil then
                if RunService:IsStudio() then
                    print("[LeaveCutscene] not played: the turkey run is on")
                end
            elseif LocalPlayer:GetAttribute("LeaveReady") then
                if LocalPlayer:GetAttribute("LoadingDone") then
                    v2 = true

                    local v231 = v227:GetAttribute("OccupantUserId") == LocalPlayer.UserId

                    roar(v231 and 3.75 or 3)

                    local v232 = not v231 and planLand(v227, v228) or nil

                    task.spawn(function() -- line: 904
                        -- upvalues: v232 (copy), LeaveCutscene (copy), HarpoonDive (copy)
                        local function v233() -- line: 905
                            -- upvalues: LeaveCutscene (copy)
                            return LeaveCutscene:InvokeServer("Start")
                        end

                        local ok, result = pcall(v233)

                        if ok and result and v232 then
                            HarpoonDive:FireServer({
                                t0 = v232.diveAt,
                                from = v232.from
                            })
                        end
                    end)
                    task.spawn(function() -- line: 912
                        -- upvalues: RunService (copy), v1 (ref)
                        local elapsed = os.clock()
                        local n16 = 0
                        local n17 = 0

                        repeat
                            local v234 = RunService.Heartbeat:Wait()

                            n17 += 1

                            if os.clock() - elapsed < 4 then
                                n16 = math.max(n16, v234)
                            end
                        until os.clock() - elapsed > 4 and not v1 or os.clock() - elapsed > 60

                        print(("[LeaveCutscene] longest frame in the first %d s after the press: %d ms; %.0f fps over the cutscene"):format(4, n16 * 1000, n17 / (os.clock() - elapsed)))
                    end)

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                    if Humanoid and LocalPlayer:GetAttribute("LocalEating") then
                        Humanoid.Jump = true
                    end

                    local v235

                    if v231 then
                        if v227:GetAttribute("Arrived") ~= true then
                            n13 = os.clock() + 12
                            waitFor(function() -- line: 931
                                -- upvalues: v227 (copy)
                                return v227:GetAttribute("Arrived") == true
                            end, 10)
                        end

                        v235 = "on the harpoon"
                    else
                        v235 = "on land"
                    end

                    local v236 = "playing (" .. v235 .. ")"

                    if RunService:IsStudio() then
                        print("[LeaveCutscene] " .. v236)
                    end

                    v1 = true
                    n13 = os.clock() + 45

                    local CameraType, FieldOfView = CurrentCamera.CameraType, CurrentCamera.FieldOfView

                    LocalPlayer:SetAttribute("Cinematic", true)
                    controls(false)
                    hideHud()
                    CineFX.Enabled = true
                    bars(true)
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    RunService:BindToRenderStep("LeaveCutscene", Enum.RenderPriority.Camera.Value + 5, onRender)

                    local v238 = task.spawn(function() -- line: 944
                        -- upvalues: v1 (ref), sweepGuis (copy)
                        while v1 do
                            sweepGuis()
                            task.wait(0.2)
                        end
                    end)

                    local function v239() -- line: 951
                        -- upvalues: v227 (copy), v231 (copy), v232 (copy), landCutscene (copy), seaCutscene (copy)
                        if v231 then
                            seaCutscene(v227)
                        else
                            landCutscene(v227, v232)
                        end
                    end

                    local ok, result = pcall(v239)

                    if not ok then
                        warn("[LeaveCutscene] " .. tostring(result))
                    end

                    v1 = false

                    local cancel = task.cancel

                    pcall(cancel, v238)
                    bars(false)
                    musicIn()
                    LocalPlayer:SetAttribute("MusicDuck", nil)
                    n4 = 0
                    n5 = 0
                    n2 = 0
                    n3 = 0

                    local _ = CineFX.AbsoluteSize

                    for _, v240 in ipairs(t10) do
                        v240.f.Visible = false
                    end

                    RunService:UnbindFromRenderStep("LeaveCutscene")
                    v42 = nil
                    LocalPlayer:SetAttribute("AutoDive", nil)

                    if v227:GetAttribute("OccupantUserId") ~= LocalPlayer.UserId then
                        CurrentCamera.CameraType = CameraType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or CameraType
                        CurrentCamera.FieldOfView = FieldOfView
                    end

                    LocalPlayer:SetAttribute("Cinematic", nil)
                    ContextActionService:UnbindAction("LeaveCutsceneBlock")

                    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
                    local v242 = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule", true)

                    if v242 then
                        local v243 = true

                        local function v244() -- line: 654
                            -- upvalues: v242 (copy), v243 (copy)
                            local Controls = require(v242):GetControls()

                            if v243 then
                                Controls:Enable()
                            else
                                Controls:Disable()
                            end
                        end

                        pcall(v244)
                    end

                    showHud()
                    task.delay(t3.BAR_TIME, function() -- line: 975
                        -- upvalues: CineFX (copy), v1 (ref)
                        if not v1 then
                            CineFX.Enabled = false
                        end
                    end)
                    LocalPlayer:SetAttribute("Dread", 1)

                    local MusicTrack = SoundService:FindFirstChild("MusicTrack")
                    local v245, v246

                    if MusicTrack and MusicTrack.TimeLength > 0 and elapsed then
                        local v247 = MusicTrack.TimeLength - (os.clock() - elapsed) - t1.END_LEAD

                        if v247 then
                            v245 = v247
                            v246 = true
                        else
                            v246 = false
                        end
                    else
                        v246 = false
                    end

                    if not v246 then
                        v245 = nil
                    end

                    local function v248() -- line: 981
                        -- upvalues: v245 (ref), LeaveCutscene (copy)
                        return LeaveCutscene:InvokeServer("Visit", v245)
                    end

                    local ok2, result2 = pcall(v248)

                    if not ok2 or not result2 then
                        v48 = "off"
                        LocalPlayer:SetAttribute("MusicTrack", nil)
                        LocalPlayer:SetAttribute("Dread", nil)
                    end
                elseif RunService:IsStudio() then
                    print("[LeaveCutscene] not played: still loading")
                end
            elseif RunService:IsStudio() then
                print("[LeaveCutscene] not played: had it already")
            end
        end
    elseif RunService:IsStudio() then
        print("[LeaveCutscene] not played: no plot / harpoon of mine")
    end
end

local function menuPressed(p65) -- line: 987
    -- upvalues: RunService (copy), v1 (ref), v2 (ref), play (copy)
    local v249 = p65 .. (if v1 then " (already playing)" elseif v2 then " (already had it)" else "")

    if RunService:IsStudio() then
        print("[LeaveCutscene] " .. v249)
    end

    if not v1 and not v2 and not game:GetService("Players").LocalPlayer:GetAttribute("TitanRiding") and game:GetService("Players").LocalPlayer:GetAttribute("TurkeyRun") == nil then
        task.spawn(play)
    end
end

GuiService.MenuOpened:Connect(function() -- line: 997
    -- upvalues: menuPressed (copy)
    menuPressed("menu opened")
end)
game:GetService("UserInputService").InputBegan:Connect(function(p66) -- line: 998
    -- upvalues: menuPressed (copy)
    if p66.KeyCode == Enum.KeyCode.Escape or p66.KeyCode == Enum.KeyCode.ButtonStart then
        menuPressed("menu key")
    end
end)

local v250
local t18 = {}
local n18 = (-1e999)
local n19 = 0

local function cry(p67, p68, p69, p70) -- line: 1007
    -- upvalues: t1 (copy), t18 (copy), n18 (ref), n19 (ref)
    local v251 = p67.PrimaryPart or p67:FindFirstChildWhichIsA("BasePart")

    if not v251 then
        return
    end

    n18 = os.clock()
    n19 = t1.EVERY[1] + math.random() * (t1.EVERY[2] - t1.EVERY[1])

    local Sound = Instance.new("Sound")

    Sound.SoundId = p68
    Sound.Volume = t1.VOLUME
    Sound.PlaybackSpeed = p69[1] + math.random() * (p69[2] - p69[1])
    Sound.RollOffMode = Enum.RollOffMode.Linear

    local NEAR, FAR = t1.NEAR, t1.FAR

    Sound.RollOffMinDistance = NEAR
    Sound.RollOffMaxDistance = FAR

    local EqualizerSoundEffect = Instance.new("EqualizerSoundEffect")
    local HIGH, MID, LOW = t1.EQ.HIGH, t1.EQ.MID, t1.EQ.LOW

    EqualizerSoundEffect.HighGain = HIGH
    EqualizerSoundEffect.MidGain = MID
    EqualizerSoundEffect.LowGain = LOW
    EqualizerSoundEffect.Parent = Sound

    local ReverbSoundEffect = Instance.new("ReverbSoundEffect")
    local DECAY, WET = t1.REVERB.DECAY, t1.REVERB.WET

    ReverbSoundEffect.DecayTime = DECAY
    ReverbSoundEffect.WetLevel = WET
    ReverbSoundEffect.Parent = Sound
    Sound.Parent = v251
    Sound:Play()

    if p70 then
        t18[Sound] = v251
    end

    Sound.Ended:Once(function() -- line: 1027
        -- upvalues: Sound (copy), t18 (copy)
        t18[Sound] = nil
        Sound:Destroy()
    end)
end

local t19 = {}
local clone, v252

local function buildPulse() -- line: 1037
    -- upvalues: SoundService (copy), PlayerGui (copy), clone (ref), v252 (ref)
    if v252 then
        return
    end

    local ReelGui = PlayerGui:FindFirstChild("ReelGui")
    local v253 = ReelGui and ReelGui:FindFirstChild("Beat", true)

    if v253 then
        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "LeviathanEdge"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ScreenInsets = Enum.ScreenInsets.None
        ScreenGui.Parent = PlayerGui
        clone = v253:Clone()
        clone.ImageTransparency = 1
        clone.Parent = ScreenGui
    end

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local HeartbeatLoop = HarpoonSFX and HarpoonSFX:FindFirstChild("HeartbeatLoop")

    v252 = HeartbeatLoop and HeartbeatLoop:Clone() or false

    if not v252 then
        return
    end

    v252.Volume = 0
    v252.PlaybackSpeed = 0.9
    v252.Parent = SoundService
end

local function whileVisiting() -- line: 1061
    -- upvalues: RunService (copy), LocalPlayer (copy), t1 (copy), stepLegend (copy), v250 (ref), t18 (copy), t19 (copy), clone (ref), v252 (ref), buildPulse (copy)
    buildPulse()

    if v252 then
        v252:Play()
    end

    local n20 = 0
    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function(p71) -- line: 1066
        -- upvalues: n20 (ref), elapsed (copy), connection (ref), LocalPlayer (copy), t1 (copy), stepLegend (copy), v250 (ref), t18 (copy), t19 (copy), clone (ref), v252 (ref)
        local v254 = LocalPlayer:GetAttribute("LeviathanVisit") == true
        local v255 = v250
        local Parent = v255 and v255.Parent and (v255.PrimaryPart or v255:FindFirstChildWhichIsA("BasePart"))
        local v256 = v254 and not (Parent and v255:GetAttribute("Hooked"))

        n20 += ((if v256 then 1 else 0) - n20) * (1 - math.exp(-2 * p71))

        local v261 = 0.5 - math.cos((os.clock() - elapsed) * 3.141592653589793 * 2 / 1.4) * 0.5

        if clone then
            clone.ImageTransparency = 1 - 0.3 * n20 * v261
        end

        if v252 then
            v252.Volume = 0.35 * n20
        end

        for v263, v264 in pairs(t19) do
            if v263.Parent then
                stepLegend(v264)
            else
                t19[v263] = nil
            end
        end

        for v265, v266 in pairs(t18) do
            if v265.Parent then
                v265.Volume = t1.VOLUME * (1 - v266.Transparency) * (1 - v266.LocalTransparencyModifier)
            else
                t18[v265] = nil
            end
        end

        if not v254 and n20 < 0.01 then
            connection:Disconnect()

            if clone then
                clone.ImageTransparency = 1
            end

            if v252 then
                v252:Stop()
            end
        end
    end)
end

LocalPlayer:GetAttributeChangedSignal("LeviathanVisit"):Connect(function() -- line: 1093
    -- upvalues: LocalPlayer (copy), v48 (ref), whileVisiting (copy)
    if LocalPlayer:GetAttribute("LeviathanVisit") then
        whileVisiting()
    else
        v48 = "off"
        LocalPlayer:SetAttribute("MusicTrack", nil)
        LocalPlayer:SetAttribute("Dread", nil)
    end
end)

local Fish = workspace:WaitForChild("Fish")

local function screen(p72) -- line: 1106
    -- upvalues: LocalPlayer (copy), t1 (copy), legendary (copy), v250 (ref), n18 (ref), n19 (ref), cry (copy), t19 (copy)
    local OnlyFor = p72:GetAttribute("OnlyFor")

    if OnlyFor then
        if OnlyFor == LocalPlayer.UserId then
            if not p72:GetAttribute("BaitId") and not p72:GetAttribute("Lucky") and not p72:GetAttribute("QuestFish") and not p72:GetAttribute("Turkey") then
                v250 = p72
                t19[p72] = legendary(p72)
                task.delay(t1.ROAR_AFTER, function() -- line: 1120
                    -- upvalues: p72 (copy), LocalPlayer (copy), t1 (copy), n18 (ref), n19 (ref), cry (copy)
                    if LocalPlayer:GetAttribute("LeviathanVisit") and p72.Parent and not p72:GetAttribute("Hooked") and os.clock() - n18 >= n19 then
                        cry(p72, t1.ROARS[math.random(#t1.ROARS)], t1.PITCH, true)
                    end
                end)
                p72:GetAttributeChangedSignal("Hooked"):Connect(function() -- line: 1126
                    -- upvalues: p72 (copy), t1 (copy), cry (copy)
                    if p72:GetAttribute("Hooked") then
                        cry(p72, t1.ROARS[math.random(#t1.ROARS)], t1.HOOK_PITCH)
                    end
                end)
            end
        else
            p72:Destroy()
        end
    end
end

for _, child in ipairs(Fish:GetChildren()) do
    screen(child)
end

Fish.ChildAdded:Connect(screen)
