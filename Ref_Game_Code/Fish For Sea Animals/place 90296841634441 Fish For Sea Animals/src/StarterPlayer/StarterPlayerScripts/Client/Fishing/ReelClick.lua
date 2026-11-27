-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Config = require(ReplicatedStorage.Shared.Config)
local Settings = require(script.Parent.Parent.UI.Settings)
local t1 = {}
local t2 = {
    0, 2, 4, 5, 7, 9, 11
}
local t3 = {}
local n1 = 1
local n2 = 0
local n3 = 0
local v1 = false
local v2 = Random.new()

local function semitones(p1) -- line: 36
    -- upvalues: t2 (copy)
    return t2[p1 % #t2 + 1] + p1 // #t2 * 12
end

local function ensureVoices() -- line: 40
    -- upvalues: ContentProvider (copy), SoundService (copy), Config (copy), Settings (copy), t3 (copy)
    if #t3 > 0 then
        return
    end

    for i = 1, 6 do
        local Sound = Instance.new("Sound")

        Sound.Name = "ReelClick" .. i
        Sound.SoundId = Config.Sounds.ReelClick
        Sound.SoundGroup = Settings.group("Sfx")
        Sound.Parent = SoundService
        t3[i] = Sound
    end

    task.spawn(pcall, ContentProvider.PreloadAsync, ContentProvider, { t3[1] })
end

function t1.reset() -- line: 56
    -- upvalues: n2 (ref), n3 (ref), v1 (ref), ensureVoices (copy)
    ensureVoices()
    n2 = 0
    n3 = 0
    v1 = false
end

function t1.play() -- line: 62
    -- upvalues: t2 (copy), t3 (copy), n1 (ref), n2 (ref), n3 (ref), v1 (ref), v2 (copy), ensureVoices (copy)
    ensureVoices()

    local elapsed = os.clock()

    if n3 > 0 then
        local v5 = math.floor(math.max(elapsed - n3 - 0.3, 0) / 0.12)

        n2 = math.max(n2 - v5, 0)
    end

    n3 = elapsed

    local v7 = n2

    if n2 >= 14 then
        v7 = if v1 then 13 else 14
        v1 = not v1
    else
        v1 = false
    end

    local v8 = v7 / 14
    local v9 = (t2[v7 % #t2 + 1] + v7 // #t2 * 12) * 100 + v2:NextNumber(-12, 12)
    local v10 = t3[n1]

    n1 = n1 % #t3 + 1
    v10.PlaybackSpeed = 0.8 * 2 ^ (v9 / 1200)
    v10.Volume = (v8 * 0.15000000000000002 + 0.4) * v2:NextNumber(0.92, 1.05)
    v10.TimePosition = 0
    v10:Play()
    n2 = math.min(n2 + 1, 14)
end

function t1.stop() -- line: 90
    -- upvalues: t3 (copy), n2 (ref), n3 (ref), v1 (ref)
    for _, v13 in t3 do
        v13:Stop()
    end

    n2 = 0
    n3 = 0
    v1 = false
end

return t1
