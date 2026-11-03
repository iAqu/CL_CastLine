-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
function observeSpecificCharacter(p1, p2) --[[ observeSpecificCharacter | Line: 2 ]]
	local v1 = nil
	local v2 = nil
	local function OnCharacterAdded(p1) --[[ OnCharacterAdded | Line: 7 | Upvalues: p2 (copy), v2 (ref), v1 (ref) ]]
		local v12 = nil
		task.defer(function() --[[ Line: 11 | Upvalues: p2 (ref), p1 (copy), v2 (ref), v12 (ref), v1 (ref) ]]
			local v13 = p2(p1)
			if typeof(v13) ~= "function" then
				return
			end
			if v2.Connected and p1.Parent then
				v12 = v13
				v1 = v13
				return
			end
			task.spawn(v13)
		end)
		local v22 = nil
		v22 = p1.AncestryChanged:Connect(function(p1, p2) --[[ Line: 27 | Upvalues: v22 (ref), v12 (ref), v1 (ref) ]]
			if p2 ~= nil or not v22.Connected then
				return
			end
			v22:Disconnect()
			if v12 == nil then
				return
			end
			task.spawn(v12)
			if v1 == v12 then
				v1 = nil
			end
			v12 = nil
		end)
	end
	v2 = p1.CharacterAdded:Connect(OnCharacterAdded)
	task.defer(function() --[[ Line: 45 | Upvalues: p1 (copy), v2 (ref), OnCharacterAdded (copy) ]]
		if not (p1.Character and v2.Connected) then
			return
		end
		task.spawn(OnCharacterAdded, p1.Character)
	end)
	return function() --[[ Line: 52 | Upvalues: v2 (ref), v1 (ref) ]]
		v2:Disconnect()
		if v1 == nil then
			return
		end
		task.spawn(v1)
		v1 = nil
	end
end
return observeSpecificCharacter