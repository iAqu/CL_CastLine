-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = RunService:IsStudio()
local Loader = require(ReplicatedStorage.Packages.Loader)
require(ReplicatedStorage.Types.Modifiers)
local v2 = Loader.LoadDescendants(script)
if RunService:IsServer() then
	require(ReplicatedStorage.Modules.Util.TableUtil)
	local function getItemFromId(p1) --[[ getItemFromId | Line: 81 | Upvalues: v2 (copy) ]]
		for v1, v22 in v2 do
			if v22.Data.Id == p1 then
				return v22
			end
		end
	end
	local v3 = -1
	for v4, v5 in v2 do
		if v5.Data then
			v3 = math.max(v3, v5.Data.Id)
			continue
		end
		warn((("%* item has no data!"):format(v4)))
	end
	local t = {}
	for v7, v8 in v2 do
		if t[v8.Data.Id] then
			task.spawn(error, (("[ITEMS] DUPLICATE ENTRY FOUND: %* - %*"):format(v7, v8.Data.Name)))
		end
		if v1 and v8.Data.Id > 2000 then
			print((("[ITEMS] Item %* has an unusually high ID %*"):format(v8.Data.Name, v8.Data.Id)))
		end
		if v8.Probability and (v8.Probability.Chance and (v8.SellPrice and v8.SellPrice > 1 / v8.Probability.Chance * 50)) then
			task.spawn(error, (("[SELL PRICE] %* has an unusually high sell price!"):format(v8.Data.Name)))
		end
		t[v8.Data.Id] = true
	end
	if game.GameId == 6902403037 then
		local function updateMode() --[[ updateMode | Line: 135 | Upvalues: v2 (copy) ]]
			local v1 = workspace:GetAttribute("__GOD_MODE")
			local v22 = if v1 then 10 else 1
			local v3 = if v1 then 0.5 else 1
			local v4 = if v1 then 0.1 else 1
			for v5, v6 in v2 do
				if v6.Data.Type == "Fishing Rods" then
					local _originalClickPower = v6._originalClickPower
					if not _originalClickPower then
						local ClickPower = v6.ClickPower
						v6._originalClickPower = ClickPower
						_originalClickPower = ClickPower
					end
					local _originalResilience = v6._originalResilience
					if not _originalResilience then
						local Resilience = v6.Resilience
						v6._originalResilience = Resilience
						_originalResilience = Resilience
					end
					local _originalWindup = v6._originalWindup
					if not _originalWindup then
						local Windup = v6.Windup
						v6._originalWindup = Windup
						_originalWindup = Windup
					end
					if v6.ClickPower then
						v6.ClickPower = _originalClickPower * v22
					end
					if v6.Resilience then
						v6.Resilience = _originalResilience * v3
					end
					if v6.Windup then
						v6.Windup = NumberRange.new(_originalWindup.Min * v4, _originalWindup.Max * v4)
					end
				end
			end
		end
		updateMode()
		workspace:GetAttributeChangedSignal("__GOD_MODE"):Connect(function() --[[ Line: 184 | Upvalues: updateMode (copy) ]]
			updateMode()
		end)
	end
	table.clear(t)
end
return v2