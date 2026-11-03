-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local Animations = require(ReplicatedStorage.Modules.Animations)
require(ReplicatedStorage.Modules.NPC)
local PlayerStatsUtility = require(ReplicatedStorage.Shared.PlayerStatsUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local MarkerOffsets = require(script:WaitForChild("MarkerOffsets"))
local RodThrowVFXData = require(ReplicatedStorage.Shared.RodThrowVFXData)
local VFXController = require(ReplicatedStorage.Controllers.VFXController)
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local v1 = nil
local t6 = {
	MarkerListener = Signal.new(),
	MarkerOffsets = MarkerOffsets,
	Init = function(p1) --[[ Init | Line: 45 | Upvalues: LocalPlayer (copy), t3 (copy), t4 (copy) ]]
		LocalPlayer.CharacterRemoving:Connect(function(p1) --[[ Line: 46 | Upvalues: t3 (ref) ]]
			for i, v in ipairs(t3) do
				task.spawn(v, p1)
			end
		end)
		LocalPlayer.CharacterAdded:Connect(function(p1) --[[ Line: 52 | Upvalues: t4 (ref) ]]
			for i, v in ipairs(t4) do
				task.delay(0, v, p1)
			end
		end)
	end
}
function t6.Start(p1) --[[ Start | Line: 59 | Upvalues: v1 (ref), Replion (copy), t6 (copy), t (copy) ]]
	v1 = Replion.Client:WaitReplion("Data")
	v1:OnChange("EquippedSkinUUID", function(p1) --[[ Line: 62 | Upvalues: t6 (ref) ]]
		if not (string.len(p1) > 0) then
			return
		end
		t6:_preloadTracks()
	end)
	t6:RegisterCharacterAdded(function(p1) --[[ Line: 68 | Upvalues: t6 (ref) ]]
		t6:_preloadTracks()
	end)
	t6:RegisterCharacterRemoving(function(p1) --[[ Line: 72 | Upvalues: t (ref), t6 (ref) ]]
		warn("character died")
		table.clear(t)
		t6:_destroyActiveTracks()
	end)
end
function t6._destroyActiveTracks(p1) --[[ _destroyActiveTracks | Line: 79 | Upvalues: t5 (copy) ]]
	for v1, v2 in t5 do
		v2:Stop()
		v2:Destroy()
	end
	table.clear(t5)
end
function t6.GetRodName(p1) --[[ GetRodName | Line: 88 | Upvalues: v1 (ref), PlayerStatsUtility (copy), ItemUtility (copy) ]]
	if not v1 then
		return
	end
	local v12 = v1:GetExpect("EquippedSkinUUID")
	local v2 = v1:GetExpect("EquippedItems")
	local v3 = if string.len(v12) > 0 then v12 else v2[1]
	if not v3 then
		return
	end
	local v4 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 101 | Upvalues: v3 (copy) ]]
		return p1.UUID == v3
	end, "Fishing Rods")
	if not v4 then
		return
	end
	local v5 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v4.Id)
	if v5 then
		return v5.Data.Name
	end
end
function t6._preloadTracks(p1) --[[ _preloadTracks | Line: 115 | Upvalues: t6 (copy), Animations (copy), t (copy), ContentProvider (copy) ]]
	local v1 = t6:GetRodName()
	local t2 = {}
	for k, v in pairs(Animations) do
		if not v.Disabled and v.Animation then
			local v2 = k:find("NPC") or v.Default
			if (v1 and k:find(v1) or v2) and t[v.Animation.AnimationId] == nil then
				t[v.Animation.AnimationId] = true
				t6:AddAnimation(k)
				table.insert(t2, v.Animation)
			end
		end
	end
	local _, _2 = pcall(function() --[[ Line: 144 | Upvalues: ContentProvider (ref), t2 (copy) ]]
		ContentProvider:PreloadAsync(t2)
	end)
end
function t6.StopAnimation(p1, p2) --[[ StopAnimation | Line: 149 | Upvalues: t6 (copy), t2 (copy), HttpService (copy), t5 (copy) ]]
	local v1, v2 = t6:GetAnimationData(p2)
	if not v1 then
		return
	end
	t2[v2] = HttpService:GenerateGUID(false)
	local v3 = t5[v1.AnimationId]
	if not v3 then
		return
	end
	v3:Stop()
