-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=112061170330936

-- ! Source from the asset above; the game may have edited it since.

--[[
--!strict

const StarterGui = game:GetService("StarterGui")

task.spawn(function()
	while task.wait(3) do
		if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
			warn("Purse and CoreGui backpack enabled at the same time")
			break
		end
	end
end)

]]

-- The Script is Empty