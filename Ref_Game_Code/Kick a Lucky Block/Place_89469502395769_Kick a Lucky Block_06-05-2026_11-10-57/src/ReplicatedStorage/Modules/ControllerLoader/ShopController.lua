-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local ValidShops = require(ReplicatedStorage.Shared.Data.ValidShops)
return {
	BuyItem = function(p1, p2, p3) --[[ BuyItem | Line: 16 | Upvalues: ValidShops (copy), Network (copy) ]]
		assert(if p2 then if typeof(p2) == "string" then true else false else p2, "No ShopName arg passed.")
		assert(if p3 then if typeof(p3) == "string" then true else false else p3, "No ItemName arg passed.")
		if table.find(ValidShops, p2) then
			Network.FireServer("Shop_Buy", p2, p3)
		else
			warn((("[%*] Shop name: %* is missing from \'ValidShops\'"):format(script.Name, p2)))
		end
	end
}