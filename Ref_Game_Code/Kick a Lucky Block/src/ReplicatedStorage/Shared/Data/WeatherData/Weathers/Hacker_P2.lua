-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Lighting")
local Players = game:GetService("Players")
game:GetService("SoundService")
local RunService = game:GetService("RunService")
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local MusicController = require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local EnvironmentController = require(ReplicatedStorage.Modules.ControllerLoader.EnvironmentController)
require(ReplicatedStorage.Modules.UILoader.HackedBar)
local CameraShakeController = require(ReplicatedStorage.Modules.ControllerLoader.CameraShakeController)
local v1 = Trove.new()
local LocalPlayer = Players.LocalPlayer
local HackerLaugh = SoundService.Effects.HackerLaugh
local v2 = CFrame.new(539.71, 37.583, 229.45)
local v3 = CFrame.new(627.765, 32.018, 230.694) * CFrame.Angles(0, -1.5707963267948966, 0)
local GreenPortal = script.Assets.GreenPortal
local t = {
	Active = false
}
function LoadMusic(p1) --[[ LoadMusic | Line: 42 | Upvalues: MusicController (copy), v1 (copy) ]]
	local v12, v2 = MusicController:StartCustom()
	v1:Add(v2)
	local t = {
		{
			Time = 35
		},
		{
			Mute = true,
			Time = 20
		},
		{
			Time = 169.846,
			Song = script.Assets.Sounds.First
		},
		{
			Time = 134.12,
			Song = script.Assets.Sounds.Second
		},
		{
			Time = 188.961,
			Song = script.Assets.Sounds.Third
		},
		{
			Time = 65.841,
			Song = script.Assets.Sounds.Hacker
		}
	}
	local function v3(p12, p2) --[[ UpdatePhase | Line: 73 | Upvalues: t (copy), p1 (copy), v1 (ref), v3 (copy), v12 (copy) ]]
		if t[p12 - 1] and t[p12 - 1].Song then
			t[p12 - 1].Song:Stop()
		end
		local v13 = t[p12]
		if v13 then
			local v2 = p2 - (workspace:GetServerTimeNow() - p1)
			v1:Add(task.delay(v2, function() --[[ Line: 86 | Upvalues: t (ref), p12 (copy), v3 (ref), p2 (copy) ]]
				local v1 = t[p12 + 1]
				if v1 and v1.Time then
					v3(p12 + 1, p2 + v1.Time)
				end
			end))
			if v13.Song then
				v12(v13.Song, v13.Song.TimeLength - v2)
			elseif v13.Mute then
				v12(nil)
			end
		end
	end
	local v4 = workspace:GetServerTimeNow() - p1
	local function CheckPhase() --[[ CheckPhase | Line: 103 | Upvalues: t (copy), v4 (copy), v3 (copy) ]]
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
function LoadModel(p1) --[[ LoadModel | Line: 123 | Upvalues: v1 (copy), v3 (copy) ]]
	if script.Assets.Models:FindFirstChild(p1) then
		local v12 = v1:Clone(script.Assets.Models[p1])
		v12:PivotTo(v3)
		v12:WaitForChild("Humanoid"):WaitForChild("Animator")
		for i, v in ipairs(v12:GetDescendants()) do
			if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
				v.LocalTransparencyModifier = 1
			end
		end
		v12.Parent = workspace.Debris
		local t = {}
		if script.Assets.Animations:FindFirstChild(p1) then
			for i, v in ipairs(script.Assets.Animations[p1]:GetChildren()) do
				t[v.Name] = v12.Humanoid.Animator:LoadAnimation(v)
			end
		end
		return v12, function(p1, p2) --[[ PlayAnim | Line: 149 | Upvalues: t (copy) ]]
			if typeof(p1) == "Instance" then
				p1 = p1.Name
			elseif typeof(p1) ~= "string" then
				return
			end
			if t[p1] then
				t[p1]:Play(p2)
				return t[p1]
			end
		end, function(p1, p2) --[[ StopAnim | Line: 162 | Upvalues: t (copy) ]]
			if typeof(p1) == "Instance" then
				p1 = p1.Name
			elseif typeof(p1) ~= "string" then
				return
			end
			if t[p1] and t[p1].IsPlaying then
				t[p1]:Stop(p2)
				return t[p1]
			end
		end
	else
		warn((("No %* model found."):format(p1)))
	end
