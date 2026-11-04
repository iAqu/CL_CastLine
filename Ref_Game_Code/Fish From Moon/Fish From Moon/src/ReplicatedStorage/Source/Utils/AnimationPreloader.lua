local AnimationPreloader = {}

local AnimationCache = {}

local player = game:GetService("Players").LocalPlayer

repeat
	wait()
until player.Character

repeat
	wait()
until player.Character:FindFirstChild("Humanoid")

 

local Humanoid:Humanoid = player.Character:FindFirstChild("Humanoid")
local Animator:Animator = Humanoid:WaitForChild("Animator")


function AnimationPreloader.PreloadAnimation(Animation:Animation)
	if not Animation then
		return
	end
	if not AnimationCache[Animation.AnimationId] then
		local animationTrack:AnimationTrack = Animator:LoadAnimation(Animation)
		--animationTrack.Priority = Enum.AnimationPriority.Action4
		AnimationCache[Animation.AnimationId] = animationTrack
	end 
end

function AnimationPreloader.PlayAnimation(Animation:Animation,Priority,CD)
	if not Animation then
		return
	end
	if not Priority  then
		Priority = "Action4"
	end
	local animationTrack = AnimationCache[Animation.AnimationId]
	if animationTrack then
		if animationTrack.IsPlaying then
			return
		end
		animationTrack.Priority = Enum.AnimationPriority[Priority]
		animationTrack:Play()
		if CD then
			animationTrack:AdjustSpeed(2/CD)
		end
	else
		AnimationCache[Animation.AnimationId] = Animator:LoadAnimation(Animation)
		AnimationCache[Animation.AnimationId] : Play()
	end
	return animationTrack
end


function AnimationPreloader.StopAnimation(Animation:Animation)
	if not Animation then
		return
	end
	local animationTrack = AnimationCache[Animation.AnimationId]
	if animationTrack then
		animationTrack:Stop()
	end
end

function AnimationPreloader.StopAllAnimations()
	for _,animationTrack in pairs(AnimationCache) do
		animationTrack:Stop()
	end
end


return AnimationPreloader
