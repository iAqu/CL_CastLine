-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local Touch = Enum.UserInputType.Touch
local Keyboard = Enum.UserInputType.Keyboard
local v1 = nil
local t = {}
v1 = {
	Current = "MouseKeyboard",
	Observe = function(p1) --[[ Observe | Line: 83 | Upvalues: t (copy), v1 (ref) ]]
		if table.find(t, p1) then
			error("function already subscribed", 2)
		end
		local v12 = t
		table.insert(v12, p1)
		task.spawn(p1, v1.Current)
		return function() --[[ Line: 91 | Upvalues: t (ref), p1 (copy) ]]
			local v1 = table.find(t, p1)
			if v1 then
				local v2 = #t
				t[v1] = t[v2]
				t[v2] = nil
			end
		end
	end
}
local function SetPreferred(p1) --[[ SetPreferred | Line: 101 | Upvalues: v1 (ref), t (copy) ]]
	if p1 ~= v1.Current then
		v1.Current = p1
		for v12, v2 in t do
			task.spawn(v2, p1)
		end
	end
end
local function DeterminePreferred(p1) --[[ DeterminePreferred | Line: 112 | Upvalues: Touch (copy), SetPreferred (copy), Keyboard (copy) ]]
	if p1 == Touch then
		SetPreferred("Touch")
	else
		if p1 ~= Keyboard then
			if string.sub(p1.Name, 1, 5) == "Mouse" then
				SetPreferred("MouseKeyboard")
				return
			end
			if string.sub(p1.Name, 1, 7) == "Gamepad" then
				SetPreferred("Gamepad")
			end
			return
		end
		SetPreferred("MouseKeyboard")
	end
end
DeterminePreferred(UserInputService:GetLastInputType())
UserInputService.LastInputTypeChanged:Connect(DeterminePreferred)
return v1