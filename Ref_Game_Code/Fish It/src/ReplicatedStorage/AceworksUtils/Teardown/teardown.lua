-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = require(script.Parent:WaitForChild("typeof"))
require(script.Parent:WaitForChild("types"))
local cancel = task.cancel
local function v2(...) --[[ teardown | Line: 11 | Upvalues: v2 (copy), cancel (copy), v1 (copy) ]]
	for i = 1, select("#", ...) do
		local v12 = select(i, ...)
		local v22 = type(v12)
		if v12 ~= nil then
			if v22 == "function" then
				v12()
				continue
			end
			if v22 == "table" then
				for v3, v4 in v12 do
					v2(v4)
				end
				continue
			end
			if cancel == nil or v22 ~= "thread" then
				if v22 == "userdata" then
					local v5 = v1(v12)
					if v5 == "RBXScriptConnection" then
						if v12.Connected then
							v12:Disconnect()
						end
						continue
					end
					if v5 == "Instance" then
						v12:Destroy()
						continue
					end
					warn("unable to teardown value of type `" .. v5 .. "`")
					continue
				end
				warn("unable to teardown value of type `" .. v22 .. "`")
				continue
			end
			cancel(v12)
		end
	end
end
return v2