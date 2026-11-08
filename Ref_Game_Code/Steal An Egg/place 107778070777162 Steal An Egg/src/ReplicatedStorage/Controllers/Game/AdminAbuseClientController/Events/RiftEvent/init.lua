-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("Debris")
game:GetService("Lighting")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("ServerScriptService")
game:GetService("ServerStorage")
game:GetService("Workspace")

local BossEventFlags = require(ReplicatedStorage.Shared.Flags.BossEventFlags)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local v1 = require(ReplicatedStorage.Packages.Trove).new()
local v2 = false
local v3 = false

local function PlayCutscene1Async() -- line: 31
    -- upvalues: v1 (copy)
    require(script.Cutscene1)(v1).Run()
end

local function PlayCutscene2Async() -- line: 36
    -- upvalues: Players (copy), v1 (copy)
    Players.LocalPlayer:SetAttribute("RiftCutscene2Seen", true)
    require(script.Cutscene2)(v1).Run()
end

local t1 = {
    StartEvent = function(_, _) -- StartEvent | line: 46
        -- upvalues: BossEventFlags (copy), Remotes (copy), v1 (copy), v2 (ref), v3 (ref), PlayCutscene2Async (copy)
        if not BossEventFlags.ContentEnabled:Get() then
            return
        end

        v1:Clean()
        v2 = true
        v3 = false
        v1:Connect(Remotes.BossEvent.HealthShifted.OnClientEvent, function(p3) -- line: 55
            -- upvalues: v3 (ref), PlayCutscene2Async (copy)
            if v3 or p3 > 0 then
                return
            end

            v3 = true
            task.wait(4)
            task.spawn(PlayCutscene2Async)
        end)
        require(script.Cutscene1)(v1).Run()
    end,
    StopEvent = function(_) -- StopEvent | line: 67
        -- upvalues: v1 (copy), v2 (ref)
        v1:Clean()
        v2 = false
    end
}

BossEventFlags.ContentEnabled.Changed:Connect(function() -- line: 72
    -- upvalues: BossEventFlags (copy), v2 (ref), t1 (copy)
    if not BossEventFlags.ContentEnabled:Get() and v2 then
        t1:StopEvent()
    end
end)

return t1
