-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:25:01
-- Luau version 6, Types version 3
-- Time taken: 0.000930 seconds

return {
	getOrCreateAnimator = function(arg1) -- Line 21, Named "getOrCreateAnimator"
		if not arg1:FindFirstChildOfClass("Animator") then
			local Animator = Instance.new("Animator")
			Animator.Name = "Animator"
			Animator.Parent = arg1
		end
		return Animator
	end;
	stopAnimations = function(arg1, arg2) -- Line 38, Named "stopAnimations"
		for _, v in pairs(arg1:GetPlayingAnimationTracks()) do
			v:Stop(arg2)
		end
	end;
	isPlayingAnimationTrack = function(arg1, arg2) -- Line 51, Named "isPlayingAnimationTrack"
		for _, v_2 in pairs(arg1:GetPlayingAnimationTracks()) do
			if v_2 == arg2 then
				return true
			end
		end
		return false
	end;
}