-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local SoundService = game:GetService("SoundService")
game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local AreaUtility = require(ReplicatedStorage.Shared.AreaUtility)
require(ReplicatedStorage.Shared.TimeConfiguration)
local v1 = require(ReplicatedStorage.Packages.Loader).LoadDescendants(Lighting.LightingProfiles)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local v2 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local t = {}
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = Trove.new()
local v7 = Trove.new()
local v8 = Trove.new()
local v9 = Trove.new()
local v10 = nil
local v11 = false
local v12 = false
local v13 = nil
local v14 = false
local v15 = nil
local v16 = nil
local function FullReset() --[[ FullReset | Line: 52 | Upvalues: t (copy), v5 (ref), v3 (ref), v4 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref) ]]
	table.clear(t)
	v5 = nil
	v3 = nil
	v4 = nil
	v10 = nil
	v11 = false
	v12 = false
	v13 = nil
	v14 = false
end
local v17 = Lighting:WaitForChild("Sky"):Clone()
local function MergeLightingProfile(p1, p2) --[[ MergeLightingProfile | Line: 68 ]]
	if not p1 then
		return p2
	end
	if not p2 then
		return p1
	end
	local v1 = table.clone(p1)
	for v2, v3 in p2 do
		if typeof(v3) == "table" and typeof(p1[v2]) == "table" then
			local v5 = table.clone(p1[v2])
			for v6, v7 in v3 do
				v5[v6] = v7
			end
			v1[v2] = v5
			continue
		end
		v1[v2] = v3
	end
	return v1
end
local function SkyboxesMatch(p1, p2) --[[ SkyboxesMatch | Line: 93 ]]
	if not p1 then
		return false
	end
	return if p1.CelestialBodiesShown == p2.CelestialBodiesShown and (p1.MoonAngularSize == p2.MoonAngularSize and (p1.MoonTextureId == p2.MoonTextureId and (p1.SkyboxBk == p2.SkyboxBk and (p1.SkyboxDn == p2.SkyboxDn and (p1.SkyboxFt == p2.SkyboxFt and (p1.SkyboxLf == p2.SkyboxLf and (p1.SkyboxRt == p2.SkyboxRt and (p1.SkyboxUp == p2.SkyboxUp and (p1.StarCount == p2.StarCount and p1.SunAngularSize == p2.SunAngularSize))))))))) then p1.SunTextureId == p2.SunTextureId else false
