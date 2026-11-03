-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local v1 = script.Parent
local TweenService = game:GetService("TweenService")
local v2 = nil
local function OnVisible() --[[ OnVisible | Line: 6 | Upvalues: v2 (ref), v1 (copy), TweenService (copy) ]]
	if v2 then
		v2:Cancel()
		v2 = nil
	end
	if v1.Visible then
		v1.ImageTransparency = 0.85
		v2 = TweenService:Create(v1, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
			ImageTransparency = 0.55
		})
		v2:Play()
	end
end
v1:GetPropertyChangedSignal("Visible"):Connect(OnVisible)