-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
game:GetService("RunService")
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local MusicController = require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local EnvironmentController = require(ReplicatedStorage.Modules.ControllerLoader.EnvironmentController)
local v1 = Trove.new()
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {
	Active = false
}
function LoadMusic(p1) --[[ LoadMusic | Line: 35 | Upvalues: MusicController (copy), v1 (copy) ]]
	local v12, v2 = MusicController:StartCustom()
	v1:Add(v2)
	local t = {
		{
			Time = 16.25
		},
		{
			Time = 158.27,
			Song = script.Assets.Sounds.Phase1
		},
		{
			Time = 5
		},
		{
			Time = 126.36,
			Song = script.Assets.Sounds.Phase2
		}
	}
	local function v3(p12, p2) --[[ UpdatePhase | Line: 57 | Upvalues: t (copy), p1 (copy), v1 (ref), v3 (copy), v12 (copy) ]]
		if t[p12 - 1] and t[p12 - 1].Song then
			t[p12 - 1].Song:Stop()
		end
		local v13 = t[p12]
		if v13 then
			local v2 = p2 - (workspace:GetServerTimeNow() - p1)
			v1:Add(task.delay(v2, function() --[[ Line: 70 | Upvalues: t (ref), p12 (copy), v3 (ref), p2 (copy) ]]
				local v1 = t[p12 + 1]
				if v1 and v1.Time then
					v3(p12 + 1, p2 + v1.Time)
				end
			end))
			if v13.Song then
				v12(v13.Song, v13.Song.TimeLength - v2)
			end
		end
	end
	local v4 = workspace:GetServerTimeNow() - p1
	local function CheckPhase() --[[ CheckPhase | Line: 85 | Upvalues: t (copy), v4 (copy), v3 (copy) ]]
		local sum = 0
		for i, v in ipairs(t) do
			sum = sum + v.Time
			if v4 < sum then
				v3(i, sum)
				return
			end
		end
	end
	if v4 < 0 then
		v1:Add(task.delay(math.abs(v4), CheckPhase))
	else
		CheckPhase()
	end
end
function InitAura() --[[ InitAura | Line: 105 | Upvalues: v1 (copy), Players (copy) ]]
	local v12 = v1:Extend()
	local function LoadAura(p1) --[[ LoadAura | Line: 108 | Upvalues: v12 (copy) ]]
		if p1 then
			local v1 = p1:FindFirstChild("HumanoidRootPart") or p1:WaitForChild("HumanoidRootPart", 3)
			if v1 then
				v12:Clone(script.Assets.AuraAttachment).Parent = v1
			end
		end
	end
	for i, v in ipairs(Players:GetPlayers()) do
		local Character = v.Character
		if Character then
			local v2 = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 3)
			if v2 then
				v12:Clone(script.Assets.AuraAttachment).Parent = v2
			end
		end
		v12:Add(v.CharacterAdded:Connect(LoadAura))
	end
	v12:Add(Players.PlayerAdded:Connect(function(p1) --[[ Line: 127 | Upvalues: v12 (copy), LoadAura (copy) ]]
		local Character = p1.Character
		if Character then
			local v1 = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart", 3)
			if v1 then
				v12:Clone(script.Assets.AuraAttachment).Parent = v1
			end
		end
		v12:Add(p1.CharacterAdded:Connect(LoadAura))
	end))
end
function SpawnTrainers() --[[ SpawnTrainers | Line: 133 | Upvalues: v1 (copy) ]]
	local v12 = v1:Clone(script.Assets.Trainer_1)
	local v2 = v1:Clone(script.Assets.Trainer_2)
	v12.Parent = workspace.Debris
	v2.Parent = workspace.Debris
	return function() --[[ Line: 140 | Upvalues: v12 (copy), v2 (copy) ]]
		v12:Destroy()
		v2:Destroy()
	end
