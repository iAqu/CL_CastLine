local player = game:GetService("Players").LocalPlayer

game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

player:SetAttribute("BuyFishRod",false)

player:SetAttribute("CanThrow",true)
player:SetAttribute("FlyTime",false)
player:SetAttribute("AutoPlayer",false)

player:SetAttribute("ThrowBuff",false)