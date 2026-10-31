-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local v1 = RunService:IsServer()
local AnimalAnimations = if v1 then game:GetService("ServerStorage"):FindFirstChild("AnimalAnimations") else nil
local AnimationIds = require(ReplicatedStorage:WaitForChild("Config"):WaitForChild("AnimationIds"))
local v2 = AnimationIds.Player or {}
local v3 = AnimationIds.Animals or {}

local function playerClip(p1) -- line: 59
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:WaitForChild("Animations"):WaitForChild(p1)
end

local function assetId(p2) -- line: 63
    return "rbxassetid://" .. tostring(p2)
end

local t1 = {}
local t2 = {
    {
        Category = "Attack",
        Keywords = { "atk", "attack" }
    },
    {
        Category = "Swim",
        Keywords = { "swim" }
    },
    {
        Category = "Fly",
        Keywords = { "fly" }
    },
    {
        Category = "Walk",
        Keywords = { "walk", "run" }
    },
    {
        Category = "Idle",
        Keywords = { "idle" }
    }
}
local t3 = {
    "Walk",
    "Fly",
    "Swim"
}
local t4 = {
    "Idle",
    "Walk",
    "Swim",
    "Fly"
}
local t5 = {}
local t6 = {}
local t7 = {}
local t8 = {}

local function dropTrackCache(p3) -- line: 93
    -- upvalues: t7 (copy), t8 (copy)
    local v4 = t7[p3]

    if not v4 then
        return
    end

    t7[p3] = nil

    local v5 = t8[p3]

    t8[p3] = nil

    if v5 then
        for _, v6 in ipairs(v5) do
            v6:Disconnect()
        end
    end

    for _, v7 in pairs(v4) do
        local function v8() -- line: 103
            -- upvalues: v7 (copy)
            v7:Stop(0)
            v7:Destroy()
        end

        pcall(v8)
    end
end

local function getTrackCache(p4) -- line: 110
    -- upvalues: t7 (copy), t8 (copy), dropTrackCache (copy)
    local v9 = t7[p4]

    if v9 then
        return v9
    end

    local t9 = {}

    t7[p4] = t9
    t8[p4] = {
        p4.Destroying:Connect(function() -- line: 116
            -- upvalues: p4 (copy), dropTrackCache (copy)
            dropTrackCache(p4)
        end),
        p4.AncestryChanged:Connect(function() -- line: 119
            -- upvalues: p4 (copy), dropTrackCache (copy)
            if not p4:IsDescendantOf(game) then
                dropTrackCache(p4)
            end
        end)
    }

    return t9
end

local function categorize(p5) -- line: 128
    -- upvalues: t2 (copy)
    local v10 = string.lower(p5)

    if string.find(v10, "fish", 1, true) and string.find(v10, "walk", 1, true) then
        return "Swim"
    end

    for _, v11 in ipairs(t2) do
        for _, v12 in ipairs(v11.Keywords) do
            if string.find(v10, v12, 1, true) then
                return v11.Category
            end
        end
    end

    return nil
end

local function registerClip(p6) -- line: 144
    -- upvalues: KeyframeSequenceProvider (copy), t5 (copy)
    local v13 = t5[p6]

    if v13 then
        return v13
    end

    local function v14() -- line: 147
        -- upvalues: p6 (copy), KeyframeSequenceProvider (copy)
        return KeyframeSequenceProvider:RegisterKeyframeSequence(p6)
    end

    local ok, result = pcall(v14)

    if ok then
        t5[p6] = result

        return result
    end

    warn("[AnimationLibrary] Could not register clip " .. p6:GetFullName() .. ": " .. tostring(result))

    return nil
end

local function classify(p7) -- line: 159
    -- upvalues: categorize (copy)
    local t10 = {}

    for _, v15 in ipairs(p7) do
        local v16 = categorize(v15.Name)

        if v16 and not t10[v16] then
            t10[v16] = v15
        end
    end

    return t10
end

local function enumByValue(p8) -- line: 174
    local t11 = {}

    for _, v17 in ipairs(p8:GetEnumItems()) do
        t11[v17.Value] = v17
    end

    return t11
end

local PoseEasingStyle = Enum.PoseEasingStyle
local t12 = {}

