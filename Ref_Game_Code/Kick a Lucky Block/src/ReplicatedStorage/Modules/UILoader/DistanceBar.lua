-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
require(ReplicatedStorage.Modules.ControllerLoader.KickController)
require(ReplicatedStorage.Shared.Packages.Trove)
local RarityData = require(ReplicatedStorage.Shared.Data.RarityData)
local KickData = require(ReplicatedStorage.Shared.Data.KickData)
require(ReplicatedStorage.Shared.Packages.FSM)
local LocalPlayer = game:GetService("Players").LocalPlayer
local DistanceBar = LocalPlayer.PlayerGui:WaitForChild("HUD").TopBar.DistanceBar
local t = {}
local t2 = {
	"Common",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Godly",
	"Secret",
	"Rainbow",
	"Hacked",
	"Demon",
	"Celestial",
	"End"
}
local t3 = {
	Common = {
		Start = 24,
		UI = 0,
		Luck = {
			Min = 1,
			Max = 3
		}
	},
	Rare = {
		Start = 131,
		UI = 0.073,
		Luck = {
			Min = 5,
			Max = 8
		}
	},
	Epic = {
		Start = 301,
		UI = 0.153,
		Luck = {
			Min = 10,
			Max = 13
		}
	},
	Legendary = {
		Start = 541,
		UI = 0.236,
		Luck = {
			Min = 15,
			Max = 20
		}
	},
	Mythic = {
		Start = 816,
		UI = 0.322,
		Luck = {
			Min = 25,
			Max = 30
		}
	},
	Godly = {
		Start = 1136,
		UI = 0.409,
		Luck = {
			Min = 50,
			Max = 60
		}
	},
	Secret = {
		Start = 1483,
		UI = 0.502,
		Luck = {
			Min = 75,
			Max = 80
		}
	},
	Rainbow = {
		Start = 1862,
		UI = 0.599,
		Luck = {
			Min = 100,
			Max = 125
		}
	},
	Hacked = {
		Start = 2297,
		UI = 0.694,
		Luck = {
			Min = 250,
			Max = 300
		}
	},
	Demon = {
		Start = 2777,
		UI = 0.793,
		Luck = {
			Min = 500,
			Max = 1000
		}
	},
	Celestial = {
		Start = 3230,
		UI = 0.894,
		Luck = {
			Min = 1500,
			Max = 3000
		}
	},
	End = {
		UI = 1,
		Start = KickData.MAX_DISTANCE
	}
}
function InitProfile() --[[ InitProfile | Line: 128 | Upvalues: Players (copy), LocalPlayer (copy), DistanceBar (copy) ]]
	local v1, v2 = pcall(function() --[[ Line: 129 | Upvalues: Players (ref), LocalPlayer (ref) ]]
		return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
	end)
	if v1 then
		DistanceBar.Player.Image = v2
	end
end
function UpdateBar(p1, p2) --[[ UpdateBar | Line: 138 | Upvalues: t2 (copy), t3 (copy), DistanceBar (copy) ]]
	local v1 = table.find(t2, p1)
	if v1 then
		local v2 = t3[p1]
		local v3 = t3[t2[v1 + 1]]
		if v3 then
			local Start = v2.Start
			local v5 = math.clamp((p2 - Start) / (v3.Start - Start), 0, 1)
			DistanceBar.Player.Position = UDim2.fromScale(math.lerp(v2.UI, v3.UI, v5), 0.5)
			local Luck = v2.Luck
			DistanceBar.Player.Label.Text = ("Luck: %*x"):format((string.format("%.2f", (math.lerp(Luck.Min, Luck.Max, v5)))))
		end
	end
end
function t.Enable(p1, p2) --[[ Enable | Line: 163 | Upvalues: DistanceBar (copy), RunService (copy), RarityData (copy), TweenService (copy) ]]
	if p2 and not p1.Started then
		p1.Started = true
		DistanceBar.Visible = true
		local KickReady = workspace.Areas.KickReady
		local v1 = "Common"
		p1.Con = RunService.PreRender:Connect(function() --[[ Line: 178 | Upvalues: KickReady (copy), p2 (copy), RarityData (ref), v1 (ref), DistanceBar (ref), TweenService (ref) ]]
			local Z = KickReady.CFrame:ToObjectSpace(p2.CFrame).Z
			local v12 = math.abs(Z)
			local v2 = RarityData:GetRarityByDistance(v12)
			UpdateBar(v2, v12)
			if v2 ~= v1 then
				v1 = v2
				DistanceBar.Player.UIScale.Scale = 1
				TweenService:Create(DistanceBar.Player.UIScale, TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut, 0, true), {
					Scale = 1.2
				}):Play()
			end
		end)
	end
end
function t.Disable(p1) --[[ Disable | Line: 191 | Upvalues: DistanceBar (copy) ]]
	if p1.Started then
		p1.Started = false
		if p1.Con then
			p1.Con:Disconnect()
		end
		DistanceBar.Visible = false
	end
end
function t._init(p1) --[[ _init | Line: 206 ]]
	task.spawn(InitProfile)
end
return t