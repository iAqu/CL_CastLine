-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local t = {
	serialize = function(p1) --[[ serialize | Line: 6 ]]
		local v1 = buffer.create(#p1 * 8)
		for v2, v3 in p1 do
			buffer.writef64(v1, (v2 - 1) * 8, v3)
		end
		return v1
	end,
	deserialize = function(p1) --[[ deserialize | Line: 16 ]]
		local v1 = typeof(p1) == "string" and buffer.fromstring(p1) or p1
		local t = {}
		for i = 0, buffer.len(v1) / 8 - 1 do
			table.insert(t, (buffer.readf64(v1, i * 8)))
		end
		return t
	end,
	isLocalFlipbook = function(p1) --[[ isLocalFlipbook | Line: 29 | Upvalues: RunService (copy), CollectionService (copy) ]]
		if not RunService:IsStudio() then
			return false
		end
		for v1, v2 in CollectionService:GetTags(p1) do
			if v2:match("^_local_flipbook_") then
				return true
			end
		end
		return false
	end
}
function t.getTexturePrefix(p1) --[[ getTexturePrefix | Line: 43 | Upvalues: t (copy) ]]
	if t.isLocalFlipbook(p1) then
		return "rbxtemp://"
	else
		return "rbxassetid://"
	end
end
function t.getFlipbookData(p1) --[[ getFlipbookData | Line: 47 | Upvalues: t (copy) ]]
	if not p1:GetAttribute("FlipbookEnabled") then
		return nil
	end
	local v1 = p1:GetAttribute("FlipbookTextures")
	if not v1 then
		return nil
	end
	local v2 = t.deserialize(v1)
	if #v2 == 0 then
		return nil
	else
		return v2
	end
end
function t.getChangeDuration(p1) --[[ getChangeDuration | Line: 81 ]]
	local duration = p1.duration
	if p1.ref:GetAttribute("SyncDuration") then
		duration = p1.effectDuration
	end
	return duration
end
function t.createUpdateCallback(p1) --[[ createUpdateCallback | Line: 91 | Upvalues: t (copy) ]]
	local v1 = t.getTexturePrefix(p1.ref)
	return function(p12, p2) --[[ Line: 94 | Upvalues: p1 (copy), v1 (copy) ]]
		p1.setTexture((("%*%*"):format(v1, p1.frames[math.max(math.round(#p1.frames * p12), 1)])))
		return p2 * p1.getSpeed()
	end
end
return t