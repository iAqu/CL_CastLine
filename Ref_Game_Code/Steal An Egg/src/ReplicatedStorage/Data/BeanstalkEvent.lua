-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AuthoredMapPivot = game:GetService("ReplicatedStorage").Assets.BeanstalkEventAssets:GetAttribute("AuthoredMapPivot")

assert(typeof(AuthoredMapPivot) == "CFrame", "BeanstalkEventAssets needs an AuthoredMapPivot CFrame attribute")

local t1 = {
    Stage = table.freeze({
        Fireflies = 1,
        Watering = 2,
        WhaleFlight = 3,
        EggEscape = 4,
        Complete = 5
    }),
    StageAttribute = "BeanstalkStage",
    ProgressAttribute = "BeanstalkProgress",
    ClaimedAttribute = "BeanstalkClaimed",
    ParticipatingAttribute = "BeanstalkParticipating",
    StartedAtAttribute = "BeanstalkStartedAt",
    FinishedAtAttribute = "BeanstalkFinishedAt",
    RewardTitle = "Beanstalk Conquered!",
    PlaceAttribute = "BeanstalkPlace",
    MapFolderName = "BeanstalkEventMap",
    SlideExtraHeight = 750,
    LaunchSeconds = 3,
    EndingCutsceneSeconds = 38.55,
    EndingHandBackSeconds = 0.5,
    PlaceRewards = table.freeze({
        table.freeze({
            AssetId = "Amethyst Runebear OP",
            Mutations = { "Rainbow" },
            ScaleRange = NumberRange.new(1.8, 2.2)
        }),
        table.freeze({
            AssetId = "Amethyst Runebear OP",
            Mutations = { "Golden" },
            ScaleRange = NumberRange.new(1.8, 2.2)
        }),
        (table.freeze({
            AssetId = "Amethyst Runebear OP",
            ScaleRange = NumberRange.new(1.8, 2.2)
        }))
    }),
    FinisherReward = table.freeze({
        AssetId = "Amethyst Runebear"
    })
}

function t1.RewardFor(p1) -- line: 115
    -- upvalues: t1 (copy)
    return t1.PlaceRewards[p1] or t1.FinisherReward
end

function t1.MapShift(p2) -- line: 120
    -- upvalues: AuthoredMapPivot (copy)
    return p2:GetPivot() * AuthoredMapPivot:Inverse()
end

function t1.IsInsideBox(p3, p4, p5) -- line: 124
    local v2 = p3.CFrame:PointToObjectSpace(p4)
    local v3 = p3.Size * 0.5 + Vector3.new(1, 1, 1) * (p5 or 0)

    if math.abs(v2.X) <= v3.X then
        if not (math.abs(v2.Y) <= v3.Y) then
            return false
        end

        return math.abs(v2.Z) <= v3.Z
    end

    return false
end

function t1.IsOverFloor(p6, p7, p8) -- line: 133
    local v4 = p6.CFrame:PointToObjectSpace(p7)
    local v5 = p6.Size * 0.5

    if math.abs(v4.X) <= v5.X and math.abs(v4.Z) <= v5.Z and v4.Y >= v5.Y - 2 then
        return v4.Y <= v5.Y + p8
    end

    return false
end

return table.freeze(t1)
