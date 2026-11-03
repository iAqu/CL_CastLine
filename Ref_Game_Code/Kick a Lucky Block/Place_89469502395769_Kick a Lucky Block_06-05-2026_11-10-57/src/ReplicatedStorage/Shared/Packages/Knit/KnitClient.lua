-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	ServicePromises = true,
	Middleware = nil,
	PerServiceMiddleware = {}
}
local v1 = nil
local t2 = {
	Player = game:GetService("Players").LocalPlayer,
	Util = script.Parent.Parent
}
local Promise = require(t2.Util.Promise)
local ClientComm = require(t2.Util.Comm).ClientComm
local t3 = {}
local t4 = {}
local v2 = nil
local v3 = false
local v4 = false
local v5 = Instance.new("BindableEvent")
local function DoesControllerExist(p1) --[[ DoesControllerExist | Line: 127 | Upvalues: t3 (copy) ]]
	return t3[p1] ~= nil
end
local function GetServicesFolder() --[[ GetServicesFolder | Line: 133 | Upvalues: v2 (ref) ]]
	if not v2 then
		v2 = script.Parent:WaitForChild("Services")
	end
	return v2
end
local function GetMiddlewareForService(p1) --[[ GetMiddlewareForService | Line: 141 | Upvalues: v1 (ref) ]]
	local v12 = if v1.Middleware == nil then {} else v1.Middleware
	local v2 = v1.PerServiceMiddleware[p1]
	if v2 == nil then
		return v12
	else
		return v2
	end
end
local function BuildService(p1) --[[ BuildService | Line: 148 | Upvalues: v2 (ref), v1 (ref), ClientComm (copy), t4 (copy) ]]
	if not v2 then
		v2 = script.Parent:WaitForChild("Services")
	end
	local v22 = if v1.Middleware == nil then {} else v1.Middleware
	local v3 = v1.PerServiceMiddleware[p1]
	local v4 = if v3 == nil then v22 else v3
	local v5 = ClientComm.new(v2, v1.ServicePromises, p1):BuildObject(v4.Inbound, v4.Outbound)
	t4[p1] = v5
	return v5
end
function t2.CreateController(p1) --[[ CreateController | Line: 180 | Upvalues: t3 (copy), v3 (ref) ]]
	assert(type(p1) == "table", (("Controller must be a table; got %*"):format((type(p1)))))
	assert(type(p1.Name) == "string", (("Controller.Name must be a string; got %*"):format((type(p1.Name)))))
	assert(#p1.Name > 0, "Controller.Name must be a non-empty string")
	assert(not (t3[p1.Name] ~= nil), (("Controller %* already exists"):format(p1.Name)))
	assert(not v3, "Controllers cannot be created after calling \"Knit.Start()\"")
	t3[p1.Name] = p1
	return p1
end
function t2.AddControllers(p1) --[[ AddControllers | Line: 200 | Upvalues: v3 (ref) ]]
	assert(not v3, "Controllers cannot be added after calling \"Knit.Start()\"")
	local t = {}
	for v2, v32 in p1:GetChildren() do
		if v32:IsA("ModuleScript") then
			table.insert(t, require(v32))
		end
	end
	return t
end
function t2.AddControllersDeep(p1) --[[ AddControllersDeep | Line: 218 | Upvalues: v3 (ref) ]]
	assert(not v3, "Controllers cannot be added after calling \"Knit.Start()\"")
	local t = {}
	for v2, v32 in p1:GetDescendants() do
		if v32:IsA("ModuleScript") then
			table.insert(t, require(v32))
		end
	end
	return t
end
function t2.GetService(p1) --[[ GetService | Line: 285 | Upvalues: t4 (copy), v3 (ref), v2 (ref), v1 (ref), ClientComm (copy) ]]
	local v12 = t4[p1]
	if v12 then
		return v12
	else
		assert(v3, "Cannot call GetService until Knit has been started")
		local v32 = type(p1) == "string"
		assert(v32, (("ServiceName must be a string; got %*"):format((type(p1)))))
		if not v2 then
			v2 = script.Parent:WaitForChild("Services")
		end
		local v6 = if v1.Middleware == nil then {} else v1.Middleware
		local v7 = v1.PerServiceMiddleware[p1]
		local v8 = if v7 == nil then v6 else v7
		local v9 = ClientComm.new(v2, v1.ServicePromises, p1):BuildObject(v8.Inbound, v8.Outbound)
		t4[p1] = v9
		return v9
	end
end
function t2.GetController(p1) --[[ GetController | Line: 301 | Upvalues: t3 (copy), v3 (ref) ]]
	local v1 = t3[p1]
	if v1 then
		return v1
	else
		assert(v3, "Cannot call GetController until Knit has been started")
		assert(type(p1) == "string", (("ControllerName must be a string; got %*"):format((type(p1)))))
		error(("Could not find controller \"%*\". Check to verify a controller with this name exists."):format(p1), 2)
	end
end
function t2.GetControllers() --[[ GetControllers | Line: 315 | Upvalues: v3 (ref), t3 (copy) ]]
	assert(v3, "Cannot call GetControllers until Knit has been started")
	return t3
end
function t2.Start(p1) --[[ Start | Line: 338 | Upvalues: v3 (ref), Promise (copy), t3 (copy), v1 (ref), t (copy), v4 (ref), v5 (copy) ]]
	if v3 then
		return Promise.reject("Knit already started")
	else
		v3 = true
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
		if type(v1.PerServiceMiddleware) ~= "table" then
			v1.PerServiceMiddleware = {}
		end
		return Promise.new(function(p1) --[[ Line: 362 | Upvalues: t3 (ref), Promise (ref) ]]
			local t = {}
			for v1, v2 in t3 do
				if type(v2.KnitInit) == "function" then
					table.insert(t, Promise.new(function(p1) --[[ Line: 370 | Upvalues: v2 (copy) ]]
						debug.setmemorycategory(v2.Name)
						v2:KnitInit()
						p1()
					end))
				end
			end
			p1(Promise.all(t))
		end):andThen(function() --[[ Line: 380 | Upvalues: t3 (ref), v4 (ref), v5 (ref) ]]
			for v1, v2 in t3 do
				if type(v2.KnitStart) == "function" then
					task.spawn(function() --[[ Line: 384 | Upvalues: v2 (copy) ]]
						debug.setmemorycategory(v2.Name)
						v2:KnitStart()
					end)
				end
			end
			v4 = true
			v5:Fire()
			task.defer(function() --[[ Line: 394 | Upvalues: v5 (ref) ]]
				v5:Destroy()
			end)
		end)
	end
end
function t2.OnStart() --[[ OnStart | Line: 412 | Upvalues: v4 (ref), Promise (copy), v5 (copy) ]]
	if v4 then
		return Promise.resolve()
	else
		return Promise.fromEvent(v5.Event)
	end
end
return t2