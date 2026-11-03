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
local VirusMachineHandler = require(ReplicatedStorage.Modules.HandlerLoader.VirusMachineHandler)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local MusicController = require(ReplicatedStorage.Modules.ControllerLoader.MusicController)
local EnvironmentController = require(ReplicatedStorage.Modules.ControllerLoader.EnvironmentController)
local HackedBar = require(ReplicatedStorage.Modules.UILoader.HackedBar)
local v1 = Trove.new()
local LocalPlayer = Players.LocalPlayer
local HackerLaugh = SoundService.Effects.HackerLaugh
local OrangePortal = script.Assets.OrangePortal
local v2 = CFrame.new(668.768, 85, 317.2) * CFrame.Angles(0, 0, 0)
local v3 = CFrame.new(627.765, 32.018, 230.694) * CFrame.Angles(0, -1.5707963267948966, 0)
local t = {
	Active = false
}
function LoadMusic(p1) --[[ LoadMusic | Line: 38 | Upvalues: MusicController (copy), v1 (copy) ]]
	local v12, v2 = MusicController:StartCustom()
	v1:Add(v2)
	local t = {
		{
			Time = 35
		},
		{
			Mute = true,
			Time = 43
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
			Mute = true,
			Time = 49.073
		},
		{
			Time = 87.667,
			Song = script.Assets.Sounds.Fourth
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
		p1:PivotTo(p2)
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
function LoadAnimations(p1) --[[ LoadAnimations | Line: 222 | Upvalues: v1 (copy), MessagesService (copy), HackedBar (copy), VirusMachineHandler (copy), EnvironmentController (copy), OrangePortal (copy), v2 (copy), VFXService (copy), HackerLaugh (copy) ]]
	local v12 = v1:Extend()
	local v22, v3, v4 = LoadModel("Hacker")
	local v5 = nil
	local function HackerSay(p1, p2) --[[ HackerSay | Line: 228 | Upvalues: v3 (copy), MessagesService (ref) ]]
		if not p2 then
			v3("Talk")
		end
		MessagesService:PlayMessage(p1, "Hacker")
	end
	local list = {
		{
			Time = 43,
			Load = function() --[[ Load | Line: 238 | Upvalues: p1 (copy), HackedBar (ref) ]]
				local v1 = workspace:GetServerTimeNow() - p1
				for i, v in ipairs({
					{
						showTime = 43,
						hideTime = 72,
						text = "System Override",
						target = 99,
						duration = 26
					},
					{
						showTime = 78,
						hideTime = 88,
						text = "System Override",
						target = 100,
						duration = 3
					},
					{
						showTime = 172,
						hideTime = 180,
						text = "Anti-Virus System",
						target = 84,
						duration = 7
					},
					{
						showTime = 326,
						hideTime = 333,
						text = "Deploying Patch",
						target = 45,
						duration = 5
					},
					{
						showTime = 482,
						hideTime = 491,
						text = "Firewall v2",
						target = 67,
						duration = 8
					},
					{
						showTime = 620,
						hideTime = 695,
						text = "Super Anti-Virus",
						target = 100,
						duration = 65
					}
				}) do
					if v.showTime <= v1 and v1 < v.hideTime then
						HackedBar:Show(v.text, true)
						HackedBar:SetTarget(v.target, (math.max(v.duration - (v1 - v.showTime), 0.1)))
						return
					end
				end
			end
		},
		{
			Time = 90,
			Load = function() --[[ Load | Line: 264 | Upvalues: v3 (copy), v22 (copy), VirusMachineHandler (ref), EnvironmentController (ref) ]]
				v3("Idle")
				for i, v in ipairs(v22:GetDescendants()) do
					if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
						v.LocalTransparencyModifier = 0
					end
				end
				VirusMachineHandler:Spawn()
				EnvironmentController:ChangeEnvironment("Virus")
			end
		},
		{
			Time = 672,
			Load = function() --[[ Load | Line: 277 | Upvalues: OrangePortal (ref), v2 (ref), v5 (ref), v1 (ref) ]]
				local v12 = OrangePortal:Clone()
				SpawnPortal(v12, v2, true)
				v5 = v12
				v1:Add(v12)
			end
		},
		{
			Time = 678,
			Load = function() --[[ Load | Line: 286 | Upvalues: p1 (copy), v4 (copy), v3 (copy), v1 (ref), v22 (copy) ]]
				local v12 = workspace:GetServerTimeNow() - p1
				if not (v12 <= 0) then
					v4("Idle")
					v4("Talk")
					local v2 = v3("PortalAnim", 0.2)
					if v2 then
						local Length = v2.Length
						v2.TimePosition = math.max(v12 - 678, 0)
						v2:AdjustSpeed(1)
						v1:Add(v2.Ended:Once(function() --[[ Line: 301 | Upvalues: v22 (ref) ]]
							v22:Destroy()
						end))
					end
				end
			end
		}
	}
	local list2 = {
		{
			Time = 1,
			Load = function() --[[ Load | Line: 312 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("that was fun!", "Dev", "shondguy")
			end
		},
		{
			Time = 5,
			Load = function() --[[ Load | Line: 318 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("so excited about this event \240\159\152\129", "Dev", "adamdguy")
			end
		},
		{
			Time = 9,
			Load = function() --[[ Load | Line: 324 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("Yeah!", "Dev", "mikidguy")
			end
		},
		{
			Time = 11,
			Load = function() --[[ Load | Line: 330 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("HackGlitch", 2, 1)
			end
		},
		{
			Time = 15,
			Load = function() --[[ Load | Line: 336 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("what was that?", "Dev", "shondguy")
			end
		},
		{
			Time = 17,
			Load = function() --[[ Load | Line: 342 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("\240\159\152\179", "Dev", "adamdguy")
			end
		},
		{
			Time = 18,
			Load = function() --[[ Load | Line: 348 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("that was weird!", "Dev", "mikidguy")
			end
		},
		{
			Time = 22,
			Load = function() --[[ Load | Line: 354 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("anyways.. let\'s run VOID event!", "Dev", "adamdguy")
			end
		},
		{
			Time = 24,
			Load = function() --[[ Load | Line: 360 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("VOID EVENT FAILED", "Error")
			end
		},
		{
			Time = 27,
			Load = function() --[[ Load | Line: 367 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("dude", "Dev", "adamdguy")
			end
		},
		{
			Time = 30,
			Load = function() --[[ Load | Line: 374 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("HackGlitch", 4, 1)
			end
		},
		{
			Time = 32,
			Load = function() --[[ Load | Line: 381 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("what\'s going on?", "Dev", "shondguy")
			end
		},
		{
			Time = 35,
			Load = function() --[[ Load | Line: 388 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("SYSTEM ERROR", "Error")
			end
		},
		{
			Time = 38,
			Load = function() --[[ Load | Line: 395 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("what happened to the music?", "Dev", "adamdguy")
			end
		},
		{
			Time = 40,
			Load = function() --[[ Load | Line: 402 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I think it\'s a virus \240\159\152\168", "Dev", "mikidguy")
			end
		},
		{
			Time = 43,
			Load = function() --[[ Load | Line: 409 | Upvalues: HackedBar (ref) ]]
				HackedBar:Show("System Override", true)
				HackedBar:SetTarget(99, 26)
			end
		},
		{
			Time = 46,
			Load = function() --[[ Load | Line: 418 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("IT IS \240\159\152\168\240\159\152\168", "Dev", "adamdguy")
			end
		},
		{
			Time = 48,
			Load = function() --[[ Load | Line: 425 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("MIKI!", "Dev", "shondguy")
			end
		},
		{
			Time = 50,
			Load = function() --[[ Load | Line: 432 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I\'m on it!!!", "Dev", "mikidguy")
			end
		},
		{
			Time = 53,
			Load = function() --[[ Load | Line: 439 ]] end
		},
		{
			Time = 54,
			Load = function() --[[ Load | Line: 446 | Upvalues: MessagesService (ref), VFXService (ref) ]]
				MessagesService:PlayMessage("what is that!?", "Dev", "adamdguy")
				VFXService.PlayVFX("HackGlitch", 2, 1)
			end
		},
		{
			Time = 57,
			Load = function() --[[ Load | Line: 454 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 60,
			Load = function() --[[ Load | Line: 462 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("WE\'RE BEING HACKED", "Dev", "shondguy")
			end
		},
		{
			Time = 62,
			Load = function() --[[ Load | Line: 469 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("MIKI!!!!", "Dev", "adamdguy")
			end
		},
		{
			Time = 65,
			Load = function() --[[ Load | Line: 476 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("HOLD ON", "Dev", "mikidguy")
			end
		},
		{
			Time = 68,
			Load = function() --[[ Load | Line: 483 ]] end
		},
		{
			Time = 69,
			Load = function() --[[ Load | Line: 490 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I GOT IT!", "Dev", "mikidguy")
			end
		},
		{
			Time = 72,
			Load = function() --[[ Load | Line: 504 | Upvalues: HackedBar (ref) ]]
				HackedBar:Hide()
			end
		},
		{
			Time = 73,
			Load = function() --[[ Load | Line: 511 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("thank god \240\159\152\174\226\128\141\240\159\146\168", "Dev", "adamdguy")
			end
		},
		{
			Time = 74,
			Load = function() --[[ Load | Line: 518 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("phewwwww", "Dev", "shondguy")
			end
		},
		{
			Time = 75,
			Load = function() --[[ Load | Line: 525 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("glad to be at your service \240\159\152\137", "Dev", "mikidguy")
			end
		},
		{
			Time = 78,
			Load = function() --[[ Load | Line: 532 | Upvalues: HackedBar (ref) ]]
				HackedBar:Show("System Override", true)
				HackedBar:SetTarget(100, 3)
			end
		},
		{
			Time = 80,
			Load = function() --[[ Load | Line: 540 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("GUYS!!!", "Dev", "adamdguy")
			end
		},
		{
			Time = 81,
			Load = function() --[[ Load | Line: 547 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy was kicked from the event", "System")
			end
		},
		{
			Time = 82,
			Load = function() --[[ Load | Line: 554 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("NOOOOO", "Dev", "shondguy")
			end
		},
		{
			Time = 83,
			Load = function() --[[ Load | Line: 561 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy was kicked from the event", "System")
			end
		},
		{
			Time = 85,
			Load = function() --[[ Load | Line: 568 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("WHAT\'S GOING ON!?", "Dev", "mikidguy")
			end
		},
		{
			Time = 86,
			Load = function() --[[ Load | Line: 575 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy was kicked from the event", "System")
			end
		},
		{
			Time = 88,
			Load = function() --[[ Load | Line: 582 | Upvalues: HackerLaugh (ref), HackedBar (ref) ]]
				HackerLaugh:Play()
				HackedBar:Hide()
			end
		},
		{
			Time = 90,
			Load = function() --[[ Load | Line: 590 | Upvalues: v3 (copy), VFXService (ref), v22 (copy), VirusMachineHandler (ref), EnvironmentController (ref) ]]
				v3("Idle")
				VFXService.PlayVFX("EmitVFX", v22.Torso, script.Assets.VFXPart)
				task.delay(0.2, function() --[[ Line: 595 | Upvalues: v22 (ref), VirusMachineHandler (ref), EnvironmentController (ref) ]]
					for i, v in ipairs(v22:GetDescendants()) do
						if v:IsA("Texture") or (v:IsA("Decal") or v:IsA("BasePart")) then
							v.LocalTransparencyModifier = 0
						end
					end
					VirusMachineHandler:Spawn()
					EnvironmentController:ChangeEnvironment("Virus")
				end)
			end
		},
		{
			Time = 93,
			Load = function() --[[ Load | Line: 610 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("welcome to MY HACKER ABUSE!", "Hacker")
			end
		},
		{
			Time = 100,
			Load = function() --[[ Load | Line: 617 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("time to break the game \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 108,
			Load = function() --[[ Load | Line: 624 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("i injected a virus lucky block", "Hacker")
			end
		},
		{
			Time = 112,
			Load = function() --[[ Load | Line: 631 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("it\'s really rare to get!", "Hacker")
			end
		},
		{
			Time = 113,
			Load = function() --[[ Load | Line: 638 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("but it\'s worth it >:D", "Hacker")
			end
		},
		{
			Time = 125,
			Load = function() --[[ Load | Line: 644 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("every block you open makes me STRONGER", "Hacker")
			end
		},
		{
			Time = 140,
			Load = function() --[[ Load | Line: 650 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("you players are so clueless \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 150,
			Load = function() --[[ Load | Line: 656 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("the devs can\'t save you now", "Hacker")
			end
		},
		{
			Time = 165,
			Load = function() --[[ Load | Line: 662 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("wait.. someone is trying to connect \240\159\164\148", "Hacker")
			end
		},
		{
			Time = 167,
			Load = function() --[[ Load | Line: 669 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy has reconnected to the event", "System")
			end
		},
		{
			Time = 168,
			Load = function() --[[ Load | Line: 676 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy has reconnected to the event", "System")
			end
		},
		{
			Time = 169,
			Load = function() --[[ Load | Line: 683 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy has reconnected to the event", "System")
			end
		},
		{
			Time = 172,
			Load = function() --[[ Load | Line: 690 | Upvalues: HackedBar (ref) ]]
				HackedBar:Show("Anti-Virus System", true)
				HackedBar:SetTarget(84, 7)
			end
		},
		{
			Time = 173,
			Load = function() --[[ Load | Line: 698 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I AM TRYING TO BREAK THE HACKER\'S SYSTEM!", "Dev", "mikidguy")
			end
		},
		{
			Time = 176,
			Load = function() --[[ Load | Line: 705 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("keep going!!", "Dev", "adamdguy")
			end
		},
		{
			Time = 180,
			Load = function() --[[ Load | Line: 712 | Upvalues: HackedBar (ref), v3 (copy), MessagesService (ref), HackerLaugh (ref) ]]
				HackedBar:Hide()
				v3("Talk")
				MessagesService:PlayMessage("HAHAHAHAHA", "Hacker")
				HackerLaugh:Play()
			end
		},
		{
			Time = 182,
			Load = function() --[[ Load | Line: 721 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy was kicked from the event", "System")
			end
		},
		{
			Time = 183,
			Load = function() --[[ Load | Line: 727 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy was kicked from the event", "System")
			end
		},
		{
			Time = 184,
			Load = function() --[[ Load | Line: 734 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy was kicked from the event", "System")
			end
		},
		{
			Time = 187,
			Load = function() --[[ Load | Line: 742 | Upvalues: HackerLaugh (ref), v3 (copy), MessagesService (ref) ]]
				HackerLaugh:Play()
				v3("Talk")
				MessagesService:PlayMessage("you can\'t beat me \240\159\164\163", "Hacker")
			end
		},
		{
			Time = 195,
			Load = function() --[[ Load | Line: 750 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("let\'s break this game \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 210,
			Load = function() --[[ Load | Line: 757 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("my virus mutation is so OP \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 220,
			Load = function() --[[ Load | Line: 763 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("it\'s better than \"radioactive\" \240\159\164\147\240\159\164\163", "Hacker")
			end
		},
		{
			Time = 240,
			Load = function() --[[ Load | Line: 769 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("keep playing.. it only gets better from here", "Hacker")
			end
		},
		{
			Time = 255,
			Load = function() --[[ Load | Line: 776 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("TIME TO GET FASTER!!!", "Hacker")
			end
		},
		{
			Time = 270,
			Load = function() --[[ Load | Line: 783 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy has reconnected to the event", "System")
			end
		},
		{
			Time = 273,
			Load = function() --[[ Load | Line: 789 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I\'m back! We can fix this!", "Dev", "adamdguy")
			end
		},
		{
			Time = 277,
			Load = function() --[[ Load | Line: 795 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("you think you can stop me?", "Hacker")
			end
		},
		{
			Time = 280,
			Load = function() --[[ Load | Line: 801 | Upvalues: HackerLaugh (ref), MessagesService (ref) ]]
				HackerLaugh:Play()
				MessagesService:PlayMessage("adamdguy was kicked from the event", "System")
			end
		},
		{
			Time = 284,
			Load = function() --[[ Load | Line: 808 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("I am the BEST hacker! \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 295,
			Load = function() --[[ Load | Line: 815 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy has reconnected to the event", "System")
			end
		},
		{
			Time = 298,
			Load = function() --[[ Load | Line: 821 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("alright let me try something..", "Dev", "shondguy")
			end
		},
		{
			Time = 302,
			Load = function() --[[ Load | Line: 827 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("cute \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 305,
			Load = function() --[[ Load | Line: 833 | Upvalues: HackerLaugh (ref), MessagesService (ref) ]]
				HackerLaugh:Play()
				MessagesService:PlayMessage("shondguy was kicked from the event", "System")
			end
		},
		{
			Time = 309,
			Load = function() --[[ Load | Line: 840 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("NOBODY can beat me!", "Hacker")
			end
		},
		{
			Time = 320,
			Load = function() --[[ Load | Line: 847 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy has reconnected to the event", "System")
			end
		},
		{
			Time = 323,
			Load = function() --[[ Load | Line: 853 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I wrote a patch, deploying now!", "Dev", "mikidguy")
			end
		},
		{
			Time = 326,
			Load = function() --[[ Load | Line: 859 | Upvalues: HackedBar (ref) ]]
				HackedBar:Show("Deploying Patch", true)
				HackedBar:SetTarget(45, 5)
			end
		},
		{
			Time = 333,
			Load = function() --[[ Load | Line: 866 | Upvalues: HackedBar (ref) ]]
				HackedBar:Hide()
			end
		},
		{
			Time = 335,
			Load = function() --[[ Load | Line: 872 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("nice try \240\159\164\161", "Hacker")
			end
		},
		{
			Time = 337,
			Load = function() --[[ Load | Line: 878 | Upvalues: HackerLaugh (ref), MessagesService (ref) ]]
				HackerLaugh:Play()
				MessagesService:PlayMessage("mikidguy was kicked from the event", "System")
			end
		},
		{
			Time = 341,
			Load = function() --[[ Load | Line: 885 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("HAHAHAHA no one can stop me!", "Hacker")
			end
		},
		{
			Time = 348,
			Load = function() --[[ Load | Line: 891 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("this game is MINE now \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 358,
			Load = function() --[[ Load | Line: 898 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy has reconnected to the event", "System")
			end
		},
		{
			Time = 360,
			Load = function() --[[ Load | Line: 905 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("we need to take him down fast!", "Dev", "shondguy")
			end
		},
		{
			Time = 364,
			Load = function() --[[ Load | Line: 911 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("SILENCE", "Hacker")
				MessagesService:PlayMessage("shondguy was kicked from the event", "System")
			end
		},
		{
			Time = 369,
			Load = function() --[[ Load | Line: 919 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("finally some peace and quiet \240\159\152\140", "Hacker")
			end
		},
		{
			Time = 373,
			Load = function() --[[ Load | Line: 926 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("like taking candy from a baby \240\159\141\172", "Hacker")
			end
		},
		{
			Time = 378,
			Load = function() --[[ Load | Line: 933 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("now i can take over this game forever\240\159\152\140", "Hacker")
			end
		},
		{
			Time = 379,
			Load = function() --[[ Load | Line: 939 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 382,
			Load = function() --[[ Load | Line: 946 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("those devs were SO weak \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 390,
			Load = function() --[[ Load | Line: 953 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("no devs.. no rules.. just ME", "Hacker")
			end
		},
		{
			Time = 405,
			Load = function() --[[ Load | Line: 960 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("this game is actually pretty fun \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 420,
			Load = function() --[[ Load | Line: 967 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("anyone got the virus mutation yet?", "Hacker")
			end
		},
		{
			Time = 422,
			Load = function() --[[ Load | Line: 974 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("i made it SUPER OP!", "Hacker")
			end
		},
		{
			Time = 428,
			Load = function() --[[ Load | Line: 981 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("you know what.. you players deserve a gift \240\159\142\129", "Hacker")
			end
		},
		{
			Time = 433,
			Load = function() --[[ Load | Line: 988 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("for being such good little test subjects", "Hacker")
			end
		},
		{
			Time = 437,
			Load = function() --[[ Load | Line: 995 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 440,
			Load = function() --[[ Load | Line: 1002 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("ready for some INSANE multipliers? \240\159\164\145", "Hacker")
			end
		},
		{
			Time = 446,
			Load = function() --[[ Load | Line: 1009 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("here it comes..", "Hacker")
			end
		},
		{
			Time = 450,
			Load = function() --[[ Load | Line: 1016 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("MORE MULTIPLIERS \240\159\164\145", "Hacker")
			end
		},
		{
			Time = 470,
			Load = function() --[[ Load | Line: 1025 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy has reconnected to the event", "System")
			end
		},
		{
			Time = 472,
			Load = function() --[[ Load | Line: 1031 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy has reconnected to the event", "System")
			end
		},
		{
			Time = 475,
			Load = function() --[[ Load | Line: 1037 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("we have a new plan!", "Dev", "adamdguy")
			end
		},
		{
			Time = 479,
			Load = function() --[[ Load | Line: 1043 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("deploying firewall v2!", "Dev", "mikidguy")
			end
		},
		{
			Time = 482,
			Load = function() --[[ Load | Line: 1049 | Upvalues: HackedBar (ref) ]]
				HackedBar:Show("Firewall v2", true)
				HackedBar:SetTarget(67, 8)
			end
		},
		{
			Time = 485,
			Load = function() --[[ Load | Line: 1056 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("oh you\'re back? \240\159\152\130", "Hacker")
			end
		},
		{
			Time = 488,
			Load = function() --[[ Load | Line: 1062 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("it\'s working!! KEEP GOING!", "Dev", "adamdguy")
			end
		},
		{
			Time = 491,
			Load = function() --[[ Load | Line: 1068 | Upvalues: HackedBar (ref) ]]
				HackedBar:Hide()
			end
		},
		{
			Time = 493,
			Load = function() --[[ Load | Line: 1074 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("did you really think that would work? \240\159\164\161", "Hacker")
			end
		},
		{
			Time = 495,
			Load = function() --[[ Load | Line: 1080 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 497,
			Load = function() --[[ Load | Line: 1086 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("NO!!!", "Dev", "mikidguy")
			end
		},
		{
			Time = 500,
			Load = function() --[[ Load | Line: 1092 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy was kicked from the event", "System")
			end
		},
		{
			Time = 502,
			Load = function() --[[ Load | Line: 1098 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy was kicked from the event", "System")
			end
		},
		{
			Time = 505,
			Load = function() --[[ Load | Line: 1104 | Upvalues: HackerLaugh (ref), v3 (copy), MessagesService (ref) ]]
				HackerLaugh:Play()
				v3("Talk")
				MessagesService:PlayMessage("TOO EASY \240\159\152\130\240\159\152\130\240\159\152\130", "Hacker")
			end
		},
		{
			Time = 515,
			Load = function() --[[ Load | Line: 1112 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("alright players.. you\'ve earned this", "Hacker")
			end
		},
		{
			Time = 520,
			Load = function() --[[ Load | Line: 1118 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("time for some CRAZY buffs \240\159\148\165", "Hacker")
			end
		},
		{
			Time = 525,
			Load = function() --[[ Load | Line: 1124 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("BUFF TIME!!! \240\159\146\170", "Hacker")
			end
		},
		{
			Time = 532,
			Load = function() --[[ Load | Line: 1130 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("now you can get even more Virus brainrots \240\159\152\136", "Hacker")
			end
		},
		{
			Time = 545,
			Load = function() --[[ Load | Line: 1136 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("those devs will NEVER come back", "Hacker")
			end
		},
		{
			Time = 555,
			Load = function() --[[ Load | Line: 1142 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("this is my game now.. FOREVER", "Hacker")
			end
		},
		{
			Time = 558,
			Load = function() --[[ Load | Line: 1148 | Upvalues: HackerLaugh (ref) ]]
				HackerLaugh:Play()
			end
		},
		{
			Time = 565,
			Load = function() --[[ Load | Line: 1154 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("nothing can stop me \240\159\152\140", "Hacker")
			end
		},
		{
			Time = 580,
			Load = function() --[[ Load | Line: 1160 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("I wonder what I should hack next..", "Hacker")
			end
		},
		{
			Time = 593,
			Load = function() --[[ Load | Line: 1166 | Upvalues: VFXService (ref) ]]
				VFXService.PlayVFX("HackGlitch", 3, 2)
			end
		},
		{
			Time = 595,
			Load = function() --[[ Load | Line: 1172 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("wait.. what\'s happening? \240\159\164\168", "Hacker")
			end
		},
		{
			Time = 600,
			Load = function() --[[ Load | Line: 1179 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("adamdguy has reconnected to the event", "System")
			end
		},
		{
			Time = 601,
			Load = function() --[[ Load | Line: 1185 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("mikidguy has reconnected to the event", "System")
			end
		},
		{
			Time = 602,
			Load = function() --[[ Load | Line: 1191 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("shondguy has reconnected to the event", "System")
			end
		},
		{
			Time = 605,
			Load = function() --[[ Load | Line: 1197 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("oh great.. ALL of you? \240\159\152\146", "Hacker")
			end
		},
		{
			Time = 608,
			Load = function() --[[ Load | Line: 1203 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I admit... we\'ve lost...", "Dev", "adamdguy")
			end
		},
		{
			Time = 612,
			Load = function() --[[ Load | Line: 1209 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("\240\159\164\163\240\159\164\163\240\159\164\163", "Hacker")
			end
		},
		{
			Time = 614,
			Load = function() --[[ Load | Line: 1215 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("losers \240\159\145\133", "Hacker")
			end
		},
		{
			Time = 616,
			Load = function() --[[ Load | Line: 1221 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("SIKE \240\159\164\163\240\159\164\163", "Dev", "adamdguy")
			end
		},
		{
			Time = 618,
			Load = function() --[[ Load | Line: 1227 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("INJECTING SUPER ANTI-VIRUS!!! \240\159\148\165\240\159\148\165\240\159\148\165", "Dev", "mikidguy")
			end
		},
		{
			Time = 620,
			Load = function() --[[ Load | Line: 1233 | Upvalues: HackedBar (ref) ]]
				HackedBar:Show("Super Anti-Virus", true)
				HackedBar:SetTarget(100, 65)
			end
		},
		{
			Time = 624,
			Load = function() --[[ Load | Line: 1241 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("\240\159\164\163\240\159\164\163\240\159\164\163", "Hacker")
			end
		},
		{
			Time = 627,
			Load = function() --[[ Load | Line: 1248 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("let me stop this once and for all", "Hacker")
			end
		},
		{
			Time = 635,
			Load = function() --[[ Load | Line: 1254 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("wait... I CAN\'T STOP THAT", "Hacker")
			end
		},
		{
			Time = 640,
			Load = function() --[[ Load | Line: 1260 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("\240\159\152\170?", "Dev", "shondguy")
			end
		},
		{
			Time = 648,
			Load = function() --[[ Load | Line: 1266 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("NO NO NO NO NO!!!", "Hacker")
			end
		},
		{
			Time = 654,
			Load = function() --[[ Load | Line: 1273 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("I WON\'T LET YOU WIN!!!", "Hacker")
			end
		},
		{
			Time = 664,
			Load = function() --[[ Load | Line: 1279 | Upvalues: v3 (copy), MessagesService (ref) ]]
				v3("Talk")
				MessagesService:PlayMessage("MY SYSTEM IS.. BREAKING!! \240\159\152\161\240\159\152\161", "Hacker")
			end
		},
		{
			Time = 670,
			Load = function() --[[ Load | Line: 1285 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("I have a surprise for you", "Dev", "shondguy")
			end
		},
		{
			Time = 672,
			Load = function() --[[ Load | Line: 1292 | Upvalues: OrangePortal (ref), v2 (ref), v5 (ref), v1 (ref) ]]
				local v12 = OrangePortal:Clone()
				SpawnPortal(v12, v2, true)
				v5 = v12
				v1:Add(v12)
			end
		},
		{
			Time = 678,
			Load = function() --[[ Load | Line: 1301 | Upvalues: v4 (copy), v3 (copy), v1 (ref), v22 (copy) ]]
				v4("Idle")
				v4("Talk")
				local v12 = v3("PortalAnim", 0.2)
				if v12 then
					v12:AdjustSpeed(1)
					v1:Add(v12.Ended:Once(function() --[[ Line: 1308 | Upvalues: v22 (ref) ]]
						v22:Destroy()
					end))
				end
			end
		},
		{
			Time = 682,
			Load = function() --[[ Load | Line: 1317 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("A PORTAL!?!?", "Hacker")
			end
		},
		{
			Time = 685,
			Load = function() --[[ Load | Line: 1323 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("GOODBYE HACKER!!! \240\159\148\165", "Dev", "mikidguy")
			end
		},
		{
			Time = 691,
			Load = function() --[[ Load | Line: 1330 | Upvalues: MessagesService (ref) ]]
				MessagesService:PlayMessage("NOOOOOOO!!!!!! \240\159\152\161\240\159\152\161\240\159\152\161\240\159\152\161", "Hacker")
			end
		},
		{
			Time = 695,
			Load = function() --[[ Load | Line: 1336 | Upvalues: HackedBar (ref), HackerLaugh (ref), MessagesService (ref) ]]
				HackedBar:Hide()
				HackerLaugh:Play()
				MessagesService:PlayMessage("I WILL BE BACK!!! \240\159\145\191\240\159\145\191\240\159\145\191", "Hacker")
			end
		},
		{
			Time = 698,
			Load = function() --[[ Load | Line: 1344 | Upvalues: v5 (ref), v2 (ref), v1 (ref), MessagesService (ref) ]]
				if v5 then
					v1:Add((SpawnPortal(v5, v2, true, true)))
					v5 = nil
				end
				MessagesService:PlayMessage("1x1x1x1 was kicked from the event", "System")
			end
		}
	}
	local function v6(p1) --[[ UpdatePhase | Line: 1357 | Upvalues: v12 (copy), list2 (copy), v1 (ref), v6 (copy) ]]
		v12:Clean()
		local v13 = list2[p1]
		if v13 then
			local v2 = list2[p1 + 1]
			if v2 and v2.Time then
				v1:Add(task.delay(v2.Time - v13.Time, function() --[[ Line: 1368 | Upvalues: v6 (ref), p1 (copy) ]]
					v6(p1 + 1)
				end))
			end
			if v13.Load then
				v13.Load()
			end
		end
	end
	local v7 = workspace:GetServerTimeNow() - p1
	for i, v in ipairs(list) do
		if v.Time < v7 then
			task.spawn(function() --[[ Line: 1382 | Upvalues: v (copy) ]]
				v.Load()
			end)
		end
	end
	for i, v in ipairs(list2) do
		if v7 < v.Time then
			v1:Add(task.delay(v.Time - v7, function() --[[ Line: 1391 | Upvalues: v6 (copy), i (copy) ]]
				v6(i)
			end))
		else
			continue
		end
		break
	end
end
function Initialize(p1) --[[ Initialize | Line: 1400 | Upvalues: v1 (copy) ]]
	local v12 = p1 - 700
	LoadMusic(v12)
	LoadAnimations(v12)
	v1:Add(ReturnToDefault)
end
function ReturnToDefault() --[[ ReturnToDefault | Line: 1408 | Upvalues: VFXService (copy), EnvironmentController (copy) ]]
	VFXService.PlayVFX("Whitescreen", 3)
	task.delay(1, function() --[[ Line: 1410 | Upvalues: EnvironmentController (ref) ]]
		EnvironmentController:Reset()
	end)
end
function t.Initialize(p1, p2) --[[ Initialize | Line: 1417 ]]
	if not p1.Active then
		p1.Active = true
		Initialize(p2)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 1426 | Upvalues: v1 (copy) ]]
	if p1.Active then
		v1:Clean()
		p1.Active = false
	end
end
return t