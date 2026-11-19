export type TrainingLevelConfig = {
	Level: number,
	XpToNextLevel: number,
	MaxCatchWeight: number,
}

local data: {[string]: TrainingLevelConfig} = {
	["1"] = {
		Level = 1,
		XpToNextLevel = 5,
		MaxCatchWeight = 1,
	},
	["2"] = {
		Level = 2,
		XpToNextLevel = 5,
		MaxCatchWeight = 2,
	},
	["3"] = {
		Level = 3,
		XpToNextLevel = 5,
		MaxCatchWeight = 3,
	},
	["4"] = {
		Level = 4,
		XpToNextLevel = 5,
		MaxCatchWeight = 4,
	},
	["5"] = {
		Level = 5,
		XpToNextLevel = 5,
		MaxCatchWeight = 5,
	},
	["6"] = {
		Level = 6,
		XpToNextLevel = 5,
		MaxCatchWeight = 6,
	},
	["7"] = {
		Level = 7,
		XpToNextLevel = 5,
		MaxCatchWeight = 7,
	},
	["8"] = {
		Level = 8,
		XpToNextLevel = 5,
		MaxCatchWeight = 8,
	},
	["9"] = {
		Level = 9,
		XpToNextLevel = 5,
		MaxCatchWeight = 9,
	},
	["10"] = {
		Level = 10,
		XpToNextLevel = 6,
		MaxCatchWeight = 10,
	},
	["11"] = {
		Level = 11,
		XpToNextLevel = 6,
		MaxCatchWeight = 11,
	},
	["12"] = {
		Level = 12,
		XpToNextLevel = 6,
		MaxCatchWeight = 12,
	},
	["13"] = {
		Level = 13,
		XpToNextLevel = 6,
		MaxCatchWeight = 13,
	},
	["14"] = {
		Level = 14,
		XpToNextLevel = 6,
		MaxCatchWeight = 14,
	},
	["15"] = {
		Level = 15,
		XpToNextLevel = 7,
		MaxCatchWeight = 15,
	},
	["16"] = {
		Level = 16,
		XpToNextLevel = 7,
		MaxCatchWeight = 16,
	},
	["17"] = {
		Level = 17,
		XpToNextLevel = 7,
		MaxCatchWeight = 17,
	},
	["18"] = {
		Level = 18,
		XpToNextLevel = 7,
		MaxCatchWeight = 18,
	},
	["19"] = {
		Level = 19,
		XpToNextLevel = 8,
		MaxCatchWeight = 19,
	},
	["20"] = {
		Level = 20,
		XpToNextLevel = 8,
		MaxCatchWeight = 20,
	},
	["21"] = {
		Level = 21,
		XpToNextLevel = 8,
		MaxCatchWeight = 21,
	},
	["22"] = {
		Level = 22,
		XpToNextLevel = 9,
		MaxCatchWeight = 22,
	},
	["23"] = {
		Level = 23,
		XpToNextLevel = 9,
		MaxCatchWeight = 23,
	},
	["24"] = {
		Level = 24,
		XpToNextLevel = 9,
		MaxCatchWeight = 24,
	},
	["25"] = {
		Level = 25,
		XpToNextLevel = 10,
		MaxCatchWeight = 25,
	},
	["26"] = {
		Level = 26,
		XpToNextLevel = 10,
		MaxCatchWeight = 26,
	},
	["27"] = {
		Level = 27,
		XpToNextLevel = 11,
		MaxCatchWeight = 27,
	},
	["28"] = {
		Level = 28,
		XpToNextLevel = 11,
		MaxCatchWeight = 28,
	},
	["29"] = {
		Level = 29,
		XpToNextLevel = 12,
		MaxCatchWeight = 29,
	},
	["30"] = {
		Level = 30,
		XpToNextLevel = 12,
		MaxCatchWeight = 30,
	},
	["31"] = {
		Level = 31,
		XpToNextLevel = 13,
		MaxCatchWeight = 31,
	},
	["32"] = {
		Level = 32,
		XpToNextLevel = 13,
		MaxCatchWeight = 32,
	},
	["33"] = {
		Level = 33,
		XpToNextLevel = 14,
		MaxCatchWeight = 33,
	},
	["34"] = {
		Level = 34,
		XpToNextLevel = 14,
		MaxCatchWeight = 34,
	},
	["35"] = {
		Level = 35,
		XpToNextLevel = 15,
		MaxCatchWeight = 35,
	},
	["36"] = {
		Level = 36,
		XpToNextLevel = 15,
		MaxCatchWeight = 36,
	},
	["37"] = {
		Level = 37,
		XpToNextLevel = 16,
		MaxCatchWeight = 37,
	},
	["38"] = {
		Level = 38,
		XpToNextLevel = 17,
		MaxCatchWeight = 38,
	},
	["39"] = {
		Level = 39,
		XpToNextLevel = 17,
		MaxCatchWeight = 39,
	},
	["40"] = {
		Level = 40,
		XpToNextLevel = 18,
		MaxCatchWeight = 40,
	},
	["41"] = {
		Level = 41,
		XpToNextLevel = 19,
		MaxCatchWeight = 41,
	},
	["42"] = {
		Level = 42,
		XpToNextLevel = 20,
		MaxCatchWeight = 42,
	},
	["43"] = {
		Level = 43,
		XpToNextLevel = 20,
		MaxCatchWeight = 43,
	},
	["44"] = {
		Level = 44,
		XpToNextLevel = 21,
		MaxCatchWeight = 44,
	},
	["45"] = {
		Level = 45,
		XpToNextLevel = 22,
		MaxCatchWeight = 45,
	},
	["46"] = {
		Level = 46,
		XpToNextLevel = 23,
		MaxCatchWeight = 46,
	},
	["47"] = {
		Level = 47,
		XpToNextLevel = 24,
		MaxCatchWeight = 47,
	},
	["48"] = {
		Level = 48,
		XpToNextLevel = 24,
		MaxCatchWeight = 48,
	},
	["49"] = {
		Level = 49,
		XpToNextLevel = 25,
		MaxCatchWeight = 49,
	},
	["50"] = {
		Level = 50,
		XpToNextLevel = 26,
		MaxCatchWeight = 50,
	},
	["51"] = {
		Level = 51,
		XpToNextLevel = 27,
		MaxCatchWeight = 51,
	},
	["52"] = {
		Level = 52,
		XpToNextLevel = 28,
		MaxCatchWeight = 52,
	},
	["53"] = {
		Level = 53,
		XpToNextLevel = 29,
		MaxCatchWeight = 53,
	},
	["54"] = {
		Level = 54,
		XpToNextLevel = 30,
		MaxCatchWeight = 54,
	},
	["55"] = {
		Level = 55,
		XpToNextLevel = 31,
		MaxCatchWeight = 55,
	},
	["56"] = {
		Level = 56,
		XpToNextLevel = 32,
		MaxCatchWeight = 56,
	},
	["57"] = {
		Level = 57,
		XpToNextLevel = 33,
		MaxCatchWeight = 57,
	},
	["58"] = {
		Level = 58,
		XpToNextLevel = 34,
		MaxCatchWeight = 58,
	},
	["59"] = {
		Level = 59,
		XpToNextLevel = 35,
		MaxCatchWeight = 59,
	},
	["60"] = {
		Level = 60,
		XpToNextLevel = 36,
		MaxCatchWeight = 60,
	},
	["61"] = {
		Level = 61,
		XpToNextLevel = 38,
		MaxCatchWeight = 61,
	},
	["62"] = {
		Level = 62,
		XpToNextLevel = 39,
		MaxCatchWeight = 62,
	},
	["63"] = {
		Level = 63,
		XpToNextLevel = 40,
		MaxCatchWeight = 63,
	},
	["64"] = {
		Level = 64,
		XpToNextLevel = 41,
		MaxCatchWeight = 64,
	},
	["65"] = {
		Level = 65,
		XpToNextLevel = 42,
		MaxCatchWeight = 65,
	},
	["66"] = {
		Level = 66,
		XpToNextLevel = 43,
		MaxCatchWeight = 66,
	},
	["67"] = {
		Level = 67,
		XpToNextLevel = 45,
		MaxCatchWeight = 67,
	},
	["68"] = {
		Level = 68,
		XpToNextLevel = 46,
		MaxCatchWeight = 68,
	},
	["69"] = {
		Level = 69,
		XpToNextLevel = 47,
		MaxCatchWeight = 69,
	},
	["70"] = {
		Level = 70,
		XpToNextLevel = 49,
		MaxCatchWeight = 70,
	},
	["71"] = {
		Level = 71,
		XpToNextLevel = 50,
		MaxCatchWeight = 71,
	},
	["72"] = {
		Level = 72,
		XpToNextLevel = 51,
		MaxCatchWeight = 72,
	},
	["73"] = {
		Level = 73,
		XpToNextLevel = 53,
		MaxCatchWeight = 73,
	},
	["74"] = {
		Level = 74,
		XpToNextLevel = 54,
		MaxCatchWeight = 74,
	},
	["75"] = {
		Level = 75,
		XpToNextLevel = 56,
		MaxCatchWeight = 75,
	},
	["76"] = {
		Level = 76,
		XpToNextLevel = 57,
		MaxCatchWeight = 76,
	},
	["77"] = {
		Level = 77,
		XpToNextLevel = 58,
		MaxCatchWeight = 77,
	},
	["78"] = {
		Level = 78,
		XpToNextLevel = 60,
		MaxCatchWeight = 78,
	},
	["79"] = {
		Level = 79,
		XpToNextLevel = 61,
		MaxCatchWeight = 79,
	},
	["80"] = {
		Level = 80,
		XpToNextLevel = 63,
		MaxCatchWeight = 80,
	},
	["81"] = {
		Level = 81,
		XpToNextLevel = 65,
		MaxCatchWeight = 81,
	},
	["82"] = {
		Level = 82,
		XpToNextLevel = 66,
		MaxCatchWeight = 82,
	},
	["83"] = {
		Level = 83,
		XpToNextLevel = 68,
		MaxCatchWeight = 83,
	},
	["84"] = {
		Level = 84,
		XpToNextLevel = 69,
		MaxCatchWeight = 84,
	},
	["85"] = {
		Level = 85,
		XpToNextLevel = 71,
		MaxCatchWeight = 85,
	},
	["86"] = {
		Level = 86,
		XpToNextLevel = 73,
		MaxCatchWeight = 86,
	},
	["87"] = {
		Level = 87,
		XpToNextLevel = 74,
		MaxCatchWeight = 87,
	},
	["88"] = {
		Level = 88,
		XpToNextLevel = 76,
		MaxCatchWeight = 88,
	},
	["89"] = {
		Level = 89,
		XpToNextLevel = 78,
		MaxCatchWeight = 89,
	},
	["90"] = {
		Level = 90,
		XpToNextLevel = 79,
		MaxCatchWeight = 90,
	},
	["91"] = {
		Level = 91,
		XpToNextLevel = 81,
		MaxCatchWeight = 91,
	},
	["92"] = {
		Level = 92,
		XpToNextLevel = 83,
		MaxCatchWeight = 92,
	},
	["93"] = {
		Level = 93,
		XpToNextLevel = 85,
		MaxCatchWeight = 93,
	},
	["94"] = {
		Level = 94,
		XpToNextLevel = 87,
		MaxCatchWeight = 94,
	},
	["95"] = {
		Level = 95,
		XpToNextLevel = 89,
		MaxCatchWeight = 95,
	},
	["96"] = {
		Level = 96,
		XpToNextLevel = 90,
		MaxCatchWeight = 96,
	},
	["97"] = {
		Level = 97,
		XpToNextLevel = 92,
		MaxCatchWeight = 97,
	},
	["98"] = {
		Level = 98,
		XpToNextLevel = 94,
		MaxCatchWeight = 98,
	},
	["99"] = {
		Level = 99,
		XpToNextLevel = 96,
		MaxCatchWeight = 99,
	},
	["100"] = {
		Level = 100,
		XpToNextLevel = 98,
		MaxCatchWeight = 100,
	},
	["101"] = {
		Level = 101,
		XpToNextLevel = 100,
		MaxCatchWeight = 101,
	},
	["102"] = {
		Level = 102,
		XpToNextLevel = 102,
		MaxCatchWeight = 102,
	},
	["103"] = {
		Level = 103,
		XpToNextLevel = 104,
		MaxCatchWeight = 103,
	},
	["104"] = {
		Level = 104,
		XpToNextLevel = 106,
		MaxCatchWeight = 104,
	},
	["105"] = {
		Level = 105,
		XpToNextLevel = 108,
		MaxCatchWeight = 105,
	},
	["106"] = {
		Level = 106,
		XpToNextLevel = 110,
		MaxCatchWeight = 106,
	},
	["107"] = {
		Level = 107,
		XpToNextLevel = 112,
		MaxCatchWeight = 107,
	},
	["108"] = {
		Level = 108,
		XpToNextLevel = 115,
		MaxCatchWeight = 108,
	},
	["109"] = {
		Level = 109,
		XpToNextLevel = 117,
		MaxCatchWeight = 109,
	},
	["110"] = {
		Level = 110,
		XpToNextLevel = 119,
		MaxCatchWeight = 110,
	},
	["111"] = {
		Level = 111,
		XpToNextLevel = 121,
		MaxCatchWeight = 111,
	},
	["112"] = {
		Level = 112,
		XpToNextLevel = 123,
		MaxCatchWeight = 112,
	},
	["113"] = {
		Level = 113,
		XpToNextLevel = 126,
		MaxCatchWeight = 113,
	},
	["114"] = {
		Level = 114,
		XpToNextLevel = 128,
		MaxCatchWeight = 114,
	},
	["115"] = {
		Level = 115,
		XpToNextLevel = 130,
		MaxCatchWeight = 115,
	},
	["116"] = {
		Level = 116,
		XpToNextLevel = 133,
		MaxCatchWeight = 116,
	},
	["117"] = {
		Level = 117,
		XpToNextLevel = 135,
		MaxCatchWeight = 117,
	},
	["118"] = {
		Level = 118,
		XpToNextLevel = 137,
		MaxCatchWeight = 118,
	},
	["119"] = {
		Level = 119,
		XpToNextLevel = 140,
		MaxCatchWeight = 119,
	},
	["120"] = {
		Level = 120,
		XpToNextLevel = 142,
		MaxCatchWeight = 120,
	},
	["121"] = {
		Level = 121,
		XpToNextLevel = 144,
		MaxCatchWeight = 121,
	},
	["122"] = {
		Level = 122,
		XpToNextLevel = 147,
		MaxCatchWeight = 122,
	},
	["123"] = {
		Level = 123,
		XpToNextLevel = 149,
		MaxCatchWeight = 123,
	},
	["124"] = {
		Level = 124,
		XpToNextLevel = 152,
		MaxCatchWeight = 124,
	},
	["125"] = {
		Level = 125,
		XpToNextLevel = 154,
		MaxCatchWeight = 125,
	},
	["126"] = {
		Level = 126,
		XpToNextLevel = 157,
		MaxCatchWeight = 126,
	},
	["127"] = {
		Level = 127,
		XpToNextLevel = 160,
		MaxCatchWeight = 127,
	},
	["128"] = {
		Level = 128,
		XpToNextLevel = 162,
		MaxCatchWeight = 128,
	},
	["129"] = {
		Level = 129,
		XpToNextLevel = 165,
		MaxCatchWeight = 129,
	},
	["130"] = {
		Level = 130,
		XpToNextLevel = 167,
		MaxCatchWeight = 130,
	},
	["131"] = {
		Level = 131,
		XpToNextLevel = 170,
		MaxCatchWeight = 131,
	},
	["132"] = {
		Level = 132,
		XpToNextLevel = 173,
		MaxCatchWeight = 132,
	},
	["133"] = {
		Level = 133,
		XpToNextLevel = 175,
		MaxCatchWeight = 133,
	},
	["134"] = {
		Level = 134,
		XpToNextLevel = 178,
		MaxCatchWeight = 134,
	},
	["135"] = {
		Level = 135,
		XpToNextLevel = 181,
		MaxCatchWeight = 135,
	},
	["136"] = {
		Level = 136,
		XpToNextLevel = 184,
		MaxCatchWeight = 136,
	},
	["137"] = {
		Level = 137,
		XpToNextLevel = 186,
		MaxCatchWeight = 137,
	},
	["138"] = {
		Level = 138,
		XpToNextLevel = 189,
		MaxCatchWeight = 138,
	},
	["139"] = {
		Level = 139,
		XpToNextLevel = 192,
		MaxCatchWeight = 139,
	},
	["140"] = {
		Level = 140,
		XpToNextLevel = 195,
		MaxCatchWeight = 140,
	},
	["141"] = {
		Level = 141,
		XpToNextLevel = 198,
		MaxCatchWeight = 141,
	},
	["142"] = {
		Level = 142,
		XpToNextLevel = 201,
		MaxCatchWeight = 142,
	},
	["143"] = {
		Level = 143,
		XpToNextLevel = 204,
		MaxCatchWeight = 143,
	},
	["144"] = {
		Level = 144,
		XpToNextLevel = 207,
		MaxCatchWeight = 144,
	},
	["145"] = {
		Level = 145,
		XpToNextLevel = 210,
		MaxCatchWeight = 145,
	},
	["146"] = {
		Level = 146,
		XpToNextLevel = 213,
		MaxCatchWeight = 146,
	},
	["147"] = {
		Level = 147,
		XpToNextLevel = 216,
		MaxCatchWeight = 147,
	},
	["148"] = {
		Level = 148,
		XpToNextLevel = 219,
		MaxCatchWeight = 148,
	},
	["149"] = {
		Level = 149,
		XpToNextLevel = 222,
		MaxCatchWeight = 149,
	},
	["150"] = {
		Level = 150,
		XpToNextLevel = 225,
		MaxCatchWeight = 150,
	},
	["151"] = {
		Level = 151,
		XpToNextLevel = 228,
		MaxCatchWeight = 151,
	},
	["152"] = {
		Level = 152,
		XpToNextLevel = 231,
		MaxCatchWeight = 152,
	},
	["153"] = {
		Level = 153,
		XpToNextLevel = 234,
		MaxCatchWeight = 153,
	},
	["154"] = {
		Level = 154,
		XpToNextLevel = 237,
		MaxCatchWeight = 154,
	},
	["155"] = {
		Level = 155,
		XpToNextLevel = 240,
		MaxCatchWeight = 155,
	},
	["156"] = {
		Level = 156,
		XpToNextLevel = 244,
		MaxCatchWeight = 156,
	},
	["157"] = {
		Level = 157,
		XpToNextLevel = 247,
		MaxCatchWeight = 157,
	},
	["158"] = {
		Level = 158,
		XpToNextLevel = 250,
		MaxCatchWeight = 158,
	},
	["159"] = {
		Level = 159,
		XpToNextLevel = 254,
		MaxCatchWeight = 159,
	},
	["160"] = {
		Level = 160,
		XpToNextLevel = 257,
		MaxCatchWeight = 160,
	},
	["161"] = {
		Level = 161,
		XpToNextLevel = 260,
		MaxCatchWeight = 161,
	},
	["162"] = {
		Level = 162,
		XpToNextLevel = 264,
		MaxCatchWeight = 162,
	},
	["163"] = {
		Level = 163,
		XpToNextLevel = 267,
		MaxCatchWeight = 163,
	},
	["164"] = {
		Level = 164,
		XpToNextLevel = 270,
		MaxCatchWeight = 164,
	},
	["165"] = {
		Level = 165,
		XpToNextLevel = 274,
		MaxCatchWeight = 165,
	},
	["166"] = {
		Level = 166,
		XpToNextLevel = 277,
		MaxCatchWeight = 166,
	},
	["167"] = {
		Level = 167,
		XpToNextLevel = 281,
		MaxCatchWeight = 167,
	},
	["168"] = {
		Level = 168,
		XpToNextLevel = 284,
		MaxCatchWeight = 168,
	},
	["169"] = {
		Level = 169,
		XpToNextLevel = 288,
		MaxCatchWeight = 169,
	},
	["170"] = {
		Level = 170,
		XpToNextLevel = 291,
		MaxCatchWeight = 170,
	},
	["171"] = {
		Level = 171,
		XpToNextLevel = 295,
		MaxCatchWeight = 171,
	},
	["172"] = {
		Level = 172,
		XpToNextLevel = 298,
		MaxCatchWeight = 172,
	},
	["173"] = {
		Level = 173,
		XpToNextLevel = 302,
		MaxCatchWeight = 173,
	},
	["174"] = {
		Level = 174,
		XpToNextLevel = 306,
		MaxCatchWeight = 174,
	},
	["175"] = {
		Level = 175,
		XpToNextLevel = 309,
		MaxCatchWeight = 175,
	},
	["176"] = {
		Level = 176,
		XpToNextLevel = 313,
		MaxCatchWeight = 176,
	},
	["177"] = {
		Level = 177,
		XpToNextLevel = 317,
		MaxCatchWeight = 177,
	},
	["178"] = {
		Level = 178,
		XpToNextLevel = 320,
		MaxCatchWeight = 178,
	},
	["179"] = {
		Level = 179,
		XpToNextLevel = 324,
		MaxCatchWeight = 179,
	},
	["180"] = {
		Level = 180,
		XpToNextLevel = 328,
		MaxCatchWeight = 180,
	},
	["181"] = {
		Level = 181,
		XpToNextLevel = 332,
		MaxCatchWeight = 181,
	},
	["182"] = {
		Level = 182,
		XpToNextLevel = 336,
		MaxCatchWeight = 182,
	},
	["183"] = {
		Level = 183,
		XpToNextLevel = 339,
		MaxCatchWeight = 183,
	},
	["184"] = {
		Level = 184,
		XpToNextLevel = 343,
		MaxCatchWeight = 184,
	},
	["185"] = {
		Level = 185,
		XpToNextLevel = 347,
		MaxCatchWeight = 185,
	},
	["186"] = {
		Level = 186,
		XpToNextLevel = 351,
		MaxCatchWeight = 186,
	},
	["187"] = {
		Level = 187,
		XpToNextLevel = 355,
		MaxCatchWeight = 187,
	},
	["188"] = {
		Level = 188,
		XpToNextLevel = 359,
		MaxCatchWeight = 188,
	},
	["189"] = {
		Level = 189,
		XpToNextLevel = 363,
		MaxCatchWeight = 189,
	},
	["190"] = {
		Level = 190,
		XpToNextLevel = 367,
		MaxCatchWeight = 190,
	},
	["191"] = {
		Level = 191,
		XpToNextLevel = 371,
		MaxCatchWeight = 191,
	},
	["192"] = {
		Level = 192,
		XpToNextLevel = 375,
		MaxCatchWeight = 192,
	},
	["193"] = {
		Level = 193,
		XpToNextLevel = 379,
		MaxCatchWeight = 193,
	},
	["194"] = {
		Level = 194,
		XpToNextLevel = 383,
		MaxCatchWeight = 194,
	},
	["195"] = {
		Level = 195,
		XpToNextLevel = 387,
		MaxCatchWeight = 195,
	},
	["196"] = {
		Level = 196,
		XpToNextLevel = 392,
		MaxCatchWeight = 196,
	},
	["197"] = {
		Level = 197,
		XpToNextLevel = 396,
		MaxCatchWeight = 197,
	},
	["198"] = {
		Level = 198,
		XpToNextLevel = 400,
		MaxCatchWeight = 198,
	},
	["199"] = {
		Level = 199,
		XpToNextLevel = 404,
		MaxCatchWeight = 199,
	},
	["200"] = {
		Level = 200,
		XpToNextLevel = 408,
		MaxCatchWeight = 200,
	},
	["201"] = {
		Level = 201,
		XpToNextLevel = 413,
		MaxCatchWeight = 201,
	},
	["202"] = {
		Level = 202,
		XpToNextLevel = 417,
		MaxCatchWeight = 202,
	},
	["203"] = {
		Level = 203,
		XpToNextLevel = 421,
		MaxCatchWeight = 203,
	},
	["204"] = {
		Level = 204,
		XpToNextLevel = 426,
		MaxCatchWeight = 204,
	},
	["205"] = {
		Level = 205,
		XpToNextLevel = 430,
		MaxCatchWeight = 205,
	},
	["206"] = {
		Level = 206,
		XpToNextLevel = 434,
		MaxCatchWeight = 206,
	},
	["207"] = {
		Level = 207,
		XpToNextLevel = 439,
		MaxCatchWeight = 207,
	},
	["208"] = {
		Level = 208,
		XpToNextLevel = 443,
		MaxCatchWeight = 208,
	},
	["209"] = {
		Level = 209,
		XpToNextLevel = 448,
		MaxCatchWeight = 209,
	},
	["210"] = {
		Level = 210,
		XpToNextLevel = 452,
		MaxCatchWeight = 210,
	},
	["211"] = {
		Level = 211,
		XpToNextLevel = 457,
		MaxCatchWeight = 211,
	},
	["212"] = {
		Level = 212,
		XpToNextLevel = 461,
		MaxCatchWeight = 212,
	},
	["213"] = {
		Level = 213,
		XpToNextLevel = 466,
		MaxCatchWeight = 213,
	},
	["214"] = {
		Level = 214,
		XpToNextLevel = 470,
		MaxCatchWeight = 214,
	},
	["215"] = {
		Level = 215,
		XpToNextLevel = 475,
		MaxCatchWeight = 215,
	},
	["216"] = {
		Level = 216,
		XpToNextLevel = 480,
		MaxCatchWeight = 216,
	},
	["217"] = {
		Level = 217,
		XpToNextLevel = 484,
		MaxCatchWeight = 217,
	},
	["218"] = {
		Level = 218,
		XpToNextLevel = 489,
		MaxCatchWeight = 218,
	},
	["219"] = {
		Level = 219,
		XpToNextLevel = 494,
		MaxCatchWeight = 219,
	},
	["220"] = {
		Level = 220,
		XpToNextLevel = 498,
		MaxCatchWeight = 220,
	},
	["221"] = {
		Level = 221,
		XpToNextLevel = 503,
		MaxCatchWeight = 221,
	},
	["222"] = {
		Level = 222,
		XpToNextLevel = 508,
		MaxCatchWeight = 222,
	},
	["223"] = {
		Level = 223,
		XpToNextLevel = 513,
		MaxCatchWeight = 223,
	},
	["224"] = {
		Level = 224,
		XpToNextLevel = 517,
		MaxCatchWeight = 224,
	},
	["225"] = {
		Level = 225,
		XpToNextLevel = 522,
		MaxCatchWeight = 225,
	},
	["226"] = {
		Level = 226,
		XpToNextLevel = 527,
		MaxCatchWeight = 226,
	},
	["227"] = {
		Level = 227,
		XpToNextLevel = 532,
		MaxCatchWeight = 227,
	},
	["228"] = {
		Level = 228,
		XpToNextLevel = 537,
		MaxCatchWeight = 228,
	},
	["229"] = {
		Level = 229,
		XpToNextLevel = 542,
		MaxCatchWeight = 229,
	},
	["230"] = {
		Level = 230,
		XpToNextLevel = 547,
		MaxCatchWeight = 230,
	},
	["231"] = {
		Level = 231,
		XpToNextLevel = 552,
		MaxCatchWeight = 231,
	},
	["232"] = {
		Level = 232,
		XpToNextLevel = 557,
		MaxCatchWeight = 232,
	},
	["233"] = {
		Level = 233,
		XpToNextLevel = 562,
		MaxCatchWeight = 233,
	},
	["234"] = {
		Level = 234,
		XpToNextLevel = 567,
		MaxCatchWeight = 234,
	},
	["235"] = {
		Level = 235,
		XpToNextLevel = 572,
		MaxCatchWeight = 235,
	},
	["236"] = {
		Level = 236,
		XpToNextLevel = 577,
		MaxCatchWeight = 236,
	},
	["237"] = {
		Level = 237,
		XpToNextLevel = 582,
		MaxCatchWeight = 237,
	},
	["238"] = {
		Level = 238,
		XpToNextLevel = 587,
		MaxCatchWeight = 238,
	},
	["239"] = {
		Level = 239,
		XpToNextLevel = 592,
		MaxCatchWeight = 239,
	},
	["240"] = {
		Level = 240,
		XpToNextLevel = 598,
		MaxCatchWeight = 240,
	},
	["241"] = {
		Level = 241,
		XpToNextLevel = 603,
		MaxCatchWeight = 241,
	},
	["242"] = {
		Level = 242,
		XpToNextLevel = 608,
		MaxCatchWeight = 242,
	},
	["243"] = {
		Level = 243,
		XpToNextLevel = 613,
		MaxCatchWeight = 243,
	},
	["244"] = {
		Level = 244,
		XpToNextLevel = 619,
		MaxCatchWeight = 244,
	},
	["245"] = {
		Level = 245,
		XpToNextLevel = 624,
		MaxCatchWeight = 245,
	},
	["246"] = {
		Level = 246,
		XpToNextLevel = 629,
		MaxCatchWeight = 246,
	},
	["247"] = {
		Level = 247,
		XpToNextLevel = 635,
		MaxCatchWeight = 247,
	},
	["248"] = {
		Level = 248,
		XpToNextLevel = 640,
		MaxCatchWeight = 248,
	},
	["249"] = {
		Level = 249,
		XpToNextLevel = 645,
		MaxCatchWeight = 249,
	},
	["250"] = {
		Level = 250,
		XpToNextLevel = 651,
		MaxCatchWeight = 250,
	},
	["251"] = {
		Level = 251,
		XpToNextLevel = 656,
		MaxCatchWeight = 251,
	},
	["252"] = {
		Level = 252,
		XpToNextLevel = 662,
		MaxCatchWeight = 252,
	},
	["253"] = {
		Level = 253,
		XpToNextLevel = 667,
		MaxCatchWeight = 253,
	},
	["254"] = {
		Level = 254,
		XpToNextLevel = 673,
		MaxCatchWeight = 254,
	},
	["255"] = {
		Level = 255,
		XpToNextLevel = 678,
		MaxCatchWeight = 255,
	},
	["256"] = {
		Level = 256,
		XpToNextLevel = 684,
		MaxCatchWeight = 256,
	},
	["257"] = {
		Level = 257,
		XpToNextLevel = 690,
		MaxCatchWeight = 257,
	},
	["258"] = {
		Level = 258,
		XpToNextLevel = 695,
		MaxCatchWeight = 258,
	},
	["259"] = {
		Level = 259,
		XpToNextLevel = 701,
		MaxCatchWeight = 259,
	},
	["260"] = {
		Level = 260,
		XpToNextLevel = 707,
		MaxCatchWeight = 260,
	},
	["261"] = {
		Level = 261,
		XpToNextLevel = 712,
		MaxCatchWeight = 261,
	},
	["262"] = {
		Level = 262,
		XpToNextLevel = 718,
		MaxCatchWeight = 262,
	},
	["263"] = {
		Level = 263,
		XpToNextLevel = 724,
		MaxCatchWeight = 263,
	},
	["264"] = {
		Level = 264,
		XpToNextLevel = 730,
		MaxCatchWeight = 264,
	},
	["265"] = {
		Level = 265,
		XpToNextLevel = 735,
		MaxCatchWeight = 265,
	},
	["266"] = {
		Level = 266,
		XpToNextLevel = 741,
		MaxCatchWeight = 266,
	},
	["267"] = {
		Level = 267,
		XpToNextLevel = 747,
		MaxCatchWeight = 267,
	},
	["268"] = {
		Level = 268,
		XpToNextLevel = 753,
		MaxCatchWeight = 268,
	},
	["269"] = {
		Level = 269,
		XpToNextLevel = 759,
		MaxCatchWeight = 269,
	},
	["270"] = {
		Level = 270,
		XpToNextLevel = 765,
		MaxCatchWeight = 270,
	},
	["271"] = {
		Level = 271,
		XpToNextLevel = 771,
		MaxCatchWeight = 271,
	},
	["272"] = {
		Level = 272,
		XpToNextLevel = 777,
		MaxCatchWeight = 272,
	},
	["273"] = {
		Level = 273,
		XpToNextLevel = 783,
		MaxCatchWeight = 273,
	},
	["274"] = {
		Level = 274,
		XpToNextLevel = 789,
		MaxCatchWeight = 274,
	},
	["275"] = {
		Level = 275,
		XpToNextLevel = 795,
		MaxCatchWeight = 275,
	},
	["276"] = {
		Level = 276,
		XpToNextLevel = 801,
		MaxCatchWeight = 276,
	},
	["277"] = {
		Level = 277,
		XpToNextLevel = 807,
		MaxCatchWeight = 277,
	},
	["278"] = {
		Level = 278,
		XpToNextLevel = 813,
		MaxCatchWeight = 278,
	},
	["279"] = {
		Level = 279,
		XpToNextLevel = 819,
		MaxCatchWeight = 279,
	},
	["280"] = {
		Level = 280,
		XpToNextLevel = 825,
		MaxCatchWeight = 280,
	},
	["281"] = {
		Level = 281,
		XpToNextLevel = 831,
		MaxCatchWeight = 281,
	},
	["282"] = {
		Level = 282,
		XpToNextLevel = 838,
		MaxCatchWeight = 282,
	},
	["283"] = {
		Level = 283,
		XpToNextLevel = 844,
		MaxCatchWeight = 283,
	},
	["284"] = {
		Level = 284,
		XpToNextLevel = 850,
		MaxCatchWeight = 284,
	},
	["285"] = {
		Level = 285,
		XpToNextLevel = 856,
		MaxCatchWeight = 285,
	},
	["286"] = {
		Level = 286,
		XpToNextLevel = 863,
		MaxCatchWeight = 286,
	},
	["287"] = {
		Level = 287,
		XpToNextLevel = 869,
		MaxCatchWeight = 287,
	},
	["288"] = {
		Level = 288,
		XpToNextLevel = 875,
		MaxCatchWeight = 288,
	},
	["289"] = {
		Level = 289,
		XpToNextLevel = 882,
		MaxCatchWeight = 289,
	},
	["290"] = {
		Level = 290,
		XpToNextLevel = 888,
		MaxCatchWeight = 290,
	},
	["291"] = {
		Level = 291,
		XpToNextLevel = 895,
		MaxCatchWeight = 291,
	},
	["292"] = {
		Level = 292,
		XpToNextLevel = 901,
		MaxCatchWeight = 292,
	},
	["293"] = {
		Level = 293,
		XpToNextLevel = 908,
		MaxCatchWeight = 293,
	},
	["294"] = {
		Level = 294,
		XpToNextLevel = 914,
		MaxCatchWeight = 294,
	},
	["295"] = {
		Level = 295,
		XpToNextLevel = 921,
		MaxCatchWeight = 295,
	},
	["296"] = {
		Level = 296,
		XpToNextLevel = 927,
		MaxCatchWeight = 296,
	},
	["297"] = {
		Level = 297,
		XpToNextLevel = 934,
		MaxCatchWeight = 297,
	},
	["298"] = {
		Level = 298,
		XpToNextLevel = 940,
		MaxCatchWeight = 298,
	},
	["299"] = {
		Level = 299,
		XpToNextLevel = 947,
		MaxCatchWeight = 299,
	},
	["300"] = {
		Level = 300,
		XpToNextLevel = 954,
		MaxCatchWeight = 300,
	},
	["301"] = {
		Level = 301,
		XpToNextLevel = 960,
		MaxCatchWeight = 301,
	},
	["302"] = {
		Level = 302,
		XpToNextLevel = 967,
		MaxCatchWeight = 302,
	},
	["303"] = {
		Level = 303,
		XpToNextLevel = 974,
		MaxCatchWeight = 303,
	},
	["304"] = {
		Level = 304,
		XpToNextLevel = 980,
		MaxCatchWeight = 304,
	},
	["305"] = {
		Level = 305,
		XpToNextLevel = 987,
		MaxCatchWeight = 305,
	},
	["306"] = {
		Level = 306,
		XpToNextLevel = 994,
		MaxCatchWeight = 306,
	},
	["307"] = {
		Level = 307,
		XpToNextLevel = 1001,
		MaxCatchWeight = 307,
	},
	["308"] = {
		Level = 308,
		XpToNextLevel = 1008,
		MaxCatchWeight = 308,
	},
	["309"] = {
		Level = 309,
		XpToNextLevel = 1015,
		MaxCatchWeight = 309,
	},
	["310"] = {
		Level = 310,
		XpToNextLevel = 1021,
		MaxCatchWeight = 310,
	},
	["311"] = {
		Level = 311,
		XpToNextLevel = 1028,
		MaxCatchWeight = 311,
	},
	["312"] = {
		Level = 312,
		XpToNextLevel = 1035,
		MaxCatchWeight = 312,
	},
	["313"] = {
		Level = 313,
		XpToNextLevel = 1042,
		MaxCatchWeight = 313,
	},
	["314"] = {
		Level = 314,
		XpToNextLevel = 1049,
		MaxCatchWeight = 314,
	},
	["315"] = {
		Level = 315,
		XpToNextLevel = 1056,
		MaxCatchWeight = 315,
	},
	["316"] = {
		Level = 316,
		XpToNextLevel = 1063,
		MaxCatchWeight = 316,
	},
	["317"] = {
		Level = 317,
		XpToNextLevel = 1070,
		MaxCatchWeight = 317,
	},
	["318"] = {
		Level = 318,
		XpToNextLevel = 1077,
		MaxCatchWeight = 318,
	},
	["319"] = {
		Level = 319,
		XpToNextLevel = 1085,
		MaxCatchWeight = 319,
	},
	["320"] = {
		Level = 320,
		XpToNextLevel = 1092,
		MaxCatchWeight = 320,
	},
	["321"] = {
		Level = 321,
		XpToNextLevel = 1099,
		MaxCatchWeight = 321,
	},
	["322"] = {
		Level = 322,
		XpToNextLevel = 1106,
		MaxCatchWeight = 322,
	},
	["323"] = {
		Level = 323,
		XpToNextLevel = 1113,
		MaxCatchWeight = 323,
	},
	["324"] = {
		Level = 324,
		XpToNextLevel = 1121,
		MaxCatchWeight = 324,
	},
	["325"] = {
		Level = 325,
		XpToNextLevel = 1128,
		MaxCatchWeight = 325,
	},
	["326"] = {
		Level = 326,
		XpToNextLevel = 1135,
		MaxCatchWeight = 326,
	},
	["327"] = {
		Level = 327,
		XpToNextLevel = 1142,
		MaxCatchWeight = 327,
	},
	["328"] = {
		Level = 328,
		XpToNextLevel = 1150,
		MaxCatchWeight = 328,
	},
	["329"] = {
		Level = 329,
		XpToNextLevel = 1157,
		MaxCatchWeight = 329,
	},
	["330"] = {
		Level = 330,
		XpToNextLevel = 1164,
		MaxCatchWeight = 330,
	},
	["331"] = {
		Level = 331,
		XpToNextLevel = 1172,
		MaxCatchWeight = 331,
	},
	["332"] = {
		Level = 332,
		XpToNextLevel = 1179,
		MaxCatchWeight = 332,
	},
	["333"] = {
		Level = 333,
		XpToNextLevel = 1187,
		MaxCatchWeight = 333,
	},
	["334"] = {
		Level = 334,
		XpToNextLevel = 1194,
		MaxCatchWeight = 334,
	},
	["335"] = {
		Level = 335,
		XpToNextLevel = 1202,
		MaxCatchWeight = 335,
	},
	["336"] = {
		Level = 336,
		XpToNextLevel = 1209,
		MaxCatchWeight = 336,
	},
	["337"] = {
		Level = 337,
		XpToNextLevel = 1217,
		MaxCatchWeight = 337,
	},
	["338"] = {
		Level = 338,
		XpToNextLevel = 1224,
		MaxCatchWeight = 338,
	},
	["339"] = {
		Level = 339,
		XpToNextLevel = 1232,
		MaxCatchWeight = 339,
	},
	["340"] = {
		Level = 340,
		XpToNextLevel = 1240,
		MaxCatchWeight = 340,
	},
	["341"] = {
		Level = 341,
		XpToNextLevel = 1247,
		MaxCatchWeight = 341,
	},
	["342"] = {
		Level = 342,
		XpToNextLevel = 1255,
		MaxCatchWeight = 342,
	},
	["343"] = {
		Level = 343,
		XpToNextLevel = 1263,
		MaxCatchWeight = 343,
	},
	["344"] = {
		Level = 344,
		XpToNextLevel = 1271,
		MaxCatchWeight = 344,
	},
	["345"] = {
		Level = 345,
		XpToNextLevel = 1278,
		MaxCatchWeight = 345,
	},
	["346"] = {
		Level = 346,
		XpToNextLevel = 1286,
		MaxCatchWeight = 346,
	},
	["347"] = {
		Level = 347,
		XpToNextLevel = 1294,
		MaxCatchWeight = 347,
	},
	["348"] = {
		Level = 348,
		XpToNextLevel = 1302,
		MaxCatchWeight = 348,
	},
	["349"] = {
		Level = 349,
		XpToNextLevel = 1310,
		MaxCatchWeight = 349,
	},
	["350"] = {
		Level = 350,
		XpToNextLevel = 1317,
		MaxCatchWeight = 350,
	},
	["351"] = {
		Level = 351,
		XpToNextLevel = 1325,
		MaxCatchWeight = 351,
	},
	["352"] = {
		Level = 352,
		XpToNextLevel = 1333,
		MaxCatchWeight = 352,
	},
	["353"] = {
		Level = 353,
		XpToNextLevel = 1341,
		MaxCatchWeight = 353,
	},
	["354"] = {
		Level = 354,
		XpToNextLevel = 1349,
		MaxCatchWeight = 354,
	},
	["355"] = {
		Level = 355,
		XpToNextLevel = 1357,
		MaxCatchWeight = 355,
	},
	["356"] = {
		Level = 356,
		XpToNextLevel = 1365,
		MaxCatchWeight = 356,
	},
	["357"] = {
		Level = 357,
		XpToNextLevel = 1373,
		MaxCatchWeight = 357,
	},
	["358"] = {
		Level = 358,
		XpToNextLevel = 1381,
		MaxCatchWeight = 358,
	},
	["359"] = {
		Level = 359,
		XpToNextLevel = 1390,
		MaxCatchWeight = 359,
	},
	["360"] = {
		Level = 360,
		XpToNextLevel = 1398,
		MaxCatchWeight = 360,
	},
	["361"] = {
		Level = 361,
		XpToNextLevel = 1406,
		MaxCatchWeight = 361,
	},
	["362"] = {
		Level = 362,
		XpToNextLevel = 1414,
		MaxCatchWeight = 362,
	},
	["363"] = {
		Level = 363,
		XpToNextLevel = 1422,
		MaxCatchWeight = 363,
	},
	["364"] = {
		Level = 364,
		XpToNextLevel = 1430,
		MaxCatchWeight = 364,
	},
	["365"] = {
		Level = 365,
		XpToNextLevel = 1439,
		MaxCatchWeight = 365,
	},
	["366"] = {
		Level = 366,
		XpToNextLevel = 1447,
		MaxCatchWeight = 366,
	},
	["367"] = {
		Level = 367,
		XpToNextLevel = 1455,
		MaxCatchWeight = 367,
	},
	["368"] = {
		Level = 368,
		XpToNextLevel = 1464,
		MaxCatchWeight = 368,
	},
	["369"] = {
		Level = 369,
		XpToNextLevel = 1472,
		MaxCatchWeight = 369,
	},
	["370"] = {
		Level = 370,
		XpToNextLevel = 1480,
		MaxCatchWeight = 370,
	},
	["371"] = {
		Level = 371,
		XpToNextLevel = 1489,
		MaxCatchWeight = 371,
	},
	["372"] = {
		Level = 372,
		XpToNextLevel = 1497,
		MaxCatchWeight = 372,
	},
	["373"] = {
		Level = 373,
		XpToNextLevel = 1506,
		MaxCatchWeight = 373,
	},
	["374"] = {
		Level = 374,
		XpToNextLevel = 1514,
		MaxCatchWeight = 374,
	},
	["375"] = {
		Level = 375,
		XpToNextLevel = 1523,
		MaxCatchWeight = 375,
	},
	["376"] = {
		Level = 376,
		XpToNextLevel = 1531,
		MaxCatchWeight = 376,
	},
	["377"] = {
		Level = 377,
		XpToNextLevel = 1540,
		MaxCatchWeight = 377,
	},
	["378"] = {
		Level = 378,
		XpToNextLevel = 1548,
		MaxCatchWeight = 378,
	},
	["379"] = {
		Level = 379,
		XpToNextLevel = 1557,
		MaxCatchWeight = 379,
	},
	["380"] = {
		Level = 380,
		XpToNextLevel = 1566,
		MaxCatchWeight = 380,
	},
	["381"] = {
		Level = 381,
		XpToNextLevel = 1574,
		MaxCatchWeight = 381,
	},
	["382"] = {
		Level = 382,
		XpToNextLevel = 1583,
		MaxCatchWeight = 382,
	},
	["383"] = {
		Level = 383,
		XpToNextLevel = 1592,
		MaxCatchWeight = 383,
	},
	["384"] = {
		Level = 384,
		XpToNextLevel = 1600,
		MaxCatchWeight = 384,
	},
	["385"] = {
		Level = 385,
		XpToNextLevel = 1609,
		MaxCatchWeight = 385,
	},
	["386"] = {
		Level = 386,
		XpToNextLevel = 1618,
		MaxCatchWeight = 386,
	},
	["387"] = {
		Level = 387,
		XpToNextLevel = 1627,
		MaxCatchWeight = 387,
	},
	["388"] = {
		Level = 388,
		XpToNextLevel = 1636,
		MaxCatchWeight = 388,
	},
	["389"] = {
		Level = 389,
		XpToNextLevel = 1644,
		MaxCatchWeight = 389,
	},
	["390"] = {
		Level = 390,
		XpToNextLevel = 1653,
		MaxCatchWeight = 390,
	},
	["391"] = {
		Level = 391,
		XpToNextLevel = 1662,
		MaxCatchWeight = 391,
	},
	["392"] = {
		Level = 392,
		XpToNextLevel = 1671,
		MaxCatchWeight = 392,
	},
	["393"] = {
		Level = 393,
		XpToNextLevel = 1680,
		MaxCatchWeight = 393,
	},
	["394"] = {
		Level = 394,
		XpToNextLevel = 1689,
		MaxCatchWeight = 394,
	},
	["395"] = {
		Level = 395,
		XpToNextLevel = 1698,
		MaxCatchWeight = 395,
	},
	["396"] = {
		Level = 396,
		XpToNextLevel = 1707,
		MaxCatchWeight = 396,
	},
	["397"] = {
		Level = 397,
		XpToNextLevel = 1716,
		MaxCatchWeight = 397,
	},
	["398"] = {
		Level = 398,
		XpToNextLevel = 1725,
		MaxCatchWeight = 398,
	},
	["399"] = {
		Level = 399,
		XpToNextLevel = 1734,
		MaxCatchWeight = 399,
	},
	["400"] = {
		Level = 400,
		XpToNextLevel = 1744,
		MaxCatchWeight = 400,
	},
	["401"] = {
		Level = 401,
		XpToNextLevel = 1753,
		MaxCatchWeight = 401,
	},
	["402"] = {
		Level = 402,
		XpToNextLevel = 1762,
		MaxCatchWeight = 402,
	},
	["403"] = {
		Level = 403,
		XpToNextLevel = 1771,
		MaxCatchWeight = 403,
	},
	["404"] = {
		Level = 404,
		XpToNextLevel = 1780,
		MaxCatchWeight = 404,
	},
	["405"] = {
		Level = 405,
		XpToNextLevel = 1790,
		MaxCatchWeight = 405,
	},
	["406"] = {
		Level = 406,
		XpToNextLevel = 1799,
		MaxCatchWeight = 406,
	},
	["407"] = {
		Level = 407,
		XpToNextLevel = 1808,
		MaxCatchWeight = 407,
	},
	["408"] = {
		Level = 408,
		XpToNextLevel = 1818,
		MaxCatchWeight = 408,
	},
	["409"] = {
		Level = 409,
		XpToNextLevel = 1827,
		MaxCatchWeight = 409,
	},
	["410"] = {
		Level = 410,
		XpToNextLevel = 1836,
		MaxCatchWeight = 410,
	},
	["411"] = {
		Level = 411,
		XpToNextLevel = 1846,
		MaxCatchWeight = 411,
	},
	["412"] = {
		Level = 412,
		XpToNextLevel = 1855,
		MaxCatchWeight = 412,
	},
	["413"] = {
		Level = 413,
		XpToNextLevel = 1865,
		MaxCatchWeight = 413,
	},
	["414"] = {
		Level = 414,
		XpToNextLevel = 1874,
		MaxCatchWeight = 414,
	},
	["415"] = {
		Level = 415,
		XpToNextLevel = 1884,
		MaxCatchWeight = 415,
	},
	["416"] = {
		Level = 416,
		XpToNextLevel = 1893,
		MaxCatchWeight = 416,
	},
	["417"] = {
		Level = 417,
		XpToNextLevel = 1903,
		MaxCatchWeight = 417,
	},
	["418"] = {
		Level = 418,
		XpToNextLevel = 1912,
		MaxCatchWeight = 418,
	},
	["419"] = {
		Level = 419,
		XpToNextLevel = 1922,
		MaxCatchWeight = 419,
	},
	["420"] = {
		Level = 420,
		XpToNextLevel = 1932,
		MaxCatchWeight = 420,
	},
	["421"] = {
		Level = 421,
		XpToNextLevel = 1941,
		MaxCatchWeight = 421,
	},
	["422"] = {
		Level = 422,
		XpToNextLevel = 1951,
		MaxCatchWeight = 422,
	},
	["423"] = {
		Level = 423,
		XpToNextLevel = 1961,
		MaxCatchWeight = 423,
	},
	["424"] = {
		Level = 424,
		XpToNextLevel = 1970,
		MaxCatchWeight = 424,
	},
	["425"] = {
		Level = 425,
		XpToNextLevel = 1980,
		MaxCatchWeight = 425,
	},
	["426"] = {
		Level = 426,
		XpToNextLevel = 1990,
		MaxCatchWeight = 426,
	},
	["427"] = {
		Level = 427,
		XpToNextLevel = 2000,
		MaxCatchWeight = 427,
	},
	["428"] = {
		Level = 428,
		XpToNextLevel = 2010,
		MaxCatchWeight = 428,
	},
	["429"] = {
		Level = 429,
		XpToNextLevel = 2020,
		MaxCatchWeight = 429,
	},
	["430"] = {
		Level = 430,
		XpToNextLevel = 2029,
		MaxCatchWeight = 430,
	},
	["431"] = {
		Level = 431,
		XpToNextLevel = 2039,
		MaxCatchWeight = 431,
	},
	["432"] = {
		Level = 432,
		XpToNextLevel = 2049,
		MaxCatchWeight = 432,
	},
	["433"] = {
		Level = 433,
		XpToNextLevel = 2059,
		MaxCatchWeight = 433,
	},
	["434"] = {
		Level = 434,
		XpToNextLevel = 2069,
		MaxCatchWeight = 434,
	},
	["435"] = {
		Level = 435,
		XpToNextLevel = 2079,
		MaxCatchWeight = 435,
	},
	["436"] = {
		Level = 436,
		XpToNextLevel = 2089,
		MaxCatchWeight = 436,
	},
	["437"] = {
		Level = 437,
		XpToNextLevel = 2099,
		MaxCatchWeight = 437,
	},
	["438"] = {
		Level = 438,
		XpToNextLevel = 2110,
		MaxCatchWeight = 438,
	},
	["439"] = {
		Level = 439,
		XpToNextLevel = 2120,
		MaxCatchWeight = 439,
	},
	["440"] = {
		Level = 440,
		XpToNextLevel = 2130,
		MaxCatchWeight = 440,
	},
	["441"] = {
		Level = 441,
		XpToNextLevel = 2140,
		MaxCatchWeight = 441,
	},
	["442"] = {
		Level = 442,
		XpToNextLevel = 2150,
		MaxCatchWeight = 442,
	},
	["443"] = {
		Level = 443,
		XpToNextLevel = 2160,
		MaxCatchWeight = 443,
	},
	["444"] = {
		Level = 444,
		XpToNextLevel = 2171,
		MaxCatchWeight = 444,
	},
	["445"] = {
		Level = 445,
		XpToNextLevel = 2181,
		MaxCatchWeight = 445,
	},
	["446"] = {
		Level = 446,
		XpToNextLevel = 2191,
		MaxCatchWeight = 446,
	},
	["447"] = {
		Level = 447,
		XpToNextLevel = 2202,
		MaxCatchWeight = 447,
	},
	["448"] = {
		Level = 448,
		XpToNextLevel = 2212,
		MaxCatchWeight = 448,
	},
	["449"] = {
		Level = 449,
		XpToNextLevel = 2222,
		MaxCatchWeight = 449,
	},
	["450"] = {
		Level = 450,
		XpToNextLevel = 2233,
		MaxCatchWeight = 450,
	},
	["451"] = {
		Level = 451,
		XpToNextLevel = 2243,
		MaxCatchWeight = 451,
	},
	["452"] = {
		Level = 452,
		XpToNextLevel = 2254,
		MaxCatchWeight = 452,
	},
	["453"] = {
		Level = 453,
		XpToNextLevel = 2264,
		MaxCatchWeight = 453,
	},
	["454"] = {
		Level = 454,
		XpToNextLevel = 2275,
		MaxCatchWeight = 454,
	},
	["455"] = {
		Level = 455,
		XpToNextLevel = 2285,
		MaxCatchWeight = 455,
	},
	["456"] = {
		Level = 456,
		XpToNextLevel = 2296,
		MaxCatchWeight = 456,
	},
	["457"] = {
		Level = 457,
		XpToNextLevel = 2306,
		MaxCatchWeight = 457,
	},
	["458"] = {
		Level = 458,
		XpToNextLevel = 2317,
		MaxCatchWeight = 458,
	},
	["459"] = {
		Level = 459,
		XpToNextLevel = 2328,
		MaxCatchWeight = 459,
	},
	["460"] = {
		Level = 460,
		XpToNextLevel = 2338,
		MaxCatchWeight = 460,
	},
	["461"] = {
		Level = 461,
		XpToNextLevel = 2349,
		MaxCatchWeight = 461,
	},
	["462"] = {
		Level = 462,
		XpToNextLevel = 2360,
		MaxCatchWeight = 462,
	},
	["463"] = {
		Level = 463,
		XpToNextLevel = 2370,
		MaxCatchWeight = 463,
	},
	["464"] = {
		Level = 464,
		XpToNextLevel = 2381,
		MaxCatchWeight = 464,
	},
	["465"] = {
		Level = 465,
		XpToNextLevel = 2392,
		MaxCatchWeight = 465,
	},
	["466"] = {
		Level = 466,
		XpToNextLevel = 2403,
		MaxCatchWeight = 466,
	},
	["467"] = {
		Level = 467,
		XpToNextLevel = 2414,
		MaxCatchWeight = 467,
	},
	["468"] = {
		Level = 468,
		XpToNextLevel = 2424,
		MaxCatchWeight = 468,
	},
	["469"] = {
		Level = 469,
		XpToNextLevel = 2435,
		MaxCatchWeight = 469,
	},
	["470"] = {
		Level = 470,
		XpToNextLevel = 2446,
		MaxCatchWeight = 470,
	},
	["471"] = {
		Level = 471,
		XpToNextLevel = 2457,
		MaxCatchWeight = 471,
	},
	["472"] = {
		Level = 472,
		XpToNextLevel = 2468,
		MaxCatchWeight = 472,
	},
	["473"] = {
		Level = 473,
		XpToNextLevel = 2479,
		MaxCatchWeight = 473,
	},
	["474"] = {
		Level = 474,
		XpToNextLevel = 2490,
		MaxCatchWeight = 474,
	},
	["475"] = {
		Level = 475,
		XpToNextLevel = 2501,
		MaxCatchWeight = 475,
	},
	["476"] = {
		Level = 476,
		XpToNextLevel = 2512,
		MaxCatchWeight = 476,
	},
	["477"] = {
		Level = 477,
		XpToNextLevel = 2523,
		MaxCatchWeight = 477,
	},
	["478"] = {
		Level = 478,
		XpToNextLevel = 2535,
		MaxCatchWeight = 478,
	},
	["479"] = {
		Level = 479,
		XpToNextLevel = 2546,
		MaxCatchWeight = 479,
	},
	["480"] = {
		Level = 480,
		XpToNextLevel = 2557,
		MaxCatchWeight = 480,
	},
	["481"] = {
		Level = 481,
		XpToNextLevel = 2568,
		MaxCatchWeight = 481,
	},
	["482"] = {
		Level = 482,
		XpToNextLevel = 2579,
		MaxCatchWeight = 482,
	},
	["483"] = {
		Level = 483,
		XpToNextLevel = 2591,
		MaxCatchWeight = 483,
	},
	["484"] = {
		Level = 484,
		XpToNextLevel = 2602,
		MaxCatchWeight = 484,
	},
	["485"] = {
		Level = 485,
		XpToNextLevel = 2613,
		MaxCatchWeight = 485,
	},
	["486"] = {
		Level = 486,
		XpToNextLevel = 2624,
		MaxCatchWeight = 486,
	},
	["487"] = {
		Level = 487,
		XpToNextLevel = 2636,
		MaxCatchWeight = 487,
	},
	["488"] = {
		Level = 488,
		XpToNextLevel = 2647,
		MaxCatchWeight = 488,
	},
	["489"] = {
		Level = 489,
		XpToNextLevel = 2659,
		MaxCatchWeight = 489,
	},
	["490"] = {
		Level = 490,
		XpToNextLevel = 2670,
		MaxCatchWeight = 490,
	},
	["491"] = {
		Level = 491,
		XpToNextLevel = 2681,
		MaxCatchWeight = 491,
	},
	["492"] = {
		Level = 492,
		XpToNextLevel = 2693,
		MaxCatchWeight = 492,
	},
	["493"] = {
		Level = 493,
		XpToNextLevel = 2704,
		MaxCatchWeight = 493,
	},
	["494"] = {
		Level = 494,
		XpToNextLevel = 2716,
		MaxCatchWeight = 494,
	},
	["495"] = {
		Level = 495,
		XpToNextLevel = 2728,
		MaxCatchWeight = 495,
	},
	["496"] = {
		Level = 496,
		XpToNextLevel = 2739,
		MaxCatchWeight = 496,
	},
	["497"] = {
		Level = 497,
		XpToNextLevel = 2751,
		MaxCatchWeight = 497,
	},
	["498"] = {
		Level = 498,
		XpToNextLevel = 2762,
		MaxCatchWeight = 498,
	},
	["499"] = {
		Level = 499,
		XpToNextLevel = 2774,
		MaxCatchWeight = 499,
	},
	["500"] = {
		Level = 500,
		XpToNextLevel = 2786,
		MaxCatchWeight = 500,
	},
	["501"] = {
		Level = 501,
		XpToNextLevel = 2797,
		MaxCatchWeight = 501,
	},
	["502"] = {
		Level = 502,
		XpToNextLevel = 2809,
		MaxCatchWeight = 502,
	},
	["503"] = {
		Level = 503,
		XpToNextLevel = 2821,
		MaxCatchWeight = 503,
	},
	["504"] = {
		Level = 504,
		XpToNextLevel = 2833,
		MaxCatchWeight = 504,
	},
	["505"] = {
		Level = 505,
		XpToNextLevel = 2845,
		MaxCatchWeight = 505,
	},
	["506"] = {
		Level = 506,
		XpToNextLevel = 2856,
		MaxCatchWeight = 506,
	},
	["507"] = {
		Level = 507,
		XpToNextLevel = 2868,
		MaxCatchWeight = 507,
	},
	["508"] = {
		Level = 508,
		XpToNextLevel = 2880,
		MaxCatchWeight = 508,
	},
	["509"] = {
		Level = 509,
		XpToNextLevel = 2892,
		MaxCatchWeight = 509,
	},
	["510"] = {
		Level = 510,
		XpToNextLevel = 2904,
		MaxCatchWeight = 510,
	},
	["511"] = {
		Level = 511,
		XpToNextLevel = 2916,
		MaxCatchWeight = 511,
	},
	["512"] = {
		Level = 512,
		XpToNextLevel = 2928,
		MaxCatchWeight = 512,
	},
	["513"] = {
		Level = 513,
		XpToNextLevel = 2940,
		MaxCatchWeight = 513,
	},
	["514"] = {
		Level = 514,
		XpToNextLevel = 2952,
		MaxCatchWeight = 514,
	},
	["515"] = {
		Level = 515,
		XpToNextLevel = 2964,
		MaxCatchWeight = 515,
	},
	["516"] = {
		Level = 516,
		XpToNextLevel = 2976,
		MaxCatchWeight = 516,
	},
	["517"] = {
		Level = 517,
		XpToNextLevel = 2988,
		MaxCatchWeight = 517,
	},
	["518"] = {
		Level = 518,
		XpToNextLevel = 3001,
		MaxCatchWeight = 518,
	},
	["519"] = {
		Level = 519,
		XpToNextLevel = 3013,
		MaxCatchWeight = 519,
	},
	["520"] = {
		Level = 520,
		XpToNextLevel = 3025,
		MaxCatchWeight = 520,
	},
	["521"] = {
		Level = 521,
		XpToNextLevel = 3037,
		MaxCatchWeight = 521,
	},
	["522"] = {
		Level = 522,
		XpToNextLevel = 3049,
		MaxCatchWeight = 522,
	},
	["523"] = {
		Level = 523,
		XpToNextLevel = 3062,
		MaxCatchWeight = 523,
	},
	["524"] = {
		Level = 524,
		XpToNextLevel = 3074,
		MaxCatchWeight = 524,
	},
	["525"] = {
		Level = 525,
		XpToNextLevel = 3086,
		MaxCatchWeight = 525,
	},
	["526"] = {
		Level = 526,
		XpToNextLevel = 3099,
		MaxCatchWeight = 526,
	},
	["527"] = {
		Level = 527,
		XpToNextLevel = 3111,
		MaxCatchWeight = 527,
	},
	["528"] = {
		Level = 528,
		XpToNextLevel = 3124,
		MaxCatchWeight = 528,
	},
	["529"] = {
		Level = 529,
		XpToNextLevel = 3136,
		MaxCatchWeight = 529,
	},
	["530"] = {
		Level = 530,
		XpToNextLevel = 3148,
		MaxCatchWeight = 530,
	},
	["531"] = {
		Level = 531,
		XpToNextLevel = 3161,
		MaxCatchWeight = 531,
	},
	["532"] = {
		Level = 532,
		XpToNextLevel = 3173,
		MaxCatchWeight = 532,
	},
	["533"] = {
		Level = 533,
		XpToNextLevel = 3186,
		MaxCatchWeight = 533,
	},
	["534"] = {
		Level = 534,
		XpToNextLevel = 3199,
		MaxCatchWeight = 534,
	},
	["535"] = {
		Level = 535,
		XpToNextLevel = 3211,
		MaxCatchWeight = 535,
	},
	["536"] = {
		Level = 536,
		XpToNextLevel = 3224,
		MaxCatchWeight = 536,
	},
	["537"] = {
		Level = 537,
		XpToNextLevel = 3236,
		MaxCatchWeight = 537,
	},
	["538"] = {
		Level = 538,
		XpToNextLevel = 3249,
		MaxCatchWeight = 538,
	},
	["539"] = {
		Level = 539,
		XpToNextLevel = 3262,
		MaxCatchWeight = 539,
	},
	["540"] = {
		Level = 540,
		XpToNextLevel = 3275,
		MaxCatchWeight = 540,
	},
	["541"] = {
		Level = 541,
		XpToNextLevel = 3287,
		MaxCatchWeight = 541,
	},
	["542"] = {
		Level = 542,
		XpToNextLevel = 3300,
		MaxCatchWeight = 542,
	},
	["543"] = {
		Level = 543,
		XpToNextLevel = 3313,
		MaxCatchWeight = 543,
	},
	["544"] = {
		Level = 544,
		XpToNextLevel = 3326,
		MaxCatchWeight = 544,
	},
	["545"] = {
		Level = 545,
		XpToNextLevel = 3339,
		MaxCatchWeight = 545,
	},
	["546"] = {
		Level = 546,
		XpToNextLevel = 3351,
		MaxCatchWeight = 546,
	},
	["547"] = {
		Level = 547,
		XpToNextLevel = 3364,
		MaxCatchWeight = 547,
	},
	["548"] = {
		Level = 548,
		XpToNextLevel = 3377,
		MaxCatchWeight = 548,
	},
	["549"] = {
		Level = 549,
		XpToNextLevel = 3390,
		MaxCatchWeight = 549,
	},
	["550"] = {
		Level = 550,
		XpToNextLevel = 3403,
		MaxCatchWeight = 550,
	},
	["551"] = {
		Level = 551,
		XpToNextLevel = 3416,
		MaxCatchWeight = 551,
	},
	["552"] = {
		Level = 552,
		XpToNextLevel = 3429,
		MaxCatchWeight = 552,
	},
	["553"] = {
		Level = 553,
		XpToNextLevel = 3442,
		MaxCatchWeight = 553,
	},
	["554"] = {
		Level = 554,
		XpToNextLevel = 3455,
		MaxCatchWeight = 554,
	},
	["555"] = {
		Level = 555,
		XpToNextLevel = 3469,
		MaxCatchWeight = 555,
	},
	["556"] = {
		Level = 556,
		XpToNextLevel = 3482,
		MaxCatchWeight = 556,
	},
	["557"] = {
		Level = 557,
		XpToNextLevel = 3495,
		MaxCatchWeight = 557,
	},
	["558"] = {
		Level = 558,
		XpToNextLevel = 3508,
		MaxCatchWeight = 558,
	},
	["559"] = {
		Level = 559,
		XpToNextLevel = 3521,
		MaxCatchWeight = 559,
	},
	["560"] = {
		Level = 560,
		XpToNextLevel = 3535,
		MaxCatchWeight = 560,
	},
	["561"] = {
		Level = 561,
		XpToNextLevel = 3548,
		MaxCatchWeight = 561,
	},
	["562"] = {
		Level = 562,
		XpToNextLevel = 3561,
		MaxCatchWeight = 562,
	},
	["563"] = {
		Level = 563,
		XpToNextLevel = 3574,
		MaxCatchWeight = 563,
	},
	["564"] = {
		Level = 564,
		XpToNextLevel = 3588,
		MaxCatchWeight = 564,
	},
	["565"] = {
		Level = 565,
		XpToNextLevel = 3601,
		MaxCatchWeight = 565,
	},
	["566"] = {
		Level = 566,
		XpToNextLevel = 3615,
		MaxCatchWeight = 566,
	},
	["567"] = {
		Level = 567,
		XpToNextLevel = 3628,
		MaxCatchWeight = 567,
	},
	["568"] = {
		Level = 568,
		XpToNextLevel = 3641,
		MaxCatchWeight = 568,
	},
	["569"] = {
		Level = 569,
		XpToNextLevel = 3655,
		MaxCatchWeight = 569,
	},
	["570"] = {
		Level = 570,
		XpToNextLevel = 3668,
		MaxCatchWeight = 570,
	},
	["571"] = {
		Level = 571,
		XpToNextLevel = 3682,
		MaxCatchWeight = 571,
	},
	["572"] = {
		Level = 572,
		XpToNextLevel = 3696,
		MaxCatchWeight = 572,
	},
	["573"] = {
		Level = 573,
		XpToNextLevel = 3709,
		MaxCatchWeight = 573,
	},
	["574"] = {
		Level = 574,
		XpToNextLevel = 3723,
		MaxCatchWeight = 574,
	},
	["575"] = {
		Level = 575,
		XpToNextLevel = 3736,
		MaxCatchWeight = 575,
	},
	["576"] = {
		Level = 576,
		XpToNextLevel = 3750,
		MaxCatchWeight = 576,
	},
	["577"] = {
		Level = 577,
		XpToNextLevel = 3764,
		MaxCatchWeight = 577,
	},
	["578"] = {
		Level = 578,
		XpToNextLevel = 3777,
		MaxCatchWeight = 578,
	},
	["579"] = {
		Level = 579,
		XpToNextLevel = 3791,
		MaxCatchWeight = 579,
	},
	["580"] = {
		Level = 580,
		XpToNextLevel = 3805,
		MaxCatchWeight = 580,
	},
	["581"] = {
		Level = 581,
		XpToNextLevel = 3819,
		MaxCatchWeight = 581,
	},
	["582"] = {
		Level = 582,
		XpToNextLevel = 3833,
		MaxCatchWeight = 582,
	},
	["583"] = {
		Level = 583,
		XpToNextLevel = 3846,
		MaxCatchWeight = 583,
	},
	["584"] = {
		Level = 584,
		XpToNextLevel = 3860,
		MaxCatchWeight = 584,
	},
	["585"] = {
		Level = 585,
		XpToNextLevel = 3874,
		MaxCatchWeight = 585,
	},
	["586"] = {
		Level = 586,
		XpToNextLevel = 3888,
		MaxCatchWeight = 586,
	},
	["587"] = {
		Level = 587,
		XpToNextLevel = 3902,
		MaxCatchWeight = 587,
	},
	["588"] = {
		Level = 588,
		XpToNextLevel = 3916,
		MaxCatchWeight = 588,
	},
	["589"] = {
		Level = 589,
		XpToNextLevel = 3930,
		MaxCatchWeight = 589,
	},
	["590"] = {
		Level = 590,
		XpToNextLevel = 3944,
		MaxCatchWeight = 590,
	},
	["591"] = {
		Level = 591,
		XpToNextLevel = 3958,
		MaxCatchWeight = 591,
	},
	["592"] = {
		Level = 592,
		XpToNextLevel = 3972,
		MaxCatchWeight = 592,
	},
	["593"] = {
		Level = 593,
		XpToNextLevel = 3986,
		MaxCatchWeight = 593,
	},
	["594"] = {
		Level = 594,
		XpToNextLevel = 4000,
		MaxCatchWeight = 594,
	},
	["595"] = {
		Level = 595,
		XpToNextLevel = 4015,
		MaxCatchWeight = 595,
	},
	["596"] = {
		Level = 596,
		XpToNextLevel = 4029,
		MaxCatchWeight = 596,
	},
	["597"] = {
		Level = 597,
		XpToNextLevel = 4043,
		MaxCatchWeight = 597,
	},
	["598"] = {
		Level = 598,
		XpToNextLevel = 4057,
		MaxCatchWeight = 598,
	},
	["599"] = {
		Level = 599,
		XpToNextLevel = 4072,
		MaxCatchWeight = 599,
	},
	["600"] = {
		Level = 600,
		XpToNextLevel = 4086,
		MaxCatchWeight = 600,
	},
	["601"] = {
		Level = 601,
		XpToNextLevel = 4100,
		MaxCatchWeight = 601,
	},
	["602"] = {
		Level = 602,
		XpToNextLevel = 4114,
		MaxCatchWeight = 602,
	},
	["603"] = {
		Level = 603,
		XpToNextLevel = 4129,
		MaxCatchWeight = 603,
	},
	["604"] = {
		Level = 604,
		XpToNextLevel = 4143,
		MaxCatchWeight = 604,
	},
	["605"] = {
		Level = 605,
		XpToNextLevel = 4158,
		MaxCatchWeight = 605,
	},
	["606"] = {
		Level = 606,
		XpToNextLevel = 4172,
		MaxCatchWeight = 606,
	},
	["607"] = {
		Level = 607,
		XpToNextLevel = 4187,
		MaxCatchWeight = 607,
	},
	["608"] = {
		Level = 608,
		XpToNextLevel = 4201,
		MaxCatchWeight = 608,
	},
	["609"] = {
		Level = 609,
		XpToNextLevel = 4216,
		MaxCatchWeight = 609,
	},
	["610"] = {
		Level = 610,
		XpToNextLevel = 4230,
		MaxCatchWeight = 610,
	},
	["611"] = {
		Level = 611,
		XpToNextLevel = 4245,
		MaxCatchWeight = 611,
	},
	["612"] = {
		Level = 612,
		XpToNextLevel = 4259,
		MaxCatchWeight = 612,
	},
	["613"] = {
		Level = 613,
		XpToNextLevel = 4274,
		MaxCatchWeight = 613,
	},
	["614"] = {
		Level = 614,
		XpToNextLevel = 4289,
		MaxCatchWeight = 614,
	},
	["615"] = {
		Level = 615,
		XpToNextLevel = 4303,
		MaxCatchWeight = 615,
	},
	["616"] = {
		Level = 616,
		XpToNextLevel = 4318,
		MaxCatchWeight = 616,
	},
	["617"] = {
		Level = 617,
		XpToNextLevel = 4333,
		MaxCatchWeight = 617,
	},
	["618"] = {
		Level = 618,
		XpToNextLevel = 4348,
		MaxCatchWeight = 618,
	},
	["619"] = {
		Level = 619,
		XpToNextLevel = 4362,
		MaxCatchWeight = 619,
	},
	["620"] = {
		Level = 620,
		XpToNextLevel = 4377,
		MaxCatchWeight = 620,
	},
	["621"] = {
		Level = 621,
		XpToNextLevel = 4392,
		MaxCatchWeight = 621,
	},
	["622"] = {
		Level = 622,
		XpToNextLevel = 4407,
		MaxCatchWeight = 622,
	},
	["623"] = {
		Level = 623,
		XpToNextLevel = 4422,
		MaxCatchWeight = 623,
	},
	["624"] = {
		Level = 624,
		XpToNextLevel = 4437,
		MaxCatchWeight = 624,
	},
	["625"] = {
		Level = 625,
		XpToNextLevel = 4452,
		MaxCatchWeight = 625,
	},
	["626"] = {
		Level = 626,
		XpToNextLevel = 4467,
		MaxCatchWeight = 626,
	},
	["627"] = {
		Level = 627,
		XpToNextLevel = 4482,
		MaxCatchWeight = 627,
	},
	["628"] = {
		Level = 628,
		XpToNextLevel = 4497,
		MaxCatchWeight = 628,
	},
	["629"] = {
		Level = 629,
		XpToNextLevel = 4512,
		MaxCatchWeight = 629,
	},
	["630"] = {
		Level = 630,
		XpToNextLevel = 4527,
		MaxCatchWeight = 630,
	},
	["631"] = {
		Level = 631,
		XpToNextLevel = 4542,
		MaxCatchWeight = 631,
	},
	["632"] = {
		Level = 632,
		XpToNextLevel = 4557,
		MaxCatchWeight = 632,
	},
	["633"] = {
		Level = 633,
		XpToNextLevel = 4572,
		MaxCatchWeight = 633,
	},
	["634"] = {
		Level = 634,
		XpToNextLevel = 4587,
		MaxCatchWeight = 634,
	},
	["635"] = {
		Level = 635,
		XpToNextLevel = 4603,
		MaxCatchWeight = 635,
	},
	["636"] = {
		Level = 636,
		XpToNextLevel = 4618,
		MaxCatchWeight = 636,
	},
	["637"] = {
		Level = 637,
		XpToNextLevel = 4633,
		MaxCatchWeight = 637,
	},
	["638"] = {
		Level = 638,
		XpToNextLevel = 4648,
		MaxCatchWeight = 638,
	},
	["639"] = {
		Level = 639,
		XpToNextLevel = 4664,
		MaxCatchWeight = 639,
	},
	["640"] = {
		Level = 640,
		XpToNextLevel = 4679,
		MaxCatchWeight = 640,
	},
	["641"] = {
		Level = 641,
		XpToNextLevel = 4695,
		MaxCatchWeight = 641,
	},
	["642"] = {
		Level = 642,
		XpToNextLevel = 4710,
		MaxCatchWeight = 642,
	},
	["643"] = {
		Level = 643,
		XpToNextLevel = 4725,
		MaxCatchWeight = 643,
	},
	["644"] = {
		Level = 644,
		XpToNextLevel = 4741,
		MaxCatchWeight = 644,
	},
	["645"] = {
		Level = 645,
		XpToNextLevel = 4756,
		MaxCatchWeight = 645,
	},
	["646"] = {
		Level = 646,
		XpToNextLevel = 4772,
		MaxCatchWeight = 646,
	},
	["647"] = {
		Level = 647,
		XpToNextLevel = 4787,
		MaxCatchWeight = 647,
	},
	["648"] = {
		Level = 648,
		XpToNextLevel = 4803,
		MaxCatchWeight = 648,
	},
	["649"] = {
		Level = 649,
		XpToNextLevel = 4818,
		MaxCatchWeight = 649,
	},
	["650"] = {
		Level = 650,
		XpToNextLevel = 4834,
		MaxCatchWeight = 650,
	},
	["651"] = {
		Level = 651,
		XpToNextLevel = 4850,
		MaxCatchWeight = 651,
	},
	["652"] = {
		Level = 652,
		XpToNextLevel = 4865,
		MaxCatchWeight = 652,
	},
	["653"] = {
		Level = 653,
		XpToNextLevel = 4881,
		MaxCatchWeight = 653,
	},
	["654"] = {
		Level = 654,
		XpToNextLevel = 4897,
		MaxCatchWeight = 654,
	},
	["655"] = {
		Level = 655,
		XpToNextLevel = 4913,
		MaxCatchWeight = 655,
	},
	["656"] = {
		Level = 656,
		XpToNextLevel = 4928,
		MaxCatchWeight = 656,
	},
	["657"] = {
		Level = 657,
		XpToNextLevel = 4944,
		MaxCatchWeight = 657,
	},
	["658"] = {
		Level = 658,
		XpToNextLevel = 4960,
		MaxCatchWeight = 658,
	},
	["659"] = {
		Level = 659,
		XpToNextLevel = 4976,
		MaxCatchWeight = 659,
	},
	["660"] = {
		Level = 660,
		XpToNextLevel = 4992,
		MaxCatchWeight = 660,
	},
	["661"] = {
		Level = 661,
		XpToNextLevel = 5008,
		MaxCatchWeight = 661,
	},
	["662"] = {
		Level = 662,
		XpToNextLevel = 5024,
		MaxCatchWeight = 662,
	},
	["663"] = {
		Level = 663,
		XpToNextLevel = 5039,
		MaxCatchWeight = 663,
	},
	["664"] = {
		Level = 664,
		XpToNextLevel = 5055,
		MaxCatchWeight = 664,
	},
	["665"] = {
		Level = 665,
		XpToNextLevel = 5071,
		MaxCatchWeight = 665,
	},
	["666"] = {
		Level = 666,
		XpToNextLevel = 5087,
		MaxCatchWeight = 666,
	},
	["667"] = {
		Level = 667,
		XpToNextLevel = 5104,
		MaxCatchWeight = 667,
	},
	["668"] = {
		Level = 668,
		XpToNextLevel = 5120,
		MaxCatchWeight = 668,
	},
	["669"] = {
		Level = 669,
		XpToNextLevel = 5136,
		MaxCatchWeight = 669,
	},
	["670"] = {
		Level = 670,
		XpToNextLevel = 5152,
		MaxCatchWeight = 670,
	},
	["671"] = {
		Level = 671,
		XpToNextLevel = 5168,
		MaxCatchWeight = 671,
	},
	["672"] = {
		Level = 672,
		XpToNextLevel = 5184,
		MaxCatchWeight = 672,
	},
	["673"] = {
		Level = 673,
		XpToNextLevel = 5200,
		MaxCatchWeight = 673,
	},
	["674"] = {
		Level = 674,
		XpToNextLevel = 5217,
		MaxCatchWeight = 674,
	},
	["675"] = {
		Level = 675,
		XpToNextLevel = 5233,
		MaxCatchWeight = 675,
	},
	["676"] = {
		Level = 676,
		XpToNextLevel = 5249,
		MaxCatchWeight = 676,
	},
	["677"] = {
		Level = 677,
		XpToNextLevel = 5266,
		MaxCatchWeight = 677,
	},
	["678"] = {
		Level = 678,
		XpToNextLevel = 5282,
		MaxCatchWeight = 678,
	},
	["679"] = {
		Level = 679,
		XpToNextLevel = 5298,
		MaxCatchWeight = 679,
	},
	["680"] = {
		Level = 680,
		XpToNextLevel = 5315,
		MaxCatchWeight = 680,
	},
	["681"] = {
		Level = 681,
		XpToNextLevel = 5331,
		MaxCatchWeight = 681,
	},
	["682"] = {
		Level = 682,
		XpToNextLevel = 5348,
		MaxCatchWeight = 682,
	},
	["683"] = {
		Level = 683,
		XpToNextLevel = 5364,
		MaxCatchWeight = 683,
	},
	["684"] = {
		Level = 684,
		XpToNextLevel = 5381,
		MaxCatchWeight = 684,
	},
	["685"] = {
		Level = 685,
		XpToNextLevel = 5397,
		MaxCatchWeight = 685,
	},
	["686"] = {
		Level = 686,
		XpToNextLevel = 5414,
		MaxCatchWeight = 686,
	},
	["687"] = {
		Level = 687,
		XpToNextLevel = 5430,
		MaxCatchWeight = 687,
	},
	["688"] = {
		Level = 688,
		XpToNextLevel = 5447,
		MaxCatchWeight = 688,
	},
	["689"] = {
		Level = 689,
		XpToNextLevel = 5464,
		MaxCatchWeight = 689,
	},
	["690"] = {
		Level = 690,
		XpToNextLevel = 5480,
		MaxCatchWeight = 690,
	},
	["691"] = {
		Level = 691,
		XpToNextLevel = 5497,
		MaxCatchWeight = 691,
	},
	["692"] = {
		Level = 692,
		XpToNextLevel = 5514,
		MaxCatchWeight = 692,
	},
	["693"] = {
		Level = 693,
		XpToNextLevel = 5531,
		MaxCatchWeight = 693,
	},
	["694"] = {
		Level = 694,
		XpToNextLevel = 5547,
		MaxCatchWeight = 694,
	},
	["695"] = {
		Level = 695,
		XpToNextLevel = 5564,
		MaxCatchWeight = 695,
	},
	["696"] = {
		Level = 696,
		XpToNextLevel = 5581,
		MaxCatchWeight = 696,
	},
	["697"] = {
		Level = 697,
		XpToNextLevel = 5598,
		MaxCatchWeight = 697,
	},
	["698"] = {
		Level = 698,
		XpToNextLevel = 5615,
		MaxCatchWeight = 698,
	},
	["699"] = {
		Level = 699,
		XpToNextLevel = 5632,
		MaxCatchWeight = 699,
	},
	["700"] = {
		Level = 700,
		XpToNextLevel = 5649,
		MaxCatchWeight = 700,
	},
	["701"] = {
		Level = 701,
		XpToNextLevel = 5666,
		MaxCatchWeight = 701,
	},
	["702"] = {
		Level = 702,
		XpToNextLevel = 5683,
		MaxCatchWeight = 702,
	},
	["703"] = {
		Level = 703,
		XpToNextLevel = 5700,
		MaxCatchWeight = 703,
	},
	["704"] = {
		Level = 704,
		XpToNextLevel = 5717,
		MaxCatchWeight = 704,
	},
	["705"] = {
		Level = 705,
		XpToNextLevel = 5734,
		MaxCatchWeight = 705,
	},
	["706"] = {
		Level = 706,
		XpToNextLevel = 5751,
		MaxCatchWeight = 706,
	},
	["707"] = {
		Level = 707,
		XpToNextLevel = 5768,
		MaxCatchWeight = 707,
	},
	["708"] = {
		Level = 708,
		XpToNextLevel = 5785,
		MaxCatchWeight = 708,
	},
	["709"] = {
		Level = 709,
		XpToNextLevel = 5802,
		MaxCatchWeight = 709,
	},
	["710"] = {
		Level = 710,
		XpToNextLevel = 5819,
		MaxCatchWeight = 710,
	},
	["711"] = {
		Level = 711,
		XpToNextLevel = 5837,
		MaxCatchWeight = 711,
	},
	["712"] = {
		Level = 712,
		XpToNextLevel = 5854,
		MaxCatchWeight = 712,
	},
	["713"] = {
		Level = 713,
		XpToNextLevel = 5871,
		MaxCatchWeight = 713,
	},
	["714"] = {
		Level = 714,
		XpToNextLevel = 5889,
		MaxCatchWeight = 714,
	},
	["715"] = {
		Level = 715,
		XpToNextLevel = 5906,
		MaxCatchWeight = 715,
	},
	["716"] = {
		Level = 716,
		XpToNextLevel = 5923,
		MaxCatchWeight = 716,
	},
	["717"] = {
		Level = 717,
		XpToNextLevel = 5941,
		MaxCatchWeight = 717,
	},
	["718"] = {
		Level = 718,
		XpToNextLevel = 5958,
		MaxCatchWeight = 718,
	},
	["719"] = {
		Level = 719,
		XpToNextLevel = 5976,
		MaxCatchWeight = 719,
	},
	["720"] = {
		Level = 720,
		XpToNextLevel = 5993,
		MaxCatchWeight = 720,
	},
	["721"] = {
		Level = 721,
		XpToNextLevel = 6011,
		MaxCatchWeight = 721,
	},
	["722"] = {
		Level = 722,
		XpToNextLevel = 6028,
		MaxCatchWeight = 722,
	},
	["723"] = {
		Level = 723,
		XpToNextLevel = 6046,
		MaxCatchWeight = 723,
	},
	["724"] = {
		Level = 724,
		XpToNextLevel = 6063,
		MaxCatchWeight = 724,
	},
	["725"] = {
		Level = 725,
		XpToNextLevel = 6081,
		MaxCatchWeight = 725,
	},
	["726"] = {
		Level = 726,
		XpToNextLevel = 6098,
		MaxCatchWeight = 726,
	},
	["727"] = {
		Level = 727,
		XpToNextLevel = 6116,
		MaxCatchWeight = 727,
	},
	["728"] = {
		Level = 728,
		XpToNextLevel = 6134,
		MaxCatchWeight = 728,
	},
	["729"] = {
		Level = 729,
		XpToNextLevel = 6151,
		MaxCatchWeight = 729,
	},
	["730"] = {
		Level = 730,
		XpToNextLevel = 6169,
		MaxCatchWeight = 730,
	},
	["731"] = {
		Level = 731,
		XpToNextLevel = 6187,
		MaxCatchWeight = 731,
	},
	["732"] = {
		Level = 732,
		XpToNextLevel = 6205,
		MaxCatchWeight = 732,
	},
	["733"] = {
		Level = 733,
		XpToNextLevel = 6223,
		MaxCatchWeight = 733,
	},
	["734"] = {
		Level = 734,
		XpToNextLevel = 6240,
		MaxCatchWeight = 734,
	},
	["735"] = {
		Level = 735,
		XpToNextLevel = 6258,
		MaxCatchWeight = 735,
	},
	["736"] = {
		Level = 736,
		XpToNextLevel = 6276,
		MaxCatchWeight = 736,
	},
	["737"] = {
		Level = 737,
		XpToNextLevel = 6294,
		MaxCatchWeight = 737,
	},
	["738"] = {
		Level = 738,
		XpToNextLevel = 6312,
		MaxCatchWeight = 738,
	},
	["739"] = {
		Level = 739,
		XpToNextLevel = 6330,
		MaxCatchWeight = 739,
	},
	["740"] = {
		Level = 740,
		XpToNextLevel = 6348,
		MaxCatchWeight = 740,
	},
	["741"] = {
		Level = 741,
		XpToNextLevel = 6366,
		MaxCatchWeight = 741,
	},
	["742"] = {
		Level = 742,
		XpToNextLevel = 6384,
		MaxCatchWeight = 742,
	},
	["743"] = {
		Level = 743,
		XpToNextLevel = 6402,
		MaxCatchWeight = 743,
	},
	["744"] = {
		Level = 744,
		XpToNextLevel = 6420,
		MaxCatchWeight = 744,
	},
	["745"] = {
		Level = 745,
		XpToNextLevel = 6439,
		MaxCatchWeight = 745,
	},
	["746"] = {
		Level = 746,
		XpToNextLevel = 6457,
		MaxCatchWeight = 746,
	},
	["747"] = {
		Level = 747,
		XpToNextLevel = 6475,
		MaxCatchWeight = 747,
	},
	["748"] = {
		Level = 748,
		XpToNextLevel = 6493,
		MaxCatchWeight = 748,
	},
	["749"] = {
		Level = 749,
		XpToNextLevel = 6511,
		MaxCatchWeight = 749,
	},
	["750"] = {
		Level = 750,
		XpToNextLevel = 6530,
		MaxCatchWeight = 750,
	},
	["751"] = {
		Level = 751,
		XpToNextLevel = 6548,
		MaxCatchWeight = 751,
	},
	["752"] = {
		Level = 752,
		XpToNextLevel = 6566,
		MaxCatchWeight = 752,
	},
	["753"] = {
		Level = 753,
		XpToNextLevel = 6585,
		MaxCatchWeight = 753,
	},
	["754"] = {
		Level = 754,
		XpToNextLevel = 6603,
		MaxCatchWeight = 754,
	},
	["755"] = {
		Level = 755,
		XpToNextLevel = 6622,
		MaxCatchWeight = 755,
	},
	["756"] = {
		Level = 756,
		XpToNextLevel = 6640,
		MaxCatchWeight = 756,
	},
	["757"] = {
		Level = 757,
		XpToNextLevel = 6658,
		MaxCatchWeight = 757,
	},
	["758"] = {
		Level = 758,
		XpToNextLevel = 6677,
		MaxCatchWeight = 758,
	},
	["759"] = {
		Level = 759,
		XpToNextLevel = 6695,
		MaxCatchWeight = 759,
	},
	["760"] = {
		Level = 760,
		XpToNextLevel = 6714,
		MaxCatchWeight = 760,
	},
	["761"] = {
		Level = 761,
		XpToNextLevel = 6733,
		MaxCatchWeight = 761,
	},
	["762"] = {
		Level = 762,
		XpToNextLevel = 6751,
		MaxCatchWeight = 762,
	},
	["763"] = {
		Level = 763,
		XpToNextLevel = 6770,
		MaxCatchWeight = 763,
	},
	["764"] = {
		Level = 764,
		XpToNextLevel = 6788,
		MaxCatchWeight = 764,
	},
	["765"] = {
		Level = 765,
		XpToNextLevel = 6807,
		MaxCatchWeight = 765,
	},
	["766"] = {
		Level = 766,
		XpToNextLevel = 6826,
		MaxCatchWeight = 766,
	},
	["767"] = {
		Level = 767,
		XpToNextLevel = 6845,
		MaxCatchWeight = 767,
	},
	["768"] = {
		Level = 768,
		XpToNextLevel = 6863,
		MaxCatchWeight = 768,
	},
	["769"] = {
		Level = 769,
		XpToNextLevel = 6882,
		MaxCatchWeight = 769,
	},
	["770"] = {
		Level = 770,
		XpToNextLevel = 6901,
		MaxCatchWeight = 770,
	},
	["771"] = {
		Level = 771,
		XpToNextLevel = 6920,
		MaxCatchWeight = 771,
	},
	["772"] = {
		Level = 772,
		XpToNextLevel = 6939,
		MaxCatchWeight = 772,
	},
	["773"] = {
		Level = 773,
		XpToNextLevel = 6958,
		MaxCatchWeight = 773,
	},
	["774"] = {
		Level = 774,
		XpToNextLevel = 6977,
		MaxCatchWeight = 774,
	},
	["775"] = {
		Level = 775,
		XpToNextLevel = 6995,
		MaxCatchWeight = 775,
	},
	["776"] = {
		Level = 776,
		XpToNextLevel = 7014,
		MaxCatchWeight = 776,
	},
	["777"] = {
		Level = 777,
		XpToNextLevel = 7033,
		MaxCatchWeight = 777,
	},
	["778"] = {
		Level = 778,
		XpToNextLevel = 7053,
		MaxCatchWeight = 778,
	},
	["779"] = {
		Level = 779,
		XpToNextLevel = 7072,
		MaxCatchWeight = 779,
	},
	["780"] = {
		Level = 780,
		XpToNextLevel = 7091,
		MaxCatchWeight = 780,
	},
	["781"] = {
		Level = 781,
		XpToNextLevel = 7110,
		MaxCatchWeight = 781,
	},
	["782"] = {
		Level = 782,
		XpToNextLevel = 7129,
		MaxCatchWeight = 782,
	},
	["783"] = {
		Level = 783,
		XpToNextLevel = 7148,
		MaxCatchWeight = 783,
	},
	["784"] = {
		Level = 784,
		XpToNextLevel = 7167,
		MaxCatchWeight = 784,
	},
	["785"] = {
		Level = 785,
		XpToNextLevel = 7186,
		MaxCatchWeight = 785,
	},
	["786"] = {
		Level = 786,
		XpToNextLevel = 7206,
		MaxCatchWeight = 786,
	},
	["787"] = {
		Level = 787,
		XpToNextLevel = 7225,
		MaxCatchWeight = 787,
	},
	["788"] = {
		Level = 788,
		XpToNextLevel = 7244,
		MaxCatchWeight = 788,
	},
	["789"] = {
		Level = 789,
		XpToNextLevel = 7264,
		MaxCatchWeight = 789,
	},
	["790"] = {
		Level = 790,
		XpToNextLevel = 7283,
		MaxCatchWeight = 790,
	},
	["791"] = {
		Level = 791,
		XpToNextLevel = 7302,
		MaxCatchWeight = 791,
	},
	["792"] = {
		Level = 792,
		XpToNextLevel = 7322,
		MaxCatchWeight = 792,
	},
	["793"] = {
		Level = 793,
		XpToNextLevel = 7341,
		MaxCatchWeight = 793,
	},
	["794"] = {
		Level = 794,
		XpToNextLevel = 7361,
		MaxCatchWeight = 794,
	},
	["795"] = {
		Level = 795,
		XpToNextLevel = 7380,
		MaxCatchWeight = 795,
	},
	["796"] = {
		Level = 796,
		XpToNextLevel = 7400,
		MaxCatchWeight = 796,
	},
	["797"] = {
		Level = 797,
		XpToNextLevel = 7419,
		MaxCatchWeight = 797,
	},
	["798"] = {
		Level = 798,
		XpToNextLevel = 7439,
		MaxCatchWeight = 798,
	},
	["799"] = {
		Level = 799,
		XpToNextLevel = 7458,
		MaxCatchWeight = 799,
	},
	["800"] = {
		Level = 800,
		XpToNextLevel = 7478,
		MaxCatchWeight = 800,
	},
	["801"] = {
		Level = 801,
		XpToNextLevel = 7498,
		MaxCatchWeight = 801,
	},
	["802"] = {
		Level = 802,
		XpToNextLevel = 7517,
		MaxCatchWeight = 802,
	},
	["803"] = {
		Level = 803,
		XpToNextLevel = 7537,
		MaxCatchWeight = 803,
	},
	["804"] = {
		Level = 804,
		XpToNextLevel = 7557,
		MaxCatchWeight = 804,
	},
	["805"] = {
		Level = 805,
		XpToNextLevel = 7577,
		MaxCatchWeight = 805,
	},
	["806"] = {
		Level = 806,
		XpToNextLevel = 7596,
		MaxCatchWeight = 806,
	},
	["807"] = {
		Level = 807,
		XpToNextLevel = 7616,
		MaxCatchWeight = 807,
	},
	["808"] = {
		Level = 808,
		XpToNextLevel = 7636,
		MaxCatchWeight = 808,
	},
	["809"] = {
		Level = 809,
		XpToNextLevel = 7656,
		MaxCatchWeight = 809,
	},
	["810"] = {
		Level = 810,
		XpToNextLevel = 7676,
		MaxCatchWeight = 810,
	},
	["811"] = {
		Level = 811,
		XpToNextLevel = 7696,
		MaxCatchWeight = 811,
	},
	["812"] = {
		Level = 812,
		XpToNextLevel = 7716,
		MaxCatchWeight = 812,
	},
	["813"] = {
		Level = 813,
		XpToNextLevel = 7736,
		MaxCatchWeight = 813,
	},
	["814"] = {
		Level = 814,
		XpToNextLevel = 7756,
		MaxCatchWeight = 814,
	},
	["815"] = {
		Level = 815,
		XpToNextLevel = 7776,
		MaxCatchWeight = 815,
	},
	["816"] = {
		Level = 816,
		XpToNextLevel = 7796,
		MaxCatchWeight = 816,
	},
	["817"] = {
		Level = 817,
		XpToNextLevel = 7816,
		MaxCatchWeight = 817,
	},
	["818"] = {
		Level = 818,
		XpToNextLevel = 7836,
		MaxCatchWeight = 818,
	},
	["819"] = {
		Level = 819,
		XpToNextLevel = 7856,
		MaxCatchWeight = 819,
	},
	["820"] = {
		Level = 820,
		XpToNextLevel = 7876,
		MaxCatchWeight = 820,
	},
	["821"] = {
		Level = 821,
		XpToNextLevel = 7897,
		MaxCatchWeight = 821,
	},
	["822"] = {
		Level = 822,
		XpToNextLevel = 7917,
		MaxCatchWeight = 822,
	},
	["823"] = {
		Level = 823,
		XpToNextLevel = 7937,
		MaxCatchWeight = 823,
	},
	["824"] = {
		Level = 824,
		XpToNextLevel = 7957,
		MaxCatchWeight = 824,
	},
	["825"] = {
		Level = 825,
		XpToNextLevel = 7978,
		MaxCatchWeight = 825,
	},
	["826"] = {
		Level = 826,
		XpToNextLevel = 7998,
		MaxCatchWeight = 826,
	},
	["827"] = {
		Level = 827,
		XpToNextLevel = 8018,
		MaxCatchWeight = 827,
	},
	["828"] = {
		Level = 828,
		XpToNextLevel = 8039,
		MaxCatchWeight = 828,
	},
	["829"] = {
		Level = 829,
		XpToNextLevel = 8059,
		MaxCatchWeight = 829,
	},
	["830"] = {
		Level = 830,
		XpToNextLevel = 8080,
		MaxCatchWeight = 830,
	},
	["831"] = {
		Level = 831,
		XpToNextLevel = 8100,
		MaxCatchWeight = 831,
	},
	["832"] = {
		Level = 832,
		XpToNextLevel = 8120,
		MaxCatchWeight = 832,
	},
	["833"] = {
		Level = 833,
		XpToNextLevel = 8141,
		MaxCatchWeight = 833,
	},
	["834"] = {
		Level = 834,
		XpToNextLevel = 8162,
		MaxCatchWeight = 834,
	},
	["835"] = {
		Level = 835,
		XpToNextLevel = 8182,
		MaxCatchWeight = 835,
	},
	["836"] = {
		Level = 836,
		XpToNextLevel = 8203,
		MaxCatchWeight = 836,
	},
	["837"] = {
		Level = 837,
		XpToNextLevel = 8223,
		MaxCatchWeight = 837,
	},
	["838"] = {
		Level = 838,
		XpToNextLevel = 8244,
		MaxCatchWeight = 838,
	},
	["839"] = {
		Level = 839,
		XpToNextLevel = 8265,
		MaxCatchWeight = 839,
	},
	["840"] = {
		Level = 840,
		XpToNextLevel = 8285,
		MaxCatchWeight = 840,
	},
	["841"] = {
		Level = 841,
		XpToNextLevel = 8306,
		MaxCatchWeight = 841,
	},
	["842"] = {
		Level = 842,
		XpToNextLevel = 8327,
		MaxCatchWeight = 842,
	},
	["843"] = {
		Level = 843,
		XpToNextLevel = 8348,
		MaxCatchWeight = 843,
	},
	["844"] = {
		Level = 844,
		XpToNextLevel = 8369,
		MaxCatchWeight = 844,
	},
	["845"] = {
		Level = 845,
		XpToNextLevel = 8389,
		MaxCatchWeight = 845,
	},
	["846"] = {
		Level = 846,
		XpToNextLevel = 8410,
		MaxCatchWeight = 846,
	},
	["847"] = {
		Level = 847,
		XpToNextLevel = 8431,
		MaxCatchWeight = 847,
	},
	["848"] = {
		Level = 848,
		XpToNextLevel = 8452,
		MaxCatchWeight = 848,
	},
	["849"] = {
		Level = 849,
		XpToNextLevel = 8473,
		MaxCatchWeight = 849,
	},
	["850"] = {
		Level = 850,
		XpToNextLevel = 8494,
		MaxCatchWeight = 850,
	},
	["851"] = {
		Level = 851,
		XpToNextLevel = 8515,
		MaxCatchWeight = 851,
	},
	["852"] = {
		Level = 852,
		XpToNextLevel = 8536,
		MaxCatchWeight = 852,
	},
	["853"] = {
		Level = 853,
		XpToNextLevel = 8557,
		MaxCatchWeight = 853,
	},
	["854"] = {
		Level = 854,
		XpToNextLevel = 8578,
		MaxCatchWeight = 854,
	},
	["855"] = {
		Level = 855,
		XpToNextLevel = 8599,
		MaxCatchWeight = 855,
	},
	["856"] = {
		Level = 856,
		XpToNextLevel = 8620,
		MaxCatchWeight = 856,
	},
	["857"] = {
		Level = 857,
		XpToNextLevel = 8642,
		MaxCatchWeight = 857,
	},
	["858"] = {
		Level = 858,
		XpToNextLevel = 8663,
		MaxCatchWeight = 858,
	},
	["859"] = {
		Level = 859,
		XpToNextLevel = 8684,
		MaxCatchWeight = 859,
	},
	["860"] = {
		Level = 860,
		XpToNextLevel = 8705,
		MaxCatchWeight = 860,
	},
	["861"] = {
		Level = 861,
		XpToNextLevel = 8727,
		MaxCatchWeight = 861,
	},
	["862"] = {
		Level = 862,
		XpToNextLevel = 8748,
		MaxCatchWeight = 862,
	},
	["863"] = {
		Level = 863,
		XpToNextLevel = 8769,
		MaxCatchWeight = 863,
	},
	["864"] = {
		Level = 864,
		XpToNextLevel = 8791,
		MaxCatchWeight = 864,
	},
	["865"] = {
		Level = 865,
		XpToNextLevel = 8812,
		MaxCatchWeight = 865,
	},
	["866"] = {
		Level = 866,
		XpToNextLevel = 8833,
		MaxCatchWeight = 866,
	},
	["867"] = {
		Level = 867,
		XpToNextLevel = 8855,
		MaxCatchWeight = 867,
	},
	["868"] = {
		Level = 868,
		XpToNextLevel = 8876,
		MaxCatchWeight = 868,
	},
	["869"] = {
		Level = 869,
		XpToNextLevel = 8898,
		MaxCatchWeight = 869,
	},
	["870"] = {
		Level = 870,
		XpToNextLevel = 8919,
		MaxCatchWeight = 870,
	},
	["871"] = {
		Level = 871,
		XpToNextLevel = 8941,
		MaxCatchWeight = 871,
	},
	["872"] = {
		Level = 872,
		XpToNextLevel = 8963,
		MaxCatchWeight = 872,
	},
	["873"] = {
		Level = 873,
		XpToNextLevel = 8984,
		MaxCatchWeight = 873,
	},
	["874"] = {
		Level = 874,
		XpToNextLevel = 9006,
		MaxCatchWeight = 874,
	},
	["875"] = {
		Level = 875,
		XpToNextLevel = 9027,
		MaxCatchWeight = 875,
	},
	["876"] = {
		Level = 876,
		XpToNextLevel = 9049,
		MaxCatchWeight = 876,
	},
	["877"] = {
		Level = 877,
		XpToNextLevel = 9071,
		MaxCatchWeight = 877,
	},
	["878"] = {
		Level = 878,
		XpToNextLevel = 9093,
		MaxCatchWeight = 878,
	},
	["879"] = {
		Level = 879,
		XpToNextLevel = 9114,
		MaxCatchWeight = 879,
	},
	["880"] = {
		Level = 880,
		XpToNextLevel = 9136,
		MaxCatchWeight = 880,
	},
	["881"] = {
		Level = 881,
		XpToNextLevel = 9158,
		MaxCatchWeight = 881,
	},
	["882"] = {
		Level = 882,
		XpToNextLevel = 9180,
		MaxCatchWeight = 882,
	},
	["883"] = {
		Level = 883,
		XpToNextLevel = 9202,
		MaxCatchWeight = 883,
	},
	["884"] = {
		Level = 884,
		XpToNextLevel = 9224,
		MaxCatchWeight = 884,
	},
	["885"] = {
		Level = 885,
		XpToNextLevel = 9246,
		MaxCatchWeight = 885,
	},
	["886"] = {
		Level = 886,
		XpToNextLevel = 9268,
		MaxCatchWeight = 886,
	},
	["887"] = {
		Level = 887,
		XpToNextLevel = 9290,
		MaxCatchWeight = 887,
	},
	["888"] = {
		Level = 888,
		XpToNextLevel = 9312,
		MaxCatchWeight = 888,
	},
	["889"] = {
		Level = 889,
		XpToNextLevel = 9334,
		MaxCatchWeight = 889,
	},
	["890"] = {
		Level = 890,
		XpToNextLevel = 9356,
		MaxCatchWeight = 890,
	},
	["891"] = {
		Level = 891,
		XpToNextLevel = 9378,
		MaxCatchWeight = 891,
	},
	["892"] = {
		Level = 892,
		XpToNextLevel = 9400,
		MaxCatchWeight = 892,
	},
	["893"] = {
		Level = 893,
		XpToNextLevel = 9422,
		MaxCatchWeight = 893,
	},
	["894"] = {
		Level = 894,
		XpToNextLevel = 9444,
		MaxCatchWeight = 894,
	},
	["895"] = {
		Level = 895,
		XpToNextLevel = 9467,
		MaxCatchWeight = 895,
	},
	["896"] = {
		Level = 896,
		XpToNextLevel = 9489,
		MaxCatchWeight = 896,
	},
	["897"] = {
		Level = 897,
		XpToNextLevel = 9511,
		MaxCatchWeight = 897,
	},
	["898"] = {
		Level = 898,
		XpToNextLevel = 9533,
		MaxCatchWeight = 898,
	},
	["899"] = {
		Level = 899,
		XpToNextLevel = 9556,
		MaxCatchWeight = 899,
	},
	["900"] = {
		Level = 900,
		XpToNextLevel = 9578,
		MaxCatchWeight = 900,
	},
	["901"] = {
		Level = 901,
		XpToNextLevel = 9600,
		MaxCatchWeight = 901,
	},
	["902"] = {
		Level = 902,
		XpToNextLevel = 9623,
		MaxCatchWeight = 902,
	},
	["903"] = {
		Level = 903,
		XpToNextLevel = 9645,
		MaxCatchWeight = 903,
	},
	["904"] = {
		Level = 904,
		XpToNextLevel = 9668,
		MaxCatchWeight = 904,
	},
	["905"] = {
		Level = 905,
		XpToNextLevel = 9690,
		MaxCatchWeight = 905,
	},
	["906"] = {
		Level = 906,
		XpToNextLevel = 9713,
		MaxCatchWeight = 906,
	},
	["907"] = {
		Level = 907,
		XpToNextLevel = 9735,
		MaxCatchWeight = 907,
	},
	["908"] = {
		Level = 908,
		XpToNextLevel = 9758,
		MaxCatchWeight = 908,
	},
	["909"] = {
		Level = 909,
		XpToNextLevel = 9780,
		MaxCatchWeight = 909,
	},
	["910"] = {
		Level = 910,
		XpToNextLevel = 9803,
		MaxCatchWeight = 910,
	},
	["911"] = {
		Level = 911,
		XpToNextLevel = 9826,
		MaxCatchWeight = 911,
	},
	["912"] = {
		Level = 912,
		XpToNextLevel = 9848,
		MaxCatchWeight = 912,
	},
	["913"] = {
		Level = 913,
		XpToNextLevel = 9871,
		MaxCatchWeight = 913,
	},
	["914"] = {
		Level = 914,
		XpToNextLevel = 9894,
		MaxCatchWeight = 914,
	},
	["915"] = {
		Level = 915,
		XpToNextLevel = 9916,
		MaxCatchWeight = 915,
	},
	["916"] = {
		Level = 916,
		XpToNextLevel = 9939,
		MaxCatchWeight = 916,
	},
	["917"] = {
		Level = 917,
		XpToNextLevel = 9962,
		MaxCatchWeight = 917,
	},
	["918"] = {
		Level = 918,
		XpToNextLevel = 9985,
		MaxCatchWeight = 918,
	},
	["919"] = {
		Level = 919,
		XpToNextLevel = 10008,
		MaxCatchWeight = 919,
	},
	["920"] = {
		Level = 920,
		XpToNextLevel = 10031,
		MaxCatchWeight = 920,
	},
	["921"] = {
		Level = 921,
		XpToNextLevel = 10054,
		MaxCatchWeight = 921,
	},
	["922"] = {
		Level = 922,
		XpToNextLevel = 10077,
		MaxCatchWeight = 922,
	},
	["923"] = {
		Level = 923,
		XpToNextLevel = 10100,
		MaxCatchWeight = 923,
	},
	["924"] = {
		Level = 924,
		XpToNextLevel = 10123,
		MaxCatchWeight = 924,
	},
	["925"] = {
		Level = 925,
		XpToNextLevel = 10146,
		MaxCatchWeight = 925,
	},
	["926"] = {
		Level = 926,
		XpToNextLevel = 10169,
		MaxCatchWeight = 926,
	},
	["927"] = {
		Level = 927,
		XpToNextLevel = 10192,
		MaxCatchWeight = 927,
	},
	["928"] = {
		Level = 928,
		XpToNextLevel = 10215,
		MaxCatchWeight = 928,
	},
	["929"] = {
		Level = 929,
		XpToNextLevel = 10238,
		MaxCatchWeight = 929,
	},
	["930"] = {
		Level = 930,
		XpToNextLevel = 10261,
		MaxCatchWeight = 930,
	},
	["931"] = {
		Level = 931,
		XpToNextLevel = 10284,
		MaxCatchWeight = 931,
	},
	["932"] = {
		Level = 932,
		XpToNextLevel = 10308,
		MaxCatchWeight = 932,
	},
	["933"] = {
		Level = 933,
		XpToNextLevel = 10331,
		MaxCatchWeight = 933,
	},
	["934"] = {
		Level = 934,
		XpToNextLevel = 10354,
		MaxCatchWeight = 934,
	},
	["935"] = {
		Level = 935,
		XpToNextLevel = 10377,
		MaxCatchWeight = 935,
	},
	["936"] = {
		Level = 936,
		XpToNextLevel = 10401,
		MaxCatchWeight = 936,
	},
	["937"] = {
		Level = 937,
		XpToNextLevel = 10424,
		MaxCatchWeight = 937,
	},
	["938"] = {
		Level = 938,
		XpToNextLevel = 10447,
		MaxCatchWeight = 938,
	},
	["939"] = {
		Level = 939,
		XpToNextLevel = 10471,
		MaxCatchWeight = 939,
	},
	["940"] = {
		Level = 940,
		XpToNextLevel = 10494,
		MaxCatchWeight = 940,
	},
	["941"] = {
		Level = 941,
		XpToNextLevel = 10518,
		MaxCatchWeight = 941,
	},
	["942"] = {
		Level = 942,
		XpToNextLevel = 10541,
		MaxCatchWeight = 942,
	},
	["943"] = {
		Level = 943,
		XpToNextLevel = 10565,
		MaxCatchWeight = 943,
	},
	["944"] = {
		Level = 944,
		XpToNextLevel = 10588,
		MaxCatchWeight = 944,
	},
	["945"] = {
		Level = 945,
		XpToNextLevel = 10612,
		MaxCatchWeight = 945,
	},
	["946"] = {
		Level = 946,
		XpToNextLevel = 10636,
		MaxCatchWeight = 946,
	},
	["947"] = {
		Level = 947,
		XpToNextLevel = 10659,
		MaxCatchWeight = 947,
	},
	["948"] = {
		Level = 948,
		XpToNextLevel = 10683,
		MaxCatchWeight = 948,
	},
	["949"] = {
		Level = 949,
		XpToNextLevel = 10707,
		MaxCatchWeight = 949,
	},
	["950"] = {
		Level = 950,
		XpToNextLevel = 10730,
		MaxCatchWeight = 950,
	},
	["951"] = {
		Level = 951,
		XpToNextLevel = 10754,
		MaxCatchWeight = 951,
	},
	["952"] = {
		Level = 952,
		XpToNextLevel = 10778,
		MaxCatchWeight = 952,
	},
	["953"] = {
		Level = 953,
		XpToNextLevel = 10802,
		MaxCatchWeight = 953,
	},
	["954"] = {
		Level = 954,
		XpToNextLevel = 10825,
		MaxCatchWeight = 954,
	},
	["955"] = {
		Level = 955,
		XpToNextLevel = 10849,
		MaxCatchWeight = 955,
	},
	["956"] = {
		Level = 956,
		XpToNextLevel = 10873,
		MaxCatchWeight = 956,
	},
	["957"] = {
		Level = 957,
		XpToNextLevel = 10897,
		MaxCatchWeight = 957,
	},
	["958"] = {
		Level = 958,
		XpToNextLevel = 10921,
		MaxCatchWeight = 958,
	},
	["959"] = {
		Level = 959,
		XpToNextLevel = 10945,
		MaxCatchWeight = 959,
	},
	["960"] = {
		Level = 960,
		XpToNextLevel = 10969,
		MaxCatchWeight = 960,
	},
	["961"] = {
		Level = 961,
		XpToNextLevel = 10993,
		MaxCatchWeight = 961,
	},
	["962"] = {
		Level = 962,
		XpToNextLevel = 11017,
		MaxCatchWeight = 962,
	},
	["963"] = {
		Level = 963,
		XpToNextLevel = 11041,
		MaxCatchWeight = 963,
	},
	["964"] = {
		Level = 964,
		XpToNextLevel = 11065,
		MaxCatchWeight = 964,
	},
	["965"] = {
		Level = 965,
		XpToNextLevel = 11089,
		MaxCatchWeight = 965,
	},
	["966"] = {
		Level = 966,
		XpToNextLevel = 11114,
		MaxCatchWeight = 966,
	},
	["967"] = {
		Level = 967,
		XpToNextLevel = 11138,
		MaxCatchWeight = 967,
	},
	["968"] = {
		Level = 968,
		XpToNextLevel = 11162,
		MaxCatchWeight = 968,
	},
	["969"] = {
		Level = 969,
		XpToNextLevel = 11186,
		MaxCatchWeight = 969,
	},
	["970"] = {
		Level = 970,
		XpToNextLevel = 11210,
		MaxCatchWeight = 970,
	},
	["971"] = {
		Level = 971,
		XpToNextLevel = 11235,
		MaxCatchWeight = 971,
	},
	["972"] = {
		Level = 972,
		XpToNextLevel = 11259,
		MaxCatchWeight = 972,
	},
	["973"] = {
		Level = 973,
		XpToNextLevel = 11283,
		MaxCatchWeight = 973,
	},
	["974"] = {
		Level = 974,
		XpToNextLevel = 11308,
		MaxCatchWeight = 974,
	},
	["975"] = {
		Level = 975,
		XpToNextLevel = 11332,
		MaxCatchWeight = 975,
	},
	["976"] = {
		Level = 976,
		XpToNextLevel = 11357,
		MaxCatchWeight = 976,
	},
	["977"] = {
		Level = 977,
		XpToNextLevel = 11381,
		MaxCatchWeight = 977,
	},
	["978"] = {
		Level = 978,
		XpToNextLevel = 11406,
		MaxCatchWeight = 978,
	},
	["979"] = {
		Level = 979,
		XpToNextLevel = 11430,
		MaxCatchWeight = 979,
	},
	["980"] = {
		Level = 980,
		XpToNextLevel = 11455,
		MaxCatchWeight = 980,
	},
	["981"] = {
		Level = 981,
		XpToNextLevel = 11479,
		MaxCatchWeight = 981,
	},
	["982"] = {
		Level = 982,
		XpToNextLevel = 11504,
		MaxCatchWeight = 982,
	},
	["983"] = {
		Level = 983,
		XpToNextLevel = 11529,
		MaxCatchWeight = 983,
	},
	["984"] = {
		Level = 984,
		XpToNextLevel = 11553,
		MaxCatchWeight = 984,
	},
	["985"] = {
		Level = 985,
		XpToNextLevel = 11578,
		MaxCatchWeight = 985,
	},
	["986"] = {
		Level = 986,
		XpToNextLevel = 11603,
		MaxCatchWeight = 986,
	},
	["987"] = {
		Level = 987,
		XpToNextLevel = 11627,
		MaxCatchWeight = 987,
	},
	["988"] = {
		Level = 988,
		XpToNextLevel = 11652,
		MaxCatchWeight = 988,
	},
	["989"] = {
		Level = 989,
		XpToNextLevel = 11677,
		MaxCatchWeight = 989,
	},
	["990"] = {
		Level = 990,
		XpToNextLevel = 11702,
		MaxCatchWeight = 990,
	},
	["991"] = {
		Level = 991,
		XpToNextLevel = 11727,
		MaxCatchWeight = 991,
	},
	["992"] = {
		Level = 992,
		XpToNextLevel = 11751,
		MaxCatchWeight = 992,
	},
	["993"] = {
		Level = 993,
		XpToNextLevel = 11776,
		MaxCatchWeight = 993,
	},
	["994"] = {
		Level = 994,
		XpToNextLevel = 11801,
		MaxCatchWeight = 994,
	},
	["995"] = {
		Level = 995,
		XpToNextLevel = 11826,
		MaxCatchWeight = 995,
	},
	["996"] = {
		Level = 996,
		XpToNextLevel = 11851,
		MaxCatchWeight = 996,
	},
	["997"] = {
		Level = 997,
		XpToNextLevel = 11876,
		MaxCatchWeight = 997,
	},
	["998"] = {
		Level = 998,
		XpToNextLevel = 11901,
		MaxCatchWeight = 998,
	},
	["999"] = {
		Level = 999,
		XpToNextLevel = 11926,
		MaxCatchWeight = 999,
	},
	["1,000"] = {
		Level = 1000,
		XpToNextLevel = 11951,
		MaxCatchWeight = 1000,
	},
	["1,001"] = {
		Level = 1001,
		XpToNextLevel = 11977,
		MaxCatchWeight = 1001,
	},
	["1,002"] = {
		Level = 1002,
		XpToNextLevel = 12002,
		MaxCatchWeight = 1002,
	},
	["1,003"] = {
		Level = 1003,
		XpToNextLevel = 12027,
		MaxCatchWeight = 1003,
	},
	["1,004"] = {
		Level = 1004,
		XpToNextLevel = 12052,
		MaxCatchWeight = 1004,
	},
	["1,005"] = {
		Level = 1005,
		XpToNextLevel = 12077,
		MaxCatchWeight = 1005,
	},
	["1,006"] = {
		Level = 1006,
		XpToNextLevel = 12103,
		MaxCatchWeight = 1006,
	},
	["1,007"] = {
		Level = 1007,
		XpToNextLevel = 12128,
		MaxCatchWeight = 1007,
	},
	["1,008"] = {
		Level = 1008,
		XpToNextLevel = 12153,
		MaxCatchWeight = 1008,
	},
	["1,009"] = {
		Level = 1009,
		XpToNextLevel = 12179,
		MaxCatchWeight = 1009,
	},
	["1,010"] = {
		Level = 1010,
		XpToNextLevel = 12204,
		MaxCatchWeight = 1010,
	},
	["1,011"] = {
		Level = 1011,
		XpToNextLevel = 12229,
		MaxCatchWeight = 1011,
	},
	["1,012"] = {
		Level = 1012,
		XpToNextLevel = 12255,
		MaxCatchWeight = 1012,
	},
	["1,013"] = {
		Level = 1013,
		XpToNextLevel = 12280,
		MaxCatchWeight = 1013,
	},
	["1,014"] = {
		Level = 1014,
		XpToNextLevel = 12306,
		MaxCatchWeight = 1014,
	},
	["1,015"] = {
		Level = 1015,
		XpToNextLevel = 12331,
		MaxCatchWeight = 1015,
	},
	["1,016"] = {
		Level = 1016,
		XpToNextLevel = 12357,
		MaxCatchWeight = 1016,
	},
	["1,017"] = {
		Level = 1017,
		XpToNextLevel = 12382,
		MaxCatchWeight = 1017,
	},
	["1,018"] = {
		Level = 1018,
		XpToNextLevel = 12408,
		MaxCatchWeight = 1018,
	},
	["1,019"] = {
		Level = 1019,
		XpToNextLevel = 12434,
		MaxCatchWeight = 1019,
	},
	["1,020"] = {
		Level = 1020,
		XpToNextLevel = 12459,
		MaxCatchWeight = 1020,
	},
	["1,021"] = {
		Level = 1021,
		XpToNextLevel = 12485,
		MaxCatchWeight = 1021,
	},
	["1,022"] = {
		Level = 1022,
		XpToNextLevel = 12511,
		MaxCatchWeight = 1022,
	},
	["1,023"] = {
		Level = 1023,
		XpToNextLevel = 12536,
		MaxCatchWeight = 1023,
	},
	["1,024"] = {
		Level = 1024,
		XpToNextLevel = 12562,
		MaxCatchWeight = 1024,
	},
	["1,025"] = {
		Level = 1025,
		XpToNextLevel = 12588,
		MaxCatchWeight = 1025,
	},
	["1,026"] = {
		Level = 1026,
		XpToNextLevel = 12614,
		MaxCatchWeight = 1026,
	},
	["1,027"] = {
		Level = 1027,
		XpToNextLevel = 12640,
		MaxCatchWeight = 1027,
	},
	["1,028"] = {
		Level = 1028,
		XpToNextLevel = 12665,
		MaxCatchWeight = 1028,
	},
	["1,029"] = {
		Level = 1029,
		XpToNextLevel = 12691,
		MaxCatchWeight = 1029,
	},
	["1,030"] = {
		Level = 1030,
		XpToNextLevel = 12717,
		MaxCatchWeight = 1030,
	},
	["1,031"] = {
		Level = 1031,
		XpToNextLevel = 12743,
		MaxCatchWeight = 1031,
	},
	["1,032"] = {
		Level = 1032,
		XpToNextLevel = 12769,
		MaxCatchWeight = 1032,
	},
	["1,033"] = {
		Level = 1033,
		XpToNextLevel = 12795,
		MaxCatchWeight = 1033,
	},
	["1,034"] = {
		Level = 1034,
		XpToNextLevel = 12821,
		MaxCatchWeight = 1034,
	},
	["1,035"] = {
		Level = 1035,
		XpToNextLevel = 12847,
		MaxCatchWeight = 1035,
	},
	["1,036"] = {
		Level = 1036,
		XpToNextLevel = 12873,
		MaxCatchWeight = 1036,
	},
	["1,037"] = {
		Level = 1037,
		XpToNextLevel = 12900,
		MaxCatchWeight = 1037,
	},
	["1,038"] = {
		Level = 1038,
		XpToNextLevel = 12926,
		MaxCatchWeight = 1038,
	},
	["1,039"] = {
		Level = 1039,
		XpToNextLevel = 12952,
		MaxCatchWeight = 1039,
	},
	["1,040"] = {
		Level = 1040,
		XpToNextLevel = 12978,
		MaxCatchWeight = 1040,
	},
	["1,041"] = {
		Level = 1041,
		XpToNextLevel = 13004,
		MaxCatchWeight = 1041,
	},
	["1,042"] = {
		Level = 1042,
		XpToNextLevel = 13031,
		MaxCatchWeight = 1042,
	},
	["1,043"] = {
		Level = 1043,
		XpToNextLevel = 13057,
		MaxCatchWeight = 1043,
	},
	["1,044"] = {
		Level = 1044,
		XpToNextLevel = 13083,
		MaxCatchWeight = 1044,
	},
	["1,045"] = {
		Level = 1045,
		XpToNextLevel = 13110,
		MaxCatchWeight = 1045,
	},
	["1,046"] = {
		Level = 1046,
		XpToNextLevel = 13136,
		MaxCatchWeight = 1046,
	},
	["1,047"] = {
		Level = 1047,
		XpToNextLevel = 13162,
		MaxCatchWeight = 1047,
	},
	["1,048"] = {
		Level = 1048,
		XpToNextLevel = 13189,
		MaxCatchWeight = 1048,
	},
	["1,049"] = {
		Level = 1049,
		XpToNextLevel = 13215,
		MaxCatchWeight = 1049,
	},
	["1,050"] = {
		Level = 1050,
		XpToNextLevel = 13242,
		MaxCatchWeight = 1050,
	},
	["1,051"] = {
		Level = 1051,
		XpToNextLevel = 13268,
		MaxCatchWeight = 1051,
	},
	["1,052"] = {
		Level = 1052,
		XpToNextLevel = 13295,
		MaxCatchWeight = 1052,
	},
	["1,053"] = {
		Level = 1053,
		XpToNextLevel = 13321,
		MaxCatchWeight = 1053,
	},
	["1,054"] = {
		Level = 1054,
		XpToNextLevel = 13348,
		MaxCatchWeight = 1054,
	},
	["1,055"] = {
		Level = 1055,
		XpToNextLevel = 13375,
		MaxCatchWeight = 1055,
	},
	["1,056"] = {
		Level = 1056,
		XpToNextLevel = 13401,
		MaxCatchWeight = 1056,
	},
	["1,057"] = {
		Level = 1057,
		XpToNextLevel = 13428,
		MaxCatchWeight = 1057,
	},
	["1,058"] = {
		Level = 1058,
		XpToNextLevel = 13455,
		MaxCatchWeight = 1058,
	},
	["1,059"] = {
		Level = 1059,
		XpToNextLevel = 13481,
		MaxCatchWeight = 1059,
	},
	["1,060"] = {
		Level = 1060,
		XpToNextLevel = 13508,
		MaxCatchWeight = 1060,
	},
	["1,061"] = {
		Level = 1061,
		XpToNextLevel = 13535,
		MaxCatchWeight = 1061,
	},
	["1,062"] = {
		Level = 1062,
		XpToNextLevel = 13562,
		MaxCatchWeight = 1062,
	},
	["1,063"] = {
		Level = 1063,
		XpToNextLevel = 13589,
		MaxCatchWeight = 1063,
	},
	["1,064"] = {
		Level = 1064,
		XpToNextLevel = 13615,
		MaxCatchWeight = 1064,
	},
	["1,065"] = {
		Level = 1065,
		XpToNextLevel = 13642,
		MaxCatchWeight = 1065,
	},
	["1,066"] = {
		Level = 1066,
		XpToNextLevel = 13669,
		MaxCatchWeight = 1066,
	},
	["1,067"] = {
		Level = 1067,
		XpToNextLevel = 13696,
		MaxCatchWeight = 1067,
	},
	["1,068"] = {
		Level = 1068,
		XpToNextLevel = 13723,
		MaxCatchWeight = 1068,
	},
	["1,069"] = {
		Level = 1069,
		XpToNextLevel = 13750,
		MaxCatchWeight = 1069,
	},
	["1,070"] = {
		Level = 1070,
		XpToNextLevel = 13777,
		MaxCatchWeight = 1070,
	},
	["1,071"] = {
		Level = 1071,
		XpToNextLevel = 13804,
		MaxCatchWeight = 1071,
	},
	["1,072"] = {
		Level = 1072,
		XpToNextLevel = 13831,
		MaxCatchWeight = 1072,
	},
	["1,073"] = {
		Level = 1073,
		XpToNextLevel = 13859,
		MaxCatchWeight = 1073,
	},
	["1,074"] = {
		Level = 1074,
		XpToNextLevel = 13886,
		MaxCatchWeight = 1074,
	},
	["1,075"] = {
		Level = 1075,
		XpToNextLevel = 13913,
		MaxCatchWeight = 1075,
	},
	["1,076"] = {
		Level = 1076,
		XpToNextLevel = 13940,
		MaxCatchWeight = 1076,
	},
	["1,077"] = {
		Level = 1077,
		XpToNextLevel = 13967,
		MaxCatchWeight = 1077,
	},
	["1,078"] = {
		Level = 1078,
		XpToNextLevel = 13995,
		MaxCatchWeight = 1078,
	},
	["1,079"] = {
		Level = 1079,
		XpToNextLevel = 14022,
		MaxCatchWeight = 1079,
	},
	["1,080"] = {
		Level = 1080,
		XpToNextLevel = 14049,
		MaxCatchWeight = 1080,
	},
	["1,081"] = {
		Level = 1081,
		XpToNextLevel = 14077,
		MaxCatchWeight = 1081,
	},
	["1,082"] = {
		Level = 1082,
		XpToNextLevel = 14104,
		MaxCatchWeight = 1082,
	},
	["1,083"] = {
		Level = 1083,
		XpToNextLevel = 14131,
		MaxCatchWeight = 1083,
	},
	["1,084"] = {
		Level = 1084,
		XpToNextLevel = 14159,
		MaxCatchWeight = 1084,
	},
	["1,085"] = {
		Level = 1085,
		XpToNextLevel = 14186,
		MaxCatchWeight = 1085,
	},
	["1,086"] = {
		Level = 1086,
		XpToNextLevel = 14214,
		MaxCatchWeight = 1086,
	},
	["1,087"] = {
		Level = 1087,
		XpToNextLevel = 14241,
		MaxCatchWeight = 1087,
	},
	["1,088"] = {
		Level = 1088,
		XpToNextLevel = 14269,
		MaxCatchWeight = 1088,
	},
	["1,089"] = {
		Level = 1089,
		XpToNextLevel = 14296,
		MaxCatchWeight = 1089,
	},
	["1,090"] = {
		Level = 1090,
		XpToNextLevel = 14324,
		MaxCatchWeight = 1090,
	},
	["1,091"] = {
		Level = 1091,
		XpToNextLevel = 14352,
		MaxCatchWeight = 1091,
	},
	["1,092"] = {
		Level = 1092,
		XpToNextLevel = 14379,
		MaxCatchWeight = 1092,
	},
	["1,093"] = {
		Level = 1093,
		XpToNextLevel = 14407,
		MaxCatchWeight = 1093,
	},
	["1,094"] = {
		Level = 1094,
		XpToNextLevel = 14435,
		MaxCatchWeight = 1094,
	},
	["1,095"] = {
		Level = 1095,
		XpToNextLevel = 14462,
		MaxCatchWeight = 1095,
	},
	["1,096"] = {
		Level = 1096,
		XpToNextLevel = 14490,
		MaxCatchWeight = 1096,
	},
	["1,097"] = {
		Level = 1097,
		XpToNextLevel = 14518,
		MaxCatchWeight = 1097,
	},
	["1,098"] = {
		Level = 1098,
		XpToNextLevel = 14546,
		MaxCatchWeight = 1098,
	},
	["1,099"] = {
		Level = 1099,
		XpToNextLevel = 14574,
		MaxCatchWeight = 1099,
	},
	["1,100"] = {
		Level = 1100,
		XpToNextLevel = 14601,
		MaxCatchWeight = 1100,
	},
	["1,101"] = {
		Level = 1101,
		XpToNextLevel = 14629,
		MaxCatchWeight = 1101,
	},
	["1,102"] = {
		Level = 1102,
		XpToNextLevel = 14657,
		MaxCatchWeight = 1102,
	},
	["1,103"] = {
		Level = 1103,
		XpToNextLevel = 14685,
		MaxCatchWeight = 1103,
	},
	["1,104"] = {
		Level = 1104,
		XpToNextLevel = 14713,
		MaxCatchWeight = 1104,
	},
	["1,105"] = {
		Level = 1105,
		XpToNextLevel = 14741,
		MaxCatchWeight = 1105,
	},
	["1,106"] = {
		Level = 1106,
		XpToNextLevel = 14769,
		MaxCatchWeight = 1106,
	},
	["1,107"] = {
		Level = 1107,
		XpToNextLevel = 14797,
		MaxCatchWeight = 1107,
	},
	["1,108"] = {
		Level = 1108,
		XpToNextLevel = 14825,
		MaxCatchWeight = 1108,
	},
	["1,109"] = {
		Level = 1109,
		XpToNextLevel = 14854,
		MaxCatchWeight = 1109,
	},
	["1,110"] = {
		Level = 1110,
		XpToNextLevel = 14882,
		MaxCatchWeight = 1110,
	},
	["1,111"] = {
		Level = 1111,
		XpToNextLevel = 14910,
		MaxCatchWeight = 1111,
	},
	["1,112"] = {
		Level = 1112,
		XpToNextLevel = 14938,
		MaxCatchWeight = 1112,
	},
	["1,113"] = {
		Level = 1113,
		XpToNextLevel = 14966,
		MaxCatchWeight = 1113,
	},
	["1,114"] = {
		Level = 1114,
		XpToNextLevel = 14995,
		MaxCatchWeight = 1114,
	},
	["1,115"] = {
		Level = 1115,
		XpToNextLevel = 15023,
		MaxCatchWeight = 1115,
	},
	["1,116"] = {
		Level = 1116,
		XpToNextLevel = 15051,
		MaxCatchWeight = 1116,
	},
	["1,117"] = {
		Level = 1117,
		XpToNextLevel = 15080,
		MaxCatchWeight = 1117,
	},
	["1,118"] = {
		Level = 1118,
		XpToNextLevel = 15108,
		MaxCatchWeight = 1118,
	},
	["1,119"] = {
		Level = 1119,
		XpToNextLevel = 15136,
		MaxCatchWeight = 1119,
	},
	["1,120"] = {
		Level = 1120,
		XpToNextLevel = 15165,
		MaxCatchWeight = 1120,
	},
	["1,121"] = {
		Level = 1121,
		XpToNextLevel = 15193,
		MaxCatchWeight = 1121,
	},
	["1,122"] = {
		Level = 1122,
		XpToNextLevel = 15222,
		MaxCatchWeight = 1122,
	},
	["1,123"] = {
		Level = 1123,
		XpToNextLevel = 15250,
		MaxCatchWeight = 1123,
	},
	["1,124"] = {
		Level = 1124,
		XpToNextLevel = 15279,
		MaxCatchWeight = 1124,
	},
	["1,125"] = {
		Level = 1125,
		XpToNextLevel = 15307,
		MaxCatchWeight = 1125,
	},
	["1,126"] = {
		Level = 1126,
		XpToNextLevel = 15336,
		MaxCatchWeight = 1126,
	},
	["1,127"] = {
		Level = 1127,
		XpToNextLevel = 15365,
		MaxCatchWeight = 1127,
	},
	["1,128"] = {
		Level = 1128,
		XpToNextLevel = 15393,
		MaxCatchWeight = 1128,
	},
	["1,129"] = {
		Level = 1129,
		XpToNextLevel = 15422,
		MaxCatchWeight = 1129,
	},
	["1,130"] = {
		Level = 1130,
		XpToNextLevel = 15451,
		MaxCatchWeight = 1130,
	},
	["1,131"] = {
		Level = 1131,
		XpToNextLevel = 15479,
		MaxCatchWeight = 1131,
	},
	["1,132"] = {
		Level = 1132,
		XpToNextLevel = 15508,
		MaxCatchWeight = 1132,
	},
	["1,133"] = {
		Level = 1133,
		XpToNextLevel = 15537,
		MaxCatchWeight = 1133,
	},
	["1,134"] = {
		Level = 1134,
		XpToNextLevel = 15566,
		MaxCatchWeight = 1134,
	},
	["1,135"] = {
		Level = 1135,
		XpToNextLevel = 15595,
		MaxCatchWeight = 1135,
	},
	["1,136"] = {
		Level = 1136,
		XpToNextLevel = 15624,
		MaxCatchWeight = 1136,
	},
	["1,137"] = {
		Level = 1137,
		XpToNextLevel = 15653,
		MaxCatchWeight = 1137,
	},
	["1,138"] = {
		Level = 1138,
		XpToNextLevel = 15681,
		MaxCatchWeight = 1138,
	},
	["1,139"] = {
		Level = 1139,
		XpToNextLevel = 15710,
		MaxCatchWeight = 1139,
	},
	["1,140"] = {
		Level = 1140,
		XpToNextLevel = 15739,
		MaxCatchWeight = 1140,
	},
	["1,141"] = {
		Level = 1141,
		XpToNextLevel = 15768,
		MaxCatchWeight = 1141,
	},
	["1,142"] = {
		Level = 1142,
		XpToNextLevel = 15798,
		MaxCatchWeight = 1142,
	},
	["1,143"] = {
		Level = 1143,
		XpToNextLevel = 15827,
		MaxCatchWeight = 1143,
	},
	["1,144"] = {
		Level = 1144,
		XpToNextLevel = 15856,
		MaxCatchWeight = 1144,
	},
	["1,145"] = {
		Level = 1145,
		XpToNextLevel = 15885,
		MaxCatchWeight = 1145,
	},
	["1,146"] = {
		Level = 1146,
		XpToNextLevel = 15914,
		MaxCatchWeight = 1146,
	},
	["1,147"] = {
		Level = 1147,
		XpToNextLevel = 15943,
		MaxCatchWeight = 1147,
	},
	["1,148"] = {
		Level = 1148,
		XpToNextLevel = 15972,
		MaxCatchWeight = 1148,
	},
	["1,149"] = {
		Level = 1149,
		XpToNextLevel = 16002,
		MaxCatchWeight = 1149,
	},
	["1,150"] = {
		Level = 1150,
		XpToNextLevel = 16031,
		MaxCatchWeight = 1150,
	},
	["1,151"] = {
		Level = 1151,
		XpToNextLevel = 16060,
		MaxCatchWeight = 1151,
	},
	["1,152"] = {
		Level = 1152,
		XpToNextLevel = 16090,
		MaxCatchWeight = 1152,
	},
	["1,153"] = {
		Level = 1153,
		XpToNextLevel = 16119,
		MaxCatchWeight = 1153,
	},
	["1,154"] = {
		Level = 1154,
		XpToNextLevel = 16148,
		MaxCatchWeight = 1154,
	},
	["1,155"] = {
		Level = 1155,
		XpToNextLevel = 16178,
		MaxCatchWeight = 1155,
	},
	["1,156"] = {
		Level = 1156,
		XpToNextLevel = 16207,
		MaxCatchWeight = 1156,
	},
	["1,157"] = {
		Level = 1157,
		XpToNextLevel = 16237,
		MaxCatchWeight = 1157,
	},
	["1,158"] = {
		Level = 1158,
		XpToNextLevel = 16266,
		MaxCatchWeight = 1158,
	},
	["1,159"] = {
		Level = 1159,
		XpToNextLevel = 16296,
		MaxCatchWeight = 1159,
	},
	["1,160"] = {
		Level = 1160,
		XpToNextLevel = 16325,
		MaxCatchWeight = 1160,
	},
	["1,161"] = {
		Level = 1161,
		XpToNextLevel = 16355,
		MaxCatchWeight = 1161,
	},
	["1,162"] = {
		Level = 1162,
		XpToNextLevel = 16384,
		MaxCatchWeight = 1162,
	},
	["1,163"] = {
		Level = 1163,
		XpToNextLevel = 16414,
		MaxCatchWeight = 1163,
	},
	["1,164"] = {
		Level = 1164,
		XpToNextLevel = 16444,
		MaxCatchWeight = 1164,
	},
	["1,165"] = {
		Level = 1165,
		XpToNextLevel = 16473,
		MaxCatchWeight = 1165,
	},
	["1,166"] = {
		Level = 1166,
		XpToNextLevel = 16503,
		MaxCatchWeight = 1166,
	},
	["1,167"] = {
		Level = 1167,
		XpToNextLevel = 16533,
		MaxCatchWeight = 1167,
	},
	["1,168"] = {
		Level = 1168,
		XpToNextLevel = 16563,
		MaxCatchWeight = 1168,
	},
	["1,169"] = {
		Level = 1169,
		XpToNextLevel = 16593,
		MaxCatchWeight = 1169,
	},
	["1,170"] = {
		Level = 1170,
		XpToNextLevel = 16622,
		MaxCatchWeight = 1170,
	},
	["1,171"] = {
		Level = 1171,
		XpToNextLevel = 16652,
		MaxCatchWeight = 1171,
	},
	["1,172"] = {
		Level = 1172,
		XpToNextLevel = 16682,
		MaxCatchWeight = 1172,
	},
	["1,173"] = {
		Level = 1173,
		XpToNextLevel = 16712,
		MaxCatchWeight = 1173,
	},
	["1,174"] = {
		Level = 1174,
		XpToNextLevel = 16742,
		MaxCatchWeight = 1174,
	},
	["1,175"] = {
		Level = 1175,
		XpToNextLevel = 16772,
		MaxCatchWeight = 1175,
	},
	["1,176"] = {
		Level = 1176,
		XpToNextLevel = 16802,
		MaxCatchWeight = 1176,
	},
	["1,177"] = {
		Level = 1177,
		XpToNextLevel = 16832,
		MaxCatchWeight = 1177,
	},
	["1,178"] = {
		Level = 1178,
		XpToNextLevel = 16862,
		MaxCatchWeight = 1178,
	},
	["1,179"] = {
		Level = 1179,
		XpToNextLevel = 16892,
		MaxCatchWeight = 1179,
	},
	["1,180"] = {
		Level = 1180,
		XpToNextLevel = 16922,
		MaxCatchWeight = 1180,
	},
	["1,181"] = {
		Level = 1181,
		XpToNextLevel = 16952,
		MaxCatchWeight = 1181,
	},
	["1,182"] = {
		Level = 1182,
		XpToNextLevel = 16983,
		MaxCatchWeight = 1182,
	},
	["1,183"] = {
		Level = 1183,
		XpToNextLevel = 17013,
		MaxCatchWeight = 1183,
	},
	["1,184"] = {
		Level = 1184,
		XpToNextLevel = 17043,
		MaxCatchWeight = 1184,
	},
	["1,185"] = {
		Level = 1185,
		XpToNextLevel = 17073,
		MaxCatchWeight = 1185,
	},
	["1,186"] = {
		Level = 1186,
		XpToNextLevel = 17104,
		MaxCatchWeight = 1186,
	},
	["1,187"] = {
		Level = 1187,
		XpToNextLevel = 17134,
		MaxCatchWeight = 1187,
	},
	["1,188"] = {
		Level = 1188,
		XpToNextLevel = 17164,
		MaxCatchWeight = 1188,
	},
	["1,189"] = {
		Level = 1189,
		XpToNextLevel = 17195,
		MaxCatchWeight = 1189,
	},
	["1,190"] = {
		Level = 1190,
		XpToNextLevel = 17225,
		MaxCatchWeight = 1190,
	},
	["1,191"] = {
		Level = 1191,
		XpToNextLevel = 17255,
		MaxCatchWeight = 1191,
	},
	["1,192"] = {
		Level = 1192,
		XpToNextLevel = 17286,
		MaxCatchWeight = 1192,
	},
	["1,193"] = {
		Level = 1193,
		XpToNextLevel = 17316,
		MaxCatchWeight = 1193,
	},
	["1,194"] = {
		Level = 1194,
		XpToNextLevel = 17347,
		MaxCatchWeight = 1194,
	},
	["1,195"] = {
		Level = 1195,
		XpToNextLevel = 17377,
		MaxCatchWeight = 1195,
	},
	["1,196"] = {
		Level = 1196,
		XpToNextLevel = 17408,
		MaxCatchWeight = 1196,
	},
	["1,197"] = {
		Level = 1197,
		XpToNextLevel = 17439,
		MaxCatchWeight = 1197,
	},
	["1,198"] = {
		Level = 1198,
		XpToNextLevel = 17469,
		MaxCatchWeight = 1198,
	},
	["1,199"] = {
		Level = 1199,
		XpToNextLevel = 17500,
		MaxCatchWeight = 1199,
	},
	["1,200"] = {
		Level = 1200,
		XpToNextLevel = 17531,
		MaxCatchWeight = 1200,
	},
	["1,201"] = {
		Level = 1201,
		XpToNextLevel = 17561,
		MaxCatchWeight = 1201,
	},
	["1,202"] = {
		Level = 1202,
		XpToNextLevel = 17592,
		MaxCatchWeight = 1202,
	},
	["1,203"] = {
		Level = 1203,
		XpToNextLevel = 17623,
		MaxCatchWeight = 1203,
	},
	["1,204"] = {
		Level = 1204,
		XpToNextLevel = 17654,
		MaxCatchWeight = 1204,
	},
	["1,205"] = {
		Level = 1205,
		XpToNextLevel = 17684,
		MaxCatchWeight = 1205,
	},
	["1,206"] = {
		Level = 1206,
		XpToNextLevel = 17715,
		MaxCatchWeight = 1206,
	},
	["1,207"] = {
		Level = 1207,
		XpToNextLevel = 17746,
		MaxCatchWeight = 1207,
	},
	["1,208"] = {
		Level = 1208,
		XpToNextLevel = 17777,
		MaxCatchWeight = 1208,
	},
	["1,209"] = {
		Level = 1209,
		XpToNextLevel = 17808,
		MaxCatchWeight = 1209,
	},
	["1,210"] = {
		Level = 1210,
		XpToNextLevel = 17839,
		MaxCatchWeight = 1210,
	},
	["1,211"] = {
		Level = 1211,
		XpToNextLevel = 17870,
		MaxCatchWeight = 1211,
	},
	["1,212"] = {
		Level = 1212,
		XpToNextLevel = 17901,
		MaxCatchWeight = 1212,
	},
	["1,213"] = {
		Level = 1213,
		XpToNextLevel = 17932,
		MaxCatchWeight = 1213,
	},
	["1,214"] = {
		Level = 1214,
		XpToNextLevel = 17963,
		MaxCatchWeight = 1214,
	},
	["1,215"] = {
		Level = 1215,
		XpToNextLevel = 17994,
		MaxCatchWeight = 1215,
	},
	["1,216"] = {
		Level = 1216,
		XpToNextLevel = 18025,
		MaxCatchWeight = 1216,
	},
	["1,217"] = {
		Level = 1217,
		XpToNextLevel = 18056,
		MaxCatchWeight = 1217,
	},
	["1,218"] = {
		Level = 1218,
		XpToNextLevel = 18088,
		MaxCatchWeight = 1218,
	},
	["1,219"] = {
		Level = 1219,
		XpToNextLevel = 18119,
		MaxCatchWeight = 1219,
	},
	["1,220"] = {
		Level = 1220,
		XpToNextLevel = 18150,
		MaxCatchWeight = 1220,
	},
	["1,221"] = {
		Level = 1221,
		XpToNextLevel = 18181,
		MaxCatchWeight = 1221,
	},
	["1,222"] = {
		Level = 1222,
		XpToNextLevel = 18213,
		MaxCatchWeight = 1222,
	},
	["1,223"] = {
		Level = 1223,
		XpToNextLevel = 18244,
		MaxCatchWeight = 1223,
	},
	["1,224"] = {
		Level = 1224,
		XpToNextLevel = 18275,
		MaxCatchWeight = 1224,
	},
	["1,225"] = {
		Level = 1225,
		XpToNextLevel = 18307,
		MaxCatchWeight = 1225,
	},
	["1,226"] = {
		Level = 1226,
		XpToNextLevel = 18338,
		MaxCatchWeight = 1226,
	},
	["1,227"] = {
		Level = 1227,
		XpToNextLevel = 18370,
		MaxCatchWeight = 1227,
	},
	["1,228"] = {
		Level = 1228,
		XpToNextLevel = 18401,
		MaxCatchWeight = 1228,
	},
	["1,229"] = {
		Level = 1229,
		XpToNextLevel = 18433,
		MaxCatchWeight = 1229,
	},
	["1,230"] = {
		Level = 1230,
		XpToNextLevel = 18464,
		MaxCatchWeight = 1230,
	},
	["1,231"] = {
		Level = 1231,
		XpToNextLevel = 18496,
		MaxCatchWeight = 1231,
	},
	["1,232"] = {
		Level = 1232,
		XpToNextLevel = 18527,
		MaxCatchWeight = 1232,
	},
	["1,233"] = {
		Level = 1233,
		XpToNextLevel = 18559,
		MaxCatchWeight = 1233,
	},
	["1,234"] = {
		Level = 1234,
		XpToNextLevel = 18590,
		MaxCatchWeight = 1234,
	},
	["1,235"] = {
		Level = 1235,
		XpToNextLevel = 18622,
		MaxCatchWeight = 1235,
	},
	["1,236"] = {
		Level = 1236,
		XpToNextLevel = 18654,
		MaxCatchWeight = 1236,
	},
	["1,237"] = {
		Level = 1237,
		XpToNextLevel = 18686,
		MaxCatchWeight = 1237,
	},
	["1,238"] = {
		Level = 1238,
		XpToNextLevel = 18717,
		MaxCatchWeight = 1238,
	},
	["1,239"] = {
		Level = 1239,
		XpToNextLevel = 18749,
		MaxCatchWeight = 1239,
	},
	["1,240"] = {
		Level = 1240,
		XpToNextLevel = 18781,
		MaxCatchWeight = 1240,
	},
	["1,241"] = {
		Level = 1241,
		XpToNextLevel = 18813,
		MaxCatchWeight = 1241,
	},
	["1,242"] = {
		Level = 1242,
		XpToNextLevel = 18845,
		MaxCatchWeight = 1242,
	},
	["1,243"] = {
		Level = 1243,
		XpToNextLevel = 18877,
		MaxCatchWeight = 1243,
	},
	["1,244"] = {
		Level = 1244,
		XpToNextLevel = 18908,
		MaxCatchWeight = 1244,
	},
	["1,245"] = {
		Level = 1245,
		XpToNextLevel = 18940,
		MaxCatchWeight = 1245,
	},
	["1,246"] = {
		Level = 1246,
		XpToNextLevel = 18972,
		MaxCatchWeight = 1246,
	},
	["1,247"] = {
		Level = 1247,
		XpToNextLevel = 19004,
		MaxCatchWeight = 1247,
	},
	["1,248"] = {
		Level = 1248,
		XpToNextLevel = 19036,
		MaxCatchWeight = 1248,
	},
	["1,249"] = {
		Level = 1249,
		XpToNextLevel = 19068,
		MaxCatchWeight = 1249,
	},
	["1,250"] = {
		Level = 1250,
		XpToNextLevel = 19101,
		MaxCatchWeight = 1250,
	},
	["1,251"] = {
		Level = 1251,
		XpToNextLevel = 19133,
		MaxCatchWeight = 1251,
	},
	["1,252"] = {
		Level = 1252,
		XpToNextLevel = 19165,
		MaxCatchWeight = 1252,
	},
	["1,253"] = {
		Level = 1253,
		XpToNextLevel = 19197,
		MaxCatchWeight = 1253,
	},
	["1,254"] = {
		Level = 1254,
		XpToNextLevel = 19229,
		MaxCatchWeight = 1254,
	},
	["1,255"] = {
		Level = 1255,
		XpToNextLevel = 19261,
		MaxCatchWeight = 1255,
	},
	["1,256"] = {
		Level = 1256,
		XpToNextLevel = 19294,
		MaxCatchWeight = 1256,
	},
	["1,257"] = {
		Level = 1257,
		XpToNextLevel = 19326,
		MaxCatchWeight = 1257,
	},
	["1,258"] = {
		Level = 1258,
		XpToNextLevel = 19358,
		MaxCatchWeight = 1258,
	},
	["1,259"] = {
		Level = 1259,
		XpToNextLevel = 19391,
		MaxCatchWeight = 1259,
	},
	["1,260"] = {
		Level = 1260,
		XpToNextLevel = 19423,
		MaxCatchWeight = 1260,
	},
	["1,261"] = {
		Level = 1261,
		XpToNextLevel = 19455,
		MaxCatchWeight = 1261,
	},
	["1,262"] = {
		Level = 1262,
		XpToNextLevel = 19488,
		MaxCatchWeight = 1262,
	},
	["1,263"] = {
		Level = 1263,
		XpToNextLevel = 19520,
		MaxCatchWeight = 1263,
	},
	["1,264"] = {
		Level = 1264,
		XpToNextLevel = 19553,
		MaxCatchWeight = 1264,
	},
	["1,265"] = {
		Level = 1265,
		XpToNextLevel = 19585,
		MaxCatchWeight = 1265,
	},
	["1,266"] = {
		Level = 1266,
		XpToNextLevel = 19618,
		MaxCatchWeight = 1266,
	},
	["1,267"] = {
		Level = 1267,
		XpToNextLevel = 19650,
		MaxCatchWeight = 1267,
	},
	["1,268"] = {
		Level = 1268,
		XpToNextLevel = 19683,
		MaxCatchWeight = 1268,
	},
	["1,269"] = {
		Level = 1269,
		XpToNextLevel = 19716,
		MaxCatchWeight = 1269,
	},
	["1,270"] = {
		Level = 1270,
		XpToNextLevel = 19748,
		MaxCatchWeight = 1270,
	},
	["1,271"] = {
		Level = 1271,
		XpToNextLevel = 19781,
		MaxCatchWeight = 1271,
	},
	["1,272"] = {
		Level = 1272,
		XpToNextLevel = 19814,
		MaxCatchWeight = 1272,
	},
	["1,273"] = {
		Level = 1273,
		XpToNextLevel = 19846,
		MaxCatchWeight = 1273,
	},
	["1,274"] = {
		Level = 1274,
		XpToNextLevel = 19879,
		MaxCatchWeight = 1274,
	},
	["1,275"] = {
		Level = 1275,
		XpToNextLevel = 19912,
		MaxCatchWeight = 1275,
	},
	["1,276"] = {
		Level = 1276,
		XpToNextLevel = 19945,
		MaxCatchWeight = 1276,
	},
	["1,277"] = {
		Level = 1277,
		XpToNextLevel = 19978,
		MaxCatchWeight = 1277,
	},
	["1,278"] = {
		Level = 1278,
		XpToNextLevel = 20011,
		MaxCatchWeight = 1278,
	},
	["1,279"] = {
		Level = 1279,
		XpToNextLevel = 20044,
		MaxCatchWeight = 1279,
	},
	["1,280"] = {
		Level = 1280,
		XpToNextLevel = 20076,
		MaxCatchWeight = 1280,
	},
	["1,281"] = {
		Level = 1281,
		XpToNextLevel = 20109,
		MaxCatchWeight = 1281,
	},
	["1,282"] = {
		Level = 1282,
		XpToNextLevel = 20142,
		MaxCatchWeight = 1282,
	},
	["1,283"] = {
		Level = 1283,
		XpToNextLevel = 20175,
		MaxCatchWeight = 1283,
	},
	["1,284"] = {
		Level = 1284,
		XpToNextLevel = 20209,
		MaxCatchWeight = 1284,
	},
	["1,285"] = {
		Level = 1285,
		XpToNextLevel = 20242,
		MaxCatchWeight = 1285,
	},
	["1,286"] = {
		Level = 1286,
		XpToNextLevel = 20275,
		MaxCatchWeight = 1286,
	},
	["1,287"] = {
		Level = 1287,
		XpToNextLevel = 20308,
		MaxCatchWeight = 1287,
	},
	["1,288"] = {
		Level = 1288,
		XpToNextLevel = 20341,
		MaxCatchWeight = 1288,
	},
	["1,289"] = {
		Level = 1289,
		XpToNextLevel = 20374,
		MaxCatchWeight = 1289,
	},
	["1,290"] = {
		Level = 1290,
		XpToNextLevel = 20407,
		MaxCatchWeight = 1290,
	},
	["1,291"] = {
		Level = 1291,
		XpToNextLevel = 20441,
		MaxCatchWeight = 1291,
	},
	["1,292"] = {
		Level = 1292,
		XpToNextLevel = 20474,
		MaxCatchWeight = 1292,
	},
	["1,293"] = {
		Level = 1293,
		XpToNextLevel = 20507,
		MaxCatchWeight = 1293,
	},
	["1,294"] = {
		Level = 1294,
		XpToNextLevel = 20541,
		MaxCatchWeight = 1294,
	},
	["1,295"] = {
		Level = 1295,
		XpToNextLevel = 20574,
		MaxCatchWeight = 1295,
	},
	["1,296"] = {
		Level = 1296,
		XpToNextLevel = 20607,
		MaxCatchWeight = 1296,
	},
	["1,297"] = {
		Level = 1297,
		XpToNextLevel = 20641,
		MaxCatchWeight = 1297,
	},
	["1,298"] = {
		Level = 1298,
		XpToNextLevel = 20674,
		MaxCatchWeight = 1298,
	},
	["1,299"] = {
		Level = 1299,
		XpToNextLevel = 20708,
		MaxCatchWeight = 1299,
	},
	["1,300"] = {
		Level = 1300,
		XpToNextLevel = 20741,
		MaxCatchWeight = 1300,
	},
	["1,301"] = {
		Level = 1301,
		XpToNextLevel = 20775,
		MaxCatchWeight = 1301,
	},
	["1,302"] = {
		Level = 1302,
		XpToNextLevel = 20808,
		MaxCatchWeight = 1302,
	},
	["1,303"] = {
		Level = 1303,
		XpToNextLevel = 20842,
		MaxCatchWeight = 1303,
	},
	["1,304"] = {
		Level = 1304,
		XpToNextLevel = 20876,
		MaxCatchWeight = 1304,
	},
	["1,305"] = {
		Level = 1305,
		XpToNextLevel = 20909,
		MaxCatchWeight = 1305,
	},
	["1,306"] = {
		Level = 1306,
		XpToNextLevel = 20943,
		MaxCatchWeight = 1306,
	},
	["1,307"] = {
		Level = 1307,
		XpToNextLevel = 20977,
		MaxCatchWeight = 1307,
	},
	["1,308"] = {
		Level = 1308,
		XpToNextLevel = 21010,
		MaxCatchWeight = 1308,
	},
	["1,309"] = {
		Level = 1309,
		XpToNextLevel = 21044,
		MaxCatchWeight = 1309,
	},
	["1,310"] = {
		Level = 1310,
		XpToNextLevel = 21078,
		MaxCatchWeight = 1310,
	},
	["1,311"] = {
		Level = 1311,
		XpToNextLevel = 21112,
		MaxCatchWeight = 1311,
	},
	["1,312"] = {
		Level = 1312,
		XpToNextLevel = 21146,
		MaxCatchWeight = 1312,
	},
	["1,313"] = {
		Level = 1313,
		XpToNextLevel = 21179,
		MaxCatchWeight = 1313,
	},
	["1,314"] = {
		Level = 1314,
		XpToNextLevel = 21213,
		MaxCatchWeight = 1314,
	},
	["1,315"] = {
		Level = 1315,
		XpToNextLevel = 21247,
		MaxCatchWeight = 1315,
	},
	["1,316"] = {
		Level = 1316,
		XpToNextLevel = 21281,
		MaxCatchWeight = 1316,
	},
	["1,317"] = {
		Level = 1317,
		XpToNextLevel = 21315,
		MaxCatchWeight = 1317,
	},
	["1,318"] = {
		Level = 1318,
		XpToNextLevel = 21349,
		MaxCatchWeight = 1318,
	},
	["1,319"] = {
		Level = 1319,
		XpToNextLevel = 21383,
		MaxCatchWeight = 1319,
	},
	["1,320"] = {
		Level = 1320,
		XpToNextLevel = 21417,
		MaxCatchWeight = 1320,
	},
	["1,321"] = {
		Level = 1321,
		XpToNextLevel = 21452,
		MaxCatchWeight = 1321,
	},
	["1,322"] = {
		Level = 1322,
		XpToNextLevel = 21486,
		MaxCatchWeight = 1322,
	},
	["1,323"] = {
		Level = 1323,
		XpToNextLevel = 21520,
		MaxCatchWeight = 1323,
	},
	["1,324"] = {
		Level = 1324,
		XpToNextLevel = 21554,
		MaxCatchWeight = 1324,
	},
	["1,325"] = {
		Level = 1325,
		XpToNextLevel = 21588,
		MaxCatchWeight = 1325,
	},
	["1,326"] = {
		Level = 1326,
		XpToNextLevel = 21622,
		MaxCatchWeight = 1326,
	},
	["1,327"] = {
		Level = 1327,
		XpToNextLevel = 21657,
		MaxCatchWeight = 1327,
	},
	["1,328"] = {
		Level = 1328,
		XpToNextLevel = 21691,
		MaxCatchWeight = 1328,
	},
	["1,329"] = {
		Level = 1329,
		XpToNextLevel = 21725,
		MaxCatchWeight = 1329,
	},
	["1,330"] = {
		Level = 1330,
		XpToNextLevel = 21760,
		MaxCatchWeight = 1330,
	},
	["1,331"] = {
		Level = 1331,
		XpToNextLevel = 21794,
		MaxCatchWeight = 1331,
	},
	["1,332"] = {
		Level = 1332,
		XpToNextLevel = 21829,
		MaxCatchWeight = 1332,
	},
	["1,333"] = {
		Level = 1333,
		XpToNextLevel = 21863,
		MaxCatchWeight = 1333,
	},
	["1,334"] = {
		Level = 1334,
		XpToNextLevel = 21897,
		MaxCatchWeight = 1334,
	},
	["1,335"] = {
		Level = 1335,
		XpToNextLevel = 21932,
		MaxCatchWeight = 1335,
	},
	["1,336"] = {
		Level = 1336,
		XpToNextLevel = 21966,
		MaxCatchWeight = 1336,
	},
	["1,337"] = {
		Level = 1337,
		XpToNextLevel = 22001,
		MaxCatchWeight = 1337,
	},
	["1,338"] = {
		Level = 1338,
		XpToNextLevel = 22036,
		MaxCatchWeight = 1338,
	},
	["1,339"] = {
		Level = 1339,
		XpToNextLevel = 22070,
		MaxCatchWeight = 1339,
	},
	["1,340"] = {
		Level = 1340,
		XpToNextLevel = 22105,
		MaxCatchWeight = 1340,
	},
	["1,341"] = {
		Level = 1341,
		XpToNextLevel = 22140,
		MaxCatchWeight = 1341,
	},
	["1,342"] = {
		Level = 1342,
		XpToNextLevel = 22174,
		MaxCatchWeight = 1342,
	},
	["1,343"] = {
		Level = 1343,
		XpToNextLevel = 22209,
		MaxCatchWeight = 1343,
	},
	["1,344"] = {
		Level = 1344,
		XpToNextLevel = 22244,
		MaxCatchWeight = 1344,
	},
	["1,345"] = {
		Level = 1345,
		XpToNextLevel = 22279,
		MaxCatchWeight = 1345,
	},
	["1,346"] = {
		Level = 1346,
		XpToNextLevel = 22313,
		MaxCatchWeight = 1346,
	},
	["1,347"] = {
		Level = 1347,
		XpToNextLevel = 22348,
		MaxCatchWeight = 1347,
	},
	["1,348"] = {
		Level = 1348,
		XpToNextLevel = 22383,
		MaxCatchWeight = 1348,
	},
	["1,349"] = {
		Level = 1349,
		XpToNextLevel = 22418,
		MaxCatchWeight = 1349,
	},
	["1,350"] = {
		Level = 1350,
		XpToNextLevel = 22453,
		MaxCatchWeight = 1350,
	},
	["1,351"] = {
		Level = 1351,
		XpToNextLevel = 22488,
		MaxCatchWeight = 1351,
	},
	["1,352"] = {
		Level = 1352,
		XpToNextLevel = 22523,
		MaxCatchWeight = 1352,
	},
	["1,353"] = {
		Level = 1353,
		XpToNextLevel = 22558,
		MaxCatchWeight = 1353,
	},
	["1,354"] = {
		Level = 1354,
		XpToNextLevel = 22593,
		MaxCatchWeight = 1354,
	},
	["1,355"] = {
		Level = 1355,
		XpToNextLevel = 22628,
		MaxCatchWeight = 1355,
	},
	["1,356"] = {
		Level = 1356,
		XpToNextLevel = 22663,
		MaxCatchWeight = 1356,
	},
	["1,357"] = {
		Level = 1357,
		XpToNextLevel = 22698,
		MaxCatchWeight = 1357,
	},
	["1,358"] = {
		Level = 1358,
		XpToNextLevel = 22733,
		MaxCatchWeight = 1358,
	},
	["1,359"] = {
		Level = 1359,
		XpToNextLevel = 22769,
		MaxCatchWeight = 1359,
	},
	["1,360"] = {
		Level = 1360,
		XpToNextLevel = 22804,
		MaxCatchWeight = 1360,
	},
	["1,361"] = {
		Level = 1361,
		XpToNextLevel = 22839,
		MaxCatchWeight = 1361,
	},
	["1,362"] = {
		Level = 1362,
		XpToNextLevel = 22874,
		MaxCatchWeight = 1362,
	},
	["1,363"] = {
		Level = 1363,
		XpToNextLevel = 22910,
		MaxCatchWeight = 1363,
	},
	["1,364"] = {
		Level = 1364,
		XpToNextLevel = 22945,
		MaxCatchWeight = 1364,
	},
	["1,365"] = {
		Level = 1365,
		XpToNextLevel = 22980,
		MaxCatchWeight = 1365,
	},
	["1,366"] = {
		Level = 1366,
		XpToNextLevel = 23016,
		MaxCatchWeight = 1366,
	},
	["1,367"] = {
		Level = 1367,
		XpToNextLevel = 23051,
		MaxCatchWeight = 1367,
	},
	["1,368"] = {
		Level = 1368,
		XpToNextLevel = 23087,
		MaxCatchWeight = 1368,
	},
	["1,369"] = {
		Level = 1369,
		XpToNextLevel = 23122,
		MaxCatchWeight = 1369,
	},
	["1,370"] = {
		Level = 1370,
		XpToNextLevel = 23158,
		MaxCatchWeight = 1370,
	},
	["1,371"] = {
		Level = 1371,
		XpToNextLevel = 23193,
		MaxCatchWeight = 1371,
	},
	["1,372"] = {
		Level = 1372,
		XpToNextLevel = 23229,
		MaxCatchWeight = 1372,
	},
	["1,373"] = {
		Level = 1373,
		XpToNextLevel = 23264,
		MaxCatchWeight = 1373,
	},
	["1,374"] = {
		Level = 1374,
		XpToNextLevel = 23300,
		MaxCatchWeight = 1374,
	},
	["1,375"] = {
		Level = 1375,
		XpToNextLevel = 23335,
		MaxCatchWeight = 1375,
	},
	["1,376"] = {
		Level = 1376,
		XpToNextLevel = 23371,
		MaxCatchWeight = 1376,
	},
	["1,377"] = {
		Level = 1377,
		XpToNextLevel = 23407,
		MaxCatchWeight = 1377,
	},
	["1,378"] = {
		Level = 1378,
		XpToNextLevel = 23443,
		MaxCatchWeight = 1378,
	},
	["1,379"] = {
		Level = 1379,
		XpToNextLevel = 23478,
		MaxCatchWeight = 1379,
	},
	["1,380"] = {
		Level = 1380,
		XpToNextLevel = 23514,
		MaxCatchWeight = 1380,
	},
	["1,381"] = {
		Level = 1381,
		XpToNextLevel = 23550,
		MaxCatchWeight = 1381,
	},
	["1,382"] = {
		Level = 1382,
		XpToNextLevel = 23586,
		MaxCatchWeight = 1382,
	},
	["1,383"] = {
		Level = 1383,
		XpToNextLevel = 23622,
		MaxCatchWeight = 1383,
	},
	["1,384"] = {
		Level = 1384,
		XpToNextLevel = 23658,
		MaxCatchWeight = 1384,
	},
	["1,385"] = {
		Level = 1385,
		XpToNextLevel = 23693,
		MaxCatchWeight = 1385,
	},
	["1,386"] = {
		Level = 1386,
		XpToNextLevel = 23729,
		MaxCatchWeight = 1386,
	},
	["1,387"] = {
		Level = 1387,
		XpToNextLevel = 23765,
		MaxCatchWeight = 1387,
	},
	["1,388"] = {
		Level = 1388,
		XpToNextLevel = 23801,
		MaxCatchWeight = 1388,
	},
	["1,389"] = {
		Level = 1389,
		XpToNextLevel = 23837,
		MaxCatchWeight = 1389,
	},
	["1,390"] = {
		Level = 1390,
		XpToNextLevel = 23874,
		MaxCatchWeight = 1390,
	},
	["1,391"] = {
		Level = 1391,
		XpToNextLevel = 23910,
		MaxCatchWeight = 1391,
	},
	["1,392"] = {
		Level = 1392,
		XpToNextLevel = 23946,
		MaxCatchWeight = 1392,
	},
	["1,393"] = {
		Level = 1393,
		XpToNextLevel = 23982,
		MaxCatchWeight = 1393,
	},
	["1,394"] = {
		Level = 1394,
		XpToNextLevel = 24018,
		MaxCatchWeight = 1394,
	},
	["1,395"] = {
		Level = 1395,
		XpToNextLevel = 24054,
		MaxCatchWeight = 1395,
	},
	["1,396"] = {
		Level = 1396,
		XpToNextLevel = 24091,
		MaxCatchWeight = 1396,
	},
	["1,397"] = {
		Level = 1397,
		XpToNextLevel = 24127,
		MaxCatchWeight = 1397,
	},
	["1,398"] = {
		Level = 1398,
		XpToNextLevel = 24163,
		MaxCatchWeight = 1398,
	},
	["1,399"] = {
		Level = 1399,
		XpToNextLevel = 24199,
		MaxCatchWeight = 1399,
	},
	["1,400"] = {
		Level = 1400,
		XpToNextLevel = 24236,
		MaxCatchWeight = 1400,
	},
	["1,401"] = {
		Level = 1401,
		XpToNextLevel = 24272,
		MaxCatchWeight = 1401,
	},
	["1,402"] = {
		Level = 1402,
		XpToNextLevel = 24309,
		MaxCatchWeight = 1402,
	},
	["1,403"] = {
		Level = 1403,
		XpToNextLevel = 24345,
		MaxCatchWeight = 1403,
	},
	["1,404"] = {
		Level = 1404,
		XpToNextLevel = 24382,
		MaxCatchWeight = 1404,
	},
	["1,405"] = {
		Level = 1405,
		XpToNextLevel = 24418,
		MaxCatchWeight = 1405,
	},
	["1,406"] = {
		Level = 1406,
		XpToNextLevel = 24455,
		MaxCatchWeight = 1406,
	},
	["1,407"] = {
		Level = 1407,
		XpToNextLevel = 24491,
		MaxCatchWeight = 1407,
	},
	["1,408"] = {
		Level = 1408,
		XpToNextLevel = 24528,
		MaxCatchWeight = 1408,
	},
	["1,409"] = {
		Level = 1409,
		XpToNextLevel = 24564,
		MaxCatchWeight = 1409,
	},
	["1,410"] = {
		Level = 1410,
		XpToNextLevel = 24601,
		MaxCatchWeight = 1410,
	},
	["1,411"] = {
		Level = 1411,
		XpToNextLevel = 24638,
		MaxCatchWeight = 1411,
	},
	["1,412"] = {
		Level = 1412,
		XpToNextLevel = 24674,
		MaxCatchWeight = 1412,
	},
	["1,413"] = {
		Level = 1413,
		XpToNextLevel = 24711,
		MaxCatchWeight = 1413,
	},
	["1,414"] = {
		Level = 1414,
		XpToNextLevel = 24748,
		MaxCatchWeight = 1414,
	},
	["1,415"] = {
		Level = 1415,
		XpToNextLevel = 24785,
		MaxCatchWeight = 1415,
	},
	["1,416"] = {
		Level = 1416,
		XpToNextLevel = 24821,
		MaxCatchWeight = 1416,
	},
	["1,417"] = {
		Level = 1417,
		XpToNextLevel = 24858,
		MaxCatchWeight = 1417,
	},
	["1,418"] = {
		Level = 1418,
		XpToNextLevel = 24895,
		MaxCatchWeight = 1418,
	},
	["1,419"] = {
		Level = 1419,
		XpToNextLevel = 24932,
		MaxCatchWeight = 1419,
	},
	["1,420"] = {
		Level = 1420,
		XpToNextLevel = 24969,
		MaxCatchWeight = 1420,
	},
	["1,421"] = {
		Level = 1421,
		XpToNextLevel = 25006,
		MaxCatchWeight = 1421,
	},
	["1,422"] = {
		Level = 1422,
		XpToNextLevel = 25043,
		MaxCatchWeight = 1422,
	},
	["1,423"] = {
		Level = 1423,
		XpToNextLevel = 25080,
		MaxCatchWeight = 1423,
	},
	["1,424"] = {
		Level = 1424,
		XpToNextLevel = 25117,
		MaxCatchWeight = 1424,
	},
	["1,425"] = {
		Level = 1425,
		XpToNextLevel = 25154,
		MaxCatchWeight = 1425,
	},
	["1,426"] = {
		Level = 1426,
		XpToNextLevel = 25191,
		MaxCatchWeight = 1426,
	},
	["1,427"] = {
		Level = 1427,
		XpToNextLevel = 25228,
		MaxCatchWeight = 1427,
	},
	["1,428"] = {
		Level = 1428,
		XpToNextLevel = 25265,
		MaxCatchWeight = 1428,
	},
	["1,429"] = {
		Level = 1429,
		XpToNextLevel = 25303,
		MaxCatchWeight = 1429,
	},
	["1,430"] = {
		Level = 1430,
		XpToNextLevel = 25340,
		MaxCatchWeight = 1430,
	},
	["1,431"] = {
		Level = 1431,
		XpToNextLevel = 25377,
		MaxCatchWeight = 1431,
	},
	["1,432"] = {
		Level = 1432,
		XpToNextLevel = 25414,
		MaxCatchWeight = 1432,
	},
	["1,433"] = {
		Level = 1433,
		XpToNextLevel = 25452,
		MaxCatchWeight = 1433,
	},
	["1,434"] = {
		Level = 1434,
		XpToNextLevel = 25489,
		MaxCatchWeight = 1434,
	},
	["1,435"] = {
		Level = 1435,
		XpToNextLevel = 25526,
		MaxCatchWeight = 1435,
	},
	["1,436"] = {
		Level = 1436,
		XpToNextLevel = 25564,
		MaxCatchWeight = 1436,
	},
	["1,437"] = {
		Level = 1437,
		XpToNextLevel = 25601,
		MaxCatchWeight = 1437,
	},
	["1,438"] = {
		Level = 1438,
		XpToNextLevel = 25639,
		MaxCatchWeight = 1438,
	},
	["1,439"] = {
		Level = 1439,
		XpToNextLevel = 25676,
		MaxCatchWeight = 1439,
	},
	["1,440"] = {
		Level = 1440,
		XpToNextLevel = 25714,
		MaxCatchWeight = 1440,
	},
	["1,441"] = {
		Level = 1441,
		XpToNextLevel = 25751,
		MaxCatchWeight = 1441,
	},
	["1,442"] = {
		Level = 1442,
		XpToNextLevel = 25789,
		MaxCatchWeight = 1442,
	},
	["1,443"] = {
		Level = 1443,
		XpToNextLevel = 25826,
		MaxCatchWeight = 1443,
	},
	["1,444"] = {
		Level = 1444,
		XpToNextLevel = 25864,
		MaxCatchWeight = 1444,
	},
	["1,445"] = {
		Level = 1445,
		XpToNextLevel = 25902,
		MaxCatchWeight = 1445,
	},
	["1,446"] = {
		Level = 1446,
		XpToNextLevel = 25939,
		MaxCatchWeight = 1446,
	},
	["1,447"] = {
		Level = 1447,
		XpToNextLevel = 25977,
		MaxCatchWeight = 1447,
	},
	["1,448"] = {
		Level = 1448,
		XpToNextLevel = 26015,
		MaxCatchWeight = 1448,
	},
	["1,449"] = {
		Level = 1449,
		XpToNextLevel = 26052,
		MaxCatchWeight = 1449,
	},
	["1,450"] = {
		Level = 1450,
		XpToNextLevel = 26090,
		MaxCatchWeight = 1450,
	},
	["1,451"] = {
		Level = 1451,
		XpToNextLevel = 26128,
		MaxCatchWeight = 1451,
	},
	["1,452"] = {
		Level = 1452,
		XpToNextLevel = 26166,
		MaxCatchWeight = 1452,
	},
	["1,453"] = {
		Level = 1453,
		XpToNextLevel = 26204,
		MaxCatchWeight = 1453,
	},
	["1,454"] = {
		Level = 1454,
		XpToNextLevel = 26242,
		MaxCatchWeight = 1454,
	},
	["1,455"] = {
		Level = 1455,
		XpToNextLevel = 26280,
		MaxCatchWeight = 1455,
	},
	["1,456"] = {
		Level = 1456,
		XpToNextLevel = 26318,
		MaxCatchWeight = 1456,
	},
	["1,457"] = {
		Level = 1457,
		XpToNextLevel = 26356,
		MaxCatchWeight = 1457,
	},
	["1,458"] = {
		Level = 1458,
		XpToNextLevel = 26394,
		MaxCatchWeight = 1458,
	},
	["1,459"] = {
		Level = 1459,
		XpToNextLevel = 26432,
		MaxCatchWeight = 1459,
	},
	["1,460"] = {
		Level = 1460,
		XpToNextLevel = 26470,
		MaxCatchWeight = 1460,
	},
	["1,461"] = {
		Level = 1461,
		XpToNextLevel = 26508,
		MaxCatchWeight = 1461,
	},
	["1,462"] = {
		Level = 1462,
		XpToNextLevel = 26546,
		MaxCatchWeight = 1462,
	},
	["1,463"] = {
		Level = 1463,
		XpToNextLevel = 26584,
		MaxCatchWeight = 1463,
	},
	["1,464"] = {
		Level = 1464,
		XpToNextLevel = 26622,
		MaxCatchWeight = 1464,
	},
	["1,465"] = {
		Level = 1465,
		XpToNextLevel = 26661,
		MaxCatchWeight = 1465,
	},
	["1,466"] = {
		Level = 1466,
		XpToNextLevel = 26699,
		MaxCatchWeight = 1466,
	},
	["1,467"] = {
		Level = 1467,
		XpToNextLevel = 26737,
		MaxCatchWeight = 1467,
	},
	["1,468"] = {
		Level = 1468,
		XpToNextLevel = 26775,
		MaxCatchWeight = 1468,
	},
	["1,469"] = {
		Level = 1469,
		XpToNextLevel = 26814,
		MaxCatchWeight = 1469,
	},
	["1,470"] = {
		Level = 1470,
		XpToNextLevel = 26852,
		MaxCatchWeight = 1470,
	},
	["1,471"] = {
		Level = 1471,
		XpToNextLevel = 26890,
		MaxCatchWeight = 1471,
	},
	["1,472"] = {
		Level = 1472,
		XpToNextLevel = 26929,
		MaxCatchWeight = 1472,
	},
	["1,473"] = {
		Level = 1473,
		XpToNextLevel = 26967,
		MaxCatchWeight = 1473,
	},
	["1,474"] = {
		Level = 1474,
		XpToNextLevel = 27006,
		MaxCatchWeight = 1474,
	},
	["1,475"] = {
		Level = 1475,
		XpToNextLevel = 27044,
		MaxCatchWeight = 1475,
	},
	["1,476"] = {
		Level = 1476,
		XpToNextLevel = 27083,
		MaxCatchWeight = 1476,
	},
	["1,477"] = {
		Level = 1477,
		XpToNextLevel = 27121,
		MaxCatchWeight = 1477,
	},
	["1,478"] = {
		Level = 1478,
		XpToNextLevel = 27160,
		MaxCatchWeight = 1478,
	},
	["1,479"] = {
		Level = 1479,
		XpToNextLevel = 27199,
		MaxCatchWeight = 1479,
	},
	["1,480"] = {
		Level = 1480,
		XpToNextLevel = 27237,
		MaxCatchWeight = 1480,
	},
	["1,481"] = {
		Level = 1481,
		XpToNextLevel = 27276,
		MaxCatchWeight = 1481,
	},
	["1,482"] = {
		Level = 1482,
		XpToNextLevel = 27315,
		MaxCatchWeight = 1482,
	},
	["1,483"] = {
		Level = 1483,
		XpToNextLevel = 27353,
		MaxCatchWeight = 1483,
	},
	["1,484"] = {
		Level = 1484,
		XpToNextLevel = 27392,
		MaxCatchWeight = 1484,
	},
	["1,485"] = {
		Level = 1485,
		XpToNextLevel = 27431,
		MaxCatchWeight = 1485,
	},
	["1,486"] = {
		Level = 1486,
		XpToNextLevel = 27470,
		MaxCatchWeight = 1486,
	},
	["1,487"] = {
		Level = 1487,
		XpToNextLevel = 27509,
		MaxCatchWeight = 1487,
	},
	["1,488"] = {
		Level = 1488,
		XpToNextLevel = 27548,
		MaxCatchWeight = 1488,
	},
	["1,489"] = {
		Level = 1489,
		XpToNextLevel = 27586,
		MaxCatchWeight = 1489,
	},
	["1,490"] = {
		Level = 1490,
		XpToNextLevel = 27625,
		MaxCatchWeight = 1490,
	},
	["1,491"] = {
		Level = 1491,
		XpToNextLevel = 27664,
		MaxCatchWeight = 1491,
	},
	["1,492"] = {
		Level = 1492,
		XpToNextLevel = 27703,
		MaxCatchWeight = 1492,
	},
	["1,493"] = {
		Level = 1493,
		XpToNextLevel = 27742,
		MaxCatchWeight = 1493,
	},
	["1,494"] = {
		Level = 1494,
		XpToNextLevel = 27781,
		MaxCatchWeight = 1494,
	},
	["1,495"] = {
		Level = 1495,
		XpToNextLevel = 27821,
		MaxCatchWeight = 1495,
	},
	["1,496"] = {
		Level = 1496,
		XpToNextLevel = 27860,
		MaxCatchWeight = 1496,
	},
	["1,497"] = {
		Level = 1497,
		XpToNextLevel = 27899,
		MaxCatchWeight = 1497,
	},
	["1,498"] = {
		Level = 1498,
		XpToNextLevel = 27938,
		MaxCatchWeight = 1498,
	},
	["1,499"] = {
		Level = 1499,
		XpToNextLevel = 27977,
		MaxCatchWeight = 1499,
	},
	["1,500"] = {
		Level = 1500,
		XpToNextLevel = 0,
		MaxCatchWeight = 1500,
	},
}

return data