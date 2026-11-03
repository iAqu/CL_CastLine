-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/wyButjTMhM)
-- Decompiled on 2025-05-19 18:19:16
-- Luau version 6, Types version 3
-- Time taken: 0.003496 seconds

local UtilModules = script:WaitForChild("UtilModules")
local RunService = game:GetService("RunService")
local var15
if var15 then
	var15 = game:GetService("ServerScriptService")
end
local var16
if not RunService:IsRunning() then
	error("Loading nevermore modules not supported in test mode")
elseif RunService:IsServer() then
	var16 = require(var15.NodeModules:FindFirstChild("LoaderUtils", true).Parent).bootstrapGame(var15.NodeModules)
else
	var16 = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
end
if var15 and var15:FindFirstChild("QuentySoftShutdown") then
	error("Remove ServerScriptService.QuentySoftShutdown, this is installed via node_modules now.")
end
for i, v in pairs({
	Packages = var16;
	ServiceBag = require(var16.ServiceBag).new();
	CurrentCamera = workspace.CurrentCamera;
	Icons = require(UtilModules.Assets.Icons);
	PlayerSettings = require(UtilModules.Assets.PlayerSettings);
	InputIcons = require(UtilModules.Assets.InputIcons);
	Enchantments = require(UtilModules.Assets.Enchantments);
	KickEffectUtils = require(UtilModules.Utilities.KickEffectUtils);
	MarketplaceUtils = require(UtilModules.Utilities.MarketplaceUtils);
	String = require(UtilModules.Utilities.String);
	PeriodLeaderboardStore = require(UtilModules.Utilities.PeriodLeaderboardStore);
	HumanoidWalkTo = require(UtilModules.Utilities.HumanoidWalkTo);
	PlayerThumbnailUtils = require(UtilModules.Utilities.PlayerThumbnailUtils);
	UserServiceUtils = require(UtilModules.Utilities.UserServiceUtils);
	throttle = require(UtilModules.Utilities.throttle);
	ThrottledFunction = require(UtilModules.Utilities.ThrottledFunction);
	CharacterUtils = require(UtilModules.Utilities.CharacterUtils);
	HumanoidUtils = require(UtilModules.Utilities.HumanoidUtils);
	CurrencyIconUtils = require(UtilModules.Utilities.CurrencyIconUtils);
	Streamer = require(UtilModules.Utilities.Streamer);
	CollisionSettings = require(UtilModules.Utilities.CollisionSettings);
	Settings = require(UtilModules.Settings);
	Players = game:GetService("Players");
	ReplicatedStorage = game:GetService("ReplicatedStorage");
	StarterGui = game:GetService("StarterGui");
	Lighting = game:GetService("Lighting");
	BadgeService = game:GetService("BadgeService");
	Debris = game:GetService("Debris");
	UserInputService = game:GetService("UserInputService");
	RunService = game:GetService("RunService");
	CollectionService = game:GetService("CollectionService");
	TextService = game:GetService("TextService");
	MarketplaceService = game:GetService("MarketplaceService");
	SoundService = game:GetService("SoundService");
	SocialService = game:GetService("SocialService");
	ProximityPromptService = game:GetService("ProximityPromptService");
	TeleportService = game:GetService("TeleportService");
	ServerScriptService = game:GetService("ServerScriptService");
	ServerStorage = game:GetService("ServerStorage");
	HttpService = game:GetService("HttpService");
	DataStoreService = game:GetService("DataStoreService");
	ItemData = {};
	AnimationsDisabled = Instance.new("BoolValue");
}) do
	require(game:GetService("ReplicatedStorage").ChiefUtils.Util)[i] = v
	local var22
end
for _, v_2 in pairs(UtilModules.Utilities.ItemData:GetChildren()) do
	local tbl = {}
	for _, v_3 in pairs(v_2:GetChildren()) do
		tbl[v_3.Name] = require(v_3)
	end
	if next(tbl) then
		var22.ItemData[v_2.Name] = tbl
	end
end
function var22.IsGuiObjectVisible(arg1, arg2) -- Line 99
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [60] 48. Error Block 21 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [60] 48. Error Block 21 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 2 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [1] 2. Error Block 2 end (CF ANALYSIS FAILED)
end
return var22