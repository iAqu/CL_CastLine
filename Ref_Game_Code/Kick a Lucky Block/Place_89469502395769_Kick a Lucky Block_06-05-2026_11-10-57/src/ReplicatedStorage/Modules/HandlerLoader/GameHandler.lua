-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local CameraController = require(ReplicatedStorage.Modules.ControllerLoader.CameraController)
local TransformController = require(ReplicatedStorage.Modules.ControllerLoader.TransformController)
local ZoneController = require(ReplicatedStorage.Modules.ControllerLoader.ZoneController)
local KickController = require(ReplicatedStorage.Modules.ControllerLoader.KickController)
local TsunamiController = require(ReplicatedStorage.Modules.ControllerLoader.TsunamiController)
local AnimationController = require(ReplicatedStorage.Modules.ControllerLoader.AnimationController)
require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local DistanceBar = require(ReplicatedStorage.Modules.UILoader.DistanceBar)
local NewInventory = require(ReplicatedStorage.Modules.UILoader.NewInventory)
local Kickbar = require(ReplicatedStorage.Modules.UILoader.Kickbar)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local CameraShakeController = require(ReplicatedStorage.Modules.ControllerLoader.CameraShakeController)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local LBClass = require(ReplicatedStorage.Classes.LBClass)
local FSM = require(ReplicatedStorage.Shared.Packages.FSM)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
require(ReplicatedStorage.Modules.ServicesLoader.WeatherService_Client)
local MutationSwitch = require(ReplicatedStorage.Shared.Data.MutationSwitch)
local CustomKick = require(ReplicatedStorage.Shared.Data.CustomKick)
local RarityData = require(ReplicatedStorage.Shared.Data.RarityData)
local LocalPlayer = game:GetService("Players").LocalPlayer
local Icon = LocalPlayer:GetMouse().Icon
local BrainrotNames = SoundService.BrainrotNames
local Fall = SoundService.Effects.Fall
local CurrentCamera = workspace.CurrentCamera
local t = {
	InGame = false,
	Status = "Lobby",
	Trove = Trove.new(),
	GameChanged = Signal.new(),
	GotResult = Signal.new(),
	StatusChanged = Signal.new()
}
local v1 = FSM.new({
	CanKick = {
		OnEnter = function() --[[ OnEnter | Line: 73 | Upvalues: t (copy) ]]
			t.Trove:Add(LoadVisuals())
			t.Trove:Add(StartKickButton())
		end,
		OnLeave = function() --[[ OnLeave | Line: 78 | Upvalues: t (copy) ]]
			t.Trove:Clean()
		end
	},
	Blocked = {
		OnEnter = function() --[[ OnEnter | Line: 84 ]] end,
		OnLeave = function() --[[ OnLeave | Line: 88 | Upvalues: t (copy) ]]
			t.Trove:Clean()
		end
	},
	InKick = {
		OnEnter = function() --[[ OnEnter | Line: 95 | Upvalues: SpeedServiceClient (copy), NewInventory (copy) ]]
			SpeedServiceClient:SlowMode(false)
			NewInventory:Disable()
		end,
		OnLeave = function() --[[ OnLeave | Line: 100 | Upvalues: SpeedServiceClient (copy), NewInventory (copy), t (copy) ]]
			SpeedServiceClient:SlowMode(true)
			NewInventory:Enable()
			t.Trove:Clean()
		end
	}
})
function LoadVisuals() --[[ LoadVisuals | Line: 112 | Upvalues: AnimationController (copy) ]]
	AnimationController.PlayAnim("HoldAnim")
	local v1 = HoldLuckyBlock()
	return function() --[[ Line: 117 | Upvalues: AnimationController (ref), v1 (copy) ]]
		AnimationController.StopAnim("HoldAnim")
		v1()
	end
