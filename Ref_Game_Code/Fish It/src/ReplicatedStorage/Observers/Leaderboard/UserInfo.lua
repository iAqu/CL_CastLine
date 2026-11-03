-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserService = game:GetService("UserService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Promise"))
require(script.Parent:WaitForChild("Types"))
local v1 = Promise.promisify(function(p1) --[[ Line: 11 | Upvalues: UserService (copy) ]]
	return UserService:GetUserInfosByUserIdsAsync(p1)
end)
local t = {}
local v2 = 0
local t2 = {}
function t2.UpdateUserInfoCache(p1, p2) --[[ UpdateUserInfoCache | Line: 22 | Upvalues: v2 (ref), t (copy), Promise (copy), v1 (copy), t2 (copy) ]]
	local v12 = workspace:GetServerTimeNow()
	if v12 - v2 < 1 then
		task.wait(1 + math.random())
	end
	local t3 = {}
	for i, v in ipairs(p2) do
		if t[v] == nil then
			table.insert(t3, v)
		end
	end
	if #t3 > 0 then
		local v22, v3 = Promise.try(v1, t3):catch(t2._logError):await()
		if v22 and typeof(v3) == "table" then
			for i, v in ipairs(v3) do
				t[v.Id] = v
			end
		end
	end
	v2 = v12
end
function t2.GetCache(p1) --[[ GetCache | Line: 50 | Upvalues: t (copy) ]]
	return t
end
function t2._logError(p1) --[[ _logError | Line: 54 ]] end
return t2