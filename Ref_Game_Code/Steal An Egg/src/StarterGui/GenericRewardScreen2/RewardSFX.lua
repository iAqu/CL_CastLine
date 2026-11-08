-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local SoundService = game:GetService("SoundService")
local t1 = {}
local t2 = {
    Reward = "129831855124668"
}
local t3 = {
    Reward = {
        Volume = 0.65,
        Throttle = 0.3,
        NoRetrigger = true
    }
}

local function normalise(p1) -- line: 39
    return (p1:gsub("%W", ""):lower():gsub("sfx$", ""))
end

local t4 = {
    keyreward = "Reward",
    rewardsfx = "Reward"
}
local t5 = {}

for v1 in pairs(t2) do
    t5[v1:gsub("%W", ""):lower():gsub("sfx$", "")] = v1
end

for v2, v3 in pairs(t4) do
    t5[v2] = v3
end

local Parent = script.Parent
local v4 = Parent and script.Parent:FindFirstChild("SFX")
local RewardScreen = SoundService:FindFirstChild("RewardScreen")
local v5 = RewardScreen

if not RewardScreen then
    local SoundGroup = Instance.new("SoundGroup")

    v5 = SoundGroup
    SoundGroup.Name = "RewardScreen"
    SoundGroup.Volume = 1
    SoundGroup.Parent = SoundService
end

local t6 = {}
local t7 = {}

local function resolveSource(p2) -- line: 72
    -- upvalues: t2 (copy), t5 (copy), v4 (ref)
    if v4 then
        for _, child in ipairs(v4:GetChildren()) do
            if child:IsA("Sound") and t5[child.Name:gsub("%W", ""):lower():gsub("sfx$", "")] == p2 then
                return child.SoundId
            end
        end
    end

    local v6 = t2[p2]

    if not v6 or v6 == "" then
        return nil
    end

    if tonumber(v6) then
        return "rbxassetid://" .. v6
    end

    return v6
end

local function buildSound(p3) -- line: 93
    -- upvalues: t3 (copy), v5 (ref), resolveSource (copy)
    local v7 = resolveSource(p3)
    local v8

    if not v7 or v7 == "" then
        return nil
    else
        v8 = t3[p3] or {}
    end

    local v10 = v5:FindFirstChild(p3)

    if v10 then
        v10:Destroy()
    end

    local Sound = Instance.new("Sound")

    Sound.Name = p3
    Sound.SoundId = v7
    Sound.Volume = v8.Volume or 0.5
    Sound.PlaybackSpeed = v8.PlaybackSpeed or 1
    Sound.SoundGroup = v5
    Sound.Parent = v5

    return Sound
end

for v11 in pairs(t2) do
    t6[v11] = buildSound(v11)
end

function t1.play(p4) -- line: 121
    -- upvalues: t3 (copy), t6 (copy), t7 (copy)
    local v12 = t6[p4]

    if not v12 then
        return
    end

    local v13 = t3[p4] or {}

    if v13.NoRetrigger and v12.IsPlaying then
        return
    end

    local v14 = v13.Throttle or 0.05
    local elapsed = os.clock()

    if t7[p4] and elapsed - t7[p4] < v14 then
        return
    end

    t7[p4] = elapsed
    v12.TimePosition = 0
    v12:Play()
end

function t1.stop(p5) -- line: 144
    -- upvalues: t6 (copy)
    local v15 = t6[p5]

    if v15 then
        v15:Stop()
    end
end

function t1.setVolume(p6) -- line: 151
    -- upvalues: v5 (ref)
    v5.Volume = math.clamp(p6, 0, 1)
end

function t1.refresh() -- line: 156
    -- upvalues: t2 (copy), v4 (ref), t6 (copy), buildSound (copy)
    v4 = script.Parent and script.Parent:FindFirstChild("SFX")

    for v17, v18 in pairs(t6) do
        if v18 then
            v18:Destroy()
        end

        t6[v17] = nil
    end

    for v19 in pairs(t2) do
        t6[v19] = buildSound(v19)
    end
end

function t1.preload() -- line: 171
    -- upvalues: ContentProvider (copy), t6 (copy)
    task.spawn(function() -- line: 172
        -- upvalues: ContentProvider (copy), t6 (copy)
        local t8 = {}

        for _, v20 in pairs(t6) do
            if v20 then
                t8[#t8 + 1] = v20
            end
        end

        if #t8 > 0 then
            local function v21() -- line: 180
                -- upvalues: t8 (copy), ContentProvider (copy)
                ContentProvider:PreloadAsync(t8)
            end

            pcall(v21)
        end
    end)
end

return t1
