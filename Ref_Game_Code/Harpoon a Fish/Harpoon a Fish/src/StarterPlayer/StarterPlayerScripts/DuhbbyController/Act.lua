-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local t1 = {}

t1.__index = t1

local rad, identity = math.rad, CFrame.identity

local function A(p1, p2, p3) -- line: 20
    -- upvalues: rad (copy)
    return CFrame.Angles(rad(p1 or 0), rad(p2 or 0), (rad(p3 or 0)))
end

local t2 = {
    LeftShoulder = CFrame.Angles(0, 0, -0.08726646259971647),
    RightShoulder = CFrame.Angles(0, 0, 0.08726646259971647),
    LeftElbow = CFrame.Angles(0.10471975511965978, 0, 0),
    RightElbow = CFrame.Angles(0.10471975511965978, 0, 0)
}
local t3 = {
    Waist = CFrame.Angles(-1.0821041362364843, 0, 0),
    Neck = CFrame.Angles(-0.3141592653589793, 0, 0),
    LeftShoulder = CFrame.Angles(1.361356816555577, 0, -0.15707963267948966),
    RightShoulder = CFrame.Angles(1.361356816555577, 0, 0.15707963267948966),
    LeftElbow = CFrame.Angles(0.20943951023931956, 0, 0),
    RightElbow = CFrame.Angles(0.20943951023931956, 0, 0),
    LeftHip = CFrame.Angles(0.4886921905584123, 0, 0),
    RightHip = CFrame.Angles(0.4886921905584123, 0, 0),
    LeftKnee = CFrame.Angles(-0.5934119456780721, 0, 0),
    RightKnee = CFrame.Angles(-0.5934119456780721, 0, 0),
    LeftAnkle = CFrame.Angles(0.13962634015954636, 0, 0),
    RightAnkle = CFrame.Angles(0.13962634015954636, 0, 0)
}
local t4 = {
    Waist = CFrame.Angles(-0.06981317007977318, 0, 0),
    LeftShoulder = CFrame.Angles(0.9075712110370514, 0, -0.15707963267948966),
    RightShoulder = CFrame.Angles(0.9075712110370514, 0, 0.15707963267948966),
    LeftElbow = CFrame.Angles(0.8726646259971648, 0, 0),
    RightElbow = CFrame.Angles(0.8726646259971648, 0, 0)
}
local t5 = {
    UP = 0.3,
    WALK = 0.95,
    STEPS = 3.4,
    BEND = 0.24,
    LIFT = 0.32,
    SET = 0.26,
    TURN = 0.22,
    FLOP = 0.5,
    REACH = 2.1,
    DIP = 0.38,
    STRIDE = {
        HIP = 30,
        KNEE = 42,
        ARM = 9,
        ELBOW = 8,
        BOB = 0.1
    },
    HELD = CFrame.new(0, -0.1, -1.75),
    BREATH = {
        DEG = 1.6,
        RATE = 1.7
    }
}

t1.FEEL = t5

local function standHeight(p4) -- line: 48
    -- upvalues: identity (copy)
    local t6 = {
        [p4.char.HumanoidRootPart] = identity
    }
    local n1 = 0

    for _, v6 in ipairs(p4.ORDER) do
        local v7 = p4.J[v6]

        if v7 then
            local Attachment0Parent = v7.Attachment0.Parent
            local Attachment1Parent = v7.Attachment1.Parent

            if t6[Attachment0Parent] then
                t6[Attachment1Parent] = t6[Attachment0Parent] * v7.Attachment0.CFrame * v7.Attachment1.CFrame:Inverse()

                if Attachment1Parent.Name:find("Foot") then
                    n1 = math.min(n1, (t6[Attachment1Parent] * CFrame.new(0, -Attachment1Parent.Size.Y / 2, 0)).Position.Y)
                end
            end
        end
    end

    return -n1
end