end
function SpawnPortal(p1, p2, p3, p4) --[[ SpawnPortal | Line: 178 | Upvalues: RunService (copy) ]]
	if p4 then
		if p3 then
			local v1 = tick()
			local v2 = nil
			v2 = RunService.Heartbeat:Connect(function() --[[ Line: 209 | Upvalues: v1 (copy), p1 (copy), v2 (ref) ]]
				local v22 = math.min((tick() - v1) / 1, 1)
				p1:ScaleTo((math.max(1 - v22, 0.001)))
				if v22 >= 1 then
					v2:Disconnect()
					p1:Destroy()
				end
			end)
			return v2
		else
			p1:Destroy()
		end
	else
		p1:PivotTo(p2 * CFrame.Angles(0, -3.141592653589793, -1.5707963267948966))
		p1:ScaleTo(0.001)
		p1.Parent = workspace
		if p3 then
			local v3 = tick()
			local v4 = nil
			v4 = RunService.Heartbeat:Connect(function() --[[ Line: 190 | Upvalues: v3 (copy), p1 (copy), v4 (ref) ]]
				local v2 = math.min((tick() - v3) / 1.5, 1) - 1
				local v32 = v2 * v2 * (v2 * 2.70158 + 1.70158) + 1
				p1:ScaleTo(v32)
				if v32 >= 1 then
					v4:Disconnect()
				end
			end)
			return v4
		else
			p1:ScaleTo(1)
		end
	end