for _, v18 in ipairs(PoseEasingStyle:GetEnumItems()) do
    t12[v18.Value] = v18
end

local PoseEasingDirection = Enum.PoseEasingDirection
local t13 = {}

for _, v19 in ipairs(PoseEasingDirection:GetEnumItems()) do
    t13[v19.Value] = v19
end

local AnimationPriority = Enum.AnimationPriority
local t14 = {}

for _, v20 in ipairs(AnimationPriority:GetEnumItems()) do
    t14[v20.Value] = v20
end

local function packPose(p9) -- line: 184
    -- upvalues: packPose (copy)
    local t15 = {
        n = p9.Name,
        c = p9.CFrame
    }

    if p9.Weight ~= 1 then
        t15.w = p9.Weight
    end

    if p9.EasingStyle ~= Enum.PoseEasingStyle.Linear then
        t15.e = p9.EasingStyle.Value
    end

    if p9.EasingDirection ~= Enum.PoseEasingDirection.In then
        t15.d = p9.EasingDirection.Value
    end

    for _, child in ipairs(p9:GetChildren()) do
        if child:IsA("Pose") then
            t15.k = t15.k or {}
            table.insert(t15.k, packPose(child))
        end
    end

    return t15
end

local function packClip(p10) -- line: 198
    -- upvalues: packPose (copy)
    local Keyframes = p10:GetKeyframes()

    table.sort(Keyframes, function(p11, p12) -- line: 200
        return p11.Time < p12.Time
    end)

    local t16 = {
        Name = p10.Name,
        Loop = p10.Loop,
        Priority = p10.Priority.Value,
        Keyframes = {}
    }

    for _, v21 in ipairs(Keyframes) do
        local t17 = {
            t = v21.Time,
            p = {}
        }

        if v21.Name ~= "Keyframe" then
            t17.n = v21.Name
        end

        for _, child in ipairs(v21:GetChildren()) do
            if child:IsA("Pose") then
                table.insert(t17.p, (packPose(child)))
            elseif child:IsA("KeyframeMarker") then
                t17.m = t17.m or {}
                table.insert(t17.m, {
                    n = child.Name,
                    v = child.Value
                })
            end
        end

        table.insert(t16.Keyframes, t17)
    end

    return t16
end

local t19 = {}

function t1.PackAnimal(p13) -- line: 221
    -- upvalues: v1 (copy), AnimalAnimations (copy), packClip (copy), t19 (copy)
    if not v1 then
        return nil
    end

    local v23 = t19[p13]

    if v23 then
        return v23
    end

    local t20 = {}
    local v24 = AnimalAnimations and AnimalAnimations:FindFirstChild(p13)

    if v24 then
        for _, child in ipairs(v24:GetChildren()) do
            if child:IsA("KeyframeSequence") then
                table.insert(t20, (packClip(child)))
            end
        end
    end

    t19[p13] = t20

    return t20
end

local function unpackPose(p14, p15) -- line: 239
    -- upvalues: t12 (copy), t13 (copy), unpackPose (copy)
    local Pose = Instance.new("Pose")

    Pose.Name = p14.n
    Pose.CFrame = p14.c
    Pose.Weight = p14.w or 1

    if p14.e then
        Pose.EasingStyle = t12[p14.e] or Enum.PoseEasingStyle.Linear
    end

    if p14.d then
        Pose.EasingDirection = t13[p14.d] or Enum.PoseEasingDirection.In
    end

    Pose.Parent = p15

    if p14.k then
        for _, v26 in ipairs(p14.k) do
            unpackPose(v26, Pose)
        end
    end
end

local function unpackClip(p16) -- line: 252
    -- upvalues: t14 (copy), unpackPose (copy)
    local KeyframeSequence = Instance.new("KeyframeSequence")

    KeyframeSequence.Name = p16.Name
    KeyframeSequence.Loop = p16.Loop
    KeyframeSequence.Priority = t14[p16.Priority] or Enum.AnimationPriority.Action

    for _, v27 in ipairs(p16.Keyframes) do
        local Keyframe = Instance.new("Keyframe")

        Keyframe.Time = v27.t

        if v27.n then
            Keyframe.Name = v27.n
        end

        for _, v28 in ipairs(v27.p) do
            unpackPose(v28, Keyframe)
        end

        if v27.m then
            for _, v29 in ipairs(v27.m) do
                local KeyframeMarker = Instance.new("KeyframeMarker")

                KeyframeMarker.Name = v29.n
                KeyframeMarker.Value = v29.v
                KeyframeMarker.Parent = Keyframe
            end
        end

        Keyframe.Parent = KeyframeSequence
    end

    return KeyframeSequence
