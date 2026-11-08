-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AreaEggs = require(ReplicatedStorage.Shared.Types.AreaEggs)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local EggState = require(ReplicatedStorage.Client.EggState)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local Log = require(ReplicatedStorage.Packages.Log)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Timer = require(ReplicatedStorage.Packages.Timer)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local PlayerRequest = AreaEggs.DropReasons.PlayerRequest
local Carrying = HalloweenDimension.PlayerAttributes.Carrying
local v1 = Log.new()
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 35
        -- upvalues: ButtonFX (copy), EggState (copy), GUI (copy), Remotes (copy), Timer (copy), ToolGameplayGuard (copy), Trove (copy), PlayerRequest (copy), Carrying (copy), v1 (copy), LocalPlayer (copy)
        local v2 = GUI.DropHeldEgg()
        local v3 = Trove.new()
        local v4 = false

        local function isDimensionCarrying() -- line: 44
            -- upvalues: Carrying (copy), LocalPlayer (copy)
            return LocalPlayer:GetAttribute(Carrying) == true
        end

        local function updateVisibility() -- line: 48
            -- upvalues: v2 (copy), v4 (ref), ToolGameplayGuard (copy), Carrying (copy), LocalPlayer (copy)
            v2.Enabled = v4 and ToolGameplayGuard.IsLocalInsideArena() or LocalPlayer:GetAttribute(Carrying) == true
        end

        local function setCarrying(p1) -- line: 53
            -- upvalues: v2 (copy), v4 (ref), ToolGameplayGuard (copy), Carrying (copy), LocalPlayer (copy)
            v4 = p1.IsCarrying
            v2.Enabled = v4 and ToolGameplayGuard.IsLocalInsideArena() or LocalPlayer:GetAttribute(Carrying) == true
        end

        v2.Enabled = false
        ButtonFX(v2.Button, nil, function() -- line: 64
            -- upvalues: v2 (copy), v4 (ref), EggState (copy), Remotes (copy), ToolGameplayGuard (copy), PlayerRequest (copy), Carrying (copy), v1 (copy), LocalPlayer (copy)
            if LocalPlayer:GetAttribute(Carrying) == true then
                local v7, v8 = Remotes.HalloweenDimension.AskDropEgg:InvokeServer()

                if not v7 and v8 ~= nil then
                    v1:AtDebug():Log((("Drop dimension egg denied for %*: %*"):format(LocalPlayer.UserId, v8)))
                end

                v2.Enabled = v4 and ToolGameplayGuard.IsLocalInsideArena() or LocalPlayer:GetAttribute(Carrying) == true
            elseif ToolGameplayGuard.IsLocalInsideArena() then
                local v10, v11 = EggState.DropFieldEgg(PlayerRequest)

                if not v10 and v11 ~= nil then
                    v1:AtDebug():Log((("Drop held area egg denied for %*: %*"):format(LocalPlayer.UserId, v11)))
                end
            else
                v2.Enabled = v4 and ToolGameplayGuard.IsLocalInsideArena() or LocalPlayer:GetAttribute(Carrying) == true
            end
        end)
        v3:Add(Timer.Simple(0.1, updateVisibility, true))
        v3:Add(EggState.CarryChanged:Connect(setCarrying))
        v3:Add(LocalPlayer:GetAttributeChangedSignal(Carrying):Connect(updateVisibility))
        v3:AttachToInstance(script)
    end
}
