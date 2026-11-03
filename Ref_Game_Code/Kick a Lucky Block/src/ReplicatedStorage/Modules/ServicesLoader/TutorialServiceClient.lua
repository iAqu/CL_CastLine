-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
game:GetService("TweenService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
require(ReplicatedStorage.Shared.Utility.InfiniteMath)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local NewInventory = require(ReplicatedStorage.Modules.UILoader.NewInventory)
local PlacedVisualizer = require(ReplicatedStorage.Modules.ControllerLoader.PlacedVisualizer)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local Signal = require(ReplicatedStorage.Shared.Packages.Signal)
local ZoneController = require(ReplicatedStorage.Modules.ControllerLoader.ZoneController)
local KickController = require(ReplicatedStorage.Modules.ControllerLoader.KickController)
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local GameHandler = require(ReplicatedStorage.Modules.HandlerLoader.GameHandler)
local ClientPlotService = require(ReplicatedStorage.Modules.ServicesLoader.ClientPlotService)
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local WeightServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.WeightServiceClient)
local KickServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.KickServiceClient)
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
require(ReplicatedStorage.Shared.Data.WeightsData)
local DisplayBeam = require(ReplicatedStorage.Functional.Tutorial.DisplayBeam)
local DisplayText = require(ReplicatedStorage.Functional.Tutorial.DisplayText)
local HighlightUI = require(ReplicatedStorage.Functional.Tutorial.HighlightUI)
require(ReplicatedStorage.Functional.Tutorial.ClickOn3DTarget)
local ClickOn2DTarget = require(ReplicatedStorage.Functional.Tutorial.ClickOn2DTarget)
local LocalPlayer = game:GetService("Players").LocalPlayer
local v1 = Trove.new()
local v2 = nil
function GetClosestBrainrot() --[[ GetClosestBrainrot | Line: 47 | Upvalues: LocalPlayer (copy) ]]
	if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
		local v1 = 9999
		local v2 = nil
		for i, v in ipairs(workspace.Entities:GetChildren()) do
			local Root = v:FindFirstChild("Root")
			if Root then
				local Magnitude = (LocalPlayer.Character.PrimaryPart.Position - Root.Position).Magnitude
				if Magnitude < v1 then
					v1 = Magnitude
					v2 = v
				end
			end
		end
		return v2
	end
