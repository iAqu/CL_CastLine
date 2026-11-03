-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {}
local t2 = {
	DefaultDeveloper = true,
	DefaultAdmin = true,
	DefaultSeniorStaff = true,
	DefaultStaff = true
}
local t3 = {
	ban = {
		Danger = true,
		Group = "Moderation"
	},
	kick = {
		Danger = true,
		Group = "Moderation"
	},
	globalmessage = {
		Danger = true,
		Group = "Messaging"
	},
	globalluck = {
		Group = "Events"
	},
	globalevent = {
		Group = "Events"
	},
	addevent = {
		Group = "Events"
	},
	additem = {
		Group = "Items"
	},
	giveability = {
		Group = "Items"
	},
	addcoins = {
		Group = "Economy"
	},
	addabilityrolls = {
		Group = "Economy"
	},
	givegift = {
		Group = "Economy"
	},
	offlinegift = {
		Group = "Economy"
	},
	givebaits = {
		Group = "Items"
	},
	allquests = {
		Group = "Utility"
	},
	tpisland = {
		Group = "Utility"
	}
}
local function ExtractOptions(p1) --[[ ExtractOptions | Line: 57 ]]
	if not p1 or p1 == "" then
		return nil
	end
	local v1 = p1:match(":%s*(.+)$") or p1
	if v1:find("|") then
		local t = {}
		for v2 in v1:gmatch("[^|]+") do
			local v3 = v2:match("^%s*(.-)%s*$")
			if v3 and v3 ~= "" then
				table.insert(t, v3)
			end
		end
		if #t >= 2 then
			return t
		end
	end
	if not v1:find(",") then
		return nil
	end
	local v4 = true
	local t = {}
	for v5 in v1:gmatch("[^,]+") do
		local v6 = v5:match("^%s*(.-)%s*$")
		if v6 and v6 ~= "" then
			if #v6 > 40 or v6:find("%s%s") then
				v4 = false
				break
			end
			table.insert(t, v6)
		end
	end
	if v4 and #t >= 2 then
		return t
	else
		return nil
	end
end
local function MapFieldType(p1, p2) --[[ MapFieldType | Line: 119 ]]
	if p2 then
		return "select"
	end
	if p1 == "player" or p1 == "players" then
		return "player"
	end
	if p1 == "number" or p1 == "integer" then
		return "number"
	else
		return "text"
	end
end
local function ArgToField(p1) --[[ ArgToField | Line: 130 | Upvalues: ExtractOptions (copy) ]]
	local v1 = p1.Name or "Argument"
	local v2 = ExtractOptions(p1.Description)
	local Type = p1.Type
	local v3 = if v2 then "select" elseif Type == "player" or Type == "players" then "player" elseif Type == "number" or Type == "integer" then "number" else "text"
	local v4 = v1:lower()
	if v3 == "text" and (v4:find("message") or v4:find("reason")) then
		v3 = "textarea"
	end
	local t = {
		Key = v1,
		Label = v1,
		Type = v3
	}
	t.Placeholder = if v2 then nil else p1.Description
	t.Options = v2
	t.Default = p1.Default
	t.Optional = p1.Optional == true
	return t
end
local function ConvertCommand(p1) --[[ ConvertCommand | Line: 155 | Upvalues: t2 (copy), ArgToField (copy), t3 (copy) ]]
	if not t2[p1.Group] then
		return nil
	end
	local t = {}
	local t4 = {}
	for v2, v3 in p1.Args or {} do
		local v4 = ArgToField(v3)
		table.insert(t, v4)
		table.insert(t4, v4.Key)
	end
	local v5 = p1.Name:gsub("(%l)(%u)", "%1 %2")
	local v6 = v5:sub(1, 1):upper() .. v5:sub(2):lower()
	local t5 = {
		Group = "Other",
		Danger = false,
		Id = p1.Name:lower(),
		Label = v6,
		Description = p1.Description or "",
		CmdrName = p1.Name,
		ArgOrder = t4,
		Fields = t
	}
	local v7 = t3[p1.Name:lower()]
	if v7 then
		for v8, v9 in v7 do
			t5[v8] = v9
		end
	end
	return t5
end
function t.BuildCommands(p1) --[[ BuildCommands | Line: 200 | Upvalues: ConvertCommand (copy) ]]
	local t = {}
	local t2 = {}
	for v1, v2 in p1.Registry.CommandsArray do
		if not t[v2.Name] then
			t[v2.Name] = true
			local v3 = ConvertCommand(v2)
			if v3 then
				table.insert(t2, v3)
			end
		end
	end
	table.sort(t2, function(p1, p2) --[[ Line: 221 ]]
		if p1.Group == p2.Group then
			return p1.Label < p2.Label
		else
			return p1.Group < p2.Group
		end
	end)
	return t2
end
return t