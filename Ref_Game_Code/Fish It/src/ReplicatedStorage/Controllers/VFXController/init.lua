-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
local Signal = require(ReplicatedStorage.Packages.Signal)
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Loader = require(ReplicatedStorage.Packages.Loader)
local VFXUtility = require(ReplicatedStorage.Shared.VFXUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ForgeVFX = require(ReplicatedStorage.Packages.ForgeVFX)
local v1 = Loader.LoadChildren(script:WaitForChild("Effects"))
local SupportedInstances = require(script:WaitForChild("SupportedInstances"))
local CFrameTranslations = require(script:WaitForChild("CFrameTranslations"))
local v2 = Net:RemoteEvent("PlayVFX")
local v3 = Net:RemoteFunction("LoadVFX")
local CosmeticFolder = workspace:WaitForChild("CosmeticFolder")
local Characters = workspace:WaitForChild("Characters")
local t = {
	PlayVFX = Signal.new(),
	PlayEffect = Signal.new(),
	Contains = function(p1, p2) --[[ Contains | Line: 40 | Upvalues: VFXUtility (copy) ]]
		return VFXUtility:Contains(p2)
	end
}
function t.RenderAtPoint(p1, p2, p3) --[[ RenderAtPoint | Line: 44 | Upvalues: VFXUtility (copy), t (copy), Soundbook (copy), CosmeticFolder (copy), ForgeVFX (copy) ]]
	local v1 = VFXUtility:NewContainer(p2)
	if not v1 then
		return
	end
	local v2 = t:GetCFrame(p3, v1)
	v1:PivotTo(v2)
	if v1:HasTag("PlaySFX") then
		local v3 = v1:GetAttribute("SFX")
		if Soundbook:HasSound(v3) then
			Soundbook:RenderAt(v3, v2.Position)
		end
	end
	v1.Parent = CosmeticFolder
	ForgeVFX.emit(v1).Finished:andThen(function() --[[ Line: 69 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end)
end
function t.RenderInstance(p1, p2, p3) --[[ RenderInstance | Line: 74 | Upvalues: VFXUtility (copy), Trove (copy), t (copy), CosmeticFolder (copy), CFrameTranslations (copy), RunService (copy), Soundbook (copy), ForgeVFX (copy) ]]
	local v1 = VFXUtility:NewContainer(p2)
	if not v1 then
		return
	end
	local v2 = Trove.new()
	v2:Add(function() --[[ Line: 81 | Upvalues: v1 (copy) ]]
		if not (v1 and v1:IsDescendantOf(game)) then
			return
		end
		v1:Destroy()
	end)
	if p3:IsA("BasePart") then
		local v3 = t:GetCFrame(p3.CFrame, v1)
		v1.Anchored = false
		v1.Massless = true
		v1.CFrame = v3
		local WeldConstraint = Instance.new("WeldConstraint")
		WeldConstraint.Parent = v1
		WeldConstraint.Part0 = v1
		WeldConstraint.Part1 = p3
		v1.Parent = CosmeticFolder
	else
		local v4 = Vector3.new(0, 1, 0) * (v1.Size.Y / 2)
		local v5 = CFrameTranslations[p3.ClassName] or (function() --[[ Line: 103 ]]
			return CFrame.identity
		end)
		v1:PivotTo(v5(p3) - v4)
		v1.Parent = CosmeticFolder
		v2:Add(RunService.Heartbeat:Connect(function(p1) --[[ Line: 110 | Upvalues: v1 (copy), v5 (copy), p3 (copy), v4 (copy) ]]
			v1:PivotTo(v5(p3) - v4)
		end))
	end
	if v1:HasTag("PlaySFX") then
		local v6 = v1:GetAttribute("SFX")
		if Soundbook:HasSound(v6) then
			Soundbook:RenderAt(v6, v1.Position)
		end
	end
	ForgeVFX.emit(v1).Finished:andThen(function() --[[ Line: 126 | Upvalues: v2 (copy) ]]
		v2:Destroy()
	end)
end
function t.GetCFrame(p1, p2, p3) --[[ GetCFrame | Line: 131 | Upvalues: CosmeticFolder (copy), Characters (copy) ]]
	local v1 = if typeof(p3) == "Instance" and p3:IsA("PVInstance") then p3 elseif typeof(p3) == "table" then p3.Container else nil
	if not v1 then
		return CFrame.identity
	end
	local v2 = if v1:IsA("Model") then v1:GetExtentsSize() elseif v1:IsA("BasePart") then v1.Size else Vector3.new(1, 1, 1)
	if v1:HasTag("Floor") then
		local v4 = RaycastParams.new()
		v4.FilterType = Enum.RaycastFilterType.Exclude
		v4.FilterDescendantsInstances = { v1, CosmeticFolder, Characters }
		v4.IgnoreWater = true
		v4.RespectCanCollide = false
		local v5 = workspace:Raycast(p2.Position, Vector3.new(-0, -100, -0), v4)
		if v5 then
			local v6, v7, v8 = p2:ToOrientation()
			return CFrame.new(v5.Position) * CFrame.fromOrientation(v6, v7, v8) + Vector3.new(0, 1, 0) * (v2.Y / 2)
		end
	end
	return p2 - Vector3.new(0, 1, 0) * (v2.Y / 2)
end
function t.Render(p1, p2, p3, p4) --[[ Render | Line: 163 | Upvalues: v1 (copy) ]]
	local v12 = v1[p2]
	if v12 then
		v12(p3.Container)
		return
	end
	for i, v in ipairs(p3.ParticleEmitters) do
		local v2 = v:GetAttribute("EmitCount")
		local v3 = v:GetAttribute("EmitDelay") or 0
		local v4 = v:GetAttribute("EmitDuration")
		local function eparticle() --[[ eparticle | Line: 175 | Upvalues: v4 (copy), v (copy) ]]
			if not v4 or v4 == 0 then
				return
			end
			v.Enabled = true
			task.delay(v4, function() --[[ Line: 178 | Upvalues: v (ref) ]]
				v.Enabled = false
			end)
		end
		if v2 then
			if v3 == 0 then
				v:Emit(v2)
				if v4 and v4 ~= 0 then
					v.Enabled = true
					task.delay(v4, function() --[[ Line: 178 | Upvalues: v (copy) ]]
						v.Enabled = false
					end)
				end
				continue
			end
			task.delay(v3, function() --[[ Line: 189 | Upvalues: v (copy), v2 (copy), v4 (copy) ]]
				v:Emit(v2)
				if not v4 or v4 == 0 then
					return
				end
				v.Enabled = true
				task.delay(v4, function() --[[ Line: 178 | Upvalues: v (ref) ]]
					v.Enabled = false
				end)
			end)
		end
	end
end
function t.Load(p1) --[[ Load | Line: 198 | Upvalues: v3 (copy) ]]
	v3:InvokeServer(p1)
end
function t.Handle(p1, p2) --[[ Handle | Line: 202 | Upvalues: VFXUtility (copy), t (copy), SupportedInstances (copy) ]]
	if not VFXUtility:Contains(p1) then
		t.Load(p1)
	end
	if typeof(p2) == "CFrame" then
		return t:RenderAtPoint(p1, p2)
	end
	if typeof(p2) == "Instance" and table.find(SupportedInstances, p2.ClassName) then
		return t:RenderInstance(p1, p2)
	end
end
function t.Start(p1) --[[ Start | Line: 220 | Upvalues: v2 (copy), t (copy), VFXUtility (copy), CosmeticFolder (copy) ]]
	v2.OnClientEvent:Connect(t.Handle)
	t.PlayVFX:Connect(t.Handle)
	t.PlayEffect:Connect(function(p1, p2) --[[ Line: 224 | Upvalues: VFXUtility (ref), t (ref), CosmeticFolder (ref) ]]
		local v1 = VFXUtility:CreateContainer(p1)
		if v1 then
			local Container = v1.Container
			Container:PivotTo(CFrame.new(p2 + Vector3.new(0, 0.5, 0)))
			t:Render(p1, v1, v1.MaxLifetime)
			Container.Parent = CosmeticFolder
		end
	end)
end
return t