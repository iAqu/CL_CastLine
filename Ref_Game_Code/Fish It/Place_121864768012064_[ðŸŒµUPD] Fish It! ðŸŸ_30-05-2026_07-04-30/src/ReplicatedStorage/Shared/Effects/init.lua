-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local LocalPlayer = Players.LocalPlayer
require(ReplicatedStorage.Packages.Thread)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Thread = require(ReplicatedStorage.Packages.Thread)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Client = require(ReplicatedStorage.Packages.Replion).Client
require(ReplicatedStorage.Shared.StringLibrary)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
require(script:WaitForChild("Types"))
local FishingCastText = require(script:WaitForChild("FishingCastText"))
local v3 = Net:RemoteEvent("PlayFishingEffect")
local v4 = Net:RemoteEvent("ReplicateTextEffect")
local v5 = Net:RemoteEvent("DestroyEffect")
local v6 = Signal.new()
local v7 = workspace:WaitForChild("!!! EFFECTS")
local t = {
	GetEffectIndex = function(p1, p2, p3) --[[ GetEffectIndex | Line: 44 | Upvalues: FishingCastText (copy) ]]
		if p3 then
			return #FishingCastText
		end
		if p2 >= 0.95 then
			return #FishingCastText - 1
		else
			return math.max(math.floor(p2 * (#FishingCastText - 1)), 1)
		end
	end
}
function t.FishingEffect(p1, p2, p3, p4, p5) --[[ FishingEffect | Line: 52 | Upvalues: v1 (copy), Players (copy), v3 (copy), t (copy) ]]
	if not v1 then
		return
	end
	local v12 = Players:GetPlayerFromCharacter(p2)
	if not v12 then
		return
	end
	local Head = p2:FindFirstChild("Head")
	if not Head then
		return
	end
	v3:FireAllClients(v12, Head, t:GetEffectIndex(p4, p5))
end
function t.DestroyEffect(p1, p2, p3) --[[ DestroyEffect | Line: 68 | Upvalues: v1 (copy), v5 (copy), v2 (copy), v6 (copy) ]]
	if v1 and p2 == "All" then
		v5:FireAllClients(nil, p3)
	elseif v1 and (typeof(p2) == "Instance" and p2:IsA("Player")) then
		v5:FireClient(p2, nil, p3)
	end
	if not v2 then
		return
	end
	v6:Fire(p3)
end
function t.TextEffect(p1, p2) --[[ TextEffect | Line: 83 | Upvalues: v1 (copy), HttpService (copy), v4 (copy), v2 (copy), v7 (copy), Trove (copy), v6 (copy), Thread (copy), spr (copy), Soundbook (copy) ]]
	if v1 then
		local v12 = HttpService:GenerateGUID(false)
		p2.UUID = v12
		if p2.Channel == "All" then
			v4:FireAllClients(p2)
			return v12
		end
		if typeof(p2.Channel) ~= "Instance" or not p2.Channel:IsA("Player") then
			return v12
		end
		v4:FireClient(p2.Channel, p2)
		return v12
	else
		if not v2 then
			return
		end
		local v22 = if p2.TextData.AttachTo then p2.TextData.AttachTo.CFrame.Position elseif p2.Container then p2.Container.Position else nil
		if v22 and (not p2.IgnoreDistance and (workspace.CurrentCamera.CFrame.Position - v22).Magnitude > 300) then
			return
		end
		local v42 = script.Components:FindFirstChild(p2.TextData.EffectType or "BG")
		if not v42 then
			return
		end
		local v5 = p2.UUID or HttpService:GenerateGUID(false)
		local v62 = 90
		local v72 = 300
		local TextEffectAttachment = Instance.new("Part")
		TextEffectAttachment.Name = "TextEffectAttachment"
		TextEffectAttachment.Anchored = false
		TextEffectAttachment.CanCollide = false
		TextEffectAttachment.CanTouch = false
		TextEffectAttachment.CanQuery = false
		TextEffectAttachment.Transparency = 1
		TextEffectAttachment.Size = Vector3.new(0.1, 0.1, 0.1)
		TextEffectAttachment.Massless = true
		if p2.Container then
			TextEffectAttachment.Position = p2.Container.Position
		end
		local v8 = nil
		if p2.TextData.AttachTo then
			TextEffectAttachment.Anchored = false
			local Weld = Instance.new("Weld")
			Weld.Parent = TextEffectAttachment
			Weld.Part0 = TextEffectAttachment
			Weld.Part1 = p2.TextData.AttachTo
			Weld.C0 = CFrame.new(Vector3.new(-0, -2.5, -0))
			v8 = Weld
		else
			TextEffectAttachment.Anchored = true
		end
		TextEffectAttachment.Parent = p2.Parent or v7
		local v10 = Trove.new()
		local v11 = v42:Clone()
		if p2.TextData.Size then
			v11.Size = p2.TextData.Size
		end
		if p2.TextData.StudsOffset then
			v11.StudsOffset = p2.TextData.StudsOffset
		end
		if p2.TextData.Range then
			v11.MaxDistance = p2.TextData.Range
		end
		if p2.TextData.TextColor then
			v11.Container.Label.UIGradient.Color = p2.TextData.TextColor
		end
		if p2.CountdownData then
			local CountdownEnd = p2.CountdownData.CountdownEnd
			if not p2.CountdownData.CountdownStart then
				workspace:GetServerTimeNow()
			end
			local function updateLabel() --[[ updateLabel | Line: 171 | Upvalues: CountdownEnd (copy), v11 (copy), v10 (copy) ]]
				local v1 = workspace:GetServerTimeNow()
				local v3 = math.max(CountdownEnd - v1, 0)
				local v4 = math.floor(v3 % 60)
				v11.Container.Label.Text = ("%02i:%02i"):format((v3 - v4) / 60, v4)
				if CountdownEnd <= v1 then
					v10:Destroy()
				end
			end
			v11.MaxDistance = v11.MaxDistance * 3
			local v12 = v6:Connect(function(p1) --[[ Line: 193 | Upvalues: v5 (ref), v11 (copy), TextEffectAttachment (copy), v10 (copy) ]]
				if p1 ~= v5 then
					return
				end
				v11:Destroy()
				TextEffectAttachment:Destroy()
				v10:Destroy()
			end)
			v10:Add(function() --[[ Line: 202 | Upvalues: v12 (copy) ]]
				v12:Disconnect()
			end)
			v10:Add(Thread:Execute(10, updateLabel))
			updateLabel()
		else
			local sum = p2.Duration or 0.5
			if p2.TextData.Text == "PERFECT!" or p2.TextData.Text == "PERFECTION!" then
				sum = sum + 0.3
				v62 = 20
				v72 = 50
			end
			v11.Container.Label.Text = p2.TextData.Text
			task.delay(sum, function() --[[ Line: 220 | Upvalues: v10 (copy) ]]
				v10:Destroy()
			end)
		end
		v10:Add(function() --[[ Line: 226 | Upvalues: v11 (copy), spr (ref), v62 (ref), v72 (ref) ]]
			if not v11:IsDescendantOf(workspace) then
				return
			end
			spr.stop(v11.Container)
			spr.target(v11.Container, v62, v72, {
				GroupTransparency = 1
			})
		end)
		v10:Add(function() --[[ Line: 235 | Upvalues: v11 (copy), spr (ref), TextEffectAttachment (copy) ]]
			task.wait(4)
			if v11:IsDescendantOf(workspace) then
				spr.stop(v11.Container)
				v11:Destroy()
			end
			if not TextEffectAttachment:IsDescendantOf(workspace) then
				return
			end
			TextEffectAttachment:Destroy()
		end)
		v11.Container.GroupTransparency = 1
		v11.Parent = TextEffectAttachment
		if p2.TextData.Text == "PERFECT!" or p2.TextData.Text == "PERFECTION!" then
			Soundbook.Sounds.PerfectCast:Play()
		end
		if v8 then
			spr.target(v8, v62, v72, {
				C0 = CFrame.new(Vector3.new(-0, -1, -0))
			})
		elseif p2.Container and p2.Container.Position then
			spr.target(TextEffectAttachment, v62, v72, {
				Position = p2.Container.Position
			})
		end
		spr.target(v11.Container, v62, v72, {
			GroupTransparency = 0
		})
		return v5
	end
end
if v2 then
	local VFXController = require(ReplicatedStorage.Controllers.VFXController)
	v4.OnClientEvent:Connect(function(...) --[[ Line: 279 | Upvalues: t (copy) ]]
		t:TextEffect(...)
	end)
	v5.OnClientEvent:Connect(function(...) --[[ Line: 282 | Upvalues: t (copy) ]]
		t:DestroyEffect(...)
	end)
	v3.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 286 | Upvalues: FishingCastText (copy), Client (copy), t (copy), LocalPlayer (copy), VFXController (ref) ]]
		if not p2 then
			return
		end
		if (workspace.CurrentCamera.CFrame.Position - p2.Position).Magnitude > 100 then
			return
		end
		local v1 = FishingCastText[p3]
		if not v1 then
			return
		end
		local v2 = Client:GetReplion("Data")
		if not v2 then
			return
		end
		local v3 = v2:Get({ "Settings", "Self Rod VFX" })
		local v4 = v2:Get({ "Settings", "Others Rod VFX" })
		local v5 = table.clone(v1)
		v5.AttachTo = p2
		t:TextEffect({
			Duration = 0.5,
			Channel = p1,
			Container = p2,
			TextData = v5
		})
		if not (p3 >= 4) or (p1 ~= LocalPlayer or not v3) and (p1 == LocalPlayer or not v4) then
			return
		end
		VFXController.Handle(v5.Text, p2)
	end)
end
return t