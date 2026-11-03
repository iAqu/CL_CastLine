-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Signal = require(ReplicatedStorage.Packages.Signal)
local spr = require(ReplicatedStorage.Packages.spr)
local CoreCall = require(ReplicatedStorage.Modules.CoreCall)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v1 = Net:RemoteFunction("BlackoutScreen")
local v2 = Net:RemoteEvent("ProductPurchaseFinished")
local v3 = Signal.new()
local v4 = 0
local t = {}
local t2 = {}
local PurchaseScreenBlackout = PlayerGui:WaitForChild("PurchaseScreenBlackout")
local CanvasGroup = PurchaseScreenBlackout:WaitForChild("Blackout"):WaitForChild("CanvasGroup")
local Close = CanvasGroup:WaitForChild("Close")
local Blackout = PlayerGui:WaitForChild("Blackout")
local t3 = {}
function t3.Start(p1) --[[ Start | Line: 49 | Upvalues: v3 (copy), t3 (copy), v1 (copy), v2 (copy), GuiControl (copy), Close (copy), t (copy) ]]
	v3:Connect(t3.onPurchaseUpdated)
	function v1.OnClientInvoke(p1, p2) --[[ Line: 52 | Upvalues: t3 (ref) ]]
		t3.blackoutScreen(p1, p2, true)
		return true
	end
	v2.OnClientEvent:Connect(t3.addPurchase)
	GuiControl:Hook("Hold Button", Close).Clicked:Connect(function() --[[ Line: 61 | Upvalues: t (ref), t3 (ref) ]]
		table.clear(t)
		t3.addPurchase(0, false)
	end)
	_G.addPurchase = t3.addPurchase
end
function t3._hideCoreGui(p1, p2) --[[ _hideCoreGui | Line: 71 | Upvalues: CoreCall (copy) ]]
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.Chat, p2)
	CoreCall("SetCoreGuiEnabled", Enum.CoreGuiType.PlayerList, p2)
end
function t3.blackoutScreen(p1, p2, p3) --[[ blackoutScreen | Line: 76 | Upvalues: GuiControl (copy), Blackout (copy), spr (copy), t3 (copy), Soundbook (copy), LocalPlayer (copy) ]]
	GuiControl:Close(true)
	GuiControl:Lock()
	if p2 then
		Blackout.Label.Visible = false
	end
	spr.stop(Blackout.Blackout)
	spr.stop(Blackout.Label)
	Blackout.Blackout.BackgroundTransparency = 1
	Blackout.Label.TextTransparency = 1
	t3:_hideCoreGui(false)
	spr.target(Blackout.Blackout, 1, 2, {
		BackgroundTransparency = 0
	})
	spr.target(Blackout.Label, 1, 2, {
		TextTransparency = 0
	})
	GuiControl:Open("Blackout", true)
	task.wait(1)
	if p1 and not p2 then
		Soundbook.Sounds.TeleportTransition:Play()
	end
	if p1 then
		LocalPlayer:RequestStreamAroundAsync(p1.Position, if p3 then 8 else 4)
	end
	local function f2() --[[ Line: 121 | Upvalues: spr (ref), Blackout (ref) ]]
		spr.stop(Blackout.Blackout)
		spr.stop(Blackout.Label)
		spr.target(Blackout.Blackout, 1, 2, {
			BackgroundTransparency = 1
		})
		spr.target(Blackout.Label, 1, 2, {
			TextTransparency = 1
		})
	end
	local sum = 1
	if p3 then
		task.delay(3, f2)
		sum = sum + 3
	else
		task.wait(3)
		f2()
	end
	task.delay(sum, function() --[[ Line: 142 | Upvalues: GuiControl (ref), t3 (ref), p2 (copy), Blackout (ref) ]]
		GuiControl:Unlock()
		GuiControl:Close(true)
		t3:_hideCoreGui(true)
		if not p2 then
			return
		end
		Blackout.Label.Visible = true
	end)
end
function t3.onPurchaseUpdated() --[[ onPurchaseUpdated | Line: 154 | Upvalues: v4 (ref), t (copy), t2 (copy), CanvasGroup (copy), Close (copy), PurchaseScreenBlackout (copy), TweenService (copy) ]]
	local v1 = tick()
	v4 = v1
	local v2 = t[1]
	local ProductId = v2.ProductId
	if #t2 > 0 then
		for i, v in ipairs(t2) do
			v:Destroy()
		end
		table.clear(t2)
	end
	if v2.Purchased ~= nil then
		local v3 = TweenService:Create(PurchaseScreenBlackout.Blackout, TweenInfo.new(0.09, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		})
		local v42 = TweenService:Create(PurchaseScreenBlackout.Spin, TweenInfo.new(0.09, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			ImageTransparency = 1
		})
		TweenService:Create(CanvasGroup, TweenInfo.new(0.045, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			GroupTransparency = 1
		}):Play()
		v3:Play()
		v42:Play()
		v42.Completed:Once(function() --[[ Line: 223 | Upvalues: Close (ref), PurchaseScreenBlackout (ref) ]]
			Close.Visible = false
			PurchaseScreenBlackout.Enabled = false
		end)
		table.remove(t, 1)
		return
	end
	CanvasGroup.GroupTransparency = 1
	Close.Visible = false
	PurchaseScreenBlackout.Blackout.BackgroundTransparency = 1
	PurchaseScreenBlackout.Spin.ImageTransparency = 0
	PurchaseScreenBlackout.Spin.Rotation = 0
	PurchaseScreenBlackout.Enabled = true
	local v5 = TweenService:Create(PurchaseScreenBlackout.Blackout, TweenInfo.new(0.18, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.2
	})
	local v6 = TweenService:Create(PurchaseScreenBlackout.Spin, TweenInfo.new(1.94, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {
		Rotation = 360
	})
	local Popup = script:FindFirstChild("Popup")
	if Popup.Playing then
		local v7, v8
		task.delay(1, function() --[[ Line: 190 | Upvalues: v1 (copy), v4 (ref), Close (ref), TweenService (ref), CanvasGroup (ref), t2 (ref) ]]
			if v1 ~= v4 then
				return
			end
			Close.Visible = true
			local v12 = TweenService:Create(CanvasGroup, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				GroupTransparency = 0
			})
			table.insert(t2, v12)
			v12:Play()
		end)
		v7 = t2
		table.insert(t2, v5)
		v8 = t2
		table.insert(t2, v6)
		v5:Play()
		v6:Play()
		table.remove(t, 1)
		return
	end
	Popup:Play()
	task.delay(1, function() --[[ Line: 190 | Upvalues: v1 (copy), v4 (ref), Close (ref), TweenService (ref), CanvasGroup (ref), t2 (ref) ]]
		if v1 ~= v4 then
			return
		end
		Close.Visible = true
		local v12 = TweenService:Create(CanvasGroup, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
			GroupTransparency = 0
		})
		table.insert(t2, v12)
		v12:Play()
	end)
	table.insert(t2, v5)
	table.insert(t2, v6)
	v5:Play()
	v6:Play()
	table.remove(t, 1)
end
function t3.addPurchase(p1, p2) --[[ addPurchase | Line: 232 | Upvalues: t (copy), v3 (copy) ]]
	table.insert(t, {
		ProductId = p1,
		Purchased = p2
	})
	v3:Fire()
end
return t3