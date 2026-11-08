-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)

require(ReplicatedStorage.Data.Gears)
require(ReplicatedStorage.Shared.Globals.Constants)

local Gears = require(ReplicatedStorage.Data.Gears)
local GunCatalog = require(ReplicatedStorage.Client.Util.GunCatalog)
local v1 = require(ReplicatedStorage.Packages.Log).new()
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ToolSetup = require(ReplicatedStorage.Client.Util.ToolSetup)
local t = require(ReplicatedStorage.Packages.t)

return {
    Start = function() -- Start | line: 24
        -- upvalues: Players (copy), Audio (copy), Gears (copy), GunCatalog (copy), v1 (copy), Remotes (copy), ToolSetup (copy), t (copy)
        local v2 = GunCatalog.ListGearNames()
        local LocalPlayer = Players.LocalPlayer
        local CurrentCamera = workspace.CurrentCamera
        local v3

        local function createWallCheckParams(p1) -- line: 34
            local v4 = RaycastParams.new()

            v4.FilterType = Enum.RaycastFilterType.Exclude

            local t2 = {
                p1
            }
            local Tool = p1:FindFirstChildOfClass("Tool")

            if Tool then
                table.insert(t2, Tool)
            end

            v4.FilterDescendantsInstances = t2
            v4.IgnoreWater = true

            return v4
        end

        local function isShootPathBlocked(p2, _, p4) -- line: 49
            -- upvalues: createWallCheckParams (copy)
            if not p4 or not p2 then
                return true
            end

            local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart")

            if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
                return true
            end

            local v5 = p4:FindFirstChild("Right Arm")

            if not v5 then
                return true
            end

            local RightShoulderAttachment = v5:FindFirstChild("RightShoulderAttachment")

            if not RightShoulderAttachment then
                return true
            end

            local v6 = p2.WorldPosition - RightShoulderAttachment.WorldPosition
            local v7 = createWallCheckParams(p4)

            return workspace:Raycast(RightShoulderAttachment.WorldPosition, v6, v7) ~= nil
        end

        local function getArmShootPosition(p5, p6) -- line: 85
            -- upvalues: LocalPlayer (copy), CurrentCamera (copy), isShootPathBlocked (copy)
            if not p5 then
                return Vector3.new(0, 0, 0), Vector3.new(0, 0, 0), true
            end

            local Mouse = LocalPlayer:GetMouse()
            local v8 = CurrentCamera:ScreenPointToRay(Mouse.X, Mouse.Y)
            local v9 = v8.Origin + v8.Direction * 1000
            local v10 = RaycastParams.new()

            v10.FilterType = Enum.RaycastFilterType.Exclude

            local t3 = {
                p6
            }
            local Tool = p6:FindFirstChildOfClass("Tool")

            if Tool then
                table.insert(t3, Tool)
            end

            v10.FilterDescendantsInstances = t3
            v10.IgnoreWater = true

            local v11 = workspace:Raycast(v8.Origin, v8.Direction * 1000, v10)

            if v11 then
                v9 = v11.Position
            end

            local WorldPosition = p5.WorldPosition
            local Unit = (v9 - WorldPosition).Unit

            return WorldPosition, Unit, (isShootPathBlocked(p5, Unit, p6))
        end

        local function onActivated(p7) -- line: 124
            -- upvalues: LocalPlayer (copy), v3 (ref), getArmShootPosition (copy), v1 (copy), Remotes (copy), t (copy)
            local Character = LocalPlayer.Character

            if not Character then
                return
            end

            local v13 = assert(p7:FindFirstChild("Shoot", true), "Shoot Attachment not found")

            t.strict(t.instanceIsA("Attachment"))(v13)

            local v14, v15, v16 = getArmShootPosition(v13, Character)

            if v16 then
                v1:AtDebug():Log("Shoot blocked by wall - preventing fire")
            else
                Remotes.GunGadget.AskDischarge:FireServer(v3:GetCurrentToolGearName(), v14, v15)
            end
        end

        local function onEquipped() -- line: 147
            -- upvalues: v3 (ref), Audio (copy), Gears (copy)
            local CurrentToolGearName = v3:GetCurrentToolGearName()

            if CurrentToolGearName then
                local EQUIP_SFX = Gears.Directory[CurrentToolGearName].EQUIP_SFX

                if EQUIP_SFX then
                    Audio.PlayFile(EQUIP_SFX, script)
                end
            end
        end

        local function onUnequipped() -- line: 162
            -- upvalues: v3 (ref), Remotes (copy)
            Remotes.GunGadget.DropCaster:FireServer(v3:GetCurrentToolGearName())
        end

        v3 = ToolSetup.Attach(v2, {
            onActivated = onActivated,
            onEquipped = onEquipped,
            onUnequipped = onUnequipped
        })
    end
}
