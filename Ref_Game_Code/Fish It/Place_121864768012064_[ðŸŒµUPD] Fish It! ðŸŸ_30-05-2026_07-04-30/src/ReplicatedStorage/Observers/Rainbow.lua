-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Observers = require(ReplicatedStorage.Packages.Observers)
local v1 = 0
local t = {
	ParticleEmitter = {},
	Beam = {},
	Part = {},
	Light = {},
	Decal = {},
	Texture = {},
	Image = {},
	UIGradient = {},
	SurfaceAppearance = {}
}
local function getClass(p1) --[[ getClass | Line: 45 ]]
	if p1:IsA("Light") then
		return "Light"
	end
	if p1:IsA("BasePart") then
		return "Part"
	end
	if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
		return "Image"
	else
		return p1.ClassName
	end
end
Observers.observeTag("Rainbow", function(p1) --[[ Line: 61 | Upvalues: t (copy) ]]
	local t2 = {}
	local function trackDescendant(p1) --[[ trackDescendant | Line: 64 | Upvalues: t (ref), t2 (copy) ]]
		local v2 = t[if p1:IsA("Light") then "Light" elseif p1:IsA("BasePart") then "Part" elseif p1:IsA("ImageLabel") or p1:IsA("ImageButton") then "Image" else p1.ClassName]
		if v2 then
			table.insert(v2, p1)
			table.insert(t2, p1)
		end
	end
	if p1:IsA("Model") then
		for i, v in ipairs(p1:GetDescendants()) do
			local v1
			v1 = if v:IsA("Light") then "Light" elseif v:IsA("BasePart") then "Part" elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then "Image" else v.ClassName
			local v2 = t[v1]
			if v2 then
				table.insert(v2, v)
				table.insert(t2, v)
			end
		end
	else
		local v4 = t[if p1:IsA("Light") then "Light" elseif p1:IsA("BasePart") then "Part" elseif p1:IsA("ImageLabel") or p1:IsA("ImageButton") then "Image" else p1.ClassName]
		if v4 then
			table.insert(v4, p1)
			table.insert(t2, p1)
		end
	end
	return function() --[[ Line: 83 | Upvalues: t2 (copy), t (ref) ]]
		for i = #t2, 1, -1 do
			local v1
			local v2 = t2[i]
			v1 = if v2:IsA("Light") then "Light" elseif v2:IsA("BasePart") then "Part" elseif v2:IsA("ImageLabel") or v2:IsA("ImageButton") then "Image" else v2.ClassName
			local v3 = t[v1]
			if v3 then
				local v4 = table.find(v3, v2)
				if v4 then
					table.remove(v3, v4)
				end
			end
		end
		table.clear(t2)
	end
end, { workspace, PlayerGui })
RunService.RenderStepped:Connect(function(p1) --[[ Line: 105 | Upvalues: v1 (ref) ]]
	v1 = math.fmod(v1 + p1 * 0.2, 1)
end)
task.spawn(function() --[[ Line: 109 | Upvalues: v1 (ref), t (copy) ]]
	while true do
		task.wait(0.041666666666666664)
		local v12 = Color3.fromHSV(v1, 0.5, 0.9)
		local v2 = ColorSequence.new(v12)
		for i, v in ipairs(t.Part) do
			v.Color = v12
		end
		for i, v in ipairs(t.Light) do
			v.Color = v12
		end
		for i, v in ipairs(t.Decal) do
			v.Color3 = v12
		end
		for i, v in ipairs(t.Texture) do
			v.Color3 = v12
		end
		for i, v in ipairs(t.Image) do
			v.ImageColor3 = v12
		end
		for i, v in ipairs(t.SurfaceAppearance) do
			v.Color = v12
		end
		for i, v in ipairs(t.Beam) do
			v.Color = v2
		end
		for i, v in ipairs(t.ParticleEmitter) do
			v.Color = v2
		end
		for i, v in ipairs(t.UIGradient) do
			v.Color = v2
		end
	end
end)
return {}