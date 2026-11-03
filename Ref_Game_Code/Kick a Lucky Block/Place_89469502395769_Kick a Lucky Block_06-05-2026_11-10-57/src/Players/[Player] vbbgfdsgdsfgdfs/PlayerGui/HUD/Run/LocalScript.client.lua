-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local TweenService = game:GetService("TweenService")
local v2 = nil
local v3 = Color3.fromRGB(77, 0, 1)
local v4 = Color3.fromRGB(39, 0, 1)
local function OnVisible() --[[ OnVisible | Line: 8 | Upvalues: v2 (ref), v1 (copy), v3 (copy), TweenService (copy), v4 (copy) ]]
	if v2 then
		v2:Cancel()
		v2 = nil
	end
	if v1.Visible then
		v1.BackgroundColor3 = v3
		v2 = TweenService:Create(v1, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			BackgroundColor3 = v4
		})
		v2:Play()
	end
end
v1:GetPropertyChangedSignal("Visible"):Connect(OnVisible)