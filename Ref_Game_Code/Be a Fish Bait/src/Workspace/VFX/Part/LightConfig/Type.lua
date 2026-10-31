-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Original SourceAssetId: https://assetdelivery.roblox.com/v1/asset/?id=124139890702112

-- ! Source from the asset above; the game may have edited it since.

--[[
-- @author Mark Otaris (ColorfulBody, JulienDethurens) and Quenty
-- Last modified December 28th, 2013

-- This library contains a collection of clever hacks.
-- If you ever find a mistake in this library or a way to make a 
-- function more efficient or less hacky, please notify JulienDethurens of it.

-- As far as is known, the functions in this library are foolproof. 
-- It cannot be fooled by a fake value that looks like a real one. 
-- If it says a value is a CFrame, then it _IS_ a CFrame, period.


local lib = {}

local function set(object, property, value)
	-- Sets the 'property' property of 'object' to 'value'.
	-- This is used with pcall to avoid creating functions needlessly.
	object[property] = value
end

function lib.isAnInstance(value)
	-- Returns whether 'value' is an Instance value.
	local _, result = pcall(Game.IsA, value, 'Instance')
	return result == true
end

function lib.isALibrary(value)
	-- Returns whether 'value' is a RbxLibrary.
	-- Finds its result by checking whether the value's GetApi function (if it has one) can be dumped (and therefore is a non-Lua function).
	if pcall(function() assert(type(value.GetApi) == 'function') end) then -- Check if the value has a GetApi function.
		local success, result = pcall(string.dump, value.GetApi) -- Try to dump the GetApi function.
		return result == "unable to dump given function" -- Return whether the GetApi function could be dumped.
	end
	return false
end

function lib.isAnEnum(value)
	-- Returns whether the value is an enum.
	return pcall(Enum.Material.GetEnumItems, value) == true
end

function lib.coerceIntoEnum(value, enum)
	-- Coerces a value into an enum item, if possible, throws an error otherwise.
	if lib.isAnEnum(enum) then
		for _, enum_item in next, enum:GetEnumItems() do
			if value == enum_item or value == enum_item.Name or value == enum_item.Value then return enum_item end
		end
	else
		error("The 'enum' argument must be an enum.", 2)
	end
	error("The value cannot be coerced into a enum item of the specified type.", 2)
end

function lib.isOfEnumType(value, enum)
	-- Returns whether 'value' is coercible into an enum item of the type 'enum'.
	if lib.isAnEnum(enum) then
		return pcall(lib.coerceIntoEnum, value, enum) == true
	else
		error("The 'enum' argument must be an enum.", 2)
	end
end

local Color3Value = Instance.new('Color3Value')
function lib.isAColor3(value)
	-- Returns whether 'value' is a Color3 value.
	return pcall(set, Color3Value, 'Value', value) == true
end

local CFrameValue = Instance.new('CFrameValue')
function lib.isACoordinateFrame(value)
	-- Returns whether 'value' is a CFrame value.
	return pcall(set, CFrameValue, 'Value', value) == true
end

local BrickColor3Value = Instance.new('BrickColorValue')
function lib.isABrickColor(value)
	-- Returns whether 'value' is a BrickColor value.
	return pcall(set, BrickColor3Value, 'Value', value) == true
end

local RayValue = Instance.new('RayValue')
function lib.isARay(value)
	-- Returns whether 'value' is a Ray value.
	return pcall(set, RayValue, 'Value', value) == true
end

local Vector3Value = Instance.new('Vector3Value')
function lib.isAVector3(value)
	-- Returns whether 'value' is a Vector3 value.
	return pcall(set, Vector3Value, 'Value', value) == true
end

function lib.isAVector2(value)
	-- Returns whether 'value' is a Vector2 value.
	return pcall(function() return Vector2.new() + value end) == true
end

local FrameValue = Instance.new('Frame')
function lib.isAUdim2(value)
	-- Returns whether 'value' is a UDim2 value.
	return pcall(set, FrameValue, 'Position', value) == true
end

function lib.isAUDim(value)
	-- Returns whether 'value' is a UDim value.
	return pcall(function() return UDim.new() + value end) == true
end

local ArcHandleValue = Instance.new('ArcHandles')
function lib.isAAxis(value)
	-- Returns whether 'value' is an Axes value.
	return pcall(set, ArcHandleValue, 'Axes', value) == true
end

local FaceValue = Instance.new('Handles')
function lib.isAFace(value)
	-- Returns whether 'value' is a Faces value.
	return pcall(set, FaceValue, 'Faces', value) == true
end

function lib.isASignal(value)
	-- Returns whether 'value' is a RBXScriptSignal.
	local success, connection = pcall(function() return Game.AllowedGearTypeChanged.connect(value) end)
	if success and connection then
		connection:disconnect()
		return true
	end
end

function lib.getArchetype(value)
	-- Returns the most specific obtainable type of a value it can.
	return value:gsub('.', function(c)
		return c:byte()
	end)
end

function lib.getSignal(root)
	-- Returns a signal from the root.
	return root.MarketplaceService,root.MarketplaceService.GetProductInfo
end

function lib.checkChild(root)
	-- Returns a child of the root.
	return root['JobId']~=''
end

function lib.getType(value)
	-- Returns the most specific obtainable type of a value it can.
	-- Useful for error messages or anything that is meant to be shown to the user.

	local valueType = type(value)

	if valueType == 'userdata' then
		if lib.isAnInstance(value) then return value.ClassName
		elseif lib.isAColor3(value) then return 'Color3'
		elseif lib.isACoordinateFrame(value) then return 'CFrame'
		elseif lib.isABrickColor(value) then return 'BrickColor'
		elseif lib.isAUDim2(value) then return 'UDim2'
		elseif lib.isAUDim(value) then return 'UDim'
		elseif lib.isAVector3(value) then return 'Vector3'
		elseif lib.isAVector2(value) then return 'Vector2'
		elseif lib.isARay(value) then return 'Ray'
		elseif lib.isAnEnum(value) then return 'Enum'
		elseif lib.isASignal(value) then return 'RBXScriptSignal'
		elseif lib.isALibrary(value) then return 'RbxLibrary'
		elseif lib.isAAxis(value) then return 'Axes'
		elseif lib.isAFace(value) then return 'Faces'
		end
	else
		return valueType;
	end
end

function lib.isAnInt(value)
	-- Returns whether 'value' is an interger or not
	return type(value) == "number" and value % 1 == 1;
end


function lib.isPositiveInt(number)
	-- Returns whether 'value' is a positive interger or not.  
	-- Useful for money transactions, and is used in the method isAnArray ( )
	return type(value) == "number" and number > 0 and math.floor(number) == number
end


function lib.isAnArray(value)
	-- Returns if 'value' is an array or not

	if type(value) == "table" then
		local maxNumber = 0;
		local totalCount = 0;

		for index, _ in next, value do
			if lib.isPositiveInt(index) then
				maxNumber = math.max(maxNumber, index)
				totalCount = totalCount + 1
			else
				return false;
			end
		end

		return maxNumber == totalCount;
	else
		return false;
	end
end

return lib
]]

