-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

game:GetService("StarterGui")

local SoundService = game:GetService("SoundService")

game:GetService("ContentProvider")
game:GetService("RunService")

local TweenService = game:GetService("TweenService")
local SammyGuardSystem = require(script.SammyGuardSystem)
local StealingSystem = require(script.StealingSystem)
local Trove = require(ReplicatedStorage.Packages.Trove)
local UISystem = require(script.UISystem)
local v1 = require(script.CollectSystem)(t1)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local SammyEventVisuals = ReplicatedStorage.Assets.SammyEventVisuals
local v2 = Trove.new()
local v3 = false
local v4 = false

local function PlayMusic() -- line: 36
    -- upvalues: v2 (copy)
    script.Music:Play()
    v2:Add(function() -- line: 38
        script.Music:Stop()
    end)
end

local function MuteDefaultMusic() -- line: 43
    -- upvalues: SoundService (copy), TweenService (copy), v2 (copy)
    TweenService:Create(SoundService.Music.GameMusic, TweenInfo.new(0.5), {
        Volume = 0
    }):Play()
    v2:Add(function() -- line: 45
        -- upvalues: SoundService (copy), TweenService (copy)
        TweenService:Create(SoundService.Music.GameMusic, TweenInfo.new(0.5), {
            Volume = 1
        }):Play()
    end)
end

local function SetupSammyLightingAndMap() -- line: 50
    -- upvalues: Workspace (copy), LightingController (copy), SammyEventVisuals (copy), v2 (copy)
    LightingController.SetLayer("SammyEventLighting", "SammyEvent", 999, 0.01)
    v2:Add(function() -- line: 53
        -- upvalues: LightingController (copy)
        LightingController.ClearLayer("SammyEventLighting")
    end)

    local clone = SammyEventVisuals.Map:Clone()

    clone.Parent = Workspace
    v2:Add(clone)
end

t1.AssetTrove = v2

function t1.IsEventActive() -- line: 66
    -- upvalues: v3 (ref)
    return v3
end

function t1.StartEvent(_, p2, p3) -- line: 70
    -- upvalues: Workspace (copy), SammyGuardSystem (copy), StealingSystem (copy), UISystem (copy), v1 (copy), v2 (copy), v3 (ref), v4 (ref), MuteDefaultMusic (copy), SetupSammyLightingAndMap (copy)
    p3 = p3 or {}
    v2:Clean()
    v3 = true
    v4 = p3.SkipCutscenes
    Workspace:SetAttribute("ScrambleHUDAwaitingSammyOutro", not v4 and Workspace:GetAttribute("ScrambleHUDUnlocked") ~= true)

    local ServerTimeNow = Workspace:GetServerTimeNow()

    if not p3.SkipCutscenes and not p3.WasInProgress then
        require(script.Cutscenes.IntroCutscene)(v2).Run()
    end

    local v6 = Workspace:GetServerTimeNow() - ServerTimeNow

    SetupSammyLightingAndMap()
    MuteDefaultMusic()
    script.Music:Play()
    v2:Add(function() -- line: 38
        script.Music:Stop()
    end)
    v1.Start()
    SammyGuardSystem.Start(v2)
    StealingSystem.Start(v2)
    UISystem.Start(v2, Workspace:GetServerTimeNow() + p2 - v6)
end

function t1.StopEvent(_) -- line: 100
    -- upvalues: Workspace (copy), StealingSystem (copy), UISystem (copy), v1 (copy), v2 (copy), v3 (ref), v4 (ref)
    v3 = false
    UISystem.Stop()
    StealingSystem.Stop()
    v1.Clear()
    v2:Clean()

    if not v4 then
        require(script.Cutscenes.OutroCutscene1)(v2).Run()
        require(script.Cutscenes.OutroCutscene2)(v2).Run()
        v2:Clean()
    end

    Workspace:SetAttribute("ScrambleHUDAwaitingSammyOutro", nil)
end

return t1
