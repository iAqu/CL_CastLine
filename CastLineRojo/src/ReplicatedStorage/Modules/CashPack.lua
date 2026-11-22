local CashPack = {}

CashPack.Offers = {
	WinsTier1 = { Floor = 100_000, Seconds = 40 * 60 },
	WinsTier2 = { Floor = 1_000_000, Seconds = 120 * 60 },
	WinsTier3 = { Floor = 10_000_000, Seconds = 360 * 60 },
}

local steps = { 1, 1.2, 1.5, 2, 2.5, 3, 4, 5, 6, 8, 10 }

function CashPack.GetAmount(purchaseId: string, baseRate: number?): number?
	local offer = CashPack.Offers[purchaseId]
	if not offer or type(baseRate) ~= "number" or not (baseRate >= 0 and baseRate < math.huge) then
		return nil
	end

	local raw = baseRate * offer.Seconds
	if raw <= offer.Floor then
		return offer.Floor
	end
	if raw == math.huge then
		return nil
	end
	local magnitude = 10 ^ math.floor(math.log10(raw))
	local normalized = raw / magnitude
	local nearest = steps[#steps]
	for index = 1, #steps - 1 do
		-- The geometric midpoint separates values of equal logarithmic distance.
		if normalized <= math.sqrt(steps[index] * steps[index + 1]) then
			nearest = steps[index]
			break
		end
	end
	local amount = math.round(nearest * magnitude)
	return if amount < math.huge then math.max(offer.Floor, amount) else nil
end

return CashPack
