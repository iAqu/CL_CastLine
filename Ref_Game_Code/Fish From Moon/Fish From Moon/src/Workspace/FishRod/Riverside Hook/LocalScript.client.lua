local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local Player = game.Players.LocalPlayer
local Character = workspace:WaitForChild(Player.Name)
local Humanoid = Character:WaitForChild("Humanoid")

local IdleAnim

IdleAnim = Tool:WaitForChild("IdleAnim")
IdleAnim = Humanoid:LoadAnimation(IdleAnim)

Tool.Equipped:connect(function()
	if IdleAnim then
		IdleAnim:Play()
	end
end)
Tool.Unequipped:connect(function()
	if IdleAnim then
		IdleAnim:Stop()
	end
end)
Humanoid.Died:connect(function()
	if IdleAnim then
		IdleAnim:Stop()
	end
end)