end
local t2 = {
	NightTime = false,
	NightTimeChanged = Signal.new()
}
function t2.Init(p1) --[[ Init | Line: 122 | Upvalues: v2 (ref), Replion (copy), t2 (copy), Lighting (copy), LocalPlayer (copy), v4 (ref), v1 (copy), t (copy), v5 (ref), v3 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), Observers (copy) ]]
	v2 = Replion.Client:WaitReplion("Time")
	v2:OnChange("Time", function(p1) --[[ Line: 125 | Upvalues: t2 (ref), Lighting (ref) ]]
		local v1 = t2:_getLightingProfile()
		if if v1 then v1.ForcedClockTime else nil then
			t2:_updateTextLabels()
			t2:_setNightTime(t2:IsNightTime())
			return
		end
		Lighting.ClockTime = p1
		t2:_updateTextLabels()
		t2:_setNightTime(t2:IsNightTime())
	end)
	workspace:GetAttributeChangedSignal("ClockTime"):Connect(function() --[[ Line: 143 | Upvalues: t2 (ref) ]]
		t2:_updateTextLabels()
		t2:_setNightTime(t2:IsNightTime())
	end)
	local function LocationChanged() --[[ LocationChanged | Line: 151 | Upvalues: LocalPlayer (ref), v4 (ref), t2 (ref), v1 (ref) ]]
		local v12 = LocalPlayer:GetAttribute("LocationName")
		local v2 = if v12 == "Lost Isle" or (v12 == "Sisyphus Statue" or (v12 == "Treasure Hall" or v12 == "Treasure Room")) then "Lost Isle" elseif v12 == "Ancient Ruin" or v12 == "Crystalline Passage" then "Crystalline Passage" else v12
		if v4 and v4 == v2 then
			return
		end
		if v4 then
			t2:RemoveAmbianceOverride(v4)
		end
		v4 = v2
		local v3 = v1[v2]
		if not v3 then
			return
		end
		t2:AddAmbianceOverride(v2, v3.Priority)
	end
	Replion.Client:AwaitReplion("Events", function(p1) --[[ Line: 186 | Upvalues: t (ref), v5 (ref), v3 (ref), v4 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), t2 (ref), LocalPlayer (ref), LocationChanged (copy) ]]
		p1:OnArrayRemove("Events", function(p1, p2) --[[ Line: 190 | Upvalues: t (ref), v5 (ref), v3 (ref), v4 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref) ]]
			if typeof(p2) ~= "string" or not p2:find("Admin") then
				UpdateLighting()
				return
			end
			table.clear(t)
			v5 = nil
			v3 = nil
			v4 = nil
			v10 = nil
			v11 = false
			v12 = false
			v13 = nil
			v14 = false
			UpdateLighting()
		end)
		p1:OnArrayInsert("Events", function(p1, p2) --[[ Line: 198 | Upvalues: t (ref), v5 (ref), v3 (ref), v4 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref) ]]
			if typeof(p2) == "string" and p2:find("Admin") then
				table.clear(t)
				v5 = nil
				v3 = nil
				v4 = nil
				v10 = nil
				v11 = false
				v12 = false
				v13 = nil
				v14 = false
			end
			UpdateLighting()
		end)
		task.defer(UpdateLighting)
		t2:_updateLocationLabels()
		task.delay(2, function() --[[ Line: 211 | Upvalues: LocalPlayer (ref), v4 (ref), LocationChanged (ref) ]]
			if LocalPlayer:GetAttribute("LocationName") == v4 then
				return
			end
			LocationChanged()
		end)
	end)
	LocalPlayer:GetAttributeChangedSignal("LocationName"):Connect(function() --[[ Line: 219 | Upvalues: LocationChanged (copy), t2 (ref) ]]
		LocationChanged()
		t2:_updateLocationLabels()
	end)
	t2.NightTimeChanged:Connect(function() --[[ Line: 224 ]]
		UpdateLighting()
	end)
	Observers.observeCharacter(function(p1, p2) --[[ Line: 229 | Upvalues: LocalPlayer (ref), v5 (ref), t (ref), LocationChanged (copy) ]]
		if p1 == LocalPlayer then
			task.wait(0.5)
			p2:WaitForChild("HumanoidRootPart")
			v5 = nil
			table.clear(t)
			LocationChanged()
		end
	end)
end
function t2.GetLightingProfile(p1) --[[ GetLightingProfile | Line: 246 | Upvalues: v5 (ref), v1 (copy) ]]
	if v5 then
		return v1[v5], p1:IsNightTime()
	else
		return nil, p1:IsNightTime()
	end
end
function t2.IsNightTime(p1) --[[ IsNightTime | Line: 253 ]]
	local v1 = workspace:GetAttribute("ClockTime")
	return if v1 < 7 then true else v1 > 17.783
end
function t2._setNightTime(p1, p2) --[[ _setNightTime | Line: 260 | Upvalues: t2 (copy) ]]
	if p2 ~= t2.NightTime then
		t2.NightTime = p2
		t2.NightTimeChanged:Fire()
	end
end
function t2.RefreshAmbiancePriority(p1) --[[ RefreshAmbiancePriority | Line: 269 | Upvalues: t (copy), v3 (ref) ]]
	if #t > 0 then
		table.sort(t, function(p1, p2) --[[ Line: 271 ]]
			return p1.Priority > p2.Priority
		end)
	end
	local v1 = t[1]
	v3 = if v1 then v1.Name else nil
	UpdateLighting()
end
function t2.RemoveAmbianceOverride(p1, p2) --[[ RemoveAmbianceOverride | Line: 286 | Upvalues: t (copy), v4 (ref), t2 (copy) ]]
	for i, v in ipairs(t) do
		if v.Name == p2 then
			table.remove(t, i)
			break
		end
	end
	v4 = nil
	t2:RefreshAmbiancePriority()
end
function t2.AddAmbianceOverride(p1, p2, p3) --[[ AddAmbianceOverride | Line: 298 | Upvalues: t (copy), t2 (copy) ]]
	for i, v in ipairs(t) do
		if v.Name == p2 then
			return false
		end
	end
	table.insert(t, {
		Name = p2,
		Priority = p3
	})
	t2:RefreshAmbiancePriority()
	return true
