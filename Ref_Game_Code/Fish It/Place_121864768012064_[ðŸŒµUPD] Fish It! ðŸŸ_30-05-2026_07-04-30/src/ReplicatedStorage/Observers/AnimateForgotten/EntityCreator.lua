-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
t.__index = t
local t2 = {
	Thunderzilla = {
		Idle = {
			AnimationId = "rbxassetid://124544444479116",
			Looped = true,
			Priority = Enum.AnimationPriority.Idle
		},
		Swim1 = {
			AnimationId = "rbxassetid://94623110137103",
			Looped = true,
			Priority = Enum.AnimationPriority.Action2
		},
		Swim2 = {
			AnimationId = "rbxassetid://83636359436676",
			Looped = true,
			Priority = Enum.AnimationPriority.Action2
		},
		Swim3 = {
			AnimationId = "rbxassetid://97427165680315",
			Looped = true,
			Priority = Enum.AnimationPriority.Action2
		}
	}
}
function t.new(p1, p2) --[[ new | Line: 45 | Upvalues: t (copy), t2 (copy) ]]
	assert(if typeof(p1) == "string" then if #p1 > 0 then true else false else false, "[EntityCreator] entityName must be a non-empty string.")
	assert(if typeof(p2) == "Instance" then p2:IsA("Model") else false, "[EntityCreator] viewModel must be a Model instance.")
	local AnimationController = p2:FindFirstChildOfClass("AnimationController")
	assert(AnimationController, ("[EntityCreator] \'%s\' has no AnimationController."):format(p1))
	local Animator = AnimationController:FindFirstChildOfClass("Animator")
	assert(Animator, ("[EntityCreator] \'%s\' has no Animator."):format(p1))
	local v4 = setmetatable({}, t)
	v4._name = p1
	v4._viewModel = p2
	v4._animator = Animator
	v4._currentState = "Idle"
	v4._previousState = "Idle"
	v4.StateChanged = Instance.new("BindableEvent")
	v4._stateMap = t2[v4._name] or t2.Thunderzilla
	v4._connections = {}
	local v6 = Instance.new("Folder")
	v6.Name = ("EntityCreator_%s"):format(p1)
	v6.Parent = p2
	v4._folder = v6
	v4._animations = {}
	for k, v in pairs(v4._stateMap) do
		local Animation = Instance.new("Animation")
		Animation.Name = ("Anim_%s_%s"):format(p1, k)
		Animation.AnimationId = v.AnimationId
		Animation.Parent = v6
		v4._animations[k] = Animation
	end
	v4._tracks = {}
	v4:PlayAnimation("Idle")
	return v4
end
function t._getTrack(p1, p2) --[[ _getTrack | Line: 103 ]]
	if p1._tracks[p2] then
		return p1._tracks[p2]
	end
	local v1 = p1._animations[p2]
	local v2 = p1._stateMap[p2]
	if not (v1 and v2) then
		warn(("[EntityCreator] No animation registered for state \'%s\' on \'%s\'."):format(p2, p1._name))
		return nil
	end
	local v3 = p1._animator:LoadAnimation(v1)
	v3.Looped = v2.Looped
	v3.Priority = v2.Priority
	if not v3.Looped then
		local v4 = v3.Stopped:Connect(function() --[[ Line: 122 | Upvalues: p1 (copy), p2 (copy) ]]
			if p1._currentState ~= p2 then
				return
			end
			p1:SetState(p1._previousState)
		end)
		table.insert(p1._connections, v4)
	end
	p1._tracks[p2] = v3
	return v3
end
function t._stopCurrent(p1) --[[ _stopCurrent | Line: 135 ]]
	local v1 = p1._tracks[p1._currentState]
	if not (v1 and v1.IsPlaying) then
		return
	end
	v1:Stop()
end
function t.SetState(p1, p2) --[[ SetState | Line: 142 ]]
	assert(if typeof(p2) == "string" then true else false, "[EntityCreator] state must be a string.")
	assert(p1._stateMap[p2], ("[EntityCreator] Unknown state \'%s\' for entity \'%s\'."):format(p2, p1._name))
	if p2 ~= p1._currentState then
		local _currentState = p1._currentState
		p1._previousState = _currentState
		p1._currentState = p2
		p1.StateChanged:Fire(p2, _currentState)
		p1:PlayAnimation(p2)
	end
end
function t.PlayAnimation(p1, p2) --[[ PlayAnimation | Line: 158 ]]
	assert(if typeof(p2) == "string" then true else false, "[EntityCreator] state must be a string.")
	if not p1._stateMap[p2] then
		warn(("[EntityCreator] No animation registered for state \'%s\' on \'%s\'."):format(p2, p1._name))
		return
	end
	local v2 = p1:_getTrack(p2)
	if v2 then
		p1:_stopCurrent()
		v2:Play()
	end
end
function t.GetState(p1) --[[ GetState | Line: 175 ]]
	return p1._currentState
end
function t.GetPreviousState(p1) --[[ GetPreviousState | Line: 179 ]]
	return p1._previousState
end
function t.StopAll(p1) --[[ StopAll | Line: 183 ]]
	for k, v in pairs(p1._tracks) do
		if v.IsPlaying then
			v:Stop()
		end
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 191 ]]
	for i, v in ipairs(p1._connections) do
		v:Disconnect()
	end
	table.clear(p1._connections)
	for k, v in pairs(p1._tracks) do
		if v.IsPlaying then
			v:Stop(0)
		end
	end
	table.clear(p1._tracks)
	if p1._folder and p1._folder.Parent then
		p1._folder:Destroy()
	end
	p1._folder = nil
	if p1.StateChanged then
		p1.StateChanged:Destroy()
		p1.StateChanged = nil
	end
	p1._animations = nil
	p1._stateMap = nil
	p1._animator = nil
	p1._viewModel = nil
end
return t