-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WeatherService_Client = require(ReplicatedStorage.Modules.ServicesLoader.WeatherService_Client)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local LocalPlayer = game:GetService("Players").LocalPlayer
local t = {}
local t2 = {
	None = {
		{
			min = 0,
			text = "Bad"
		},
		{
			min = 0.2,
			text = "Mid"
		},
		{
			min = 0.4,
			text = "Good"
		},
		{
			min = 0.6,
			text = "Great"
		},
		{
			min = 0.8,
			text = "Excellent"
		},
		{
			min = 0.97,
			text = "Perfect"
		}
	},
	Stadium = {
		{
			min = 0,
			text = "Bad"
		},
		{
			min = 0.164,
			text = "Mid"
		},
		{
			min = 0.325,
			text = "Good"
		},
		{
			min = 0.492,
			text = "Great"
		},
		{
			min = 0.66,
			text = "Excellent"
		},
		{
			min = 0.824,
			text = "Perfect"
		},
		{
			min = 0.95,
			text = "Cosmic"
		}
	}
}
t.Length = {
	Default = 3.6,
	Perfect = 2.51
}
t.CustomKicks = {
	Default = {
		AnimName = "KickAnim",
		Offset = CFrame.new(0, -2, -2.7) * CFrame.Angles(0, -1.5707963267948966, 0),
		Func = function() --[[ Func | Line: 45 ]]
			return function() --[[ Line: 47 ]] end
		end
	},
	Perfect = {
		AnimName = "PerfectKick",
		Offset = CFrame.new(0, 3.3, -0.5),
		Func = function(p1) --[[ Func | Line: 56 | Upvalues: LocalPlayer (copy), VFXService (copy), ReplicatedStorage (copy), SoundService (copy) ]]
			local Character = LocalPlayer.Character
			if Character then
				VFXService.PlayVFX("EmitVFX", Character.PrimaryPart, ReplicatedStorage.Objects.VFX.PerfectKick)
			end
			return p1:GetMarkerReachedSignal("Sound"):Connect(function(p1) --[[ Line: 64 | Upvalues: SoundService (ref) ]]
				if SoundService.Effects.Kicking:FindFirstChild(p1) then
					SoundService.Effects.Kicking[p1]:Play()
				end
			end)
		end
	},
	Cosmic = {
		AnimName = "PerfectKick",
		Offset = CFrame.new(0, 3.3, -0.5),
		Func = function(p1) --[[ Func | Line: 77 | Upvalues: LocalPlayer (copy), VFXService (copy), ReplicatedStorage (copy), SoundService (copy) ]]
			local Character = LocalPlayer.Character
			if Character then
				VFXService.PlayVFX("EmitVFX", Character.PrimaryPart, ReplicatedStorage.Objects.VFX.CosmicKick)
			end
			return p1:GetMarkerReachedSignal("Sound"):Connect(function(p1) --[[ Line: 85 | Upvalues: SoundService (ref) ]]
				if SoundService.Effects.Kicking:FindFirstChild(p1) then
					SoundService.Effects.Kicking[p1]:Play()
				end
			end)
		end
	}
}
function t.GetKickFromScale(p1, p2) --[[ GetKickFromScale | Line: 95 | Upvalues: WeatherService_Client (copy), t2 (copy) ]]
	local v3 = 0
	local v4 = nil
	for i, v in ipairs(WeatherService_Client.Events.Stadium and WeatherService_Client.Events.Stadium > workspace:GetServerTimeNow() and t2.Stadium or t2.None) do
		if v.min <= p2 and v3 <= v.min then
			v3 = v.min
			v4 = v.text
		end
	end
	return v4 or "Excellent"
end
return t