end

local t21 = {}
local t22 = {}
local v30 = AnimalTemplates.Version()

local function checkCache() -- line: 282
    -- upvalues: AnimalTemplates (copy), t6 (copy), v30 (ref)
    local v31 = AnimalTemplates.Version()

    if v31 ~= v30 then
        v30 = v31
        table.clear(t6)
    end
end

function t1.EnsureAnimalClips(p17) -- line: 294
    -- upvalues: RunService (copy), Remotes (copy), AnimalTemplates (copy), v1 (copy), AnimalAnimations (copy), t4 (copy), t6 (copy), classify (copy), unpackClip (copy), t21 (copy), t22 (copy), v30 (ref), v3 (copy)
    local v32 = AnimalTemplates.Version()

    if v32 ~= v30 then
        v30 = v32
        table.clear(t6)
    end

    local v33 = t6[p17]

    if v33 then
        return v33
    end

    local v34 = AnimalTemplates.Get(p17)

    if not (v34 and v34:GetAttribute("PartMade")) then
        local v35 = v3[p17]

        if v35 then
            local t23 = {}

            for v36, v37 in pairs(v35) do
                t23[v36] = {
                    Id = "rbxassetid://" .. tostring(v37.Id),
                    Length = v37.Length
                }
            end

            t6[p17] = t23

            return t23
        end

        if not RunService:IsStudio() and not t22[p17] then
            t22[p17] = true
            warn("[AnimationLibrary] " .. tostring(p17) .. " has no uploaded animations (Config.AnimationIds) - it cannot animate in a live server")
        end

        if v1 then
            local t25 = {}
            local v38 = AnimalAnimations and AnimalAnimations:FindFirstChild(p17)

            if v38 then
                for _, child in ipairs(v38:GetChildren()) do
                    if child:IsA("KeyframeSequence") then
                        table.insert(t25, child)
                    end
                end
            end

            local v39 = classify(t25)

            t6[p17] = v39

            return v39
        end

        local v40 = t21[p17]

        if v40 then
            table.insert(v40, coroutine.running())

            return coroutine.yield()
        end

        local t26 = {}

        t21[p17] = t26

        local function v41() -- line: 359
            -- upvalues: p17 (copy), Remotes (copy)
            return Remotes.Function("Animations_Get"):InvokeServer(p17)
        end

        local ok, result = pcall(v41)
        local t27 = {}

        if not ok or type(result) ~= "table" then
            warn("[AnimationLibrary] Could not fetch the clips of " .. tostring(p17) .. ": " .. tostring(result))
        else
            for _, v42 in ipairs(result) do
                local ok, result = pcall(unpackClip, v42)

                if ok then
                    table.insert(t27, result)
                else
                    warn("[AnimationLibrary] Could not rebuild clip " .. tostring(v42.Name) .. " of " .. p17 .. ": " .. tostring(result))
                end
            end
        end

        local v43 = classify(t27)

        t6[p17] = v43
        t21[p17] = nil

        for _, v44 in ipairs(t26) do
            task.spawn(v44, v43)
        end

        return v43
    end

    local v45 = {}
    local v46 = false

    for _, v47 in ipairs(t4) do
        local Attribute = v34:GetAttribute("Anim_" .. v47)

        if type(Attribute) == "number" then
            local Attribute2 = v34:GetAttribute("AnimLen_" .. v47)
            local t28 = {
                Id = "rbxassetid://" .. tostring(Attribute),
                Length = type(Attribute2) == "number" and Attribute2 or 1
            }

            v46 = true
            v45[v47] = t28
        end
    end

    if not v46 then
        local t29 = {}
        local Clips = v34:FindFirstChild("Clips")

        if Clips then
            for _, child in ipairs(Clips:GetChildren()) do
                if child:IsA("KeyframeSequence") then
                    table.insert(t29, child)
                end
            end
        end

        v45 = classify(t29)
    end

    t6[p17] = v45

    return v45