end
function StartKickButton() --[[ StartKickButton | Line: 123 | Upvalues: LocalPlayer (copy), ClientProfile (copy), Trove (copy), Kickbar (copy), KickController (copy), t (copy), VFXService (copy), Network (copy), MessagesService (copy), UserInputService (copy) ]]
	local HUD = LocalPlayer.PlayerGui:FindFirstChild("HUD")
	if HUD then
		local KickButton = HUD.KickButton
		KickButton.Visible = true
		if ClientProfile.Device == "Console" then
			KickButton.GamepadKey.Visible = true
		end
		local v1 = Trove.new()
		local v2 = nil
		local function StartKicking() --[[ StartKicking | Line: 141 | Upvalues: LocalPlayer (ref), Kickbar (ref), v2 (ref), KickController (ref), t (ref) ]]
			LocalPlayer.Character.PrimaryPart.Anchored = true
			StopAnims()
			Kickbar:Start()
			v2 = KickController:PerformKick(LocalPlayer.Character)
			t.Trove:Add(v2)
		end
		local function EndKicking() --[[ EndKicking | Line: 149 | Upvalues: VFXService (ref), LocalPlayer (ref), v2 (ref), KickController (ref), Kickbar (ref), Network (ref) ]]
			VFXService.PlayVFX("HighlightObject", LocalPlayer.Character)
			v2:Fire()
			v2 = nil
			local v1 = math.clamp(KickController.Scale, 0, 1)
			Kickbar:End(v1)
			Network.FireServer("KickEvent", v1)
			LocalPlayer.Character.PrimaryPart.Anchored = false
		end
		v1:Add(KickButton.Activated:Once(function() --[[ Line: 160 | Upvalues: LocalPlayer (ref), MessagesService (ref), KickButton (copy), Kickbar (ref), v2 (ref), KickController (ref), t (ref) ]]
			if LocalPlayer:GetAttribute("KickDebounced") then
				MessagesService:PlayMessage("Kick Debounced.", "Error")
			else
				KickButton.Visible = false
				LocalPlayer.Character.PrimaryPart.Anchored = true
				StopAnims()
				Kickbar:Start()
				v2 = KickController:PerformKick(LocalPlayer.Character)
				t.Trove:Add(v2)
			end
		end))
		v1:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 170 | Upvalues: v2 (ref), KickButton (copy), LocalPlayer (ref), Kickbar (ref), KickController (ref), t (ref) ]]
			if not p2 and (not v2 and p1.KeyCode == Enum.KeyCode.ButtonB) then
				KickButton.Visible = false
				LocalPlayer.Character.PrimaryPart.Anchored = true
				StopAnims()
				Kickbar:Start()
				v2 = KickController:PerformKick(LocalPlayer.Character)
				t.Trove:Add(v2)
			end
		end))
		v1:Add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 184 | Upvalues: v2 (ref), EndKicking (copy) ]]
			if not p2 and (v2 and (p1.UserInputType == Enum.UserInputType.Touch or (p1.UserInputType == Enum.UserInputType.MouseButton1 or p1.KeyCode == Enum.KeyCode.ButtonR2))) then
				EndKicking()
			end
		end))
		return function() --[[ Line: 200 | Upvalues: v1 (copy), KickButton (copy) ]]
			v1:Clean()
			KickButton.Visible = false
		end
	end
