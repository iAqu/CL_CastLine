-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local Lanes = require(script.Parent.Lanes)
local GoldenNotif = ReplicatedStorage.Assets.UI.Notifs.GoldenNotif
local t1 = {
    Show = function() -- Show | line: 17
        -- upvalues: Audio (copy), ButterflyCatalog (copy), Lanes (copy), GoldenNotif (copy)
        Lanes.Schedule({
            Lane = "Banner",
            Seconds = 5,
            UniqueKey = "GoldenButterfly",
            Frame = GoldenNotif:Clone(),
            OnShown = function() -- OnShown | line: 23
                -- upvalues: Audio (copy), ButterflyCatalog (copy)
                Audio.Play(ButterflyCatalog.Sounds.GoldenAnnounce, script, {
                    Volume = 0.85
                })
            end
        })
    end
}

return table.freeze(t1)
