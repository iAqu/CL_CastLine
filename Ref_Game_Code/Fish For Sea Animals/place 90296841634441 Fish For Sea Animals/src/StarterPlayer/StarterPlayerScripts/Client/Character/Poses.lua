-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local LocalPlayer = Players.LocalPlayer
local Barbells = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Barbells")
local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local t6 = {}

local function lerp(p1, p2, p3) -- line: 22
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 25
    local v3 = math.clamp(p4, 0, 1)

    return v3 * v3 * (3 - 2 * v3)
end

local t7 = {
    Hold = function(_) -- Hold | line: 34
        return {
            RS = { 40, 0, 0 },
            RE = { 50, 0, 0 }
        }
    end
}

local function v4() -- line: 40
    return 0
end

function t1.setAimSource(p6) -- line: 44
    -- upvalues: v4 (ref)
    v4 = p6
end

function t7.Aim(p7) -- line: 48
    -- upvalues: v4 (ref)
    local v5 = v4()
    local v7 = math.sin(p7 * 2) * 2 * (1 - v5)

    return {
        RS = {
            40 + 110 * v5 + v7,
            0,
            0 + -10 * v5
        },
        RE = {
            50 + -25 * v5,
            0, 0
        },
        LS = {
            0 + 45 * v5,
            0,
            0 + 18 * v5
        },
        LE = {
            0 + 25 * v5,
            0, 0
        },
        Waist = {
            0 + 6 * v5,
            0 + -22 * v5,
            0
        },
        Neck = {
            0 + -5 * v5,
            0 + 10 * v5,
            0
        }
    }
end

t1.RELEASE = 0.86 * Config.CastPace

function t7.Cast(p8) -- line: 64
    -- upvalues: Config (copy)
    local v8 = p8 / Config.CastPace

    if v8 < 0.72 then
        local v10 = math.clamp(v8 / 0.72, 0, 1)
        local v11 = v10 * v10 * (3 - 2 * v10)
        local v13 = math.sin(v11 * 3.141592653589793)

        return {
            RS = {
                40 + 132 * v11,
                0,
                0 + -12 * v11 + v13 * 55
            },
            RE = {
                50 + -20 * v11 - v13 * 30,
                0, 0
            },
            LS = {
                0 + 70 * v11,
                0,
                0 + 20 * v11 + v13 * 40
            },
            LE = {
                0 + 10 * v11,
                0, 0
            },
            Waist = {
                0 + 8 * v11,
                0 + -30 * v11,
                0
            },
            Root = {
                0 + 10 * v11,
                -360 * v11,
                0
            },
            Neck = {
                0 + -10 * v11,
                0, 0
            }
        }
    end

    if v8 < 0.92 then
        local v15 = math.clamp((v8 - 0.72) / 0.2, 0, 1)
        local v16 = v15 * v15 * (3 - 2 * v15)

        return {
            RS = {
                172 + -117 * v16,
                0,
                -12 + 12 * v16
            },
            RE = {
                30 + -22 * v16,
                0, 0
            },
            LS = {
                70 + -30 * v16,
                0,
                20 + 10 * v16
            },
            LE = {
                10 + 30 * v16,
                0, 0
            },
            Waist = {
                8 + -22 * v16,
                -30 + 52 * v16,
                0
            },
            Root = {
                10 + -28 * v16,
                0, 0
            },
            Neck = {
                -10 + 16 * v16,
                0, 0
            }
        }
    end

    if v8 < 1.35 then
        local v18 = math.clamp((v8 - 0.92) / 0.43, 0, 1)
        local v19 = v18 * v18 * (3 - 2 * v18)

        return {
            RS = {
                55 + 15 * v19,
                0, 0
            },
            RE = {
                8 + 7 * v19,
                0, 0
            },
            LS = {
                40 + 15 * v19,
                0, 30
            },
            LE = {
                40 + -5 * v19,
                0, 0
            },
            Waist = {
                -14 + 20 * v19,
                22 + -16 * v19,
                0
            },
            Root = {
                -18 + 18 * v19,
                0, 0
            },
            Neck = {
                6 + -6 * v19,
                0, 0
            }
        }
    end

    local v21 = math.sin(v8 * 2) * 3

    return {
        RS = {
            v21 + 70,
            0, 0
        },
        RE = { 15, 0, 0 },
        LS = {
            v21 + 55,
            0, 30
        },
        LE = { 35, 0, 0 },
        Waist = { 6, 6, 0 }
    }
