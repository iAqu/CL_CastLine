-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Middleware = nil
}
local v1 = nil
local t2 = {
	Util = script.Parent.Parent
}
local v2 = newproxy(true)
getmetatable(v2).__tostring = function() --[[ Line: 123 ]]
	return "SIGNAL_MARKER"
end
local v3 = newproxy(true)
getmetatable(v3).__tostring = function() --[[ Line: 128 ]]
	return "UNRELIABLE_SIGNAL_MARKER"
end
local v4 = newproxy(true)
getmetatable(v4).__tostring = function() --[[ Line: 133 ]]
	return "PROPERTY_MARKER"
end
local Services = Instance.new("Folder")
Services.Name = "Services"
local Promise = require(t2.Util.Promise)
local ServerComm = require(t2.Util.Comm).ServerComm
local t3 = {}
local v5 = false
local v6 = false
local v7 = Instance.new("BindableEvent")
local function DoesServiceExist(p1) --[[ DoesServiceExist | Line: 149 | Upvalues: t3 (copy) ]]
	return t3[p1] ~= nil
end
function t2.CreateService(p1) --[[ CreateService | Line: 184 | Upvalues: t3 (copy), v5 (ref), ServerComm (copy), Services (copy) ]]
	assert(type(p1) == "table", (("Service must be a table; got %*"):format((type(p1)))))
	assert(type(p1.Name) == "string", (("Service.Name must be a string; got %*"):format((type(p1.Name)))))
	assert(#p1.Name > 0, "Service.Name must be a non-empty string")
	assert(not (t3[p1.Name] ~= nil), (("Service \"%*\" already exists"):format(p1.Name)))
	assert(not v5, "Services cannot be created after calling \"Knit.Start()\"")
	p1.KnitComm = ServerComm.new(Services, p1.Name)
	if type(p1.Client) == "table" then
		if p1.Client.Server ~= p1 then
			p1.Client.Server = p1
		end
	else
		p1.Client = {
			Server = p1
		}
	end
	t3[p1.Name] = p1
	return p1
end
function t2.AddServices(p1) --[[ AddServices | Line: 214 | Upvalues: v5 (ref) ]]
	assert(not v5, "Services cannot be added after calling \"Knit.Start()\"")
	local t = {}
	for v2, v3 in p1:GetChildren() do
		if v3:IsA("ModuleScript") then
			table.insert(t, require(v3))
		end
	end
	return t
end
function t2.AddServicesDeep(p1) --[[ AddServicesDeep | Line: 232 | Upvalues: v5 (ref) ]]
	assert(not v5, "Services cannot be added after calling \"Knit.Start()\"")
	local t = {}
	for v2, v3 in p1:GetDescendants() do
		if v3:IsA("ModuleScript") then
			table.insert(t, require(v3))
		end
	end
	return t
end
function t2.GetService(p1) --[[ GetService | Line: 250 | Upvalues: v5 (ref), t3 (copy) ]]
	assert(v5, "Cannot call GetService until Knit has been started")
	assert(type(p1) == "string", (("ServiceName must be a string; got %*"):format((type(p1)))))
	return assert(t3[p1], (("Could not find service \"%*\""):format(p1)))
end
function t2.GetServices() --[[ GetServices | Line: 260 | Upvalues: v5 (ref), t3 (copy) ]]
	assert(v5, "Cannot call GetServices until Knit has been started")
	return t3
end
function t2.CreateSignal() --[[ CreateSignal | Line: 290 | Upvalues: v2 (copy) ]]
	return v2
end
function t2.CreateUnreliableSignal() --[[ CreateUnreliableSignal | Line: 313 | Upvalues: v3 (copy) ]]
	return v3
end
function t2.CreateProperty(p1) --[[ CreateProperty | Line: 346 | Upvalues: v4 (copy) ]]
	return { v4, p1 }
end
function t2.Start(p1) --[[ Start | Line: 384 | Upvalues: v5 (ref), Promise (copy), t3 (copy), v1 (ref), t (copy), v2 (copy), v3 (copy), v4 (copy), v6 (ref), v7 (copy), Services (copy) ]]
	if v5 then
		return Promise.reject("Knit already started")
	else
		v5 = true
		table.freeze(t3)
		if p1 == nil then
			v1 = t
		else
			local v12 = typeof(p1) == "table"
			assert(v12, (("KnitOptions should be a table or nil; got %*"):format((typeof(p1)))))
			v1 = p1
			for v32, v42 in t do
				if p1[v32] == nil then
					p1[v32] = v42
				end
			end
		end
		return Promise.new(function(p1) --[[ Line: 405 | Upvalues: v1 (ref), t3 (ref), v2 (ref), v3 (ref), v4 (ref), Promise (ref) ]]
			local v12 = if v1.Middleware == nil then {} else v1.Middleware
			for v22, v32 in t3 do
				local v42 = if v32.Middleware == nil then {} else v32.Middleware
				local v5 = if v42.Inbound == nil then v12.Inbound else v42.Inbound
				local v6 = if v42.Outbound == nil then v12.Outbound else v42.Outbound
				v32.Middleware = nil
				for v7, v8 in v32.Client do
					if type(v8) == "function" then
						v32.KnitComm:WrapMethod(v32.Client, v7, v5, v6)
					end
					if v8 == v2 then
						v32.Client[v7] = v32.KnitComm:CreateSignal(v7, false, v5, v6)
					end
					if v8 == v3 then
						v32.Client[v7] = v32.KnitComm:CreateSignal(v7, true, v5, v6)
					end
					if type(v8) == "table" and v8[1] == v4 then
						v32.Client[v7] = v32.KnitComm:CreateProperty(v7, v8[2], v5, v6)
					end
				end
			end
			local t = {}
			for v9, v10 in t3 do
				if type(v10.KnitInit) == "function" then
					table.insert(t, Promise.new(function(p1) --[[ Line: 435 | Upvalues: v10 (copy) ]]
						debug.setmemorycategory(v10.Name)
						v10:KnitInit()
						p1()
					end))
				end
			end
			p1(Promise.all(t))
		end):andThen(function() --[[ Line: 445 | Upvalues: t3 (ref), v6 (ref), v7 (ref), Services (ref) ]]
			for v1, v2 in t3 do
				if type(v2.KnitStart) == "function" then
					task.spawn(function() --[[ Line: 449 | Upvalues: v2 (copy) ]]
						debug.setmemorycategory(v2.Name)
						v2:KnitStart()
					end)
				end
			end
			v6 = true
			v7:Fire()
			task.defer(function() --[[ Line: 459 | Upvalues: v7 (ref) ]]
				v7:Destroy()
			end)
			Services.Parent = script.Parent
		end)
	end
end
function t2.OnStart() --[[ OnStart | Line: 480 | Upvalues: v6 (ref), Promise (copy), v7 (copy) ]]
	if v6 then
		return Promise.resolve()
	else
		return Promise.fromEvent(v7.Event)
	end
end
return t2