-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local t1 = {
    scale = 1
}
local CurrentCamera = workspace.CurrentCamera
local n1 = 0
local n2 = 0
local t2
local t3 = {}
local t4
local v1 = false
local t5 = {
    linear = function(p1) -- linear | line: 23
        return p1
    end,
    inOut = function(p2) -- inOut | line: 26
        return -(math.cos(3.141592653589793 * p2) - 1) / 2
    end,
    out = function(p3) -- out | line: 29
        return 1 - (1 - p3) ^ 4
    end,
    snap = function(p4) -- snap | line: 32
        if p4 >= 1 then
            return 1
        end

        return 1 - 2 ^ (-10 * p4)
    end,
    ["in"] = function(p5) -- line: 35
        return p5 ^ 3
    end
}
local t6 = {
    start = 0,
    time = 1,
    fov0 = 50,
    fov1 = 50,
    roll0 = 0,
    roll1 = 0,
    follow = nil,
    focus = nil,
    handheld = 1,
    radius = 3,
    blend = 0,
    blendFov = 50,
    from = CFrame.identity,
    to = CFrame.identity,
    ease = t5.inOut,
    blendFrom = CFrame.identity
}
local v3 = CFrame.identity
local n3 = 50
local n4 = 0
local n5 = 0
local n6 = 0

function t1.now() -- line: 63
    -- upvalues: n1 (ref)
    return n1
end

function t1.rate() -- line: 68
    -- upvalues: t1 (copy), n2 (ref)
    if os.clock() < n2 then
        return 0
    end

    return t1.scale
end

function t1.hitstop(p6) -- line: 73
    -- upvalues: n2 (ref)
    local v4 = n2

    n2 = math.max(v4, os.clock() + p6)
end

function t1.slowmo(p7, p8) -- line: 78
    -- upvalues: t1 (copy), t2 (ref)
    if not p8 or p8 <= 0 then
        t2 = nil
        t1.scale = p7
    else
        t2 = {
            from = t1.scale,
            to = p7,
            start = os.clock(),
            time = p8
        }
    end
end

function t1.wait(p9) -- line: 88
    -- upvalues: RunService (copy), n1 (ref), v1 (ref)
    local v6 = n1 + p9

    while n1 < v6 and v1 do
        RunService.Heartbeat:Wait()
    end
end

function t1.during(p10, p11) -- line: 96
    -- upvalues: RunService (copy), n1 (ref), v1 (ref)
    local v7 = n1

    while n1 - v7 < p10 and v1 do
        local v8 = n1 - v7

        p11(v8, v8 / p10)
        RunService.Heartbeat:Wait()
    end

    p11(p10, 1)
end

local function setShot(p12) -- line: 118
    -- upvalues: n1 (ref), t5 (copy), t6 (copy), v3 (ref), n3 (ref)
    p12 = p12 or {}
    t6.start = n1
    t6.fov0 = p12.fov or 50
    t6.fov1 = p12.fov1 or t6.fov0
    t6.roll0 = p12.roll or 0
    t6.roll1 = p12.roll1 or t6.roll0
    t6.ease = t5[p12.ease or "inOut"]
    t6.focus = p12.focus
    t6.handheld = p12.handheld or 1
    t6.radius = p12.radius or 3
    t6.blend = p12.blend or 0

    local v10 = v3
    local v11 = n3

    t6.blendFrom = v10
    t6.blendFov = v11
end

function t1.cut(p13, p14) -- line: 134
    -- upvalues: t6 (copy), setShot (copy)
    setShot(p14)
    t6.follow = nil
    t6.from = p13
    t6.to = p13
    t6.time = 1
end

function t1.move(p15, p16, p17, p18) -- line: 141
    -- upvalues: t6 (copy), setShot (copy)
    setShot(p18)
    t6.follow = nil
    t6.from = p15
    t6.to = p16
    t6.time = p17
end

function t1.follow(p19, p20, p21) -- line: 148
    -- upvalues: t6 (copy), setShot (copy)
    setShot(p21)
    t6.follow = p19
    t6.time = p20 or 1
end

function t1.shake(p22) -- line: 155
    -- upvalues: n4 (ref)
    n4 = math.min(1, n4 + p22)
end

function t1.rumble(p23) -- line: 159
    -- upvalues: n5 (ref)
    n5 = p23
end

function t1.punch(p24) -- line: 164
    -- upvalues: n6 (ref)
    n6 += p24
end

local function noise(p25, p26) -- line: 168
    return math.noise(p25 + 0.37, p26)
end