end

function t7.Reel(p9) -- line: 107
    local v23 = math.sin(p9 * 30) * 6
    local v26 = math.max(0, (math.sin(p9 * 5))) * 10

    return {
        RS = {
            v23 + 125,
            0, 0
        },
        RE = { 30, 0, 0 },
        LS = {
            v23 + 80,
            0, 25
        },
        LE = { 45, 0, 0 },
        Waist = {
            v26 * 0.5 + 6,
            -8, 0
        },
        Root = {
            v26 + 12,
            0, 0
        },
        Neck = { -6, 0, 0 }
    }
end

function t7.Flick(p10) -- line: 122
    if p10 < 0.16 then
        local v28 = math.clamp(p10 / 0.16, 0, 1)
        local v29 = v28 * v28 * (3 - 2 * v28)

        return {
            RS = {
                40 + 120 * v29,
                0, 0
            },
            RE = {
                50 + -20 * v29,
                0, 0
            },
            Waist = {
                0 + 6 * v29,
                0 + -16 * v29,
                0
            }
        }
    end

    local v31 = math.clamp((p10 - 0.16) / 0.2, 0, 1)
    local v32 = v31 * v31 * (3 - 2 * v31)

    return {
        RS = {
            160 + -90 * v32,
            0, 0
        },
        RE = {
            30 + -18 * v32,
            0, 0
        },
        Waist = {
            6 + -14 * v32,
            -16 + 26 * v32,
            0
        }
    }
end

local t8 = {
    RH = { 88, 0, 4 },
    LH = { 88, 0, -4 },
    RK = { -84, 0, 0 },
    LK = { -84, 0, 0 }
}

local function seated(p11) -- line: 134
    -- upvalues: t8 (copy)
    for v33, v34 in t8 do
        p11[v33] = p11[v33] or v34
    end

    return p11
end

function t7.Doze(p12) -- line: 142
    -- upvalues: t8 (copy)
    local v36 = (math.sin(p12 * 1.7) + 1) / 2
    local t9 = {
        RS = {
            48 - v36 * 6,
            0, 0
        },
        RE = { 30, 0, 0 },
        LS = {
            40 - v36 * 4,
            0, 18
        },
        LE = { 40, 0, 0 },
        Waist = {
            -6 - v36 * 5,
            0, 0
        },
        Neck = {
            -20 - v36 * 16,
            0, 0
        }
    }

    for v37, v38 in t8 do
        t9[v37] = t9[v37] or v38
    end

    return t9
end

function t7.Slump(p13) -- line: 155
    -- upvalues: t8 (copy)
    local v40 = math.clamp(p13 / 0.5, 0, 1)
    local v41 = v40 * v40 * (3 - 2 * v40)
    local t10 = {
        RS = {
            48 + -40 * v41,
            0,
            0 + 12 * v41
        },
        RE = {
            30 + -20 * v41,
            0, 0
        },
        LS = {
            40 + -34 * v41,
            0,
            18 + -10 * v41
        },
        LE = {
            40 + -28 * v41,
            0, 0
        },
        Waist = {
            -8 + -12 * v41,
            0,
            0 + 6 * v41
        },
        Neck = {
            -30 + -12 * v41,
            0,
            0 + 12 * v41
        }
    }

    for v42, v43 in t8 do
        t10[v42] = t10[v42] or v43
    end

    return t10
end

