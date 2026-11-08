-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=5888513160

-- ! Source from the asset above; the game may have edited it since.

--[[
local MobileCameraFramework = {}
local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local CAS = game:GetService("ContextActionService")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character.Humanoid
local camera = workspace.CurrentCamera
local button = script.Parent

--Visiblity
uis = game:GetService("UserInputService")
ismobile = uis.TouchEnabled
button.Visible = ismobile

local states = {
	OFF = "rbxasset://textures/ui/mouseLock_off@2x.png",
	ON = "rbxasset://textures/ui/mouseLock_on@2x.png"
}
local MAX_LENGTH = 900000
local active = false
local ENABLED_OFFSET = CFrame.new(1.7, 0, 0)
local DISABLED_OFFSET = CFrame.new(-1.7, 0, 0)
local function UpdateImage(STATE)
	button.Image = states[STATE]
end
local function UpdateAutoRotate(BOOL)
	humanoid.AutoRotate = BOOL
end
local function GetUpdatedCameraCFrame(ROOT, CAMERA)
	return CFrame.new(root.Position, Vector3.new(CAMERA.CFrame.LookVector.X * MAX_LENGTH, root.Position.Y, CAMERA.CFrame.LookVector.Z * MAX_LENGTH))
end
local function EnableShiftlock()
	UpdateAutoRotate(false)
	UpdateImage("ON")
	root.CFrame = GetUpdatedCameraCFrame(root, camera)
	camera.CFrame = camera.CFrame * ENABLED_OFFSET
end
local function DisableShiftlock()
	UpdateAutoRotate(true)
	UpdateImage("OFF")
	camera.CFrame = camera.CFrame * DISABLED_OFFSET
	pcall(function()
		active:Disconnect()
		active = nil
	end)
end
UpdateImage("OFF")
active = false
function ShiftLock()
	if not active then
		active = runservice.RenderStepped:Connect(function()
			EnableShiftlock()
		end)
	else
		DisableShiftlock()
	end
end
local ShiftLockButton = CAS:BindAction("ShiftLOCK", ShiftLock, false, "On")
CAS:SetPosition("ShiftLOCK", UDim2.new(0.8, 0, 0.8, 0))
button.MouseButton1Click:Connect(function()
	if not active then
		active = runservice.RenderStepped:Connect(function()
			EnableShiftlock()
		end)
	else
		DisableShiftlock()
	end
end)
return MobileCameraFramework

]]

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

require(ReplicatedStorage.Shared.Globals.Constants)

local Log = require(ReplicatedStorage.Packages.Log)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local v1 = CFrame.new(-1.7, 0, 0)
local v2 = CFrame.new(1.7, 0, 0)
local v3 = Enum.RenderPriority.Camera.Value + 1
local t1 = {
    Off = "rbxasset://textures/ui/mouseLock_off@2x.png",
    On = "rbxasset://textures/ui/mouseLock_on@2x.png"
}
local LocalPlayer = Players.LocalPlayer
local Parent = script.Parent

assert(Parent:IsA("ImageButton"), "StarterGui.ShiftLockButton.ImageButton must be an ImageButton")

local ParentParent = Parent.Parent

assert(ParentParent:IsA("ScreenGui"), "StarterGui.ShiftLockButton must be a ScreenGui")

local Lock = ParentParent.Lock

assert(Lock:IsA("ImageLabel"), "StarterGui.ShiftLockButton.Lock must be an ImageLabel")

local v4 = false
local v5 = false
local v6 = Log.new()

local function updateImage(p1) -- line: 44
    -- upvalues: Parent (copy), Lock (copy)
    Parent.Image = p1 and "rbxasset://textures/ui/mouseLock_on@2x.png" or "rbxasset://textures/ui/mouseLock_off@2x.png"
    Lock.Visible = p1
end

local function getCurrentCamera() -- line: 49
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")

    return CurrentCamera
end

local function updateShiftLock() -- line: 55
    -- upvalues: Workspace (copy), Player (copy), v2 (copy), t1 (copy), LocalPlayer (copy), Parent (copy), Lock (copy), v5 (ref)
    if v5 then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera

    assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")

    if CurrentCamera.CameraType == Enum.CameraType.Scriptable then
        return
    end

    local v9 = Player.WaitForRootPart(LocalPlayer)

    Player.WaitForHumanoid(LocalPlayer).AutoRotate = false
    Parent.Image = t1.On
    Lock.Visible = true

    local LookVector = CurrentCamera.CFrame.LookVector

    v9.CFrame = CFrame.new(v9.Position, (Vector3.new(LookVector.X * 9E+05, v9.Position.Y, LookVector.Z * 9E+05)))
    CurrentCamera.CFrame *= v2
end

