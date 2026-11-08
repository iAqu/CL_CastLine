-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Lanes = require(script.Parent.Lanes)
local GhostBossNotif = ReplicatedStorage.Assets.UI.Notifs.GhostBossNotif
local t1 = {}

local function announceSound() -- line: 16
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Sounds = Assets and Assets:FindFirstChild("Sounds")
    local BossEventSounds = Sounds and Sounds:FindFirstChild("BossEventSounds")
    local v1 = BossEventSounds and BossEventSounds:FindFirstChild("Blackhole Spawn")

    return if v1 and v1:IsA("Sound") then v1 else nil
end

function t1.Show() -- line: 24
    -- upvalues: Audio (copy), Lanes (copy), GhostBossNotif (copy), announceSound (copy)
    Lanes.Schedule({
        Lane = "Banner",
        Seconds = 5,
        UniqueKey = "GhostBoss",
        Frame = GhostBossNotif:Clone(),
        OnShown = function() -- OnShown | line: 30
            -- upvalues: Audio (copy), announceSound (copy)
            local v2 = announceSound()

            if v2 then
                Audio.Play(v2, script, {
                    Volume = 0.7,
                    PlaybackSpeed = 1.15
                })
            end
        end
    })
end

return table.freeze(t1)
