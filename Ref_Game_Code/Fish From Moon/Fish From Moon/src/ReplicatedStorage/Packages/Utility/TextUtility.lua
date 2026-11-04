-- Server
-- Pingu (gabrielcidade)
-- February 14, 2023

-- Documentation
--[[

]]

-- Module requires
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local TableUtil = require(Knit.Util.TableUtil)

-- Constants

-- Variables

-- Module definition
local TextUtility = {}

function TextUtility:KnitInit() end

function TextUtility.CodePointSub(text, i, j)
	return string.sub(
		text,
		utf8.offset(text, i) or if i > 0 then #text + 1 else 0,
		if j == nil or j == -1 then #text else (utf8.offset(text, j + 1) or if j > 0 then #text + 1 else 0) - 1
	)
end

function TextUtility.Trim(text: string)
	local from = string.match(text, "^%s*()")

	return from > #text and "" or string.match(text, ".*%S", from)
end

function TextUtility.EditDistance(s, t, lim)
	local s_len, t_len = utf8.len(s), utf8.len(t)
	if lim and math.abs(s_len - t_len) >= lim then
		return lim
	end

	if type(s) == "string" then
		s = { string.byte(s, 1, s_len) }
	end

	if type(t) == "string" then
		t = { string.byte(t, 1, t_len) }
	end

	local min = math.min
	local num_columns = t_len + 1

	local d = table.create((s_len + 1) * (t_len + 1))

	for i = 0, s_len do
		d[i * num_columns] = i
	end

	for j = 0, t_len do
		d[j] = j
	end

	for i = 1, s_len do
		local i_pos = i * num_columns
		local best = lim
		for j = 1, t_len do
			local add_cost = (s[i] ~= t[j] and 1 or 0)
			local val =
				min(d[i_pos - num_columns + j] + 1, d[i_pos + j - 1] + 1, d[i_pos - num_columns + j - 1] + add_cost)

			d[i_pos + j] = val

			if i > 1 and j > 1 and s[i] == t[j - 1] and s[i - 1] == t[j] then
				d[i_pos + j] = min(val, d[i_pos - num_columns - num_columns + j - 2] + add_cost)
			end

			if lim and val < best then
				best = val
			end
		end

		if lim and best >= lim then
			return lim
		end
	end

	return d[#d]
end

function TextUtility.LevenshteinDistance(String1: string, String2: string)
	if String1 == String2 then
		return 0
	end

	local PossibleLength1 = utf8.len(String1)
	local PossibleLength2 = utf8.len(String2)

	if PossibleLength1 == nil or PossibleLength2 == nil then
		return 0
	end

	local Length1 = PossibleLength1 :: number
	local Length2 = PossibleLength2 :: number

	if Length1 == 0 then
		return Length2
	elseif Length2 == 0 then
		return Length1 :: number
	end

	local Matrix = {} -- Would love to use table.create for this, but it starts at 0.
	for Index = 0, Length1 do
		Matrix[Index] = { [0] = Index }
	end

	for Index = 0, Length2 do
		Matrix[0][Index] = Index
	end

	local Index = 1
	local IndexSub1

	for _, Code1 in utf8.codes(String1) do
		local Jndex = 1
		local JndexSub1

		for _, Code2 in utf8.codes(String2) do
			local Cost = Code1 == Code2 and 0 or 1
			IndexSub1 = Index - 1
			JndexSub1 = Jndex - 1

			Matrix[Index][Jndex] = math.min(
				Matrix[IndexSub1][Jndex] + 1,
				Matrix[Index][JndexSub1] + 1,
				Matrix[IndexSub1][JndexSub1] + Cost
			)
			Jndex += 1
		end

		Index += 1
	end

	return Matrix[Length1][Length2]
end

-- algorithm from Boatbomber
function TextUtility.RelevanceScore(searchTerm: string, name: string)
	if searchTerm == name then
		return 100
	end

	local numTerm, numName = utf8.len(searchTerm), utf8.len(name)

	local distance = TextUtility.EditDistance(searchTerm, name)
	local lengthDiff = math.abs(numName - numTerm)

	local startsWith = string.sub(name, 1, 1) == string.sub(searchTerm, 1, 1)

	local matchAmount = 0
	for i = 1, numTerm do
		if string.find(name, string.sub(searchTerm, 1, i), 1, true) then
			matchAmount = i
		else
			break
		end
	end

	local orderedSearchTermTable = table.create(numTerm)
	for i = 1, numTerm do
		table.insert(orderedSearchTermTable, `.*{string.sub(searchTerm, i, i)}`)
	end

	local orderedFind = string.find(name, table.concat(orderedSearchTermTable))

	local find, endFind, findPiece
	if matchAmount == numTerm then
		find, endFind = string.find(name, searchTerm, 1, true)
		findPiece = string.find(string.sub(name, endFind or 1, endFind or 1), "%w") and true or false
	end

	local score = (startsWith and 4 or 0)
		+ (find and (findPiece and 6 or 8) or 0)
		+ (orderedFind and 2 or 0)
		+ matchAmount
		+ (matchAmount / numTerm >= 0.75 and 4 or 0)
		+ ((distance or lengthDiff) - lengthDiff)

	return score
end

function TextUtility.Includes(searchTerm: string, text: string)
	return string.find(string.lower(text), string.lower(searchTerm), 1, true) ~= nil
end

function TextUtility.IncludesMultiple(searchTerm: string, texts: { string })
	for _, text in texts do
		if TextUtility.Includes(searchTerm, text) then
			return true
		end
	end
	
	return false	
end

return TextUtility