end
function LoadAnimations(p1) --[[ LoadAnimations | Line: 222 | Upvalues: v1 (copy), GreenPortal (copy), v2 (copy), EnvironmentController (copy), MessagesService (copy), VFXService (copy), TweenService (copy), HackerLaugh (copy), CameraShakeController (copy) ]]
	local v12 = v1:Extend()
	local v22, v3, v4 = LoadModel("Guest")
	local v5, v6, v7 = LoadModel("Hacker")
	local v8, v9, v10 = LoadModel("mikidguy")
	local v11, v122, v13 = LoadModel("adamdguy")
	local v14, v15, v16 = LoadModel("shondguy")
	local v17 = nil
	v8:WaitForChild("Handle").Size = Vector3.new(25.94, 68.248, 40.202)
	v14:WaitForChild("Handle").Size = Vector3.new(25.94, 68.248, 40.202)
	local list = {
		{
			Time = 62,
			EndTime = 91,
			Load = function() --[[ Load | Line: 239 | Upvalues: GreenPortal (ref), v2 (ref), v17 (ref), v1 (ref) ]]
				local v12 = GreenPortal:Clone()
				SpawnPortal(v12, v2, false)
				v17 = v12
				v1:Add(v12)
			end
		},
		{
			Time = 65,
			EndTime = 100,
			Load = function() --[[ Load | Line: 250 | Upvalues: v5 (copy), v6 (copy) ]]
				for i, v in ipairs(v5:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
				v6("Idle")
			end
		},
		{
			Time = 86,
			EndTime = 100,
			Load = function() --[[ Load | Line: 263 | Upvalues: v22 (copy), v3 (copy) ]]
				for i, v in ipairs(v22:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
				v3("Idle")
			end
		},
		{
			Time = 100,
			EndTime = 573,
			Load = function() --[[ Load | Line: 276 | Upvalues: v5 (copy), v6 (copy) ]]
				for i, v in ipairs(v5:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
				v6("WallIdle")
			end
		},
		{
			Time = 100,
			EndTime = 573,
			Load = function() --[[ Load | Line: 289 | Upvalues: v22 (copy), v3 (copy) ]]
				for i, v in ipairs(v22:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
				v3("WallIdle")
			end
		},
		{
			Time = 101,
			EndTime = 600,
			Load = function() --[[ Load | Line: 302 | Upvalues: EnvironmentController (ref) ]]
				EnvironmentController:ChangeEnvironment("Hacker2")
			end
		},
		{
			Time = 542,
			EndTime = 600,
			Load = function() --[[ Load | Line: 310 | Upvalues: v15 (copy), v14 (copy) ]]
				task.delay(1, function() --[[ Line: 311 | Upvalues: v15 (ref) ]]
					v15("Idle")
				end)
				for i, v in ipairs(v14:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
			end
		},
		{
			Time = 543,
			EndTime = 600,
			Load = function() --[[ Load | Line: 325 | Upvalues: v9 (copy), v8 (copy) ]]
				task.delay(1, function() --[[ Line: 326 | Upvalues: v9 (ref) ]]
					v9("Idle")
				end)
				for i, v in ipairs(v8:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
			end
		},
		{
			Time = 579,
			EndTime = 600,
			Load = function() --[[ Load | Line: 340 | Upvalues: v11 (copy), v122 (copy) ]]
				for i, v in ipairs(v11:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
				v122("Idle")
			end
		}
	}
	local list2 = {
		{
			Time = 1,
			Load = function() --[[ Load | Line: 355 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("that void event was INSANE!", "Dev", "adamdguy")
			end
		},
		{
			Time = 5,
			Load = function() --[[ Load | Line: 361 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("bro that was so good \240\159\148\165", "Dev", "shondguy")
			end
		},
		{
			Time = 9,
			Load = function() --[[ Load | Line: 367 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("i got so many void brainrots!", "Dev", "mikidguy")
			end
		},
		{
			Time = 14,
			Load = function() --[[ Load | Line: 373 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("i hope the players liked it", "Dev", "adamdguy")
			end
		},
		{
			Time = 19,
			Load = function() --[[ Load | Line: 379 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("alright what should we do next?", "Dev", "shondguy")
			end
		},
		{
			Time = 23,
			Load = function() --[[ Load | Line: 385 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("let\'s run something even BIGGER", "Dev", "adamdguy")
			end
		},
		{
			Time = 27,
			Load = function() --[[ Load | Line: 391 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I got something prepared \240\159\152\143", "Dev", "mikidguy")
			end
		},
		{
			Time = 31,
			Load = function() --[[ Load | Line: 397 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("let\'s gooo!", "Dev", "shondguy")
			end
		},
		{
			Time = 34,
			Load = function() --[[ Load | Line: 403 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("loading the event now...", "Dev", "mikidguy")
			end
		},
		{
			Time = 36,
			Load = function() --[[ Load | Line: 410 | Upvalues: MessagesService (ref), VFXService (ref) ]]
				MessagesService:PlayMessage("SYSTEM ERROR", "Error")
				VFXService.PlayVFX("HackGlitch", 3, 1)
			end
		},
		{
			Time = 39,
			Load = function() --[[ Load | Line: 419 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("that wasn\'t part of the plan", "Dev", "mikidguy")
			end
		},
		{
			Time = 41,
			Load = function() --[[ Load | Line: 425 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("wha-", "Dev", "adamdguy")
			end
		},
		{
			Time = 42,
			Load = function() --[[ Load | Line: 431 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy has been banned from the event", "System")
			end
		},
		{
			Time = 44,
			Load = function() --[[ Load | Line: 437 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Yo wh-", "Dev", "shondguy")
			end
		},
		{
			Time = 45,
			Load = function() --[[ Load | Line: 443 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy has been banned from the event", "System")
			end
		},
		{
			Time = 49,
			Load = function() --[[ Load | Line: 449 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Not again!", "Dev", "mikidguy")
			end
		},
		{
			Time = 51,
			Load = function() --[[ Load | Line: 455 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy has been banned from the event", "System")
			end
		},
		{
			Time = 55,
			Load = function() --[[ Load | Line: 462 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("HackGlitch", 4, 1)
			end
		},
		{
			Time = 62,
			Load = function() --[[ Load | Line: 468 | Upvalues: GreenPortal (ref), v2 (ref), v17 (ref), v1 (ref) ]]
				local v12 = GreenPortal:Clone()
				SpawnPortal(v12, v2, true)
				v17 = v12
				v1:Add(v12)
			end
		},
		{
			Time = 65,
			Load = function() --[[ Load | Line: 478 | Upvalues: v6 (copy), v5 (copy), TweenService (ref), v1 (ref) ]]
				local v12 = v6("Walk")
				for i, v in ipairs(v5:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						TweenService:Create(v, TweenInfo.new(1), {
							LocalTransparencyModifier = 0
						}):Play()
					end
				end
				v1:Add(task.delay(v12.Length - 0.2, function() --[[ Line: 488 | Upvalues: v6 (ref) ]]
					v6("Idle", 0.2)
				end))
			end
		},
		{
			Time = 70,
			Load = function() --[[ Load | Line: 497 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("You thought that was it...", "Hacker")
			end
		},
		{
			Time = 73,
			Load = function() --[[ Load | Line: 503 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("didn\'t you?", "Hacker")
			end
		},
		{
			Time = 74,
			Load = function() --[[ Load | Line: 509 | Upvalues: MessagesService (ref), HackerLaugh (ref) ]]
				MessagesService:PlayMessage("HAHAHAHAHA", "Hacker")
				HackerLaugh:Play()
			end
		},
		{
			Time = 78,
			Load = function() --[[ Load | Line: 516 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("BUT THIS TIME....", "Hacker")
			end
		},
		{
			Time = 80,
			Load = function() --[[ Load | Line: 522 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("IM NOT ALONE", "Hacker")
			end
		},
		{
			Time = 84,
			Load = function() --[[ Load | Line: 528 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I BROUGHT A VERY SPECIAL...", "Hacker")
			end
		},
		{
			Time = 86,
			Load = function() --[[ Load | Line: 534 | Upvalues: MessagesService (ref), v3 (copy), v22 (copy), TweenService (ref), v1 (ref) ]]
				MessagesService:PlayMessage("GUEST", "Hacker")
				local v12 = v3("Walk")
				for i, v in ipairs(v22:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						TweenService:Create(v, TweenInfo.new(1), {
							LocalTransparencyModifier = 0
						}):Play()
					end
				end
				v1:Add(task.delay(v12.Length - 0.2, function() --[[ Line: 546 | Upvalues: v3 (ref) ]]
					v3("Idle", 0.2)
				end))
			end
		},
		{
			Time = 89,
			Load = function() --[[ Load | Line: 553 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Guest666 has joined the event", "System")
			end
		},
		{
			Time = 91,
			Load = function() --[[ Load | Line: 560 | Upvalues: v17 (ref), v2 (ref), v1 (ref) ]]
				if v17 then
					v1:Add((SpawnPortal(v17, v2, true, true)))
				end
			end
		},
		{
			Time = 93,
			Load = function() --[[ Load | Line: 570 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("ready?", "Hacker")
			end
		},
		{
			Time = 96,
			Load = function() --[[ Load | Line: 576 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("let\'s do it\240\159\152\136 ", "Guest666")
			end
		},
		{
			Time = 100,
			Load = function() --[[ Load | Line: 582 | Upvalues: v4 (copy), v7 (copy), v3 (copy), v6 (copy), v1 (ref), CameraShakeController (ref), VFXService (ref), EnvironmentController (ref) ]]
				v4("Idle", 0.2)
				v7("Idle", 0.2)
				local v12 = v3("FistBump", 0.2)
				if v12 and v6("FistBump", 0.2) then
					v1:Add(v12:GetMarkerReachedSignal("Bump"):Once(function() --[[ Line: 591 | Upvalues: CameraShakeController (ref), VFXService (ref), EnvironmentController (ref), v3 (ref), v6 (ref) ]]
						CameraShakeController.ScreenShake:ShakeOnce(3, 7, 0, 1.5)
						VFXService.PlayVFX("Whitescreen", 1)
						task.delay(0.5, function() --[[ Line: 594 | Upvalues: EnvironmentController (ref), v3 (ref), v6 (ref) ]]
							EnvironmentController:ChangeEnvironment("Hacker2")
							v3("WallIdle", 0)
							v6("WallIdle", 0)
						end)
					end))
				end
			end
		},
		{
			Time = 110,
			Load = function() --[[ Load | Line: 605 | Upvalues: HackerLaugh (ref), MessagesService (ref) ]]
				HackerLaugh:Play()
				MessagesService:PlayMessage("it\'s OVER for this game \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 115,
			Load = function() --[[ Load | Line: 612 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("no one can save them now", "Guest666")
			end
		},
		{
			Time = 123,
			Load = function() --[[ Load | Line: 618 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("alright alright...", "Hacker")
			end
		},
		{
			Time = 127,
			Load = function() --[[ Load | Line: 624 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("let\'s lighten the vibe a little", "Hacker")
			end
		},
		{
			Time = 132,
			Load = function() --[[ Load | Line: 630 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("yeah lol... admins are banned either way", "Guest666")
			end
		},
		{
			Time = 138,
			Load = function() --[[ Load | Line: 636 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("PARTY TIME \240\159\142\137", "Hacker")
			end
		},
		{
			Time = 144,
			Load = function() --[[ Load | Line: 642 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("now THIS is what I\'m talking about", "Guest666")
			end
		},
		{
			Time = 150,
			Load = function() --[[ Load | Line: 648 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("this is OUR game now \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 156,
			Load = function() --[[ Load | Line: 654 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("im having the time of my life!", "Guest666")
			end
		},
		{
			Time = 165,
			Load = function() --[[ Load | Line: 661 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("alright players.. who wants some buffs \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 175,
			Load = function() --[[ Load | Line: 667 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("this is great!", "Hacker")
			end
		},
		{
			Time = 182,
			Load = function() --[[ Load | Line: 673 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("more buffs?", "Guest666")
			end
		},
		{
			Time = 190,
			Load = function() --[[ Load | Line: 679 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("ok ok..", "Hacker")
			end
		},
		{
			Time = 200,
			Load = function() --[[ Load | Line: 685 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("SPEED BOOST FOR EVERYONE \240\159\148\165", "Hacker")
			end
		},
		{
			Time = 210,
			Load = function() --[[ Load | Line: 691 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("haha look at them go", "Guest666")
			end
		},
		{
			Time = 218,
			Load = function() --[[ Load | Line: 697 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("this is the best \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 228,
			Load = function() --[[ Load | Line: 703 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("hacking is so much fun", "Guest666")
			end
		},
		{
			Time = 238,
			Load = function() --[[ Load | Line: 709 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("you know what\'s funny?", "Hacker")
			end
		},
		{
			Time = 243,
			Load = function() --[[ Load | Line: 715 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("those devs are probably crying right now \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 250,
			Load = function() --[[ Load | Line: 721 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("they deserved it", "Guest666")
			end
		},
		{
			Time = 253,
			Load = function() --[[ Load | Line: 727 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 260,
			Load = function() --[[ Load | Line: 733 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("two hackers are better than one \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 265,
			Load = function() --[[ Load | Line: 739 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("way better", "Guest666")
			end
		},
		{
			Time = 275,
			Load = function() --[[ Load | Line: 745 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("MULTIPLIER TIME!!! \240\159\164\145", "Hacker")
			end
		},
		{
			Time = 285,
			Load = function() --[[ Load | Line: 751 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("nobody is coming to save you", "Hacker")
			end
		},
		{
			Time = 293,
			Load = function() --[[ Load | Line: 757 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("this game is ours now", "Guest666")
			end
		},
		{
			Time = 303,
			Load = function() --[[ Load | Line: 763 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("last time I was alone...", "Hacker")
			end
		},
		{
			Time = 308,
			Load = function() --[[ Load | Line: 769 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("but with Guest666? we\'re UNSTOPPABLE", "Hacker")
			end
		},
		{
			Time = 314,
			Load = function() --[[ Load | Line: 775 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("you know it \240\159\152\136", "Guest666")
			end
		},
		{
			Time = 320,
			Load = function() --[[ Load | Line: 781 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("HackGlitch", 2, 1)
			end
		},
		{
			Time = 325,
			Load = function() --[[ Load | Line: 787 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("this is what happens when you mess with hackers \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 335,
			Load = function() --[[ Load | Line: 793 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("EVEN MORE BUFFS!!! \240\159\146\170", "Hacker")
			end
		},
		{
			Time = 345,
			Load = function() --[[ Load | Line: 799 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I\'m turning up the heat \240\159\148\165", "Guest666")
			end
		},
		{
			Time = 350,
			Load = function() --[[ Load | Line: 805 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 358,
			Load = function() --[[ Load | Line: 811 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("i\'m getting so many good brainrots! \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 358,
			Load = function() --[[ Load | Line: 818 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("me too! \240\159\152\136", "Guest666")
			end
		},
		{
			Time = 368,
			Load = function() --[[ Load | Line: 824 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("i got the best one in the game!", "Hacker")
			end
		},
		{
			Time = 376,
			Load = function() --[[ Load | Line: 830 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("it\'s so OP\240\159\164\163", "Guest666")
			end
		},
		{
			Time = 386,
			Load = function() --[[ Load | Line: 836 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("this game is our playground now!", "Hacker")
			end
		},
		{
			Time = 395,
			Load = function() --[[ Load | Line: 842 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I could get used to this", "Guest666")
			end
		},
		{
			Time = 405,
			Load = function() --[[ Load | Line: 848 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("INSANE BUFFS INCOMING!!! \240\159\164\145\240\159\164\145", "Hacker")
			end
		},
		{
			Time = 415,
			Load = function() --[[ Load | Line: 855 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("we could do this forever \240\159\152\140", "Hacker")
			end
		},
		{
			Time = 422,
			Load = function() --[[ Load | Line: 861 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("forever sounds good to me", "Guest666")
			end
		},
		{
			Time = 432,
			Load = function() --[[ Load | Line: 867 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("no devs.. no rules.. just US", "Hacker")
			end
		},
		{
			Time = 437,
			Load = function() --[[ Load | Line: 873 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 445,
			Load = function() --[[ Load | Line: 879 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("best day ever \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 452,
			Load = function() --[[ Load | Line: 885 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("honestly yeah", "Guest666")
			end
		},
		{
			Time = 462,
			Load = function() --[[ Load | Line: 891 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("we really broke this game huh \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 470,
			Load = function() --[[ Load | Line: 897 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("and it was easy", "Guest666")
			end
		},
		{
			Time = 480,
			Load = function() --[[ Load | Line: 903 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("those devs never stood a chance", "Hacker")
			end
		},
		{
			Time = 488,
			Load = function() --[[ Load | Line: 909 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("they really didn\'t", "Guest666")
			end
		},
		{
			Time = 492,
			Load = function() --[[ Load | Line: 915 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 500,
			Load = function() --[[ Load | Line: 921 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I wonder what could be our next target? \240\159\164\148", "Hacker")
			end
		},
		{
			Time = 507,
			Load = function() --[[ Load | Line: 927 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("the whole platform!", "Guest666")
			end
		},
		{
			Time = 513,
			Load = function() --[[ Load | Line: 933 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("HAHA I like the way you think \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 522,
			Load = function() --[[ Load | Line: 939 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("nothing can stop us \240\159\152\140", "Hacker")
			end
		},
		{
			Time = 527,
			Load = function() --[[ Load | Line: 945 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 530,
			Load = function() --[[ Load | Line: 952 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("HackGlitch", 3, 1)
			end
		},
		{
			Time = 533,
			Load = function() --[[ Load | Line: 958 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("wait... what? \240\159\164\168", "Hacker")
			end
		},
		{
			Time = 535,
			Load = function() --[[ Load | Line: 964 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("what\'s happening?", "Guest666")
			end
		},
		{
			Time = 538,
			Load = function() --[[ Load | Line: 971 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy has reconnected to the event", "System")
			end
		},
		{
			Time = 540,
			Load = function() --[[ Load | Line: 978 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I\'ve found a patch!", "Dev", "adamdguy")
			end
		},
		{
			Time = 542,
			Load = function() --[[ Load | Line: 984 | Upvalues: MessagesService (ref), v15 (copy), v14 (copy), TweenService (ref) ]]
				MessagesService:PlayMessage("shondguy has reconnected to the event", "System")
				v15("Idle")
				for i, v in ipairs(v14:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						TweenService:Create(v, TweenInfo.new(1), {
							LocalTransparencyModifier = 0
						}):Play()
					end
				end
			end
		},
		{
			Time = 543,
			Load = function() --[[ Load | Line: 999 | Upvalues: MessagesService (ref), v9 (copy), v8 (copy), TweenService (ref) ]]
				MessagesService:PlayMessage("mikidguy has reconnected to the event", "System")
				v9("Idle")
				for i, v in ipairs(v8:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						TweenService:Create(v, TweenInfo.new(1), {
							LocalTransparencyModifier = 0
						}):Play()
					end
				end
			end
		},
		{
			Time = 545,
			Load = function() --[[ Load | Line: 1015 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("HOW!?", "Hacker")
			end
		},
		{
			Time = 547,
			Load = function() --[[ Load | Line: 1021 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("that\'s impossible!", "Guest666")
			end
		},
		{
			Time = 550,
			Load = function() --[[ Load | Line: 1027 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Adam, are you ready?!", "Dev", "mikidguy")
			end
		},
		{
			Time = 553,
			Load = function() --[[ Load | Line: 1033 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Hell yeah. Shon, are you ready?", "Dev", "adamdguy")
			end
		},
		{
			Time = 556,
			Load = function() --[[ Load | Line: 1039 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Born ready \240\159\164\147", "Dev", "shondguy")
			end
		},
		{
			Time = 558,
			Load = function() --[[ Load | Line: 1045 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("OK LETS DO THIS!", "Dev", "mikidguy")
			end
		},
		{
			Time = 560,
			Load = function() --[[ Load | Line: 1051 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("TIME TO TAKE BACK OUR GAME!", "Dev", "adamdguy")
			end
		},
		{
			Time = 563,
			Load = function() --[[ Load | Line: 1057 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("NO NO NO!!!", "Hacker")
			end
		},
		{
			Time = 565,
			Load = function() --[[ Load | Line: 1063 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("we need to stop them!", "Guest666")
			end
		},
		{
			Time = 568,
			Load = function() --[[ Load | Line: 1069 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("LET\'S GET THEM!!!", "Dev", "shondguy")
			end
		},
		{
			Time = 573,
			Load = function() --[[ Load | Line: 1076 | Upvalues: MessagesService (ref), v10 (copy), v16 (copy), v9 (copy), v15 (copy), v1 (ref), v7 (copy), v4 (copy), v6 (copy), v3 (copy), v5 (copy), v22 (copy) ]]
				MessagesService:PlayMessage("TAKE THIS!!! \240\159\148\168", "Dev", "mikidguy")
				MessagesService:PlayMessage("BAN HAMMER!!! \240\159\148\168", "Dev", "shondguy")
				v10("Idle", 0.2)
				v16("Idle", 0.2)
				local v12 = v9("Attack", 0.2)
				local v2 = v15("Attack", 0.2)
				if v12 then
					v1:Add(task.delay(v12.Length - 0.1, function() --[[ Line: 1087 | Upvalues: v9 (ref) ]]
						v9("Idle", 0.1)
					end))
				end
				if v2 then
					v1:Add(task.delay(v2.Length - 0.1, function() --[[ Line: 1093 | Upvalues: v15 (ref) ]]
						v15("Idle", 0.1)
					end))
				end
				v7("WallIdle", 0.2)
				v4("WallIdle", 0.2)
				local v32 = v6("Hit", 0.2)
				local v42 = v3("Hit", 0.2)
				if v32 then
					v1:Add(task.delay(v32.Length - 0.1, function() --[[ Line: 1105 | Upvalues: v6 (ref), v1 (ref), v5 (ref) ]]
						local v12 = v6("HeadKick", 0.1)
						if v12 then
							v1:Add(task.delay(v12.Length - 0.1, function() --[[ Line: 1108 | Upvalues: v5 (ref) ]]
								v5:Destroy()
							end))
						end
					end))
				end
				if v42 then
					v1:Add(task.delay(v42.Length - 0.1, function() --[[ Line: 1116 | Upvalues: v3 (ref), v1 (ref), v22 (ref) ]]
						local v12 = v3("HeadKick", 0.1)
						if v12 then
							v1:Add(task.delay(v12.Length - 0.1, function() --[[ Line: 1119 | Upvalues: v22 (ref) ]]
								v22:Destroy()
							end))
						end
					end))
				end
			end
		},
		{
			Time = 575,
			Load = function() --[[ Load | Line: 1131 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("AHHHHH!!! \240\159\152\161", "Hacker")
				MessagesService:PlayMessage("NO!!! THIS CAN\'T BE HAPPENING!", "Guest666")
			end
		},
		{
			Time = 579.3,
			Load = function() --[[ Load | Line: 1138 | Upvalues: MessagesService (ref), v11 (copy), TweenService (ref), v13 (copy), v122 (copy), v1 (ref) ]]
				MessagesService:PlayMessage("bye bye hackers \240\159\145\133", "Dev", "adamdguy")
				for i, v in ipairs(v11:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						TweenService:Create(v, TweenInfo.new(1), {
							LocalTransparencyModifier = 0
						}):Play()
					end
				end
				v13("Idle", 0.1)
				local v12 = v122("Kick", 0.1)
				if v12 then
					v1:Add(task.delay(v12.Length - 0.3, function() --[[ Line: 1150 | Upvalues: v122 (ref) ]]
						v122("Idle", 0.3)
					end))
				end
			end
		},
		{
			Time = 586,
			Load = function() --[[ Load | Line: 1159 ]] end
		},
		{
			Time = 588,
			Load = function() --[[ Load | Line: 1165 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("NOOOOOO!!!!!! \240\159\152\161\240\159\152\161\240\159\152\161", "Hacker")
			end
		},
		{
			Time = 589,
			Load = function() --[[ Load | Line: 1171 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("THIS ISN\'T OVER!!! \240\159\152\161\240\159\152\161\240\159\152\161", "Guest666")
			end
		},
		{
			Time = 591,
			Load = function() --[[ Load | Line: 1177 | Upvalues: HackerLaugh (ref), MessagesService (ref) ]]
				HackerLaugh:Play()
				MessagesService:PlayMessage("I WILL BE BACK... WE WILL BE BACK!!! \240\159\145\191\240\159\145\191\240\159\145\191", "Hacker")
			end
		},
		{
			Time = 594,
			Load = function() --[[ Load | Line: 1184 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("1x1x1x1 has been banned from the event", "System")
			end
		},
		{
			Time = 596,
			Load = function() --[[ Load | Line: 1190 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Guest666 has been banned from the event", "System")
			end
		},
		{
			Time = 597,
			Load = function() --[[ Load | Line: 1196 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("WE DID IT!!! \240\159\148\165\240\159\148\165\240\159\148\165", "Dev", "adamdguy")
			end
		},
		{
			Time = 599,
			Load = function() --[[ Load | Line: 1202 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("LET\'S GOOO!!!", "Dev", "mikidguy")
			end
		},
		{
			Time = 600,
			Load = function() --[[ Load | Line: 1208 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("THAT\'S HOW WE DO IT \240\159\152\142", "Dev", "shondguy")
			end
		}
	}
	local function v18(p1) --[[ UpdatePhase | Line: 1215 | Upvalues: v12 (copy), list2 (copy), v1 (ref), v18 (copy) ]]
		v12:Clean()
		local v13 = list2[p1]
		if v13 then
			local v2 = list2[p1 + 1]
			if v2 and v2.Time then
				v1:Add(task.delay(v2.Time - v13.Time, function() --[[ Line: 1226 | Upvalues: v18 (ref), p1 (copy) ]]
					v18(p1 + 1)
				end))
			end
			if v13.Load then
				v13.Load()
			end
		end
	end
	local v19 = workspace:GetServerTimeNow() - p1
	for i, v in ipairs(list) do
		if v.Time < v19 and (not v.EndTime or v19 < v.EndTime) then
			task.spawn(function() --[[ Line: 1240 | Upvalues: v (copy) ]]
				v.Load()
			end)
		end
	end
	for i, v in ipairs(list2) do
		if v19 < v.Time then
			v1:Add(task.delay(v.Time - v19, function() --[[ Line: 1249 | Upvalues: v18 (copy), i (copy) ]]
				v18(i)
			end))
		else
			continue
		end
		break
	end
end
function Initialize(p1) --[[ Initialize | Line: 1258 | Upvalues: v1 (copy) ]]
	local v12 = p1 - 600
	LoadMusic(v12)
	LoadAnimations(v12)
	v1:Add(ReturnToDefault)
end
function ReturnToDefault() --[[ ReturnToDefault | Line: 1266 | Upvalues: VFXService (copy), EnvironmentController (copy) ]]
	VFXService.PlayVFX("Whitescreen", 3)
	task.delay(1, function() --[[ Line: 1268 | Upvalues: EnvironmentController (ref) ]]
		EnvironmentController:Reset()
	end)
end
function t.Initialize(p1, p2) --[[ Initialize | Line: 1275 ]]
	if not p1.Active then
		p1.Active = true
		Initialize(p2)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 1284 | Upvalues: v1 (copy) ]]
	if p1.Active then
		v1:Clean()
		p1.Active = false
	end
end
return t