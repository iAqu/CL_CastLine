-- Use a different developer product for each rod; for example ProductIds.Rod_101 = 123456.
-- Empty or zero IDs disable purchase prompts. Previously bought credits remain usable.
local Config = {
	ProductIds = {} :: { [string]: number },
	CashMultipliers = { 0.5, 2, 10 },
	MutationWeights = {
		{ Golden = 70, Diamond = 25, Rainbow = 5 },
		{ Golden = 0, Diamond = 80, Rainbow = 20 },
		{ Golden = 0, Diamond = 20, Rainbow = 80 },
		{ Golden = 0, Diamond = 0, Rainbow = 100 },
	},
}

function Config.GetProductId(rodId: string): number?
	local id = Config.ProductIds[rodId]
	return if type(id) == "number" and id > 0 and id % 1 == 0 and Config.GetProductRod(id) == rodId then id else nil
end

function Config.GetProductRod(productId: number): string?
	local found
	for rodId, id in pairs(Config.ProductIds) do
		if id > 0 and id == productId then
			if found then
				return nil
			end
			found = rodId
		end
	end
	return found
end

return Config
