-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local UISystem = require(script.Parent.Parent.UISystem)
local LocalPlayer = Players.LocalPlayer

local function hasClaimed() -- line: 24
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute(BeanstalkEvent.ClaimedAttribute) == true
end

return {
    Run = function(p1, _, _, p4) -- Run | line: 32
        -- upvalues: BeanstalkEvent (copy), Remotes (copy), UISystem (copy), LocalPlayer (copy)
        UISystem.SetTask("EVENT COMPLETE")

        if not p4 then
            require(script.Parent.Parent.Cutscenes.EndingCutscene)(p1).Run()
        end

        while LocalPlayer:GetAttribute(BeanstalkEvent.ClaimedAttribute) ~= true do
            Remotes.BeanstalkEvent.AskClaimReward:FireServer(not p4)
            task.wait(1)
        end

        UISystem.Finish()
    end
}
