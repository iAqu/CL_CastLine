-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function rot(p1, p2, p3) -- line: 44
    return CFrame.Angles(math.rad(p1), math.rad(p2), (math.rad(p3)))
end

local function clip(p4, p5, p6) -- line: 48
    return {
        Animation = p4,
        Speed = p5 or 1,
        Looped = p6 == nil or p6
    }
end

local function animatorOf(p7) -- line: 56
    local v1 = p7:FindFirstChildOfClass("Humanoid") or p7:FindFirstChildOfClass("AnimationController")

    if v1 == nil then
        return nil
    end

    local Animator = v1:FindFirstChildOfClass("Animator")

    if Animator == nil then
        Animator = Instance.new("Animator")
        Animator.Parent = v1
    end

    return Animator
end

local function loadTracks(p8) -- line: 70
    local t3 = {}
    local v2 = p8:FindFirstChildOfClass("Humanoid") or p8:FindFirstChildOfClass("AnimationController")
    local Animator

    if v2 ~= nil then
        Animator = v2:FindFirstChildOfClass("Animator")

        if Animator == nil then
            Animator = Instance.new("Animator")
            Animator.Parent = v2
        end
    end

    local Animations = p8:FindFirstChild("Animations")

    if Animator ~= nil and Animations ~= nil then
        for _, child in Animations:GetChildren() do
            if child:IsA("Animation") then
                local LoadAnimation = Animator.LoadAnimation
                local ok, result = pcall(LoadAnimation, Animator, child)

                if ok and result then
                    result.Priority = Enum.AnimationPriority.Core
                    t3[child.Name] = result
                end
            end
        end
    end

    return t3
end

local function step(p9, p10) -- line: 89
    p9.Time += p10

    for v3, v4 in p9.Blend do
        local v5 = if v3 == p9.Mood then 1 else 0
        local v8 = v4 + (v5 - v4) * math.min(p10 * 6, 1)

        if v8 < 0.001 and v5 == 0 then
            p9.Blend[v3] = nil
        else
            p9.Blend[v3] = v8
        end
    end

    if p9.Blend[p9.Mood] == nil then
        p9.Blend[p9.Mood] = 0
    end

    local v9 = p9.Profile.Body(p9, p9.Time)

    p9.Primary.CFrame = p9.Root * CFrame.new(0, p9.Feet, 0) * v9
end

local function applyMood(p11) -- line: 107
    local v10 = p11.Profile.Clips[p11.Mood] or p11.Profile.Clips.Idle
    local v11 = v10 and p11.Tracks[v10.Animation]

    if v11 == nil then
        return
    end

    local Speed = v10.Speed
    local StrideStuds = p11.Profile.StrideStuds

    if StrideStuds and p11.Mood == "Run" then
        Speed = math.clamp(p11.Pace / StrideStuds, 0.6, 2.4)
    end

    if p11.Current == v11 then
        v11:AdjustSpeed(Speed)
    else
        if p11.Current then
            p11.Current:Stop(0.3)
        end

        v11.Looped = v10.Looped
        v11:Play(0.3, 1, Speed)
        p11.Current = v11
    end
end

