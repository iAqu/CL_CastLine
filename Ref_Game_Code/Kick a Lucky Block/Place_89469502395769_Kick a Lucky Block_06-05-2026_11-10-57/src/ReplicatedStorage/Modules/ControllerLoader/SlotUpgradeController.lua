-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseUpgradesServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.BaseUpgradesServiceClient)
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local SlotUpgradesData = require(ReplicatedStorage.Shared.Data.SlotUpgradesData)
local v1 = PlayerGui:FindFirstChild("SurfaceGUIs") or PlayerGui:WaitForChild("SurfaceGUIs")
local t = {
	Relative = CFrame.new(-7.05004883, -4.5000062, -16.5001526, 0, 0, -1, 0, 1, 0, 1, 0, 0)
}
function LoadSignGUI(p1) --[[ LoadSignGUI | Line: 23 | Upvalues: ReplicatedStorage (copy), v1 (copy), SlotUpgradesData (copy), BaseUpgradesServiceClient (copy), ClientBalanceService (copy), MessagesService (copy) ]]
	local v12 = ReplicatedStorage.Objects.GUI.LevelGUI:Clone()
	v12:WaitForChild("BuyButton")
	v12:WaitForChild("Frame"):WaitForChild("Label")
	v12.Adornee = p1:WaitForChild("BillboardPart")
	v12.Parent = v1
	local v2 = nil
	local v3 = nil
	local function OnSlotsChanged(p1) --[[ OnSlotsChanged | Line: 36 | Upvalues: v3 (ref), SlotUpgradesData (ref), BaseUpgradesServiceClient (ref), v2 (ref), v12 (copy) ]]
		v3 = SlotUpgradesData:GetPrice(p1 + 1)
		if p1 == BaseUpgradesServiceClient.MAX_SLOTS then
			if v2 then
				v2:Disconnect()
				v2 = nil
			end
			v12.BuyButton.Visible = false
			v12.Frame.Label.Text = ("[MAX] Slots %*"):format(10 + p1)
		else
			v12.Frame.Label.Text = ("Slots %*"):format(10 + p1)
			v12.BuyButton.Visible = true
			v12.BuyButton.TextLabel.Text = ("%*$"):format(v3)
		end
	end
	local function UpgradeRequest() --[[ UpgradeRequest | Line: 54 | Upvalues: v3 (ref), ClientBalanceService (ref), BaseUpgradesServiceClient (ref), MessagesService (ref) ]]
		if v3 and v3 <= ClientBalanceService.Balance then
			BaseUpgradesServiceClient:RequestUpgrade()
		elseif v3 then
			MessagesService:PlayMessage("Insufficient cash", "Error")
		end
	end
	OnSlotsChanged(BaseUpgradesServiceClient.AddedSlots)
	BaseUpgradesServiceClient.SlotsChanged:Connect(OnSlotsChanged)
	v2 = v12.BuyButton.Activated:Connect(UpgradeRequest)
end
function t.PlaceSign(p1, p2) --[[ PlaceSign | Line: 71 | Upvalues: ReplicatedStorage (copy) ]]
	local v1 = p2:GetPivot():ToWorldSpace(p1.Relative)
	local v2 = ReplicatedStorage.Objects.Plot.SlotUpgradeSign:Clone()
	v2:PivotTo(v1)
	LoadSignGUI(v2)
	v2.Parent = workspace.Debris
end
return t