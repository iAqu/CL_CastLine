-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=124139890702112

-- ! Source from the asset above; the game may have edited it since.

--[=[
-- EasyConfiguration.lua
-- @author Quenty
-- Last Modified February 3rd, 2014

local Type = print(script.Parent:WaitForChild("Type"))

local lib = {}

local function Modify(Instance, Values)
	-- Modifies an Instance by using a table.  

	assert(type(Values) == "table", "Values is not a table");

	for Index, Value in next, Values do
		if type(Index) == "number" then
			Value.Parent = Instance
		else
			Instance[Index] = Value
		end
	end
	return Instance
end

local function Make(ClassType, Properties)
	-- Using a syntax hack to create a nice way to Make new items.  

	return Modify(Instance.new(ClassType), Properties)
end

local AcceptableTypes = { -- Anything in here has a .Value property. 
	["StringValue"]         = true;
	["IntValue"]            = true;
	["NumberValue"]         = true;
	["BrickColorValue"]     = true;
	["BoolValue"]           = true;
	["Color3Value"]         = true;
	["Vector3Value"]        = true;
	["IntConstrainedValue"] = true;
}

local function TypeIsAcceptable(TypeName)
	return AcceptableTypes[TypeName]
end
lib.TypeIsAcceptable = TypeIsAcceptable;
lib.typeIsAcceptable = TypeIsAcceptable

local function AddSubDataLayer(DataName, Parent)
	-- For organization of data. Adds another configuration with the name "DataName", if one can't be found, and then returns it. 

	local DataContainer = Parent:FindFirstChild(DataName) or Make("Configuration", {
		Name = DataName;
		Parent = Parent;
		Archivable = true;
	})

	return DataContainer
end
lib.AddSubDataLayer = AddSubDataLayer
lib.addSubDataLayer = AddSubDataLayer

local EasyConfigCache = {}
setmetatable(EasyConfigCache, {__mode = "k"})

local function MakeEasyConfiguration(Configuration)
	if EasyConfigCache[Configuration] then
		return EasyConfigCache[Configuration]
	else
		local NewConfiguration = {}

		local function Get(ObjectName)
			return Configuration:FindFirstChild(ObjectName)
		end

		setmetatable(NewConfiguration, {
			__index = function(_, value)

				if not type(value) == "string" then
					error("Only Indexing with strings is supported with easyConfiguration", 2)
				end

				local loweredValue = value:lower()

				if loweredValue == "add" or loweredValue == "addvalue" then
					--[[ 
					So they can do stuff like... Config.AddValue('IntValue', {
						Name = "PizzaEaten"
						Value = 0;
					})

					--]]
					return function(valueType, values)
						local Object

						if values and values.Name and type(values.Name) == "string" then
							Object = Get(values.Name)
							if Object and Object.ClassName ~= valueType then
								print("[EasyConfiguration] - Invalid class '"..Object.ClassName.."' in configuration, being replaced by new data '"..valueType.."'");
								Object:Destroy()
								Object = nil;
							end
						else
							error("[EasyConfiguration] - No values received in the add method of easy configuration. Please give a table of default properties including the name. ", 2)
						end

						if not Object then
							local newInstance = Instance.new(valueType)
							Modify(newInstance, values)
							newInstance.Parent = Configuration
						end
					end
				elseif loweredValue == "get" or loweredValue == "getvalue" then
					return function(name)
						return Get(name)
					end
				elseif loweredValue == "getcontainer" then
					return function(name)
						return Get(name)
					end
				else
					local Object = Configuration:FindFirstChild(value)
					if Object and AcceptableTypes[Object.ClassName] then
						return Object.Value
					else
						error("[EasyConfiguration] - " .. (Object and "Object '"..value.."' was a "..Type.getType(Object).." value, and not acceptable, so no return was given" or "Could not find Object '"..value.."' in the configuration"), 2)
					end
				end
			end;
			__newindex = function(_, value, newValue)
				if type(value) == "string" then
					local Object = Get(value)
					if Object and AcceptableTypes[Object.ClassName] then
						Object.Value = newValue;
					else
						error("[EasyConfiguration] - Value '" .. value .. "' was not accepted, or wasn't in the configuration", 2);
					end
				else
					error("[EasyConfiguration] - Index with a string")
				end
			end;
		})

		EasyConfigCache[Configuration] = NewConfiguration
		return NewConfiguration;
	end
end
lib.Make = MakeEasyConfiguration;
lib.MakeEasyConfiguration = MakeEasyConfiguration;

return lib
]=]