function t1.new(p12, p13) -- line: 130
    -- upvalues: loadTracks (copy), step (copy), applyMood (copy)
    local PrimaryPart = p12.PrimaryPart
    local FeetOffset = p12:GetAttribute("FeetOffset")
    local t4 = {
        Mood = "",
        Pace = 0,
        Current = nil,
        Model = p12,
        Root = PrimaryPart.CFrame * CFrame.new(0, -(if typeof(FeetOffset) == "number" then FeetOffset else 0), 0),
        Time = math.random() * 10,
        Feet = if typeof(FeetOffset) ~= "number" then 0 else FeetOffset,
        Blend = {
            Idle = 1
        },
        Profile = p13,
        Tracks = loadTracks(p12),
        Primary = PrimaryPart,
        Step = step,
        SetRoot = function(p14, p15) -- line: 147
            p14.Root = p15
            p14.Primary.CFrame = p15 * CFrame.new(0, p14.Feet, 0)
        end,
        SetMood = function(p16, p17) -- line: 151
            -- upvalues: applyMood (copy)
            if p16.Mood == p17 then
                return
            end

            p16.Mood = p17

            if p16.Blend[p17] == nil then
                p16.Blend[p17] = 0
            end

            applyMood(p16)
        end,
        SetPace = function(p18, p19) -- line: 161
            -- upvalues: applyMood (copy)
            p18.Pace = p19

            if p18.Mood == "Run" then
                applyMood(p18)
            end
        end,
        Weight = function(p20, p21) -- line: 167
            return p20.Blend[p21] or 0
        end
    }

    t4.Play = function(p22, p23, p24, p25) -- line: 170
        local v13 = p22.Tracks[p23]

        if v13 == nil then
            return nil
        end

        v13.Priority = Enum.AnimationPriority.Action
        v13.Looped = false
        v13:Play(p24 or 0.2, 1, p25 or 1)

        return v13
    end

    t4.Destroy = function(p26) -- line: 180
        for _, v14 in p26.Tracks do
            v14:Stop(0)
            v14:Destroy()
        end

        table.clear(p26.Tracks)
        p26.Current = nil
    end

    t4:SetMood("Idle")

    return t4
end

local function weighted(p27, p28) -- line: 192
    local n1 = 0

    for v15 in p27.Blend do
        n1 += p27:Weight(v15)
    end

    local identity = CFrame.identity

    if n1 <= 0 then
        return identity
    end

    for v16, v17 in p28 do
        local v18 = p27:Weight(v16) / n1

        if v18 > 0 then
            identity = identity:Lerp(identity * v17, v18)
        end
    end

    return identity
end

t1.Dog = table.freeze({
    StrideStuds = 9,
    Clips = {
        Idle = {
            Animation = "Idle",
            Speed = 1,
            Looped = true
        },
        Sad = {
            Animation = "Idle",
            Speed = 0.7,
            Looped = true
        },
        Happy = {
            Animation = "Idle",
            Speed = 1.3,
            Looped = true
        },
        Talk = {
            Animation = "Idle",
            Speed = 1.1,
            Looped = true
        },
        Run = {
            Animation = "Walk",
            Speed = 1,
            Looped = true
        },
        Spin = {
            Animation = "Idle",
            Speed = 1.5,
            Looped = true
        }
    },
    Body = function(p29, p30) -- Body | line: 220
        -- upvalues: weighted (copy)
        local t6 = {
            Sad = CFrame.new(0, -0.1, 0) * CFrame.Angles(-0.05235987755982989, 0, 0)
        }

        t6.Happy = CFrame.new(0, math.abs((math.sin(p30 * 7))) * 0.5, 0)

        local v23 = CFrame.new(0, math.abs((math.sin(p30 * 9))) * 1.1, 0)
        local v24 = p30 * 540 % 360

        t6.Spin = v23 * CFrame.Angles(0, math.rad(v24), 0)

        return (weighted(p29, t6))
    end
})
t1.Fisherman = table.freeze({
    Clips = {
        Idle = {
            Animation = "Idle",
            Speed = 1,
            Looped = true
        },
        Talk = {
            Animation = "Look",
            Speed = 1,
            Looped = true
        },
        Pet = {
            Animation = "Idle",
            Speed = 0.8,
            Looped = true
        },
        Reel = {
            Animation = "Hold",
            Speed = 1,
            Looped = true
        },
        Cheer = {
            Animation = "Cheer",
            Speed = 1,
            Looped = true
        },
        Give = {
            Animation = "Point",
            Speed = 1,
            Looped = false
        }
    },
    Body = function(p31, p32) -- Body | line: 238
        -- upvalues: weighted (copy)
        local v26 = math.sin(p32 * 10) * 3 + -6

        return (weighted(p31, {
            Reel = CFrame.Angles(math.rad(v26), 0, 0),
            Pet = CFrame.new(0, -0.15, 0) * CFrame.Angles(-0.13962634015954636, 0, 0)
        }))
    end
})

return table.freeze(t1)
