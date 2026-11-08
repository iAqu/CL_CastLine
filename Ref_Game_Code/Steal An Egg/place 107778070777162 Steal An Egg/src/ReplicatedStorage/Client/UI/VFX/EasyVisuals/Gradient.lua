-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local StopRamp = require(script.Parent.StopRamp)
local t = require(ReplicatedStorage.Packages.t)
local Heartbeat = RunService.Heartbeat
local t1 = {
    TextLabel = true,
    TextBox = true,
    TextButton = true
}
local t2 = {}

t2.__index = t2
t2.__class = "Gradient"

local v1 = t.strict(t.union(t.instanceIsA("GuiObject"), t.instanceIsA("UIStroke")))
local v2 = t.strict(t.number)
local v3 = t.strict(t.ColorSequence)
local v4 = t.strict(t.union(t.number, t.NumberSequence))

local function flatAlpha(p1) -- line: 84
    return NumberSequence.new({
        NumberSequenceKeypoint.new(0, p1),
        NumberSequenceKeypoint.new(1, p1)
    })
end

local function settle(p2) -- line: 91
    return (math.clamp(p2, 0, 1))
end

local function newSweep(p3) -- line: 95
    return {
        now = 0,
        goal = nil,
        rate = 0,
        rateGoal = 0,
        response = p3
    }
end

local function holdAt(p4, p5, p6) -- line: 99
    p4.goal = p5
    p4.rate = 0
    p4.rateGoal = 0
    p4.response = math.clamp(p6, 0, 1)
end

local function driftAt(p7, p8, p9) -- line: 106
    p7.rateGoal = p8
    p7.goal = nil
    p7.response = math.clamp(p9, 0, 1)
end

local function step(p10, p11) -- line: 112
    local goal = p10.goal

    if goal then
        p10.now += (goal - p10.now) * p10.response
    else
        p10.rate += (p10.rateGoal - p10.rate) * p10.response * p11
        p10.now += p10.rate * p11
    end

    return p10.now
end

local function borrowGradient(p12) -- line: 124
    local UIGradient = p12:FindFirstChildWhichIsA("UIGradient")

    if UIGradient then
        return UIGradient
    end

    return Instance.new("UIGradient")
end

local function release(p13) -- line: 132
    p13.driver:Disconnect()

    if p13.gradient then
        p13.gradient:Destroy()
        p13.gradient = nil
    end
end

local function resolvePalette(p14) -- line: 141
    -- upvalues: StopRamp (copy)
    local v5 = StopRamp.Drift(p14.palette.Keypoints, StopRamp.Colour, p14.phase.now, 5, 100)

    p14.paletteResolved = ColorSequence.new(v5)

    return p14.paletteResolved
end

