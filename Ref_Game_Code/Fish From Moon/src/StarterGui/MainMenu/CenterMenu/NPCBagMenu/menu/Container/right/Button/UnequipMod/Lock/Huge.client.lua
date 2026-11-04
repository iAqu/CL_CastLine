--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local button = script.Parent

button.MouseButton1Down:Connect(function()

	local PetBagController = Knit.GetController("PetBagController")
	PetBagController:HugePet()

end)