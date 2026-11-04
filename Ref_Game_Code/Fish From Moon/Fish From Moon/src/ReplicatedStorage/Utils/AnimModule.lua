local module = {}

local Anims = {}

--播放动画
function module.PlayAnim(model, animation)
	if not model then
		return 
	end
	local controller = model:FindFirstChild("Humanoid") or model:FindFirstChild("AnimationController")
	if not controller then
		return
	end
	local animator = controller:FindFirstChild("Animator") or Instance.new("Animator", controller)
	for _, track in pairs((animator:GetPlayingAnimationTracks())) do
		if track.Animation == animation and track.IsPlaying then
			return
		end
	end
	if Anims[model] == nil or Anims[model][animation] == nil then
		Anims[model] = {}
		Anims[model][animation] = animator:LoadAnimation(animation)
	end
	Anims[model][animation]:Play()
end
--停止播放动画
function module.StopAnim(model, anim)
	local controller = model:FindFirstChild("Humanoid") or model:FindFirstChild("AnimationController")
	if not controller then
		return
	end
	local tracks = (controller:FindFirstChild("Animator") or Instance.new("Animator", controller)):GetPlayingAnimationTracks()
	for _, track in pairs(tracks) do
		if track.Animation == anim then
			track:Stop()
			return
		end	
	end
end
--冻住玩家
function module.FreezePlayer(isfrozen)
	if not isfrozen then
		game:GetService("ContextActionService"):UnbindAction("freezeMovement")
		return
	end
	game:GetService("ContextActionService"):BindAction("freezeMovement", function()
		return Enum.ContextActionResult.Sink
	end, false, unpack(Enum.PlayerActions:GetEnumItems()))
end
return module
