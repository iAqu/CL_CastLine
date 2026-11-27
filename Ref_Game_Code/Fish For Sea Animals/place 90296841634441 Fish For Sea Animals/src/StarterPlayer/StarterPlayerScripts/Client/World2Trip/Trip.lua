-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Controls = require(script.Parent.Parent.Character.Controls)
local Poses = require(script.Parent.Parent.Character.Poses)
local TripUi = require(script.Parent.TripUi)
local TripSet = require(script.Parent.TripSet)
local TripCave = require(script.Parent.TripCave)
local TripDeep = require(script.Parent.TripDeep)
local TripTour = require(script.Parent.TripTour)
local LocalPlayer = Players.LocalPlayer
local v1 = false
local v2 = false
local t1 = {}

function t1.isPlaying() -- line: 43
    -- upvalues: v1 (ref)
    return v1
end

local function hideHeld(p1, p2) -- line: 48
    for _, v3 in { "RodModel", "HeldAnimal" } do
        local v4 = p1:FindFirstChild(v3)

        if v4 then
            for _, descendant in v4:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = p2 and 1 or 0
                end
            end
        end
    end
end

function t1.play(p3) -- line: 63
    -- upvalues: Remotes (copy), Controls (copy), Poses (copy), TripUi (copy), TripSet (copy), TripCave (copy), TripDeep (copy), TripTour (copy), LocalPlayer (copy), v1 (ref), v2 (ref), hideHeld (copy)
    local Character = LocalPlayer.Character
    local v5, v6

    if Character then
        v5 = Character:FindFirstChild("HumanoidRootPart")
        v6 = Character:FindFirstChildOfClass("Humanoid")
    else
        v6 = Character
        v5 = Character
    end

    if not v1 then
        if v5 and v6 and not (v6.Health <= 0) then
            v1 = true
            v2 = false

            local CurrentCamera = workspace.CurrentCamera

            if not (p3 and p3.First) then
                TripUi.open()
                Controls.lock("World2Trip")
                TripUi.fade(true, 0.35)
                task.wait(0.4)
                Remotes.World2Trip:FireServer("Arrive")
                task.wait(0.5)
                Controls.unlock("World2Trip")
                TripUi.fade(false, 0.6)
                TripUi.close()
                v1 = false
            else
                local Folder = Instance.new("Folder")

                Folder.Name = "World2TripSet"
                Folder.Parent = workspace

                local v7 = TripSet.sub(Folder)

                if v7 then
                    local v8 = v6.RigType == Enum.HumanoidRigType.R15
                    local t2 = {
                        character = Character,
                        root = v5,
                        humanoid = v6,
                        camera = CurrentCamera,
                        folder = Folder,
                        sub = v7,
                        subCF = v7.home * CFrame.Angles(0, 3.141592653589793, 0),
                        sitAbove = if v8 then v6.HipHeight * 0.55 + 0.2 else 1.5,
                        first = p3 and p3.First,
                        skipped = function() -- skipped | line: 112
                            -- upvalues: v2 (ref)
                            return v2
                        end
                    }
                    local Submarine = workspace.EventHole.Cave:FindFirstChild("Submarine")

                    local function showOriginal(p4) -- line: 118
                        -- upvalues: Submarine (copy)
                        if not Submarine then
                            return
                        end

                        for _, descendant in Submarine:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                descendant.LocalTransparencyModifier = p4 and 0 or 1
                            end
                        end
                    end

                    TripUi.open()
                    TripUi.letterbox(true)
                    TripUi.fade(true, 0.35)

                    if Submarine then
                        for _, descendant in Submarine:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                descendant.LocalTransparencyModifier = 1
                            end
                        end
                    end

                    Controls.lock("World2Trip")
                    hideHeld(Character, true)
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    TripCave.play(t2)

                    if not v2 then
                        TripDeep.play(t2)
                    end

                    if t2.ungrade then
                        t2.ungrade()
                    end

                    if t2.dof then
                        t2.dof:Destroy()
                    end

                    if not v2 then
                        TripTour.play(t2, function() -- line: 148
                            -- upvalues: v2 (ref)
                            return v2
                        end)
                    end

                    if t2.call then
                        local call = t2.call

                        t2.call = nil
                        call:Destroy()
                    end

                    if t2.unworry then
                        t2.unworry()
                    end

                    if t2.unfog then
                        t2.unfog()
                    end

                    TripUi.fade(true, 0.4)
                    Poses.clear()
                    Folder:Destroy()

                    if Submarine then
                        for _, descendant in Submarine:GetDescendants() do
                            if descendant:IsA("BasePart") then
                                descendant.LocalTransparencyModifier = 0
                            end
                        end
                    end

                    TripTour.arrive(t2)
                    Remotes.World2Trip:FireServer("Arrive")
                    hideHeld(Character, false)
                    CurrentCamera.FieldOfView = 70
                    CurrentCamera.CameraType = Enum.CameraType.Custom
                    CurrentCamera.CameraSubject = v6
                    Controls.unlock("World2Trip")
                    TripUi.close()
                    TripUi.fade(false, 0.6)
                    v1 = false
                else
                    Folder:Destroy()
                    v1 = false
                    Remotes.World2Trip:FireServer("Cancel")
                end
            end
        else
            Remotes.World2Trip:FireServer("Cancel")
        end
    end
end

function t1.goBack() -- line: 182
    -- upvalues: Remotes (copy), Controls (copy), TripUi (copy), v1 (ref)
    if not v1 then
        v1 = true
        TripUi.open()
        Controls.lock("World2Trip")
        TripUi.fade(true, 0.35)
        task.wait(0.4)
        Remotes.World2Trip:FireServer("Return")
        task.wait(0.5)
        Controls.unlock("World2Trip")
        TripUi.fade(false, 0.6)
        TripUi.close()
        v1 = false
    end
end

return t1
