-- Edit-only install after all asset, animation, visual and gameplay checks pass.
-- Shared Command Bar state holds the authoring validation jobs.
-- selene: allow(global_usage)
local jobs = _G
assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
local staged = workspace.Fish_Processed
local templates = game.ReplicatedStorage.Models.Fish
local manifest = game.HttpService:JSONDecode(game.HttpService:GetAsync("http://127.0.0.1:18773/source-manifest.json"))
local expected = #manifest.fish
local gameplay =
	game.HttpService:JSONDecode(game.HttpService:GetAsync("http://127.0.0.1:18773/gameplay-validation.json"))
assert(
	gameplay.done and #gameplay.results == expected and #gameplay.errors == 0 and gameplay.legacyMouthFallback.passed,
	"Gameplay validation must pass for the complete source batch"
)
for _, result in gameplay.results do
	assert(result.passed and result.framingPassed, result.name)
end
assert(
	jobs.FishSkinValidationJob.done
		and #jobs.FishSkinValidationJob.results == expected
		and #jobs.FishSkinValidationJob.errors == 0,
	"Published skin validation must pass for the complete source batch"
)
assert(
	jobs.FishValidationJob.done and #jobs.FishValidationJob.results == expected and #jobs.FishValidationJob.errors == 0,
	"Animation validation must pass for the complete source batch"
)
assert(
	#staged:GetChildren() >= expected and #templates:GetChildren() >= expected,
	"Incomplete staged fish or templates"
)
local backupName = "BeforeTemplateInstall_" .. os.date("!%Y%m%d_%H%M%S")
local backup = templates:Clone()
backup.Name = backupName
backup.Parent = game.ServerStorage.FishUpgradeBackups
local replacements = {}
for _, spec in manifest.fish do
	local fish = assert(staged:FindFirstChild(spec.name))
	local old = assert(templates:FindFirstChild(fish.Name))
	assert(
		#fish.Animations:GetChildren() == 5 and fish.PrimaryPart.MouthAttachment,
		"Fish animations or mouth attachment are missing: " .. fish.Name
	)
	for _, name in require(game.ReplicatedStorage.Modules.FishingConfig).Bite.Drip.Points do
		local point = fish.PrimaryPart:FindFirstChild("FishDrip_" .. name, true)
		assert(
			point and point:IsA("Attachment") and point.Parent:IsA("Bone"),
			"Missing drip point: " .. fish.Name .. "/" .. name
		)
	end
	for _, bone in fish:GetDescendants() do
		if bone:IsA("Bone") then
			bone.Transform = CFrame.identity
		end
	end
	fish:SetAttribute("ProcessingStatus", "Validated")
	fish:SetAttribute("ProcessingVersion", "20261104")
	local fresh = fish:Clone()
	fresh:PivotTo(old:GetPivot())
	table.insert(replacements, { old = old, new = fresh })
end
for _, pair in replacements do
	pair.old.Parent = nil
	pair.new.Parent = templates
end
for _, pair in replacements do
	pair.old:Destroy()
end
local exportSource = workspace:FindFirstChild("_FishExportSource")
if exportSource then
	exportSource:Destroy()
end
local result = {
	installed = expected,
	backup = backup:GetFullName(),
	originalBackup = "ServerStorage.FishUpgradeBackups.BeforeProcessed_20261104_062102",
	sourceCount = #workspace.Fish:GetChildren(),
	processedCount = #staged:GetChildren(),
	templateCount = #templates:GetChildren(),
	defaultFish = require(game.ReplicatedStorage.Modules.FishingConfig).Bite.FishName or "random",
}
jobs.FishInstallResult = result
return result
