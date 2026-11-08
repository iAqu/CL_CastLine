-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("Workspace")
game:GetService("ContentProvider")

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

require(ReplicatedStorage.Data.MountRace)

local Preload = require(ReplicatedStorage.Shared.Utils.Preload)

require(ReplicatedStorage.Shared.Remotes)

local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Trove.new()

Trove.new()

local function WarmAssets() -- line: 26
    -- upvalues: ReplicatedStorage (copy), Preload (copy)
    Preload.WarmAtWorkspace(script.Name, { ReplicatedStorage.CutsceneAssets.PumpkinBossCutsceneAssets })
end

task.spawn(function() -- line: 32
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Players (copy), Preload (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()

    if not (ServerTimeNow > 1792855200) then
        if not RunService:IsStudio() then
            local v2 = Random.new(Players.LocalPlayer.UserId + 1792854000)
            local v3 = ServerTimeNow < 1792850400

            if v3 then
                task.wait(1792850400 - ServerTimeNow)
            end

            local v4 = v3 and 600 or 60

            task.wait(v2:NextNumber(0, v4))
        end

        Preload.WarmAtWorkspace(script.Name, { ReplicatedStorage.CutsceneAssets.PumpkinBossCutsceneAssets })
    end
end)

return {
    StartEvent = function(_, _, p3) -- StartEvent | line: 61
        -- upvalues: ReplicatedStorage (copy), Players (copy), Debris (copy), v1 (copy)
        v1:Clean()

        if p3 and not p3.SkipCutscenes then
            local clone = ReplicatedStorage.CutsceneAssets.PumpkinBossCutsceneAssets.PlayVideo:Clone()

            clone.Parent = Players.LocalPlayer.PlayerGui
            clone.VideoFrame:Play()
            Debris:AddItem(clone, 30)
        end
    end,
    StopEvent = function(_) -- StopEvent | line: 72
        -- upvalues: v1 (copy)
        v1:Clean()
    end
}
