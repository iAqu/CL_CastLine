-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local v1 = Color3.fromRGB(255, 0, 0)
local v2 = CFrame.new(0, (1 / 0), 0)
local t = {}

t.__index = t
t.__type = "RaycastHitboxVisualizerCache"
t._AdornmentInUse = {}
t._AdornmentInReserve = {}
function t._CreateAdornment(p1) --[[ _CreateAdornment | Line: 25 | Upvalues: v1 (copy), v2 (copy) ]]
	local _RaycastHitboxDebugLine = Instance.new("LineHandleAdornment")

	_RaycastHitboxDebugLine.Name = "_RaycastHitboxDebugLine"
	_RaycastHitboxDebugLine.Color3 = v1
	_RaycastHitboxDebugLine.Thickness = 4
	_RaycastHitboxDebugLine.Length = 0
	_RaycastHitboxDebugLine.CFrame = v2
	_RaycastHitboxDebugLine.Adornee = workspace.Terrain
	_RaycastHitboxDebugLine.Parent = workspace.Terrain

	return {
		LastUse = 0,
		Adornment = _RaycastHitboxDebugLine
	}
end
function t.GetAdornment(p1) --[[ GetAdornment | Line: 44 | Upvalues: t (copy) ]]
	if #t._AdornmentInReserve <= 0 then
		local v1 = t:_CreateAdornment()

		table.insert(t._AdornmentInReserve, v1)
	end

	local v2 = table.remove(t._AdornmentInReserve, 1)

	if v2 then
		v2.Adornment.Visible = true
		v2.LastUse = os.clock()
		table.insert(t._AdornmentInUse, v2)
	end

	return v2
end
function t.ReturnAdornment(p1, p2) --[[ ReturnAdornment | Line: 64 | Upvalues: v2 (copy), t (copy) ]]
	p2.Adornment.Length = 0
	p2.Adornment.Visible = false
	p2.Adornment.CFrame = v2
	table.insert(t._AdornmentInReserve, p2)
end
function t.Clear(p1) --[[ Clear | Line: 74 | Upvalues: t (copy) ]]
	for i = #t._AdornmentInReserve, 1, -1 do
		if t._AdornmentInReserve[i].Adornment then
			t._AdornmentInReserve[i].Adornment:Destroy()
		end

		table.remove(t._AdornmentInReserve, i)
	end
end

return t