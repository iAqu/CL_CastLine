-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
game:GetService("ContextActionService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Signal)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Device = require(ReplicatedStorage.Modules.Device)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
require(ReplicatedStorage.Modules.CoreCall)
local InputControl = require(ReplicatedStorage.Modules.InputControl)
local v1 = Net:RemoteEvent("CancelPrompt")
local v2 = Instance.new("BindableEvent")
local v3 = false
local v4 = false
local v5 = "Yes"
local v6 = "No"
local Prompt = LocalPlayer.PlayerGui:WaitForChild("Prompt")
local No = Prompt:WaitForChild("Blackout"):WaitForChild("Options"):WaitForChild("No")
local Yes = Prompt:WaitForChild("Blackout"):WaitForChild("Options"):WaitForChild("Yes")
local t = {}
local t2 = {
	Init = function(p1) --[[ Init | Line: 59 | Upvalues: InputControl (copy), v3 (ref), GuiService (copy), v2 (copy), v1 (copy), UserInputService (copy) ]]
		InputControl:RegisterInput({ Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonB }, { function() --[[ Line: 62 | Upvalues: v3 (ref) ]]
				return v3
			end, function() --[[ Line: 65 | Upvalues: GuiService (ref) ]]
				return GuiService.CoreGuiNavigationEnabled
			end }, function(p1) --[[ Line: 69 | Upvalues: v2 (ref) ]]
			if p1.KeyCode == Enum.KeyCode.ButtonX then
				v2:Fire(true)
				return
			end
			if p1.KeyCode ~= Enum.KeyCode.ButtonB then
				return
			end
			v2:Fire(false)
		end)
		v1.OnClientEvent:Connect(function() --[[ Line: 78 | Upvalues: v3 (ref), v2 (ref) ]]
			if not v3 then
				return
			end
			v2:Fire(false)
		end)
		UserInputService.InputChanged:Connect(RefreshConsoleInputs)
		GuiService:GetPropertyChangedSignal("CoreGuiNavigationEnabled"):Connect(RefreshConsoleInputs)
		RefreshConsoleInputs()
	end,
	Start = function(p1) --[[ Start | Line: 89 | Upvalues: Trove (copy), GuiControl (copy), No (copy), Yes (copy), LocalPlayer (copy), v2 (copy), t (copy), RunService (copy), v5 (ref) ]]
		local v1 = Trove.new()
		local v22 = GuiControl:Hook("Hold Button", No)
		local v3 = GuiControl:Hook("Hold Button", Yes)
		LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 95 | Upvalues: LocalPlayer (ref), v2 (ref) ]]
			if not LocalPlayer:GetAttribute("InCutscene") then
				return
			end
			v2:Fire(false)
		end)
		v22.Clicked:Connect(function() --[[ Line: 102 | Upvalues: v2 (ref) ]]
			v2:Fire(false)
		end)
		v3.Clicked:Connect(function() --[[ Line: 106 | Upvalues: t (ref), Yes (ref), v2 (ref) ]]
			local v1 = t[1]
			if not v1 then
				return
			end
			local v22
			if v1.ConfirmAction then
				local v3 = workspace:GetServerTimeNow()
				local _signature = v1._signature
				if not _signature then
					v1._signature = v3 + 2
					Yes:SetAttribute("Inactive", v3 + 2)
					return
				end
				v22 = _signature <= v3
			else
				v22 = true
			end
			if not v22 then
				return
			end
			v2:Fire(true)
		end)
		Yes:GetAttributeChangedSignal("Inactive"):Connect(function() --[[ Line: 133 | Upvalues: v1 (copy), Yes (ref), RunService (ref), v5 (ref) ]]
			v1:Clean()
			local v12 = Yes:GetAttribute("Inactive")
			if v12 then
				Yes.Label.Text = ("Waiting (%*)"):format(2)
				Yes.BackgroundTransparency = 0.5
				v1:Add(RunService.Heartbeat:Connect(function() --[[ Line: 141 | Upvalues: v12 (copy), Yes (ref), v1 (ref) ]]
					local v2 = math.max(v12 - workspace:GetServerTimeNow(), 0)
					Yes.Label.Text = ("Waiting (%*)"):format(math.round(v2 * 10) / 10)
					if v2 ~= 0 then
						return
					end
					v1:Clean()
					Yes:SetAttribute("Inactive", nil)
				end))
			else
				Yes.Label.Text = v5
				Yes.BackgroundTransparency = 0
			end
		end)
	end,
	_setJumpState = function(p1, p2) --[[ _setJumpState | Line: 160 | Upvalues: LocalPlayer (copy) ]]
		local Character = LocalPlayer.Character
		if not Character then
			return
		end
		local v1 = Character:FindFirstChildWhichIsA("Humanoid")
		if v1 then
			v1:SetStateEnabled(Enum.HumanoidStateType.Jumping, p2)
		end
	end,
	FirePrompt = function(p1, p2, p3) --[[ FirePrompt | Line: 174 | Upvalues: t (copy) ]]
		table.insert(t, {
			TextPrompt = p2,
			ConfirmAction = false
		})
		return p1:Refresh()
	end,
	FireChoicePrompt = function(p1, p2, p3, p4) --[[ FireChoicePrompt | Line: 185 | Upvalues: t (copy) ]]
		table.insert(t, {
			ConfirmAction = false,
			TextPrompt = p2,
			ConfirmText = p4,
			CancelText = p3
		})
		return p1:Refresh()
	end
}
function t2.DrawPrompt(p1, p2) --[[ DrawPrompt | Line: 196 | Upvalues: Trove (copy), t2 (copy), UserInputService (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), No (copy), Yes (copy), Prompt (copy), GuiControl (copy), v2 (copy), t (copy), ProximityPromptService (copy) ]]
	local v1 = Trove.new()
	t2:_setJumpState(false)
	v1:Add(UserInputService.JumpRequest:Connect(function() --[[ Line: 203 | Upvalues: v3 (ref), t2 (ref) ]]
		if v3 then
			t2:_setJumpState(false)
		else
			t2:_setJumpState(true)
		end
	end))
	v1:Add(function() --[[ Line: 211 | Upvalues: t2 (ref) ]]
		t2:_setJumpState(true)
	end)
	pcall(function() --[[ Line: 217 | Upvalues: p2 (copy) ]]
		if p2.TextPrompt:find("</stroke>") ~= nil then
			return
		end
		p2.TextPrompt = ("<stroke thickness=\"4\" transparency=\"0\">%*</stroke>"):format(p2.TextPrompt)
	end)
	if p2.ConfirmAction then
		v4 = true
		v5 = p2.ConfirmText or "Yes"
		v6 = p2.CancelText or "No"
		No.Label.Text = v6
		Yes:SetAttribute("Inactive", workspace:GetServerTimeNow() + 1)
	else
		v4 = false
		v5 = p2.ConfirmText or "Yes"
		v6 = p2.CancelText or "No"
		No.Label.Text = v6
		Yes:SetAttribute("Inactive", nil)
		Yes.Label.Text = v5
	end
	task.defer(function() --[[ Line: 238 | Upvalues: v4 (ref) ]] end)
	Prompt.Blackout.Label.Text = p2.TextPrompt
	local Gui = GuiControl.Gui
	if Gui then
		Gui.Enabled = false
	end
	GuiControl:Lock()
	GuiControl:SetHUDVisibility(false)
	Prompt.Enabled = true
	v3 = true
	local v22 = v2.Event:Wait()
	table.remove(t, 1)
	v1:Destroy()
	v3 = false
	ProximityPromptService.Enabled = true
	Prompt.Enabled = false
	v5 = "Yes"
	v6 = "No"
	Yes.Label.Text = v5
	No.Label.Text = v6
	GuiControl:SetHUDVisibility(true)
	if Gui and GuiControl.Gui == Gui then
		Gui.Enabled = true
	else
		GuiControl:Close(true)
	end
	GuiControl:Unlock()
	task.delay(0.1, function() --[[ Line: 288 | Upvalues: ProximityPromptService (ref) ]]
		ProximityPromptService.Enabled = true
	end)
	return v22
end
function t2.Refresh(p1) --[[ Refresh | Line: 295 | Upvalues: Promise (copy), t (copy) ]]
	return Promise.new(function(p12, p2) --[[ Line: 296 | Upvalues: t (ref), p1 (copy) ]]
		local v1 = t[1]
		if v1 then
			return p12(p1:DrawPrompt(v1))
		else
			return p2("No action prompts were queued!")
		end
	end)
end
function RefreshConsoleInputs(p1) --[[ RefreshConsoleInputs | Line: 307 | Upvalues: UserInputService (copy), Device (copy), No (copy), Yes (copy) ]]
	if p1 then
		local UserInputType = p1.UserInputType
	else
		UserInputService:GetLastInputType()
	end
	if Device:_getDevice() == "Console" then
		No.Vector.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonB)
		Yes.Vector.Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX)
		No.Vector.Visible = true
		Yes.Vector.Visible = true
	else
		No.Vector.Visible = false
		Yes.Vector.Visible = false
	end
end
return t2