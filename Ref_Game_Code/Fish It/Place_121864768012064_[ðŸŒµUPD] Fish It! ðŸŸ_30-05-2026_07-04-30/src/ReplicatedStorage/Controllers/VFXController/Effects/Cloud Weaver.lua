-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.VFXUtility)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local ForgeVFX = require(ReplicatedStorage.Packages.ForgeVFX)
require(ReplicatedStorage.Packages.spr)
ReplicatedStorage:WaitForChild("VFX"):WaitForChild("Cloud Weaver")
local DragonRig = script:WaitForChild("DragonRig")
local v1 = nil
local v2 = false
local function preload(p1) --[[ preload | Line: 20 | Upvalues: v2 (ref), ContentProvider (copy) ]]
	if not v2 then
		v2 = xpcall(function() --[[ Line: 25 | Upvalues: ContentProvider (ref), p1 (copy) ]]
			ContentProvider:PreloadAsync(p1)
		end, warn)
	end
end
local function getRigAnimation() --[[ getRigAnimation | Line: 30 | Upvalues: v1 (ref) ]]
	if v1 then
		return v1
	else
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "rbxassetid://76678284365913"
		Animation.Parent = script
		v1 = Animation
		return Animation
	end
end
return function(p1) --[[ playAnimation | Line: 43 | Upvalues: DragonRig (copy), v1 (ref), v2 (ref), ContentProvider (copy), Soundbook (copy), ForgeVFX (copy) ]]
	if (workspace.CurrentCamera.CFrame.Position - p1:GetPivot().Position).Magnitude > 1000 then
		return
	end
	local Top = p1:WaitForChild("Top")
	local Bottom = p1:WaitForChild("Bottom")
	local Position = Top.Position
	local Position_2 = Bottom.Position
	local v12 = DragonRig:Clone()
	local RootPart = v12:WaitForChild("RootPart")
	local Animator = v12:WaitForChild("AnimationController"):WaitForChild("Animator")
	RootPart.Anchored = true
	v12:PivotTo(CFrame.new(Vector3.new(0, -100, 4000)))
	v12.Parent = workspace
	local v22
	if v1 then
		v22 = v1
	else
		local Animation = Instance.new("Animation")
		Animation.AnimationId = "rbxassetid://76678284365913"
		Animation.Parent = script
		v1 = Animation
		v22 = Animation
	end
	local v3 = Animator:LoadAnimation(v22)
	v3.Looped = false
	local t = { v12, v3 }
	if not v2 then
		v2 = xpcall(function() --[[ Line: 25 | Upvalues: ContentProvider (ref), t (copy) ]]
			ContentProvider:PreloadAsync(t)
		end, warn)
	end
	local v4 = os.clock()
	repeat
		task.wait()
	until v3.Length > 0 or os.clock() - v4 > 1
	v3.Stopped:Once(function() --[[ Line: 77 | Upvalues: v3 (copy), v12 (copy) ]]
		v3:Destroy()
		v12:Destroy()
	end)
	v3:Play(nil, nil, 1.2)
	Soundbook:RenderAt("Cloud Weaver Splash", Position_2)
	repeat
		task.wait()
	until v3.IsPlaying
	task.delay(0.1, v12.PivotTo, v12, CFrame.new(Position_2 + Vector3.new(0, 4, 0)))
	task.delay(v3.Length * 0.7583333333333334, function() --[[ Line: 88 | Upvalues: ForgeVFX (ref), p1 (copy) ]]
		ForgeVFX.emit(p1).Finished:andThen(function() --[[ Line: 91 | Upvalues: p1 (ref) ]]
			p1:Destroy()
		end)
	end)
end