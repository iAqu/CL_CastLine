-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = PlayerGui:WaitForChild("Backpack")
local CurrentCamera = workspace.CurrentCamera
local Observers = require(ReplicatedStorage.Packages.Observers)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Components = require(script:WaitForChild("Components"))
local v1 = Signal.new()
local v2 = Signal.new()
local v3 = Signal.new()
local t = {}
local v4 = nil
local t2 = {
	_locked = false,
	_fishingLocked = false,
	Gui = nil,
	GuiFocusedSignal = v2,
	GuiUnfocusedSignal = v1,
	GuiHiddenSignal = v3,
	FishingLock = function(p1) --[[ FishingLock | Line: 66 ]]
		p1._fishingLocked = true
	end,
	FishingUnlock = function(p1) --[[ FishingUnlock | Line: 71 ]]
		p1._fishingLocked = false
	end,
	Unlock = function(p1) --[[ Unlock | Line: 76 ]]
		p1._locked = false
	end,
	Lock = function(p1) --[[ Lock | Line: 81 ]]
		p1._locked = true
	end,
	BeforeHook = function(p1, p2, p3) --[[ BeforeHook | Line: 86 | Upvalues: t (copy), Signal (copy) ]]
		local v1 = t[p2]
		if not v1 then
			local v2 = Signal.new()
			t[p2] = v2
			v1 = v2
		end
		return v1:Connect(p3)
	end,
	IsOpen = function(p1, p2) --[[ IsOpen | Line: 98 | Upvalues: PlayerGui (copy) ]]
		local v1 = PlayerGui:FindFirstChild(p2)
		if not v1 then
			return false
		end
		if p1.Gui == v1 then
			return true
		end
		if v1.Enabled and not p1.Gui then
			v1.Enabled = false
		end
		return v1.Enabled
	end,
	Close = function(p1, p2) --[[ Close | Line: 115 | Upvalues: v4 (ref), v1 (copy) ]]
		if p2 then
			p1._locked = false
		end
		if p1._locked then
			return
		end
		local v12
		if v4 then
			v12 = v4
			v4.Enabled = false
		else
			v12 = nil
		end
		local Gui = p1.Gui
		if Gui then
			Gui.Enabled = false
			p1.Gui = nil
			v12 = Gui
		end
		if not v12 then
			return
		end
		v1:Fire(v12)
	end,
	Open = function(p1, p2, p3, p4) --[[ Open | Line: 143 | Upvalues: PlayerGui (copy), t (copy), v4 (ref), v2 (copy) ]]
		if p3 then
			p1._locked = false
		end
		if p1._locked then
			return
		end
		local v1 = PlayerGui:FindFirstChild(p2)
		if not v1 then
			return
		end
		if not v1:IsA("ScreenGui") then
			return
		end
		local v22 = t[p2]
		if v22 then
			v22:Fire(p4)
		end
		p1:Close(p3)
		v4 = v1
		p1.Gui = v1
		if p1.Gui then
			p1.Gui.Enabled = true
		end
		v2:Fire(v1)
	end,
	HideAllHUD = function(p1, p2) --[[ HideAllHUD | Line: 179 | Upvalues: PlayerGui (copy), StarterGui (copy) ]]
		local t = {}
		for v1, v2 in PlayerGui:GetChildren() do
			local v3 = v2.Name
			if v3 ~= "Backpack" and (v3 ~= "Oxygen" and (v3 ~= "Charge" and table.find(p2, v2.Name) == nil)) then
				t[v2] = v2.Enabled
				v2.Enabled = false
			end
		end
		for v4, v5 in workspace:WaitForChild("!!!! ISLAND LOCATIONS !!!!"):GetChildren() do
			if table.find(p2, v5.Name) == nil and v5:FindFirstChild("Gui") then
				t[v5.Gui] = v5.Gui.Enabled
				v5.Gui.Enabled = false
			end
		end
		pcall(function() --[[ Line: 201 | Upvalues: StarterGui (ref) ]]
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		end)
		return t
	end,
	RestoreHUD = function(p1, p2) --[[ RestoreHUD | Line: 209 | Upvalues: PlayerGui (copy), StarterGui (copy) ]]
		for v1, v2 in PlayerGui:GetChildren() do
			local v3 = v2.Name
			if v3 ~= "Backpack" and (v3 ~= "Oxygen" and (v3 ~= "Charge" and p2[v2])) then
				v2.Enabled = p2[v2]
			end
		end
		for v4, v5 in workspace:WaitForChild("!!!! ISLAND LOCATIONS !!!!"):GetChildren() do
			if v5:FindFirstChild("Gui") and p2[v5.Gui] then
				v5.Gui.Enabled = p2[v5.Gui]
			end
		end
		pcall(function() --[[ Line: 227 | Upvalues: StarterGui (ref) ]]
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		end)
	end,
	Hook = function(p1, p2, ...) --[[ Hook | Line: 233 | Upvalues: Components (copy) ]]
		local v1 = Components[p2]
		if v1 then
			return v1.new(...)
		else
			error((("Component \"%*\" does not exist!"):format(p2)))
		end
	end,
	SetHUDVisibility = function(p1, p2) --[[ SetHUDVisibility | Line: 242 | Upvalues: LocalPlayer (copy), Backpack (copy), v3 (copy) ]]
		if p1._fishingLocked and p2 then
			return
		end
		if LocalPlayer:GetAttribute("InCutscene") then
			p2 = false
		end
		Backpack.Enabled = p2
		v3:Fire(p2)
	end
}
Observers.observeCharacter(function(p1, p2) --[[ Line: 258 | Upvalues: LocalPlayer (copy), t2 (copy) ]]
	if p1 == LocalPlayer then
		return function() --[[ Line: 263 | Upvalues: t2 (ref) ]]
			t2:Close()
			if t2.Gui then
				return
			end
			t2:SetHUDVisibility(true)
		end
	end
end)
LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 273 | Upvalues: LocalPlayer (copy), t2 (copy) ]]
	if LocalPlayer:GetAttribute("InCutscene") then
		t2:SetHUDVisibility(false)
	else
		t2:SetHUDVisibility(true)
	end
end)
Observers.observeSpecificCharacter(LocalPlayer, function() --[[ Line: 282 | Upvalues: t2 (copy) ]]
	t2:SetHUDVisibility(true)
end)
return t2