function t7.Startle(p14) -- line: 168
    -- upvalues: t8 (copy)
    local v45 = math.clamp(p14 / 0.18, 0, 1)
    local v46 = v45 * v45 * (3 - 2 * v45)
    local v47 = if p14 < 0.6 then math.sin(p14 * 60) * 4 else 0
    local t11 = {
        RS = {
            10 + 130 * v46 + v47,
            0,
            0 + 20 * v46
        },
        RE = {
            30 + -10 * v46,
            0, 0
        },
        LS = {
            4 + 136 * v46 - v47,
            0,
            0 + 20 * v46
        },
        LE = { 20, 0, 0 },
        Waist = {
            -20 + 26 * v46,
            0, 0
        },
        Neck = {
            -30 + 38 * v46,
            0, 0
        }
    }

    for v49, v50 in t8 do
        t11[v49] = t11[v49] or v50
    end

    return t11
end

function t7.Steer(p15) -- line: 183
    -- upvalues: t8 (copy)
    local v52 = math.sin(p15 * 11) * 22
    local t12 = {
        RS = {
            v52 + 70,
            0, 6
        },
        RE = { 40, 0, 0 },
        LS = {
            70 - v52,
            0, 6
        },
        LE = { 40, 0, 0 },
        Waist = {
            14,
            math.sin(p15 * 5.5) * 10,
            0
        },
        Neck = {
            -6,
            math.sin(p15 * 7) * 8,
            0
        }
    }

    for v55, v56 in t8 do
        t12[v55] = t12[v55] or v56
    end

    return t12
end

function t7.Laugh(p16) -- line: 196
    -- upvalues: t8 (copy)
    local v58 = (math.sin(p16 * 13) + 1) / 2
    local t13 = {
        RS = { 60, 0, 110 },
        RE = { 70, 0, 0 },
        LS = { 30, 0, 10 },
        LE = { 100, 0, 0 },
        Waist = {
            -12 - v58 * 10,
            25, 0
        },
        Neck = {
            -18 - v58 * 12,
            55, 0
        }
    }

    for v59, v60 in t8 do
        t13[v59] = t13[v59] or v60
    end

    return t13
end

function t7.LookAhead(p17) -- line: 210
    -- upvalues: t8 (copy)
    local v62 = math.clamp(p17 / 1.6, 0, 1)
    local v63 = v62 * v62 * (3 - 2 * v62)
    local v65 = math.clamp((p17 - 0.2) / 2.4, 0, 1)
    local v66 = v65 * v65 * (3 - 2 * v65)
    local v68 = math.clamp((p17 - 2.2) / 0.6, 0, 1)
    local v69 = v68 * v68 * (3 - 2 * v68)
    local t14 = {
        RS = {
            60 + -40 * v63,
            0,
            110 + -100 * v63
        },
        RE = {
            70 + -40 * v63,
            0, 0
        },
        LS = {
            30 + -10 * v63,
            0, 10
        },
        LE = {
            100 + -60 * v63,
            0, 0
        },
        Waist = {
            -12 + 18 * v63,
            25 + -25 * v63,
            0
        },
        Neck = {
            -18 + 22 * v66,
            55 + -55 * v66,
            v69 * 14
        }
    }

    for v70, v71 in t8 do
        t14[v70] = t14[v70] or v71
    end

    return t14
end

function t7.Drive(p18) -- line: 225
    -- upvalues: t8 (copy)
    local v73 = math.sin(p18 * 1.4)
    local t15 = {
        RS = {
            v73 * 4 + 62,
            0, 6
        },
        RE = { 44, 0, 0 },
        LS = {
            62 - v73 * 4,
            0, 6
        },
        LE = { 44, 0, 0 },
        Waist = {
            8,
            v73 * 3,
            0
        },
        Neck = {
            -4,
            v73 * 4,
            0
        }
    }

    for v74, v75 in t8 do
        t15[v74] = t15[v74] or v75
    end

    return t15
end

function t7.Leap(p19) -- line: 238
    local v77 = math.clamp(p19 / 0.25, 0, 1)
    local v78 = v77 * v77 * (3 - 2 * v77)

    return {
        RS = {
            20 + 130 * v78,
            0, 25
        },
        LS = {
            20 + 130 * v78,
            0, 25
        },
        RE = { 20, 0, 0 },
        LE = { 20, 0, 0 },
        RH = {
            0 + 55 * v78,
            0, 0
        },
        LH = {
            0 + 35 * v78,
            0, 0
        },
        RK = {
            0 + -70 * v78,
            0, 0
        },
        LK = {
            0 + -50 * v78,
            0, 0
        }
    }
