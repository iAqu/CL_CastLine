-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Preload = require(ReplicatedStorage.Shared.Utils.Preload)
local v1 = table.freeze({
    KeyTurn = "rbxassetid://116122774582166",
    Ratchet = "rbxassetid://79199310694455",
    KeyThunk = "rbxassetid://93471936378241",
    ChainSnap = "rbxassetid://94606155495585",
    LinkClink = "rbxassetid://89384724133841",
    DoorSlam = "rbxassetid://107387051232862",
    Draft = "rbxassetid://99449925503203",
    ChainRattle = "rbxassetid://96614250520996",
    PadlockClunk = "rbxassetid://116406137162867",
    Creak = "rbxassetid://120769059226866",
    Shimmer = "rbxassetid://124699703411879",
    Boom = "rbxassetid://119977062667102"
})
local t1 = {
    Ids = v1
}

local function group() -- line: 37
    -- upvalues: SoundService (copy)
    local Gameplay = SoundService:FindFirstChild("Gameplay")

    return if Gameplay ~= nil and Gameplay:IsA("SoundGroup") then Gameplay else nil
end

function t1.Warm() -- line: 46
    -- upvalues: Preload (copy), v1 (copy)
    local t2 = {}

    for _, v2 in v1 do
        table.insert(t2, v2)
    end

    task.spawn(Preload.WarmSounds, t2)
end

function t1.Play(p1, p2, p3, p4) -- line: 54
    -- upvalues: SoundService (copy), Audio (copy), v1 (copy)
    local v3 = v1[p1]

    if v3 == nil then
        return nil
    end

    local Play = Audio.Play
    local _script = script
    local Gameplay = SoundService:FindFirstChild("Gameplay")

    if Gameplay == nil or not Gameplay:IsA("SoundGroup") then
        Gameplay = nil
    end

    return Play(v3, _script, {
        SoundGroup = Gameplay,
        Volume = p2,
        PlaybackSpeed = p3 or 1,
        TimePosition = p4
    })
end

function t1.At(p5, p6, p7, p8) -- line: 67
    -- upvalues: SoundService (copy), Audio (copy), v1 (copy)
    local v4 = v1[p5]

    if v4 == nil then
        return nil
    end

    local Play = Audio.Play
    local t4 = {
        MaxDistance = 260
    }
    local Gameplay = SoundService:FindFirstChild("Gameplay")

    t4.SoundGroup = if Gameplay == nil or not Gameplay:IsA("SoundGroup") then nil else Gameplay
    t4.Volume = p7
    t4.PlaybackSpeed = p8 or 1

    return Play(v4, p6, t4)
end

return table.freeze(t1)
