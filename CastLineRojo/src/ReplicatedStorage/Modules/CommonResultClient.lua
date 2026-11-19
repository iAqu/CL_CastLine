local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local GuiAnimation = require(ReplicatedStorage.Modules.GuiAnimation)
local template = playerGui:WaitForChild("CommonResultGui")

local CommonResult = {}

type Options = {
	ConfirmText: string?,
	RequireConfirm: boolean?,
}

function CommonResult.OpenResultGui(text: string, onConfirm: (() -> ())?, options: Options?)
	local clone = template:Clone()
	clone.Frame.ResultLabel.Text = text
	local button = clone.Frame.ConfirmButton
	if options and options.ConfirmText then
		button.TextLabel.Text = options.ConfirmText
	end

	local closed = false
	local function close()
		if closed then
			return false
		end
		closed = true
		GuiAnimation.PopModal(clone)
		clone:Destroy()
		return true
	end

	local function confirm()
		if close() and onConfirm then
			onConfirm()
		end
	end

	button.Activated:Connect(confirm)
	clone.Enabled = true
	clone.Parent = playerGui
	GuiAnimation.PushModal(clone, button, function()
		if not (options and options.RequireConfirm) then
			confirm()
		end
	end)
	return clone, close
end

return CommonResult
