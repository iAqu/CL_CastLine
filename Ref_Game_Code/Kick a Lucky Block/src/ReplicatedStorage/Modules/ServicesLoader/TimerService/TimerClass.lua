-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatTime = require(ReplicatedStorage.Functional.FormatTime)
local t = {}
t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 26 | Upvalues: t (copy) ]]
	return setmetatable({
		Label = p1,
		EndTime = p2,
		Format = p3,
		OnDestroy = p4,
		Requirement = p5
	}, t)
end
function t.UpdateEndTime(p1, p2) --[[ UpdateEndTime | Line: 38 ]]
	if p2 then
		p1.EndTime = p2
		p1:OnTick(workspace:GetServerTimeNow())
	end
end
function t.OnTick(p1, p2) --[[ OnTick | Line: 46 ]]
	local v2 = math.max(p1.EndTime - p2, 0)
	p1:SetLabel(v2)
	return v2
end
function t.SetLabel(p1, p2) --[[ SetLabel | Line: 54 | Upvalues: FormatTime (copy) ]]
	if p2 then
		local v1 = FormatTime(p2)
		p1.Label.Text = p1.Format and p1.Format:format(v1) or v1
	end
end
function t.ChangeFormat(p1, p2) --[[ ChangeFormat | Line: 63 ]]
	if p2 then
		p1.Format = p2
		p1:OnTick(workspace:GetServerTimeNow())
	end
end
function t.Destroy(p1, p2) --[[ Destroy | Line: 71 ]]
	if p1.OnDestroy and not p2 then
		p1:OnDestroy()
	end
	p1.Destroyed = true
end
return t