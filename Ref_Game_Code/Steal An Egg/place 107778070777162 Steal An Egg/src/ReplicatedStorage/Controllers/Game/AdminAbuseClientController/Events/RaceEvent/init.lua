-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

game:GetService("ContentProvider")
game:GetService("RunService")
game:GetService("Players")

local MountRace = require(ReplicatedStorage.Data.MountRace)

require(ReplicatedStorage.Shared.Utils.Preload)

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Trove.new()
local v2 = Trove.new()

local function playOutro() -- line: 27
    -- upvalues: Remotes (copy), v2 (copy)
    local v3 = v2:Extend()
    local Run = require(script.Cutscenes.OutroCutscene)(v3).Run
    local _warn = warn

    xpcall(Run, _warn)
    v3:Clean()
    Remotes.MountRace.OutroFinished:FireServer()
end

return {
    StartEvent = function(_, _, p3) -- StartEvent | line: 38
        -- upvalues: Workspace (copy), MountRace (copy), v1 (copy), v2 (copy), playOutro (copy)
        v1:Clean()
        v2:Clean()
        v2:Connect(Workspace:GetAttributeChangedSignal(MountRace.OutroAttribute), function() -- line: 42
            -- upvalues: Workspace (copy), MountRace (copy), playOutro (copy)
            if Workspace:GetAttribute(MountRace.OutroAttribute) == true then
                task.spawn(playOutro)
            end
        end)
        p3 = p3 or {}

        if p3.SkipCutscenes or p3.WasInProgress then
            return
        end

        local Run = require(script.Cutscenes.IntroCutscene)(v1).Run
        local _warn = warn

        if not xpcall(Run, _warn) then
            v1:Clean()
        end
    end,
    StopEvent = function(_) -- StopEvent | line: 59
        -- upvalues: v1 (copy), v2 (copy)
        v1:Clean()
        v2:Clean()
    end
}
