-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Utils = require(script.Parent.Utils)
local v1 = RunService:IsServer()
local v2 = RunService:IsClient()
local Remotes
if Utils.ShouldMock then
	Remotes = nil
elseif v1 then
	Remotes = Instance.new("Folder")
	Remotes.Name = "Remotes"
	Remotes.Parent = script.Parent.Parent
else
	local Remotes_2 = script.Parent.Parent:WaitForChild("Remotes", 5)
	Remotes = assert(Remotes_2, "Did you forget to require the Replion module on the server?")
end
local function get(p1) --[[ get | Line: 33 | Upvalues: Remotes (ref), v2 (copy) ]]
	local v1 = Remotes:FindFirstChild(p1)
	if v1 then
		return v1
	end
	if not v2 then
		local v22
		v22 = Instance.new("RemoteEvent")
		v22.Name = p1
		v22.Parent = Remotes
		return v22
	end
	error("Did you forget to require the Replion module on the server?")
end
local function create(p1) --[[ create | Line: 48 | Upvalues: Remotes (ref), v2 (copy) ]]
	for v1, v22 in p1 do
		if not Remotes:FindFirstChild(v22) then
			if v2 then
				error("Did you forget to require the Replion module on the server?")
			end
			local v3 = Instance.new("RemoteEvent")
			v3.Name = v22
			v3.Parent = Remotes
		end
	end
end
local function sendTo(p1, p2, ...) --[[ sendTo | Line: 54 | Upvalues: Utils (copy), Remotes (ref), v2 (copy), Players (copy) ]]
	if Utils.ShouldMock then
		return
	end
	local v1 = Remotes:FindFirstChild(p2)
	local v22
	if v1 then
		v22 = v1
	else
		if v2 then
			error("Did you forget to require the Replion module on the server?")
		end
		local v3 = Instance.new("RemoteEvent")
		v3.Name = p2
		v3.Parent = Remotes
		v22 = v3
	end
	if p1 == "All" then
		v22:FireAllClients(...)
		return
	end
	if type(p1) == "table" then
		for v4, v5 in p1 do
			if v5:IsDescendantOf(Players) then
				v22:FireClient(v5, ...)
			end
		end
	elseif typeof(p1) == "Instance" and p1:IsA("Player") then
		v22:FireClient(p1, ...)
	else
		error("Invalid replicateTo!")
	end
end
return table.freeze({
	get = get,
	create = create,
	sendTo = sendTo
})