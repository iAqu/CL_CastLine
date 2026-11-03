-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
require(ReplicatedStorage.Shared.UserPriority)
local AbilitySpinProducts = require(ReplicatedStorage.Shared.Products.AbilitySpinProducts)
local PetEggProducts = require(ReplicatedStorage.Shared.Products.PetEggProducts)
local v1 = false
local StateChanged = script:FindFirstChild("StateChanged")
if StateChanged == nil then
	StateChanged = Instance.new("BindableEvent")
	StateChanged.Name = "StateChanged"
	StateChanged.Parent = script
end
local t = {
	[3581374744] = {
		product = "High Tech Speedcraft",
		currency = "gamePass",
		gamePassId = 1811251052
	},
	[3546397233] = {
		product = "Voidcraft",
		currency = "gamePass",
		gamePassId = 1730986932
	},
	[3424369858] = {
		product = "Sharki",
		currency = "gamePass",
		gamePassId = 1520310771
	},
	[3480150103] = {
		product = "Frozen Jetski",
		currency = "gamePass",
		gamePassId = 1634045259
	},
	[3520469069] = {
		product = "Ethereal Jetski",
		currency = "gamePass",
		gamePassId = 1685119887
	},
	[3410201198] = {
		product = "Futuristic Pack",
		currency = "gamePass",
		gamePassId = 1181618549
	},
	[3410161546] = {
		product = "Blossom Pack",
		currency = "gamePass",
		gamePassId = 1371189261
	},
	[3410202705] = {
		product = "More Mutations",
		currency = "gamePass",
		gamePassId = 1250805291
	},
	[3404504895] = {
		product = "Advanced Luck",
		currency = "gamePass",
		gamePassId = 1463535044
	},
	[2650338526] = {
		product = "Extra Luck",
		currency = "gamePass",
		gamePassId = 957182887
	},
	[3410186417] = {
		product = "Small Luck",
		currency = "gamePass",
		gamePassId = 1011727126
	},
	[2650338522] = {
		product = "Double XP",
		currency = "gamePass",
		gamePassId = 950921012
	},
	[2650338523] = {
		product = "Hyper Pack",
		currency = "gamePass",
		gamePassId = 955512908
	},
	[3382457799] = {
		product = "Mini Hoverboat",
		currency = "gamePass",
		gamePassId = 1420081646
	},
	[3397117194] = {
		product = "Burger Boat",
		currency = "gamePass",
		gamePassId = 1451064827
	},
	[2650338525] = {
		product = "Sell Anywhere",
		currency = "gamePass",
		gamePassId = 955704767
	},
	[2650338524] = {
		product = "VIP",
		currency = "gamePass",
		gamePassId = 956088258
	},
	[3410599356] = {
		product = "1,000 Coins",
		currency = "product",
		productId = 2672015131
	},
	[3410599623] = {
		product = "6,500 Coins",
		currency = "product",
		productId = 2672015276
	},
	[3410599902] = {
		product = "15,000 Coins",
		currency = "product",
		productId = 2672015581
	},
	[3410600182] = {
		product = "45,000 Coins",
		currency = "product",
		productId = 2672015764
	},
	[3410600415] = {
		product = "100,000 Coins",
		currency = "product",
		productId = 2672016438
	},
	[3410600684] = {
		product = "500,000 Coins",
		currency = "product",
		productId = 3354034695
	},
	[3410622077] = {
		product = "1 Wheel Spin",
		currency = "product",
		productId = 3378204619
	},
	[3410622355] = {
		product = "5 Wheel Spins",
		currency = "product",
		productId = 3378204784
	},
	[3410622630] = {
		product = "10 Wheel Spins",
		currency = "product",
		productId = 3378205021
	},
	[3410620881] = {
		product = "1 Luxury Crate",
		currency = "product",
		productId = 3395961390
	},
	[3410620557] = {
		product = "5 Luxury Crates",
		currency = "product",
		productId = 3395961602
	},
	[3410618102] = {
		product = "1 Enchanted Crate",
		currency = "product",
		productId = 3373665925
	},
	[3410618597] = {
		product = "5 Enchanted Crates",
		currency = "product",
		productId = 3373665582
	},
	[3410616845] = {
		product = "1 Ocean Crate",
		currency = "product",
		productId = 3283181010
	},
	[3410616209] = {
		product = "5 Ocean Crates",
		currency = "product",
		productId = 3283181168
	},
	[3417202296] = {
		product = "1 Mystery Crate",
		currency = "product",
		productId = 3417201642
	},
	[3417202481] = {
		product = "5 Mystery Crates",
		currency = "product",
		productId = 3417202032
	},
	[3473454305] = {
		product = "1 Elderwood Crate",
		currency = "product",
		productId = 3473454003
	},
	[3473454434] = {
		product = "5 Elderwood Crates",
		currency = "product",
		productId = 3473454185
	},
	[3508725788] = {
		product = "1 Pirate Crate",
		currency = "product",
		productId = 3508725528
	},
	[3508725324] = {
		product = "5 Pirate Crates",
		currency = "product",
		productId = 3508725097
	},
	[3551819556] = {
		product = "1 Azure Crate",
		currency = "product",
		productId = 3551819349
	},
	[3551819620] = {
		product = "5 Azure Crates",
		currency = "product",
		productId = 3551819446
	},
	[3541444433] = {
		product = "1 Emote Crate",
		currency = "product",
		productId = 3541425261
	},
	[3541444349] = {
		product = "5 Emote Crates",
		currency = "product",
		productId = 3541444224
	},
	[3535923823] = {
		product = "Easter Pack",
		currency = "limited",
		productId = 3535923766
	},
	[3597017801] = {
		product = "Blossom Guitar",
		currency = "limited",
		productId = 3597017700
	},
	[3591974586] = {
		product = "Overdrive",
		currency = "limited",
		productId = 3591974517
	},
	[3584068919] = {
		product = "Void Guitar",
		currency = "limited",
		productId = 3584068840
	},
	[3577909201] = {
		product = "Golden Clockwork",
		currency = "limited",
		productId = 3577909091
	},
	[3579087325] = {
		product = "Empyrean Staff",
		currency = "limited",
		productId = 3579087271
	},
	[3568734108] = {
		product = "Easter Parasol",
		currency = "product",
		productId = 3568734041
	},
	[3568734579] = {
		product = "Bunny Summoner",
		currency = "product",
		productId = 3568734512
	},
	[3581540009] = {
		product = "Body Swap",
		currency = "limited",
		productId = 3581539940
	},
	[2678515326] = {
		product = "x2 Luck",
		currency = "product",
		productId = 2678515326,
		_ignoreUnitTest = true
	},
	[2678515467] = {
		product = "x4 Luck",
		currency = "product",
		productId = 2678515467,
		_ignoreUnitTest = true
	},
	[2678517976] = {
		product = "x8 Luck",
		currency = "product",
		productId = 2678517976,
		_ignoreUnitTest = true
	},
	[3581392853] = {
		product = "6h - x8 Luck",
		currency = "product",
		productId = 3581391081,
		_ignoreUnitTest = true
	},
	[3581393835] = {
		product = "12h - x8 Luck",
		currency = "product",
		productId = 3581393658,
		_ignoreUnitTest = true
	},
	[3592930154] = {
		product = "Galaxy Booth",
		currency = "product",
		productId = 3592930102,
		_ignoreUnitTest = true
	}
}
for k, v in pairs(AbilitySpinProducts) do
	t[k] = TableUtil.Copy(v, true)
