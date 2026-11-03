-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local t = {}
local function RateLimit(p1, p2, p3) --[[ RateLimit | Line: 8 | Upvalues: t (copy) ]]
	if not t[p1] then
		t[p1] = {}
	end
	local v1 = os.clock()
	local v2 = t[p1][p2] or 0
	if p3 <= v1 - v2 then
		t[p1][p2] = v1
		return true, p3
	else
		return false, p3 - (v1 - v2)
	end
end
Players.PlayerRemoving:Connect(function(p1) --[[ Line: 24 | Upvalues: t (copy) ]]
	t[p1] = nil
end)
return RateLimit