-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
game:GetService("RunService")
local DataTypes = require(script.DataTypes)
local Customs = require(script.Customs)
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 10 | Upvalues: t (copy) ]]
	assert(p1, "No instance provided")
	assert(p2, "No tweenInfo provided")
	assert(p3, "No properties provided")
	local v2 = setmetatable({}, t)
	v2.Instance = p1
	v2.TweenInfo = p2
	v2.Properties = p3
	v2.UpdatedBindable = Instance.new("BindableEvent")
	v2.Updated = v2.UpdatedBindable.Event
	v2.CompletedBindable = Instance.new("BindableEvent")
	v2.Completed = v2.CompletedBindable.Event
	return v2
end
function t.Play(p1) --[[ Play | Line: 30 | Upvalues: t (copy) ]]
	p1:IndexOriginalProperties()
	p1.StartTime = tick()
	p1.Thread = task.defer(t.StartLoop, p1)
end
function t.Cancel(p1) --[[ Cancel | Line: 36 ]]
	p1.Thread = nil
	p1.StartTime = nil
end
function t.Reset(p1) --[[ Reset | Line: 41 ]]
	for k, v in pairs(p1.Properties) do
		p1.Instance[k] = p1.OriginalProperties[k]
	end
end
function t.PropertyExists(p1, p2) --[[ PropertyExists | Line: 47 ]]
	return pcall(function() --[[ Line: 48 | Upvalues: p1 (copy), p2 (copy) ]]
		return p1.Instance[p2]
	end)
end
function t.IsWhitelisted(p1, p2) --[[ IsWhitelisted | Line: 55 ]]
	if not p2.Whitelist then
		return true
	end
	for k, v in pairs(p2.Whitelist) do
		if p1.Instance:IsA(v) then
			return true
		end
	end
end
function t.IndexOriginalProperties(p1) --[[ IndexOriginalProperties | Line: 67 | Upvalues: Customs (copy), DataTypes (copy) ]]
	p1.OriginalProperties = {}
	for k, v in pairs(p1.Properties) do
		local v1 = Customs[k]
		local v2 = p1:PropertyExists(k) or v1
		assert(v2, k .. " is not a valid property of " .. p1.Instance:GetFullName())
		if v1 then
			local v4 = p1:IsWhitelisted(v1)
			assert(v4, p1.Instance:GetFullName() .. " class is not supported for custom type " .. k)
			p1.OriginalProperties[k] = v1.Get(p1.Instance)
			continue
		end
		local v6 = DataTypes[typeof(v)]
		assert(v6, typeof(v) .. " data type is not supported")
		p1.OriginalProperties[k] = p1.Instance[k]
	end
end
function t.StartLoop(p1) --[[ StartLoop | Line: 87 ]]
	local v1 = false
	local count = 0
	while p1.Thread == p1.Thread and p1.Instance.Parent do
		local v2 = (tick() - p1.StartTime) / p1.TweenInfo.Time
		local v3 = math.min(v2, 1)
		if v1 then
			v2 = 1 - v3
		end
		p1:Update(v2)
		p1.UpdatedBindable:Fire(v2)
		if v3 == 1 and (p1.TweenInfo.Reverses and not v1) then
			p1.StartTime = tick()
			v1 = true
		elseif v3 == 1 then
			if count == p1.TweenInfo.RepeatCount then
				break
			end
			p1.StartTime = tick()
			v1 = false
			count = count + 1
		end
		task.wait()
	end
	p1.CompletedBindable:Fire()
	p1:Destroy()
end
function t.Update(p1, p2) --[[ Update | Line: 128 | Upvalues: TweenService (copy), DataTypes (copy), Customs (copy) ]]
	local v1 = TweenService:GetValue(p2, p1.TweenInfo.EasingStyle, p1.TweenInfo.EasingDirection)
	for k, v in pairs(p1.Properties) do
		local v2 = DataTypes[typeof(v)]
		local v3 = p1.OriginalProperties[k]
		local v4 = Customs[k]
		if v4 then
			v4.Set(p1.Instance, v3, v, v1)
			continue
		end
		p1.Instance[k] = v2(v3, v, v1)
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 144 ]]
	p1:Cancel()
	p1.CompletedBindable:Destroy()
	p1.UpdatedBindable:Destroy()
end
return t