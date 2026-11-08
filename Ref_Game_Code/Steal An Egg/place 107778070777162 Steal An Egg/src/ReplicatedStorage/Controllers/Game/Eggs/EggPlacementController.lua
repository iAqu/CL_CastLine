-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ButtonHintStrip = require(ReplicatedStorage.Client.ButtonHintStrip)
local EggPlacementRaycast = require(ReplicatedStorage.Shared.Eggs.EggPlacementRaycast)
local EggState = require(ReplicatedStorage.Client.EggState)
local EggToolDisplay = require(ReplicatedStorage.Shared.Eggs.EggToolDisplay)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PlacedEggRenderer = require(ReplicatedStorage.Shared.Eggs.PlacedEggRenderer)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local PlotState = require(ReplicatedStorage.Client.PlotState)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local ButtonR2 = Enum.KeyCode.ButtonR2
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()

return {
    Start = function() -- Start | line: 34
        -- upvalues: RunService (copy), Workspace (copy), ButtonHintStrip (copy), EggPlacementRaycast (copy), EggState (copy), EggToolDisplay (copy), Toast (copy), PlacedEggRenderer (copy), PlatformController (copy), PlotState (copy), Remotes (copy), ButtonR2 (copy), LocalPlayer (copy), v1 (copy)
        local function showInvalidPlacement() -- line: 39
            -- upvalues: Toast (copy)
            Toast.Show({
                Text = "Cannot place egg here!",
                Seconds = 2,
                Color = Color3.fromRGB(255, 80, 80)
            })
        end

        local function tryPlace(p1) -- line: 47
            -- upvalues: EggPlacementRaycast (copy), EggState (copy), EggToolDisplay (copy), Toast (copy), PlacedEggRenderer (copy), PlotState (copy), LocalPlayer (copy)
            local v2 = EggToolDisplay.GetToolUid(p1)

            if v2 ~= nil then
                local v3 = PlotState.ResolvePlot()

                if v3 ~= nil then
                    local PetArea = v3.PetArea
                    local v4 = EggPlacementRaycast.Raycast(PetArea, LocalPlayer.UserId)

                    if v4 == nil or v4.Instance ~= PetArea then
                        Toast.Show({
                            Text = "Cannot place egg here!",
                            Seconds = 2,
                            Color = Color3.fromRGB(255, 80, 80)
                        })
                    else
                        local v5 = v3.CenterPoint.CFrame:ToObjectSpace(CFrame.new(v4.Position))
                        local v6, v7 = EggState.PlantEgg(v2, v5)

                        if v6 then
                            PlacedEggRenderer.Refresh()
                        else
                            Toast.Show({
                                Seconds = 2,
                                Text = v7 or "Cannot place egg here!",
                                Color = Color3.fromRGB(255, 80, 80)
                            })
                        end
                    end
                else
                    Toast.Show({
                        Text = "Cannot place egg here!",
                        Seconds = 2,
                        Color = Color3.fromRGB(255, 80, 80)
                    })
                end
            else
                Toast.Show({
                    Text = "Cannot place egg here!",
                    Seconds = 2,
                    Color = Color3.fromRGB(255, 80, 80)
                })
            end
        end

        local function canPlaceFromHere() -- line: 81
            -- upvalues: PlatformController (copy), PlotState (copy), LocalPlayer (copy)
            if not PlatformController.IsConsole() then
                return false
            end

            local Character = LocalPlayer.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
                return PlotState.ContainsLocalPoint(HumanoidRootPart.Position)
            end

            return false
        end

        local function refreshPlacePrompt() -- line: 95
            -- upvalues: ButtonHintStrip (copy), PlatformController (copy), PlotState (copy), ButtonR2 (copy), LocalPlayer (copy)
            local v8 = false

            if PlatformController.IsConsole() then
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                v8 = not not (HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart")) and PlotState.ContainsLocalPoint(HumanoidRootPart.Position)
            end

            if v8 then
                ButtonHintStrip.Present("EggPlacement", ButtonR2, "Place Egg")
            else
                ButtonHintStrip.Retract("EggPlacement")
            end
        end

        local function bindTool(p2) -- line: 103
            -- upvalues: tryPlace (copy), RunService (copy), ButtonHintStrip (copy), PlatformController (copy), PlotState (copy), ButtonR2 (copy), LocalPlayer (copy), v1 (copy)
            v1:Clean()
            v1:Connect(p2.Activated, function() -- line: 105
                -- upvalues: p2 (copy), tryPlace (copy)
                tryPlace(p2)
            end)

            local n1 = 0

            v1:Connect(RunService.Heartbeat, function(p3) -- line: 108
                -- upvalues: n1 (ref), ButtonHintStrip (copy), PlatformController (copy), PlotState (copy), ButtonR2 (copy), LocalPlayer (copy)
                n1 += p3

                if n1 < 0.2 then
                    return
                end

                n1 = 0

                local v9 = false

                if PlatformController.IsConsole() then
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                    v9 = not not (HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart")) and PlotState.ContainsLocalPoint(HumanoidRootPart.Position)
                end

                if v9 then
                    ButtonHintStrip.Present("EggPlacement", ButtonR2, "Place Egg")
                else
                    ButtonHintStrip.Retract("EggPlacement")
                end
            end)
            v1:Add(function() -- line: 116
                -- upvalues: ButtonHintStrip (copy)
                ButtonHintStrip.Retract("EggPlacement")
            end)

            local v10 = false

            if PlatformController.IsConsole() then
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                v10 = not not (HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart")) and PlotState.ContainsLocalPoint(HumanoidRootPart.Position)
            end

            if v10 then
                ButtonHintStrip.Present("EggPlacement", ButtonR2, "Place Egg")
            else
                ButtonHintStrip.Retract("EggPlacement")
            end
        end

        local function refreshCharacter(p4) -- line: 121
            -- upvalues: bindTool (copy), EggToolDisplay (copy), v1 (copy)
            v1:Clean()

            for _, child in ipairs(p4:GetChildren()) do
                if child.ClassName == "Tool" and EggToolDisplay.IsEggTool(child) then
                    bindTool(child)

                    return
                end
            end
        end

        local function bindCharacter(p5) -- line: 131
            -- upvalues: bindTool (copy), refreshCharacter (copy), EggToolDisplay (copy), v1 (copy)
            refreshCharacter(p5)
            p5.ChildAdded:Connect(function(p6) -- line: 133
                -- upvalues: bindTool (copy), EggToolDisplay (copy)
                if p6.ClassName == "Tool" and EggToolDisplay.IsEggTool(p6) then
                    bindTool(p6)
                end
            end)
            p5.ChildRemoved:Connect(function(p7) -- line: 138
                -- upvalues: EggToolDisplay (copy), v1 (copy)
                if p7.ClassName == "Tool" and EggToolDisplay.IsEggTool(p7) then
                    v1:Clean()
                end
            end)
        end

        LocalPlayer.CharacterAdded:Connect(bindCharacter)
        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p8) -- line: 151
            -- upvalues: PlacedEggRenderer (copy)
            PlacedEggRenderer.SetPromptsSuppressed(p8 ~= nil)
        end)

        if LocalPlayer.Character ~= nil then
            bindCharacter(LocalPlayer.Character)
        end

        Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 157
            -- upvalues: refreshCharacter (copy), LocalPlayer (copy)
            local Character = LocalPlayer.Character

            if Character ~= nil then
                refreshCharacter(Character)
            end
        end)
    end
}
