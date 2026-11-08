-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ActiveAssetsController = require(script.Parent.Parent.Parent.Plots.ActiveAssetsController)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer)
local SubBiomeCycle = require(ReplicatedStorage.Shared.Util.SubBiomeCycle)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = require(script.RingSystem)(t1)
local v2 = require(script.FlyingSystem)(t1)
local v3 = require(script.TeamSystem)(t1)
local UISystem = require(script.UISystem)
local v4 = require(script.PowerUpSystem)(t1)
local v5 = require(script.MusicSystem)(t1)
local v6 = Color3.fromRGB(255, 138, 236)
local v7 = Trove.new()
local v8 = false

local function setPlotsHidden(p1) -- line: 39
    -- upvalues: ActiveAssetsController (copy), PlacedEggRenderer (copy)
    ActiveAssetsController.SetAllPetsHidden(p1)
    PlacedEggRenderer.SetAllHidden(p1)
end

t1.AssetTrove = v7

t1.IsEventActive = function() -- line: 47
    -- upvalues: v8 (ref)
    return v8
end

function t1.StartEvent(_, p3, p4) -- line: 51
    -- upvalues: Workspace (copy), ActiveAssetsController (copy), PlacedEggRenderer (copy), v1 (copy), v2 (copy), v3 (copy), UISystem (copy), v4 (copy), v5 (copy), v7 (copy), v8 (ref)
    v7:Clean()
    v8 = true

    local v9 = 0

    if not (p4 and p4.WasInProgress) then
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v10 = require(script.Cutscenes.IntroCutscene)(v7)

        ActiveAssetsController.SetAllPetsHidden(true)
        PlacedEggRenderer.SetAllHidden(true)
        v7:Add(function() -- line: 61
            -- upvalues: ActiveAssetsController (copy), PlacedEggRenderer (copy)
            ActiveAssetsController.SetAllPetsHidden(false)
            PlacedEggRenderer.SetAllHidden(false)
        end)
        v10.Run()
        ActiveAssetsController.SetAllPetsHidden(false)
        PlacedEggRenderer.SetAllHidden(false)
        v9 = Workspace:GetServerTimeNow() - ServerTimeNow
    end

    v1.Start()
    v2.Start()
    v3.Start()
    v4.Start()
    v5.Start()
    UISystem.Start(v7, Workspace:GetServerTimeNow() + p3 - v9 - 5)
end

function t1.StopEvent(_) -- line: 75
    -- upvalues: Workspace (copy), Toast (copy), SubBiomeCycle (copy), v2 (copy), v3 (copy), UISystem (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (ref)
    v8 = false
    v7:Clean()
    v2.Stop()
    v3.Stop()
    v4.Stop()
    v5.Stop()
    UISystem.Stop()
    task.wait(0.1)

    local LIGHT_VS_DARK_WINNER = Workspace:GetAttribute("LIGHT_VS_DARK_WINNER")

    if LIGHT_VS_DARK_WINNER then
        if LIGHT_VS_DARK_WINNER == "Light" then
            require(script.Cutscenes.EndCutsceneLight)(v7).Run()
            v7:Clean()
        elseif LIGHT_VS_DARK_WINNER == "Darkness" then
            require(script.Cutscenes.EndCutsceneDark)(v7).Run()
            v7:Clean()
        end

        if SubBiomeCycle.RevealPhaseAt("Light Dark", Workspace:GetServerTimeNow()) == "RevealNight" then
            Toast.Show({
                Lane = "Banner",
                Text = "⚔️ The battle was won... the Light and Dark biomes have arrived! One of 3 biomes can appear each night!",
                Seconds = 8,
                Color = v6
            })
        end
    else
        error("Winner is nil")
    end
end

return t1