end
function StopAnims() --[[ StopAnims | Line: 206 | Upvalues: LocalPlayer (copy) ]]
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		for i, v in ipairs(LocalPlayer.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
			if v.Name ~= "HoldAnim" then
				v:Stop()
			end
		end
	end
end
function HoldLuckyBlock() --[[ HoldLuckyBlock | Line: 219 | Upvalues: LocalPlayer (copy), ReplicatedStorage (copy) ]]
	local Character = LocalPlayer.Character
	if Character then
		local UpperTorso = Character:FindFirstChild("UpperTorso")
		if UpperTorso then
			local v1 = ReplicatedStorage.Objects.LuckyBlocks.Common:Clone()
			v1:WaitForChild("Root").Anchored = false
			for i, v in ipairs(v1:GetChildren()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
					v.Massless = true
				end
			end
			local Weld = Instance.new("Weld")
			Weld.Part0 = UpperTorso
			Weld.Part1 = v1.Root
			Weld.C0 = CFrame.new(0, 0, -2)
			Weld.Parent = v1.Root
			v1.Parent = UpperTorso
			return function() --[[ Line: 247 | Upvalues: v1 (copy) ]]
				v1:Destroy()
			end
		end
	end
end
function LB_Anim_Load() --[[ LB_Anim_Load | Line: 252 | Upvalues: LocalPlayer (copy), ReplicatedStorage (copy) ]]
	local Character = LocalPlayer.Character
	if Character then
		local PrimaryPart = Character.PrimaryPart
		if PrimaryPart then
			local v1 = ReplicatedStorage.Objects.AnimObjects.Common:Clone()
			v1:WaitForChild("CubeRoot").Anchored = false
			local Motor6D = Instance.new("Motor6D")
			Motor6D.Part0 = PrimaryPart
			Motor6D.Part1 = v1.CubeRoot
			Motor6D.C0 = CFrame.Angles(0, -1.5707963267948966, 0)
			Motor6D.Parent = PrimaryPart
			v1.Parent = Character
			return function() --[[ Line: 273 | Upvalues: v1 (copy) ]]
				v1:Destroy()
			end
		end
	end
end
function UpdateState() --[[ UpdateState | Line: 278 | Upvalues: ZoneController (copy), t (copy), v1 (copy) ]]
	local isZone = ZoneController.Zone == "KickReady"
	if t.InGame then
		v1:GoToState("InKick")
	elseif isZone then
		v1:GoToState("CanKick")
	else
		v1:GoToState("Blocked")
	end
end
function CreatePart(p1) --[[ CreatePart | Line: 290 | Upvalues: ReplicatedStorage (copy), LBClass (copy) ]]
	local v1 = ReplicatedStorage.Objects.GameRelated.HitboxPart:Clone()
	v1.Transparency = 1
	v1.Position = p1
	local v2 = LBClass.new(v1)
	v1.Parent = workspace.Debris
	return v1, v2
end
function ForceLookToDistance() --[[ ForceLookToDistance | Line: 299 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	if Character and Character.PrimaryPart then
		Character.PrimaryPart.CFrame = CFrame.fromMatrix(Character.PrimaryPart.CFrame.Position, (Vector3.new(0, 1, 0)):Cross(-workspace.Areas.KickReady.CFrame.LookVector), Vector3.new(0, 1, 0), -workspace.Areas.KickReady.CFrame.LookVector)
	end
end
function OnStartKick(p1, p2, p3) --[[ OnStartKick | Line: 309 | Upvalues: t (copy), LocalPlayer (copy), RarityData (copy), CurrentCamera (copy), CustomKick (copy), KickController (copy), AnimationController (copy), TweenService (copy), SoundService (copy), CameraShakeController (copy), VFXService (copy), Fall (copy), DistanceBar (copy), CameraController (copy), ReplicatedStorage (copy), TransformController (copy), MutationSwitch (copy), Network (copy), TsunamiController (copy), RunService (copy) ]]
	if not t.InGame then
		local Character = LocalPlayer.Character
		if Character and Character.PrimaryPart then
			t.InGame = true
			t.GameChanged:Fire(true)
			local v1 = RarityData:GetRarityByDistance(p1)
			local KickReady = workspace.Areas.KickReady
			Character.PrimaryPart.CFrame = CFrame.new(Character.PrimaryPart.Position) * KickReady.CFrame.Rotation
			Character.PrimaryPart.Anchored = true
			Character.Humanoid.AutoRotate = false
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			CurrentCamera.CFrame = Character.PrimaryPart.CFrame * CFrame.new(5, 1, 10) * CFrame.Angles(0, 0.2617993877991494, 0)
			local v2 = LB_Anim_Load()
			local v4 = CustomKick.CustomKicks[CustomKick:GetKickFromScale(KickController.Scale)] or CustomKick.CustomKicks.Default
			local v5 = Character.PrimaryPart.CFrame:ToWorldSpace(v4.Offset)
			local v6 = AnimationController.PlayAnim(v4.AnimName or "KickAnim")
			if v6 then
				t.Trove:Connect(v6:GetMarkerReachedSignal("Camera"), function(p1) --[[ Line: 341 | Upvalues: TweenService (ref), CurrentCamera (ref), SoundService (ref) ]]
					if p1 == "Start" then
						TweenService:Create(CurrentCamera, TweenInfo.new(3), {
							FieldOfView = 55
						}):Play()
					elseif p1 == "Kick" then
						SoundService.Effects.Kicking.Kick.TimePosition = 0.1
						SoundService.Effects.Kicking.Kick:Resume()
						SoundService.Effects.Whoosh:Play()
					end
				end)
				if v4.Func then
					t.Trove:Add(v4.Func(v6))
				end
				v6:GetMarkerReachedSignal("Kick"):Wait()
				CameraShakeController.ScreenShake:ShakeOnce(3, 7, 0, 1.5)
				v2()
				VFXService.PlayVFX("KickVFX", Character)
				Fall:Play()
			end
			local Position = v5.Position
			local v7 = p1 + KickReady.CFrame:PointToObjectSpace(Position).Z
			local v8, v9 = CreatePart(Position)
			DistanceBar:Enable(v8)
			task.delay(0.25, function() --[[ Line: 371 | Upvalues: CameraController (ref), v8 (copy), KickReady (copy) ]]
				CameraController:LerpToSubject(v8, -KickReady.CFrame.LookVector)
			end)
			t.Trove:Add(v8)
			local v10, v11 = KickController:Kick(v8, Position, v7, KickReady.CFrame.LookVector)
			local v12 = "Common"
			local v13 = 0
			local RarityChange = SoundService.Effects.RarityChange
			RarityChange.PitchShiftSoundEffect.Octave = 1
			t.Trove:Connect(v10, function(p1) --[[ Line: 390 | Upvalues: v12 (ref), v9 (copy), VFXService (ref), v8 (copy), ReplicatedStorage (ref), RarityChange (copy), v13 (ref) ]]
				if p1 ~= v12 then
					v12 = p1
					v9:ChangeRarity(p1)
					VFXService.PlayVFX("EmitVFX", v8, ReplicatedStorage.Objects.VFX.SlapVFX)
					RarityChange.PitchShiftSoundEffect.Octave = v13 / 10 + 1
					RarityChange:Play()
					v13 = v13 + 1
				end
			end)
			t.Trove:Add(v11:Connect(function() --[[ Line: 408 | Upvalues: VFXService (ref), v8 (copy), SoundService (ref) ]]
				VFXService.PlayVFX("CraterAtPosition", v8.Position, 4.5, true)
				VFXService.PlayVFX("CraterAtPosition", v8.Position, 5)
				SoundService.Effects.Thud.TimePosition = 0.2
				SoundService.Effects.Thud:Resume()
			end))
			local v14 = v11:Wait()
			DistanceBar:Disable()
			Fall:Stop()
			VFXService.PlayVFX("LandingEffect", v8)
			t.Trove:Add(TransformController:TransformToBrainrot(LocalPlayer.Character, p2))
			LocalPlayer.Character.Humanoid.AutoRotate = true
			CurrentCamera.CameraType = Enum.CameraType.Scriptable
			local v15 = v9.VisualBlock or v8
			local v16 = CameraController:GetDistanceFromObject(v15, 0.2) or 20
			local v17 = CFrame.lookAt(v15:GetPivot().Position - (KickReady.CFrame.LookVector - Vector3.new(0, 0.4, 0)) * v16, v15:GetPivot().Position)
			TweenService:Create(CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				CFrame = v17
			}):Play()
			if p3 then
				task.wait(1)
				v9:ChangeRarity(p3)
				if MutationSwitch[p3] then
					MutationSwitch[p3](v8)
				end
				local v18 = CameraController:GetDistanceFromObject(v9.VisualBlock, 0.2) or 20
				local v19 = CFrame.lookAt(v15:GetPivot().Position - (KickReady.CFrame.LookVector - Vector3.new(0, 0.4, 0)) * v18, v15:GetPivot().Position)
				CurrentCamera.FieldOfView = 70
				TweenService:Create(CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true), {
					FieldOfView = 50
				}):Play()
				TweenService:Create(CurrentCamera, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					CFrame = v19
				}):Play()
				task.wait(0.5)
			end
			task.wait(1)
			if v9.VisualBlock then
				v9.VisualBlock:Destroy()
				v9.VisualBlock = nil
			end
			local v21 = CFrame.fromMatrix(v14, (Vector3.new(0, 1, 0)):Cross(KickReady.CFrame.LookVector), Vector3.new(0, 1, 0), KickReady.CFrame.LookVector)
			VFXService.PlayVFX("AnimateBrainrots", v1, v21, p2, workspace:GetServerTimeNow() + 2.5, 1, p3)
			local v23 = CameraController:GetDistanceFromObject(ReplicatedStorage.Objects.Entities:FindFirstChild(p2.Name), 0.7) or 20
			TweenService:Create(CurrentCamera, TweenInfo.new(0.5), {
				CFrame = CFrame.new(v14 + Vector3.new(0, 3, 0) - KickReady.CFrame.LookVector * v23, v14 + Vector3.new(0, 3, 0))
			}):Play()
			task.wait(2.5)
			Character.PrimaryPart.CFrame = v21 * CFrame.new(0, Character.Humanoid.HipHeight + Character.PrimaryPart.Size.Y / 2, 0)
			Network.FireServer("Transformed")
			local v24 = TsunamiController:SpawnWave(v1)
			if v24 then
				t.Trove:Add(v24)
			end
			Character.PrimaryPart.Anchored = false
			t.Status = "Tsunami"
			t.StatusChanged:Fire()
			local v25 = OverlapParams.new()
			v25.FilterDescendantsInstances = { Character }
			v25.FilterType = Enum.RaycastFilterType.Include
			local function CheckFinished() --[[ CheckFinished | Line: 490 | Upvalues: v25 (copy), Network (ref) ]]
				if #workspace:GetPartsInPart(workspace.Zones.CollectZone, v25) > 0 then
					Network.FireServer("KickCollect")
				end
			end
			if #workspace:GetPartsInPart(workspace.Zones.CollectZone, v25) > 0 then
				Network.FireServer("KickCollect")
			end
			t.Trove:Connect(RunService.PreRender, CheckFinished)
		end
	end
end
function OnGameEnded(p1) --[[ OnGameEnded | Line: 502 | Upvalues: t (copy), LocalPlayer (copy), VFXService (copy), SoundService (copy), DistanceBar (copy) ]]
	t.Trove:Clean()
	t.InGame = false
	t.GameChanged:Fire(false)
	t.Status = "Lobby"
	t.StatusChanged:Fire()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.AutoRotate = true
	end
	if p1 then
		VFXService.PlayVFX("ScreenColorEffect", Color3.fromRGB(255, 175, 0), true)
		SoundService.Effects.RewardSound:Play()
	else
		VFXService.PlayVFX("ScreenColorEffect", Color3.fromRGB(255, 0, 0), true)
	end
	t.GotResult:Fire(p1)
	DistanceBar:Disable()
end
function t._init(p1) --[[ _init | Line: 528 | Upvalues: SpeedServiceClient (copy), Network (copy), BrainrotNames (copy), ZoneController (copy), t (copy) ]]
	UpdateState()
	SpeedServiceClient:SlowMode(true)
	Network.OnClientEvent("KickEvent"):Connect(OnStartKick)
	Network.OnClientEvent("KickEventEnded"):Connect(OnGameEnded)
	Network.OnClientEvent("Collected"):Connect(function(p1) --[[ Line: 536 | Upvalues: BrainrotNames (ref) ]]
		local v1 = BrainrotNames:FindFirstChild(p1)
		if v1 then
			v1:Play()
		end
	end)
	ZoneController.ZoneChanged:Connect(UpdateState)
	t.GameChanged:Connect(UpdateState)
end
return t