end

function t7.LookUp(p20) -- line: 254
    local v80 = math.clamp(p20 / 0.8, 0, 1)
    local v81 = v80 * v80 * (3 - 2 * v80)
    local v82 = if not (p20 > 1.6 and p20 < 2.4) then 0 else math.sin((p20 - 1.6) / 0.8 * 3.141592653589793)

    return {
        Neck = {
            0 + 34 * v81 - v82 * 10,
            math.sin(p20 * 0.9) * 6,
            0
        },
        Waist = {
            0 + -6 * v81 - v82 * 4,
            0, 0
        },
        RS = {
            v82 * 30,
            0,
            v82 * 25
        },
        LS = {
            v82 * 30,
            0,
            v82 * 25
        },
        RE = {
            v82 * 50,
            0, 0
        },
        LE = {
            v82 * 50,
            0, 0
        }
    }
end

function t7.Ready(p21) -- line: 268
    -- upvalues: t8 (copy)
    local v87 = math.clamp(p21 / 0.6, 0, 1)
    local v88 = v87 * v87 * (3 - 2 * v87)
    local v89 = if not (p21 > 1.3 and p21 < 2.1) then 0 else math.sin((p21 - 1.3) / 0.8 * 3.141592653589793)
    local t17 = {
        RS = { 56, 0, 6 },
        RE = { 34, 0, 0 },
        LS = { 56, 0, 6 },
        LE = { 34, 0, 0 },
        Waist = {
            6 + 12 * v88,
            0, 0
        },
        Neck = {
            0 + 6 * v88 - v89 * 16,
            0, 0
        }
    }

    for v91, v92 in t8 do
        t17[v91] = t17[v91] or v92
    end

    return t17
end

function t7.Cower(p22) -- line: 282
    -- upvalues: t8 (copy)
    local v94 = math.sin(p22 * 50) * 3
    local t18 = {
        RS = {
            v94 + 120,
            0, 30
        },
        RE = { 120, 0, 0 },
        LS = {
            120 - v94,
            0, 30
        },
        LE = { 120, 0, 0 },
        Waist = {
            10, 0,
            v94 * 0.5
        },
        Neck = {
            v94 + 6,
            0, 0
        }
    }

    for v95, v96 in t8 do
        t18[v95] = t18[v95] or v96
    end

    return t18
end

function t7.Carry(p23) -- line: 296
    return {
        RS = {
            math.sin(p23 * 2.4) * 2 + 82,
            0, 0
        },
        RE = { 8, 0, 0 }
    }
end

t1.LIFT_TOP = 0.36
t1.LIFT_BOTTOM = 0.88

local function liftProgress(p24) -- line: 308
    -- upvalues: t1 (copy)
    if p24 < t1.LIFT_TOP then
        local v99 = math.clamp(p24 / t1.LIFT_TOP, 0, 1)

        return v99 * v99 * (3 - 2 * v99)
    end

    if p24 < 0.5 then
        return 1
    end

    if p24 < t1.LIFT_BOTTOM then
        local v101 = math.clamp((p24 - 0.5) / (t1.LIFT_BOTTOM - 0.5), 0, 1)

        return 1 - v101 * v101 * (3 - 2 * v101)
    end

    return 0
end

