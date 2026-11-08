--# selene: allow(global_usage)
-- Atomic batch admission after published-asset and Client gameplay validation.
assert(game.PlaceId == 84106335829275 and game.CreatorId == 598797612, "Wrong development place")
local h = game:GetService("HttpService")
local manifest = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/source-manifest.json"))
local gameplay = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/gameplay-validation.json"))
local regression = h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/regression-validation.json"))
local stage = assert(workspace:FindFirstChild("_FishRace_Staging"))
local processed = workspace.Fish_Processed
local templates = game.ReplicatedStorage.Models.Fish
local expected = #manifest.fish
local finalCount = manifest.existingProcessed + expected
assert(_G.RaceValidationJob.done and _G.RaceValidationJob.count == expected, "Asset audit incomplete")
assert(next(_G.RaceValidationJob.errors) == nil, "Unresolved asset failure")
assert(gameplay.done and #gameplay.results == finalCount and #gameplay.errors == 0, "Gameplay audit incomplete")
for _, result in gameplay.results do
	assert(result.passed and result.framingPassed, "Gameplay/framing failure " .. result.name)
end
assert(
	regression.random.passed and regression.random.templates == finalCount and regression.drip.passed,
	"Regression audit incomplete"
)
assert(#stage:GetChildren() == expected, "Staging batch incomplete")
assert(#processed:GetChildren() == manifest.existingProcessed, "Processed directory changed during production")
assert(#templates:GetChildren() == manifest.existingTemplates, "Template directory changed during production")
assert(require(game.ReplicatedStorage.Modules.FishingConfig).Bite.FishName == nil, "Random pool is not enabled")
for _, spec in manifest.fish do
	local fish = assert(stage:FindFirstChild(spec.name), "Missing " .. spec.name)
	assert(
		not processed:FindFirstChild(spec.name) and not templates:FindFirstChild(spec.name),
		"Name collision " .. spec.name
	)
	assert(
		fish.PrimaryPart and fish.Animations and #fish.Animations:GetChildren() == 5,
		"Incomplete fish " .. spec.name
	)
	assert(_G.RaceValidationJob.results[spec.name].passed, "Failed fish " .. spec.name)
end
local backup = Instance.new("Folder")
backup.Name = "BeforeRaceMerge_" .. os.date("!%Y%m%d_%H%M%S")
backup.Parent = game.ServerStorage.FishUpgradeBackups
local beforeProcessed, beforeTemplates = processed:Clone(), templates:Clone()
beforeProcessed.Name, beforeTemplates.Name = "ProcessedBefore", "TemplatesBefore"
beforeProcessed.Parent, beforeTemplates.Parent = backup, backup
for _, spec in manifest.fish do
	local fish = stage[spec.name]
	fish:SetAttribute("ProcessingStatus", "Complete")
	fish.Parent = processed
	local template = fish:Clone()
	template.Parent = templates
end
assert(#processed:GetChildren() == finalCount and #templates:GetChildren() == finalCount, "Merge count mismatch")
local result = {
	complete = true,
	newFish = expected,
	processed = finalCount,
	templates = finalCount,
	backup = backup:GetFullName(),
}
h:PostAsync("http://127.0.0.1:18775/installation.json", h:JSONEncode(result), Enum.HttpContentType.ApplicationJson)
return result
