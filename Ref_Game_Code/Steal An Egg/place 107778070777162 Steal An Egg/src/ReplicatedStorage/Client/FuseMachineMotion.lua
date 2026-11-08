-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local EmitTree = require(ReplicatedStorage.Shared.Utils.VFX).EmitTree
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    {
        Seconds = 0.22,
        Rise = 2.6,
        Squash = 0.92,
        Stretch = 1.12,
        Pitch = -6,
        Roll = 5
    },
    {
        Seconds = 0.18,
        Rise = 1.65,
        Squash = 0.96,
        Stretch = 1.08,
        Pitch = 4,
        Roll = -3
    },
    {
        Seconds = 0.15,
        Rise = 0.9,
        Squash = 0.985,
        Stretch = 1.04,
        Pitch = -2,
        Roll = 1.5
    }
}
local t2 = {}
local EasingStyle, EasingDirection = Enum.EasingStyle, Enum.EasingDirection

local function backOut(p1) -- line: 41
    -- upvalues: TweenService (copy), EasingStyle (copy), EasingDirection (copy)
    return TweenService:GetValue(p1, EasingStyle.Back, EasingDirection.Out)
end

local function bounceOut(p2) -- line: 43
    -- upvalues: TweenService (copy), EasingStyle (copy), EasingDirection (copy)
    return TweenService:GetValue(p2, EasingStyle.Bounce, EasingDirection.Out)
end

local function quadIn(p3) -- line: 45
    -- upvalues: TweenService (copy), EasingStyle (copy), EasingDirection (copy)
    return TweenService:GetValue(p3, EasingStyle.Quad, EasingDirection.In)
end

local function locateEmitter(p4, p5) -- line: 47
    return p5:FindFirstChild("EmitFuse") or p4:FindFirstChild("EmitFuse")
end

local function poseAt(p6, p7, p8) -- line: 52
    -- upvalues: TweenService (copy), EasingStyle (copy), EasingDirection (copy)
    if p7 < 0.34 then
        local Value = TweenService:GetValue(math.min(p7 / 0.34, 1), EasingStyle.Back, EasingDirection.Out)

        return p6.Rise * Value, p6.Pitch * Value, p6.Roll * Value, p8 + (p6.Stretch - p8) * Value
    end

    local v4 = math.max(p7 - 0.34, 0) / 0.66
    local v5 = 1 - TweenService:GetValue(v4, EasingStyle.Bounce, EasingDirection.Out)
    local v6

    if v4 < 0.55 then
        local Value = TweenService:GetValue(v4 / 0.55, EasingStyle.Quad, EasingDirection.In)

        v6 = p6.Stretch + (p6.Squash - p6.Stretch) * Value
    else
        local Value = TweenService:GetValue((v4 - 0.55) / 0.45, EasingStyle.Bounce, EasingDirection.Out)

        v6 = p6.Squash + (p8 - p6.Squash) * Value
    end

    return p6.Rise * v5, p6.Pitch * v5, p6.Roll * v5, v6
end

function t2.Bounce(p9, p10) -- line: 80
    -- upvalues: RunService (copy), t (copy), t1 (copy), poseAt (copy)
    t.strict(t.instanceIsA("Model"))(p9)
    t.strict(t.callback)(p10)

    local Pivot = p9:GetPivot()
    local Scale = p9:GetScale()

    for _, v9 in ipairs(t1) do
        local n1 = 0
        local v10

        while true do
            if n1 < v9.Seconds then
                local v11 = RunService.PreRender:Wait()

                if p10() then
                    n1 = math.min(n1 + v11, v9.Seconds)

                    local v13, v14, v15, v16 = poseAt(v9, n1 / v9.Seconds, Scale)

                    p9:ScaleTo(v16)
                    p9:PivotTo(Pivot * CFrame.new(0, v13, 0) * CFrame.Angles(math.rad(v14), 0, (math.rad(v15))))
                    continue
                end

                v10 = true
            else
                v10 = false
            end

            break
        end

        p9:ScaleTo(Scale)
        p9:PivotTo(Pivot)

        if v10 then
            return false
        end
    end

    return true
end

function t2.Burst(p11, p12) -- line: 117
    -- upvalues: EmitTree (copy), t (copy)
    t.strict(t.instanceIsA("Model"))(p11)
    t.strict(t.instanceIsA("BasePart"))(p12)

    local v17 = p12:FindFirstChild("EmitFuse") or p11:FindFirstChild("EmitFuse")

    if v17 ~= nil then
        EmitTree(v17)
    end
end

function t2.Run(p13, p14, p15) -- line: 127
    -- upvalues: t (copy), t2 (copy)
    t.strict(t.instanceIsA("Model"))(p13)
    t.strict(t.instanceIsA("BasePart"))(p14)
    t.strict(t.callback)(p15)

    local v18 = t2.Bounce(p13, p15)

    if v18 then
        t2.Burst(p13, p14)
    end

    return v18
end

return t2
