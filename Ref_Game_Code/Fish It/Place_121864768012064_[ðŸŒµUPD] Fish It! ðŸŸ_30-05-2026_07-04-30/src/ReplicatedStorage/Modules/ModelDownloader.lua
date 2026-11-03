-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local Net = require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Signal)
local Trove = require(ReplicatedStorage.Packages.Trove)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local v3 = Net:RemoteEvent("ModelDownload")
local v4 = if v1 then game:GetService("ServerStorage"):WaitForChild("ServerCollection") else nil
local Collection = script:WaitForChild("Collection")
local t = {}
local t2 = {}
local function downloadBanned(p1) --[[ downloadBanned | Line: 30 ]]
	return if p1 == "Fishing Rods" or p1 == "Lanterns" then true else p1 == "Boats"
end
local function updateIdentifier(p1, p2) --[[ updateIdentifier | Line: 34 | Upvalues: ItemUtility (copy) ]]
	if typeof(p2) == "number" then
		local v1 = ItemUtility.GetItemDataFromItemType(p1, p2)
		if v1 then
			return v1.Data.Name
		end
	end
	return p2
end
function t2.Download(p1, p2, p3) --[[ Download | Line: 45 | Upvalues: ItemUtility (copy), t (copy), Collection (copy) ]]
	if if p2 == "Fishing Rods" or p2 == "Lanterns" then true elseif p2 == "Boats" then true else false then
		return
	end
	local v2
	if typeof(p3) == "number" then
		local v3 = ItemUtility.GetItemDataFromItemType(p2, p3)
		v2 = if v3 then v3.Data.Name else p3
	else
		v2 = p3
	end
	local v4 = t[p2]
	if not v4 then
		return
	end
	local v5 = v4[v2]
	if not v5 then
		return
	end
	if v5:IsDescendantOf(Collection) then
		return
	end
	v5.Parent = Collection[p2]
end
function t2.DownloadApproved(p1, p2, p3) --[[ DownloadApproved | Line: 67 | Upvalues: ItemUtility (copy), Collection (copy), t (copy) ]]
	local v1
	if typeof(p3) == "number" then
		local v2 = ItemUtility.GetItemDataFromItemType(p2, p3)
		v1 = if v2 then v2.Data.Name else p3
	else
		v1 = p3
	end
	local v3 = Collection:FindFirstChild(p2)
	if not v3 then
		return
	end
	if v3:FindFirstChild(v1) then
		return
	end
	local v4 = t[p2]
	if not v4 then
		return
	end
	local v5 = v4[v1]
	if not v5 then
		return
	end
	if v5:IsDescendantOf(Collection) then
		return
	end
	if if p2 == "Fishing Rods" or p2 == "Lanterns" then true else p2 == "Boats" then
		v5:Clone().Parent = v3
	else
		v5.Parent = v3
	end
end
function t2.Wait(p1, p2, p3) --[[ Wait | Line: 99 | Upvalues: ItemUtility (copy), v2 (copy), Trove (copy), v3 (copy), Collection (copy) ]]
	local v1
	if typeof(p3) == "number" then
		local v22 = ItemUtility.GetItemDataFromItemType(p2, p3)
		v1 = if v22 then v22.Data.Name else p3
	else
		v1 = p3
	end
	local v32
	if v2 then
		local v4 = Trove.new()
		v4:Add(task.defer(function() --[[ Line: 105 | Upvalues: v3 (ref), p2 (copy), v1 (copy) ]]
			v3:FireServer(p2, v1)
		end))
		v32 = v4
	else
		v32 = nil
	end
	local v5 = Collection:WaitForChild(p2):WaitForChild(v1, 5)
	if v32 then
		v32:Destroy()
	end
	if v5 then
		return v5
	else
		warn((("Unable to Wait for model! Timeout reached. %* - %*\n%*"):format(p2, p3, (debug.traceback()))))
	end
end
function t2.GetModel(p1, p2, p3, p4) --[[ GetModel | Line: 125 | Upvalues: ItemUtility (copy), v1 (copy), v4 (copy), t (copy), v2 (copy), t2 (copy) ]]
	local v12 = if p4 == nil then true else p4
	local v22, v3
	if typeof(p3) == "number" then
		local v42 = ItemUtility.GetItemDataFromItemType(p2, p3)
		if v42 then
			v22 = v42.Data.Name
			v3 = v12
		else
			v22 = p3
			v3 = v12
		end
	else
		v22 = p3
		v3 = v12
	end
	if if p2 == "Fishing Rods" or p2 == "Lanterns" then true elseif p2 == "Boats" then true else false then
		if v1 then
			return v4[p2]:WaitForChild(v22, 10)
		end
		local v6 = t[p2]
		local v7 = if v6 then v6[v22] else v6
		if v2 and (not v7 and v3) then
			v7 = t2:Wait(p2, v22)
		end
		return v7
	else
		local v10 = (t[p2] or t[p2 .. "s"])[v22]
		if v2 and (not v10 and v3) then
			v10 = t2:Wait(p2, v22)
		end
		return v10
	end
end
if v1 then
	v3.OnServerEvent:Connect(function(p1, p2, p3) --[[ Line: 198 | Upvalues: ItemUtility (copy), t2 (copy) ]]
		assert(if typeof(p2) == "string" then true else false)
		assert(if typeof(p3) == "string" then true elseif typeof(p3) == "number" then true else false)
		local v3 = ItemUtility.GetItemDataFromItemType(p2, p3)
		if not v3 then
			return
		end
		if v3.Downloadable then
			t2:Download(p2, p3)
		end
	end)
end
xpcall(function() --[[ Line: 217 | Upvalues: v4 (copy), Collection (copy), t (copy) ]]
	for v2, v3 in (v4 or Collection):GetChildren() do
		local v42 = v3.Name
		t[v42] = {}
		local v5 = t[v42]
		local function appendModel(p1) --[[ appendModel | Line: 226 | Upvalues: v5 (copy), v42 (copy) ]]
			local v1 = p1.Name
			if v5[v1] then
				task.spawn(error, (("Duplicate name found for %* - %*!"):format(v42, v1)))
			else
				v5[v1] = p1
			end
		end
		for i, v in ipairs(v3:GetChildren()) do
			local v6 = v.Name
			if v5[v6] then
				task.spawn(error, (("Duplicate name found for %* - %*!"):format(v42, v6)))
				continue
			end
			v5[v6] = v
		end
		v3.ChildAdded:Connect(function(p1) --[[ Line: 241 | Upvalues: v5 (copy), v42 (copy) ]]
			local v1 = p1.Name
			if v5[v1] then
				task.spawn(error, (("Duplicate name found for %* - %*!"):format(v42, v1)))
			else
				v5[v1] = p1
			end
		end)
	end
end, warn)
return t2