-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Players = game:GetService("Players")
-- -- require the Stroke Adjustermodule, this modele take effect
-- local UIStrokeAdjuster = require(ReplicatedStorage.Libs.UIStrokeAdjuster)
-- local Knit = require(ReplicatedStorage.Packages.Knit)
-- local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

-- local LocalPlayer = Players.LocalPlayer
-- local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")


--     -- UIStrokeAdjuster:TagScreenGui(PlayerGui:WaitForChild("StoreGui"))
--     -- UIStrokeAdjuster:TagScreenGui(PlayerGui:WaitForChild("PetGui"))
--     -- UIStrokeAdjuster:TagScreenGui(PlayerGui:WaitForChild("HomeGui"))



-- Knit.OnStart():andThen(function()
--     -- UIStrokeAdjuster:UpdateStrokeThickness()
--     UIStrokeAdjuster:TagBillboardGui(PlayerGui:WaitForChild("EggPreviewGui"))
--     UIStrokeAdjuster:TagBillboardGui(PlayerGui:WaitForChild("TitleGui"):WaitForChild("EggTemple"))
--     UIStrokeAdjuster:TagBillboardGui(PlayerGui:WaitForChild("TitleGui"):WaitForChild("RobuxEggTemple"))
-- end):catch(warn)