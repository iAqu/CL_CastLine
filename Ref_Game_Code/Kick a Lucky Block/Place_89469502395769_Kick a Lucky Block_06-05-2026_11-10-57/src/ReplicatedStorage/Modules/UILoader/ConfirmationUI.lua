-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local ConfirmFrame = (PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")).ConfirmFrame
local t = {
	IsOpening = false,
	LastThread = nil
}
function t.GetResult(p1, p2, p3, p4) --[[ GetResult | Line: 20 | Upvalues: Trove (copy), ConfirmFrame (copy), t (copy) ]]
	if p1.IsOpening then
	else
		p1.IsOpening = true
		local v1 = nil
		local v2 = Trove.new()
		local v3 = coroutine.running()
		if p2 then
			p2.Visible = false
			v2:Add(p2:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 33 | Upvalues: p2 (copy) ]]
				p2.Visible = false
			end))
			v2:Add(function() --[[ Line: 37 | Upvalues: p2 (copy) ]]
				p2.Visible = true
			end)
		end
		ConfirmFrame.Visible = true
		ConfirmFrame.Label.Text = p3 or "Are you sure?"
		v2:Connect(ConfirmFrame:GetPropertyChangedSignal("Visible"), function() --[[ Line: 45 | Upvalues: ConfirmFrame (ref) ]]
			ConfirmFrame.Visible = true
		end)
		v2:Connect(ConfirmFrame.Buttons.Yes.Activated, function() --[[ Line: 49 | Upvalues: v1 (ref), v2 (copy), v3 (copy) ]]
			if not v1 then
				v2:Clean()
				v1 = "Yes"
				coroutine.resume(v3)
			end
		end)
		v2:Connect(ConfirmFrame.Buttons.Yes.Action.Released, function() --[[ Line: 57 | Upvalues: v1 (ref), v2 (copy), v3 (copy) ]]
			if not v1 then
				v2:Clean()
				v1 = "Yes"
				coroutine.resume(v3)
			end
		end)
		v2:Connect(ConfirmFrame.Buttons.No.Activated, function() --[[ Line: 65 | Upvalues: v1 (ref), v2 (copy), v3 (copy) ]]
			if not v1 then
				v2:Clean()
				v1 = "No"
				coroutine.resume(v3)
			end
		end)
		v2:Connect(ConfirmFrame.Buttons.No.Action.Released, function() --[[ Line: 73 | Upvalues: v1 (ref), v2 (copy), v3 (copy) ]]
			if not v1 then
				v2:Clean()
				v1 = "No"
				coroutine.resume(v3)
			end
		end)
		if p4 then
			v2:Add(task.delay(p4, function() --[[ Line: 82 | Upvalues: v1 (ref), v2 (copy), v3 (copy) ]]
				if not v1 then
					v2:Clean()
					v1 = "No"
					coroutine.resume(v3)
				end
			end))
		end
		coroutine.yield()
		t.IsOpening = false
		ConfirmFrame.Visible = false
		return v1
	end
end
function DeviceChanged(p1) --[[ DeviceChanged | Line: 98 | Upvalues: ClientProfile (copy), ConfirmFrame (copy) ]]
	if p1 == ClientProfile.DeviceTypes.Console then
		ConfirmFrame.Buttons.No.GamepadKey.Visible = true
		ConfirmFrame.Buttons.Yes.GamepadKey.Visible = true
	else
		ConfirmFrame.Buttons.No.GamepadKey.Visible = false
		ConfirmFrame.Buttons.Yes.GamepadKey.Visible = false
	end
end
function t._init() --[[ _init | Line: 108 | Upvalues: ClientProfile (copy) ]]
	DeviceChanged(ClientProfile.Device)
	ClientProfile.DeviceChanged:Connect(DeviceChanged)
end
return t