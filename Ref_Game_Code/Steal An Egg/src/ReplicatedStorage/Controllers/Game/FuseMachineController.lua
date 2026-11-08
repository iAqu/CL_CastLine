-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Directory = require(ReplicatedStorage.Data.Assets).Directory
local Audio = require(ReplicatedStorage.Shared.Audio)

require(ReplicatedStorage.Shared.Globals.Constants)

local FuseMachineMotion = require(ReplicatedStorage.Client.FuseMachineMotion)
local FuseMachineSignals = require(ReplicatedStorage.Client.FuseMachineSignals)
local FuseMachine = require(ReplicatedStorage.Shared.Types.FuseMachine)
local Log = require(ReplicatedStorage.Packages.Log)
local Message = require(ReplicatedStorage.Client.Message)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local v1 = Log.new()

return {
    Start = function() -- Start | line: 31
        -- upvalues: Workspace (copy), Directory (copy), Audio (copy), FuseMachineMotion (copy), FuseMachineSignals (copy), FuseMachine (copy), Message (copy), Toast (copy), Remotes (copy), Tabs (copy), v1 (copy)
        local Machines = Workspace:WaitForChild("World").Machines

        assert(Machines:IsA("Folder"), "Workspace.World.Machines must be a Folder")

        local FuseMachine2 = Machines.FuseMachine

        assert(FuseMachine2:IsA("Model"), "Workspace FuseMachine must be a Model")

        local Machine = FuseMachine2.Machine

        assert(Machine:IsA("BasePart"), "FuseMachine.Machine must be a BasePart")

        local Attachment = Machine.Attachment

        assert(Attachment:IsA("Attachment"), "FuseMachine.Machine.Attachment must be an Attachment")

        local ProximityPrompt = Attachment.ProximityPrompt

        assert(ProximityPrompt:IsA("ProximityPrompt"), "FuseMachine proximity prompt must be a ProximityPrompt")

        local n1 = 0

        local function notifyError(p1) -- line: 49
            -- upvalues: Toast (copy)
            Toast.Show({
                Seconds = 3,
                Text = p1,
                Color = Color3.fromRGB(255, 0, 0)
            })
        end

        local function playFuseAndGrant(p2) -- line: 57
            -- upvalues: FuseMachine2 (copy), Machine (copy), ProximityPrompt (copy), n1 (ref), Directory (copy), Audio (copy), FuseMachineMotion (copy), Message (copy), Toast (copy), Remotes (copy), Tabs (copy), v1 (copy)
            local AssetCategory = p2.AssetCategory
            local v2 = Directory[AssetCategory]

            if v2 ~= nil then
                local Egg = v2.Egg

                n1 += 1

                local v3 = n1

                ProximityPrompt.Enabled = false

                if FuseMachineMotion.Run(FuseMachine2, Machine, function() -- line: 72
                    -- upvalues: v3 (copy), n1 (ref)
                    return n1 == v3
                end) then
                    Audio.Play(103131639134026, script)
                    Message.Notice(("You fused <font color=\"#%*\">%*</font>"):format(v2.Rarity.Color:ToHex(), Egg.DisplayName), {
                        LeaveClosed = true,
                        Image = Egg.Icon
                    })

                    local v4, v5 = Remotes.Fusery.FinishReveal:InvokeServer()

                    if not v4 then
                        local v6 = if typeof(v5) == "string" then v5 else "Failed to grant fused egg"

                        Toast.Show({
                            Seconds = 3,
                            Text = v6,
                            Color = Color3.fromRGB(255, 0, 0)
                        })
                    end

                    ProximityPrompt.Enabled = true
                    Tabs.Deactivate({
                        instant = true
                    })
                else
                    ProximityPrompt.Enabled = true
                end
            else
                v1:AtError():Log("Fuse result category has no asset config", {
                    Category = AssetCategory
                })
            end
        end

        ProximityPrompt.ActionText = "Fuse Pets"
        ProximityPrompt.Triggered:Connect(function() -- line: 103
            -- upvalues: Tabs (copy)
            Tabs.Activate("PetFuse")
        end)
        FuseMachineSignals.FuseStarted:Connect(function(p3) -- line: 105
            -- upvalues: playFuseAndGrant (copy), FuseMachine (copy)
            assert(FuseMachine.FuseResult(p3), "Fuse started signal requires a valid serialized reward egg")
            task.spawn(playFuseAndGrant, p3)
        end)
    end
}