end

function t1.HasAnimalClips(p18) -- line: 385
    -- upvalues: AnimalTemplates (copy), t6 (copy), v30 (ref), v3 (copy)
    local v48 = AnimalTemplates.Version()

    if v48 ~= v30 then
        v30 = v48
        table.clear(t6)
    end

    if t6[p18] == nil then
        local v49 = AnimalTemplates.Get(p18)

        if not (v49 and v49:GetAttribute("PartMade")) then
            return v3[p18] ~= nil
        end
    end

    return true
end

local function getAnimalClips(p19) -- line: 393
    -- upvalues: AnimalTemplates (copy), t1 (copy), t6 (copy), v30 (ref)
    local v50 = AnimalTemplates.Version()

    if v50 ~= v30 then
        v30 = v50
        table.clear(t6)
    end

    return t6[p19] or t1.EnsureAnimalClips(p19)
end

function t1.GetAnimalCategories(p20) -- line: 402
    -- upvalues: AnimalTemplates (copy), t1 (copy), t6 (copy), v30 (ref)
    local v51 = AnimalTemplates.Version()

    if v51 ~= v30 then
        v30 = v51
        table.clear(t6)
    end

    local v52 = t6[p20] or t1.EnsureAnimalClips(p20)
    local t30 = {}

    for v53 in pairs(v52) do
        t30[v53] = true
    end

    return t30
end

function t1.GetMoveCategory(p21) -- line: 410
    -- upvalues: AnimalTemplates (copy), t1 (copy), t3 (copy), t6 (copy), v30 (ref)
    local v54 = AnimalTemplates.Version()

    if v54 ~= v30 then
        v30 = v54
        table.clear(t6)
    end

    local v55 = t6[p21] or t1.EnsureAnimalClips(p21)

    for _, v56 in ipairs(t3) do
        if v55[v56] then
            return v56
        end
    end

    return if v55.Idle then "Idle" else nil
end

function t1.GetIdleCategory(p22) -- line: 421
    -- upvalues: AnimalTemplates (copy), t1 (copy), t6 (copy), v30 (ref)
    local v57 = AnimalTemplates.Version()

    if v57 ~= v30 then
        v30 = v57
        table.clear(t6)
    end

    if (t6[p22] or t1.EnsureAnimalClips(p22)).Idle then
        return "Idle"
    end

    return t1.GetMoveCategory(p22)
end

function t1.GetAnimalClipId(p23, p24) -- line: 427
    -- upvalues: AnimalTemplates (copy), t1 (copy), t6 (copy), registerClip (copy), v30 (ref)
    local v58 = AnimalTemplates.Version()

    if v58 ~= v30 then
        v30 = v58
        table.clear(t6)
    end

    local v59 = (t6[p23] or t1.EnsureAnimalClips(p23))[p24]

    if not v59 then
        return nil
    end

    if type(v59) == "table" then
        return v59.Id
    end

    return (registerClip(v59))
end

function t1.GetAnimalClipLength(p25, p26) -- line: 435
    -- upvalues: AnimalTemplates (copy), t1 (copy), t6 (copy), v30 (ref)
    local v60 = AnimalTemplates.Version()

    if v60 ~= v30 then
        v30 = v60
        table.clear(t6)
    end

    local v61 = (t6[p25] or t1.EnsureAnimalClips(p25))[p26]

    if not v61 then
        return 1
    end

    if type(v61) == "table" then
        return (math.max(v61.Length or 1, 0.05))
    end

    local n1 = 0

    for _, v63 in ipairs(v61:GetKeyframes()) do
        if n1 < v63.Time then
            n1 = v63.Time
        end
    end

    return (math.max(n1, 0.05))
end

function t1.GetThrowId() -- line: 447
    -- upvalues: playerClip (copy), registerClip (copy), v2 (copy)
    if v2.Throw then
        return "rbxassetid://" .. tostring(v2.Throw.Id)
    end

    return (registerClip(playerClip("Throw")))
end

