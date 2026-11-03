-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	QuestLines = {
		["A New Adventure"] = { "Catch Fish & Upgrade Rod!", "Catch 5 Fish & Upgrade Bait!", "Visit the Ocean", "Visit the Kohana Island!", "Volcanic Fish", "Getting Familiar" },
		["Pufferfish Hunter"] = { "Shell Catcher", "Catch 20 Fish In Kohana Volcano", "Catch 15 Magma Smeltfish", "Catch 2 Magma Piranha", "Catch 2 Mutated Fish", "Complete a Epic Bounty", "Catch 1 Ancient Magma Whale" }
	}
}
function t.GetQuestLineFromId(p1, p2) --[[ GetQuestLineFromId | Line: 24 | Upvalues: t (copy) ]]
	if t.QuestLines[p2] ~= nil then
		return p2
	end
	for v1, v2 in t.QuestLines do
		if table.find(v2, p2) then
			return v1
		end
	end
	return nil
end
function t.IsAQuestLine(p1, p2) --[[ IsAQuestLine | Line: 37 | Upvalues: t (copy) ]]
	return if t:GetQuestLineFromId(p2) == nil then t.QuestLines[p2] ~= nil else true
end
return t