function t7.Lift(p25) -- line: 319
    -- upvalues: t1 (copy)
    local v102 = p25 % 1
    local n1 = 0

    if v102 < t1.LIFT_TOP then
        local v104 = math.clamp(v102 / t1.LIFT_TOP, 0, 1)

        n1 = v104 * v104 * (3 - 2 * v104)
    elseif v102 < 0.5 then
        n1 = 1
    elseif v102 < t1.LIFT_BOTTOM then
        local v106 = math.clamp((v102 - 0.5) / (t1.LIFT_BOTTOM - 0.5), 0, 1)

        n1 = 1 - v106 * v106 * (3 - 2 * v106)
    end

    local v107 = if not (t1.LIFT_TOP <= v102 and v102 < 0.5) then 0 else math.sin(p25 * 70) * 2
    local v109 = 6 + 18 * n1
    local v110 = 12 + 123 * n1 + v107
    local t19 = {
        Waist = {
            math.sin(n1 * 3.141592653589793) * 3 + n1 * 4,
            0, 0
        },
        Neck = {
            n1 * -4,
            0, 0
        }
    }
    local t20 = {
        RS = { v109, 0, 4 },
        RE = { v110, 0, 0 },
        LS = { v109, 0, -4 },
        LE = { v110, 0, 0 }
    }
    local v112 = 10 + 85 * n1 + v107
    local t21 = {
        RS = { v112, 0, 4 },
        LS = { v112, 0, -4 }
    }

    for v113, v114 in t19 do
        t20[v113] = v114
        t21[v113] = v114
    end

    return t20, t21
end