end
local t = {
	InTutorial = false,
	Changed = Signal.new(),
	Steps = {
		function(p1) --[[ Line: 77 | Upvalues: DisplayText (copy), v1 (copy) ]]
			task.delay(1.5, DisplayText, "Welcome to Kick a Lucky Block!", "Typing")
			v1:Add(task.delay(4, function() --[[ Line: 79 | Upvalues: DisplayText (ref), p1 (copy) ]]
				DisplayText(nil)
				p1()
			end))
		end,
		function(p1) --[[ Line: 86 | Upvalues: DisplayText (copy), DisplayBeam (copy), ZoneController (copy), v1 (copy) ]]
			local KickReady = workspace.Areas.KickReady
			DisplayText("Kick a lucky block!")
			DisplayBeam(KickReady)
			local function CheckInZone() --[[ CheckInZone | Line: 91 | Upvalues: ZoneController (ref), KickReady (copy), DisplayBeam (ref), v1 (ref), p1 (copy) ]]
				if ZoneController.Zone == KickReady.Name then
					DisplayBeam(nil)
					v1:Clean()
					p1()
				end
			end
			v1:Connect(ZoneController.ZoneChanged, CheckInZone)
			local isName = ZoneController.Zone == KickReady.Name
			if isName then
				DisplayBeam(nil)
				v1:Clean()
				p1()
			end
		end,
		function(p1, p2) --[[ Line: 108 | Upvalues: LocalPlayer (copy), DisplayText (copy), HighlightUI (copy), ZoneController (copy), DisplayBeam (copy), v1 (copy), KickController (copy) ]]
			local KickButton = (LocalPlayer.PlayerGui:FindFirstChild("HUD") or LocalPlayer.PlayerGui:WaitForChild("HUD")).KickButton
			local KickReady = workspace.Areas.KickReady
			DisplayText("Kick a lucky block!")
			HighlightUI(KickButton)
			local function CheckInZone() --[[ CheckInZone | Line: 116 | Upvalues: ZoneController (ref), KickReady (copy), HighlightUI (ref), DisplayBeam (ref), v1 (ref), p2 (copy) ]]
				if not (ZoneController.Zone == KickReady.Name) then
					HighlightUI(nil)
					DisplayBeam(nil)
					v1:Clean()
					p2()
				end
			end
			local function MinigameChanged() --[[ MinigameChanged | Line: 126 | Upvalues: KickController (ref), DisplayText (ref), HighlightUI (ref), v1 (ref), p1 (copy) ]]
				if KickController.InMinigame then
					DisplayText(nil)
					HighlightUI(nil)
					v1:Clean()
					p1()
				end
			end
			v1:Connect(ZoneController.ZoneChanged, CheckInZone)
			v1:Connect(KickController.InMinigameChanged, MinigameChanged)
			local isName = ZoneController.Zone == KickReady.Name
			if not isName then
				HighlightUI(nil)
				DisplayBeam(nil)
				v1:Clean()
				p2()
			end
			if KickController.InMinigame then
				DisplayText(nil)
				HighlightUI(nil)
				v1:Clean()
				p1()
			end
		end,
		function(p1) --[[ Line: 145 | Upvalues: ClientProfile (copy), DisplayText (copy), GameHandler (copy), v1 (copy) ]]
			local DeviceTypes = ClientProfile.DeviceTypes
			DisplayText(({
				[DeviceTypes.Console] = "Press R2 to \'Kick\'",
				[DeviceTypes.Mobile] = "Tap to Kick!",
				[DeviceTypes.PC] = "Click to Kick!"
			})[ClientProfile.Device or ClientProfile.DeviceTypes.Mobile])
			local function CheckKicked() --[[ CheckKicked | Line: 155 | Upvalues: GameHandler (ref), v1 (ref), DisplayText (ref), p1 (copy) ]]
				if GameHandler.InGame then
					v1:Clean()
					DisplayText(nil)
					p1()
				end
			end
			v1:Connect(GameHandler.GameChanged, CheckKicked)
			if GameHandler.InGame then
				v1:Clean()
				DisplayText(nil)
				p1()
			end
		end,
		function(p1) --[[ Line: 168 | Upvalues: v1 (copy), GameHandler (copy) ]]
			local function CheckWon(p12) --[[ CheckWon | Line: 169 | Upvalues: p1 (copy) ]]
				if p12 then
					p1()
				end
			end
			v1:Connect(GameHandler.GotResult, CheckWon)
		end,
		function(p1) --[[ Line: 179 | Upvalues: v2 (ref), DisplayBeam (copy), DisplayText (copy), v1 (copy), PlacedVisualizer (copy) ]]
			DisplayBeam(v2.Slots.Slot5)
			DisplayText("Place in the slot")
			v1:Add(PlacedVisualizer.BrainrotPlaced:Connect(function() --[[ Line: 184 | Upvalues: v1 (ref), DisplayBeam (ref), DisplayText (ref), p1 (copy) ]]
				v1:Clean()
				DisplayBeam(nil)
				DisplayText(nil)
				p1()
			end))
		end,
		function(p1) --[[ Line: 193 | Upvalues: PlacedVisualizer (copy), EntitiesData (copy), ClientBalanceService (copy), DisplayText (copy), DisplayBeam (copy), v2 (ref), v1 (copy) ]]
			local LastBrainrot = PlacedVisualizer.LastBrainrot
			if LastBrainrot then
				local v3 = EntitiesData.GetCostForUpgrade(LastBrainrot:GetAttribute("ID"), LastBrainrot:GetAttribute("Level") or 1)
				if v3 <= ClientBalanceService.Balance then
					p1()
				else
					DisplayText((("Collect $%*"):format(v3)))
					DisplayBeam(v2.Buttons:FindFirstChild(LastBrainrot.Parent.Name))
					v1:Add(ClientBalanceService.CoinsChanged:Connect(function(p12) --[[ Line: 211 | Upvalues: v3 (copy), v1 (ref), DisplayText (ref), DisplayBeam (ref), p1 (copy) ]]
						if v3 <= p12 then
							v1:Clean()
							DisplayText(nil)
							DisplayBeam(nil)
							p1()
						else
							DisplayText(("Collect $%*"):format(v3), (("%*/%*"):format(p12, v3)))
						end
					end))
				end
			else
				p1()
			end
		end,
		function(p1) --[[ Line: 226 | Upvalues: PlacedVisualizer (copy), LocalPlayer (copy), v1 (copy), ClickOn2DTarget (copy), DisplayBeam (copy), DisplayText (copy) ]]
			local LastBrainrot = PlacedVisualizer.LastBrainrot
			if LastBrainrot then
				local v12 = LastBrainrot.Parent
				if v12 then
					local v3 = (LocalPlayer.PlayerGui:FindFirstChild("SurfaceGUIs") or LocalPlayer.PlayerGui:WaitForChild("SurfaceGUIs")):FindFirstChild(v12.Name)
					if v3 then
						v1:Add(ClickOn2DTarget(v3.Button))
						DisplayBeam(v3.Adornee)
						DisplayText("Buy an upgrade")
						v1:Add(v3.Button.Activated:Connect(function() --[[ Line: 250 | Upvalues: v1 (ref), DisplayBeam (ref), DisplayText (ref), p1 (copy) ]]
							v1:Clean()
							DisplayBeam(nil)
							DisplayText(nil)
							p1()
						end))
					else
						p1()
					end
				else
					p1()
				end
			else
				p1()
			end
		end,
		function(p1) --[[ Line: 259 | Upvalues: WeightServiceClient (copy), DisplayBeam (copy), DisplayText (copy), LocalPlayer (copy), v1 (copy) ]]
			if table.find(WeightServiceClient.Owned, "Wooden Stick") then
				p1()
			else
				DisplayBeam(workspace.Shops.WeightShop:FindFirstChild("TouchPart") or workspace.Shops.WeightShop:WaitForChild("TouchPart"))
				DisplayText("Go to the weights shop")
				local WeightUI = (LocalPlayer.PlayerGui:FindFirstChild("Frames") or LocalPlayer.PlayerGui:WaitForChild("Frames")).WeightUI
				local function Update() --[[ Update | Line: 272 | Upvalues: WeightUI (copy), DisplayBeam (ref), DisplayText (ref), p1 (copy) ]]
					if WeightUI.Visible then
						DisplayBeam(nil)
						DisplayText(nil)
						p1()
					end
				end
				v1:Connect(WeightUI:GetPropertyChangedSignal("Visible"), Update)
				if WeightUI.Visible then
					DisplayBeam(nil)
					DisplayText(nil)
					p1()
				end
			end
		end,
		function(p1) --[[ Line: 285 | Upvalues: WeightServiceClient (copy), LocalPlayer (copy), HighlightUI (copy), DisplayText (copy), v1 (copy) ]]
			if table.find(WeightServiceClient.Owned, "Wooden Stick") then
				p1()
			else
				local v12 = LocalPlayer.PlayerGui:FindFirstChild("Frames") or LocalPlayer.PlayerGui:WaitForChild("Frames")
				local v2 = v12.WeightUI.ScrollingFrame:FindFirstChild("Wooden Stick")
				if v2 then
					HighlightUI(v2.Buttons.InteractButton)
				else
					DisplayText("Buy a wooden stick from the shop")
				end
				v1:Add(WeightServiceClient.Changed:Connect(function() --[[ Line: 300 | Upvalues: WeightServiceClient (ref), HighlightUI (ref), DisplayText (ref), LocalPlayer (ref), p1 (copy) ]]
					if WeightServiceClient.Equipped ~= "None" then
						HighlightUI(nil)
						DisplayText(nil)
						LocalPlayer.PlayerGui.Frames.WeightUI.Visible = false
						p1()
					end
				end))
			end
		end,
		function(p1) --[[ Line: 311 | Upvalues: LocalPlayer (copy), Tags (copy), NewInventory (copy), HighlightUI (copy), v1 (copy) ]]
			local v12 = nil
			local v2 = LocalPlayer.Backpack:GetChildren()
			if LocalPlayer.Character then
				local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if Tool then
					table.insert(v2, Tool)
				end
			end
			for i, v in ipairs(v2) do
				if v:HasTag(Tags.SquatTool) then
					v12 = v
				end
			end
			if v12 then
				local v3 = NewInventory:GetButton(v12)
				if v3 then
					HighlightUI(v3)
					local function ToolChanged() --[[ ToolChanged | Line: 340 | Upvalues: v12 (ref), LocalPlayer (ref), HighlightUI (ref), p1 (copy) ]]
						if v12.Parent == LocalPlayer.Character then
							HighlightUI(nil)
							p1()
						end
					end
					v1:Add(v12.AncestryChanged:Connect(ToolChanged))
				else
					p1()
				end
			else
				p1()
			end
		end,
		function(p1, p2) --[[ Line: 351 | Upvalues: LocalPlayer (copy), Tags (copy), DisplayText (copy), v1 (copy), KickServiceClient (copy) ]]
			local v12 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if v12 and v12:HasTag(Tags.SquatTool) then
				DisplayText((("Get to %* kick power"):format(100)))
				local TutorialGui = LocalPlayer.PlayerGui:WaitForChild("TutorialGui")
				local v2 = script:WaitForChild("UIGradient"):Clone()
				v2.Parent = TutorialGui.MessageTemplate.MessageLabel
				v1:Add(KickServiceClient.LevelChanged:Connect(function() --[[ Line: 370 | Upvalues: KickServiceClient (ref), DisplayText (ref), v2 (copy), p1 (copy) ]]
					local Level = KickServiceClient.Level
					DisplayText((("Get to %*/%* kick power"):format(math.min(Level, 100), 100)))
					if Level >= 100 then
						DisplayText(nil)
						v2:Destroy()
						p1()
					end
				end))
			else
				p2()
			end
		end,
		function(p1) --[[ Line: 385 | Upvalues: DisplayBeam (copy), DisplayText (copy), LocalPlayer (copy), v1 (copy) ]]
			DisplayBeam(workspace.Shops.SpeedShop:FindFirstChild("TouchPart") or workspace.Shops.SpeedShop:WaitForChild("TouchPart"))
			DisplayText("Go to the speed shop")
			local SpeedUpgrades = (LocalPlayer.PlayerGui:FindFirstChild("Frames") or LocalPlayer.PlayerGui:WaitForChild("Frames")).SpeedUpgrades
			local function Update() --[[ Update | Line: 393 | Upvalues: SpeedUpgrades (copy), DisplayBeam (ref), DisplayText (ref), p1 (copy) ]]
				if SpeedUpgrades.Visible then
					DisplayBeam(nil)
					DisplayText(nil)
					p1()
				end
			end
			v1:Connect(SpeedUpgrades:GetPropertyChangedSignal("Visible"), Update)
			if SpeedUpgrades.Visible then
				DisplayBeam(nil)
				DisplayText(nil)
				p1()
			end
		end,
		function(p1) --[[ Line: 406 | Upvalues: SpeedServiceClient (copy), DisplayText (copy), LocalPlayer (copy), HighlightUI (copy), v1 (copy) ]]
			if SpeedServiceClient.Level >= 5 then
				p1()
			else
				DisplayText("Buy 5 speed upgrades")
				HighlightUI((LocalPlayer.PlayerGui:FindFirstChild("Frames") or LocalPlayer.PlayerGui:WaitForChild("Frames")).SpeedUpgrades.ScrollingFrame["+1 Speed"].ButtonsFrame.One)
				v1:Add(SpeedServiceClient.LevelChanged:Connect(function() --[[ Line: 418 | Upvalues: SpeedServiceClient (ref), HighlightUI (ref), DisplayText (ref), p1 (copy) ]]
					if SpeedServiceClient.Level >= 5 then
						HighlightUI(nil)
						DisplayText(nil)
						p1()
					end
				end))
			end
		end,
		function(p1) --[[ Line: 429 | Upvalues: DisplayText (copy), DisplayBeam (copy), ZoneController (copy), v1 (copy) ]]
			local KickReady = workspace.Areas.KickReady
			DisplayText("Kick a lucky block!")
			DisplayBeam(KickReady)
			local function CheckInZone() --[[ CheckInZone | Line: 434 | Upvalues: ZoneController (ref), KickReady (copy), DisplayBeam (ref), DisplayText (ref), v1 (ref), p1 (copy) ]]
				if ZoneController.Zone == KickReady.Name then
					DisplayBeam(nil)
					DisplayText(nil)
					v1:Clean()
					p1()
				end
			end
			v1:Connect(ZoneController.ZoneChanged, CheckInZone)
			local isName = ZoneController.Zone == KickReady.Name
			if isName then
				DisplayBeam(nil)
				DisplayText(nil)
				v1:Clean()
				p1()
			end
		end
	}
}
function StepChanged() --[[ StepChanged | Line: 452 | Upvalues: LocalPlayer (copy), t (copy), v1 (copy), Network (copy) ]]
	local v12 = LocalPlayer:GetAttribute("TutorialStep")
	local v2 = t.Steps[v12]
	v1:Clean()
	if v2 then
		if not t.InTutorial then
			t.InTutorial = true
		end
		v2(function() --[[ Line: 466 | Upvalues: LocalPlayer (ref), v12 (copy), Network (ref) ]]
			LocalPlayer:SetAttribute("TutorialStep", v12 + 1)
			Network.FireServer("TutorialStep", v12 + 1)
		end, function() --[[ Line: 469 | Upvalues: LocalPlayer (ref), v12 (copy), Network (ref) ]]
			LocalPlayer:SetAttribute("TutorialStep", v12 - 1)
			Network.FireServer("TutorialStep", v12 - 1)
		end)
	else
		t.InTutorial = false
		t.Changed:Fire()
	end
end
function t._init() --[[ _init | Line: 475 | Upvalues: v2 (ref), ClientPlotService (copy), LocalPlayer (copy) ]]
	v2 = ClientPlotService.Model
	StepChanged()
	LocalPlayer:GetAttributeChangedSignal("TutorialStep"):Connect(StepChanged)
end
return t