function t1.new(p5) -- line: 64
    -- upvalues: t1 (copy), t5 (copy), standHeight (copy)
    local v8 = setmetatable({
        ctx = p5
    }, t1)
    local root = p5.root
    local HumanoidRootPart = p5.char.HumanoidRootPart
    local crate = p5.crate

    v8.restHrp = root.CFrame:ToObjectSpace(HumanoidRootPart.CFrame)
    v8.crateRest = root.CFrame:ToObjectSpace(crate.CFrame)
    p5.crateRest = v8.crateRest

    local v9 = v8.crateRest.Position.Y - crate.Size.Y / 2
    local v10 = root.CFrame:PointToObjectSpace(p5.char.UpperTorso.Position)
    local v11 = v9 + standHeight(p5)
    local v12 = Vector3.new(v10.X, v11, v10.Z)
    local crateRestPosition = v8.crateRest.Position
    local v13 = Vector3.new(crateRestPosition.X, v11, crateRestPosition.Z)
    local Unit = (v13 - v12).Unit
    local v14 = v13 - Unit * t5.REACH

    v8.standFace = CFrame.lookAt(v12, v13)
    v8.pick = CFrame.lookAt(v14, v13)
    v8.pickAway = CFrame.lookAt(v14, v14 - Unit)
    v8.standAway = CFrame.lookAt(v12, v12 - Unit)
    v8.seq = nil
    v8.t0 = 0
    v8.snap = nil

    return v8
end

function t1.segments(p6, p7) -- line: 87
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy)
    if p7 == "give" then
        return {
            {
                t5.UP,
                t2,
                p6.standFace,
                Enum.EasingStyle.Back,
                0
            },
            {
                t5.WALK,
                "walk",
                p6.pick,
                Enum.EasingStyle.Sine,
                0
            },
            {
                t5.BEND,
                t3,
                p6.pick,
                Enum.EasingStyle.Quad,
                0,
                false,
                t5.DIP
            },
            {
                t5.LIFT,
                t4,
                p6.pick,
                Enum.EasingStyle.Back,
                1
            },
            {
                1e999,
                "hold",
                p6.pick,
                nil,
                1,
                true
            }
        }
    end

    return {
        {
            t5.SET,
            t3,
            p6.pick,
            Enum.EasingStyle.Quad,
            0,
            false,
            t5.DIP
        },
        {
            t5.TURN,
            t2,
            p6.pickAway,
            Enum.EasingStyle.Back,
            0
        },
        {
            t5.WALK,
            "walk",
            p6.standAway,
            Enum.EasingStyle.Sine,
            0
        },
        {
            t5.FLOP,
            "rest",
            p6.restHrp,
            Enum.EasingStyle.Bounce,
            0
        }
    }
end

function t1.Play(p8, p9, p10, p11) -- line: 107
    p8.name = p9
    p8.seq = p8:segments(p9)
    p8.t0 = p10
    p8.snap = p11
end

local function poseOf(p12, p13, p14) -- line: 114
    -- upvalues: identity (copy)
    if p13 == "rest" then
        return p12.ctx.REST[p14]
    end

    return type(p13) == "table" and p13[p14] or identity
end

local function walkPose(p15, p16) -- line: 121
    -- upvalues: identity (copy), A (copy), t5 (copy)
    local v15 = math.sin(p16)
    local STRIDE = t5.STRIDE

    if p15 == "LeftHip" then
        return A(STRIDE.HIP * v15)
    end

    if p15 == "RightHip" then
        return A(-STRIDE.HIP * v15)
    end

    if p15 == "LeftKnee" then
        return A(-STRIDE.KNEE * math.max(0, -math.cos(p16 - 0.6)))
    end

    if p15 == "RightKnee" then
        return A(-STRIDE.KNEE * math.max(0, (math.cos(p16 - 0.6))))
    end

    if p15 == "LeftShoulder" then
        return A(-STRIDE.ARM * v15, 0, -5)
    end

    if p15 == "RightShoulder" then
        return A(STRIDE.ARM * v15, 0, 5)
    end

    if p15 == "LeftElbow" or p15 == "RightElbow" then
        return A(STRIDE.ELBOW)
    end

    return identity