end
for k, v in pairs(PetEggProducts) do
	t[k] = TableUtil.Copy(v, true)
end
for k, v in pairs({
	[3562441727] = {
		product = "50 Tokens",
		currency = "product",
		productId = 3562441655
	},
	[3576828451] = {
		product = "100 Tokens",
		currency = "product",
		productId = 3576828379
	},
	[3563709227] = {
		product = "250 Tokens",
		currency = "product",
		productId = 3563709131
	},
	[3563709427] = {
		product = "1,000 Tokens",
		currency = "product",
		productId = 3563709333
	},
	[3563710700] = {
		product = "2,500 Tokens",
		currency = "product",
		productId = 3563709580
	},
	[3563711174] = {
		product = "5,000 Tokens",
		currency = "product",
		productId = 3563711098
	},
	[3576828649] = {
		product = "10,000 Tokens",
		currency = "product",
		productId = 3576828579
	}
}) do
	t[k] = TableUtil.Copy(v, true)
end
if not RunService:IsClient() then
	return t
end
task.spawn(function() --[[ Line: 648 | Upvalues: Replion (copy), v1 (ref), StateChanged (ref), Observers (copy) ]]
	Replion.Client:AwaitReplion("RemoteConfigs", function(p1) --[[ Line: 649 | Upvalues: v1 (ref), StateChanged (ref) ]]
		local function updateState() --[[ updateState | Line: 650 | Upvalues: p1 (copy), v1 (ref), StateChanged (ref) ]]
			local v12 = p1:Get("GiftTokens") == true
			if v12 == v1 then
				return
			end
			v1 = v12
			StateChanged:Fire()
		end
		p1:OnChange("GiftTokens", function() --[[ Line: 658 | Upvalues: p1 (copy), v1 (ref), StateChanged (ref) ]]
			local v12 = p1:Get("GiftTokens") == true
			if v12 == v1 then
				return
			end
			v1 = v12
			StateChanged:Fire()
		end)
		local v12 = p1:Get("GiftTokens") == true
		if v12 == v1 then
			return
		end
		v1 = v12
		StateChanged:Fire()
	end)
	Observers.observeTag("TokenGiftingButton", function(p1) --[[ Line: 665 | Upvalues: v1 (ref), StateChanged (ref) ]]
		p1.Visible = v1
		local v12 = StateChanged.Event:Connect(function() --[[ Line: 668 | Upvalues: p1 (copy), v1 (ref) ]]
			p1.Visible = v1
		end)
		return function() --[[ Line: 672 | Upvalues: v12 (copy) ]]
			v12:Disconnect()
		end
	end)
end)
return t