local function render() -- line: 172
    -- upvalues: Lighting (copy), CurrentCamera (copy), n1 (ref), t6 (copy), v3 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref)
    local v13 = n1 - t6.start
    local v16 = t6.ease((math.clamp(v13 / t6.time, 0, 1)))
    local v17 = t6.roll0 + (t6.roll1 - t6.roll0) * v16
    local v18 = (if t6.follow then t6.follow(v13) else t6.from:Lerp(t6.to, v16)) * CFrame.Angles(0, 0, (math.rad(v17)))
    local v19 = t6.fov0 + (t6.fov1 - t6.fov0) * v16

    if v13 < t6.blend then
        local v21 = -(math.cos(3.141592653589793 * (v13 / t6.blend)) - 1) / 2

        v18 = t6.blendFrom:Lerp(v18, v21)
        v19 = t6.blendFov + (v19 - t6.blendFov) * v21
    end

    v3 = v18
    n3 = v19

    local elapsed = os.clock()
    local handheld = t6.handheld
    local Angles = CFrame.Angles
    local v22 = elapsed * 0.32
    local v24 = math.rad(math.noise(1.37, v22) * 1.1 * handheld)
    local v25 = elapsed * 0.27
    local v27 = Angles(v24, math.rad(math.noise(2.37, v25) * 1.4 * handheld), 0)
    local v30 = math.max(n4, n5) ^ 2
    local Angles2 = CFrame.Angles
    local v31 = elapsed * 24
    local v33 = math.rad(math.noise(3.37, v31) * 7 * v30)
    local v34 = elapsed * 24
    local v36 = math.rad(math.noise(4.37, v34) * 7 * v30)
    local v37 = elapsed * 24
    local v39 = Angles2(v33, v36, (math.rad(math.noise(5.37, v37) * 5 * v30)))

    CurrentCamera.CFrame = v18 * v27 * v39
    CurrentCamera.FieldOfView = math.clamp(v19 - n6, 8, 110)

    local DepthOfFieldEffect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")

    if not DepthOfFieldEffect then
        return
    end

    local focus = t6.focus

    if typeof(focus) == "Instance" then
        focus = focus.Position
    end

    if focus then
        DepthOfFieldEffect.FocusDistance = (focus - CurrentCamera.CFrame.Position).Magnitude
        DepthOfFieldEffect.InFocusRadius = t6.radius
        DepthOfFieldEffect.FarIntensity = 0.75
        DepthOfFieldEffect.NearIntensity = 0.6
    else
        DepthOfFieldEffect.FocusDistance = 0
        DepthOfFieldEffect.InFocusRadius = 500
        DepthOfFieldEffect.FarIntensity = 0.12
        DepthOfFieldEffect.NearIntensity = 0
    end
end

function t1.start() -- line: 210
    -- upvalues: Lighting (copy), RunService (copy), t1 (copy), CurrentCamera (copy), n1 (ref), n2 (ref), t2 (ref), t3 (copy), t4 (ref), v1 (ref), v3 (ref), n3 (ref), n4 (ref), n5 (ref), n6 (ref), render (copy)
    v1 = true
    n1 = 0
    n2 = 0
    n4 = 0
    n5 = 0
    n6 = 0
    t1.scale = 1
    t2 = nil

    local CFrame, FieldOfView = CurrentCamera.CFrame, CurrentCamera.FieldOfView

    v3 = CFrame
    n3 = FieldOfView
    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local DepthOfFieldEffect = Lighting:FindFirstChildOfClass("DepthOfFieldEffect")

    if DepthOfFieldEffect then
        t4 = {
            DepthOfFieldEffect,
            DepthOfFieldEffect.Enabled,
            DepthOfFieldEffect.FocusDistance,
            DepthOfFieldEffect.InFocusRadius,
            DepthOfFieldEffect.FarIntensity,
            DepthOfFieldEffect.NearIntensity
        }
        DepthOfFieldEffect.Enabled = true
    end

    table.insert(t3, RunService.Heartbeat:Connect(function(p27) -- line: 224
        -- upvalues: t1 (copy), n1 (ref), t2 (ref), n4 (ref), n6 (ref)
        if t2 then
            local v43 = math.clamp((os.clock() - t2.start) / t2.time, 0, 1)

            t1.scale = t2.from + (t2.to - t2.from) * (-(math.cos(3.141592653589793 * v43) - 1) / 2)

            if v43 >= 1 then
                t2 = nil
            end
        end

        n1 += p27 * t1.rate()

        local v48 = n4

        n4 = math.max(0, v48 - p27 * 1.6)
        n6 *= math.exp(-p27 * 7)
    end))
    RunService:BindToRenderStep("IntroCamera", Enum.RenderPriority.Camera.Value + 1, render)
end

function t1.stop() -- line: 240
    -- upvalues: RunService (copy), t1 (copy), t3 (copy), t4 (ref), v1 (ref)
    v1 = false

    local UnbindFromRenderStep = RunService.UnbindFromRenderStep

    pcall(UnbindFromRenderStep, RunService, "IntroCamera")

    for _, v52 in t3 do
        v52:Disconnect()
    end

    table.clear(t3)
    t1.scale = 1

    if not t4 then
        return
    end

    local v53 = t4[1]
    local v54, v55, v56, v57, v58 = table.unpack(t4, 2)

    v53.Enabled = v54
    v53.FocusDistance = v55
    v53.InFocusRadius = v56
    v53.FarIntensity = v57
    v53.NearIntensity = v58
    t4 = nil
end

return t1
