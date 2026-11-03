-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local KickTip = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD").KickTip
return {
	ShowTip = function(p1, p2) --[[ ShowTip | Line: 12 | Upvalues: KickTip (copy) ]]
		if KickTip:FindFirstChild(p2) then
			KickTip.Visible = true
			KickTip[p2].Visible = true
		end
	end,
	Hide = function(p1) --[[ Hide | Line: 19 | Upvalues: KickTip (copy) ]]
		KickTip.Visible = false
		for i, v in ipairs(KickTip:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Visible = false
			end
		end
	end
}