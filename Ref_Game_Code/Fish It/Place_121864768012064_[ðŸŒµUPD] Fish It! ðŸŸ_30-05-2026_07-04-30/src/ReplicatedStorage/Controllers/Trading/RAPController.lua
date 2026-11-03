-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local TradeData = require(ReplicatedStorage.Shared.Trading.TradeData)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local t = {}
local v1 = nil
function t.GetRAP(p1, p2, p3) --[[ GetRAP | Line: 23 | Upvalues: v1 (ref), ItemUtility (copy), TradeData (copy) ]]
	if not v1 then
		return nil
	end
	local v12 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if not v12 then
		return nil
	end
	local v2 = v1:Get({ "RAPs", p2, (TradeData.GetItemId(p2, v12)) })
	if v2 == -1 then
		return nil
	else
		return v2
	end
end
function t.GetRAPAsync(p1, p2, p3) --[[ GetRAPAsync | Line: 43 | Upvalues: ItemUtility (copy), TradeData (copy) ]]
	local v1 = ItemUtility.GetItemDataFromItemType(p2, p3)
	if not v1 then
		return nil
	end
	local v2, v3 = TradeData.Remotes.GetItemRAP:InvokeServer(p2, v1.Data.Id)
	if v2 or not v3 then
		return v2
	end
	warn((("Failed to GetItemRAP for %* %*: %*"):format(p2, p3, v3)))
	return v2
end
function t.Start(p1) --[[ Start | Line: 58 | Upvalues: v1 (ref), Replion (copy) ]]
	v1 = Replion.Client:WaitReplion("RAP")
end
return t