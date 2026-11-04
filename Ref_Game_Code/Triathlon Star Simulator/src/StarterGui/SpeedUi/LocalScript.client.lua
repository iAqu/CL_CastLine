-- Saved by UniversalSynSaveInstance https://discord.gg/wx4ThpAsmw

-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2024-10-02 00:30:18
-- Luau version 6, Types version 3
-- Time taken: 0.000814 seconds

local tbl = {}
for i = 1, 8 do
	table.insert(tbl, script.Parent:FindFirstChild("Speed"..i))
end
local const_number = 1
while true do
	i = 0.05
	if not wait(i) then break end
	i = script.Parent
	if i.Enabled == true then
		i = tbl
		local var12
		for i_2, v in pairs(i) do
			if i_2 ~= const_number then
				var12 = false
			else
				var12 = true
			end
			v.Visible = var12
		end
		if 8 < const_number + 1 then
		end
	end
end