-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local isEmpty = require(script.Parent.Parent:WaitForChild("Internal"):WaitForChild("Llama")).isEmpty
local v1 = nil
local t = {}
local function destroyConnection() --[[ destroyConnection | Line: 10 | Upvalues: v1 (ref) ]]
	if v1 == nil then
		return
	end
	v1:Disconnect()
	v1 = nil
end
local function createConnection() --[[ createConnection | Line: 17 | Upvalues: v1 (ref), RunService (copy), t (copy) ]]
	if v1 ~= nil then
		return
	end
	v1 = RunService.RenderStepped:Connect(function(p1_2) --[[ Line: 19 | Upvalues: t (ref) ]]
		for k2, v in pairs(t) do
			v(p1_2)
		end
	end)
end
return function(p1) --[[ bindToRenderstep | Line: 27 | Upvalues: HttpService (copy), t (copy), v1 (ref), RunService (copy), isEmpty (copy) ]]
	local v12 = HttpService:GenerateGUID(false)
	t[v12] = p1
	if v1 ~= nil then
		return function() --[[ Line: 32 | Upvalues: t (ref), v12 (copy), isEmpty (ref), v1 (ref) ]]
			t[v12] = nil
			if isEmpty(t) ~= true or v1 == nil then
				return
			end
			v1:Disconnect()
			v1 = nil
		end
	end
	v1 = RunService.RenderStepped:Connect(function(p1_2) --[[ Line: 19 | Upvalues: t (ref) ]]
		for k2, v in pairs(t) do
			v(p1_2)
		end
	end)
	return function() --[[ Line: 32 | Upvalues: t (ref), v12 (copy), isEmpty (ref), v1 (ref) ]]
		t[v12] = nil
		if isEmpty(t) ~= true or v1 == nil then
			return
		end
		v1:Disconnect()
		v1 = nil
	end
end