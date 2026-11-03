-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local Trove = require(ReplicatedStorage.Packages.Trove)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local EggMachineConfig = require(ReplicatedStorage.Shared.EggMachineConfig)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = Net:RemoteFunction("ExchangeEggMachine")
local v2 = Net:RemoteEvent("OpenEggMachine")
local v3 = nil
local v4 = Trove.new()
local v5 = false
local v6 = 0
local t = {}
local t2 = {}
local function ensureGui() --[[ ensureGui | Line: 41 | Upvalues: PlayerGui (copy), EggMachineConfig (copy), t2 (copy) ]]
	local v1 = PlayerGui:WaitForChild(EggMachineConfig.GuiName)
	if not v1:IsA("ScreenGui") then
		return
	end
	local Main = v1:WaitForChild("Main")
	if not Main:IsA("Frame") then
		return
	end
	local EggItem = Main:WaitForChild("EggItem")
	local CarrotItem = Main:WaitForChild("CarrotItem")
	local Exhange1 = Main:WaitForChild("Exhange1")
	local Close = Main:WaitForChild("Close")
	local Exhange10 = Main:FindFirstChild("Exhange10")
	if not (EggItem:IsA("ImageButton") and (CarrotItem:IsA("ImageButton") and (Exhange1:IsA("GuiButton") and Close:IsA("GuiButton")))) then
		return
	end
	if Exhange10 and Exhange10:IsA("GuiObject") then
		Exhange10.Visible = false
	end
	local Label = EggItem:WaitForChild("Label")
	local Amount = EggItem:WaitForChild("Amount")
	local Label_2 = CarrotItem:WaitForChild("Label")
	local Amount_2 = CarrotItem:WaitForChild("Amount")
	local Label_3 = Exhange1:WaitForChild("Label")
	if Label:IsA("TextLabel") and (Amount:IsA("TextLabel") and (Label_2:IsA("TextLabel") and (Amount_2:IsA("TextLabel") and Label_3:IsA("TextLabel")))) then
		t2.Gui = v1
		t2.Main = Main
		t2.ItemValue = Amount_2
		t2.ItemLabel = Label_2
		t2.EggLabel = Label
		t2.EggAmount = Amount
		t2.ExchangeButton = Exhange1
		t2.ExchangeButtonLabel = Label_3
		t2.CloseButton = Close
	end
end
local function openMachine() --[[ openMachine | Line: 87 | Upvalues: t2 (copy), GuiControl (copy), EggMachineConfig (copy) ]]
	if t2.Gui then
		GuiControl:Open(EggMachineConfig.GuiName)
	end
end
local function closeMachine() --[[ closeMachine | Line: 95 | Upvalues: GuiControl (copy) ]]
	GuiControl:Close()
end
local function getEggCount() --[[ getEggCount | Line: 99 | Upvalues: LocalPlayer (copy) ]]
	local v1 = LocalPlayer:GetAttribute("IncubatingEggCount")
	if typeof(v1) == "number" then
		return math.max(0, (math.floor(v1)))
	else
		return 0
	end
end
local function getExchangeItemCount() --[[ getExchangeItemCount | Line: 108 | Upvalues: v3 (ref), v6 (ref) ]]
	if not v3 then
		return 0
	end
	if v6 == 0 then
		return 0
	end
	for k, v in pairs(v3:Get({ "Inventory", "Items" }) or {}) do
		if v.Id == v6 then
			return v.Quantity or 1
		end
	end
	return 0