end
function LoadAnimations(p1) --[[ LoadAnimations | Line: 146 | Upvalues: v1 (copy), EnvironmentController (copy), MessagesService (copy), VFXService (copy), SoundService (copy) ]]
	local v12 = v1:Extend()
	local v2 = nil
	local v3 = nil
	local list = {
		{
			Time = 95.8,
			Load = function() --[[ Load | Line: 155 | Upvalues: v3 (ref), v2 (ref) ]]
				InitAura()
				if not (v3 or v2) then
					v3 = SpawnTrainers()
				end
			end
		},
		{
			Time = 180,
			Load = function() --[[ Load | Line: 166 | Upvalues: v2 (ref), v3 (ref), v1 (ref) ]]
				if not v2 then
					if v3 then
						v3()
						v3 = nil
					end
					local v12 = v1:Clone(script.Assets.mikidguytraining)
					v2 = v12
					v12:PivotTo(CFrame.new(729.078, 7.5, 231.348) * CFrame.Angles(0, -1.5707963267948966, 0))
					v12.Parent = workspace.Debris
					local v22 = v12:WaitForChild("Humanoid"):WaitForChild("Animator"):LoadAnimation(script.Assets.Animations.SquatBarbell)
					v22:Play()
					v1:Add(function() --[[ Line: 184 | Upvalues: v22 (copy) ]]
						v22:Destroy()
					end)
				end
			end
		},
		{
			Time = 189,
			Load = function() --[[ Load | Line: 193 | Upvalues: EnvironmentController (ref) ]]
				EnvironmentController:ChangeEnvironment("Fire")
			end
		}
	}
	local list2 = {
		{
			Time = 3.33,
			Load = function() --[[ Load | Line: 202 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Ready?", "Dev", "mikidguy")
			end
		},
		{
			Time = 5,
			Load = function() --[[ Load | Line: 208 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("LET\'S BEGIN!", "Dev", "mikidguy")
			end
		},
		{
			Time = 5.8,
			Load = function() --[[ Load | Line: 214 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("<font color = \"#ffd21d\">WARM UP</font>", "Info", "x1.25 Lift Speed")
			end
		},
		{
			Time = 10.25,
			Load = function() --[[ Load | Line: 220 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("bruh that\'s boring \240\159\164\163", "Dev", "shondguy")
			end
		},
		{
			Time = 16.25,
			Load = function() --[[ Load | Line: 226 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("let\'s begin for real\240\159\152\136", "Dev", "adamdguy")
			end
		},
		{
			Time = 16.5,
			Load = function() --[[ Load | Line: 232 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("<font color = \"#00ffe1\">TRAIN TIME</font>", "Info", "x1.5 Lift Speed")
			end
		},
		{
			Time = 22.5,
			Load = function() --[[ Load | Line: 238 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("yeah that\'s better", "Dev", "shondguy")
			end
		},
		{
			Time = 35.5,
			Load = function() --[[ Load | Line: 244 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("but I\'m still missing something..", "Dev", "shondguy")
			end
		},
		{
			Time = 44.5,
			Load = function() --[[ Load | Line: 250 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("bet\240\159\152\137", "Dev", "mikidguy")
			end
		},
		{
			Time = 52,
			Load = function() --[[ Load | Line: 256 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Tap the bonus buttons!!", "Dev", "mikidguy")
			end
		},
		{
			Time = 67,
			Load = function() --[[ Load | Line: 262 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Thank you guys for participating in this event :D", "Dev", "shondguy")
			end
		},
		{
			Time = 87.8,
			Load = function() --[[ Load | Line: 268 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("what\'s now adam?", "Dev", "shondguy")
			end
		},
		{
			Time = 95.8,
			Load = function() --[[ Load | Line: 274 | Upvalues: MessagesService (ref), v3 (ref) ]]
				MessagesService:PlayMessage("MORE POWER", "Dev", "adamdguy")
				MessagesService:PlayMessage("<font color = \"#bf00ff\">MAX EFFORT</font>", "Info", "x2 Lift Speed")
				InitAura()
				v3 = SpawnTrainers()
			end
		},
		{
			Time = 100,
			Load = function() --[[ Load | Line: 283 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("LET\'S GO!", "Dev", "shondguy")
			end
		},
		{
			Time = 107,
			Load = function() --[[ Load | Line: 289 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("\240\159\152\142", "Dev", "adamdguy")
			end
		},
		{
			Time = 144,
			Load = function() --[[ Load | Line: 295 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("ready to amp it up?", "Dev", "adamdguy")
			end
		},
		{
			Time = 152.8,
			Load = function() --[[ Load | Line: 301 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("hell yeah!", "Dev", "shondguy")
			end
		},
		{
			Time = 170,
			Load = function() --[[ Load | Line: 307 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("Whitescreen", 2)
			end
		},
		{
			Time = 175,
			Load = function() --[[ Load | Line: 313 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("wait, where\'s miki?", "Dev", "adamdguy")
			end
		},
		{
			Time = 179,
			Load = function() --[[ Load | Line: 319 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("\240\159\152\137", "Dev", "mikidguy")
			end
		},
		{
			Time = 179.5,
			Load = function() --[[ Load | Line: 325 | Upvalues: v1 (ref), v2 (ref), VFXService (ref), SoundService (ref), v3 (ref), MessagesService (ref) ]]
				local v12 = v1:Clone(script.Assets.mikidguytraining)
				v2 = v12
				v12:PivotTo(CFrame.new(729.078, 7.5, 231.348) * CFrame.Angles(0, -1.5707963267948966, 0))
				v12.Parent = workspace.Debris
				local Animator = v12:WaitForChild("Humanoid"):WaitForChild("Animator")
				local v22 = Animator:LoadAnimation(script.Assets.Animations.SpawnAnim)
				local v32 = Animator:LoadAnimation(script.Assets.Animations.SquatBarbell)
				v22:Play()
				v22.Looped = false
				v1:Add(v22.Ended:Once(function() --[[ Line: 338 | Upvalues: v32 (copy) ]]
					v32:Play()
				end))
				v1:Add(v22:GetMarkerReachedSignal("Crater"):Once(function() --[[ Line: 342 | Upvalues: VFXService (ref), SoundService (ref), v3 (ref), MessagesService (ref), v1 (ref) ]]
					VFXService.PlayVFX("CraterAtPosition", Vector3.new(732.506, 0.488, 223.752), 3, 3)
					SoundService.Effects.Explosion_1:Play()
					if v3 then
						MessagesService:PlayMessage("OUCH", "Dev", "adamdguy")
						v1:Add(task.delay(1, function() --[[ Line: 348 | Upvalues: MessagesService (ref) ]]
							MessagesService:PlayMessage("WHAT WAS THAT?", "Dev", "shondguy")
						end))
						v1:Add(task.delay(3, function() --[[ Line: 351 | Upvalues: MessagesService (ref) ]]
							MessagesService:PlayMessage("HAHAHAHHAHA", "Dev", "mikidguy")
						end))
						v3()
						v3 = nil
					end
				end))
				v1:Add(function() --[[ Line: 359 | Upvalues: v32 (copy), v22 (copy) ]]
					v32:Destroy()
					v22:Destroy()
				end)
			end
		},
		{
			Time = 186,
			Load = function() --[[ Load | Line: 368 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("TIME TO LIFT \240\159\148\165", "Dev", "mikidguy")
			end
		},
		{
			Time = 189,
			Load = function() --[[ Load | Line: 374 | Upvalues: VFXService (ref), EnvironmentController (ref), MessagesService (ref) ]]
				VFXService.PlayVFX("Whitescreen", 2, Color3.fromRGB())
				task.delay(1, function() --[[ Line: 376 | Upvalues: EnvironmentController (ref), MessagesService (ref) ]]
					EnvironmentController:ChangeEnvironment("Fire")
					MessagesService:PlayMessage("<font color = \"#ff0000\">HELL MODE</font>", "Info", "x3.5 LIFT SPEED")
				end)
			end
		}
	}
	local function v4(p1) --[[ UpdatePhase | Line: 385 | Upvalues: v12 (copy), list2 (copy), v1 (ref), v4 (copy) ]]
		v12:Clean()
		local v13 = list2[p1]
		if v13 then
			local v2 = list2[p1 + 1]
			if v2 and v2.Time then
				v1:Add(task.delay(v2.Time - v13.Time, function() --[[ Line: 396 | Upvalues: v4 (ref), p1 (copy) ]]
					v4(p1 + 1)
				end))
			end
			if v13.Load then
				v13.Load()
			end
		end
	end
	local v5 = workspace:GetServerTimeNow() - p1
	for i, v in ipairs(list) do
		if v.Time < v5 then
			task.spawn(function() --[[ Line: 410 | Upvalues: v (copy) ]]
				v.Load()
			end)
		end
	end
	for i, v in ipairs(list2) do
		if v5 < v.Time then
			v1:Add(task.delay(v.Time - v5, function() --[[ Line: 419 | Upvalues: v4 (copy), i (copy) ]]
				v4(i)
			end))
		else
			continue
		end
		break
	end
end
function Initialize(p1) --[[ Initialize | Line: 428 | Upvalues: v1 (copy) ]]
	local v12 = p1 - 305.88
	LoadMusic(v12)
	LoadAnimations(v12)
	v1:Add(ReturnToDefault)
end
function ReturnToDefault() --[[ ReturnToDefault | Line: 436 | Upvalues: VFXService (copy), EnvironmentController (copy) ]]
	VFXService.PlayVFX("Whitescreen", 3)
	task.delay(1, function() --[[ Line: 438 | Upvalues: EnvironmentController (ref) ]]
		EnvironmentController:Reset()
	end)
end
function t.Initialize(p1, p2) --[[ Initialize | Line: 445 ]]
	if not p1.Active then
		p1.Active = true
		Initialize(p2)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 454 | Upvalues: v1 (copy) ]]
	if p1.Active then
		v1:Clean()
		p1.Active = false
	end
end
return t