function t1.GetPullUpId() -- line: 452
    -- upvalues: playerClip (copy), registerClip (copy), v2 (copy)
    if v2.PullUp then
        return "rbxassetid://" .. tostring(v2.PullUp.Id)
    end

    return (registerClip(playerClip("PullUp")))
end

function t1.GetPullUpLength() -- line: 457
    -- upvalues: ReplicatedStorage (copy), v2 (copy)
    if not (v2.PullUp and v2.PullUp.Length) then
        local PullUp = ReplicatedStorage:WaitForChild("Animations"):WaitForChild("PullUp")
        local n2 = 0

        for _, v64 in ipairs(PullUp:GetKeyframes()) do
            if n2 < v64.Time then
                n2 = v64.Time
            end
        end

        return (math.max(n2, 0.05))
    end

    return (math.max(v2.PullUp.Length, 0.05))
end

local function findHost(p27) -- line: 473
    return p27:FindFirstChildOfClass("Humanoid") or p27:FindFirstChildOfClass("AnimationController")
end

function t1.FindAnimator(p28) -- line: 479
    local v65 = p28:FindFirstChildOfClass("Humanoid") or p28:FindFirstChildOfClass("AnimationController")

    return v65 and v65:FindFirstChildOfClass("Animator") or nil
end

function t1.WaitForAnimator(p29, p30) -- line: 493
    -- upvalues: t1 (copy)
    local v66 = os.clock() + (p30 or 5)
    local v67

    while true do
        if not p29.Parent then
            return nil
        end

        v67 = t1.FindAnimator(p29)

        if v67 then
            break
        end

        if v66 <= os.clock() then
            return nil
        end

        task.wait(0.05)
    end

    return v67
end

function t1.GetAnimator(p31) -- line: 508
    local v68 = p31:FindFirstChildOfClass("Humanoid") or p31:FindFirstChildOfClass("AnimationController")

    if not v68 then
        v68 = Instance.new("AnimationController")
        v68.Parent = p31
    end

    local Animator = v68:FindFirstChildOfClass("Animator")

    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = v68
    end

    return Animator
end

function t1.Load(p32, p33) -- line: 523
    -- upvalues: t1 (copy), getTrackCache (copy)
    if not p33 then
        return nil
    end

    local v69 = t1.GetAnimator(p32)
    local v70 = getTrackCache(v69)
    local v71 = v70[p33]

    if v71 then
        return v71
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p33

    local function v72() -- line: 531
        -- upvalues: v69 (copy), Animation (copy)
        return v69:LoadAnimation(Animation)
    end

    local ok, result = pcall(v72)

    if ok then
        v70[p33] = result

        return result
    end

    warn("[AnimationLibrary] LoadAnimation failed on " .. p32:GetFullName() .. ": " .. tostring(result))

    return nil
end

function t1.Play(p34, p35, p36) -- line: 543
    -- upvalues: t1 (copy)
    p36 = p36 or {}

    local v74 = t1.Load(p34, p35)

    if not v74 then
        return nil
    end

    v74.Looped = p36.Looped ~= false

    if p36.Priority then
        v74.Priority = p36.Priority
    end

    v74:Play(p36.FadeTime or 0.2, p36.Weight or 1, p36.Speed or 1)

    return v74
end

function t1.PlayAnimal(p37, p38, p39) -- line: 554
    -- upvalues: t1 (copy)
    local v75 = p37:GetAttribute("AnimalName") or p37.Name
    local v76 = t1.GetAnimalClipId(v75, p38)
    local v77 = v76

    if not v76 then
        local v78 = p38 == "Idle" and t1.GetIdleCategory(v75) or t1.GetMoveCategory(v75)

        if v78 then
            v77 = t1.GetAnimalClipId(v75, v78)
        end
    end

    if v77 then
        return t1.Play(p37, v77, p39)
    end

    return nil
end

function t1.StopAll(p40, p41) -- line: 568
    local v79 = p40:FindFirstChildOfClass("Humanoid") or p40:FindFirstChildOfClass("AnimationController")
    local Animator = v79 and v79:FindFirstChildOfClass("Animator")

    if Animator then
        for _, v80 in ipairs(Animator:GetPlayingAnimationTracks()) do
            v80:Stop(p41 or 0.2)
        end
    end
end

return t1
