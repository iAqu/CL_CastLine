-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local HttpService = game:GetService("HttpService")
local v1 = Random.new()
local function Copy(p1, p2) --[[ Copy | Line: 38 ]]
	if not p1 then
		return nil
	end
	if p2 then
		local function v1(p1_2_2_2_2) --[[ DeepCopy | Line: 44 | Upvalues: v1 (copy) ]]
			local v12 = table.clone(p1_2_2_2_2)
			for v2, v3 in v12 do
				if type(v3) == "table" then
					v12[v2] = v1(v3)
				end
			end
			return v12
		end
		return v1(p1)
	else
		return table.clone(p1)
	end
end
local function v2(p1, p2) --[[ Sync | Line: 84 | Upvalues: v2 (copy) ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	assert(if type(p2) == "table" then true else false, "Second argument must be a table")
	local v3 = table.clone(p1)
	for k, v in pairs(v3) do
		local v4, v5
		local v6 = p2[k]
		if v6 == nil then
			v3[k] = nil
			continue
		end
		if type(v) == type(v6) then
			if type(v) == "table" then
				v3[k] = v2(v, v6)
			end
			continue
		end
		if type(v6) == "table" then
			if v6 then
				v4 = function(p1_2_2_2_2) --[[ DeepCopy | Line: 44 | Upvalues: v4 (copy) ]]
					local v12 = table.clone(p1_2_2_2_2)
					for v2, v3 in v12 do
						if type(v3) == "table" then
							v12[v2] = v4(v3)
						end
					end
					return v12
				end
				v5 = v4(v6)
			else
				v5 = nil
			end
			v3[k] = v5
			continue
		end
		v3[k] = v6
	end
	for k, v in pairs(p2) do
		local v8, v9
		if v3[k] == nil then
			if type(v) == "table" then
				if v then
					v8 = function(p1_2_2_2_2) --[[ DeepCopy | Line: 44 | Upvalues: v8 (copy) ]]
						local v12 = table.clone(p1_2_2_2_2)
						for v2, v3 in v12 do
							if type(v3) == "table" then
								v12[v2] = v8(v3)
							end
						end
						return v12
					end
					v9 = v8(v)
				else
					v9 = nil
				end
				v3[k] = v9
				continue
			end
			v3[k] = v
		end
	end
	return v3
end
local function v3(p1, p2) --[[ Reconcile | Line: 156 | Upvalues: v3 (copy) ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	assert(if type(p2) == "table" then true else false, "Second argument must be a table")
	local v32 = table.clone(p1)
	for v8, v9 in p2 do
		local v4, v5, v6, v7
		local v10 = p1[v8]
		if v10 == nil then
			if type(v9) == "table" then
				if v9 then
					v4 = function(p1_2_2_2_2) --[[ DeepCopy | Line: 44 | Upvalues: v4 (copy) ]]
						local v12 = table.clone(p1_2_2_2_2)
						for v2, v3 in v12 do
							if type(v3) == "table" then
								v12[v2] = v4(v3)
							end
						end
						return v12
					end
					v5 = v4(v9)
				else
					v5 = nil
				end
				v32[v8] = v5
				continue
			end
			v32[v8] = v9
			continue
		end
		if type(v10) == "table" then
			if type(v9) == "table" then
				v32[v8] = v3(v10, v9)
				continue
			end
			if v10 then
				v6 = function(p1_2_2_2_2) --[[ DeepCopy | Line: 44 | Upvalues: v6 (copy) ]]
					local v12 = table.clone(p1_2_2_2_2)
					for v2, v3 in v12 do
						if type(v3) == "table" then
							v12[v2] = v6(v3)
						end
					end
					return v12
				end
				v7 = v6(v10)
			else
				v7 = nil
			end
			v32[v8] = v7
		end
	end
	return v32
end
local function SwapRemove(p1, p2) --[[ SwapRemove | Line: 209 ]]
	local v1 = #p1
	p1[p2] = p1[v1]
	p1[v1] = nil
end
local function SwapRemoveFirstValue(p1, p2) --[[ SwapRemoveFirstValue | Line: 234 ]]
	local v1 = table.find(p1, p2)
	if v1 then
		local v2 = #p1
		p1[v1] = p1[v2]
		p1[v2] = nil
	end
	return v1
end
local function Map(p1, p2) --[[ Map | Line: 262 ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	assert(if type(p2) == "function" then true else false, "Second argument must be a function")
	local v3 = table.create(#p1)
	for v4, v5 in p1 do
		v3[v4] = p2(v5, v4, p1)
	end
	return v3
end
local function Filter(p1, p2) --[[ Filter | Line: 292 ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	assert(if type(p2) == "function" then true else false, "Second argument must be a function")
	local v3 = table.create(#p1)
	if #p1 > 0 then
		local count = 0
		for v4, v5 in p1 do
			if p2(v5, v4, p1) then
				count = count + 1
				v3[count] = v5
			end
		end
	else
		for v6, v7 in p1 do
			if p2(v7, v6, p1) then
				v3[v6] = v7
			end
		end
	end
	return v3
end
local function Closest(p1, p2) --[[ Closest | Line: 314 ]]
	assert(if typeof(p1) == "Vector3" then true else false, "First argument must be a Vector3.")
	assert(if type(p2) == "table" then true else false, "Second argument must be a table.")
	local v3 = (1 / 0)
	local v4 = nil
	for v5, v6 in p2 do
		local Magnitude = (p1 - (v6:IsA("Model") and v6:GetPivot().Position or v6.Position)).Magnitude
		if Magnitude < v3 then
			v3 = Magnitude
			v4 = v6
		end
	end
	return v4, v3
end
local function Reduce(p1, p2, p3) --[[ Reduce | Line: 354 ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	assert(if type(p2) == "function" then true else false, "Second argument must be a function")
	if #p1 > 0 then
		local v3, v4
		if p3 == nil then
			v3 = p1[1]
			v4 = 2
		else
			v4 = 1
			v3 = p3
		end
		for i = v4, #p1 do
			v3 = p2(v3, p1[i], i, p1)
		end
		return v3
	else
		local v6, v7
		if p3 == nil then
			local v8 = next(p1)
			v6 = v8
			v7 = v8
		else
			v6 = nil
			v7 = p3
		end
		for v9, v10 in next, p1, v6 do
			v7 = p2(v7, v10, v9, p1)
		end
		return v7
	end
end
local function Assign(p1, ...) --[[ Assign | Line: 397 ]]
	local v1 = table.clone(p1)
	for v2, v3 in { ... } do
		for v4, v5 in v3 do
			v1[v4] = v5
		end
	end
	return v1
end
local function Extend(p1, p2) --[[ Extend | Line: 426 ]]
	local v1 = table.clone(p1)
	for v2, v3 in p2 do
		table.insert(v1, v3)
	end
	return v1
end
local function Reverse(p1) --[[ Reverse | Line: 451 ]]
	local v1 = #p1
	local v2 = table.create(v1)
	for i = 1, v1 do
		v2[i] = p1[v1 - i + 1]
	end
	return v2
end
local function Shuffle(p1, p2) --[[ Shuffle | Line: 478 | Upvalues: v1 (copy) ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	local v2 = table.clone(p1)
	local v3 = if typeof(p2) == "Random" then p2 else v1
	for i = #p1, 2, -1 do
		local v4 = v3:NextInteger(1, i)
		local v6 = v2[i]
		v2[i] = v2[v4]
		v2[v4] = v6
	end
	return v2
end
local function Sample(p1, p2, p3) --[[ Sample | Line: 508 | Upvalues: v1 (copy) ]]
	assert(if type(p1) == "table" then true else false, "First argument must be a table")
	assert(if type(p2) == "number" then true else false, "Second argument must be a number")
	local v3 = table.clone(p1)
	local v4 = table.create(p2)
	local v5 = if typeof(p3) == "Random" then p3 else v1
	local v6 = #p1
	local v7 = math.clamp(p2, 1, v6)
	for i = 1, v7 do
		local v9 = v5:NextInteger(i, v6)
		local v11 = v3[i]
		v3[i] = v3[v9]
		v3[v9] = v11
	end
	table.move(v3, 1, v7, 1, v4)
	return v4
end
local function Flat(p1, p2) --[[ Flat | Line: 545 ]]
	local v1 = if type(p2) == "number" then p2 else 1
	local v2 = table.create(#p1)
	local function v3(p1_2, p2_2) --[[ Scan | Line: 548 | Upvalues: v1 (copy), v3 (copy), v2 (copy) ]]
		for v12, v22 in p1_2 do
			if type(v22) == "table" and p2_2 < v1 then
				v3(v22, p2_2 + 1)
				continue
			end
			table.insert(v2, v22)
		end
	end
	v3(p1, 0)
	return v2
end
local function FlatMap(p1, p2) --[[ FlatMap | Line: 582 | Upvalues: Map (copy) ]]
	local v1 = Map(p1, p2)
	local v2 = table.create(#v1)
	local v3 = 1
	local function v4(p1_2, p2_2) --[[ Scan | Line: 548 | Upvalues: v3 (copy), v4 (copy), v2 (copy) ]]
		for v12, v22 in p1_2 do
			if type(v22) == "table" and p2_2 < v3 then
				v4(v22, p2_2 + 1)
				continue
			end
			table.insert(v2, v22)
		end
	end
	v4(v1, 0)
	return v2
end
local function Keys(p1) --[[ Keys | Line: 608 ]]
	local v1 = table.create(#p1)
	for v2 in p1 do
		table.insert(v1, v2)
	end
	return v1
end
local function Values(p1) --[[ Values | Line: 638 ]]
	local v1 = table.create(#p1)
	for v2, v3 in p1 do
		table.insert(v1, v3)
	end
	return v1
end
local function Find(p1, p2) --[[ Find | Line: 677 ]]
	for v1, v2 in p1 do
		if p2(v2, v1, p1) then
			return v2, v1
		end
	end
	return nil, nil
end
local function Every(p1, p2) --[[ Every | Line: 706 ]]
	for v1, v2 in p1 do
		if not p2(v2, v1, p1) then
			return false
		end
	end
	return true
end
local function Some(p1, p2) --[[ Some | Line: 735 ]]
	for v1, v2 in p1 do
		if p2(v2, v1, p1) then
			return true
		end
	end
	return false
end
local function Truncate(p1, p2) --[[ Truncate | Line: 761 ]]
	local v1 = #p1
	local v2 = math.clamp(p2, 1, v1)
	if v2 == v1 then
		return table.clone(p1)
	else
		return table.move(p1, 1, v2, 1, table.create(v2))
	end
end
local function Zip(...) --[[ Zip | Line: 794 ]]
	assert(select("#", ...) > 0, "Must supply at least 1 table")
	local function ZipIteratorArray(p1, p2) --[[ ZipIteratorArray | Line: 796 ]]
		local v1 = p2 + 1
		local t = {}
		for v2, v3 in p1 do
			local v4 = v3[v1]
			if v4 == nil then
				return nil, nil
			end
			t[v2] = v4
		end
		return v1, t
	end
	local function ZipIteratorMap(p1, p2) --[[ ZipIteratorMap | Line: 809 ]]
		local t = {}
		for v1, v2 in p1 do
			local v3 = next(v2, p2)
			if v3 == nil then
				return nil, nil
			end
			t[v1] = v3
		end
		return p2, t
	end
	local t = { ... }
	if #t[1] > 0 then
		return ZipIteratorArray, t, 0
	else
		return ZipIteratorMap, t, nil
	end
end
local function Lock(p1) --[[ Lock | Line: 847 ]]
	local function v1(p1) --[[ Freeze | Line: 848 | Upvalues: v1 (copy) ]]
		for k, v in pairs(p1) do
			if type(v) == "table" then
				p1[k] = v1(v)
			end
		end
		return table.freeze(p1)
	end
	return v1(p1)
end
local function GetProperties(p1, p2) --[[ GetProperties | Line: 860 ]]
	local t = {}
	for v1, v2 in p1 do
		t[v1] = p2(v2)
	end
	return t
end
local function IsEmpty(p1) --[[ IsEmpty | Line: 888 ]]
	if p1 == nil then
		return true
	end
	return next(p1) == nil
end
local function EncodeJSON(p1) --[[ EncodeJSON | Line: 901 | Upvalues: HttpService (copy) ]]
	return HttpService:JSONEncode(p1)
end
local function DecodeJSON(p1) --[[ DecodeJSON | Line: 913 | Upvalues: HttpService (copy) ]]
	return HttpService:JSONDecode(p1)
end
local function Count(p1) --[[ Count | Line: 925 ]]
	local count = 0
	for v1 in p1 do
		count = count + 1
	end
	return count
end
local function v4(p1) --[[ Clear | Line: 941 | Upvalues: v4 (copy) ]]
	if typeof(p1) ~= "table" then
		return nil
	end
	for v1, v2 in p1 do
		if typeof(v2) == "table" then
			v4(v2)
		end
		p1[v1] = nil
	end
	return nil
end
local function GetWrappedIndex(p1, p2, p3) --[[ GetWrappedIndex | Line: 964 ]]
	local v1 = #p1
	local v2 = p2 % v1 + 1
	if p3 then
		return v2, (v2 - 2) % v1 + 1
	else
		return v2
	end
end
local function Sort(p1, p2) --[[ Sort | Line: 982 ]]
	table.sort(p1, p2)
	return p1
end
local function IsDictionary(p1) --[[ IsDictionary | Line: 995 ]]
	if type(p1) ~= "table" then
		return "Not a table"
	end
	local v1 = true
	local v2 = false
	for k, v in pairs(p1) do
		if type(k) ~= "number" or (k < 1 or math.floor(k) ~= k) then
			v1 = false
			v2 = true
			break
		end
	end
	if v1 then
		local count = 1
		for i, v in ipairs(p1) do
			if i == count then
				count = count + 1
			else
				v1 = false
				v2 = true
				break
			end
		end
	end
	if v1 and not v2 then
		return false
	end
	return true
end
local function v5(p1, p2) --[[ IsEqual | Line: 1042 | Upvalues: IsDictionary (copy), v5 (copy) ]]
	if p1 == nil or p2 == nil then
		return if p1 == nil then p2 == nil else false
	else
		assert(if typeof(p1) == "table" then if typeof(p2) == "table" then true else false else false, "Arguments must be a table value!")
		local v3 = if p1 == nil then true elseif next(p1) == nil then true else false
		if not (v3 or (if p2 == nil then true elseif next(p2) == nil then true else false)) then
			if IsDictionary(p1) ~= IsDictionary(p2) then
				return false
			end
			local count = 0
			for v52 in p1 do
				count = count + 1
			end
			count_2 = 0
			v6 = count
			for v7 in p2 do
				count_2 = count_2 + 1
			end
			if v6 ~= count_2 then
				return false
			end
			for k, v in pairs(p1) do
				if k ~= "Quantity" then
					if p2[k] == nil then
						return false
					end
					if typeof(v) == "table" then
						if not v5(v, p2[k]) then
							return false
						end
						continue
					end
					if p2[k] ~= v then
						return false
					end
				end
			end
			return true
		end
		local v8 = if p1 == nil then true elseif next(p1) == nil then true else false
		return v8 == (if p2 == nil then true elseif next(p2) == nil then true else false)
	end
end
local function IntersectDict(p1, p2) --[[ IntersectDict | Line: 1068 ]]
	local t = {}
	for v1 in p1 do
		if not p2[v1] then
			table.insert(t, v1)
		end
	end
	return t
end
local function IsNestedTable(p1) --[[ IsNestedTable | Line: 1091 | Upvalues: IsDictionary (copy) ]]
	if typeof(p1) ~= "table" then
		return false
	end
	if IsDictionary(p1) then
		return
	end
	for v1, v2 in p1 do
		return typeof(v2) == "table"
	end
end
t.IsEqual = v5
t.IsDictionary = IsDictionary
t.Sort = Sort
t.GetWrappedIndex = GetWrappedIndex
t.Clear = v4
t.Count = Count
t.Copy = Copy
t.Closest = Closest
t.Sync = v2
t.Reconcile = v3
t.GetProperties = GetProperties
t.SwapRemove = SwapRemove
t.SwapRemoveFirstValue = SwapRemoveFirstValue
t.Map = Map
t.Filter = Filter
t.Reduce = Reduce
t.Assign = Assign
t.Extend = Extend
t.Reverse = Reverse
t.Shuffle = Shuffle
t.Sample = Sample
t.Flat = Flat
t.FlatMap = FlatMap
t.Keys = Keys
t.Values = Values
t.Find = Find
t.Every = Every
t.Some = Some
t.Truncate = Truncate
t.Zip = Zip
t.Lock = Lock
t.IsEmpty = IsEmpty
t.EncodeJSON = EncodeJSON
t.DecodeJSON = DecodeJSON
t.IntersectDictionary = IntersectDict
t.IsNestedTable = IsNestedTable
return t