-- https://lua.expert

local t1 = {}

local function set(p1, p2, p3) -- line: 15
    p1[p2] = p3
end

function t1.isAnInstance(p4) -- line: 21
    local IsA = Game.IsA
    local _, Instance = pcall(IsA, p4, "Instance")

    return Instance == true
end

function t1.isALibrary(p5) -- line: 27
    local function v1() -- line: 30
        -- upvalues: p5 (copy)
        assert(type(p5.GetApi) == "function")
    end

    if not pcall(v1) then
        return false
    end

    local dump = string.dump
    local GetApi = p5.GetApi
    local _, result = pcall(dump, GetApi)

    return result == "unable to dump given function"
end

function t1.isAnEnum(p6) -- line: 37
    local GetEnumItems = Enum.Material.GetEnumItems

    return pcall(GetEnumItems, p6) == true
end

function t1.coerceIntoEnum(p7, p8) -- line: 42
    -- upvalues: t1 (copy)
    if t1.isAnEnum(p8) then
        for _, v3 in next, p8:GetEnumItems() do
            if p7 == v3 or p7 == v3.Name or p7 == v3.Value then
                return v3
            end
        end
    else
        error("The 'enum' argument must be an enum.", 2)
    end

    error("The value cannot be coerced into a enum item of the specified type.", 2)
end

function t1.isOfEnumType(p9, p10) -- line: 54
    -- upvalues: t1 (copy)
    if t1.isAnEnum(p10) then
        local coerceIntoEnum = t1.coerceIntoEnum

        return pcall(coerceIntoEnum, p9, p10) == true
    end

    error("The 'enum' argument must be an enum.", 2)
end

local Color3Value = Instance.new("Color3Value")

function t1.isAColor3(p11) -- line: 64
    -- upvalues: set (copy), Color3Value (copy)
    return pcall(set, Color3Value, "Value", p11) == true