end
function t6.GetAnimationData(p1, p2) --[[ GetAnimationData | Line: 169 | Upvalues: Animations (copy), v1 (ref), PlayerStatsUtility (copy), ItemUtility (copy) ]]
	local v12 = Animations[p2]
	local v2 = nil
	if v12 and (v12.Variants and v1) then
		local v3 = v1:GetExpect("EquippedSkinUUID")
		local v4 = v1:GetExpect("EquippedItems")[1]
		local v5 = if string.len(v3) > 0 then v3 else v4
		local v6 = PlayerStatsUtility:GetItemFromInventory(v1, function(p1) --[[ Line: 185 | Upvalues: v5 (ref) ]]
			return p1.UUID == v5
		end, "Fishing Rods")
		if v6 then
			local v7 = ItemUtility.GetItemDataFromItemType("Fishing Rods", v6.Id)
			if v7 then
				local v8 = ("%s - %s"):format(v7.Data.Name, p2)
				if Animations[v8] then
					v2 = v8
				elseif Animations[v2] then
					return Animations[v2], v2
				else
					return v12, p2
				end
			elseif Animations[v2] then
				return Animations[v2], v2
			else
				return v12, p2
			end
		end
	end
	if Animations[v2] then
		return Animations[v2], v2
	else
		return v12, p2
	end
end
function t6.IsDisabled(p1, p2) --[[ IsDisabled | Line: 209 | Upvalues: t6 (copy) ]]
	local v1, _ = t6:GetAnimationData(p2)
	if v1 then
		return v1.Disabled and true or false
	else
		return false
	end
end
function t6.PlayAnimation(p1, p2, p3) --[[ PlayAnimation | Line: 222 | Upvalues: t6 (copy), HttpService (copy), t2 (copy), t5 (copy), v1 (ref), Trove (copy), RodThrowVFXData (copy), LocalPlayer (copy), VFXController (copy), Soundbook (copy) ]]
	local v12, v2 = t6:GetAnimationData(p2)
	if not v12 then
		return
	end
	t2[v2] = HttpService:GenerateGUID(false)
	local v3 = t5[v12.AnimationId]
	local v4
	if v3 == nil then
		local v5, v6 = t6:AddAnimation(v2)
		v3 = v5
		v4 = v6
	else
		v4 = nil
	end
	if v3 then
		v3:Play(nil, nil, v12.PlaybackSpeed)
		local v7 = v1 and v1:Get({ "Settings", "Self Rod VFX" })
		local v8 = Trove.new()
		v8:Add(v3:GetMarkerReachedSignal("Throw"):Once(function(p1) --[[ Line: 245 | Upvalues: RodThrowVFXData (ref), LocalPlayer (ref), v7 (copy), VFXController (ref) ]]
			if not p1 then
				return
			end
			local v1 = RodThrowVFXData[p1]
			if not v1 then
				return
			end
			if v1.PlayAttachment then
				local CastingEmitVFX = LocalPlayer.Character:FindFirstChild("CastingEmitVFX", true)
				if CastingEmitVFX and v7 then
					VFXController.Handle(p1, CastingEmitVFX)
				end
			else
				if not v7 then
					return
				end
				VFXController.Handle(p1, LocalPlayer.Character.HumanoidRootPart.CFrame * v1.Offset)
			end
		end))
		v8:Add(v3.Stopped:Once(function() --[[ Line: 272 | Upvalues: v8 (copy) ]]
			v8:Clean()
		end))
		v8:Add(v3.Destroying:Once(function() --[[ Line: 276 | Upvalues: v8 (copy) ]]
			v8:Clean()
		end))
		if p3 then
			v3.Ended:Wait()
			v8:Clean()
		end
	end
	if not v12.CustomCastSFX then
		return v3, v4
	end
	local Character = LocalPlayer.Character
	if not Character then
		return v3, v4
	end
	Soundbook:RenderAt(v12.CustomCastSFX, Character:GetPivot().Position)
	return v3, v4
