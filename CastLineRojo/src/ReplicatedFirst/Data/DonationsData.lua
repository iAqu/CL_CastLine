export type DonationConfig = {
	DonationID: string,
	Index: number,
	NeedCount: number,
	EarnHeart: number,
}

local data: {[string]: DonationConfig} = {
	Donation_1 = {
		DonationID = "Donation_1",
		Index = 1,
		NeedCount = 5,
		EarnHeart = 10,
	},
	Donation_2 = {
		DonationID = "Donation_2",
		Index = 2,
		NeedCount = 10,
		EarnHeart = 20,
	},
	Donation_3 = {
		DonationID = "Donation_3",
		Index = 3,
		NeedCount = 20,
		EarnHeart = 30,
	},
	Donation_4 = {
		DonationID = "Donation_4",
		Index = 4,
		NeedCount = 50,
		EarnHeart = 40,
	},
	Donation_5 = {
		DonationID = "Donation_5",
		Index = 5,
		NeedCount = 100,
		EarnHeart = 50,
	},
	Donation_6 = {
		DonationID = "Donation_6",
		Index = 6,
		NeedCount = 200,
		EarnHeart = 60,
	},
	Donation_7 = {
		DonationID = "Donation_7",
		Index = 7,
		NeedCount = 500,
		EarnHeart = 70,
	},
	Donation_8 = {
		DonationID = "Donation_8",
		Index = 8,
		NeedCount = 1000,
		EarnHeart = 80,
	},
}

return data