function t1.liftPhase() -- line: 340
    -- upvalues: Config (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local ServerTimeNow = workspace:GetServerTimeNow()

    if Character then
        ServerTimeNow = Config.repClock(Character, ServerTimeNow)
    end

    return ServerTimeNow % 1
end

local function findJoints(p26) -- line: 350
    local function motor(p27, p28) -- line: 351
        -- upvalues: p26 (copy)
        local v115 = p26:FindFirstChild(p27)
        local v116 = v115 and v115:FindFirstChild(p28)

        return if v116 and (v116:IsA("Motor6D") or v116:IsA("AnimationConstraint")) then v116 else nil
    end

    if p26:FindFirstChild("UpperTorso") then
        local RightUpperArm = p26:FindFirstChild("RightUpperArm")
        local RightShoulder = RightUpperArm and RightUpperArm:FindFirstChild("RightShoulder")

        if not (RightShoulder and (RightShoulder:IsA("Motor6D") or RightShoulder:IsA("AnimationConstraint"))) then
            RightShoulder = nil
        end

        local t22 = {}

        t22.RS = RightShoulder

        local RightLowerArm = p26:FindFirstChild("RightLowerArm")
        local RightElbow = RightLowerArm and RightLowerArm:FindFirstChild("RightElbow")

        t22.RE = if not (RightElbow and (RightElbow:IsA("Motor6D") or RightElbow:IsA("AnimationConstraint"))) then nil else RightElbow

        local LeftUpperArm = p26:FindFirstChild("LeftUpperArm")
        local LeftShoulder = LeftUpperArm and LeftUpperArm:FindFirstChild("LeftShoulder")

        t22.LS = if not (LeftShoulder and (LeftShoulder:IsA("Motor6D") or LeftShoulder:IsA("AnimationConstraint"))) then nil else LeftShoulder

        local LeftLowerArm = p26:FindFirstChild("LeftLowerArm")
        local LeftElbow = LeftLowerArm and LeftLowerArm:FindFirstChild("LeftElbow")

        t22.LE = if not (LeftElbow and (LeftElbow:IsA("Motor6D") or LeftElbow:IsA("AnimationConstraint"))) then nil else LeftElbow

        local UpperTorso = p26:FindFirstChild("UpperTorso")
        local Waist = UpperTorso and UpperTorso:FindFirstChild("Waist")

        t22.Waist = if not (Waist and (Waist:IsA("Motor6D") or Waist:IsA("AnimationConstraint"))) then nil else Waist

        local Head = p26:FindFirstChild("Head")
        local Neck = Head and Head:FindFirstChild("Neck")

        t22.Neck = if not (Neck and (Neck:IsA("Motor6D") or Neck:IsA("AnimationConstraint"))) then nil else Neck

        local LowerTorso = p26:FindFirstChild("LowerTorso")
        local Root = LowerTorso and LowerTorso:FindFirstChild("Root")

        t22.Root = if not (Root and (Root:IsA("Motor6D") or Root:IsA("AnimationConstraint"))) then nil else Root

        local RightUpperLeg = p26:FindFirstChild("RightUpperLeg")
        local RightHip = RightUpperLeg and RightUpperLeg:FindFirstChild("RightHip")

        t22.RH = if not (RightHip and (RightHip:IsA("Motor6D") or RightHip:IsA("AnimationConstraint"))) then nil else RightHip

        local RightLowerLeg = p26:FindFirstChild("RightLowerLeg")
        local RightKnee = RightLowerLeg and RightLowerLeg:FindFirstChild("RightKnee")

        t22.RK = if not (RightKnee and (RightKnee:IsA("Motor6D") or RightKnee:IsA("AnimationConstraint"))) then nil else RightKnee

        local LeftUpperLeg = p26:FindFirstChild("LeftUpperLeg")
        local LeftHip = LeftUpperLeg and LeftUpperLeg:FindFirstChild("LeftHip")

        t22.LH = if not (LeftHip and (LeftHip:IsA("Motor6D") or LeftHip:IsA("AnimationConstraint"))) then nil else LeftHip

        local LeftLowerLeg = p26:FindFirstChild("LeftLowerLeg")
        local LeftKnee = LeftLowerLeg and LeftLowerLeg:FindFirstChild("LeftKnee")

        t22.LK = if not (LeftKnee and (LeftKnee:IsA("Motor6D") or LeftKnee:IsA("AnimationConstraint"))) then nil else LeftKnee

        return t22, false
    end

    local Torso = p26:FindFirstChild("Torso")
    local v117 = Torso and Torso:FindFirstChild("Right Shoulder")

    if not (v117 and (v117:IsA("Motor6D") or v117:IsA("AnimationConstraint"))) then
        v117 = nil
    end

    local t23 = {}

    t23.RS = v117

    local Torso2 = p26:FindFirstChild("Torso")
    local v118 = Torso2 and Torso2:FindFirstChild("Left Shoulder")

    t23.LS = if not (v118 and (v118:IsA("Motor6D") or v118:IsA("AnimationConstraint"))) then nil else v118

    local Torso3 = p26:FindFirstChild("Torso")
    local Neck = Torso3 and Torso3:FindFirstChild("Neck")

    t23.Neck = if not (Neck and (Neck:IsA("Motor6D") or Neck:IsA("AnimationConstraint"))) then nil else Neck

    local HumanoidRootPart = p26:FindFirstChild("HumanoidRootPart")
    local RootJoint = HumanoidRootPart and HumanoidRootPart:FindFirstChild("RootJoint")

    t23.Root = if not (RootJoint and (RootJoint:IsA("Motor6D") or RootJoint:IsA("AnimationConstraint"))) then nil else RootJoint

    local Torso4 = p26:FindFirstChild("Torso")
    local v119 = Torso4 and Torso4:FindFirstChild("Right Hip")

    t23.RH = if not (v119 and (v119:IsA("Motor6D") or v119:IsA("AnimationConstraint"))) then nil else v119

    local Torso5 = p26:FindFirstChild("Torso")
    local v120 = Torso5 and Torso5:FindFirstChild("Left Hip")

    t23.LH = if not (v120 and (v120:IsA("Motor6D") or v120:IsA("AnimationConstraint"))) then nil else v120

    return t23, true
end

local function poseFor(p29, p30) -- line: 383
    -- upvalues: Players (copy), Config (copy), self (copy), self2 (copy)
    local v121 = self[p29]

    if v121 then
        return v121.name, os.clock() - v121.start
    end

    if p29:GetAttribute("Lifting") then
        return "Lift", Config.repClock(p29, workspace:GetServerTimeNow())
    end

    if p29:GetAttribute("Holding") then
        return "Carry", os.clock()
    end

    if p29:GetAttribute("BossRod") then
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(p29)

        return if not (PlayerFromCharacter and PlayerFromCharacter:GetAttribute("BossHooked")) then "Hold" else "Reel", os.clock()
    end

    if not p29:GetAttribute("Fishing") then
        return nil, 0
    end

    local v122 = not p30 and self2[p29]

    if v122 and os.clock() < v122.stop then
        return v122.name, os.clock() - v122.start
    end

    local CastAt = p29:GetAttribute("CastAt")
    local v123 = CastAt and workspace:GetServerTimeNow() - CastAt

    if v123 and v123 < 12 and not p30 then
        return "Cast", v123
    end

    return "Hold", 0
end

local function toTransform(p31, p32) -- line: 415
    local v129 = CFrame.Angles(math.rad(p32[1]), math.rad(p32[2]), (math.rad(p32[3])))
    local identity = CFrame.identity

    if p31:IsA("Motor6D") then
        identity = p31.C0.Rotation
    elseif p31.Attachment0 then
        identity = p31.Attachment0.CFrame.Rotation
    end

    return identity:Inverse() * v129 * identity
end

local function updateBarbell(p33, p34, p35) -- line: 427
    -- upvalues: Players (copy), Config (copy), Barbells (copy)
    local PlayerFromCharacter = Players:GetPlayerFromCharacter(p34)
    local BarbellTier, v130

    if p35 and PlayerFromCharacter then
        local BarbellTier2 = PlayerFromCharacter:GetAttribute("BarbellTier")

        if BarbellTier2 then
            BarbellTier = BarbellTier2
            v130 = true
        else
            v130 = false
        end
    else
        v130 = false
    end

    if not v130 then
        BarbellTier = nil
    end

    if p33.barbell and p33.barbellTier ~= BarbellTier then
        p33.barbell:Destroy()
        p33.barbell = nil
    end

    if not BarbellTier then
        return
    end

    if not p33.barbell then
        local v131 = Config.Barbells[BarbellTier]
        local v132 = v131 and Barbells:FindFirstChild(v131.Model)

        if not v132 then
            return
        end

        local clone = v132:Clone()
        local _, BoundingBox = clone:GetBoundingBox()

        clone:ScaleTo(clone:GetScale() * Config.barbellScale(BoundingBox))
        clone.WorldPivot = clone:GetBoundingBox()

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        clone.Parent = workspace
        p33.barbell = clone
        p33.barbellTier = BarbellTier
    end

    local v133 = p34:FindFirstChild("RightHand") or p34:FindFirstChild("Right Arm")
    local v134 = p34:FindFirstChild("LeftHand") or p34:FindFirstChild("Left Arm")
    local v135 = p34:FindFirstChild("UpperTorso") or p34:FindFirstChild("Torso")

    if not (v133 and v134 and v135) then
        return
    end

    local function grip(p36) -- line: 464
        if p36.Name:find("Hand") then
            return p36.Position
        end

        return (p36.CFrame * CFrame.new(0, -1, 0)).Position
    end

    local Position = if v133.Name:find("Hand") then v133.Position else (v133.CFrame * CFrame.new(0, -1, 0)).Position
    local Position2 = if v134.Name:find("Hand") then v134.Position else (v134.CFrame * CFrame.new(0, -1, 0)).Position
    local v136 = Position - Position2

    if not (v136.Magnitude < 0.01) then
        local Unit = v136.Unit
        local UpVector = v135.CFrame.UpVector
        local Unit2 = (UpVector - Unit * UpVector:Dot(Unit)).Unit

        p33.barbell:PivotTo(CFrame.fromMatrix((Position + Position2) / 2, Unit, Unit2))
    end
end

function t1.play(p37) -- line: 478
    -- upvalues: LocalPlayer (copy), self (copy)
    if LocalPlayer.Character then
        self[LocalPlayer.Character] = {
            name = p37,
            start = os.clock()
        }
    end
end

function t1.clear() -- line: 484
    -- upvalues: LocalPlayer (copy), self (copy)
    if LocalPlayer.Character then
        self[LocalPlayer.Character] = nil
    end
end

function t1.playFor(p38, p39) -- line: 491
    -- upvalues: self (copy)
    self[p38] = if p39 then {
        name = p39,
        start = os.clock()
    } else nil
end

function t1.playOn(p40, p41, p42) -- line: 496
    -- upvalues: self2 (copy)
    self2[p40] = {
        name = p41,
        start = os.clock(),
        stop = os.clock() + p42
    }
end

function t1.init() -- line: 500
    -- upvalues: Players (copy), RunService (copy), LocalPlayer (copy), t6 (copy), t7 (copy), findJoints (copy), poseFor (copy), toTransform (copy), updateBarbell (copy)
    RunService.PreSimulation:Connect(function(p43) -- line: 501
        -- upvalues: Players (copy), LocalPlayer (copy), t6 (copy), t7 (copy), findJoints (copy), poseFor (copy), toTransform (copy)
        local v138 = 1 - math.exp(-p43 * 18)

        for _, player in Players:GetPlayers() do
            local Character = player.Character

            if Character then
                local v139 = t6[Character]

                if not v139 then
                    local v140, v141 = findJoints(Character)

                    v139 = {
                        refindAt = 0,
                        joints = v140,
                        isR6 = v141,
                        current = {}
                    }
                    t6[Character] = v139

                    local function changed(p44) -- line: 514
                        -- upvalues: v139 (ref)
                        if not (p44:IsA("Motor6D") or p44:IsA("AnimationConstraint")) then
                            return
                        end

                        local v142 = v139

                        v142.refindAt = 0
                        v142.stale = true
                    end

                    Character.DescendantAdded:Connect(changed)
                    Character.DescendantRemoving:Connect(changed)
                    Character.Destroying:Connect(function() -- line: 522
                        -- upvalues: Character (copy), v139 (ref), t6 (copy)
                        if v139.barbell then
                            v139.barbell:Destroy()
                        end

                        t6[Character] = nil
                    end)
                end

                local elapsed = os.clock()

                if v139.refindAt <= elapsed then
                    local v143 = not v139.stale
                    local t25 = if v139.isR6 then { "RS", "LS" } else { "RS", "RE", "LS", "LE" }

                    for _, v144 in t25 do
                        local v145 = v139.joints[v144]

                        if not (v145 and v145:IsDescendantOf(Character)) then
                            v143 = false
                        end
                    end

                    if not v143 then
                        local joints = v139.joints
                        local v146, v147 = findJoints(Character)
                        local v148 = v139

                        v148.joints = v146
                        v148.isR6 = v147
                        v148.stale = false

                        for v149, v150 in joints do
                            if v139.joints[v149] ~= v150 then
                                v139.current[v150] = nil
                            end
                        end
                    end

                    local v151 = elapsed + 0.5

                    v139.refindAt = v151
                end

                local v152, v153 = poseFor(Character, player == LocalPlayer)

                v139.pose = v152

                if v152 then
                    local v154, v155 = t7[v152](v153)

                    if not (v139.isR6 and v155) then
                        local v156 = v139

                        v155 = v154

                        if v156.isR6 then
                            for _, v157 in {
                                    {
                                        "RS",
                                        "RE"
                                    },
                                    {
                                        "LS",
                                        "LE"
                                    }
                                } do
                                v155 = v154

                                local v158 = v154[v157[1]]
                                local v159 = v154[v157[2]]

                                if v158 and v159 then
                                    v154[v157[1]] = {
                                        v158[1] + v159[1],
                                        v158[2] + v159[2],
                                        v158[3] + v159[3]
                                    }
                                end
                            end
                        end
                    end

                    for v160, v161 in v139.joints do
                        if not v155[v160] then
                            v139.current[v161] = nil
                        end
                    end

                    for v162, v163 in v155 do
                        local v164 = v139.joints[v162]

                        if v164 then
                            local v165 = (v139.current[v164] or v164.Transform):Lerp(toTransform(v164, v163), v138)

                            v139.current[v164] = v165
                            v164.Transform = v165
                        end
                    end
                else
                    table.clear(v139.current)
                end
            end
        end
    end)
    RunService.Heartbeat:Connect(function() -- line: 586
        -- upvalues: t6 (copy), updateBarbell (copy)
        for v166, v167 in t6 do
            updateBarbell(v167, v166, v167.pose == "Lift")
        end
    end)
end

return t1
