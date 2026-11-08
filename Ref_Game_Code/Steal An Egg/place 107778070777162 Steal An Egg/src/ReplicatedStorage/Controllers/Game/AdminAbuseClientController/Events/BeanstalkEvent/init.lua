-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

game:GetService("ContentProvider")
game:GetService("RunService")

local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local BeanstalkGrowth = require(script.BeanstalkGrowth)
local Completion = require(script.Stages.Completion)
local EggEscape = require(script.Stages.EggEscape)
local Fireflies = require(script.Stages.Fireflies)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Music = require(script.Music)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local UISystem = require(script.UISystem)
local Watering = require(script.Stages.Watering)
local WhaleFlight = require(script.Stages.WhaleFlight)
local LocalPlayer = Players.LocalPlayer
local Stage = BeanstalkEvent.Stage
local t1 = {
    [Stage.Fireflies] = Fireflies,
    [Stage.Watering] = Watering,
    [Stage.WhaleFlight] = WhaleFlight,
    [Stage.EggEscape] = EggEscape,
    [Stage.Complete] = Completion
}
local t2 = {
    [Stage.Fireflies] = "Stage1",
    [Stage.Watering] = "Stage2",
    [Stage.WhaleFlight] = "Stage3",
    [Stage.EggEscape] = "Stage4TrackA"
}
local v1 = Trove.new()
local v2 = Trove.new()
local v3 = false
local v4

local function waitForRig() -- line: 70
    -- upvalues: LocalPlayer (copy)
    local v5 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    return {
        Character = v5,
        Humanoid = v5:WaitForChild("Humanoid"),
        Root = v5:WaitForChild("HumanoidRootPart")
    }
end

local function applySky() -- line: 77
    -- upvalues: LightingController (copy)
    LightingController.SetLayer("BeanstalkEventSky", {
        Sky = LightingController.Presets.AdminAbuse.Sky
    }, 200)
end

local function runStage(p1) -- line: 85
    -- upvalues: BeanstalkEvent (copy), BeanstalkGrowth (copy), Music (copy), LocalPlayer (copy), Stage (copy), t1 (copy), t2 (copy), v2 (copy), v4 (ref), waitForRig (copy)
    v2:Clean()

    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)
    local v6 = v4
    local v7, v8

    if typeof(Attribute) ~= "number" or v6 == nil then
        return
    else
        v7 = t1[Attribute]
        v8 = v7 ~= nil
    end

    assert(v8, (("No Beanstalk stage module for stage %*"):format(Attribute)))
    BeanstalkGrowth.GrowTo(BeanstalkGrowth.HeightFor(Attribute))

    if Stage.Fireflies < Attribute then
        BeanstalkGrowth.SetBaseGrowth(1)
    end

    if Stage.Watering < Attribute then
        BeanstalkGrowth.SetWilted(0)
    end

    local v11 = t2[Attribute]

    if v11 ~= nil then
        Music.Play(v11)
    else
        Music.Release()
    end

    v2:Add(task.spawn(function() -- line: 109
        -- upvalues: p1 (copy), v6 (copy), v7 (ref), v2 (copy), waitForRig (copy)
        v7.Run(v2, v6, waitForRig(), p1)
    end))
end

return {
    StartEvent = function(_, _, p4) -- StartEvent | line: 118
        -- upvalues: Workspace (copy), BeanstalkEvent (copy), BeanstalkGrowth (copy), LightingController (copy), Music (copy), Remotes (copy), UISystem (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (ref), v4 (ref), runStage (copy)
        v1:Clean()
        v2:Clean()
        v3 = true

        local v12 = Workspace:WaitForChild(BeanstalkEvent.MapFolderName, 30)

        assert(v12 ~= nil and v12:IsA("Folder"), "The Beanstalk map never replicated")

        if not v3 then
            return
        end

        v4 = v12
        v1:Add(function() -- line: 130
            -- upvalues: v4 (ref)
            v4 = nil
        end)
        v1:Add(function() -- line: 133
            -- upvalues: LightingController (copy)
            LightingController.ClearLayer("BeanstalkEventSky")
        end)
        p4 = p4 or {}

        if not p4.SkipCutscenes and not p4.WasInProgress then
            LightingController.SetLayer("BeanstalkEventSky", {
                Sky = LightingController.Presets.AdminAbuse.Sky
            }, 200)
            require(script.Cutscenes.IntroCutscene)(v1).Run()

            if not v3 then
                return
            end

            Remotes.BeanstalkEvent.AskStartTimer:FireServer(p4.EnchantedForestRevealRunId)
        end

        local v15 = false

        local function onStage(p5) -- line: 153
            -- upvalues: v12 (copy), v15 (ref), BeanstalkEvent (copy), BeanstalkGrowth (copy), LightingController (copy), Music (copy), UISystem (copy), LocalPlayer (copy), v1 (copy), runStage (copy)
            if typeof(LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)) == "number" then
                if not v15 then
                    v15 = true
                    LightingController.SetLayer("BeanstalkEventSky", {
                        Sky = LightingController.Presets.AdminAbuse.Sky
                    }, 200)
                    UISystem.Start(v1)
                    Music.Start(v1)
                    BeanstalkGrowth.Start(v1, v12)
                end

                runStage(p5)
            end
        end

        v1:Connect(LocalPlayer:GetAttributeChangedSignal(BeanstalkEvent.StageAttribute), function() -- line: 168
            -- upvalues: onStage (copy)
            onStage(false)
        end)
        v1:Connect(LocalPlayer.CharacterAdded, function() -- line: 172
            -- upvalues: onStage (copy)
            onStage(true)
        end)
        onStage(false)
    end,
    StopEvent = function(_) -- StopEvent | line: 178
        -- upvalues: v1 (copy), v2 (copy), v3 (ref)
        v3 = false
        v2:Clean()
        v1:Clean()
    end
}