end
local function updateUi() --[[ updateUi | Line: 127 | Upvalues: getExchangeItemCount (copy), LocalPlayer (copy), EggMachineConfig (copy), v5 (ref), t2 (copy) ]]
	local v1 = getExchangeItemCount()
	local v2 = LocalPlayer:GetAttribute("IncubatingEggCount")
	local v3 = if typeof(v2) == "number" then math.max(0, (math.floor(v2))) else 0
	local v7 = math.max(EggMachineConfig.ItemCost - v1, 0)
	local v8 = if EggMachineConfig.ItemCost <= v1 then true else false
	local v9 = if v3 < EggMachineConfig.MaxIncubatingEggs then true else false
	local v10 = if v8 then if v9 then not v5 else v9 else v8
	if t2.ItemValue then
		t2.ItemValue.Text = ("%*/%*"):format(v1, EggMachineConfig.ItemCost)
	end
	if t2.ItemLabel then
		t2.ItemLabel.Text = EggMachineConfig.ItemPluralName
	end
	if t2.EggAmount then
		t2.EggAmount.Text = "1"
	end
	if t2.EggLabel then
		t2.EggLabel.Text = "Egg"
	end
	if t2.ExchangeButton then
		t2.ExchangeButton.ImageColor3 = if v10 then Color3.fromRGB(80, 255, 0) else Color3.fromRGB(199, 96, 89)
	end
	if not t2.ExchangeButtonLabel then
		return
	end
	if v5 then
		t2.ExchangeButtonLabel.Text = "Working..."
		return
	end
	if not v9 then
		t2.ExchangeButtonLabel.Text = "Egg Slots Full"
		return
	end
	if v8 then
		t2.ExchangeButtonLabel.Text = "Exchange"
		return
	end
	t2.ExchangeButtonLabel.Text = ("You need %* More"):format(v7)
end
function t.Start(p1) --[[ Start | Line: 168 | Upvalues: ensureGui (copy), v3 (ref), Replion (copy), ItemUtility (copy), EggMachineConfig (copy), v6 (ref), t2 (copy), v4 (copy), GuiControl (copy), v5 (ref), updateUi (copy), v1 (copy), TextNotificationController (copy), closeMachine (copy), v2 (copy), LocalPlayer (copy) ]]
	ensureGui()
	v3 = Replion.Client:WaitReplion("Data")
	local v12 = ItemUtility.GetItemDataFromItemType("Items", EggMachineConfig.ItemName)
	if v12 then
		v6 = v12.Data.Id
	end
	if t2.Gui then
		t2.Gui.Enabled = false
	end
	if t2.ExchangeButton then
		v4:Add(GuiControl:Hook("Hold Button", t2.ExchangeButton).Clicked:Connect(function() --[[ Line: 181 | Upvalues: v5 (ref), updateUi (ref), v1 (ref), TextNotificationController (ref) ]]
			if v5 then
				return
			end
			v5 = true
			updateUi()
			local v12, v2 = pcall(function() --[[ Line: 189 | Upvalues: v1 (ref) ]]
				return v1:InvokeServer()
			end)
			v5 = false
			updateUi()
			if not v12 then
				TextNotificationController:DeliverNotification({
					Type = "Text",
					Text = "Egg machine failed.",
					TextColor = {
						R = 255,
						G = 120,
						B = 120
					}
				})
				return
			end
			if v2 and v2.Success then
				return
			end
			local t = {
				Type = "Text"
			}
			t.Text = if v2 then v2.Message or "Unable to exchange carrots." else "Unable to exchange carrots."
			t.TextColor = {
				R = 255,
				G = 120,
				B = 120
			}
			TextNotificationController:DeliverNotification(t)
		end))
	end
	if t2.CloseButton then
		v4:Add(GuiControl:Hook("Hold Button", t2.CloseButton).Clicked:Connect(closeMachine))
	end
	v4:Add(v2.OnClientEvent:Connect(function() --[[ Line: 219 | Upvalues: updateUi (ref), t2 (ref), GuiControl (ref), EggMachineConfig (ref) ]]
		updateUi()
		if t2.Gui then
			GuiControl:Open(EggMachineConfig.GuiName)
		end
	end))
	v4:Add(LocalPlayer:GetAttributeChangedSignal("IncubatingEggCount"):Connect(updateUi))
	v4:Add(v3:OnChange({ "Inventory", "Items" }, updateUi))
	v4:Add(v3:OnChange({ "Incubator", "Slots" }, updateUi))
	v4:Add(GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 227 | Upvalues: t2 (ref), updateUi (ref) ]]
		if p1 ~= t2.Gui then
			return
		end
		updateUi()
	end))
	updateUi()
end
return t