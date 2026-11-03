-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
require(script.Types)
local v1 = script
local Reference = require(v1.Reference)
local v2 = Reference.getObject()
local v3 = if v2 then v2.Value else v2
if v3 and v3 ~= v1 then
	return require(v3)
else
	if not v2 then
		Reference.addToReplicatedStorage()
	end
	local GoodSignal = require(v1.Packages.GoodSignal)
	local Janitor = require(v1.Packages.Janitor)
	local Utility = require(v1.Utility)
	local Themes = require(v1.Features.Themes)
	local Gamepad = require(v1.Features.Gamepad)
	local Overflow = require(v1.Features.Overflow)
	local t = {}
	t.__index = t
	local LocalPlayer = Players.LocalPlayer
	local t2 = {}
	local v4 = GoodSignal.new()
	local Elements = v1.Elements
	local v5 = 0
	local t3 = {
		mobile = Enum.PreferredInput.Touch,
		desktop = Enum.PreferredInput.KeyboardAndMouse,
		console = Enum.PreferredInput.Gamepad
	}
	t.baseDisplayOrderChanged = GoodSignal.new()
	t.baseDisplayOrder = 10
	t.baseTheme = require(v1.Features.Themes.Default)
	t.isOldTopbar = false
	t.iconsDictionary = t2
	t.insetHeightChanged = GoodSignal.new()
	t.container = require(Elements.Container)(t)
	t.topbarEnabled = true
	t.iconAdded = GoodSignal.new()
	t.iconRemoved = GoodSignal.new()
	t.iconChanged = GoodSignal.new()
	function t.getIcons() --[[ getIcons | Line: 110 | Upvalues: t (copy) ]]
		return t.iconsDictionary
	end
	function t.getIconByUID(p1) --[[ getIconByUID | Line: 114 | Upvalues: t (copy) ]]
		local v1 = t.iconsDictionary[p1]
		if v1 then
			return v1
		else
			return nil
		end
	end
	function t.getIcon(p1) --[[ getIcon | Line: 122 | Upvalues: t (copy), t2 (copy) ]]
		local v1 = t.getIconByUID(p1)
		if v1 then
			return v1
		else
			for k, v in pairs(t2) do
				if v.name == p1 then
					return v
				end
			end
			return nil
		end
	end
	function t.setTopbarEnabled(p1, p2) --[[ setTopbarEnabled | Line: 135 | Upvalues: t (copy) ]]
		if typeof(p1) ~= "boolean" then
			p1 = t.topbarEnabled
		end
		if not p2 then
			t.topbarEnabled = p1
		end
		for k, v in pairs(t.container) do
			v.Enabled = p1
		end
	end
	function t.modifyBaseTheme(p1) --[[ modifyBaseTheme | Line: 147 | Upvalues: Themes (copy), t (copy), t2 (copy) ]]
		for k, v in pairs((Themes.getModifications(p1))) do
			for k2, v2 in pairs(t.baseTheme) do
				Themes.merge(v2, v)
			end
		end
		for k, v in pairs(t2) do
			v:setTheme(t.baseTheme)
		end
	end
	function t.setDisplayOrder(p1) --[[ setDisplayOrder | Line: 159 | Upvalues: t (copy) ]]
		t.baseDisplayOrder = p1
		t.baseDisplayOrderChanged:Fire(p1)
	end
	task.defer(Gamepad.start, t)
	task.defer(Overflow.start, t)
	task.defer(function() --[[ Line: 169 | Upvalues: LocalPlayer (copy), t (copy), v1 (copy) ]]
		local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		for k, v in pairs(t.container) do
			v.Parent = PlayerGui
		end
		require(v1.Attribute)
	end)
	function t.new() --[[ new | Line: 180 | Upvalues: t (copy), Janitor (copy), Utility (copy), t2 (copy), GoodSignal (copy), v1 (copy), Elements (copy), v5 (ref), UserInputService (copy), t3 (copy), v4 (copy), StarterGui (copy) ]]
		local t4 = {}
		local v12 = t
		setmetatable(t4, v12)
		local v2 = Janitor.new()
		t4.janitor = v2
		t4.themesJanitor = v2:add(Janitor.new())
		t4.singleClickJanitor = v2:add(Janitor.new())
		t4.captionJanitor = v2:add(Janitor.new())
		t4.joinJanitor = v2:add(Janitor.new())
		t4.menuJanitor = v2:add(Janitor.new())
		t4.dropdownJanitor = v2:add(Janitor.new())
		local v3 = Utility.generateUID()
		t2[v3] = t4
		v2:add(function() --[[ Line: 197 | Upvalues: t2 (ref), v3 (copy) ]]
			t2[v3] = nil
		end)
		t4.selected = v2:add(GoodSignal.new())
		t4.deselected = v2:add(GoodSignal.new())
		t4.toggled = v2:add(GoodSignal.new())
		t4.viewingStarted = v2:add(GoodSignal.new())
		t4.viewingEnded = v2:add(GoodSignal.new())
		t4.stateChanged = v2:add(GoodSignal.new())
		t4.notified = v2:add(GoodSignal.new())
		t4.noticeStarted = v2:add(GoodSignal.new())
		t4.noticeChanged = v2:add(GoodSignal.new())
		t4.endNotices = v2:add(GoodSignal.new())
		t4.toggleKeyAdded = v2:add(GoodSignal.new())
		t4.fakeToggleKeyChanged = v2:add(GoodSignal.new())
		t4.alignmentChanged = v2:add(GoodSignal.new())
		t4.updateSize = v2:add(GoodSignal.new())
		t4.resizingComplete = v2:add(GoodSignal.new())
		t4.joinedParent = v2:add(GoodSignal.new())
		t4.menuSet = v2:add(GoodSignal.new())
		t4.dropdownSet = v2:add(GoodSignal.new())
		t4.updateMenu = v2:add(GoodSignal.new())
		t4.startMenuUpdate = v2:add(GoodSignal.new())
		t4.childThemeModified = v2:add(GoodSignal.new())
		t4.indicatorSet = v2:add(GoodSignal.new())
		t4.dropdownChildAdded = v2:add(GoodSignal.new())
		t4.menuChildAdded = v2:add(GoodSignal.new())
		t4.iconModule = v1
		t4.UID = v3
		t4.isEnabled = true
		t4.enabled = t4.isEnabled
		t4.isSelected = false
		t4.isViewing = false
		t4.joinedFrame = false
		t4.parentIconUID = false
		t4.deselectWhenOtherIconSelected = true
		t4.totalNotices = 0
		t4.activeState = "Deselected"
		t4.alignment = ""
		t4.originalAlignment = ""
		t4.appliedTheme = {}
		t4.appearance = {}
		t4.cachedInstances = {}
		t4.cachedNamesToInstances = {}
		t4.cachedCollectives = {}
		t4.bindedToggleKeys = {}
		t4.customBehaviours = {}
		t4.toggleItems = {}
		t4.bindedEvents = {}
		t4.notices = {}
		t4.menuIcons = {}
		t4.dropdownIcons = {}
		t4.childIconsDict = {}
		t4.creationTime = os.clock()
		t4.widget = v2:add(require(Elements.Widget)(t4, t))
		t4:setAlignment()
		v5 = v5 + 1
		local v42 = v5 * 0.01 + 1
		t4:setOrder(v42, "deselected")
		t4:setOrder(v42, "selected")
		t4:setTheme(t.baseTheme)
		local v52 = t4:getInstance("ClickRegion")
		local v6 = false
		local v7 = 0
		local function handleToggle() --[[ handleToggle | Line: 277 | Upvalues: t4 (copy), v7 (ref) ]]
			if not t4.locked then
				local v1 = tick()
				if not (v1 - v7 < 0.1) then
					v7 = v1
					if t4.isSelected then
						t4:deselect("User", t4)
					else
						t4:select("User", t4)
					end
				end
			end
		end
		v52.MouseButton1Click:Connect(function() --[[ Line: 296 | Upvalues: v6 (ref), t4 (copy), v7 (ref) ]]
			v6 = true
			if not t4.locked then
				local v1 = tick()
				if not (v1 - v7 < 0.1) then
					v7 = v1
					if t4.isSelected then
						t4:deselect("User", t4)
					else
						t4:select("User", t4)
					end
				end
			end
		end)
		v52.TouchTap:Connect(function() --[[ Line: 301 | Upvalues: v6 (ref), t4 (copy), v7 (ref) ]]
			if not v6 then
				if t4.locked then
					return
				end
				local v1 = tick()
				if v1 - v7 < 0.1 then
					return
				end
				v7 = v1
				if t4.isSelected then
					t4:deselect("User", t4)
					return
				end
				t4:select("User", t4)
			end
		end)
		v2:add(UserInputService.InputBegan:Connect(function(p1, p2) --[[ Line: 314 | Upvalues: t4 (copy), v7 (ref) ]]
			if not t4.locked and (t4.bindedToggleKeys[p1.KeyCode] and not p2) then
				if t4.locked then
					return
				end
				local v1 = tick()
				if v1 - v7 < 0.1 then
					return
				end
				v7 = v1
				if t4.isSelected then
					t4:deselect("User", t4)
					return
				end
				t4:select("User", t4)
			end
		end))
		local function viewingStarted(p1) --[[ viewingStarted | Line: 326 | Upvalues: t4 (copy) ]]
			if not t4.locked then
				t4.isViewing = true
				t4.viewingStarted:Fire(true)
				if not p1 then
					t4:setState("Viewing", "User", t4)
				end
			end
		end
		local function viewingEnded() --[[ viewingEnded | Line: 336 | Upvalues: t4 (copy) ]]
			if not t4.locked then
				t4.isViewing = false
				t4.viewingEnded:Fire(true)
				t4:setState(nil, "User", t4)
			end
		end
		t4.joinedParent:Connect(function() --[[ Line: 344 | Upvalues: t4 (copy) ]]
			if t4.isViewing then
				if t4.locked then
					return
				end
				t4.isViewing = false
				t4.viewingEnded:Fire(true)
				t4:setState(nil, "User", t4)
			end
		end)
		v52.MouseEnter:Connect(function() --[[ Line: 349 | Upvalues: UserInputService (ref), t3 (ref), t4 (copy) ]]
			local isNotDesktop = UserInputService.PreferredInput ~= t3.desktop
			if not t4.locked then
				t4.isViewing = true
				t4.viewingStarted:Fire(true)
				if not isNotDesktop then
					t4:setState("Viewing", "User", t4)
				end
			end
		end)
		local v8 = 0
		v2:add(UserInputService.TouchEnded:Connect(viewingEnded))
		v52.MouseLeave:Connect(viewingEnded)
		v52.SelectionGained:Connect(viewingStarted)
		v52.SelectionLost:Connect(viewingEnded)
		v52.MouseButton1Down:Connect(function() --[[ Line: 358 | Upvalues: t4 (copy), UserInputService (ref), t3 (ref), v8 (ref) ]]
			if not t4.locked and UserInputService.PreferredInput == t3.mobile then
				v8 = v8 + 1
				local v1 = v8
				task.delay(0.2, function() --[[ Line: 362 | Upvalues: v1 (copy), v8 (ref), t4 (ref) ]]
					if v1 == v8 then
						if t4.locked then
							return
						end
						t4.isViewing = true
						t4.viewingStarted:Fire(true)
						t4:setState("Viewing", "User", t4)
					end
				end)
			end
		end)
		v52.MouseButton1Up:Connect(function() --[[ Line: 369 | Upvalues: v8 (ref) ]]
			v8 = v8 + 1
		end)
		local v9 = t4:getInstance("IconOverlay")
		t4.viewingStarted:Connect(function() --[[ Line: 375 | Upvalues: v9 (copy), t4 (copy) ]]
			v9.Visible = not t4.overlayDisabled
		end)
		t4.viewingEnded:Connect(function() --[[ Line: 378 | Upvalues: v9 (copy) ]]
			v9.Visible = false
		end)
		v2:add(v4:Connect(function(p1) --[[ Line: 383 | Upvalues: t4 (copy) ]]
			if p1 ~= t4 and (t4.deselectWhenOtherIconSelected and p1.deselectWhenOtherIconSelected) then
				t4:deselect("AutoDeselect", p1)
			end
		end))
		local v11 = string.split(debug.info(2, "s"), ".")
		local v122 = game
		local v13 = nil
		for k, v in pairs(v11) do
			local v14 = v122:FindFirstChild(v)
			if v14 and v14:IsA("ScreenGui") then
				v122 = v14
				v13 = v14
			end
			v122 = v14
			break
		end
		if v122 and (v13 and v13.ResetOnSpawn == true) then
			t4.originsScreenGui = v13
			Utility.localPlayerRespawned(function() --[[ Line: 409 | Upvalues: t4 (copy) ]]
				t4:destroy()
			end)
		end
		t4.toggled:Connect(function(p1) --[[ Line: 415 | Upvalues: t4 (copy), t (ref) ]]
			t4.noticeChanged:Fire(t4.totalNotices)
			for k, v in pairs(t4.childIconsDict) do
				local v1 = t.getIconByUID(k)
				v1.noticeChanged:Fire(v1.totalNotices)
				if not p1 and v1.isSelected then
					for k2, v2 in pairs(v1.childIconsDict) do
						v1:deselect("HideParentFeature", t4)
					end
				end
			end
		end)
		t4.selected:Connect(function() --[[ Line: 438 | Upvalues: t4 (copy), StarterGui (ref) ]]
			if #t4.dropdownIcons > 0 then
				if StarterGui:GetCore("ChatActive") and t4.alignment ~= "Right" then
					t4.chatWasPreviouslyActive = true
					StarterGui:SetCore("ChatActive", false)
				end
				if not StarterGui:GetCoreGuiEnabled("PlayerList") or t4.alignment == "Left" then
					return
				end
				t4.playerlistWasPreviouslyActive = true
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			end
		end)
		t4.deselected:Connect(function() --[[ Line: 451 | Upvalues: t4 (copy), StarterGui (ref) ]]
			if t4.chatWasPreviouslyActive then
				t4.chatWasPreviouslyActive = nil
				StarterGui:SetCore("ChatActive", true)
			end
			if t4.playerlistWasPreviouslyActive then
				t4.playerlistWasPreviouslyActive = nil
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
			end
		end)
		task.delay(0.1, function() --[[ Line: 465 | Upvalues: t4 (copy) ]]
			if t4.activeState == "Deselected" then
				t4.stateChanged:Fire("Deselected")
				t4:refresh()
			end
		end)
		t.iconAdded:Fire(t4)
		return t4
	end
	function t.setName(p1, p2) --[[ setName | Line: 481 ]]
		p1.widget.Name = p2
		p1.name = p2
		return p1
	end
	function t.setState(p1, p2, p3, p4) --[[ setState | Line: 487 | Upvalues: Utility (copy), v4 (copy) ]]
		if not p2 then
			p2 = if p1.isSelected then "Selected" else "Deselected"
		end
		local v2 = Utility.formatStateName(p2)
		if p1.activeState ~= v2 then
			local isSelected = p1.isSelected
			p1.activeState = v2
			if v2 == "Deselected" then
				p1.isSelected = false
				if isSelected then
					p1.toggled:Fire(false, p3, p4)
					p1.deselected:Fire(p3, p4)
				end
				p1:_setToggleItemsVisible(false, p3, p4)
			elseif v2 == "Selected" then
				p1.isSelected = true
				if not isSelected then
					p1.toggled:Fire(true, p3, p4)
					p1.selected:Fire(p3, p4)
					v4:Fire(p1, p3, p4)
				end
				p1:_setToggleItemsVisible(true, p3, p4)
			end
			p1.stateChanged:Fire(v2, p3, p4)
		end
	end
	function t.getInstance(p1, p2) --[[ getInstance | Line: 520 | Upvalues: Themes (copy) ]]
		local v1 = p1.cachedNamesToInstances[p2]
		if v1 then
			return v1
		else
			local function cacheInstance(p12, p2) --[[ cacheInstance | Line: 528 | Upvalues: p1 (copy) ]]
				if not p1.cachedInstances[p2] then
					local v1 = p2:GetAttribute("Collective")
					local v2 = if v1 then p1.cachedCollectives[v1] else v1
					if v2 then
						table.insert(v2, p2)
					end
					p1.cachedNamesToInstances[p12] = p2
					p1.cachedInstances[p2] = true
					p2.Destroying:Once(function() --[[ Line: 538 | Upvalues: p1 (ref), p12 (copy), p2 (copy) ]]
						p1.cachedNamesToInstances[p12] = nil
						p1.cachedInstances[p2] = nil
					end)
				end
			end
			local widget = p1.widget
			cacheInstance("Widget", widget)
			if p2 == "Widget" then
				return widget
			else
				local v2 = nil
				local function v3(p12) --[[ scanChildren | Line: 551 | Upvalues: p1 (copy), Themes (ref), v3 (copy), cacheInstance (copy), p2 (copy), v2 (ref) ]]
					for k, v in pairs(p12:GetChildren()) do
						local v1 = v:GetAttribute("WidgetUID")
						if not v1 or v1 == p1.UID then
							local v22 = Themes.getRealInstance(v)
							if v22 then
								v = v22
							end
							v3(v)
							if v:IsA("GuiBase") or (v:IsA("UIBase") or v:IsA("ValueBase")) then
								local v32 = v.Name
								cacheInstance(v32, v)
								if v32 == p2 then
									v2 = v
								end
							end
						end
					end
				end
				v3(widget)
				return v2
			end
		end
	end
	function t.getCollective(p1, p2) --[[ getCollective | Line: 580 ]]
		local v1 = p1.cachedCollectives[p2]
		if v1 then
			return v1
		else
			local t = {}
			for k, v in pairs(p1.cachedInstances) do
				if k:GetAttribute("Collective") == p2 then
					table.insert(t, k)
				end
			end
			p1.cachedCollectives[p2] = t
			return t
		end
	end
	function t.getInstanceOrCollective(p1, p2) --[[ getInstanceOrCollective | Line: 601 ]]
		local t = {}
		local v1 = p1:getInstance(p2)
		if v1 then
			table.insert(t, v1)
		end
		if #t == 0 then
			t = p1:getCollective(p2)
		end
		return t
	end
	function t.getStateGroup(p1, p2) --[[ getStateGroup | Line: 615 ]]
		local v1 = if p2 then p2 else p1.activeState
		local v2 = p1.appearance[v1]
		if not v2 then
			v2 = {}
			p1.appearance[v1] = v2
		end
		return v2
	end
	function t.refreshAppearance(p1, p2, p3) --[[ refreshAppearance | Line: 625 | Upvalues: Themes (copy) ]]
		Themes.refresh(p1, p2, p3)
		return p1
	end
	function t.refresh(p1) --[[ refresh | Line: 630 ]]
		p1:refreshAppearance(p1.widget)
		p1.updateSize:Fire()
		return p1
	end
	function t.updateParent(p1) --[[ updateParent | Line: 636 | Upvalues: t (copy) ]]
		local v1 = t.getIconByUID(p1.parentIconUID)
		if v1 then
			v1.updateSize:Fire()
		end
	end
	function t.setBehaviour(p1, p2, p3, p4, p5) --[[ setBehaviour | Line: 643 ]]
		p1.customBehaviours[p2 .. "-" .. p3] = p4
		if p5 then
			for k, v in pairs((p1:getInstanceOrCollective(p2))) do
				p1:refreshAppearance(v, p3)
			end
		end
	end
	function t.modifyTheme(p1, p2, p3) --[[ modifyTheme | Line: 656 | Upvalues: Themes (copy) ]]
		return p1, Themes.modify(p1, p2, p3)
	end
	function t.modifyChildTheme(p1, p2, p3) --[[ modifyChildTheme | Line: 661 | Upvalues: t (copy) ]]
		p1.childModifications = p2
		p1.childModificationsUID = p3
		for k, v in pairs(p1.childIconsDict) do
			t.getIconByUID(k):modifyTheme(p2, p3)
		end
		p1.childThemeModified:Fire()
		return p1
	end
	function t.removeModification(p1, p2) --[[ removeModification | Line: 674 | Upvalues: Themes (copy) ]]
		Themes.remove(p1, p2)
		return p1
	end
	function t.removeModificationWith(p1, p2, p3, p4) --[[ removeModificationWith | Line: 679 | Upvalues: Themes (copy) ]]
		Themes.removeWith(p1, p2, p3, p4)
		return p1
	end
	function t.setTheme(p1, p2) --[[ setTheme | Line: 684 | Upvalues: Themes (copy) ]]
		Themes.set(p1, p2)
		return p1
	end
	function t.setEnabled(p1, p2) --[[ setEnabled | Line: 689 ]]
		p1.isEnabled = p2
		p1.enabled = p1.isEnabled
		p1.widget.Visible = p2
		p1:updateParent()
		return p1
	end
	function t.select(p1, p2, p3) --[[ select | Line: 697 ]]
		p1:setState("Selected", p2, p3)
		return p1
	end
	function t.deselect(p1, p2, p3) --[[ deselect | Line: 702 ]]
		p1:setState("Deselected", p2, p3)
		return p1
	end
	function t.notify(p1, p2, p3) --[[ notify | Line: 707 | Upvalues: Elements (copy), t (copy) ]]
		if not p1.notice then
			p1.notice = require(Elements.Notice)(p1, t)
		end
		p1.noticeStarted:Fire(p2, p3)
		return p1
	end
	function t.clearNotices(p1) --[[ clearNotices | Line: 721 ]]
		p1.endNotices:Fire()
		return p1
	end
	function t.disableOverlay(p1, p2) --[[ disableOverlay | Line: 726 ]]
		p1.overlayDisabled = p2
		return p1
	end
	t.disableStateOverlay = t.disableOverlay
	function t.setImage(p1, p2, p3) --[[ setImage | Line: 732 | Upvalues: ContentProvider (copy) ]]
		p1:modifyTheme({ "IconImage", "Image", p2, p3 })
		task.spawn(function() --[[ Line: 736 | Upvalues: p2 (copy), ContentProvider (ref) ]]
			local v2 = if tonumber(p2) then ("rbxassetid://%*"):format(p2) else p2
			if ContentProvider:GetAssetFetchStatus(v2) ~= Enum.AssetFetchStatus.Success then
				pcall(ContentProvider.PreloadAsync, ContentProvider, { v2 })
			end
		end)
		return p1
	end
	function t.setLabel(p1, p2, p3) --[[ setLabel | Line: 748 ]]
		p1:modifyTheme({ "IconLabel", "Text", p2, p3 })
		return p1
	end
	function t.setOrder(p1, p2, p3) --[[ setOrder | Line: 753 ]]
		local v1 = p2 * 100
		p1:modifyTheme({ "IconSpot", "LayoutOrder", v1, p3 })
		p1:modifyTheme({ "Widget", "LayoutOrder", v1, p3 })
		return p1
	end
	function t.setCornerRadius(p1, p2, p3) --[[ setCornerRadius | Line: 762 ]]
		p1:modifyTheme({ "IconCorners", "CornerRadius", p2, p3 })
		return p1
	end
	function t.align(p1, p2, p3) --[[ align | Line: 767 | Upvalues: t (copy) ]]
		local v1 = tostring(p2):lower()
		if v1 == "mid" or v1 == "centre" then
			v1 = "center"
		end
		if v1 ~= "left" and (v1 ~= "center" and v1 ~= "right") then
			v1 = "left"
		end
		local v2 = v1 == "center" and t.container.TopbarCentered or t.container.TopbarStandard
		local v3 = string.upper((string.sub(v1, 1, 1))) .. string.sub(v1, 2)
		if not p3 then
			p1.originalAlignment = v3
		end
		local joinedFrame = p1.joinedFrame
		local v4 = v2.Holders[v3]
		p1.screenGui = v2
		p1.alignmentHolder = v4
		if not p1.isDestroyed then
			p1.widget.Parent = joinedFrame or v4
		end
		p1.alignment = v3
		p1.alignmentChanged:Fire(v3)
		t.iconChanged:Fire(p1)
		return p1
	end
	t.setAlignment = t.align
	function t.setLeft(p1) --[[ setLeft | Line: 796 ]]
		p1:setAlignment("Left")
		return p1
	end
	function t.setMid(p1) --[[ setMid | Line: 801 ]]
		p1:setAlignment("Center")
		return p1
	end
	function t.setRight(p1) --[[ setRight | Line: 806 ]]
		p1:setAlignment("Right")
		return p1
	end
	function t.setWidth(p1, p2, p3) --[[ setWidth | Line: 811 ]]
		p1:modifyTheme({ "Widget", "DesiredWidth", p2, p3 })
		return p1
	end
	function t.setImageScale(p1, p2, p3) --[[ setImageScale | Line: 819 ]]
		p1:modifyTheme({ "IconImageScale", "Value", p2, p3 })
		return p1
	end
	function t.setImageRatio(p1, p2, p3) --[[ setImageRatio | Line: 824 ]]
		p1:modifyTheme({ "IconImageRatio", "AspectRatio", p2, p3 })
		return p1
	end
	function t.setTextSize(p1, p2, p3) --[[ setTextSize | Line: 829 ]]
		p1:modifyTheme({ "IconLabel", "TextSize", p2, p3 })
		return p1
	end
	function t.setTextFont(p1, p2, p3, p4, p5) --[[ setTextFont | Line: 834 ]]
		local v1 = if p3 then p3 else Enum.FontWeight.Regular
		local v2 = if p4 then p4 else Enum.FontStyle.Normal
		local v3 = nil
		local v4 = typeof(p2)
		local v5, v6
		if v4 == "number" then
			v3, v5, v6 = Font.fromId(p2, v1, v2), v1, v2
		elseif v4 == "EnumItem" then
			v3, v5, v6 = Font.fromEnum(p2), v1, v2
		elseif v4 == "string" and not p2:match("rbxasset") then
			v3, v5, v6 = Font.fromName(p2, v1, v2), v1, v2
		else
			v5 = v1
			v6 = v2
		end
		if not v3 then
			v3 = Font.new(p2, v5, v6)
		end
		p1:modifyTheme({ "IconLabel", "FontFace", v3, p5 })
		return p1
	end
	function t.setTextColor(p1, p2, p3) --[[ setTextColor | Line: 855 ]]
		if p2 == nil or (p2 == "" or (type(p2) ~= "userdata" or typeof(p2) ~= "Color3")) then
			if p2 ~= nil and p2 ~= "" then
				warn("setTextColor item must be a Color3 value! Changed the color to white.")
			end
			p2 = Color3.fromRGB(255, 255, 255)
		end
		p1:modifyTheme({ "IconLabel", "TextColor3", p2, p3 })
		return p1
	end
	function t.bindToggleItem(p1, p2) --[[ bindToggleItem | Line: 867 ]]
		if not (p2:IsA("GuiObject") or p2:IsA("LayerCollector")) then
			error("Toggle item must be a GuiObject or LayerCollector!")
		end
		p1.toggleItems[p2] = true
		p1:_updateSelectionInstances()
		return p1
	end
	function t.unbindToggleItem(p1, p2) --[[ unbindToggleItem | Line: 876 ]]
		p1.toggleItems[p2] = nil
		p1:_updateSelectionInstances()
		return p1
	end
	function t._updateSelectionInstances(p1) --[[ _updateSelectionInstances | Line: 882 ]]
		for k, v in pairs(p1.toggleItems) do
			local t = {}
			for k2, v2 in pairs(k:GetDescendants()) do
				if (v2:IsA("TextButton") or v2:IsA("ImageButton")) and v2.Active then
					table.insert(t, v2)
				end
			end
			p1.toggleItems[k] = t
		end
	end
	function t._setToggleItemsVisible(p1, p2, p3, p4) --[[ _setToggleItemsVisible | Line: 896 ]]
		for k, v in pairs(p1.toggleItems) do
			if not p4 or (p4 == p1 or p4.toggleItems[k] == nil) then
				k[if k:IsA("LayerCollector") then "Enabled" else "Visible"] = p2
			end
		end
	end
	function t.bindEvent(p1, p2, p3) --[[ bindEvent | Line: 908 ]]
		local v1 = p1[p2]
		assert(if v1 then if typeof(v1) == "table" then v1.Connect else false else v1, "argument[1] must be a valid topbarplus icon event name!")
		assert(if typeof(p3) == "function" then true else false, "argument[2] must be a function!")
		p1.bindedEvents[p2] = v1:Connect(function(...) --[[ Line: 912 | Upvalues: p3 (copy), p1 (copy) ]]
			p3(p1, ...)
		end)
		return p1
	end
	function t.unbindEvent(p1, p2) --[[ unbindEvent | Line: 918 ]]
		local v1 = p1.bindedEvents[p2]
		if v1 then
			v1:Disconnect()
			p1.bindedEvents[p2] = nil
		end
		return p1
	end
	function t.bindToggleKey(p1, p2) --[[ bindToggleKey | Line: 927 ]]
		assert(if typeof(p2) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
		p1.bindedToggleKeys[p2] = true
		p1.toggleKeyAdded:Fire(p2)
		p1:setCaption("_hotkey_")
		return p1
	end
	function t.unbindToggleKey(p1, p2) --[[ unbindToggleKey | Line: 935 ]]
		assert(if typeof(p2) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
		p1.bindedToggleKeys[p2] = nil
		return p1
	end
	function t.call(p1, p2, ...) --[[ call | Line: 941 ]]
		local v1 = table.pack(...)
		task.spawn(function() --[[ Line: 943 | Upvalues: p2 (copy), p1 (copy), v1 (copy) ]]
			p2(p1, table.unpack(v1))
		end)
		return p1
	end
	function t.addToJanitor(p1, p2, p3, p4) --[[ addToJanitor | Line: 949 ]]
		p1.janitor:add(p2, p3, p4)
		return p1
	end
	function t.lock(p1) --[[ lock | Line: 954 ]]
		p1:getInstance("ClickRegion").Visible = false
		p1.locked = true
		return p1
	end
	function t.unlock(p1) --[[ unlock | Line: 962 ]]
		p1:getInstance("ClickRegion").Visible = true
		p1.locked = false
		return p1
	end
	function t.debounce(p1, p2) --[[ debounce | Line: 969 ]]
		p1:lock()
		task.wait(p2)
		p1:unlock()
		return p1
	end
	function t.autoDeselect(p1, p2) --[[ autoDeselect | Line: 976 ]]
		if p2 == nil then
			p2 = true
		end
		p1.deselectWhenOtherIconSelected = p2
		return p1
	end
	function t.oneClick(p1, p2) --[[ oneClick | Line: 986 ]]
		local singleClickJanitor = p1.singleClickJanitor
		singleClickJanitor:clean()
		if p2 or p2 == nil then
			singleClickJanitor:add(p1.selected:Connect(function() --[[ Line: 992 | Upvalues: p1 (copy) ]]
				p1:deselect("OneClick", p1)
			end))
		end
		p1.oneClickEnabled = true
		return p1
	end
	function t.setCaption(p1, p2) --[[ setCaption | Line: 1000 | Upvalues: Elements (copy) ]]
		if p2 ~= "_hotkey_" or not p1.captionText then
			local captionJanitor = p1.captionJanitor
			p1.captionJanitor:clean()
			if p2 and p2 ~= "" then
				local v1 = captionJanitor:add(require(Elements.Caption)(p1))
				v1:SetAttribute("CaptionText", p2)
				p1.caption = v1
				p1.captionText = p2
			else
				p1.caption = nil
				p1.captionText = nil
			end
		end
		return p1
	end
	function t.setCaptionHint(p1, p2) --[[ setCaptionHint | Line: 1018 ]]
		assert(if typeof(p2) == "EnumItem" then true else false, "argument[1] must be a KeyCode EnumItem!")
		p1.fakeToggleKey = p2
		p1.fakeToggleKeyChanged:Fire(p2)
		p1:setCaption("_hotkey_")
		return p1
	end
	function t.leave(p1) --[[ leave | Line: 1026 ]]
		p1.joinJanitor:clean()
		return p1
	end
	function t.joinMenu(p1, p2) --[[ joinMenu | Line: 1032 | Upvalues: Utility (copy) ]]
		Utility.joinFeature(p1, p2, p2.menuIcons, p2:getInstance("Menu"))
		p2.menuChildAdded:Fire(p1)
		return p1
	end
	function t.setMenu(p1, p2) --[[ setMenu | Line: 1038 ]]
		p1.menuSet:Fire(p2)
		return p1
	end
	function t.setFixedMenu(p1, p2) --[[ setFixedMenu | Line: 1043 ]]
		p1:freezeMenu(p2)
		p1:setMenu(p2)
	end
	t.setFrozenMenu = t.setFixedMenu
	function t.freezeMenu(p1) --[[ freezeMenu | Line: 1049 ]]
		p1:select("FrozenMenu", p1)
		p1:bindEvent("deselected", function(p12) --[[ Line: 1053 | Upvalues: p1 (copy) ]]
			p12:select("FrozenMenu", p1)
		end)
		p1:modifyTheme({ "IconSpot", "Visible", false })
	end
	function t.joinDropdown(p1, p2) --[[ joinDropdown | Line: 1059 | Upvalues: Utility (copy) ]]
		p2:getDropdown()
		Utility.joinFeature(p1, p2, p2.dropdownIcons, p2:getInstance("DropdownScroller"))
		p2.dropdownChildAdded:Fire(p1)
		return p1
	end
	function t.getDropdown(p1) --[[ getDropdown | Line: 1066 | Upvalues: Elements (copy) ]]
		local dropdown = p1.dropdown
		if not dropdown then
			local v1 = require(Elements.Dropdown)(p1)
			p1.dropdown = v1
			p1:clipOutside(v1)
			dropdown = v1
		end
		return dropdown
	end
	function t.setDropdown(p1, p2) --[[ setDropdown | Line: 1076 ]]
		p1:getDropdown()
		p1.dropdownSet:Fire(p2)
		return p1
	end
	function t.clipOutside(p1, p2) --[[ clipOutside | Line: 1082 | Upvalues: Utility (copy) ]]
		local v1 = Utility.clipOutside(p1, p2)
		p1:refreshAppearance(p2)
		return p1, v1
	end
	function t.setIndicator(p1, p2) --[[ setIndicator | Line: 1093 | Upvalues: Elements (copy), t (copy) ]]
		if not p1.indicator then
			p1.indicator = p1.janitor:add(require(Elements.Indicator)(p1, t))
		end
		p1.indicatorSet:Fire(p2)
	end
	function t.convertLabelToNumberSpinner(p1, p2, p3) --[[ convertLabelToNumberSpinner | Line: 1105 ]]
		task.defer(function() --[[ Line: 1106 | Upvalues: p1 (copy), p2 (copy), p3 (copy) ]]
			local v1 = p1:getInstance("IconLabel")
			v1.Transparency = 1
			p2.Parent = v1.Parent
			p2.Size = UDim2.fromScale(1, 1)
			p2.AnchorPoint = Vector2.new(0.5, 0.5)
			p2.Position = UDim2.new(0.5, 0, 0.5, 0)
			p2.TextXAlignment = Enum.TextXAlignment.Center
			p2.ClipsDescendants = false
			for i, v in ipairs({ "FontFace", "BorderSizePixel", "BorderColor3", "Rotation", "TextStrokeTransparency", "TextStrokeColor3", "TextStrokeTransparency", "TextColor3" }) do
				p2[v] = v1[v]
				p1:addToJanitor(v1:GetPropertyChangedSignal(v):Connect(function() --[[ Line: 1129 | Upvalues: p2 (ref), v (copy), v1 (copy) ]]
					p2[v] = v1[v]
				end))
			end
			local function getSpinnerSizeAndDigitCount() --[[ getSpinnerSizeAndDigitCount | Line: 1136 | Upvalues: p2 (ref) ]]
				local sum = 0
				local count = 0
				for v1, v2 in p2.Frame:GetChildren() do
					local v3 = string.lower(v2.Name)
					if v3 == "digit" then
						sum = sum + v2.AbsoluteSize.X
						count = count + 1
					end
					if (v3 == "prefix" or (v3 == "suffix" or v3 == "comma")) and v2.Text ~= "" then
						sum = sum + v2.AbsoluteSize.X
						count = count + 1
					end
				end
				return sum, count
			end
			local function getLabelParentContainerXSize() --[[ getLabelParentContainerXSize | Line: 1154 | Upvalues: v1 (copy), p2 (ref) ]]
				local v12 = v1.Parent
				local v2 = if v12 then v12.Parent else v12
				if v2 == nil then
					return 0
				elseif v2.IconImage.Visible == true then
					return p2.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X
				else
					return v2.AbsoluteSize.X
				end
			end
			local function getNumberSpinnerXSize() --[[ getNumberSpinnerXSize | Line: 1166 | Upvalues: p2 (ref) ]]
				return p2.Frame.AbsoluteSize.X
			end
			local function adjustSize() --[[ adjustSize | Line: 1170 | Upvalues: getSpinnerSizeAndDigitCount (copy), p1 (ref), p2 (ref), v1 (copy) ]]
				local v12, v2 = getSpinnerSizeAndDigitCount()
				if v2 < 18 then
					p1:setLabel(p2.Value)
				end
				local X = p2.Frame.AbsoluteSize.X
				local v3, v4, v5, v6, v7, v8, v9, v10
				while true do
					if not (v12 < X) or p1.isDestroyed == true then
						v3 = v1.Parent
						v4 = if v3 then v3.Parent else v3
						v5 = if v4 == nil then 0 elseif v4.IconImage.Visible == true then p2.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v4.AbsoluteSize.X
						while v5 < v12 and p1.isDestroyed ~= true do
							task.wait(0.05)
							if v2 < 8 and v2 > 0 then
								p2.TextSize = v1.TextSize
								return
							end
							v6 = p2
							p2.TextSize = p2.TextSize - 1
							v7 = v1.Parent
							v8 = if v7 then v7.Parent else v7
							v5 = if v8 == nil then 0 elseif v8.IconImage.Visible == true then p2.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v8.AbsoluteSize.X
							v9, v10 = getSpinnerSizeAndDigitCount()
							v12, v2 = v9, v10
						end
						return
					end
					task.wait(0.05)
					if v2 > 0 and v2 < 8 then
						break
					end
					local v11 = p2
					v11.TextSize = v11.TextSize + 1
					X = p2.Frame.AbsoluteSize.X
					local v122, v13 = getSpinnerSizeAndDigitCount()
					v12 = v122
					v2 = v13
				end
				p2.TextSize = v1.TextSize
				v3 = v1.Parent
				v4 = if v3 then v3.Parent else v3
				v5 = if v4 == nil then 0 elseif v4.IconImage.Visible == true then p2.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v4.AbsoluteSize.X
				while v5 < v12 and p1.isDestroyed ~= true do
					task.wait(0.05)
					if v2 < 8 and v2 > 0 then
						p2.TextSize = v1.TextSize
						return
					end
					v6 = p2
					p2.TextSize = p2.TextSize - 1
					v7 = v1.Parent
					v8 = if v7 then v7.Parent else v7
					v5 = if v8 == nil then 0 elseif v8.IconImage.Visible == true then p2.Frame.AbsoluteSize.X + v1.Parent.Parent.IconImage.AbsoluteSize.X else v8.AbsoluteSize.X
					v9, v10 = getSpinnerSizeAndDigitCount()
					v12, v2 = v9, v10
				end
			end
			p1:addToJanitor(p2.Frame.ChildAdded:Connect(adjustSize))
			p1:addToJanitor(p2.Frame.ChildRemoved:Connect(adjustSize))
			p1:addToJanitor(p1.iconAdded:Connect(function() --[[ Line: 1208 | Upvalues: adjustSize (copy) ]]
				task.wait(1)
				adjustSize()
			end))
			p1:updateParent()
			p2.Name = "LabelSpinner"
			p2.Prefix = "$"
			p2.Commas = true
			p2.Decimals = 0
			p2.Duration = 0.25
			p2.Value = 10
			task.wait(0.2)
			if typeof(p3) == "function" then
				p3()
			end
		end)
		return p1
	end
	function t.destroy(p1) --[[ destroy | Line: 1235 | Upvalues: t (copy) ]]
		if not p1.isDestroyed then
			p1:clearNotices()
			if p1.parentIconUID then
				p1:leave()
			end
			p1.isDestroyed = true
			p1.janitor:clean()
			t.iconRemoved:Fire(p1)
		end
	end
	t.Destroy = t.destroy
	return t
end