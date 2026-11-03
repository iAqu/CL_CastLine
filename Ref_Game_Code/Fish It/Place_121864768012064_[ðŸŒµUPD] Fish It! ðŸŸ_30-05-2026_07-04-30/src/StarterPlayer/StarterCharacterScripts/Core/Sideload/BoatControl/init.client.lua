-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"))
local TagEffect = require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("TagEffect"))
local Teardown = require(ReplicatedStorage:WaitForChild("AceworksUtils"):WaitForChild("Teardown"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Trove = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Trove"))
local BoatsHandlingData = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("BoatsHandlingData"))
local ControlModule = require(LocalPlayer:WaitForChild("PlayerScripts").PlayerModule:WaitForChild("ControlModule"))
local Assets = ReplicatedStorage:WaitForChild("Assets")
local v1 = Assets:WaitForChild("Core Boat Assets")
Assets:WaitForChild("Boats")
local MobileGui = v1:WaitForChild("MobileGui")
local v2 = nil
local v3 = nil
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
if Humanoid then
	local v4 = Trove.new()
	local v5 = Trove.new()
	local getThumbstick = require(script:WaitForChild("getThumbstick"))
	local getFront = require(script:WaitForChild("getFront"))
	local getBack = require(script:WaitForChild("getBack"))
	local resetAssembly = require(script:WaitForChild("resetAssembly"))
	local function DestroyAll() --[[ DestroyAll | Line: 55 | Upvalues: v5 (copy), v4 (copy) ]]
		v5:Destroy()
		v4:Destroy()
	end
	local function SeatPartChanged() --[[ SeatPartChanged | Line: 61 | Upvalues: Humanoid (copy), v3 (ref), v5 (copy), resetAssembly (copy), BoatsHandlingData (copy), UserInputService (copy), MobileGui (copy), PlayerGui (copy), v2 (ref), RunService (copy), ControlModule (copy), getThumbstick (copy), getFront (copy), getBack (copy) ]]
		local SeatPart = Humanoid.SeatPart
		if SeatPart then
			if not SeatPart:IsA("VehicleSeat") then
				return
			end
			local v1 = SeatPart.Parent
			if not v1 then
				return
			end
			local Base = v1:FindFirstChild("Base")
			if not Base then
				warn("Boat missing Base:", v1:GetFullName())
				return
			end
			local v22 = v1.Name
			if not v1:HasTag("Boat") then
				warn("Model is not tagged as a \"Boat\"!")
				return
			end
			local v32 = BoatsHandlingData[v22]
			if not v32 then
				warn("Boat missing boatData:", v1:GetFullName())
				return
			end
			local v4 = Base:FindFirstChildWhichIsA("AlignOrientation")
			if not v4 then
				warn("Boat missing AlignOrientation:", v1:GetFullName())
				return
			end
			local v52 = Base:FindFirstChildWhichIsA("LinearVelocity")
			if not v52 then
				warn("Boat missing LinearVelocity:", v1:GetFullName())
				return
			end
			if not Base:FindFirstChild("Attachment") then
				warn("Boat missing Attachment:", v1:GetFullName())
				return
			end
			v3 = SeatPart
			local v6 = game.ReplicatedStorage.Boats:FindFirstChild(v22)
			local v7 = if v6 then require(v6) or {} else {}
			local v8 = nil
			local v9 = nil
			local v10 = nil
			local v11 = "Idle"
			local v12 = false
			local Animator = Humanoid:FindFirstChildOfClass("Animator")
			if not Animator then
				local Animator_2 = Instance.new("Animator")
				Animator_2.Parent = Humanoid
				Animator = Animator_2
			end
			local Animations = v7.Animations
			if Animations and Animator then
				print("loading")
				if Animations.Idle then
					local Animation = Instance.new("Animation")
					Animation.AnimationId = Animations.Idle
					v8 = Animator:LoadAnimation(Animation)
					v8.Looped = true
					v8.Priority = Enum.AnimationPriority.Action2
					Animation:Destroy()
					v5:Add(function() --[[ Line: 170 | Upvalues: v8 (ref) ]]
						if not v8 then
							return
						end
						v8:Stop()
						v8:Destroy()
					end)
				end
				if Animations.Surfing then
					local Animation = Instance.new("Animation")
					Animation.AnimationId = Animations.Surfing
					v9 = Animator:LoadAnimation(Animation)
					v9.Looped = true
					v9.Priority = Enum.AnimationPriority.Action2
					Animation:Destroy()
					v5:Add(function() --[[ Line: 189 | Upvalues: v9 (ref) ]]
						if not v9 then
							return
						end
						v9:Stop()
						v9:Destroy()
					end)
				end
				if Animations.SlowSurfing then
					v12 = true
					local Animation = Instance.new("Animation")
					Animation.AnimationId = Animations.SlowSurfing
					v10 = Animator:LoadAnimation(Animation)
					v10.Looped = true
					v10.Priority = Enum.AnimationPriority.Action2
					Animation:Destroy()
					v5:Add(function() --[[ Line: 211 | Upvalues: v10 (ref) ]]
						if not v10 then
							return
						end
						v10:Stop()
						v10:Destroy()
					end)
				end
				if v8 then
					v8:Play(0.2)
				end
			end
			local function StopAllTracks(p1) --[[ StopAllTracks | Line: 227 | Upvalues: v8 (ref), v10 (ref), v9 (ref) ]]
				if v8 then
					v8:Stop(p1)
				end
				if v10 then
					v10:Stop(p1)
				end
				if not v9 then
					return
				end
				v9:Stop(p1)
			end
			local function SetAnimationState(p1) --[[ SetAnimationState | Line: 240 | Upvalues: v11 (ref), v8 (ref), v10 (ref), v9 (ref), v12 (ref) ]]
				if v11 == p1 then
					return
				end
				v11 = p1
				if v8 then
					v8:Stop(0.2)
				end
				if v10 then
					v10:Stop(0.2)
				end
				if v9 then
					v9:Stop(0.2)
				end
				if p1 == "Surfing" then
					if v9 then
						v9:Play(0.2)
					end
				elseif p1 == "SlowSurfing" then
					if v12 and v10 then
						v10:Play(0.2)
						return
					end
					if v9 then
						v9:Play(0.2)
					end
				else
					if not v8 then
						return
					end
					v8:Play(0.2)
				end
			end
			local v13 = nil
			if UserInputService.TouchEnabled then
				local v14 = MobileGui:Clone()
				v5:Add(v14.TouchControlFrame.AccelerateButton.InputBegan:Connect(function() --[[ Line: 279 | Upvalues: v13 (ref) ]]
					v13 = 1
				end))
				v5:Add(v14.TouchControlFrame.AccelerateButton.InputEnded:Connect(function() --[[ Line: 283 | Upvalues: v13 (ref) ]]
					if v13 ~= 1 then
						return
					end
					v13 = 0
				end))
				v5:Add(v14.TouchControlFrame.BrakeButton.InputBegan:Connect(function() --[[ Line: 289 | Upvalues: v13 (ref) ]]
					v13 = -1
				end))
				v5:Add(v14.TouchControlFrame.BrakeButton.InputEnded:Connect(function() --[[ Line: 293 | Upvalues: v13 (ref) ]]
					if v13 ~= -1 then
						return
					end
					v13 = 0
				end))
				v5:Add(function() --[[ Line: 299 | Upvalues: v14 (copy) ]]
					v14:Destroy()
				end)
				v14.Enabled = true
				v14.Parent = PlayerGui
				v2 = v14
			end
			local v15 = nil
			local v16 = nil
			if UserInputService.GamepadEnabled then
				v5:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 315 | Upvalues: UserInputService (ref), v15 (ref), v16 (ref) ]]
					if p2 then
						return
					end
					if p1.KeyCode ~= Enum.KeyCode.Thumbstick1 then
						return
					end
					for v1, v2 in UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1) do
						if v2.KeyCode == Enum.KeyCode.Thumbstick1 then
							v15 = v2.Position.X
							v16 = v2.Position.Y
						end
					end
				end))
			end
			local v17 = v32.Acceleration or 1
			local Speed = v32.Speed
			local RotationSpeed = v32.RotationSpeed
			local LaunchControl = v32.LaunchControl
			local v18 = Speed * 0.25 * 0.7
			v5:Add(RunService.Heartbeat:Connect(function(p1) --[[ Line: 349 | Upvalues: UserInputService (ref), ControlModule (ref), v15 (ref), v16 (ref), getThumbstick (ref), getFront (ref), getBack (ref), RotationSpeed (copy), v4 (copy), Speed (copy), v13 (ref), v52 (copy), v17 (copy), Animations (copy), v11 (ref), v8 (ref), v10 (ref), v9 (ref), v18 (copy), v12 (ref) ]]
				local v1 = false
				if UserInputService.TouchEnabled then
					local v2 = ControlModule:GetMoveVector()
					v15 = v2.X
					v16 = v2.Z
				end
				if UserInputService.GamepadEnabled then
					v1 = true
					local v3, v42 = getThumbstick()
					v15 = v3
					v16 = v42
				end
				local v5 = UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right)
				local v6 = UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left)
				local v7 = UserInputService:IsKeyDown(Enum.KeyCode.W) or (UserInputService:IsKeyDown(Enum.KeyCode.Up) or (if v1 then getFront() else v1))
				local v82 = UserInputService:IsKeyDown(Enum.KeyCode.S) or (UserInputService:IsKeyDown(Enum.KeyCode.Down) or (if v1 then getBack() else v1))
				local v92 = v15 and math.sign(v15) or nil
				local v132 = v4
				v132.CFrame = v132.CFrame * CFrame.Angles(0, (if v5 then -0.3490658503988659 elseif v6 then 0.3490658503988659 elseif v92 then math.rad(v92 * -4) else 0) * (p1 * RotationSpeed * 2), 0)
				local v14 = Speed * -0.25
				v52.VectorVelocity = v52.VectorVelocity:Lerp(Vector3.new(1, 0, 0) * (if v13 then v13 * v14 elseif v7 then v14 elseif v82 then -v14 else 0), p1 * v17)
				if not Animations then
					return
				end
				local v162 = math.abs(v52.VectorVelocity.X)
				if v162 < 2 then
					if v11 == "Idle" then
						return
					end
					v11 = "Idle"
					if v8 then
						v8:Stop(0.2)
					end
					if v10 then
						v10:Stop(0.2)
					end
					if v9 then
						v9:Stop(0.2)
					end
					if v8 then
						v8:Play(0.2)
					end
				elseif v18 <= v162 then
					if v11 == "Surfing" then
						return
					end
					v11 = "Surfing"
					if v8 then
						v8:Stop(0.2)
					end
					if v10 then
						v10:Stop(0.2)
					end
					if v9 then
						v9:Stop(0.2)
					end
					if v9 then
						v9:Play(0.2)
					end
				else
					if v11 == "SlowSurfing" then
						return
					end
					v11 = "SlowSurfing"
					if v8 then
						v8:Stop(0.2)
					end
					if v10 then
						v10:Stop(0.2)
					end
					if v9 then
						v9:Stop(0.2)
					end
					if v12 and v10 then
						v10:Play(0.2)
						return
					end
					if not v9 then
						return
					end
					v9:Play(0.2)
				end
			end))
		else
			if not v3 then
				return
			end
			v5:Clean()
			local v19 = v3.Parent
			local v20 = if v19 then v19:FindFirstChild("Base") else v19
			if v20 and v20:IsA("BasePart") then
				resetAssembly(v20)
				for i = 1, 6 do
					pcall(resetAssembly, v20)
					task.wait()
				end
			end
			v3 = nil
		end
	end
	v4:Add(Humanoid:GetPropertyChangedSignal("SeatPart"):Connect(SeatPartChanged))
	v4:Add(Humanoid.Died:Once(DestroyAll))
	v4:Add(Character.Destroying:Once(DestroyAll))
	local v6 = TagEffect.configure():ignoreDescendantOf(ReplicatedStorage):targetParent():withDefaultConfig({})
	v6:effect("Boat_Core", function(p1, p2) --[[ Line: 413 | Upvalues: Teardown (copy), RunService (copy) ]]
		return Teardown.fn(RunService.Heartbeat:Connect(function() --[[ Line: 419 | Upvalues: p1 (copy) ]]
			if not p1.Anchored then
				return
			end
			p1.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			p1.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end))
	end)
	v6:effect("Boat_Wave", function(p1, p2) --[[ Line: 428 | Upvalues: Players (copy), Teardown (copy), RunService (copy) ]]
		if p2.ownerUserId == Players.LocalPlayer.UserId then
			local v1 = p2.customScale or 1
			return Teardown.fn(RunService.Heartbeat:Connect(function() --[[ Line: 436 | Upvalues: p1 (copy), v1 (copy) ]]
				local v2 = CFrame.new
				local v3 = time() * 1
				local v4 = v2(0, math.cos(v3) * math.noise(time() * 0.2) * 0.4 * v1, 0)
				local Angles = CFrame.Angles
				local v5 = time() * 1.1
				local v7 = math.rad(math.sin(v5) * math.noise(100 + time() * 0.3) * 5 * v1)
				local v8 = time() * 0.9
				p1.C1 = v4 * Angles(v7, 0, (math.rad(math.sin(v8) * math.noise(1000 + time() * 0.4) * 5 * v1)))
			end))
		end
	end)
end