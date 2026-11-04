local ServerScriptService = game:GetService('ServerScriptService');
local MarketplaceService = game:GetService('MarketplaceService');
local ReplicatedStorage = game:GetService('ReplicatedStorage');

local Monetization = {};

Monetization.DevProducts = {
	LuckPotion = {Id = 3224021249},
	LuckPotion10 = {Id = 3224021445},
	SuperLuckPotion = {Id = 3224021691},
	SuperLuckPotion10 = {Id = 3224021880},
	MoneyPotion = {Id = 3224022013},
	MoneyPotion10 = {Id = 3224022152},
	SuperPotionsBundle = {Id = 3242207572},

	MoneySmallPack = {Id = 3224026025},
	MoneyMediumPack = {Id = 3224026132},
	MoneyBigPack = {Id = 3224026216},
	MoneySuperPack = {Id = 3224026304},
	MoneyUltraPack = {Id = 3224026384},

	GemsSmallPack = {Id = 3242137391},
	GemsMediumPack = {Id = 3242137747},
	GemsBigPack = {Id = 3242138137},
	GemsSuperPack = {Id = 3242138332},
	GemsUltraPack = {Id = 3242138558},

	Spin1 = {Id = 3242138558},
	Spin10 = {Id = 3242138558},
	Spin100 = {Id = 3242138558},

	UnlockAllOnlineRewards = {Id = 3242785912},
	
	BankUpgrade = {Id = 3242914298},

	RBEgg1 = {Id = 3255661412},

	StoreDailyPack1 = {Id = 3249540586},
	StoreDailyPack2 = {Id = 3249540934},
	StoreDailyPack3 = {Id = 3249541123},
} 

Monetization.Gamepasses = {
	VIP = {Id = 1078154072},
	Teleport = {Id = 1078582826},
	Luck = {Id = 1078151967},
	SuperLuck = {Id = 1078132146},
	UltraLuck = {Id = 1078305264},
	Storage50 = {Id = 1078806277},
	Storage100 = {Id = 1078494888},
	Equip1 = {Id = 1078154074},
	Equip1Too = {Id = 1078700530},
	AutoChest = {Id = 1078124126},
	TripleOpen = {Id = 1078678584},
	MagicChest = {Id = 1078774333},
}

Monetization.GiftDevProducts = {
	VIP = {Id = 3224017691},
	Teleport = {Id = 3224017874},
	Luck = {Id = 3224017970},
	SuperLuck = {Id = 3224018062},
	UltraLuck = {Id = 3224018132},
	Storage50 = {Id = 3224018224},
	Storage100 = {Id = 3224018436},
	Equip1 = {Id = 3224018497},
	Equip1Too = {Id = 3224018571},
	AutoChest = {Id = 3224018657},
	TripleOpen = {Id = 3224018737},
	MagicChest = {Id = 3224018798},
	
	LuckPotion = {Id = 3224022299},
	LuckPotion10 = {Id = 3224022406},
	SuperLuckPotion = {Id = 3224022475},
	SuperLuckPotion10 = {Id = 3224022543},
	MoneyPotion = {Id = 3224022596},
	MoneyPotion10 = {Id = 3224022646},
	SuperPotionsBundle = {Id = 3242207774},

	MoneySmallPack = {Id = 3224026991},
	MoneyMediumPack = {Id = 3224027064},
	MoneyBigPack = {Id = 3224027141},
	MoneySuperPack = {Id = 3224027236},
	MoneyUltraPack = {Id = 3224027319},

	GemsSmallPack = {Id = 3242137589},
	GemsMediumPack = {Id = 3242137950},
	GemsBigPack = {Id = 3242138228},
	GemsSuperPack = {Id = 3242138440},
	GemsUltraPack = {Id = 3242138661},
}

Monetization.DoneLoading = false;

task.spawn(function()
	for i, gamepass: {[string]: {Id: number, Name: string, Icon: string, Cost: number}} in Monetization.Gamepasses do
		Monetization.Gamepasses[i] = {
			Id = gamepass.Id,   ----ID
			DisplayName = "loading",  ----名字
			Icon = "",   ----图标
			Cost = 9999,   ---价格
			Desc = "loading"   ----描述
		}
	end

	for i, product: {[string]: {Id: number, Name: string, Icon: string, Cost: number}} in Monetization.DevProducts do
		Monetization.DevProducts[i] = {
			Id = product.Id,
			DisplayName = "loading",
			Icon = "",
			Cost = 9999,
			Desc = "loading"   ----描述
		}
	end

	for i, gift: {[string]: {Id: number, Name: string, Icon: string, Cost: number}} in Monetization.GiftDevProducts do
		Monetization.GiftDevProducts[i] = {
			Id = gift.Id,
			DisplayName = "loading",
			Icon = "",
			Cost = 9999,
		}
	end

	for i, gamepass: {[string]: {Id: number, Name: string, Icon: string, Cost: number}} in Monetization.Gamepasses do
		pcall(function()
			local data = MarketplaceService:GetProductInfo(gamepass.Id, Enum.InfoType.GamePass);
			if not data then return end;
			Monetization.Gamepasses[i] = {
				Id = gamepass.Id,
				DisplayName = data.Name,
				Icon = "rbxassetid://"..data.IconImageAssetId,
				Cost = data.PriceInRobux,
				Desc = data.Description
			}
		end)
	end
	for i, product: {[string]: {Id: number, Name: string, Icon: string, Cost: number}} in Monetization.DevProducts do
		pcall(function()
			local data = MarketplaceService:GetProductInfo(product.Id, Enum.InfoType.Product);
			if not data then return end;
			Monetization.DevProducts[i] = {
				Id = product.Id,
				DisplayName = data.Name,
				Icon = "rbxassetid://"..data.IconImageAssetId,
				Cost = data.PriceInRobux,
				Desc = data.Description
			}
		end)
	end
	for i, gift: {[string]: {Id: number, Name: string, Icon: string, Cost: number}} in Monetization.GiftDevProducts do
		pcall(function()
			local data = MarketplaceService:GetProductInfo(gift.Id, Enum.InfoType.Product);
			if not data then return end;
			Monetization.GiftDevProducts[i] = {
				Id = gift.Id,
				DisplayName = data.Name,
				Icon = "rbxassetid://"..data.IconImageAssetId,
				Cost = data.PriceInRobux,
			}
		end)
	end
	Monetization.DoneLoading = true;
end)

local GamepassCache: {[Player]: {[number]: boolean}} = {};

return Monetization;