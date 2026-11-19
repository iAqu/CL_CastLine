-- Client: real modules and a detached GUI clone; no purchases or persistent UI edits.
local storage = game:GetService("ReplicatedStorage")
local config = require(storage.Modules.RarityConfig)
local presentation = require(storage.Modules.RarityPresentation)
local selectBait = require(storage.Modules.FishingBaitSelect)
local source = game:GetService("StarterGui").BaitSelectGui
local baits = table.clone(require(game:GetService("ReplicatedFirst").Data.BaitsData))
local ids, quotes = { "Bait_114", "Bait_115" }, {
	Bait_114 = { available = false, price = 123 },
	Bait_115 = { available = true, tier = 4, credits = 1 },
}
for _, rarity in ipairs(config.List) do
	local id = "Validation_" .. rarity.Name
	baits[id] = { DisplayName = rarity.Name, Rarity = rarity.Name, Icon = "nil" }
	table.insert(ids, id)
end
local gui, binding
local report = { rarities = 0, binds = 0, rows = 0 }
local function cleanup()
	if binding then
		binding.Destroy()
		binding = nil
	end
	if gui then
		gui:Destroy()
		gui = nil
	end
end
local function gradientCount(instance)
	local count = 0
	for _, child in ipairs(instance:GetChildren()) do
		if child:IsA("UIGradient") then
			count += 1
		end
	end
	return count
end
local ok, err = xpcall(function()
	assert(presentation.GetColor("Secret"):ToHex():lower() == "d73aff", "Secret must use its purple core")
	assert(presentation.GetTemplate("Mythic") == presentation.GetTemplate("Mythical"), "Alias diverged")
	for _, rarity in ipairs(config.List) do
		local template = assert(presentation.GetTemplate(rarity.Name))
		assert(template.Rotation == (if rarity.Name == "Secret" or rarity.Name == "Exclusive" then 20 else 90), "Wrong template rotation")
		for _, point in ipairs(template.Transparency.Keypoints) do
			assert(point.Value == 0, "Unexpected template transparency")
		end
		report.rarities += 1
	end
	gui = source:Clone()
	local list = gui.Frame.Content.BaitsFrame
	local authoredPrice = list.Template.Button.Price:FindFirstChildOfClass("UIGradient")
	local none = list.None.Button
	local noneColor = none.BackgroundColor3
	local noneGradient = none:FindFirstChildOfClass("UIGradient")
	local initialChildren = #list:GetChildren()
	for _ = 1, 3 do
		binding = selectBait.Bind(gui, { BaitsSelect = ids }, baits, function() end, function() end, quotes)
		binding.Show()
		for _, id in ipairs(ids) do
			local button = list[id].Button
			local template = assert(presentation.GetTemplate(baits[id].Rarity))
			local gradient = assert(button:FindFirstChildOfClass("UIGradient"))
			assert(gradientCount(button) == 1 and gradient.Enabled, "Duplicate or disabled gradient")
			assert(gradient ~= template and gradient.Color == template.Color and gradient.Rotation == template.Rotation, "Clone differs from template")
			assert(button.BackgroundColor3 == Color3.new(1, 1, 1), "Base color tinted the gradient")
			assert(button:FindFirstChild("Name").TextColor3 == Color3.new(1, 1, 1), "Name inherited green")
			local priceGradient = button.Price:FindFirstChildOfClass("UIGradient")
			assert((priceGradient ~= nil) == (authoredPrice ~= nil), "Price gradient missing")
			if authoredPrice then
				assert(priceGradient.Color == authoredPrice.Color and priceGradient.Rotation == authoredPrice.Rotation, "Price gradient changed")
			end
			report.rows += 1
		end
		assert(none.BackgroundColor3 == noneColor and none:FindFirstChildOfClass("UIGradient") == noneGradient, "None styling changed")
		assert(none.Interactable and not list.Bait_114.Button.Interactable, "Free or unavailable state changed")
		assert(list.Bait_115.Button.Interactable, "Owned state changed")
		assert(list.Bait_114.Button.Price.Text == "$123", "Cash price changed")
		assert(list.Bait_115.Button.Price.Text == "OWNED", "Owned price changed")
		binding.SetBusy(true)
		assert(not list.Bait_114.Button.Interactable and not list.Bait_115.Button.Interactable, "Busy buttons remain active")
		binding.SetBusy(false)
		assert(
			none.Interactable and list.Bait_115.Button.Interactable and not list.Bait_114.Button.Interactable,
			"Resetting busy must restore only available buttons"
		)
		binding.Destroy()
		binding = nil
		assert(#list:GetChildren() == initialChildren, "Destroy leaked rows")
		report.binds += 1
	end
end, debug.traceback)
cleanup()
assert(ok, err)
return report
