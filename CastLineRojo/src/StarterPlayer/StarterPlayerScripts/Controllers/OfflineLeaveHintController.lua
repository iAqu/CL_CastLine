local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local CommonResultClient = require(ReplicatedStorage.Modules.CommonResultClient)

local OFFLINE_HINT_TEXT = "Fish on your plot earn Cash while you're away!"

local OfflineLeaveHintController = Knit.CreateController({
	Name = "OfflineLeaveHintController",
})

function OfflineLeaveHintController:KnitStart()
	GuiService.MenuOpened:Connect(function()
		CommonResultClient.OpenResultGui(OFFLINE_HINT_TEXT)
	end)
end

return OfflineLeaveHintController