end
function t2._updateTextLabels(p1) --[[ _updateTextLabels | Line: 315 | Upvalues: CollectionService (copy) ]]
	local v1 = workspace:GetAttribute("ClockTime")
	local v2 = math.floor(v1)
	local v3 = v1 - math.floor(v1)
	local v5 = ("%02i:%02i %s"):format(math.fmod(v2, 12), math.floor(v3 * 60), if v1 >= 12 then "PM" else "AM")
	for i, v in ipairs((CollectionService:GetTagged("ClockLabel"))) do
		v.Text = v5
	end
end
function t2._updateLocationLabels(p1) --[[ _updateLocationLabels | Line: 329 | Upvalues: LocalPlayer (copy), AreaUtility (copy), CollectionService (copy) ]]
	local v1 = LocalPlayer:GetAttribute("LocationName")
	if not v1 then
		return
	end
	local v2 = AreaUtility:GetArea(v1)
	local v3 = if v2 and (v2.Hidden or v2.ComingSoon) then "???" else v1
	for i, v in ipairs((CollectionService:GetTagged("LocationLabel"))) do
		v.Text = v3
	end
	if LocalPlayer:GetAttribute("Loading") then
		return
	end
	UpdateLocationNotification(v3)
end
function t2._forceUpdateAndOverride(p1, p2) --[[ _forceUpdateAndOverride | Line: 347 | Upvalues: v14 (ref), v11 (ref), v16 (ref), v15 (ref), v1 (copy) ]]
	if p2 then
		v14 = true
		v11 = true
		v16 = p2
		v15 = v1[p2]
		UpdateLighting()
		v14 = false
		v11 = false
	end
end
function t2._removeOverride(p1) --[[ _removeOverride | Line: 360 | Upvalues: v15 (ref), v16 (ref) ]]
	v15 = nil
	v16 = nil
	UpdateLighting()
end
function t2._getLightingProfile(p1) --[[ _getLightingProfile | Line: 366 | Upvalues: v1 (copy), Replion (copy), v3 (ref), LocalPlayer (copy), t2 (copy), MergeLightingProfile (copy) ]]
	if next(v1) == nil then
		return
	end
	local v12 = Replion.Client:GetReplion("Events")
	if v12 then
		if v12:Find("Events", "Admin - 3RR0R 3V3NT") then
			return v1["Admin - 3RR0R 3V3NT"], "Admin - 3RR0R 3V3NT"
		end
		if v12:Find("Events", "Admin - Classic Island") then
			return v1["Fisherman Island"], "Admin - Classic Island"
		end
		if v12:Find("Events", "Admin - Night Celebration") then
			return v1["Admin - Night Celebration"], "Admin - Night Celebration"
		end
		if v12:Find("Events", "Admin - Galaxy Storm") then
			return v1["Admin - Galaxy Storm"], "Admin - Galaxy Storm"
		end
		if v12:Find("Events", "Admin - Bloodmoon") then
			return v1.Bloodmoon, "Bloodmoon"
		end
		if v12:Find("Events", "Admin - Purple Bloodmoon") then
			return v1["Purple Bloodmoon"], "Purple Bloodmoon"
		end
		if v12:Find("Events", "Galaxy") then
			return v1.Galaxy, "Galaxy"
		end
	end
	if v3 == nil then
		v3 = LocalPlayer:GetAttribute("LocationName")
	end
	local v2 = if t2.NightTime then "Night" else "Day"
	local v32 = v1[v2]
	local v4 = if v3 then v1[v3] else nil
	if not v4 then
		return v32, v2
	end
	local v5 = if v12 then v12:Get("Events") else v12
	if v5 then
		for i, v in ipairs(v5) do
			if v ~= "Day" and (v ~= "Night" and v4[v]) then
				return MergeLightingProfile(v32, v4[v]), ("%*:%*:%*"):format(v3, v, v2)
			end
		end
	end
	return MergeLightingProfile(v32, v4[v2] or v4), ("%*:%*"):format(v3, v2)
end
function UpdateLocationNotification(p1) --[[ UpdateLocationNotification | Line: 429 | Upvalues: TextNotificationController (copy) ]]
	TextNotificationController:DeliverNotification({
		Type = "Location",
		Text = p1,
		TextColor = {
			R = 255,
			G = 255,
			B = 255
		}
	})
