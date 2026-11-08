-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local GearToolLookup = require(ReplicatedStorage.Shared.Util.GearToolLookup)
local Gears = require(ReplicatedStorage.Data.Gears)
local ScrambleVaultPresentation = require(ReplicatedStorage.Shared.Util.ScrambleVaultPresentation)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local t4 = nil

local function eased(p1) -- line: 21
    -- upvalues: TweenService (copy)
    return TweenService:GetValue(math.clamp(p1, 0, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
end

local function closedDoor(p2) -- line: 24
    -- upvalues: self (copy)
    if not self[p2] then
        self[p2] = p2:GetPivot()
    end

    return self[p2]
end

function t1.IsPlaying() -- line: 28
    -- upvalues: t4 (ref)
    return t4 ~= nil
end

function t1.SetOpen(p3, p4) -- line: 31
    -- upvalues: ScrambleVaultPresentation (copy), self (copy), t4 (ref)
    if not t4 or t4.Vault ~= p3 then
        local v2 = ScrambleVaultPresentation.Assets(p3)

        if v2 then
            local DoorPose = ScrambleVaultPresentation.DoorPose

            if not self[v2] then
                self[v2] = v2:GetPivot()
            end

            v2:PivotTo(DoorPose(self[v2], p4 and 1 or 0, p3:GetAttribute("DoorOpenAngleDegrees")))
        end
    end
end

local function safely(p5) -- line: 36
    local ok, result = pcall(p5)

    if not ok then
        warn("[Scramble] Vault cleanup:", result)
    end
end

local function restoreCamera(p6) -- line: 40
    -- upvalues: LocalPlayer (copy)
    if p6.OwnsCamera then
        p6.OwnsCamera = false

        local Camera = p6.Camera

        if Camera:GetAttribute("ScrambleVaultCameraOwner") == p6.Id then
            Camera:SetAttribute("ScrambleVaultCameraOwner", nil)

            if Camera.CameraType == Enum.CameraType.Scriptable then
                Camera.CameraType = p6.CameraType

                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                if Character ~= p6.Character or not Camera.CameraSubject or not Camera.CameraSubject.Parent then
                    Camera.CameraSubject = Humanoid
                end

                if workspace.CurrentCamera == Camera and Character == p6.Character then
                    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                    local v3 = if HumanoidRootPart then HumanoidRootPart.Position - p6.Origin else Vector3.new(0, 0, 0)

                    Camera.CFrame = p6.CameraFrame + v3
                    Camera.Focus = p6.Focus + v3
                end
            end
        end
    end
end

local function releasePresentation(p7) -- line: 60
    -- upvalues: ContextActionService (copy), restoreCamera (copy)
    local function v4() -- line: 61
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("ScrambleVaultMovement")
    end

    local ok, result = pcall(v4)

    if not ok then
        warn("[Scramble] Vault cleanup:", result)
    end

    local function v5() -- line: 62
        -- upvalues: ContextActionService (copy)
        ContextActionService:UnbindAction("ScrambleVaultSkip")
    end

    local ok2, result2 = pcall(v5)

    if not ok2 then
        warn("[Scramble] Vault cleanup:", result2)
    end

    local function v6() -- line: 63
        -- upvalues: p7 (copy), restoreCamera (copy)
        restoreCamera(p7)
    end

    local ok3, result3 = pcall(v6)

    if not ok3 then
        warn("[Scramble] Vault cleanup:", result3)
    end

    local ReleaseUI = p7.ReleaseUI

    p7.ReleaseUI = nil

    if ReleaseUI then
        local ok, result = pcall(ReleaseUI)

        if not ok then
            warn("[Scramble] Vault cleanup:", result)
        end
    end
end

function t1.Stop(p8) -- line: 68
    -- upvalues: RunService (copy), ScrambleVaultPresentation (copy), t4 (ref), releasePresentation (copy)
    local t6 = t4

    if not t6 then
        return
    end

    t4 = nil

    local function v7() -- line: 72
        -- upvalues: RunService (copy)
        RunService:UnbindFromRenderStep("ScrambleVaultReward")
    end

    local ok, result = pcall(v7)

    if not ok then
        warn("[Scramble] Vault cleanup:", result)
    end

    releasePresentation(t6)

    if t6.Weapon then
        local function v8() -- line: 74
            -- upvalues: t6 (copy)
            t6.Weapon:Destroy()
        end

        local ok, result = pcall(v8)

        if not ok then
            warn("[Scramble] Vault cleanup:", result)
        end
    end

    local function v9() -- line: 75
        -- upvalues: p8 (copy), t6 (copy), ScrambleVaultPresentation (copy)
        if t6.Door.Parent then
            t6.Door:PivotTo(ScrambleVaultPresentation.DoorPose(t6.Closed, p8 and 1 or 0, t6.Angle))
        end
    end

    local ok2, result2 = pcall(v9)

    if not ok2 then
        warn("[Scramble] Vault cleanup:", result2)
    end
end

function t1.Finish(p9, p10) -- line: 81
    -- upvalues: t1 (copy), t4 (ref)
    if t4 and t4.Id == p9 then
        t1.Stop(p10)
    end
end

local function weaponModel(p11) -- line: 84
    -- upvalues: GearToolLookup (copy), Gears (copy)
    local v10 = Gears.Directory[p11]
    local v11 = v10 and GearToolLookup(v10.ToolModel or p11)

    if not v11 then
        return nil
    end

    local Model = Instance.new("Model")

    Model.Name = "ScramblerRewardVisual"

    local Handle = v11:FindFirstChild("Handle")

    if not (Handle and Handle:IsA("BasePart")) then
        Model:Destroy()

        return nil
    end

    for _, descendant in v11:GetDescendants() do
        if descendant:IsA("BasePart") then
            local clone = descendant:Clone()

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("LuaSourceContainer")
                    or descendant:IsA("JointInstance")
                    or descendant:IsA("Constraint")
                    or descendant:IsA("BasePart")
                    or descendant:IsA("ProximityPrompt")
                    or descendant:IsA("ClickDetector")
                    or descendant:IsA("TouchTransmitter")
                    or descendant:IsA("Tool") then
                    descendant:Destroy()
                end
            end

            clone.Anchored = true
            clone.CanCollide = false
            clone.CanTouch = false
            clone.CanQuery = false
            clone.LocalTransparencyModifier = 0
            clone.Parent = Model
        end
    end

    Model.WorldPivot = Handle.CFrame

    return Model
end

function t1.Start(p12, p13) -- line: 108
    -- upvalues: RunService (copy), TweenService (copy), ContextActionService (copy), GuiService (copy), HiddenUIHandler (copy), ScrambleVaultPresentation (copy), LocalPlayer (copy), t1 (copy), self (copy), t4 (ref), eased (copy), releasePresentation (copy), weaponModel (copy)
    local v12, v13, Character, Humanoid, v14

    if t4 then
        v14 = true
    elseif type(p13) == "table" then
        if type(p13.Id) == "string" then
            if type(p13.Gear) == "string" then
                if type(p13.StartedAt) == "number" then
                    local v15

                    v12, v15, v13 = ScrambleVaultPresentation.Assets(p12)
                    Character = LocalPlayer.Character
                    Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                    v14 = false
                else
                    v14 = true
                end
            else
                v14 = true
            end
        else
            v14 = true
        end
    else
        v14 = true
    end

    if v14 then
        return
    end

    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local CurrentCamera = workspace.CurrentCamera

    if v12 and v13 and HumanoidRootPart and Humanoid and not (Humanoid.Health <= 0) and CurrentCamera then
        local v16 = weaponModel(p13.Gear)

        if v16 then
            if not self[v12] then
                self[v12] = v12:GetPivot()
            end

            local v17 = self[v12]
            local Position = v12:GetBoundingBox().Position
            local v20 = Vector3.new(Position.X - v13.Position.X, 0, Position.Z - v13.Position.Z)
            local v21, v22

            if v20.Magnitude > 0.1 then
                local Unit = v20.Unit

                v22 = Unit
                v21 = Unit
            else
                v21 = Vector3.new(0, 0, -1)
                v22 = Vector3.new(0, 0, -1)
            end

            local v23 = Position + Vector3.new(0, 0.5, 0)
            local v24 = v23 + v22 * 10 + (Vector3.new(0, 1, 0)):Cross(v22) * 2.5 + Vector3.new(0, 2, 0)
            local v25 = RaycastParams.new()

            v25.FilterType = Enum.RaycastFilterType.Exclude
            v25.FilterDescendantsInstances = { Character, v12 }
            v25.RespectCanCollide = true

            local v26 = workspace:Raycast(v23, v24 - v23, v25)

            if v26 then
                v24 = v26.Position + v26.Normal * 0.5
            end

            local v27 = CurrentCamera.CameraType == Enum.CameraType.Custom and not HiddenUIHandler.IsHidden() and not GuiService.ReducedMotionEnabled
            local t7 = {
                Id = p13.Id,
                Vault = p12,
                Door = v12,
                Closed = v17,
                Angle = p12:GetAttribute("DoorOpenAngleDegrees"),
                Weapon = v16,
                Spawn = v13.CFrame,
                Outward = v22,
                StartedAt = p13.StartedAt,
                Character = Character,
                Humanoid = Humanoid,
                Origin = HumanoidRootPart.Position,
                Camera = CurrentCamera,
                CameraFrame = CurrentCamera.CFrame,
                CameraType = CurrentCamera.CameraType,
                FOV = CurrentCamera.FieldOfView,
                Focus = CurrentCamera.Focus,
                Subject = CurrentCamera.CameraSubject,
                OwnsCamera = v27,
                Shot = CFrame.lookAt(v24, v23)
            }

            t4 = t7
            task.delay(ScrambleVaultPresentation.Duration + 0.75, function() -- line: 141
                -- upvalues: t7 (copy), t4 (ref), releasePresentation (copy)
                if t4 == t7 then
                    releasePresentation(t7)
                end
            end)
            task.delay(ScrambleVaultPresentation.Duration + 8, function() -- line: 144
                -- upvalues: t7 (copy), t1 (copy), t4 (ref)
                if t4 == t7 then
                    t1.Stop(false)
                end
            end)

            local v28 = v12
            local Character2 = Character
            local Humanoid2 = Humanoid

            local function v29() -- line: 147
                -- upvalues: p12 (copy), CurrentCamera (copy), v16 (copy), v17 (copy), v21 (ref), v23 (copy), t7 (copy), v27 (copy), v28 (copy), Character2 (copy), Humanoid2 (copy), RunService (copy), TweenService (copy), ContextActionService (copy), HiddenUIHandler (copy), ScrambleVaultPresentation (copy), LocalPlayer (copy), t1 (copy), t4 (ref), eased (copy), releasePresentation (copy)
                v28:PivotTo(v17)
                v16:ScaleTo(ScrambleVaultPresentation.DisplayScale)
                v16:PivotTo(t7.Spawn)
                v16.Parent = workspace

                if v27 then
                    CurrentCamera:SetAttribute("ScrambleVaultCameraOwner", t7.Id)
                    t7.ReleaseUI = HiddenUIHandler.Acquire()
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    ContextActionService:BindActionAtPriority("ScrambleVaultMovement", function() -- line: 156
                        return Enum.ContextActionResult.Sink
                    end, false, Enum.ContextActionPriority.High.Value + 100, table.unpack(Enum.PlayerActions:GetEnumItems()))
                    ContextActionService:BindActionAtPriority("ScrambleVaultSkip", function(_, p15) -- line: 158
                        -- upvalues: t7 (copy), t4 (ref), releasePresentation (copy)
                        if p15 == Enum.UserInputState.Begin and t4 == t7 then
                            releasePresentation(t7)
                        end

                        return Enum.ContextActionResult.Pass
                    end, false, Enum.ContextActionPriority.High.Value + 101, Enum.KeyCode.Escape, Enum.KeyCode.ButtonB)
                end

                RunService:BindToRenderStep("ScrambleVaultReward", Enum.RenderPriority.Camera.Value + 2, function() -- line: 163
                    -- upvalues: p12 (copy), CurrentCamera (copy), v16 (copy), v17 (copy), v21 (ref), v23 (copy), t7 (copy), v28 (copy), Character2 (copy), Humanoid2 (copy), TweenService (copy), ScrambleVaultPresentation (copy), LocalPlayer (copy), t1 (copy), t4 (ref), eased (copy), releasePresentation (copy)
                    local function v32() -- line: 164
                        -- upvalues: p12 (copy), CurrentCamera (copy), v16 (copy), v17 (copy), v21 (ref), v23 (copy), t7 (copy), v28 (copy), Character2 (copy), Humanoid2 (copy), TweenService (copy), ScrambleVaultPresentation (copy), LocalPlayer (copy), t1 (copy), t4 (ref), eased (copy), releasePresentation (copy)
                        if t4 ~= t7 then
                            return
                        end

                        local HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
                        local v33, v34

                        if LocalPlayer.Character ~= Character2 or Humanoid2.Health <= 0 then
                            v34 = true
                        elseif not HumanoidRootPart or not p12:IsDescendantOf(workspace) or not v28.Parent or (HumanoidRootPart.Position - t7.Origin).Magnitude > 35 then
                            v34 = true
                        else
                            v33 = math.max(0, workspace:GetServerTimeNow() - t7.StartedAt)
                            v28:PivotTo(ScrambleVaultPresentation.DoorPose(v17, TweenService:GetValue(math.clamp((v33 - ScrambleVaultPresentation.DoorStart) / ScrambleVaultPresentation.DoorSeconds, 0, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), t7.Angle))

                            if v33 < ScrambleVaultPresentation.Duration then
                                v16.Parent = workspace

                                local v38 = math.clamp((v33 - ScrambleVaultPresentation.FlyAt) / (ScrambleVaultPresentation.Duration - ScrambleVaultPresentation.FlyAt), 0, 1)
                                local SpawnPosition = t7.Spawn.Position
                                local v39 = HumanoidRootPart.Position + Vector3.new(0, 1, 0)
                                local v40 = SpawnPosition + v21 * 5 + Vector3.new(0, 3, 0)
                                local Value = TweenService:GetValue(math.clamp(v38, 0, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)

                                v16:ScaleTo(ScrambleVaultPresentation.DisplayScale + (1 - ScrambleVaultPresentation.DisplayScale) * Value)

                                local v41 = (1 - Value) ^ 2 * SpawnPosition + (1 - Value) * 2 * Value * v40 + Value ^ 2 * v39

                                v16:PivotTo(CFrame.new(v41) * t7.Spawn.Rotation * CFrame.Angles(0, v38 * 3.141592653589793 * 2, 0))
                            elseif ScrambleVaultPresentation.Duration <= v33 then
                                v16.Parent = nil
                            end

                            v34 = false
                        end

                        if v34 then
                            t1.Stop(false)

                            return
                        end

                        if t7.OwnsCamera then
                            if workspace.CurrentCamera == CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable and CurrentCamera.CameraSubject == t7.Subject and CurrentCamera:GetAttribute("ScrambleVaultCameraOwner") == t7.Id then
                                Humanoid2:Move((Vector3.new(0, 0, 0)))

                                local Value = TweenService:GetValue(math.clamp((v33 - ScrambleVaultPresentation.FlyAt) / (ScrambleVaultPresentation.Duration - ScrambleVaultPresentation.FlyAt), 0, 1), Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
                                local v43 = t7.CameraFrame + (HumanoidRootPart.Position - t7.Origin)

                                CurrentCamera.CFrame = t7.CameraFrame:Lerp(t7.Shot, eased(v33 / ScrambleVaultPresentation.CameraIn)):Lerp(v43, Value)
                                CurrentCamera.Focus = CFrame.new(v23):Lerp(t7.Focus + (HumanoidRootPart.Position - t7.Origin), Value)

                                if ScrambleVaultPresentation.Duration <= v33 then
                                    releasePresentation(t7)
                                end
                            else
                                releasePresentation(t7)
                            end
                        end

                        if ScrambleVaultPresentation.Duration + 8 < v33 then
                            t1.Stop(false)
                        end
                    end

                    local traceback = debug.traceback
                    local v45, v46 = xpcall(v32, traceback)

                    if not v45 then
                        t1.Stop(false)
                        warn("[Scramble] Vault animation failed:", v46)
                    end
                end)
            end

            local traceback = debug.traceback
            local v47, v48 = xpcall(v29, traceback)

            if not v47 then
                t1.Stop(false)
                warn("[Scramble] Vault animation could not start:", v48)
            end
        end
    end
end

return t1