local function resolveAlpha(p15) -- line: 153
    -- upvalues: StopRamp (copy)
    local Keypoints = p15.alphaStopsGoal.Keypoints

    if #Keypoints ~= 2 or Keypoints[1].Value ~= Keypoints[2].Value then
        local Keypoints = p15.alphaStops.Keypoints
        local v6 = StopRamp.Drift(Keypoints, StopRamp.Alpha, p15.alphaPhase.now, #Keypoints + 1, 1e999)

        p15.alphaResolved = NumberSequence.new(v6)

        return p15.alphaResolved
    end

    p15.alphaResolved = p15.alphaStopsGoal

    return p15.alphaStopsGoal
end

local function advance(p16, p17) -- line: 168
    -- upvalues: StopRamp (copy), resolveAlpha (copy)
    if p16.paletteBlend == 1 then
        p16.palette = p16.paletteGoal
    else
        p16.palette = ColorSequence.new(StopRamp.Restripe(p16.paletteGoal.Keypoints, p16.palette.Keypoints, p16.paletteBlend, StopRamp.Colour))
    end

    if p16.alphaBlend == 1 then
        p16.alphaStops = p16.alphaStopsGoal
    end

    local gradient, angle = p16.gradient, p16.angle
    local goal = angle.goal

    if goal then
        angle.now += (goal - angle.now) * angle.response
    else
        angle.rate += (angle.rateGoal - angle.rate) * angle.response * p17
        angle.now += angle.rate * p17
    end

    gradient.Rotation = angle.now

    local phase = p16.phase
    local goal2 = phase.goal

    if goal2 then
        phase.now += (goal2 - phase.now) * phase.response

        local _ = phase.now
    else
        phase.rate += (phase.rateGoal - phase.rate) * phase.response * p17
        phase.now += phase.rate * p17

        local _ = phase.now
    end

    local alphaPhase = p16.alphaPhase
    local goal3 = alphaPhase.goal

    if goal3 then
        alphaPhase.now += (goal3 - alphaPhase.now) * alphaPhase.response

        local _ = alphaPhase.now
    else
        alphaPhase.rate += (alphaPhase.rateGoal - alphaPhase.rate) * alphaPhase.response * p17
        alphaPhase.now += alphaPhase.rate * p17

        local _ = alphaPhase.now
    end

    local v7 = StopRamp.Drift(p16.palette.Keypoints, StopRamp.Colour, p16.phase.now, 5, 100)

    p16.paletteResolved = ColorSequence.new(v7)
    gradient.Color = p16.paletteResolved
    gradient.Transparency = resolveAlpha(p16)
end

function t2.new(p18, p19, p20) -- line: 194
    -- upvalues: Constants (copy), Heartbeat (copy), t1 (copy), t2 (copy), v1 (copy), v3 (copy), v4 (copy), flatAlpha (copy), advance (copy)
    v1(p18)
    v3(p19)
    v4(p20)
    assert(#p19.Keypoints <= 19, (`a wash accepts at most {19} colour stops`))

    if typeof(p20) == "NumberSequence" then
        assert(#p20.Keypoints <= 19, (`a wash accepts at most {19} alpha stops`))
    end

    local v12 = if typeof(p20) == "number" then flatAlpha(p20) else p20
    local v13 = setmetatable({
        driver = nil,
        isPaused = false,
        frameDebt = 0.05,
        paletteResolved = nil,
        paletteBlend = 1,
        alphaResolved = nil,
        alphaBlend = 1,
        strandedAlphaGoal = nil,
        strandedAlphaResponse = nil,
        host = p18,
        gradient = p18:FindFirstChildWhichIsA("UIGradient") or Instance.new("UIGradient"),
        isTextHost = t1[p18.ClassName] == true,
        palette = p19,
        paletteGoal = p19,
        alphaStops = v12,
        alphaStopsGoal = v12,
        phase = {
            now = 0,
            goal = nil,
            rate = 0,
            rateGoal = 0,
            response = 1
        },
        alphaPhase = {
            now = 0,
            goal = nil,
            rate = 0,
            rateGoal = 0,
            response = 1
        },
        angle = {
            now = 0,
            goal = nil,
            rate = 0,
            rateGoal = 0,
            response = 0
        }
    }, t2)

    v13.driver = Heartbeat:Connect(function(p21) -- line: 244
        -- upvalues: v13 (copy), Constants (copy), advance (copy)
        if v13.isPaused then
            return
        end

        local frameDebt

        if Constants.IS_MOBILE then
            v13.frameDebt += p21

            if v13.frameDebt < 0.05 then
                return
            end

            frameDebt = v13.frameDebt
            v13.frameDebt = 0
        else
            frameDebt = p21
        end

        debug.profilebegin("EasyVisuals/wash")

        if v13.host and v13.host.Parent ~= nil then
            advance(v13, frameDebt)
            debug.profileend()
        else
            v13.driver:Disconnect()

            if v13.gradient then
                v13.gradient:Destroy()
                v13.gradient = nil
            end
        end
    end)
    v13.gradient.Parent = v13.host

    return v13
end

function t2.Destroy(p22) -- line: 277
    p22.driver:Disconnect()

    if p22.gradient then
        p22.gradient:Destroy()
        p22.gradient = nil
    end
end

function t2.Suspend(p23) -- line: 279
    p23.isPaused = true
end

function t2.Wake(p24) -- line: 281
    p24.isPaused = false
end

function t2.SetRotation(p25, p26, p27) -- line: 283
    -- upvalues: v2 (copy)
    v2(p26)
    v2(p27)

    local angle = p25.angle

    angle.goal = p26
    angle.rate = 0
    angle.rateGoal = 0
    angle.response = math.clamp(p27, 0, 1)
end

function t2.Spin(p28, p29, p30) -- line: 289
    -- upvalues: v2 (copy)
    v2(p29)
    v2(p30)

    local angle = p28.angle

    angle.rateGoal = p29
    angle.goal = nil
    angle.response = math.clamp(p30, 0, 1)
end

function t2.PhaseTo(p31, p32, p33) -- line: 295
    -- upvalues: v2 (copy)
    v2(p32)
    v2(p33)

    local phase = p31.phase

    phase.goal = p32
    phase.rate = 0
    phase.rateGoal = 0
    phase.response = math.clamp(p33, 0, 1)
end

function t2.Drift(p34, p35, p36) -- line: 301
    -- upvalues: v2 (copy)
    v2(p35)
    v2(p36)

    local phase = p34.phase

    phase.rateGoal = p35
    phase.goal = nil
    phase.response = math.clamp(p36, 0, 1)
end

function t2.AlphaPhaseTo(p37, p38, p39) -- line: 307
    -- upvalues: v2 (copy)
    v2(p38)
    v2(p39)

    local alphaPhase = p37.alphaPhase

    alphaPhase.goal = p38
    alphaPhase.rate = 0
    alphaPhase.rateGoal = 0
    alphaPhase.response = math.clamp(p39, 0, 1)
end

function t2.AlphaDrift(p40, p41, p42) -- line: 313
    -- upvalues: v2 (copy)
    v2(p41)
    v2(p42)

    local alphaPhase = p40.alphaPhase

    alphaPhase.rateGoal = p41
    alphaPhase.goal = nil
    alphaPhase.response = math.clamp(p42, 0, 1)
end

function t2.Recolor(p43, p44, p45) -- line: 319
    -- upvalues: v3 (copy)
    v3(p44)
    p43.paletteBlend = p45 or 1
    p43.paletteGoal = p44

    return p43.paletteGoal
end

function t2.Refade(p46, p47, p48) -- line: 334
    -- upvalues: v2 (copy), flatAlpha (copy)
    assert(p47, "a wash needs alpha stops to fade toward")
    v2(p48)

    if typeof(p47) == "number" then
        p46.strandedAlphaGoal = flatAlpha(p47)
    elseif typeof(p47) == "NumberSequence" then
        p46.strandedAlphaGoal = p47
    else
        warn("a wash was handed alpha stops that were neither a number nor a NumberSequence")
    end

    p46.strandedAlphaResponse = math.clamp(p48, 0, 1)
end

return table.freeze(t2)
