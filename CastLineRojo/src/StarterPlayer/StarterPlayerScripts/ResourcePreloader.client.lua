-- ResourceLoader Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")

local sounds = {}
local animations = {}

local preloadCallback = function(_assetId, _assetFetchStatus)
end

local Sound = ReplicatedStorage:WaitForChild("Sound")
local Animation = ReplicatedStorage:WaitForChild("Animation")

for _, sound in pairs(Sound:GetDescendants()) do
	if sound:IsA("Sound") then
		table.insert(sounds, sound)
	end
end

for _, animation in pairs(Animation:GetDescendants()) do
	if animation:IsA("Animation") then
		table.insert(animations, animation)
	end
end

task.spawn(function()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	ContentProvider:PreloadAsync(animations, preloadCallback)
	ContentProvider:PreloadAsync(sounds, preloadCallback)
end)