end
function t6.AddAnimation(p1, p2) --[[ AddAnimation | Line: 297 | Upvalues: LocalPlayer (copy), Animations (copy), t5 (copy), Trove (copy), Signal (copy), t2 (copy), t6 (copy), MarkerOffsets (copy), RunService (copy) ]]
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local v1 = Character:FindFirstChildWhichIsA("Humanoid")
	if not v1 then
		return
	end
	local v2 = v1:FindFirstChildWhichIsA("Animator")
	if not v2 then
		return
	end
	local v3 = Animations[p2]
	if not v3 then
		return
	end
	local Animation = v3.Animation
	if not Animation then
		return
	end
	local v4 = t5[v3.AnimationId]
	if v4 then
		return
	end
	local CustomMarkers = v3.CustomMarkers
	local LinkedMarkers = v3.LinkedMarkers
	local LinkedAnimations = v3.LinkedAnimations
	local PlaybackSpeed = v3.PlaybackSpeed
	local Looped = v3.Looped
	local TimePosition = v3.TimePosition
	local Looped_2 = v3.Looped
	if v4 then
		return
	end
	local v5 = Trove.new()
	local v6 = Signal.new()
	local v7 = Signal.new()
	local v8 = Signal.new()
	local v9 = Signal.new()
	local v10 = nil
	local v11 = if LinkedMarkers then if next(LinkedMarkers) == nil then false else true else false
	local v12 = if LinkedAnimations then if #LinkedAnimations > 0 then true else false else false
	v5:Add(function() --[[ Line: 356 | Upvalues: v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (ref), t5 (ref), v3 (copy) ]]
		v6:DisconnectAll()
		v6:Destroy()
		v7:DisconnectAll()
		v7:Destroy()
		v8:DisconnectAll()
		v8:Destroy()
		v9:DisconnectAll()
		v9:Destroy()
		v10 = nil
		t5[v3.AnimationId] = nil
	end)
	local v13, v14 = pcall(function() --[[ Line: 374 | Upvalues: v2 (copy), Animation (copy) ]]
		return v2:LoadAnimation(Animation)
	end)
	local function playMarker(p1, p22) --[[ playMarker | Line: 379 | Upvalues: t2 (ref), p2 (copy), v10 (ref), v6 (copy), t6 (ref), v13 (ref), v14 (ref) ]]
		if t2[p2] == v10 then
			v6:Fire(p1)
			if typeof(p22) == "string" then
				t6:PlayAnimation(p22)
			end
		else
			if not v13 then
				return
			end
			v14:Stop()
		end
	end
	local function stoppedTrack() --[[ stoppedTrack | Line: 392 | Upvalues: v14 (ref), t2 (ref), p2 (copy), v10 (ref), LinkedAnimations (copy), t6 (ref), v13 (ref) ]]
		if v14.TimePosition ~= v14.Length then
			return
		end
		if v10 == t2[p2] then
			for i, v in ipairs(LinkedAnimations) do
				task.spawn(t6.PlayAnimation, t6, v)
			end
		else
			if not v13 then
				return
			end
			v14:Stop()
		end
	end
	if v13 then
		if Looped ~= nil then
			v14.Looped = Looped
		end
		if TimePosition then
			v14.TimePosition = TimePosition
		end
		v5:Add(v14:GetPropertyChangedSignal("IsPlaying"):Connect(function() --[[ Line: 417 | Upvalues: v14 (ref), v10 (ref), t2 (ref), p2 (copy) ]]
			if not v14.IsPlaying then
				return
			end
			v10 = t2[p2]
		end))
		if v11 then
			for v15, v16 in LinkedMarkers do
				v5:Add(v14:GetMarkerReachedSignal(v15):Connect(function() --[[ Line: 425 | Upvalues: v15 (copy), v16 (copy), t2 (ref), p2 (copy), v10 (ref), v6 (copy), t6 (ref), v13 (ref), v14 (ref) ]]
					local v1 = v15
					local v2 = v16
					if t2[p2] == v10 then
						v6:Fire(v1)
						if typeof(v2) == "string" then
							t6:PlayAnimation(v2)
						end
					else
						if not v13 then
							return
						end
						v14:Stop()
					end
				end))
			end
		end
		if CustomMarkers then
			for v17, v18 in CustomMarkers do
				v5:Add(v14:GetMarkerReachedSignal(v18):Connect(function() --[[ Line: 433 | Upvalues: t6 (ref), v18 (copy) ]]
					t6.MarkerListener:Fire(v18)
				end))
			end
		end
		if v12 then
			v5:Add(v14.Stopped:Connect(function() --[[ Line: 440 | Upvalues: stoppedTrack (copy) ]]
				stoppedTrack()
			end))
		end
		t5[v3.AnimationId] = v14
		v14.Destroying:Once(function() --[[ Line: 448 | Upvalues: v5 (copy) ]]
			v5:Destroy()
		end)
	else
		local v19 = v5:Extend()
		if v11 then
			for v20, v21 in LinkedMarkers do
				local v22 = MarkerOffsets[v20]
				if v22 then
					local v23 = v7:Connect(function(p1) --[[ Line: 463 | Upvalues: v22 (copy), v20 (copy), v21 (copy), t2 (ref), p2 (copy), v10 (ref), v6 (copy), t6 (ref), v13 (ref), v14 (ref) ]]
						task.wait(v22 / (p1 or 1))
						local v1 = v20
						local v2 = v21
						if t2[p2] == v10 then
							v6:Fire(v1)
							if typeof(v2) == "string" then
								t6:PlayAnimation(v2)
							end
						else
							if not v13 then
								return
							end
							v14:Stop()
						end
					end)
					v5:Add(function() --[[ Line: 470 | Upvalues: v23 (copy) ]]
						v23:Disconnect()
					end)
				end
			end
		end
		if CustomMarkers then
			for v24, v25 in CustomMarkers do
				local v26 = MarkerOffsets[v25]
				if v26 then
					local v27 = v7:Connect(function(p1) --[[ Line: 483 | Upvalues: v26 (copy), t6 (ref), v25 (copy) ]]
						task.wait(v26 / (p1 or 1))
						t6.MarkerListener:Fire(v25)
					end)
					v5:Add(function() --[[ Line: 490 | Upvalues: v27 (copy) ]]
						v27:Disconnect()
					end)
				end
			end
		end
		if v12 then
			local v28 = v8:Connect(function() --[[ Line: 497 | Upvalues: stoppedTrack (copy) ]]
				stoppedTrack()
			end)
			v5:Add(function() --[[ Line: 501 | Upvalues: v28 (copy) ]]
				v28:Disconnect()
			end)
		end
		local t = {
			TimePosition = 0,
			Play = function(p1, p22, p3, p4, p5) --[[ Play | Line: 508 | Upvalues: v10 (ref), t2 (ref), p2 (copy), v7 (copy) ]]
				v10 = t2[p2]
				v7:Fire(p5)
			end,
			Stop = function(p1) --[[ Stop | Line: 513 | Upvalues: v19 (copy), v8 (copy), v9 (copy) ]]
				v19:Clean()
				v8:Fire()
				v9:Fire()
			end,
			Destroy = function(p1) --[[ Destroy | Line: 519 | Upvalues: v19 (copy), v8 (copy), v9 (copy), v5 (copy) ]]
				v19:Clean()
				v8:Fire()
				v9:Fire()
				v5:Destroy()
			end,
			Stopped = {
				Connect = function(p1, p2) --[[ Connect | Line: 528 | Upvalues: v8 (copy) ]]
					v8:Connect(p2)
				end,
				Once = function(p1, p2) --[[ Once | Line: 531 | Upvalues: v8 (copy) ]]
					v8:Once(p2)
				end
			},
			Ended = {
				Connect = function(p1, p2) --[[ Connect | Line: 537 | Upvalues: v9 (copy) ]]
					v9:Connect(p2)
				end,
				Once = function(p1, p2) --[[ Once | Line: 540 | Upvalues: v9 (copy) ]]
					v9:Once(p2)
				end
			},
			Length = v3.Length or 0
		}
		local v29 = v7:Connect(function() --[[ Line: 549 | Upvalues: v19 (copy), t (copy), RunService (ref), v9 (copy) ]]
			local v1 = false
			v19:Clean()
			t.TimePosition = 0
			v19:Add(RunService.PreAnimation:Connect(function(p1) --[[ Line: 556 | Upvalues: t (ref), v1 (ref), v9 (ref) ]]
				t.TimePosition = math.min(t.TimePosition, t.Length)
				if v1 or not (t.TimePosition >= t.Length) then
					return
				end
				v1 = true
				v9:Fire()
			end))
		end)
		v19:Add(function() --[[ Line: 566 | Upvalues: v29 (copy) ]]
			v29:Disconnect()
		end)
		v13 = true
		v14 = t
		t5[v3.AnimationId] = t
	end
	return v14
end
function t6.DestroyActiveAnimationTracks(p1, p2) --[[ DestroyActiveAnimationTracks | Line: 582 | Upvalues: Animations (copy), t5 (copy), t2 (copy) ]]
	local v2 = if p2 then p2 else {}
	for k, v in pairs(Animations) do
		if not v.Disabled then
			local v3 = t5[v.AnimationId]
			if v3 and not table.find(v2, k) then
				local v4 = k:split(" ")
				if not table.find(v2, v4[#v4]) then
					if t2[k] then
						t2[k] = nil
					end
					v3:Stop()
				end
			end
		end
	end
end
function t6.RegisterCharacterRemoving(p1, p2) --[[ RegisterCharacterRemoving | Line: 615 | Upvalues: t3 (copy) ]]
	table.insert(t3, p2)
end
function t6.RegisterCharacterAdded(p1, p2) --[[ RegisterCharacterAdded | Line: 619 | Upvalues: t4 (copy), LocalPlayer (copy) ]]
	table.insert(t4, p2)
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	task.spawn(p2, Character)
end
return t6