-- https://lua.expert

local v1 = print(script.Parent:WaitForChild("Type"))
local t1 = {}

local function Modify(p1, p2) -- line: 9
    assert(type(p2) == "table", "Values is not a table")

    for v3, v4 in next, p2 do
        if type(v3) == "number" then
            v4.Parent = p1
        else
            p1[v3] = v4
        end
    end

    return p1
end

local function Make(p3, p4) -- line: 24
    -- upvalues: Modify (copy)
    return (Modify(Instance.new(p3), p4))
end

local t2 = {
    StringValue = true,
    IntValue = true,
    NumberValue = true,
    BrickColorValue = true,
    BoolValue = true,
    Color3Value = true,
    Vector3Value = true,
    IntConstrainedValue = true
}

local function TypeIsAcceptable(p5) -- line: 41
    -- upvalues: t2 (copy)
    return t2[p5]
end

t1.TypeIsAcceptable = TypeIsAcceptable
t1.typeIsAcceptable = TypeIsAcceptable

local function AddSubDataLayer(p6, p7) -- line: 47
    -- upvalues: Modify (copy)
    local v5 = p7:FindFirstChild(p6)

    if not v5 then
        local t3 = {
            Archivable = true,
            Name = p6,
            Parent = p7
        }

        v5 = Modify(Instance.new("Configuration"), t3)
    end

    return v5
end

t1.AddSubDataLayer = AddSubDataLayer
t1.addSubDataLayer = AddSubDataLayer

local t4 = {}

setmetatable(t4, {
    __mode = "k"
})

local function MakeEasyConfiguration(p8) -- line: 64
    -- upvalues: v1 (copy), Modify (copy), t2 (copy), t4 (copy)
    if t4[p8] then
        return t4[p8]
    end

    local t6 = {}

    local function Get(p9) -- line: 70
        -- upvalues: p8 (copy)
        return p8:FindFirstChild(p9)
    end

    setmetatable(t6, {
        __index = function(_, p11) -- __index | line: 75
            -- upvalues: p8 (copy), Get (copy), v1 (copy), Modify (copy), t2 (copy)
            if not type(p11) == "string" then
                error("Only Indexing with strings is supported with easyConfiguration", 2)
            end

            local v6 = p11:lower()

            if v6 == "add" or v6 == "addvalue" then
                return function(p12, p13) -- line: 91
                    -- upvalues: p8 (copy), Modify (copy)
                    local v7 = not not (p13 and p13.Name and type(p13.Name) == "string")
                    local v8

                    if v7 then
                        v8 = p8:FindFirstChild(p13.Name)

                        if v8 and v8.ClassName ~= p12 then
                            print("[EasyConfiguration] - Invalid class '" .. v8.ClassName .. "' in configuration, being replaced by new data '" .. p12 .. "'")
                            v8:Destroy()
                            v8 = nil
                        end
                    else
                        error("[EasyConfiguration] - No values received in the add method of easy configuration. Please give a table of default properties including the name. ", 2)
                    end

                    if v8 then
                        return
                    end

                    local v9 = Instance.new(p12)

                    Modify(v9, p13)
                    v9.Parent = p8
                end
            end

            if v6 == "get" or v6 == "getvalue" then
                return function(p14) -- line: 112
                    -- upvalues: Get (copy)
                    return Get(p14)
                end
            end

            if v6 == "getcontainer" then
                return function(p15) -- line: 116
                    -- upvalues: Get (copy)
                    return Get(p15)
                end
            end

            local v10 = p8:FindFirstChild(p11)

            if v10 and t2[v10.ClassName] then
                return v10.Value
            end

            error("[EasyConfiguration] - " .. (v10 and "Object '" .. p11 .. "' was a " .. v1.getType(v10) .. " value, and not acceptable, so no return was given" or "Could not find Object '" .. p11 .. "' in the configuration"), 2)
        end,
        __newindex = function(_, p17, p18) -- __newindex | line: 128
            -- upvalues: p8 (copy), t2 (copy)
            if type(p17) == "string" then
                local v11 = p8:FindFirstChild(p17)

                if not (v11 and t2[v11.ClassName]) then
                    error("[EasyConfiguration] - Value '" .. p17 .. "' was not accepted, or wasn't in the configuration", 2)
                else
                    v11.Value = p18
                end
            else
                error("[EasyConfiguration] - Index with a string")
            end
        end
    })
    t4[p8] = t6

    return t6
end

t1.Make = MakeEasyConfiguration
t1.MakeEasyConfiguration = MakeEasyConfiguration

return t1