local function disableShiftLock() -- line: 78
    -- upvalues: RunService (copy), Workspace (copy), Player (copy), v1 (copy), t1 (copy), LocalPlayer (copy), Parent (copy), Lock (copy), v4 (ref)
    if not v4 then
        return
    end

    v4 = false
    RunService:UnbindFromRenderStep("MobileShiftLock")

    local v12 = Player.FindHumanoid(LocalPlayer)

    if v12 ~= nil then
        v12.AutoRotate = true
    end

    Parent.Image = t1.Off
    Lock.Visible = false

    local CurrentCamera = Workspace.CurrentCamera

    assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")
    CurrentCamera.CFrame *= v1
end

local function enableShiftLock() -- line: 93
    -- upvalues: RunService (copy), v3 (copy), v4 (ref), v5 (ref), updateShiftLock (copy)
    if not (v4 or v5) then
        v4 = true
        RunService:BindToRenderStep("MobileShiftLock", v3, updateShiftLock)
    end
end

local function updateAvailability() -- line: 102
    -- upvalues: RunService (copy), UserInputService (copy), Workspace (copy), MountRace (copy), Player (copy), v1 (copy), t1 (copy), LocalPlayer (copy), Parent (copy), Lock (copy), v4 (ref), v5 (ref), v6 (copy)
    local v14 = LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil
    local v15 = v5 or v14

    if v15 then
        if v4 then
            v4 = false
            RunService:UnbindFromRenderStep("MobileShiftLock")

            local v16 = Player.FindHumanoid(LocalPlayer)

            if v16 ~= nil then
                v16.AutoRotate = true
            end

            Parent.Image = t1.Off
            Lock.Visible = false

            local CurrentCamera = Workspace.CurrentCamera

            assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")
            CurrentCamera.CFrame *= v1
        end

        v6:AtDebug():Log("Mobile shift lock suppressed by a gameplay lock")
    end

    Parent.Visible = UserInputService.TouchEnabled and not v15
end

local function toggleShiftLock() -- line: 112
    -- upvalues: RunService (copy), Workspace (copy), Player (copy), v1 (copy), v3 (copy), t1 (copy), LocalPlayer (copy), Parent (copy), Lock (copy), v4 (ref), v5 (ref), updateShiftLock (copy)
    if v4 then
        v4 = false
        RunService:UnbindFromRenderStep("MobileShiftLock")

        local v18 = Player.FindHumanoid(LocalPlayer)

        if v18 ~= nil then
            v18.AutoRotate = true
        end

        Parent.Image = t1.Off
        Lock.Visible = false

        local CurrentCamera = Workspace.CurrentCamera

        assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")
        CurrentCamera.CFrame *= v1
    elseif not v4 then
        if v5 then
            return
        end

        v4 = true
        RunService:BindToRenderStep("MobileShiftLock", v3, updateShiftLock)
    end
end

Parent.Image = t1.Off
Lock.Visible = false

local v20 = LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil
local v21 = v5 or v20

if v21 then
    if v4 then
        v4 = false
        RunService:UnbindFromRenderStep("MobileShiftLock")

        local v22 = Player.FindHumanoid(LocalPlayer)

        if v22 ~= nil then
            v22.AutoRotate = true
        end

        Parent.Image = t1.Off
        Lock.Visible = false

        local CurrentCamera = Workspace.CurrentCamera

        assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")
        CurrentCamera.CFrame *= v1
    end

    v6:AtDebug():Log("Mobile shift lock suppressed by a gameplay lock")
end

Parent.Visible = UserInputService.TouchEnabled and not v21
Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p2) -- line: 126
    -- upvalues: RunService (copy), UserInputService (copy), Workspace (copy), MountRace (copy), Player (copy), v1 (copy), t1 (copy), LocalPlayer (copy), Parent (copy), Lock (copy), v4 (ref), v5 (ref), v6 (copy)
    v5 = p2 ~= nil

    local v24 = LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil
    local v25 = v5 or v24

    if v25 then
        if v4 then
            v4 = false
            RunService:UnbindFromRenderStep("MobileShiftLock")

            local v26 = Player.FindHumanoid(LocalPlayer)

            if v26 ~= nil then
                v26.AutoRotate = true
            end

            Parent.Image = t1.Off
            Lock.Visible = false

            local CurrentCamera = Workspace.CurrentCamera

            assert(CurrentCamera ~= nil, "Mobile shift lock requires Workspace.CurrentCamera")
            CurrentCamera.CFrame *= v1
        end

        v6:AtDebug():Log("Mobile shift lock suppressed by a gameplay lock")
    end

    Parent.Visible = UserInputService.TouchEnabled and not v25
end)
LocalPlayer:GetAttributeChangedSignal(MountRace.PlayerAttributes.RaceId):Connect(updateAvailability)
Parent.Activated:Connect(toggleShiftLock)