end

function t1.Sample(p17, p18) -- line: 134
    -- upvalues: TweenService (copy), rad (copy), identity (copy), t4 (copy), t5 (copy), walkPose (copy)
    local seq, ctx = p17.seq, p17.ctx
    local v22 = p18 - p17.t0
    local v23, v24, v25 = p17.snap.T, p17.snap.hrp, p17.snap.crate

    for v26, v27 in ipairs(seq) do
        local v28 = v27[1]
        local v29 = v27[2]
        local v30 = v27[3]
        local v31 = v27[4]
        local v32 = v27[5]
        local v33 = v27[6]
        local v34 = v27[7]
        local v35, v36, InOut, t8, v37, v38, v39, v40, v41, v42, v43, DEG, v44, v45, Angles, v46, T, v47, v48, v49, v50, new, BOB, v51, v52, v53, v54, v55, v56

        if v22 < v28 then
            if v28 == 1e999 then
                v36 = 1
            else
                v35 = v22 / v28
                v36 = math.clamp(v35, 0, 1)
            end

            if v31 then
                InOut = v31 == Enum.EasingStyle.Sine and Enum.EasingDirection.InOut or Enum.EasingDirection.Out
                v56 = TweenService:GetValue(v36, v31, InOut) or 1
            else
                v56 = 1
            end

            t8 = {}
            t8.T = {}
            t8.look = v33 or false

            if v26 == #seq and v36 >= 1 then
                t8.done = v28 ~= 1e999
            else
                t8.done = false
            end

            v55 = v29 == "walk"
            v37 = v22 * t5.STEPS * 3.141592653589793

            for _, v57 in ipairs(ctx.ORDER) do
                v38 = v23[v57] or identity

                if v55 then
                    v39 = v36 / 0.2
                    v40 = (1 - v36) / 0.2
                    v41 = math.min(1, v39, v40)
                    v42 = v38:Lerp(walkPose(v57, v37), (math.max(0, v41)))
                    t8.T[v57] = v42
                elseif v29 == "hold" then
                    v43 = t4[v57]
                    v43 = v43 or identity

                    if v57 == "Waist" then
                        DEG = t5.BREATH.DEG
                        v44 = p18 * t5.BREATH.RATE
                        v45 = DEG * math.sin(v44)
                        Angles = CFrame.Angles
                        v46 = v45 or 0
                        v43 *= Angles(rad(v46), 0, 0)
                    end

                    t8.T[v57] = v43
                else
                    T = t8.T
                    v47 = if v29 == "rest" then p17.ctx.REST[v57] else type(v29) == "table" and v29[v57] or identity
                    T[v57] = v38:Lerp(v47, v56)
                end
            end

            v48 = if v55 then v56 else math.clamp(v56, 0, 1.2)
            v49 = v24:Lerp(v30, v48)

            if v55 then
                v50 = v24:Lerp(v30, v56)
                new = CFrame.new
                BOB = t5.STRIDE.BOB
                v51 = math.sin(v37)
                v52 = BOB * math.abs(v51)
                v53 = v36 / 0.2
                v54 = (1 - v36) / 0.2
                v49 = v50 * new(0, v52 * math.min(1, v53, v54), 0)
            end

            if v34 then
                v49 *= CFrame.new(0, -v34 * v56, 0)
            end

            if v29 ~= "hold" then
                v30 = v49
            end

            t8.hrp = v30
            t8.crate = v25 + (v32 - v25) * math.clamp(v56, 0, 1)

            return t8
        end

        if v26 == #seq then
            if v28 == 1e999 then
                v36 = 1
            else
                v35 = v22 / v28
                v36 = math.clamp(v35, 0, 1)
            end

            if v31 then
                InOut = v31 == Enum.EasingStyle.Sine and Enum.EasingDirection.InOut or Enum.EasingDirection.Out
                v56 = TweenService:GetValue(v36, v31, InOut) or 1
            else
                v56 = 1
            end

            t8 = {}
            t8.T = {}
            t8.look = v33 or false

            if v26 == #seq and v36 >= 1 then
                t8.done = v28 ~= 1e999
            else
                t8.done = false
            end

            v55 = v29 == "walk"
            v37 = v22 * t5.STEPS * 3.141592653589793

            for _, v58 in ipairs(ctx.ORDER) do
                v38 = v23[v58] or identity

                if v55 then
                    v39 = v36 / 0.2
                    v40 = (1 - v36) / 0.2
                    v41 = math.min(1, v39, v40)
                    v42 = v38:Lerp(walkPose(v58, v37), (math.max(0, v41)))
                    t8.T[v58] = v42
                elseif v29 == "hold" then
                    v43 = t4[v58]
                    v43 = v43 or identity

                    if v58 == "Waist" then
                        DEG = t5.BREATH.DEG
                        v44 = p18 * t5.BREATH.RATE
                        v45 = DEG * math.sin(v44)
                        Angles = CFrame.Angles
                        v46 = v45 or 0
                        v43 *= Angles(rad(v46), 0, 0)
                    end

                    t8.T[v58] = v43
                else
                    T = t8.T
                    v47 = if v29 == "rest" then p17.ctx.REST[v58] else type(v29) == "table" and v29[v58] or identity
                    T[v58] = v38:Lerp(v47, v56)
                end
            end

            v48 = if v55 then v56 else math.clamp(v56, 0, 1.2)
            v49 = v24:Lerp(v30, v48)

            if v55 then
                v50 = v24:Lerp(v30, v56)
                new = CFrame.new
                BOB = t5.STRIDE.BOB
                v51 = math.sin(v37)
                v52 = BOB * math.abs(v51)
                v53 = v36 / 0.2
                v54 = (1 - v36) / 0.2
                v49 = v50 * new(0, v52 * math.min(1, v53, v54), 0)
            end

            if v34 then
                v49 *= CFrame.new(0, -v34 * v56, 0)
            end

            if v29 ~= "hold" then
                v30 = v49
            end

            t8.hrp = v30
            t8.crate = v25 + (v32 - v25) * math.clamp(v56, 0, 1)

            return t8
        end

        v25 = v32
        v22 -= v28
        v23 = {}

        for _, v59 in ipairs(ctx.ORDER) do
            if v29 == "walk" then
                v23[v59] = identity
            elseif v29 == "rest" then
                v23[v59] = p17.ctx.REST[v59]
            else
                v23[v59] = type(v29) == "table" and v29[v59] or identity
            end
        end

        v24 = v30 * (v34 and CFrame.new(0, -v34, 0) or identity)
    end
end

function t1.Apply(p19, p20, p21, p22) -- line: 185
    -- upvalues: identity (copy), t5 (copy)
    local root = p19.root
    local HumanoidRootPart = p19.char.HumanoidRootPart

    if p21 then
        HumanoidRootPart.CFrame = root.CFrame * p21
    end

    for _, v60 in ipairs(p19.ORDER) do
        local v61 = p19.J[v60]

        if v61 then
            local v62 = p20[v60] or identity

            v61.Transform = v62
            v61.Attachment1.Parent.CFrame = v61.Attachment0.Parent.CFrame * v61.Attachment0.CFrame * v62 * v61.Attachment1.CFrame:Inverse()
        end
    end

    for v63, v64 in pairs(p19.fits) do
        v63.CFrame = v64.ba.Parent.CFrame * v64.ba.CFrame * v64.ha.CFrame:Inverse()
    end

    if not p22 then
        return
    end

    local v65 = root.CFrame * p19.crateRest
    local v66 = p19.char.UpperTorso.CFrame * t5.HELD

    p19.crate.CFrame = p22 <= 0 and v65 or v65:Lerp(v66, (math.clamp(p22, 0, 1)))
end

return t1