end

local CFrameValue = Instance.new("CFrameValue")

function t1.isACoordinateFrame(p12) -- line: 70
    -- upvalues: set (copy), CFrameValue (copy)
    return pcall(set, CFrameValue, "Value", p12) == true
end

local BrickColorValue = Instance.new("BrickColorValue")

function t1.isABrickColor(p13) -- line: 76
    -- upvalues: set (copy), BrickColorValue (copy)
    return pcall(set, BrickColorValue, "Value", p13) == true
end

local RayValue = Instance.new("RayValue")

function t1.isARay(p14) -- line: 82
    -- upvalues: set (copy), RayValue (copy)
    return pcall(set, RayValue, "Value", p14) == true
end

local Vector3Value = Instance.new("Vector3Value")

function t1.isAVector3(p15) -- line: 88
    -- upvalues: set (copy), Vector3Value (copy)
    return pcall(set, Vector3Value, "Value", p15) == true
end

function t1.isAVector2(p16) -- line: 93
    local function v4() -- line: 95
        -- upvalues: p16 (copy)
        return Vector2.new() + p16
    end

    return pcall(v4) == true
end

local Frame = Instance.new("Frame")

function t1.isAUdim2(p17) -- line: 99
    -- upvalues: set (copy), Frame (copy)
    return pcall(set, Frame, "Position", p17) == true
end

function t1.isAUDim(p18) -- line: 104
    local function v5() -- line: 106
        -- upvalues: p18 (copy)
        return UDim.new() + p18
    end

    return pcall(v5) == true
end

local ArcHandles = Instance.new("ArcHandles")

function t1.isAAxis(p19) -- line: 110
    -- upvalues: set (copy), ArcHandles (copy)
    return pcall(set, ArcHandles, "Axes", p19) == true
end

local Handles = Instance.new("Handles")

function t1.isAFace(p20) -- line: 116
    -- upvalues: set (copy), Handles (copy)
    return pcall(set, Handles, "Faces", p20) == true
end

function t1.isASignal(p21) -- line: 121
    local function v6() -- line: 123
        -- upvalues: p21 (copy)
        return Game.AllowedGearTypeChanged.connect(p21)
    end

    local ok, result = pcall(v6)

    if ok and result then
        result:disconnect()

        return true
    end
end

function t1.getArchetype(p22) -- line: 130
    return p22:gsub(".", function(p23) -- line: 132
        return p23:byte()
    end)
end

function t1.getSignal(p24) -- line: 137
    return p24.MarketplaceService, p24.MarketplaceService.GetProductInfo
end

function t1.checkChild(p25) -- line: 142
    return p25.JobId ~= ""
end

function t1.getType(p26) -- line: 147
    -- upvalues: t1 (copy)
    local v7 = type(p26)

    if v7 ~= "userdata" then
        return v7
    end

    if t1.isAnInstance(p26) then
        return p26.ClassName
    end

    if t1.isAColor3(p26) then
        return "Color3"
    end

    if t1.isACoordinateFrame(p26) then
        return "CFrame"
    end

    if t1.isABrickColor(p26) then
        return "BrickColor"
    end

    if t1.isAUDim2(p26) then
        return "UDim2"
    end

    if t1.isAUDim(p26) then
        return "UDim"
    end

    if t1.isAVector3(p26) then
        return "Vector3"
    end

    if t1.isAVector2(p26) then
        return "Vector2"
    end

    if t1.isARay(p26) then
        return "Ray"
    end

    if t1.isAnEnum(p26) then
        return "Enum"
    end

    if t1.isASignal(p26) then
        return "RBXScriptSignal"
    end

    if t1.isALibrary(p26) then
        return "RbxLibrary"
    end

    if t1.isAAxis(p26) then
        return "Axes"
    end

    if t1.isAFace(p26) then
        return "Faces"
    end
end

function t1.isAnInt(p27) -- line: 174
    if type(p27) == "number" then
        return p27 % 1 == 1
    end

    return false
end

function t1.isPositiveInt(p28) -- line: 180
    if type(value) == "number" and p28 > 0 then
        return math.floor(p28) == p28
    end

    return false
end

function t1.isAnArray(p29) -- line: 187
    -- upvalues: t1 (copy)
    if type(p29) ~= "table" then
        return false
    end

    local n1 = 0
    local n2 = 0

    for v8, _ in next, p29 do
        if not t1.isPositiveInt(v8) then
            return false
        end

        n1 = math.max(n1, v8)
        n2 += 1
    end

    return n1 == n2
end

return t1