end
function UpdateLighting() --[[ UpdateLighting | Line: 437 | Upvalues: v12 (ref), v15 (ref), v16 (ref), t2 (copy), v5 (ref), v6 (copy), v13 (ref), v7 (copy), v8 (copy), v10 (ref), TweenService (copy), Lighting (copy), v9 (copy), SkyboxesMatch (copy), v17 (copy), Replion (copy), v11 (ref), SoundService (copy), v14 (ref), spr (copy) ]]
	if v12 then
		return
	end
	v12 = true
	local v1, v2
	if v15 == nil then
		local v3, v4 = t2:_getLightingProfile()
		v1 = v3
		v2 = v4
	else
		v1 = v15
		v2 = v16
	end
	if not v1 then
		v12 = false
		return
	end
	if typeof(v2) == "string" and (typeof(v5) == "string" and v5 == v2) then
		v12 = false
		return
	end
	v5 = v2
	v6:Clean()
	if not v1.Ambiance or v1.Ambiance and v13 ~= v1.Ambiance.SoundId then
		v7:Clean()
		v13 = nil
	end
	if not v1.Music or v1.Music and v13 ~= v1.Music.SoundId then
		v8:Clean()
		v10 = nil
	end
	if v1.Lighting then
		local v62 = TweenService:Create(Lighting, TweenInfo.new(3, Enum.EasingStyle.Quart), v1.Lighting)
		v62.Completed:Once(function() --[[ Line: 480 | Upvalues: v62 (copy) ]]
			v62:Destroy()
		end)
		v6:Add(function() --[[ Line: 484 | Upvalues: v62 (copy) ]]
			v62:Cancel()
		end)
		v62:Play()
	end
	local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if Atmosphere and v1.Atmosphere then
		local v72 = TweenService:Create(Atmosphere, TweenInfo.new(3, Enum.EasingStyle.Quart), v1.Atmosphere)
		v72.Completed:Once(function() --[[ Line: 494 | Upvalues: v72 (copy) ]]
			v72:Destroy()
		end)
		v6:Add(function() --[[ Line: 498 | Upvalues: v72 (copy) ]]
			v72:Cancel()
		end)
		v72:Play()
	end
	local v82 = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
	if v82 then
		local v92 = if v1.ColorCorrection then v1.ColorCorrection else {}
		if not v92.Brightness then
			v92.Brightness = 0.04
		end
		if not v92.TintColor then
			v92.TintColor = Color3.fromRGB(255, 255, 255)
		end
		local v102 = TweenService:Create(v82, TweenInfo.new(3, Enum.EasingStyle.Quart), v92)
		v102.Completed:Once(function() --[[ Line: 520 | Upvalues: v102 (copy) ]]
			v102:Destroy()
		end)
		v6:Add(function() --[[ Line: 524 | Upvalues: v102 (copy) ]]
			v102:Cancel()
		end)
		v102:Play()
	end
	local Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
	if Clouds and v1.Clouds then
		if typeof(v1.Clouds.Enabled) == "boolean" then
			Clouds.Enabled = v1.Clouds.Enabled
		else
			Clouds.Enabled = true
			local v112 = TweenService:Create(Clouds, TweenInfo.new(3, Enum.EasingStyle.Quart), v1.Clouds)
			v112.Completed:Once(function() --[[ Line: 538 | Upvalues: v112 (copy) ]]
				v112:Destroy()
			end)
			v6:Add(function() --[[ Line: 542 | Upvalues: v112 (copy) ]]
				v112:Cancel()
			end)
			v112:Play()
		end
	end
	local Sky = v1.Sky
	if Sky then
		v9:Clean()
		local Sky_2 = Lighting:FindFirstChildOfClass("Sky")
		if not SkyboxesMatch(Sky_2, Sky) then
			local v122 = v9:Clone(Sky)
			v9:Add(function() --[[ Line: 558 | Upvalues: v17 (ref), Lighting (ref) ]]
				v17:Clone().Parent = Lighting
			end)
			if Sky_2 then
				Sky_2:Destroy()
			end
			v122.Parent = Lighting
		end
	else
		v9:Clean()
	end
	local v132 = Replion.Client:WaitReplion("Data"):Get("Settings")
	local Music = v1.Music
	if Music and not v11 then
		v11 = true
		if not v10 or v10 ~= Music.SoundId then
			local Music_2 = Instance.new("Sound")
			Music_2.Name = "Music"
			Music_2.Volume = 0
			Music_2.SoundId = Music.SoundId
			Music_2.Looped = true
			Music_2.Parent = SoundService
			local v142 = TweenService
			local v152 = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
			local t = {}
			local v162, v172
			if v132 and v132.Music then
				v162 = Music.Volume
				if v162 then
					v172 = Music_2
				else
					v162 = 0
					v172 = Music_2
				end
			else
				v162 = 0
				v172 = Music_2
			end
			t.Volume = v162
			local v18 = v142:Create(v172, v152, t)
			v18.Completed:Once(function() --[[ Line: 594 | Upvalues: v18 (copy) ]]
				v18:Destroy()
			end)
			v8:Add(function() --[[ Line: 598 | Upvalues: v18 (copy), TweenService (ref), Music_2 (copy) ]]
				task.spawn(function() --[[ Line: 599 | Upvalues: v18 (ref), TweenService (ref), Music_2 (ref) ]]
					local v1
					if v18.PlaybackState == Enum.PlaybackState.Playing then
						v18:Cancel()
					end
					v1 = TweenService:Create(Music_2, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
						Volume = 0
					})
					v1.Completed:Once(function() --[[ Line: 609 | Upvalues: v1 (copy), Music_2 (ref) ]]
						v1:Destroy()
						Music_2:Destroy()
					end)
					v1:Play()
				end)
			end)
			v18:Play()
			Music_2:Play()
			v10 = Music.SoundId
		end
		v11 = false
	end
	local Ambiance = v1.Ambiance
	if Ambiance and not v14 then
		v14 = true
		if not v13 or v13 ~= Ambiance.SoundId then
			local Ambience = Instance.new("Sound")
			Ambience.Name = "Ambience"
			Ambience.Volume = 0
			Ambience.SoundId = Ambiance.SoundId
			Ambience.Looped = true
			Ambience.Parent = SoundService
			local v19 = TweenService
			local v20 = TweenInfo.new(0.2, Enum.EasingStyle.Quart)
			local t = {}
			local v21, v22
			if v132 and v132.Ambience then
				v21 = Ambiance.Volume
				if v21 then
					v22 = Ambience
				else
					v21 = 0
					v22 = Ambience
				end
			else
				v21 = 0
				v22 = Ambience
			end
			t.Volume = v21
			local v23 = v19:Create(v22, v20, t)
			v23.Completed:Once(function() --[[ Line: 644 | Upvalues: v23 (copy) ]]
				v23:Destroy()
			end)
			v7:Add(function() --[[ Line: 648 | Upvalues: v23 (copy), TweenService (ref), Ambience (copy) ]]
				task.spawn(function() --[[ Line: 649 | Upvalues: v23 (ref), TweenService (ref), Ambience (ref) ]]
					local v1
					if v23.PlaybackState ~= Enum.PlaybackState.Playing then
						v1 = TweenService:Create(Ambience, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
							Volume = 0
						})
						v1.Completed:Once(function() --[[ Line: 659 | Upvalues: v1 (copy), Ambience (ref) ]]
							v1:Destroy()
							Ambience:Destroy()
						end)
						v1:Play()
						return
					end
					v23:Cancel()
					v1 = TweenService:Create(Ambience, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
						Volume = 0
					})
					v1.Completed:Once(function() --[[ Line: 659 | Upvalues: v1 (copy), Ambience (ref) ]]
						v1:Destroy()
						Ambience:Destroy()
					end)
					v1:Play()
				end)
			end)
			v23:Play()
			Ambience:Play()
			v13 = Ambiance.SoundId
		end
		v14 = false
	end
	local v24 = v1.WaterColor or Color3.fromRGB(72, 129, 118)
	local Terrain = workspace.Terrain
	if Terrain.WaterColor == v24 then
		spr.stop(Terrain)
		Terrain.WaterColor = v24
	else
		spr.stop(Terrain)
		spr.target(Terrain, 1, 3, {
			WaterColor = v24
		})
	end
	local ForcedClockTime = v1.ForcedClockTime
	if ForcedClockTime then
		t2._tweenTime(ForcedClockTime)
	else
		local v25 = workspace:GetAttribute("ClockTime")
		if math.abs(v25 - Lighting.ClockTime) >= 0.1 then
			t2._tweenTime(v25)
		else
			Lighting.ClockTime = v25
		end
	end
	Lighting.ExposureCompensation = v1.ExposureCompensation or 0
	v12 = false
end
function t2._tweenTime(p1) --[[ _tweenTime | Line: 710 | Upvalues: TweenService (copy), Lighting (copy) ]]
	local v1 = TweenService:Create(Lighting, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
		ClockTime = p1
	})
	v1.Completed:Once(function() --[[ Line: 715 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end)
	v1:Play()
end
return t2