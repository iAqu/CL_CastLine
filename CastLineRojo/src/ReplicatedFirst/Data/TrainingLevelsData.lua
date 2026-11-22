export type TrainingLevelConfig = {
	Level: number,
	XpToNextLevel: number,
	MaxCatchWeight: number,
}

local data: {[string]: TrainingLevelConfig} = {
	["1"] = {
		Level = 1,
		XpToNextLevel = 5,
		MaxCatchWeight = 10,
	},
	["2"] = {
		Level = 2,
		XpToNextLevel = 5,
		MaxCatchWeight = 20,
	},
	["3"] = {
		Level = 3,
		XpToNextLevel = 5,
		MaxCatchWeight = 30,
	},
	["4"] = {
		Level = 4,
		XpToNextLevel = 5,
		MaxCatchWeight = 40,
	},
	["5"] = {
		Level = 5,
		XpToNextLevel = 5,
		MaxCatchWeight = 50,
	},
	["6"] = {
		Level = 6,
		XpToNextLevel = 5,
		MaxCatchWeight = 60,
	},
	["7"] = {
		Level = 7,
		XpToNextLevel = 5,
		MaxCatchWeight = 70,
	},
	["8"] = {
		Level = 8,
		XpToNextLevel = 5,
		MaxCatchWeight = 80,
	},
	["9"] = {
		Level = 9,
		XpToNextLevel = 5,
		MaxCatchWeight = 90,
	},
	["10"] = {
		Level = 10,
		XpToNextLevel = 6,
		MaxCatchWeight = 100,
	},
	["11"] = {
		Level = 11,
		XpToNextLevel = 6,
		MaxCatchWeight = 110,
	},
	["12"] = {
		Level = 12,
		XpToNextLevel = 6,
		MaxCatchWeight = 120,
	},
	["13"] = {
		Level = 13,
		XpToNextLevel = 6,
		MaxCatchWeight = 130,
	},
	["14"] = {
		Level = 14,
		XpToNextLevel = 6,
		MaxCatchWeight = 140,
	},
	["15"] = {
		Level = 15,
		XpToNextLevel = 7,
		MaxCatchWeight = 150,
	},
	["16"] = {
		Level = 16,
		XpToNextLevel = 7,
		MaxCatchWeight = 160,
	},
	["17"] = {
		Level = 17,
		XpToNextLevel = 7,
		MaxCatchWeight = 170,
	},
	["18"] = {
		Level = 18,
		XpToNextLevel = 7,
		MaxCatchWeight = 180,
	},
	["19"] = {
		Level = 19,
		XpToNextLevel = 8,
		MaxCatchWeight = 190,
	},
	["20"] = {
		Level = 20,
		XpToNextLevel = 8,
		MaxCatchWeight = 200,
	},
	["21"] = {
		Level = 21,
		XpToNextLevel = 8,
		MaxCatchWeight = 210,
	},
	["22"] = {
		Level = 22,
		XpToNextLevel = 9,
		MaxCatchWeight = 220,
	},
	["23"] = {
		Level = 23,
		XpToNextLevel = 9,
		MaxCatchWeight = 230,
	},
	["24"] = {
		Level = 24,
		XpToNextLevel = 9,
		MaxCatchWeight = 240,
	},
	["25"] = {
		Level = 25,
		XpToNextLevel = 10,
		MaxCatchWeight = 250,
	},
	["26"] = {
		Level = 26,
		XpToNextLevel = 10,
		MaxCatchWeight = 260,
	},
	["27"] = {
		Level = 27,
		XpToNextLevel = 11,
		MaxCatchWeight = 270,
	},
	["28"] = {
		Level = 28,
		XpToNextLevel = 11,
		MaxCatchWeight = 280,
	},
	["29"] = {
		Level = 29,
		XpToNextLevel = 12,
		MaxCatchWeight = 290,
	},
	["30"] = {
		Level = 30,
		XpToNextLevel = 12,
		MaxCatchWeight = 300,
	},
	["31"] = {
		Level = 31,
		XpToNextLevel = 13,
		MaxCatchWeight = 310,
	},
	["32"] = {
		Level = 32,
		XpToNextLevel = 13,
		MaxCatchWeight = 320,
	},
	["33"] = {
		Level = 33,
		XpToNextLevel = 14,
		MaxCatchWeight = 330,
	},
	["34"] = {
		Level = 34,
		XpToNextLevel = 14,
		MaxCatchWeight = 340,
	},
	["35"] = {
		Level = 35,
		XpToNextLevel = 15,
		MaxCatchWeight = 350,
	},
	["36"] = {
		Level = 36,
		XpToNextLevel = 15,
		MaxCatchWeight = 360,
	},
	["37"] = {
		Level = 37,
		XpToNextLevel = 16,
		MaxCatchWeight = 370,
	},
	["38"] = {
		Level = 38,
		XpToNextLevel = 17,
		MaxCatchWeight = 380,
	},
	["39"] = {
		Level = 39,
		XpToNextLevel = 17,
		MaxCatchWeight = 390,
	},
	["40"] = {
		Level = 40,
		XpToNextLevel = 18,
		MaxCatchWeight = 400,
	},
	["41"] = {
		Level = 41,
		XpToNextLevel = 19,
		MaxCatchWeight = 410,
	},
	["42"] = {
		Level = 42,
		XpToNextLevel = 20,
		MaxCatchWeight = 420,
	},
	["43"] = {
		Level = 43,
		XpToNextLevel = 20,
		MaxCatchWeight = 430,
	},
	["44"] = {
		Level = 44,
		XpToNextLevel = 21,
		MaxCatchWeight = 440,
	},
	["45"] = {
		Level = 45,
		XpToNextLevel = 22,
		MaxCatchWeight = 450,
	},
	["46"] = {
		Level = 46,
		XpToNextLevel = 23,
		MaxCatchWeight = 460,
	},
	["47"] = {
		Level = 47,
		XpToNextLevel = 24,
		MaxCatchWeight = 470,
	},
	["48"] = {
		Level = 48,
		XpToNextLevel = 24,
		MaxCatchWeight = 480,
	},
	["49"] = {
		Level = 49,
		XpToNextLevel = 25,
		MaxCatchWeight = 490,
	},
	["50"] = {
		Level = 50,
		XpToNextLevel = 26,
		MaxCatchWeight = 500,
	},
	["51"] = {
		Level = 51,
		XpToNextLevel = 27,
		MaxCatchWeight = 510,
	},
	["52"] = {
		Level = 52,
		XpToNextLevel = 28,
		MaxCatchWeight = 520,
	},
	["53"] = {
		Level = 53,
		XpToNextLevel = 29,
		MaxCatchWeight = 530,
	},
	["54"] = {
		Level = 54,
		XpToNextLevel = 30,
		MaxCatchWeight = 540,
	},
	["55"] = {
		Level = 55,
		XpToNextLevel = 31,
		MaxCatchWeight = 550,
	},
	["56"] = {
		Level = 56,
		XpToNextLevel = 32,
		MaxCatchWeight = 560,
	},
	["57"] = {
		Level = 57,
		XpToNextLevel = 33,
		MaxCatchWeight = 570,
	},
	["58"] = {
		Level = 58,
		XpToNextLevel = 34,
		MaxCatchWeight = 580,
	},
	["59"] = {
		Level = 59,
		XpToNextLevel = 35,
		MaxCatchWeight = 590,
	},
	["60"] = {
		Level = 60,
		XpToNextLevel = 36,
		MaxCatchWeight = 600,
	},
	["61"] = {
		Level = 61,
		XpToNextLevel = 38,
		MaxCatchWeight = 610,
	},
	["62"] = {
		Level = 62,
		XpToNextLevel = 39,
		MaxCatchWeight = 620,
	},
	["63"] = {
		Level = 63,
		XpToNextLevel = 40,
		MaxCatchWeight = 630,
	},
	["64"] = {
		Level = 64,
		XpToNextLevel = 41,
		MaxCatchWeight = 640,
	},
	["65"] = {
		Level = 65,
		XpToNextLevel = 42,
		MaxCatchWeight = 650,
	},
	["66"] = {
		Level = 66,
		XpToNextLevel = 43,
		MaxCatchWeight = 660,
	},
	["67"] = {
		Level = 67,
		XpToNextLevel = 45,
		MaxCatchWeight = 670,
	},
	["68"] = {
		Level = 68,
		XpToNextLevel = 46,
		MaxCatchWeight = 680,
	},
	["69"] = {
		Level = 69,
		XpToNextLevel = 47,
		MaxCatchWeight = 690,
	},
	["70"] = {
		Level = 70,
		XpToNextLevel = 49,
		MaxCatchWeight = 700,
	},
	["71"] = {
		Level = 71,
		XpToNextLevel = 50,
		MaxCatchWeight = 710,
	},
	["72"] = {
		Level = 72,
		XpToNextLevel = 51,
		MaxCatchWeight = 720,
	},
	["73"] = {
		Level = 73,
		XpToNextLevel = 53,
		MaxCatchWeight = 730,
	},
	["74"] = {
		Level = 74,
		XpToNextLevel = 54,
		MaxCatchWeight = 740,
	},
	["75"] = {
		Level = 75,
		XpToNextLevel = 56,
		MaxCatchWeight = 750,
	},
	["76"] = {
		Level = 76,
		XpToNextLevel = 57,
		MaxCatchWeight = 760,
	},
	["77"] = {
		Level = 77,
		XpToNextLevel = 58,
		MaxCatchWeight = 770,
	},
	["78"] = {
		Level = 78,
		XpToNextLevel = 60,
		MaxCatchWeight = 780,
	},
	["79"] = {
		Level = 79,
		XpToNextLevel = 61,
		MaxCatchWeight = 790,
	},
	["80"] = {
		Level = 80,
		XpToNextLevel = 63,
		MaxCatchWeight = 800,
	},
	["81"] = {
		Level = 81,
		XpToNextLevel = 65,
		MaxCatchWeight = 810,
	},
	["82"] = {
		Level = 82,
		XpToNextLevel = 66,
		MaxCatchWeight = 820,
	},
	["83"] = {
		Level = 83,
		XpToNextLevel = 68,
		MaxCatchWeight = 830,
	},
	["84"] = {
		Level = 84,
		XpToNextLevel = 69,
		MaxCatchWeight = 840,
	},
	["85"] = {
		Level = 85,
		XpToNextLevel = 71,
		MaxCatchWeight = 850,
	},
	["86"] = {
		Level = 86,
		XpToNextLevel = 73,
		MaxCatchWeight = 860,
	},
	["87"] = {
		Level = 87,
		XpToNextLevel = 74,
		MaxCatchWeight = 870,
	},
	["88"] = {
		Level = 88,
		XpToNextLevel = 76,
		MaxCatchWeight = 880,
	},
	["89"] = {
		Level = 89,
		XpToNextLevel = 78,
		MaxCatchWeight = 890,
	},
	["90"] = {
		Level = 90,
		XpToNextLevel = 79,
		MaxCatchWeight = 900,
	},
	["91"] = {
		Level = 91,
		XpToNextLevel = 81,
		MaxCatchWeight = 910,
	},
	["92"] = {
		Level = 92,
		XpToNextLevel = 83,
		MaxCatchWeight = 920,
	},
	["93"] = {
		Level = 93,
		XpToNextLevel = 85,
		MaxCatchWeight = 930,
	},
	["94"] = {
		Level = 94,
		XpToNextLevel = 87,
		MaxCatchWeight = 940,
	},
	["95"] = {
		Level = 95,
		XpToNextLevel = 89,
		MaxCatchWeight = 950,
	},
	["96"] = {
		Level = 96,
		XpToNextLevel = 90,
		MaxCatchWeight = 960,
	},
	["97"] = {
		Level = 97,
		XpToNextLevel = 92,
		MaxCatchWeight = 970,
	},
	["98"] = {
		Level = 98,
		XpToNextLevel = 94,
		MaxCatchWeight = 980,
	},
	["99"] = {
		Level = 99,
		XpToNextLevel = 96,
		MaxCatchWeight = 990,
	},
	["100"] = {
		Level = 100,
		XpToNextLevel = 98,
		MaxCatchWeight = 1000,
	},
	["101"] = {
		Level = 101,
		XpToNextLevel = 100,
		MaxCatchWeight = 1010,
	},
	["102"] = {
		Level = 102,
		XpToNextLevel = 102,
		MaxCatchWeight = 1020,
	},
	["103"] = {
		Level = 103,
		XpToNextLevel = 104,
		MaxCatchWeight = 1030,
	},
	["104"] = {
		Level = 104,
		XpToNextLevel = 106,
		MaxCatchWeight = 1040,
	},
	["105"] = {
		Level = 105,
		XpToNextLevel = 108,
		MaxCatchWeight = 1050,
	},
	["106"] = {
		Level = 106,
		XpToNextLevel = 110,
		MaxCatchWeight = 1060,
	},
	["107"] = {
		Level = 107,
		XpToNextLevel = 112,
		MaxCatchWeight = 1070,
	},
	["108"] = {
		Level = 108,
		XpToNextLevel = 115,
		MaxCatchWeight = 1080,
	},
	["109"] = {
		Level = 109,
		XpToNextLevel = 117,
		MaxCatchWeight = 1090,
	},
	["110"] = {
		Level = 110,
		XpToNextLevel = 119,
		MaxCatchWeight = 1100,
	},
	["111"] = {
		Level = 111,
		XpToNextLevel = 121,
		MaxCatchWeight = 1110,
	},
	["112"] = {
		Level = 112,
		XpToNextLevel = 123,
		MaxCatchWeight = 1120,
	},
	["113"] = {
		Level = 113,
		XpToNextLevel = 126,
		MaxCatchWeight = 1130,
	},
	["114"] = {
		Level = 114,
		XpToNextLevel = 128,
		MaxCatchWeight = 1140,
	},
	["115"] = {
		Level = 115,
		XpToNextLevel = 130,
		MaxCatchWeight = 1150,
	},
	["116"] = {
		Level = 116,
		XpToNextLevel = 133,
		MaxCatchWeight = 1160,
	},
	["117"] = {
		Level = 117,
		XpToNextLevel = 135,
		MaxCatchWeight = 1170,
	},
	["118"] = {
		Level = 118,
		XpToNextLevel = 137,
		MaxCatchWeight = 1180,
	},
	["119"] = {
		Level = 119,
		XpToNextLevel = 140,
		MaxCatchWeight = 1190,
	},
	["120"] = {
		Level = 120,
		XpToNextLevel = 142,
		MaxCatchWeight = 1200,
	},
	["121"] = {
		Level = 121,
		XpToNextLevel = 144,
		MaxCatchWeight = 1210,
	},
	["122"] = {
		Level = 122,
		XpToNextLevel = 147,
		MaxCatchWeight = 1220,
	},
	["123"] = {
		Level = 123,
		XpToNextLevel = 149,
		MaxCatchWeight = 1230,
	},
	["124"] = {
		Level = 124,
		XpToNextLevel = 152,
		MaxCatchWeight = 1240,
	},
	["125"] = {
		Level = 125,
		XpToNextLevel = 154,
		MaxCatchWeight = 1250,
	},
	["126"] = {
		Level = 126,
		XpToNextLevel = 157,
		MaxCatchWeight = 1260,
	},
	["127"] = {
		Level = 127,
		XpToNextLevel = 160,
		MaxCatchWeight = 1270,
	},
	["128"] = {
		Level = 128,
		XpToNextLevel = 162,
		MaxCatchWeight = 1280,
	},
	["129"] = {
		Level = 129,
		XpToNextLevel = 165,
		MaxCatchWeight = 1290,
	},
	["130"] = {
		Level = 130,
		XpToNextLevel = 167,
		MaxCatchWeight = 1300,
	},
	["131"] = {
		Level = 131,
		XpToNextLevel = 170,
		MaxCatchWeight = 1310,
	},
	["132"] = {
		Level = 132,
		XpToNextLevel = 173,
		MaxCatchWeight = 1320,
	},
	["133"] = {
		Level = 133,
		XpToNextLevel = 175,
		MaxCatchWeight = 1330,
	},
	["134"] = {
		Level = 134,
		XpToNextLevel = 178,
		MaxCatchWeight = 1340,
	},
	["135"] = {
		Level = 135,
		XpToNextLevel = 181,
		MaxCatchWeight = 1350,
	},
	["136"] = {
		Level = 136,
		XpToNextLevel = 184,
		MaxCatchWeight = 1360,
	},
	["137"] = {
		Level = 137,
		XpToNextLevel = 186,
		MaxCatchWeight = 1370,
	},
	["138"] = {
		Level = 138,
		XpToNextLevel = 189,
		MaxCatchWeight = 1380,
	},
	["139"] = {
		Level = 139,
		XpToNextLevel = 192,
		MaxCatchWeight = 1390,
	},
	["140"] = {
		Level = 140,
		XpToNextLevel = 195,
		MaxCatchWeight = 1400,
	},
	["141"] = {
		Level = 141,
		XpToNextLevel = 198,
		MaxCatchWeight = 1410,
	},
	["142"] = {
		Level = 142,
		XpToNextLevel = 201,
		MaxCatchWeight = 1420,
	},
	["143"] = {
		Level = 143,
		XpToNextLevel = 204,
		MaxCatchWeight = 1430,
	},
	["144"] = {
		Level = 144,
		XpToNextLevel = 207,
		MaxCatchWeight = 1440,
	},
	["145"] = {
		Level = 145,
		XpToNextLevel = 210,
		MaxCatchWeight = 1450,
	},
	["146"] = {
		Level = 146,
		XpToNextLevel = 213,
		MaxCatchWeight = 1460,
	},
	["147"] = {
		Level = 147,
		XpToNextLevel = 216,
		MaxCatchWeight = 1470,
	},
	["148"] = {
		Level = 148,
		XpToNextLevel = 219,
		MaxCatchWeight = 1480,
	},
	["149"] = {
		Level = 149,
		XpToNextLevel = 222,
		MaxCatchWeight = 1490,
	},
	["150"] = {
		Level = 150,
		XpToNextLevel = 225,
		MaxCatchWeight = 1500,
	},
	["151"] = {
		Level = 151,
		XpToNextLevel = 228,
		MaxCatchWeight = 1510,
	},
	["152"] = {
		Level = 152,
		XpToNextLevel = 231,
		MaxCatchWeight = 1520,
	},
	["153"] = {
		Level = 153,
		XpToNextLevel = 234,
		MaxCatchWeight = 1530,
	},
	["154"] = {
		Level = 154,
		XpToNextLevel = 237,
		MaxCatchWeight = 1540,
	},
	["155"] = {
		Level = 155,
		XpToNextLevel = 240,
		MaxCatchWeight = 1550,
	},
	["156"] = {
		Level = 156,
		XpToNextLevel = 244,
		MaxCatchWeight = 1560,
	},
	["157"] = {
		Level = 157,
		XpToNextLevel = 247,
		MaxCatchWeight = 1570,
	},
	["158"] = {
		Level = 158,
		XpToNextLevel = 250,
		MaxCatchWeight = 1580,
	},
	["159"] = {
		Level = 159,
		XpToNextLevel = 254,
		MaxCatchWeight = 1590,
	},
	["160"] = {
		Level = 160,
		XpToNextLevel = 257,
		MaxCatchWeight = 1600,
	},
	["161"] = {
		Level = 161,
		XpToNextLevel = 260,
		MaxCatchWeight = 1610,
	},
	["162"] = {
		Level = 162,
		XpToNextLevel = 264,
		MaxCatchWeight = 1620,
	},
	["163"] = {
		Level = 163,
		XpToNextLevel = 267,
		MaxCatchWeight = 1630,
	},
	["164"] = {
		Level = 164,
		XpToNextLevel = 270,
		MaxCatchWeight = 1640,
	},
	["165"] = {
		Level = 165,
		XpToNextLevel = 274,
		MaxCatchWeight = 1650,
	},
	["166"] = {
		Level = 166,
		XpToNextLevel = 277,
		MaxCatchWeight = 1660,
	},
	["167"] = {
		Level = 167,
		XpToNextLevel = 281,
		MaxCatchWeight = 1670,
	},
	["168"] = {
		Level = 168,
		XpToNextLevel = 284,
		MaxCatchWeight = 1680,
	},
	["169"] = {
		Level = 169,
		XpToNextLevel = 288,
		MaxCatchWeight = 1690,
	},
	["170"] = {
		Level = 170,
		XpToNextLevel = 291,
		MaxCatchWeight = 1700,
	},
	["171"] = {
		Level = 171,
		XpToNextLevel = 295,
		MaxCatchWeight = 1710,
	},
	["172"] = {
		Level = 172,
		XpToNextLevel = 298,
		MaxCatchWeight = 1720,
	},
	["173"] = {
		Level = 173,
		XpToNextLevel = 302,
		MaxCatchWeight = 1730,
	},
	["174"] = {
		Level = 174,
		XpToNextLevel = 306,
		MaxCatchWeight = 1740,
	},
	["175"] = {
		Level = 175,
		XpToNextLevel = 309,
		MaxCatchWeight = 1750,
	},
	["176"] = {
		Level = 176,
		XpToNextLevel = 313,
		MaxCatchWeight = 1760,
	},
	["177"] = {
		Level = 177,
		XpToNextLevel = 317,
		MaxCatchWeight = 1770,
	},
	["178"] = {
		Level = 178,
		XpToNextLevel = 320,
		MaxCatchWeight = 1780,
	},
	["179"] = {
		Level = 179,
		XpToNextLevel = 324,
		MaxCatchWeight = 1790,
	},
	["180"] = {
		Level = 180,
		XpToNextLevel = 328,
		MaxCatchWeight = 1800,
	},
	["181"] = {
		Level = 181,
		XpToNextLevel = 332,
		MaxCatchWeight = 1810,
	},
	["182"] = {
		Level = 182,
		XpToNextLevel = 336,
		MaxCatchWeight = 1820,
	},
	["183"] = {
		Level = 183,
		XpToNextLevel = 339,
		MaxCatchWeight = 1830,
	},
	["184"] = {
		Level = 184,
		XpToNextLevel = 343,
		MaxCatchWeight = 1840,
	},
	["185"] = {
		Level = 185,
		XpToNextLevel = 347,
		MaxCatchWeight = 1850,
	},
	["186"] = {
		Level = 186,
		XpToNextLevel = 351,
		MaxCatchWeight = 1860,
	},
	["187"] = {
		Level = 187,
		XpToNextLevel = 355,
		MaxCatchWeight = 1870,
	},
	["188"] = {
		Level = 188,
		XpToNextLevel = 359,
		MaxCatchWeight = 1880,
	},
	["189"] = {
		Level = 189,
		XpToNextLevel = 363,
		MaxCatchWeight = 1890,
	},
	["190"] = {
		Level = 190,
		XpToNextLevel = 367,
		MaxCatchWeight = 1900,
	},
	["191"] = {
		Level = 191,
		XpToNextLevel = 371,
		MaxCatchWeight = 1910,
	},
	["192"] = {
		Level = 192,
		XpToNextLevel = 375,
		MaxCatchWeight = 1920,
	},
	["193"] = {
		Level = 193,
		XpToNextLevel = 379,
		MaxCatchWeight = 1930,
	},
	["194"] = {
		Level = 194,
		XpToNextLevel = 383,
		MaxCatchWeight = 1940,
	},
	["195"] = {
		Level = 195,
		XpToNextLevel = 387,
		MaxCatchWeight = 1950,
	},
	["196"] = {
		Level = 196,
		XpToNextLevel = 392,
		MaxCatchWeight = 1960,
	},
	["197"] = {
		Level = 197,
		XpToNextLevel = 396,
		MaxCatchWeight = 1970,
	},
	["198"] = {
		Level = 198,
		XpToNextLevel = 400,
		MaxCatchWeight = 1980,
	},
	["199"] = {
		Level = 199,
		XpToNextLevel = 404,
		MaxCatchWeight = 1990,
	},
	["200"] = {
		Level = 200,
		XpToNextLevel = 408,
		MaxCatchWeight = 2000,
	},
	["201"] = {
		Level = 201,
		XpToNextLevel = 413,
		MaxCatchWeight = 2010,
	},
	["202"] = {
		Level = 202,
		XpToNextLevel = 417,
		MaxCatchWeight = 2020,
	},
	["203"] = {
		Level = 203,
		XpToNextLevel = 421,
		MaxCatchWeight = 2030,
	},
	["204"] = {
		Level = 204,
		XpToNextLevel = 426,
		MaxCatchWeight = 2040,
	},
	["205"] = {
		Level = 205,
		XpToNextLevel = 430,
		MaxCatchWeight = 2050,
	},
	["206"] = {
		Level = 206,
		XpToNextLevel = 434,
		MaxCatchWeight = 2060,
	},
	["207"] = {
		Level = 207,
		XpToNextLevel = 439,
		MaxCatchWeight = 2070,
	},
	["208"] = {
		Level = 208,
		XpToNextLevel = 443,
		MaxCatchWeight = 2080,
	},
	["209"] = {
		Level = 209,
		XpToNextLevel = 448,
		MaxCatchWeight = 2090,
	},
	["210"] = {
		Level = 210,
		XpToNextLevel = 452,
		MaxCatchWeight = 2100,
	},
	["211"] = {
		Level = 211,
		XpToNextLevel = 457,
		MaxCatchWeight = 2110,
	},
	["212"] = {
		Level = 212,
		XpToNextLevel = 461,
		MaxCatchWeight = 2120,
	},
	["213"] = {
		Level = 213,
		XpToNextLevel = 466,
		MaxCatchWeight = 2130,
	},
	["214"] = {
		Level = 214,
		XpToNextLevel = 470,
		MaxCatchWeight = 2140,
	},
	["215"] = {
		Level = 215,
		XpToNextLevel = 475,
		MaxCatchWeight = 2150,
	},
	["216"] = {
		Level = 216,
		XpToNextLevel = 480,
		MaxCatchWeight = 2160,
	},
	["217"] = {
		Level = 217,
		XpToNextLevel = 484,
		MaxCatchWeight = 2170,
	},
	["218"] = {
		Level = 218,
		XpToNextLevel = 489,
		MaxCatchWeight = 2180,
	},
	["219"] = {
		Level = 219,
		XpToNextLevel = 494,
		MaxCatchWeight = 2190,
	},
	["220"] = {
		Level = 220,
		XpToNextLevel = 498,
		MaxCatchWeight = 2200,
	},
	["221"] = {
		Level = 221,
		XpToNextLevel = 503,
		MaxCatchWeight = 2210,
	},
	["222"] = {
		Level = 222,
		XpToNextLevel = 508,
		MaxCatchWeight = 2220,
	},
	["223"] = {
		Level = 223,
		XpToNextLevel = 513,
		MaxCatchWeight = 2230,
	},
	["224"] = {
		Level = 224,
		XpToNextLevel = 517,
		MaxCatchWeight = 2240,
	},
	["225"] = {
		Level = 225,
		XpToNextLevel = 522,
		MaxCatchWeight = 2250,
	},
	["226"] = {
		Level = 226,
		XpToNextLevel = 527,
		MaxCatchWeight = 2260,
	},
	["227"] = {
		Level = 227,
		XpToNextLevel = 532,
		MaxCatchWeight = 2270,
	},
	["228"] = {
		Level = 228,
		XpToNextLevel = 537,
		MaxCatchWeight = 2280,
	},
	["229"] = {
		Level = 229,
		XpToNextLevel = 542,
		MaxCatchWeight = 2290,
	},
	["230"] = {
		Level = 230,
		XpToNextLevel = 547,
		MaxCatchWeight = 2300,
	},
	["231"] = {
		Level = 231,
		XpToNextLevel = 552,
		MaxCatchWeight = 2310,
	},
	["232"] = {
		Level = 232,
		XpToNextLevel = 557,
		MaxCatchWeight = 2320,
	},
	["233"] = {
		Level = 233,
		XpToNextLevel = 562,
		MaxCatchWeight = 2330,
	},
	["234"] = {
		Level = 234,
		XpToNextLevel = 567,
		MaxCatchWeight = 2340,
	},
	["235"] = {
		Level = 235,
		XpToNextLevel = 572,
		MaxCatchWeight = 2350,
	},
	["236"] = {
		Level = 236,
		XpToNextLevel = 577,
		MaxCatchWeight = 2360,
	},
	["237"] = {
		Level = 237,
		XpToNextLevel = 582,
		MaxCatchWeight = 2370,
	},
	["238"] = {
		Level = 238,
		XpToNextLevel = 587,
		MaxCatchWeight = 2380,
	},
	["239"] = {
		Level = 239,
		XpToNextLevel = 592,
		MaxCatchWeight = 2390,
	},
	["240"] = {
		Level = 240,
		XpToNextLevel = 598,
		MaxCatchWeight = 2400,
	},
	["241"] = {
		Level = 241,
		XpToNextLevel = 603,
		MaxCatchWeight = 2410,
	},
	["242"] = {
		Level = 242,
		XpToNextLevel = 608,
		MaxCatchWeight = 2420,
	},
	["243"] = {
		Level = 243,
		XpToNextLevel = 613,
		MaxCatchWeight = 2430,
	},
	["244"] = {
		Level = 244,
		XpToNextLevel = 619,
		MaxCatchWeight = 2440,
	},
	["245"] = {
		Level = 245,
		XpToNextLevel = 624,
		MaxCatchWeight = 2450,
	},
	["246"] = {
		Level = 246,
		XpToNextLevel = 629,
		MaxCatchWeight = 2460,
	},
	["247"] = {
		Level = 247,
		XpToNextLevel = 635,
		MaxCatchWeight = 2470,
	},
	["248"] = {
		Level = 248,
		XpToNextLevel = 640,
		MaxCatchWeight = 2480,
	},
	["249"] = {
		Level = 249,
		XpToNextLevel = 645,
		MaxCatchWeight = 2490,
	},
	["250"] = {
		Level = 250,
		XpToNextLevel = 651,
		MaxCatchWeight = 2500,
	},
	["251"] = {
		Level = 251,
		XpToNextLevel = 656,
		MaxCatchWeight = 2510,
	},
	["252"] = {
		Level = 252,
		XpToNextLevel = 662,
		MaxCatchWeight = 2520,
	},
	["253"] = {
		Level = 253,
		XpToNextLevel = 667,
		MaxCatchWeight = 2530,
	},
	["254"] = {
		Level = 254,
		XpToNextLevel = 673,
		MaxCatchWeight = 2540,
	},
	["255"] = {
		Level = 255,
		XpToNextLevel = 678,
		MaxCatchWeight = 2550,
	},
	["256"] = {
		Level = 256,
		XpToNextLevel = 684,
		MaxCatchWeight = 2560,
	},
	["257"] = {
		Level = 257,
		XpToNextLevel = 690,
		MaxCatchWeight = 2570,
	},
	["258"] = {
		Level = 258,
		XpToNextLevel = 695,
		MaxCatchWeight = 2580,
	},
	["259"] = {
		Level = 259,
		XpToNextLevel = 701,
		MaxCatchWeight = 2590,
	},
	["260"] = {
		Level = 260,
		XpToNextLevel = 707,
		MaxCatchWeight = 2600,
	},
	["261"] = {
		Level = 261,
		XpToNextLevel = 712,
		MaxCatchWeight = 2610,
	},
	["262"] = {
		Level = 262,
		XpToNextLevel = 718,
		MaxCatchWeight = 2620,
	},
	["263"] = {
		Level = 263,
		XpToNextLevel = 724,
		MaxCatchWeight = 2630,
	},
	["264"] = {
		Level = 264,
		XpToNextLevel = 730,
		MaxCatchWeight = 2640,
	},
	["265"] = {
		Level = 265,
		XpToNextLevel = 735,
		MaxCatchWeight = 2650,
	},
	["266"] = {
		Level = 266,
		XpToNextLevel = 741,
		MaxCatchWeight = 2660,
	},
	["267"] = {
		Level = 267,
		XpToNextLevel = 747,
		MaxCatchWeight = 2670,
	},
	["268"] = {
		Level = 268,
		XpToNextLevel = 753,
		MaxCatchWeight = 2680,
	},
	["269"] = {
		Level = 269,
		XpToNextLevel = 759,
		MaxCatchWeight = 2690,
	},
	["270"] = {
		Level = 270,
		XpToNextLevel = 765,
		MaxCatchWeight = 2700,
	},
	["271"] = {
		Level = 271,
		XpToNextLevel = 771,
		MaxCatchWeight = 2710,
	},
	["272"] = {
		Level = 272,
		XpToNextLevel = 777,
		MaxCatchWeight = 2720,
	},
	["273"] = {
		Level = 273,
		XpToNextLevel = 783,
		MaxCatchWeight = 2730,
	},
	["274"] = {
		Level = 274,
		XpToNextLevel = 789,
		MaxCatchWeight = 2740,
	},
	["275"] = {
		Level = 275,
		XpToNextLevel = 795,
		MaxCatchWeight = 2750,
	},
	["276"] = {
		Level = 276,
		XpToNextLevel = 801,
		MaxCatchWeight = 2760,
	},
	["277"] = {
		Level = 277,
		XpToNextLevel = 807,
		MaxCatchWeight = 2770,
	},
	["278"] = {
		Level = 278,
		XpToNextLevel = 813,
		MaxCatchWeight = 2780,
	},
	["279"] = {
		Level = 279,
		XpToNextLevel = 819,
		MaxCatchWeight = 2790,
	},
	["280"] = {
		Level = 280,
		XpToNextLevel = 825,
		MaxCatchWeight = 2800,
	},
	["281"] = {
		Level = 281,
		XpToNextLevel = 831,
		MaxCatchWeight = 2810,
	},
	["282"] = {
		Level = 282,
		XpToNextLevel = 838,
		MaxCatchWeight = 2820,
	},
	["283"] = {
		Level = 283,
		XpToNextLevel = 844,
		MaxCatchWeight = 2830,
	},
	["284"] = {
		Level = 284,
		XpToNextLevel = 850,
		MaxCatchWeight = 2840,
	},
	["285"] = {
		Level = 285,
		XpToNextLevel = 856,
		MaxCatchWeight = 2850,
	},
	["286"] = {
		Level = 286,
		XpToNextLevel = 863,
		MaxCatchWeight = 2860,
	},
	["287"] = {
		Level = 287,
		XpToNextLevel = 869,
		MaxCatchWeight = 2870,
	},
	["288"] = {
		Level = 288,
		XpToNextLevel = 875,
		MaxCatchWeight = 2880,
	},
	["289"] = {
		Level = 289,
		XpToNextLevel = 882,
		MaxCatchWeight = 2890,
	},
	["290"] = {
		Level = 290,
		XpToNextLevel = 888,
		MaxCatchWeight = 2900,
	},
	["291"] = {
		Level = 291,
		XpToNextLevel = 895,
		MaxCatchWeight = 2910,
	},
	["292"] = {
		Level = 292,
		XpToNextLevel = 901,
		MaxCatchWeight = 2920,
	},
	["293"] = {
		Level = 293,
		XpToNextLevel = 908,
		MaxCatchWeight = 2930,
	},
	["294"] = {
		Level = 294,
		XpToNextLevel = 914,
		MaxCatchWeight = 2940,
	},
	["295"] = {
		Level = 295,
		XpToNextLevel = 921,
		MaxCatchWeight = 2950,
	},
	["296"] = {
		Level = 296,
		XpToNextLevel = 927,
		MaxCatchWeight = 2960,
	},
	["297"] = {
		Level = 297,
		XpToNextLevel = 934,
		MaxCatchWeight = 2970,
	},
	["298"] = {
		Level = 298,
		XpToNextLevel = 940,
		MaxCatchWeight = 2980,
	},
	["299"] = {
		Level = 299,
		XpToNextLevel = 947,
		MaxCatchWeight = 2990,
	},
	["300"] = {
		Level = 300,
		XpToNextLevel = 954,
		MaxCatchWeight = 3000,
	},
	["301"] = {
		Level = 301,
		XpToNextLevel = 960,
		MaxCatchWeight = 3010,
	},
	["302"] = {
		Level = 302,
		XpToNextLevel = 967,
		MaxCatchWeight = 3020,
	},
	["303"] = {
		Level = 303,
		XpToNextLevel = 974,
		MaxCatchWeight = 3030,
	},
	["304"] = {
		Level = 304,
		XpToNextLevel = 980,
		MaxCatchWeight = 3040,
	},
	["305"] = {
		Level = 305,
		XpToNextLevel = 987,
		MaxCatchWeight = 3050,
	},
	["306"] = {
		Level = 306,
		XpToNextLevel = 994,
		MaxCatchWeight = 3060,
	},
	["307"] = {
		Level = 307,
		XpToNextLevel = 1001,
		MaxCatchWeight = 3070,
	},
	["308"] = {
		Level = 308,
		XpToNextLevel = 1008,
		MaxCatchWeight = 3080,
	},
	["309"] = {
		Level = 309,
		XpToNextLevel = 1015,
		MaxCatchWeight = 3090,
	},
	["310"] = {
		Level = 310,
		XpToNextLevel = 1021,
		MaxCatchWeight = 3100,
	},
	["311"] = {
		Level = 311,
		XpToNextLevel = 1028,
		MaxCatchWeight = 3110,
	},
	["312"] = {
		Level = 312,
		XpToNextLevel = 1035,
		MaxCatchWeight = 3120,
	},
	["313"] = {
		Level = 313,
		XpToNextLevel = 1042,
		MaxCatchWeight = 3130,
	},
	["314"] = {
		Level = 314,
		XpToNextLevel = 1049,
		MaxCatchWeight = 3140,
	},
	["315"] = {
		Level = 315,
		XpToNextLevel = 1056,
		MaxCatchWeight = 3150,
	},
	["316"] = {
		Level = 316,
		XpToNextLevel = 1063,
		MaxCatchWeight = 3160,
	},
	["317"] = {
		Level = 317,
		XpToNextLevel = 1070,
		MaxCatchWeight = 3170,
	},
	["318"] = {
		Level = 318,
		XpToNextLevel = 1077,
		MaxCatchWeight = 3180,
	},
	["319"] = {
		Level = 319,
		XpToNextLevel = 1085,
		MaxCatchWeight = 3190,
	},
	["320"] = {
		Level = 320,
		XpToNextLevel = 1092,
		MaxCatchWeight = 3200,
	},
	["321"] = {
		Level = 321,
		XpToNextLevel = 1099,
		MaxCatchWeight = 3210,
	},
	["322"] = {
		Level = 322,
		XpToNextLevel = 1106,
		MaxCatchWeight = 3220,
	},
	["323"] = {
		Level = 323,
		XpToNextLevel = 1113,
		MaxCatchWeight = 3230,
	},
	["324"] = {
		Level = 324,
		XpToNextLevel = 1121,
		MaxCatchWeight = 3240,
	},
	["325"] = {
		Level = 325,
		XpToNextLevel = 1128,
		MaxCatchWeight = 3250,
	},
	["326"] = {
		Level = 326,
		XpToNextLevel = 1135,
		MaxCatchWeight = 3260,
	},
	["327"] = {
		Level = 327,
		XpToNextLevel = 1142,
		MaxCatchWeight = 3270,
	},
	["328"] = {
		Level = 328,
		XpToNextLevel = 1150,
		MaxCatchWeight = 3280,
	},
	["329"] = {
		Level = 329,
		XpToNextLevel = 1157,
		MaxCatchWeight = 3290,
	},
	["330"] = {
		Level = 330,
		XpToNextLevel = 1164,
		MaxCatchWeight = 3300,
	},
	["331"] = {
		Level = 331,
		XpToNextLevel = 1172,
		MaxCatchWeight = 3310,
	},
	["332"] = {
		Level = 332,
		XpToNextLevel = 1179,
		MaxCatchWeight = 3320,
	},
	["333"] = {
		Level = 333,
		XpToNextLevel = 1187,
		MaxCatchWeight = 3330,
	},
	["334"] = {
		Level = 334,
		XpToNextLevel = 1194,
		MaxCatchWeight = 3340,
	},
	["335"] = {
		Level = 335,
		XpToNextLevel = 1202,
		MaxCatchWeight = 3350,
	},
	["336"] = {
		Level = 336,
		XpToNextLevel = 1209,
		MaxCatchWeight = 3360,
	},
	["337"] = {
		Level = 337,
		XpToNextLevel = 1217,
		MaxCatchWeight = 3370,
	},
	["338"] = {
		Level = 338,
		XpToNextLevel = 1224,
		MaxCatchWeight = 3380,
	},
	["339"] = {
		Level = 339,
		XpToNextLevel = 1232,
		MaxCatchWeight = 3390,
	},
	["340"] = {
		Level = 340,
		XpToNextLevel = 1240,
		MaxCatchWeight = 3400,
	},
	["341"] = {
		Level = 341,
		XpToNextLevel = 1247,
		MaxCatchWeight = 3410,
	},
	["342"] = {
		Level = 342,
		XpToNextLevel = 1255,
		MaxCatchWeight = 3420,
	},
	["343"] = {
		Level = 343,
		XpToNextLevel = 1263,
		MaxCatchWeight = 3430,
	},
	["344"] = {
		Level = 344,
		XpToNextLevel = 1271,
		MaxCatchWeight = 3440,
	},
	["345"] = {
		Level = 345,
		XpToNextLevel = 1278,
		MaxCatchWeight = 3450,
	},
	["346"] = {
		Level = 346,
		XpToNextLevel = 1286,
		MaxCatchWeight = 3460,
	},
	["347"] = {
		Level = 347,
		XpToNextLevel = 1294,
		MaxCatchWeight = 3470,
	},
	["348"] = {
		Level = 348,
		XpToNextLevel = 1302,
		MaxCatchWeight = 3480,
	},
	["349"] = {
		Level = 349,
		XpToNextLevel = 1310,
		MaxCatchWeight = 3490,
	},
	["350"] = {
		Level = 350,
		XpToNextLevel = 1317,
		MaxCatchWeight = 3500,
	},
	["351"] = {
		Level = 351,
		XpToNextLevel = 1325,
		MaxCatchWeight = 3510,
	},
	["352"] = {
		Level = 352,
		XpToNextLevel = 1333,
		MaxCatchWeight = 3520,
	},
	["353"] = {
		Level = 353,
		XpToNextLevel = 1341,
		MaxCatchWeight = 3530,
	},
	["354"] = {
		Level = 354,
		XpToNextLevel = 1349,
		MaxCatchWeight = 3540,
	},
	["355"] = {
		Level = 355,
		XpToNextLevel = 1357,
		MaxCatchWeight = 3550,
	},
	["356"] = {
		Level = 356,
		XpToNextLevel = 1365,
		MaxCatchWeight = 3560,
	},
	["357"] = {
		Level = 357,
		XpToNextLevel = 1373,
		MaxCatchWeight = 3570,
	},
	["358"] = {
		Level = 358,
		XpToNextLevel = 1381,
		MaxCatchWeight = 3580,
	},
	["359"] = {
		Level = 359,
		XpToNextLevel = 1390,
		MaxCatchWeight = 3590,
	},
	["360"] = {
		Level = 360,
		XpToNextLevel = 1398,
		MaxCatchWeight = 3600,
	},
	["361"] = {
		Level = 361,
		XpToNextLevel = 1406,
		MaxCatchWeight = 3610,
	},
	["362"] = {
		Level = 362,
		XpToNextLevel = 1414,
		MaxCatchWeight = 3620,
	},
	["363"] = {
		Level = 363,
		XpToNextLevel = 1422,
		MaxCatchWeight = 3630,
	},
	["364"] = {
		Level = 364,
		XpToNextLevel = 1430,
		MaxCatchWeight = 3640,
	},
	["365"] = {
		Level = 365,
		XpToNextLevel = 1439,
		MaxCatchWeight = 3650,
	},
	["366"] = {
		Level = 366,
		XpToNextLevel = 1447,
		MaxCatchWeight = 3660,
	},
	["367"] = {
		Level = 367,
		XpToNextLevel = 1455,
		MaxCatchWeight = 3670,
	},
	["368"] = {
		Level = 368,
		XpToNextLevel = 1464,
		MaxCatchWeight = 3680,
	},
	["369"] = {
		Level = 369,
		XpToNextLevel = 1472,
		MaxCatchWeight = 3690,
	},
	["370"] = {
		Level = 370,
		XpToNextLevel = 1480,
		MaxCatchWeight = 3700,
	},
	["371"] = {
		Level = 371,
		XpToNextLevel = 1489,
		MaxCatchWeight = 3710,
	},
	["372"] = {
		Level = 372,
		XpToNextLevel = 1497,
		MaxCatchWeight = 3720,
	},
	["373"] = {
		Level = 373,
		XpToNextLevel = 1506,
		MaxCatchWeight = 3730,
	},
	["374"] = {
		Level = 374,
		XpToNextLevel = 1514,
		MaxCatchWeight = 3740,
	},
	["375"] = {
		Level = 375,
		XpToNextLevel = 1523,
		MaxCatchWeight = 3750,
	},
	["376"] = {
		Level = 376,
		XpToNextLevel = 1531,
		MaxCatchWeight = 3760,
	},
	["377"] = {
		Level = 377,
		XpToNextLevel = 1540,
		MaxCatchWeight = 3770,
	},
	["378"] = {
		Level = 378,
		XpToNextLevel = 1548,
		MaxCatchWeight = 3780,
	},
	["379"] = {
		Level = 379,
		XpToNextLevel = 1557,
		MaxCatchWeight = 3790,
	},
	["380"] = {
		Level = 380,
		XpToNextLevel = 1566,
		MaxCatchWeight = 3800,
	},
	["381"] = {
		Level = 381,
		XpToNextLevel = 1574,
		MaxCatchWeight = 3810,
	},
	["382"] = {
		Level = 382,
		XpToNextLevel = 1583,
		MaxCatchWeight = 3820,
	},
	["383"] = {
		Level = 383,
		XpToNextLevel = 1592,
		MaxCatchWeight = 3830,
	},
	["384"] = {
		Level = 384,
		XpToNextLevel = 1600,
		MaxCatchWeight = 3840,
	},
	["385"] = {
		Level = 385,
		XpToNextLevel = 1609,
		MaxCatchWeight = 3850,
	},
	["386"] = {
		Level = 386,
		XpToNextLevel = 1618,
		MaxCatchWeight = 3860,
	},
	["387"] = {
		Level = 387,
		XpToNextLevel = 1627,
		MaxCatchWeight = 3870,
	},
	["388"] = {
		Level = 388,
		XpToNextLevel = 1636,
		MaxCatchWeight = 3880,
	},
	["389"] = {
		Level = 389,
		XpToNextLevel = 1644,
		MaxCatchWeight = 3890,
	},
	["390"] = {
		Level = 390,
		XpToNextLevel = 1653,
		MaxCatchWeight = 3900,
	},
	["391"] = {
		Level = 391,
		XpToNextLevel = 1662,
		MaxCatchWeight = 3910,
	},
	["392"] = {
		Level = 392,
		XpToNextLevel = 1671,
		MaxCatchWeight = 3920,
	},
	["393"] = {
		Level = 393,
		XpToNextLevel = 1680,
		MaxCatchWeight = 3930,
	},
	["394"] = {
		Level = 394,
		XpToNextLevel = 1689,
		MaxCatchWeight = 3940,
	},
	["395"] = {
		Level = 395,
		XpToNextLevel = 1698,
		MaxCatchWeight = 3950,
	},
	["396"] = {
		Level = 396,
		XpToNextLevel = 1707,
		MaxCatchWeight = 3960,
	},
	["397"] = {
		Level = 397,
		XpToNextLevel = 1716,
		MaxCatchWeight = 3970,
	},
	["398"] = {
		Level = 398,
		XpToNextLevel = 1725,
		MaxCatchWeight = 3980,
	},
	["399"] = {
		Level = 399,
		XpToNextLevel = 1734,
		MaxCatchWeight = 3990,
	},
	["400"] = {
		Level = 400,
		XpToNextLevel = 1744,
		MaxCatchWeight = 4000,
	},
	["401"] = {
		Level = 401,
		XpToNextLevel = 1753,
		MaxCatchWeight = 4010,
	},
	["402"] = {
		Level = 402,
		XpToNextLevel = 1762,
		MaxCatchWeight = 4020,
	},
	["403"] = {
		Level = 403,
		XpToNextLevel = 1771,
		MaxCatchWeight = 4030,
	},
	["404"] = {
		Level = 404,
		XpToNextLevel = 1780,
		MaxCatchWeight = 4040,
	},
	["405"] = {
		Level = 405,
		XpToNextLevel = 1790,
		MaxCatchWeight = 4050,
	},
	["406"] = {
		Level = 406,
		XpToNextLevel = 1799,
		MaxCatchWeight = 4060,
	},
	["407"] = {
		Level = 407,
		XpToNextLevel = 1808,
		MaxCatchWeight = 4070,
	},
	["408"] = {
		Level = 408,
		XpToNextLevel = 1818,
		MaxCatchWeight = 4080,
	},
	["409"] = {
		Level = 409,
		XpToNextLevel = 1827,
		MaxCatchWeight = 4090,
	},
	["410"] = {
		Level = 410,
		XpToNextLevel = 1836,
		MaxCatchWeight = 4100,
	},
	["411"] = {
		Level = 411,
		XpToNextLevel = 1846,
		MaxCatchWeight = 4110,
	},
	["412"] = {
		Level = 412,
		XpToNextLevel = 1855,
		MaxCatchWeight = 4120,
	},
	["413"] = {
		Level = 413,
		XpToNextLevel = 1865,
		MaxCatchWeight = 4130,
	},
	["414"] = {
		Level = 414,
		XpToNextLevel = 1874,
		MaxCatchWeight = 4140,
	},
	["415"] = {
		Level = 415,
		XpToNextLevel = 1884,
		MaxCatchWeight = 4150,
	},
	["416"] = {
		Level = 416,
		XpToNextLevel = 1893,
		MaxCatchWeight = 4160,
	},
	["417"] = {
		Level = 417,
		XpToNextLevel = 1903,
		MaxCatchWeight = 4170,
	},
	["418"] = {
		Level = 418,
		XpToNextLevel = 1912,
		MaxCatchWeight = 4180,
	},
	["419"] = {
		Level = 419,
		XpToNextLevel = 1922,
		MaxCatchWeight = 4190,
	},
	["420"] = {
		Level = 420,
		XpToNextLevel = 1932,
		MaxCatchWeight = 4200,
	},
	["421"] = {
		Level = 421,
		XpToNextLevel = 1941,
		MaxCatchWeight = 4210,
	},
	["422"] = {
		Level = 422,
		XpToNextLevel = 1951,
		MaxCatchWeight = 4220,
	},
	["423"] = {
		Level = 423,
		XpToNextLevel = 1961,
		MaxCatchWeight = 4230,
	},
	["424"] = {
		Level = 424,
		XpToNextLevel = 1970,
		MaxCatchWeight = 4240,
	},
	["425"] = {
		Level = 425,
		XpToNextLevel = 1980,
		MaxCatchWeight = 4250,
	},
	["426"] = {
		Level = 426,
		XpToNextLevel = 1990,
		MaxCatchWeight = 4260,
	},
	["427"] = {
		Level = 427,
		XpToNextLevel = 2000,
		MaxCatchWeight = 4270,
	},
	["428"] = {
		Level = 428,
		XpToNextLevel = 2010,
		MaxCatchWeight = 4280,
	},
	["429"] = {
		Level = 429,
		XpToNextLevel = 2020,
		MaxCatchWeight = 4290,
	},
	["430"] = {
		Level = 430,
		XpToNextLevel = 2029,
		MaxCatchWeight = 4300,
	},
	["431"] = {
		Level = 431,
		XpToNextLevel = 2039,
		MaxCatchWeight = 4310,
	},
	["432"] = {
		Level = 432,
		XpToNextLevel = 2049,
		MaxCatchWeight = 4320,
	},
	["433"] = {
		Level = 433,
		XpToNextLevel = 2059,
		MaxCatchWeight = 4330,
	},
	["434"] = {
		Level = 434,
		XpToNextLevel = 2069,
		MaxCatchWeight = 4340,
	},
	["435"] = {
		Level = 435,
		XpToNextLevel = 2079,
		MaxCatchWeight = 4350,
	},
	["436"] = {
		Level = 436,
		XpToNextLevel = 2089,
		MaxCatchWeight = 4360,
	},
	["437"] = {
		Level = 437,
		XpToNextLevel = 2099,
		MaxCatchWeight = 4370,
	},
	["438"] = {
		Level = 438,
		XpToNextLevel = 2110,
		MaxCatchWeight = 4380,
	},
	["439"] = {
		Level = 439,
		XpToNextLevel = 2120,
		MaxCatchWeight = 4390,
	},
	["440"] = {
		Level = 440,
		XpToNextLevel = 2130,
		MaxCatchWeight = 4400,
	},
	["441"] = {
		Level = 441,
		XpToNextLevel = 2140,
		MaxCatchWeight = 4410,
	},
	["442"] = {
		Level = 442,
		XpToNextLevel = 2150,
		MaxCatchWeight = 4420,
	},
	["443"] = {
		Level = 443,
		XpToNextLevel = 2160,
		MaxCatchWeight = 4430,
	},
	["444"] = {
		Level = 444,
		XpToNextLevel = 2171,
		MaxCatchWeight = 4440,
	},
	["445"] = {
		Level = 445,
		XpToNextLevel = 2181,
		MaxCatchWeight = 4450,
	},
	["446"] = {
		Level = 446,
		XpToNextLevel = 2191,
		MaxCatchWeight = 4460,
	},
	["447"] = {
		Level = 447,
		XpToNextLevel = 2202,
		MaxCatchWeight = 4470,
	},
	["448"] = {
		Level = 448,
		XpToNextLevel = 2212,
		MaxCatchWeight = 4480,
	},
	["449"] = {
		Level = 449,
		XpToNextLevel = 2222,
		MaxCatchWeight = 4490,
	},
	["450"] = {
		Level = 450,
		XpToNextLevel = 2233,
		MaxCatchWeight = 4500,
	},
	["451"] = {
		Level = 451,
		XpToNextLevel = 2243,
		MaxCatchWeight = 4510,
	},
	["452"] = {
		Level = 452,
		XpToNextLevel = 2254,
		MaxCatchWeight = 4520,
	},
	["453"] = {
		Level = 453,
		XpToNextLevel = 2264,
		MaxCatchWeight = 4530,
	},
	["454"] = {
		Level = 454,
		XpToNextLevel = 2275,
		MaxCatchWeight = 4540,
	},
	["455"] = {
		Level = 455,
		XpToNextLevel = 2285,
		MaxCatchWeight = 4550,
	},
	["456"] = {
		Level = 456,
		XpToNextLevel = 2296,
		MaxCatchWeight = 4560,
	},
	["457"] = {
		Level = 457,
		XpToNextLevel = 2306,
		MaxCatchWeight = 4570,
	},
	["458"] = {
		Level = 458,
		XpToNextLevel = 2317,
		MaxCatchWeight = 4580,
	},
	["459"] = {
		Level = 459,
		XpToNextLevel = 2328,
		MaxCatchWeight = 4590,
	},
	["460"] = {
		Level = 460,
		XpToNextLevel = 2338,
		MaxCatchWeight = 4600,
	},
	["461"] = {
		Level = 461,
		XpToNextLevel = 2349,
		MaxCatchWeight = 4610,
	},
	["462"] = {
		Level = 462,
		XpToNextLevel = 2360,
		MaxCatchWeight = 4620,
	},
	["463"] = {
		Level = 463,
		XpToNextLevel = 2370,
		MaxCatchWeight = 4630,
	},
	["464"] = {
		Level = 464,
		XpToNextLevel = 2381,
		MaxCatchWeight = 4640,
	},
	["465"] = {
		Level = 465,
		XpToNextLevel = 2392,
		MaxCatchWeight = 4650,
	},
	["466"] = {
		Level = 466,
		XpToNextLevel = 2403,
		MaxCatchWeight = 4660,
	},
	["467"] = {
		Level = 467,
		XpToNextLevel = 2414,
		MaxCatchWeight = 4670,
	},
	["468"] = {
		Level = 468,
		XpToNextLevel = 2424,
		MaxCatchWeight = 4680,
	},
	["469"] = {
		Level = 469,
		XpToNextLevel = 2435,
		MaxCatchWeight = 4690,
	},
	["470"] = {
		Level = 470,
		XpToNextLevel = 2446,
		MaxCatchWeight = 4700,
	},
	["471"] = {
		Level = 471,
		XpToNextLevel = 2457,
		MaxCatchWeight = 4710,
	},
	["472"] = {
		Level = 472,
		XpToNextLevel = 2468,
		MaxCatchWeight = 4720,
	},
	["473"] = {
		Level = 473,
		XpToNextLevel = 2479,
		MaxCatchWeight = 4730,
	},
	["474"] = {
		Level = 474,
		XpToNextLevel = 2490,
		MaxCatchWeight = 4740,
	},
	["475"] = {
		Level = 475,
		XpToNextLevel = 2501,
		MaxCatchWeight = 4750,
	},
	["476"] = {
		Level = 476,
		XpToNextLevel = 2512,
		MaxCatchWeight = 4760,
	},
	["477"] = {
		Level = 477,
		XpToNextLevel = 2523,
		MaxCatchWeight = 4770,
	},
	["478"] = {
		Level = 478,
		XpToNextLevel = 2535,
		MaxCatchWeight = 4780,
	},
	["479"] = {
		Level = 479,
		XpToNextLevel = 2546,
		MaxCatchWeight = 4790,
	},
	["480"] = {
		Level = 480,
		XpToNextLevel = 2557,
		MaxCatchWeight = 4800,
	},
	["481"] = {
		Level = 481,
		XpToNextLevel = 2568,
		MaxCatchWeight = 4810,
	},
	["482"] = {
		Level = 482,
		XpToNextLevel = 2579,
		MaxCatchWeight = 4820,
	},
	["483"] = {
		Level = 483,
		XpToNextLevel = 2591,
		MaxCatchWeight = 4830,
	},
	["484"] = {
		Level = 484,
		XpToNextLevel = 2602,
		MaxCatchWeight = 4840,
	},
	["485"] = {
		Level = 485,
		XpToNextLevel = 2613,
		MaxCatchWeight = 4850,
	},
	["486"] = {
		Level = 486,
		XpToNextLevel = 2624,
		MaxCatchWeight = 4860,
	},
	["487"] = {
		Level = 487,
		XpToNextLevel = 2636,
		MaxCatchWeight = 4870,
	},
	["488"] = {
		Level = 488,
		XpToNextLevel = 2647,
		MaxCatchWeight = 4880,
	},
	["489"] = {
		Level = 489,
		XpToNextLevel = 2659,
		MaxCatchWeight = 4890,
	},
	["490"] = {
		Level = 490,
		XpToNextLevel = 2670,
		MaxCatchWeight = 4900,
	},
	["491"] = {
		Level = 491,
		XpToNextLevel = 2681,
		MaxCatchWeight = 4910,
	},
	["492"] = {
		Level = 492,
		XpToNextLevel = 2693,
		MaxCatchWeight = 4920,
	},
	["493"] = {
		Level = 493,
		XpToNextLevel = 2704,
		MaxCatchWeight = 4930,
	},
	["494"] = {
		Level = 494,
		XpToNextLevel = 2716,
		MaxCatchWeight = 4940,
	},
	["495"] = {
		Level = 495,
		XpToNextLevel = 2728,
		MaxCatchWeight = 4950,
	},
	["496"] = {
		Level = 496,
		XpToNextLevel = 2739,
		MaxCatchWeight = 4960,
	},
	["497"] = {
		Level = 497,
		XpToNextLevel = 2751,
		MaxCatchWeight = 4970,
	},
	["498"] = {
		Level = 498,
		XpToNextLevel = 2762,
		MaxCatchWeight = 4980,
	},
	["499"] = {
		Level = 499,
		XpToNextLevel = 2774,
		MaxCatchWeight = 4990,
	},
	["500"] = {
		Level = 500,
		XpToNextLevel = 2786,
		MaxCatchWeight = 5000,
	},
	["501"] = {
		Level = 501,
		XpToNextLevel = 2797,
		MaxCatchWeight = 5010,
	},
	["502"] = {
		Level = 502,
		XpToNextLevel = 2809,
		MaxCatchWeight = 5020,
	},
	["503"] = {
		Level = 503,
		XpToNextLevel = 2821,
		MaxCatchWeight = 5030,
	},
	["504"] = {
		Level = 504,
		XpToNextLevel = 2833,
		MaxCatchWeight = 5040,
	},
	["505"] = {
		Level = 505,
		XpToNextLevel = 2845,
		MaxCatchWeight = 5050,
	},
	["506"] = {
		Level = 506,
		XpToNextLevel = 2856,
		MaxCatchWeight = 5060,
	},
	["507"] = {
		Level = 507,
		XpToNextLevel = 2868,
		MaxCatchWeight = 5070,
	},
	["508"] = {
		Level = 508,
		XpToNextLevel = 2880,
		MaxCatchWeight = 5080,
	},
	["509"] = {
		Level = 509,
		XpToNextLevel = 2892,
		MaxCatchWeight = 5090,
	},
	["510"] = {
		Level = 510,
		XpToNextLevel = 2904,
		MaxCatchWeight = 5100,
	},
	["511"] = {
		Level = 511,
		XpToNextLevel = 2916,
		MaxCatchWeight = 5110,
	},
	["512"] = {
		Level = 512,
		XpToNextLevel = 2928,
		MaxCatchWeight = 5120,
	},
	["513"] = {
		Level = 513,
		XpToNextLevel = 2940,
		MaxCatchWeight = 5130,
	},
	["514"] = {
		Level = 514,
		XpToNextLevel = 2952,
		MaxCatchWeight = 5140,
	},
	["515"] = {
		Level = 515,
		XpToNextLevel = 2964,
		MaxCatchWeight = 5150,
	},
	["516"] = {
		Level = 516,
		XpToNextLevel = 2976,
		MaxCatchWeight = 5160,
	},
	["517"] = {
		Level = 517,
		XpToNextLevel = 2988,
		MaxCatchWeight = 5170,
	},
	["518"] = {
		Level = 518,
		XpToNextLevel = 3001,
		MaxCatchWeight = 5180,
	},
	["519"] = {
		Level = 519,
		XpToNextLevel = 3013,
		MaxCatchWeight = 5190,
	},
	["520"] = {
		Level = 520,
		XpToNextLevel = 3025,
		MaxCatchWeight = 5200,
	},
	["521"] = {
		Level = 521,
		XpToNextLevel = 3037,
		MaxCatchWeight = 5210,
	},
	["522"] = {
		Level = 522,
		XpToNextLevel = 3049,
		MaxCatchWeight = 5220,
	},
	["523"] = {
		Level = 523,
		XpToNextLevel = 3062,
		MaxCatchWeight = 5230,
	},
	["524"] = {
		Level = 524,
		XpToNextLevel = 3074,
		MaxCatchWeight = 5240,
	},
	["525"] = {
		Level = 525,
		XpToNextLevel = 3086,
		MaxCatchWeight = 5250,
	},
	["526"] = {
		Level = 526,
		XpToNextLevel = 3099,
		MaxCatchWeight = 5260,
	},
	["527"] = {
		Level = 527,
		XpToNextLevel = 3111,
		MaxCatchWeight = 5270,
	},
	["528"] = {
		Level = 528,
		XpToNextLevel = 3124,
		MaxCatchWeight = 5280,
	},
	["529"] = {
		Level = 529,
		XpToNextLevel = 3136,
		MaxCatchWeight = 5290,
	},
	["530"] = {
		Level = 530,
		XpToNextLevel = 3148,
		MaxCatchWeight = 5300,
	},
	["531"] = {
		Level = 531,
		XpToNextLevel = 3161,
		MaxCatchWeight = 5310,
	},
	["532"] = {
		Level = 532,
		XpToNextLevel = 3173,
		MaxCatchWeight = 5320,
	},
	["533"] = {
		Level = 533,
		XpToNextLevel = 3186,
		MaxCatchWeight = 5330,
	},
	["534"] = {
		Level = 534,
		XpToNextLevel = 3199,
		MaxCatchWeight = 5340,
	},
	["535"] = {
		Level = 535,
		XpToNextLevel = 3211,
		MaxCatchWeight = 5350,
	},
	["536"] = {
		Level = 536,
		XpToNextLevel = 3224,
		MaxCatchWeight = 5360,
	},
	["537"] = {
		Level = 537,
		XpToNextLevel = 3236,
		MaxCatchWeight = 5370,
	},
	["538"] = {
		Level = 538,
		XpToNextLevel = 3249,
		MaxCatchWeight = 5380,
	},
	["539"] = {
		Level = 539,
		XpToNextLevel = 3262,
		MaxCatchWeight = 5390,
	},
	["540"] = {
		Level = 540,
		XpToNextLevel = 3275,
		MaxCatchWeight = 5400,
	},
	["541"] = {
		Level = 541,
		XpToNextLevel = 3287,
		MaxCatchWeight = 5410,
	},
	["542"] = {
		Level = 542,
		XpToNextLevel = 3300,
		MaxCatchWeight = 5420,
	},
	["543"] = {
		Level = 543,
		XpToNextLevel = 3313,
		MaxCatchWeight = 5430,
	},
	["544"] = {
		Level = 544,
		XpToNextLevel = 3326,
		MaxCatchWeight = 5440,
	},
	["545"] = {
		Level = 545,
		XpToNextLevel = 3339,
		MaxCatchWeight = 5450,
	},
	["546"] = {
		Level = 546,
		XpToNextLevel = 3351,
		MaxCatchWeight = 5460,
	},
	["547"] = {
		Level = 547,
		XpToNextLevel = 3364,
		MaxCatchWeight = 5470,
	},
	["548"] = {
		Level = 548,
		XpToNextLevel = 3377,
		MaxCatchWeight = 5480,
	},
	["549"] = {
		Level = 549,
		XpToNextLevel = 3390,
		MaxCatchWeight = 5490,
	},
	["550"] = {
		Level = 550,
		XpToNextLevel = 3403,
		MaxCatchWeight = 5500,
	},
	["551"] = {
		Level = 551,
		XpToNextLevel = 3416,
		MaxCatchWeight = 5510,
	},
	["552"] = {
		Level = 552,
		XpToNextLevel = 3429,
		MaxCatchWeight = 5520,
	},
	["553"] = {
		Level = 553,
		XpToNextLevel = 3442,
		MaxCatchWeight = 5530,
	},
	["554"] = {
		Level = 554,
		XpToNextLevel = 3455,
		MaxCatchWeight = 5540,
	},
	["555"] = {
		Level = 555,
		XpToNextLevel = 3469,
		MaxCatchWeight = 5550,
	},
	["556"] = {
		Level = 556,
		XpToNextLevel = 3482,
		MaxCatchWeight = 5560,
	},
	["557"] = {
		Level = 557,
		XpToNextLevel = 3495,
		MaxCatchWeight = 5570,
	},
	["558"] = {
		Level = 558,
		XpToNextLevel = 3508,
		MaxCatchWeight = 5580,
	},
	["559"] = {
		Level = 559,
		XpToNextLevel = 3521,
		MaxCatchWeight = 5590,
	},
	["560"] = {
		Level = 560,
		XpToNextLevel = 3535,
		MaxCatchWeight = 5600,
	},
	["561"] = {
		Level = 561,
		XpToNextLevel = 3548,
		MaxCatchWeight = 5610,
	},
	["562"] = {
		Level = 562,
		XpToNextLevel = 3561,
		MaxCatchWeight = 5620,
	},
	["563"] = {
		Level = 563,
		XpToNextLevel = 3574,
		MaxCatchWeight = 5630,
	},
	["564"] = {
		Level = 564,
		XpToNextLevel = 3588,
		MaxCatchWeight = 5640,
	},
	["565"] = {
		Level = 565,
		XpToNextLevel = 3601,
		MaxCatchWeight = 5650,
	},
	["566"] = {
		Level = 566,
		XpToNextLevel = 3615,
		MaxCatchWeight = 5660,
	},
	["567"] = {
		Level = 567,
		XpToNextLevel = 3628,
		MaxCatchWeight = 5670,
	},
	["568"] = {
		Level = 568,
		XpToNextLevel = 3641,
		MaxCatchWeight = 5680,
	},
	["569"] = {
		Level = 569,
		XpToNextLevel = 3655,
		MaxCatchWeight = 5690,
	},
	["570"] = {
		Level = 570,
		XpToNextLevel = 3668,
		MaxCatchWeight = 5700,
	},
	["571"] = {
		Level = 571,
		XpToNextLevel = 3682,
		MaxCatchWeight = 5710,
	},
	["572"] = {
		Level = 572,
		XpToNextLevel = 3696,
		MaxCatchWeight = 5720,
	},
	["573"] = {
		Level = 573,
		XpToNextLevel = 3709,
		MaxCatchWeight = 5730,
	},
	["574"] = {
		Level = 574,
		XpToNextLevel = 3723,
		MaxCatchWeight = 5740,
	},
	["575"] = {
		Level = 575,
		XpToNextLevel = 3736,
		MaxCatchWeight = 5750,
	},
	["576"] = {
		Level = 576,
		XpToNextLevel = 3750,
		MaxCatchWeight = 5760,
	},
	["577"] = {
		Level = 577,
		XpToNextLevel = 3764,
		MaxCatchWeight = 5770,
	},
	["578"] = {
		Level = 578,
		XpToNextLevel = 3777,
		MaxCatchWeight = 5780,
	},
	["579"] = {
		Level = 579,
		XpToNextLevel = 3791,
		MaxCatchWeight = 5790,
	},
	["580"] = {
		Level = 580,
		XpToNextLevel = 3805,
		MaxCatchWeight = 5800,
	},
	["581"] = {
		Level = 581,
		XpToNextLevel = 3819,
		MaxCatchWeight = 5810,
	},
	["582"] = {
		Level = 582,
		XpToNextLevel = 3833,
		MaxCatchWeight = 5820,
	},
	["583"] = {
		Level = 583,
		XpToNextLevel = 3846,
		MaxCatchWeight = 5830,
	},
	["584"] = {
		Level = 584,
		XpToNextLevel = 3860,
		MaxCatchWeight = 5840,
	},
	["585"] = {
		Level = 585,
		XpToNextLevel = 3874,
		MaxCatchWeight = 5850,
	},
	["586"] = {
		Level = 586,
		XpToNextLevel = 3888,
		MaxCatchWeight = 5860,
	},
	["587"] = {
		Level = 587,
		XpToNextLevel = 3902,
		MaxCatchWeight = 5870,
	},
	["588"] = {
		Level = 588,
		XpToNextLevel = 3916,
		MaxCatchWeight = 5880,
	},
	["589"] = {
		Level = 589,
		XpToNextLevel = 3930,
		MaxCatchWeight = 5890,
	},
	["590"] = {
		Level = 590,
		XpToNextLevel = 3944,
		MaxCatchWeight = 5900,
	},
	["591"] = {
		Level = 591,
		XpToNextLevel = 3958,
		MaxCatchWeight = 5910,
	},
	["592"] = {
		Level = 592,
		XpToNextLevel = 3972,
		MaxCatchWeight = 5920,
	},
	["593"] = {
		Level = 593,
		XpToNextLevel = 3986,
		MaxCatchWeight = 5930,
	},
	["594"] = {
		Level = 594,
		XpToNextLevel = 4000,
		MaxCatchWeight = 5940,
	},
	["595"] = {
		Level = 595,
		XpToNextLevel = 4015,
		MaxCatchWeight = 5950,
	},
	["596"] = {
		Level = 596,
		XpToNextLevel = 4029,
		MaxCatchWeight = 5960,
	},
	["597"] = {
		Level = 597,
		XpToNextLevel = 4043,
		MaxCatchWeight = 5970,
	},
	["598"] = {
		Level = 598,
		XpToNextLevel = 4057,
		MaxCatchWeight = 5980,
	},
	["599"] = {
		Level = 599,
		XpToNextLevel = 4072,
		MaxCatchWeight = 5990,
	},
	["600"] = {
		Level = 600,
		XpToNextLevel = 4086,
		MaxCatchWeight = 6000,
	},
	["601"] = {
		Level = 601,
		XpToNextLevel = 4100,
		MaxCatchWeight = 6010,
	},
	["602"] = {
		Level = 602,
		XpToNextLevel = 4114,
		MaxCatchWeight = 6020,
	},
	["603"] = {
		Level = 603,
		XpToNextLevel = 4129,
		MaxCatchWeight = 6030,
	},
	["604"] = {
		Level = 604,
		XpToNextLevel = 4143,
		MaxCatchWeight = 6040,
	},
	["605"] = {
		Level = 605,
		XpToNextLevel = 4158,
		MaxCatchWeight = 6050,
	},
	["606"] = {
		Level = 606,
		XpToNextLevel = 4172,
		MaxCatchWeight = 6060,
	},
	["607"] = {
		Level = 607,
		XpToNextLevel = 4187,
		MaxCatchWeight = 6070,
	},
	["608"] = {
		Level = 608,
		XpToNextLevel = 4201,
		MaxCatchWeight = 6080,
	},
	["609"] = {
		Level = 609,
		XpToNextLevel = 4216,
		MaxCatchWeight = 6090,
	},
	["610"] = {
		Level = 610,
		XpToNextLevel = 4230,
		MaxCatchWeight = 6100,
	},
	["611"] = {
		Level = 611,
		XpToNextLevel = 4245,
		MaxCatchWeight = 6110,
	},
	["612"] = {
		Level = 612,
		XpToNextLevel = 4259,
		MaxCatchWeight = 6120,
	},
	["613"] = {
		Level = 613,
		XpToNextLevel = 4274,
		MaxCatchWeight = 6130,
	},
	["614"] = {
		Level = 614,
		XpToNextLevel = 4289,
		MaxCatchWeight = 6140,
	},
	["615"] = {
		Level = 615,
		XpToNextLevel = 4303,
		MaxCatchWeight = 6150,
	},
	["616"] = {
		Level = 616,
		XpToNextLevel = 4318,
		MaxCatchWeight = 6160,
	},
	["617"] = {
		Level = 617,
		XpToNextLevel = 4333,
		MaxCatchWeight = 6170,
	},
	["618"] = {
		Level = 618,
		XpToNextLevel = 4348,
		MaxCatchWeight = 6180,
	},
	["619"] = {
		Level = 619,
		XpToNextLevel = 4362,
		MaxCatchWeight = 6190,
	},
	["620"] = {
		Level = 620,
		XpToNextLevel = 4377,
		MaxCatchWeight = 6200,
	},
	["621"] = {
		Level = 621,
		XpToNextLevel = 4392,
		MaxCatchWeight = 6210,
	},
	["622"] = {
		Level = 622,
		XpToNextLevel = 4407,
		MaxCatchWeight = 6220,
	},
	["623"] = {
		Level = 623,
		XpToNextLevel = 4422,
		MaxCatchWeight = 6230,
	},
	["624"] = {
		Level = 624,
		XpToNextLevel = 4437,
		MaxCatchWeight = 6240,
	},
	["625"] = {
		Level = 625,
		XpToNextLevel = 4452,
		MaxCatchWeight = 6250,
	},
	["626"] = {
		Level = 626,
		XpToNextLevel = 4467,
		MaxCatchWeight = 6260,
	},
	["627"] = {
		Level = 627,
		XpToNextLevel = 4482,
		MaxCatchWeight = 6270,
	},
	["628"] = {
		Level = 628,
		XpToNextLevel = 4497,
		MaxCatchWeight = 6280,
	},
	["629"] = {
		Level = 629,
		XpToNextLevel = 4512,
		MaxCatchWeight = 6290,
	},
	["630"] = {
		Level = 630,
		XpToNextLevel = 4527,
		MaxCatchWeight = 6300,
	},
	["631"] = {
		Level = 631,
		XpToNextLevel = 4542,
		MaxCatchWeight = 6310,
	},
	["632"] = {
		Level = 632,
		XpToNextLevel = 4557,
		MaxCatchWeight = 6320,
	},
	["633"] = {
		Level = 633,
		XpToNextLevel = 4572,
		MaxCatchWeight = 6330,
	},
	["634"] = {
		Level = 634,
		XpToNextLevel = 4587,
		MaxCatchWeight = 6340,
	},
	["635"] = {
		Level = 635,
		XpToNextLevel = 4603,
		MaxCatchWeight = 6350,
	},
	["636"] = {
		Level = 636,
		XpToNextLevel = 4618,
		MaxCatchWeight = 6360,
	},
	["637"] = {
		Level = 637,
		XpToNextLevel = 4633,
		MaxCatchWeight = 6370,
	},
	["638"] = {
		Level = 638,
		XpToNextLevel = 4648,
		MaxCatchWeight = 6380,
	},
	["639"] = {
		Level = 639,
		XpToNextLevel = 4664,
		MaxCatchWeight = 6390,
	},
	["640"] = {
		Level = 640,
		XpToNextLevel = 4679,
		MaxCatchWeight = 6400,
	},
	["641"] = {
		Level = 641,
		XpToNextLevel = 4695,
		MaxCatchWeight = 6410,
	},
	["642"] = {
		Level = 642,
		XpToNextLevel = 4710,
		MaxCatchWeight = 6420,
	},
	["643"] = {
		Level = 643,
		XpToNextLevel = 4725,
		MaxCatchWeight = 6430,
	},
	["644"] = {
		Level = 644,
		XpToNextLevel = 4741,
		MaxCatchWeight = 6440,
	},
	["645"] = {
		Level = 645,
		XpToNextLevel = 4756,
		MaxCatchWeight = 6450,
	},
	["646"] = {
		Level = 646,
		XpToNextLevel = 4772,
		MaxCatchWeight = 6460,
	},
	["647"] = {
		Level = 647,
		XpToNextLevel = 4787,
		MaxCatchWeight = 6470,
	},
	["648"] = {
		Level = 648,
		XpToNextLevel = 4803,
		MaxCatchWeight = 6480,
	},
	["649"] = {
		Level = 649,
		XpToNextLevel = 4818,
		MaxCatchWeight = 6490,
	},
	["650"] = {
		Level = 650,
		XpToNextLevel = 4834,
		MaxCatchWeight = 6500,
	},
	["651"] = {
		Level = 651,
		XpToNextLevel = 4850,
		MaxCatchWeight = 6510,
	},
	["652"] = {
		Level = 652,
		XpToNextLevel = 4865,
		MaxCatchWeight = 6520,
	},
	["653"] = {
		Level = 653,
		XpToNextLevel = 4881,
		MaxCatchWeight = 6530,
	},
	["654"] = {
		Level = 654,
		XpToNextLevel = 4897,
		MaxCatchWeight = 6540,
	},
	["655"] = {
		Level = 655,
		XpToNextLevel = 4913,
		MaxCatchWeight = 6550,
	},
	["656"] = {
		Level = 656,
		XpToNextLevel = 4928,
		MaxCatchWeight = 6560,
	},
	["657"] = {
		Level = 657,
		XpToNextLevel = 4944,
		MaxCatchWeight = 6570,
	},
	["658"] = {
		Level = 658,
		XpToNextLevel = 4960,
		MaxCatchWeight = 6580,
	},
	["659"] = {
		Level = 659,
		XpToNextLevel = 4976,
		MaxCatchWeight = 6590,
	},
	["660"] = {
		Level = 660,
		XpToNextLevel = 4992,
		MaxCatchWeight = 6600,
	},
	["661"] = {
		Level = 661,
		XpToNextLevel = 5008,
		MaxCatchWeight = 6610,
	},
	["662"] = {
		Level = 662,
		XpToNextLevel = 5024,
		MaxCatchWeight = 6620,
	},
	["663"] = {
		Level = 663,
		XpToNextLevel = 5039,
		MaxCatchWeight = 6630,
	},
	["664"] = {
		Level = 664,
		XpToNextLevel = 5055,
		MaxCatchWeight = 6640,
	},
	["665"] = {
		Level = 665,
		XpToNextLevel = 5071,
		MaxCatchWeight = 6650,
	},
	["666"] = {
		Level = 666,
		XpToNextLevel = 5087,
		MaxCatchWeight = 6660,
	},
	["667"] = {
		Level = 667,
		XpToNextLevel = 5104,
		MaxCatchWeight = 6670,
	},
	["668"] = {
		Level = 668,
		XpToNextLevel = 5120,
		MaxCatchWeight = 6680,
	},
	["669"] = {
		Level = 669,
		XpToNextLevel = 5136,
		MaxCatchWeight = 6690,
	},
	["670"] = {
		Level = 670,
		XpToNextLevel = 5152,
		MaxCatchWeight = 6700,
	},
	["671"] = {
		Level = 671,
		XpToNextLevel = 5168,
		MaxCatchWeight = 6710,
	},
	["672"] = {
		Level = 672,
		XpToNextLevel = 5184,
		MaxCatchWeight = 6720,
	},
	["673"] = {
		Level = 673,
		XpToNextLevel = 5200,
		MaxCatchWeight = 6730,
	},
	["674"] = {
		Level = 674,
		XpToNextLevel = 5217,
		MaxCatchWeight = 6740,
	},
	["675"] = {
		Level = 675,
		XpToNextLevel = 5233,
		MaxCatchWeight = 6750,
	},
	["676"] = {
		Level = 676,
		XpToNextLevel = 5249,
		MaxCatchWeight = 6760,
	},
	["677"] = {
		Level = 677,
		XpToNextLevel = 5266,
		MaxCatchWeight = 6770,
	},
	["678"] = {
		Level = 678,
		XpToNextLevel = 5282,
		MaxCatchWeight = 6780,
	},
	["679"] = {
		Level = 679,
		XpToNextLevel = 5298,
		MaxCatchWeight = 6790,
	},
	["680"] = {
		Level = 680,
		XpToNextLevel = 5315,
		MaxCatchWeight = 6800,
	},
	["681"] = {
		Level = 681,
		XpToNextLevel = 5331,
		MaxCatchWeight = 6810,
	},
	["682"] = {
		Level = 682,
		XpToNextLevel = 5348,
		MaxCatchWeight = 6820,
	},
	["683"] = {
		Level = 683,
		XpToNextLevel = 5364,
		MaxCatchWeight = 6830,
	},
	["684"] = {
		Level = 684,
		XpToNextLevel = 5381,
		MaxCatchWeight = 6840,
	},
	["685"] = {
		Level = 685,
		XpToNextLevel = 5397,
		MaxCatchWeight = 6850,
	},
	["686"] = {
		Level = 686,
		XpToNextLevel = 5414,
		MaxCatchWeight = 6860,
	},
	["687"] = {
		Level = 687,
		XpToNextLevel = 5430,
		MaxCatchWeight = 6870,
	},
	["688"] = {
		Level = 688,
		XpToNextLevel = 5447,
		MaxCatchWeight = 6880,
	},
	["689"] = {
		Level = 689,
		XpToNextLevel = 5464,
		MaxCatchWeight = 6890,
	},
	["690"] = {
		Level = 690,
		XpToNextLevel = 5480,
		MaxCatchWeight = 6900,
	},
	["691"] = {
		Level = 691,
		XpToNextLevel = 5497,
		MaxCatchWeight = 6910,
	},
	["692"] = {
		Level = 692,
		XpToNextLevel = 5514,
		MaxCatchWeight = 6920,
	},
	["693"] = {
		Level = 693,
		XpToNextLevel = 5531,
		MaxCatchWeight = 6930,
	},
	["694"] = {
		Level = 694,
		XpToNextLevel = 5547,
		MaxCatchWeight = 6940,
	},
	["695"] = {
		Level = 695,
		XpToNextLevel = 5564,
		MaxCatchWeight = 6950,
	},
	["696"] = {
		Level = 696,
		XpToNextLevel = 5581,
		MaxCatchWeight = 6960,
	},
	["697"] = {
		Level = 697,
		XpToNextLevel = 5598,
		MaxCatchWeight = 6970,
	},
	["698"] = {
		Level = 698,
		XpToNextLevel = 5615,
		MaxCatchWeight = 6980,
	},
	["699"] = {
		Level = 699,
		XpToNextLevel = 5632,
		MaxCatchWeight = 6990,
	},
	["700"] = {
		Level = 700,
		XpToNextLevel = 5649,
		MaxCatchWeight = 7000,
	},
	["701"] = {
		Level = 701,
		XpToNextLevel = 5666,
		MaxCatchWeight = 7010,
	},
	["702"] = {
		Level = 702,
		XpToNextLevel = 5683,
		MaxCatchWeight = 7020,
	},
	["703"] = {
		Level = 703,
		XpToNextLevel = 5700,
		MaxCatchWeight = 7030,
	},
	["704"] = {
		Level = 704,
		XpToNextLevel = 5717,
		MaxCatchWeight = 7040,
	},
	["705"] = {
		Level = 705,
		XpToNextLevel = 5734,
		MaxCatchWeight = 7050,
	},
	["706"] = {
		Level = 706,
		XpToNextLevel = 5751,
		MaxCatchWeight = 7060,
	},
	["707"] = {
		Level = 707,
		XpToNextLevel = 5768,
		MaxCatchWeight = 7070,
	},
	["708"] = {
		Level = 708,
		XpToNextLevel = 5785,
		MaxCatchWeight = 7080,
	},
	["709"] = {
		Level = 709,
		XpToNextLevel = 5802,
		MaxCatchWeight = 7090,
	},
	["710"] = {
		Level = 710,
		XpToNextLevel = 5819,
		MaxCatchWeight = 7100,
	},
	["711"] = {
		Level = 711,
		XpToNextLevel = 5837,
		MaxCatchWeight = 7110,
	},
	["712"] = {
		Level = 712,
		XpToNextLevel = 5854,
		MaxCatchWeight = 7120,
	},
	["713"] = {
		Level = 713,
		XpToNextLevel = 5871,
		MaxCatchWeight = 7130,
	},
	["714"] = {
		Level = 714,
		XpToNextLevel = 5889,
		MaxCatchWeight = 7140,
	},
	["715"] = {
		Level = 715,
		XpToNextLevel = 5906,
		MaxCatchWeight = 7150,
	},
	["716"] = {
		Level = 716,
		XpToNextLevel = 5923,
		MaxCatchWeight = 7160,
	},
	["717"] = {
		Level = 717,
		XpToNextLevel = 5941,
		MaxCatchWeight = 7170,
	},
	["718"] = {
		Level = 718,
		XpToNextLevel = 5958,
		MaxCatchWeight = 7180,
	},
	["719"] = {
		Level = 719,
		XpToNextLevel = 5976,
		MaxCatchWeight = 7190,
	},
	["720"] = {
		Level = 720,
		XpToNextLevel = 5993,
		MaxCatchWeight = 7200,
	},
	["721"] = {
		Level = 721,
		XpToNextLevel = 6011,
		MaxCatchWeight = 7210,
	},
	["722"] = {
		Level = 722,
		XpToNextLevel = 6028,
		MaxCatchWeight = 7220,
	},
	["723"] = {
		Level = 723,
		XpToNextLevel = 6046,
		MaxCatchWeight = 7230,
	},
	["724"] = {
		Level = 724,
		XpToNextLevel = 6063,
		MaxCatchWeight = 7240,
	},
	["725"] = {
		Level = 725,
		XpToNextLevel = 6081,
		MaxCatchWeight = 7250,
	},
	["726"] = {
		Level = 726,
		XpToNextLevel = 6098,
		MaxCatchWeight = 7260,
	},
	["727"] = {
		Level = 727,
		XpToNextLevel = 6116,
		MaxCatchWeight = 7270,
	},
	["728"] = {
		Level = 728,
		XpToNextLevel = 6134,
		MaxCatchWeight = 7280,
	},
	["729"] = {
		Level = 729,
		XpToNextLevel = 6151,
		MaxCatchWeight = 7290,
	},
	["730"] = {
		Level = 730,
		XpToNextLevel = 6169,
		MaxCatchWeight = 7300,
	},
	["731"] = {
		Level = 731,
		XpToNextLevel = 6187,
		MaxCatchWeight = 7310,
	},
	["732"] = {
		Level = 732,
		XpToNextLevel = 6205,
		MaxCatchWeight = 7320,
	},
	["733"] = {
		Level = 733,
		XpToNextLevel = 6223,
		MaxCatchWeight = 7330,
	},
	["734"] = {
		Level = 734,
		XpToNextLevel = 6240,
		MaxCatchWeight = 7340,
	},
	["735"] = {
		Level = 735,
		XpToNextLevel = 6258,
		MaxCatchWeight = 7350,
	},
	["736"] = {
		Level = 736,
		XpToNextLevel = 6276,
		MaxCatchWeight = 7360,
	},
	["737"] = {
		Level = 737,
		XpToNextLevel = 6294,
		MaxCatchWeight = 7370,
	},
	["738"] = {
		Level = 738,
		XpToNextLevel = 6312,
		MaxCatchWeight = 7380,
	},
	["739"] = {
		Level = 739,
		XpToNextLevel = 6330,
		MaxCatchWeight = 7390,
	},
	["740"] = {
		Level = 740,
		XpToNextLevel = 6348,
		MaxCatchWeight = 7400,
	},
	["741"] = {
		Level = 741,
		XpToNextLevel = 6366,
		MaxCatchWeight = 7410,
	},
	["742"] = {
		Level = 742,
		XpToNextLevel = 6384,
		MaxCatchWeight = 7420,
	},
	["743"] = {
		Level = 743,
		XpToNextLevel = 6402,
		MaxCatchWeight = 7430,
	},
	["744"] = {
		Level = 744,
		XpToNextLevel = 6420,
		MaxCatchWeight = 7440,
	},
	["745"] = {
		Level = 745,
		XpToNextLevel = 6439,
		MaxCatchWeight = 7450,
	},
	["746"] = {
		Level = 746,
		XpToNextLevel = 6457,
		MaxCatchWeight = 7460,
	},
	["747"] = {
		Level = 747,
		XpToNextLevel = 6475,
		MaxCatchWeight = 7470,
	},
	["748"] = {
		Level = 748,
		XpToNextLevel = 6493,
		MaxCatchWeight = 7480,
	},
	["749"] = {
		Level = 749,
		XpToNextLevel = 6511,
		MaxCatchWeight = 7490,
	},
	["750"] = {
		Level = 750,
		XpToNextLevel = 6530,
		MaxCatchWeight = 7500,
	},
	["751"] = {
		Level = 751,
		XpToNextLevel = 6548,
		MaxCatchWeight = 7510,
	},
	["752"] = {
		Level = 752,
		XpToNextLevel = 6566,
		MaxCatchWeight = 7520,
	},
	["753"] = {
		Level = 753,
		XpToNextLevel = 6585,
		MaxCatchWeight = 7530,
	},
	["754"] = {
		Level = 754,
		XpToNextLevel = 6603,
		MaxCatchWeight = 7540,
	},
	["755"] = {
		Level = 755,
		XpToNextLevel = 6622,
		MaxCatchWeight = 7550,
	},
	["756"] = {
		Level = 756,
		XpToNextLevel = 6640,
		MaxCatchWeight = 7560,
	},
	["757"] = {
		Level = 757,
		XpToNextLevel = 6658,
		MaxCatchWeight = 7570,
	},
	["758"] = {
		Level = 758,
		XpToNextLevel = 6677,
		MaxCatchWeight = 7580,
	},
	["759"] = {
		Level = 759,
		XpToNextLevel = 6695,
		MaxCatchWeight = 7590,
	},
	["760"] = {
		Level = 760,
		XpToNextLevel = 6714,
		MaxCatchWeight = 7600,
	},
	["761"] = {
		Level = 761,
		XpToNextLevel = 6733,
		MaxCatchWeight = 7610,
	},
	["762"] = {
		Level = 762,
		XpToNextLevel = 6751,
		MaxCatchWeight = 7620,
	},
	["763"] = {
		Level = 763,
		XpToNextLevel = 6770,
		MaxCatchWeight = 7630,
	},
	["764"] = {
		Level = 764,
		XpToNextLevel = 6788,
		MaxCatchWeight = 7640,
	},
	["765"] = {
		Level = 765,
		XpToNextLevel = 6807,
		MaxCatchWeight = 7650,
	},
	["766"] = {
		Level = 766,
		XpToNextLevel = 6826,
		MaxCatchWeight = 7660,
	},
	["767"] = {
		Level = 767,
		XpToNextLevel = 6845,
		MaxCatchWeight = 7670,
	},
	["768"] = {
		Level = 768,
		XpToNextLevel = 6863,
		MaxCatchWeight = 7680,
	},
	["769"] = {
		Level = 769,
		XpToNextLevel = 6882,
		MaxCatchWeight = 7690,
	},
	["770"] = {
		Level = 770,
		XpToNextLevel = 6901,
		MaxCatchWeight = 7700,
	},
	["771"] = {
		Level = 771,
		XpToNextLevel = 6920,
		MaxCatchWeight = 7710,
	},
	["772"] = {
		Level = 772,
		XpToNextLevel = 6939,
		MaxCatchWeight = 7720,
	},
	["773"] = {
		Level = 773,
		XpToNextLevel = 6958,
		MaxCatchWeight = 7730,
	},
	["774"] = {
		Level = 774,
		XpToNextLevel = 6977,
		MaxCatchWeight = 7740,
	},
	["775"] = {
		Level = 775,
		XpToNextLevel = 6995,
		MaxCatchWeight = 7750,
	},
	["776"] = {
		Level = 776,
		XpToNextLevel = 7014,
		MaxCatchWeight = 7760,
	},
	["777"] = {
		Level = 777,
		XpToNextLevel = 7033,
		MaxCatchWeight = 7770,
	},
	["778"] = {
		Level = 778,
		XpToNextLevel = 7053,
		MaxCatchWeight = 7780,
	},
	["779"] = {
		Level = 779,
		XpToNextLevel = 7072,
		MaxCatchWeight = 7790,
	},
	["780"] = {
		Level = 780,
		XpToNextLevel = 7091,
		MaxCatchWeight = 7800,
	},
	["781"] = {
		Level = 781,
		XpToNextLevel = 7110,
		MaxCatchWeight = 7810,
	},
	["782"] = {
		Level = 782,
		XpToNextLevel = 7129,
		MaxCatchWeight = 7820,
	},
	["783"] = {
		Level = 783,
		XpToNextLevel = 7148,
		MaxCatchWeight = 7830,
	},
	["784"] = {
		Level = 784,
		XpToNextLevel = 7167,
		MaxCatchWeight = 7840,
	},
	["785"] = {
		Level = 785,
		XpToNextLevel = 7186,
		MaxCatchWeight = 7850,
	},
	["786"] = {
		Level = 786,
		XpToNextLevel = 7206,
		MaxCatchWeight = 7860,
	},
	["787"] = {
		Level = 787,
		XpToNextLevel = 7225,
		MaxCatchWeight = 7870,
	},
	["788"] = {
		Level = 788,
		XpToNextLevel = 7244,
		MaxCatchWeight = 7880,
	},
	["789"] = {
		Level = 789,
		XpToNextLevel = 7264,
		MaxCatchWeight = 7890,
	},
	["790"] = {
		Level = 790,
		XpToNextLevel = 7283,
		MaxCatchWeight = 7900,
	},
	["791"] = {
		Level = 791,
		XpToNextLevel = 7302,
		MaxCatchWeight = 7910,
	},
	["792"] = {
		Level = 792,
		XpToNextLevel = 7322,
		MaxCatchWeight = 7920,
	},
	["793"] = {
		Level = 793,
		XpToNextLevel = 7341,
		MaxCatchWeight = 7930,
	},
	["794"] = {
		Level = 794,
		XpToNextLevel = 7361,
		MaxCatchWeight = 7940,
	},
	["795"] = {
		Level = 795,
		XpToNextLevel = 7380,
		MaxCatchWeight = 7950,
	},
	["796"] = {
		Level = 796,
		XpToNextLevel = 7400,
		MaxCatchWeight = 7960,
	},
	["797"] = {
		Level = 797,
		XpToNextLevel = 7419,
		MaxCatchWeight = 7970,
	},
	["798"] = {
		Level = 798,
		XpToNextLevel = 7439,
		MaxCatchWeight = 7980,
	},
	["799"] = {
		Level = 799,
		XpToNextLevel = 7458,
		MaxCatchWeight = 7990,
	},
	["800"] = {
		Level = 800,
		XpToNextLevel = 7478,
		MaxCatchWeight = 8000,
	},
	["801"] = {
		Level = 801,
		XpToNextLevel = 7498,
		MaxCatchWeight = 8010,
	},
	["802"] = {
		Level = 802,
		XpToNextLevel = 7517,
		MaxCatchWeight = 8020,
	},
	["803"] = {
		Level = 803,
		XpToNextLevel = 7537,
		MaxCatchWeight = 8030,
	},
	["804"] = {
		Level = 804,
		XpToNextLevel = 7557,
		MaxCatchWeight = 8040,
	},
	["805"] = {
		Level = 805,
		XpToNextLevel = 7577,
		MaxCatchWeight = 8050,
	},
	["806"] = {
		Level = 806,
		XpToNextLevel = 7596,
		MaxCatchWeight = 8060,
	},
	["807"] = {
		Level = 807,
		XpToNextLevel = 7616,
		MaxCatchWeight = 8070,
	},
	["808"] = {
		Level = 808,
		XpToNextLevel = 7636,
		MaxCatchWeight = 8080,
	},
	["809"] = {
		Level = 809,
		XpToNextLevel = 7656,
		MaxCatchWeight = 8090,
	},
	["810"] = {
		Level = 810,
		XpToNextLevel = 7676,
		MaxCatchWeight = 8100,
	},
	["811"] = {
		Level = 811,
		XpToNextLevel = 7696,
		MaxCatchWeight = 8110,
	},
	["812"] = {
		Level = 812,
		XpToNextLevel = 7716,
		MaxCatchWeight = 8120,
	},
	["813"] = {
		Level = 813,
		XpToNextLevel = 7736,
		MaxCatchWeight = 8130,
	},
	["814"] = {
		Level = 814,
		XpToNextLevel = 7756,
		MaxCatchWeight = 8140,
	},
	["815"] = {
		Level = 815,
		XpToNextLevel = 7776,
		MaxCatchWeight = 8150,
	},
	["816"] = {
		Level = 816,
		XpToNextLevel = 7796,
		MaxCatchWeight = 8160,
	},
	["817"] = {
		Level = 817,
		XpToNextLevel = 7816,
		MaxCatchWeight = 8170,
	},
	["818"] = {
		Level = 818,
		XpToNextLevel = 7836,
		MaxCatchWeight = 8180,
	},
	["819"] = {
		Level = 819,
		XpToNextLevel = 7856,
		MaxCatchWeight = 8190,
	},
	["820"] = {
		Level = 820,
		XpToNextLevel = 7876,
		MaxCatchWeight = 8200,
	},
	["821"] = {
		Level = 821,
		XpToNextLevel = 7897,
		MaxCatchWeight = 8210,
	},
	["822"] = {
		Level = 822,
		XpToNextLevel = 7917,
		MaxCatchWeight = 8220,
	},
	["823"] = {
		Level = 823,
		XpToNextLevel = 7937,
		MaxCatchWeight = 8230,
	},
	["824"] = {
		Level = 824,
		XpToNextLevel = 7957,
		MaxCatchWeight = 8240,
	},
	["825"] = {
		Level = 825,
		XpToNextLevel = 7978,
		MaxCatchWeight = 8250,
	},
	["826"] = {
		Level = 826,
		XpToNextLevel = 7998,
		MaxCatchWeight = 8260,
	},
	["827"] = {
		Level = 827,
		XpToNextLevel = 8018,
		MaxCatchWeight = 8270,
	},
	["828"] = {
		Level = 828,
		XpToNextLevel = 8039,
		MaxCatchWeight = 8280,
	},
	["829"] = {
		Level = 829,
		XpToNextLevel = 8059,
		MaxCatchWeight = 8290,
	},
	["830"] = {
		Level = 830,
		XpToNextLevel = 8080,
		MaxCatchWeight = 8300,
	},
	["831"] = {
		Level = 831,
		XpToNextLevel = 8100,
		MaxCatchWeight = 8310,
	},
	["832"] = {
		Level = 832,
		XpToNextLevel = 8120,
		MaxCatchWeight = 8320,
	},
	["833"] = {
		Level = 833,
		XpToNextLevel = 8141,
		MaxCatchWeight = 8330,
	},
	["834"] = {
		Level = 834,
		XpToNextLevel = 8162,
		MaxCatchWeight = 8340,
	},
	["835"] = {
		Level = 835,
		XpToNextLevel = 8182,
		MaxCatchWeight = 8350,
	},
	["836"] = {
		Level = 836,
		XpToNextLevel = 8203,
		MaxCatchWeight = 8360,
	},
	["837"] = {
		Level = 837,
		XpToNextLevel = 8223,
		MaxCatchWeight = 8370,
	},
	["838"] = {
		Level = 838,
		XpToNextLevel = 8244,
		MaxCatchWeight = 8380,
	},
	["839"] = {
		Level = 839,
		XpToNextLevel = 8265,
		MaxCatchWeight = 8390,
	},
	["840"] = {
		Level = 840,
		XpToNextLevel = 8285,
		MaxCatchWeight = 8400,
	},
	["841"] = {
		Level = 841,
		XpToNextLevel = 8306,
		MaxCatchWeight = 8410,
	},
	["842"] = {
		Level = 842,
		XpToNextLevel = 8327,
		MaxCatchWeight = 8420,
	},
	["843"] = {
		Level = 843,
		XpToNextLevel = 8348,
		MaxCatchWeight = 8430,
	},
	["844"] = {
		Level = 844,
		XpToNextLevel = 8369,
		MaxCatchWeight = 8440,
	},
	["845"] = {
		Level = 845,
		XpToNextLevel = 8389,
		MaxCatchWeight = 8450,
	},
	["846"] = {
		Level = 846,
		XpToNextLevel = 8410,
		MaxCatchWeight = 8460,
	},
	["847"] = {
		Level = 847,
		XpToNextLevel = 8431,
		MaxCatchWeight = 8470,
	},
	["848"] = {
		Level = 848,
		XpToNextLevel = 8452,
		MaxCatchWeight = 8480,
	},
	["849"] = {
		Level = 849,
		XpToNextLevel = 8473,
		MaxCatchWeight = 8490,
	},
	["850"] = {
		Level = 850,
		XpToNextLevel = 8494,
		MaxCatchWeight = 8500,
	},
	["851"] = {
		Level = 851,
		XpToNextLevel = 8515,
		MaxCatchWeight = 8510,
	},
	["852"] = {
		Level = 852,
		XpToNextLevel = 8536,
		MaxCatchWeight = 8520,
	},
	["853"] = {
		Level = 853,
		XpToNextLevel = 8557,
		MaxCatchWeight = 8530,
	},
	["854"] = {
		Level = 854,
		XpToNextLevel = 8578,
		MaxCatchWeight = 8540,
	},
	["855"] = {
		Level = 855,
		XpToNextLevel = 8599,
		MaxCatchWeight = 8550,
	},
	["856"] = {
		Level = 856,
		XpToNextLevel = 8620,
		MaxCatchWeight = 8560,
	},
	["857"] = {
		Level = 857,
		XpToNextLevel = 8642,
		MaxCatchWeight = 8570,
	},
	["858"] = {
		Level = 858,
		XpToNextLevel = 8663,
		MaxCatchWeight = 8580,
	},
	["859"] = {
		Level = 859,
		XpToNextLevel = 8684,
		MaxCatchWeight = 8590,
	},
	["860"] = {
		Level = 860,
		XpToNextLevel = 8705,
		MaxCatchWeight = 8600,
	},
	["861"] = {
		Level = 861,
		XpToNextLevel = 8727,
		MaxCatchWeight = 8610,
	},
	["862"] = {
		Level = 862,
		XpToNextLevel = 8748,
		MaxCatchWeight = 8620,
	},
	["863"] = {
		Level = 863,
		XpToNextLevel = 8769,
		MaxCatchWeight = 8630,
	},
	["864"] = {
		Level = 864,
		XpToNextLevel = 8791,
		MaxCatchWeight = 8640,
	},
	["865"] = {
		Level = 865,
		XpToNextLevel = 8812,
		MaxCatchWeight = 8650,
	},
	["866"] = {
		Level = 866,
		XpToNextLevel = 8833,
		MaxCatchWeight = 8660,
	},
	["867"] = {
		Level = 867,
		XpToNextLevel = 8855,
		MaxCatchWeight = 8670,
	},
	["868"] = {
		Level = 868,
		XpToNextLevel = 8876,
		MaxCatchWeight = 8680,
	},
	["869"] = {
		Level = 869,
		XpToNextLevel = 8898,
		MaxCatchWeight = 8690,
	},
	["870"] = {
		Level = 870,
		XpToNextLevel = 8919,
		MaxCatchWeight = 8700,
	},
	["871"] = {
		Level = 871,
		XpToNextLevel = 8941,
		MaxCatchWeight = 8710,
	},
	["872"] = {
		Level = 872,
		XpToNextLevel = 8963,
		MaxCatchWeight = 8720,
	},
	["873"] = {
		Level = 873,
		XpToNextLevel = 8984,
		MaxCatchWeight = 8730,
	},
	["874"] = {
		Level = 874,
		XpToNextLevel = 9006,
		MaxCatchWeight = 8740,
	},
	["875"] = {
		Level = 875,
		XpToNextLevel = 9027,
		MaxCatchWeight = 8750,
	},
	["876"] = {
		Level = 876,
		XpToNextLevel = 9049,
		MaxCatchWeight = 8760,
	},
	["877"] = {
		Level = 877,
		XpToNextLevel = 9071,
		MaxCatchWeight = 8770,
	},
	["878"] = {
		Level = 878,
		XpToNextLevel = 9093,
		MaxCatchWeight = 8780,
	},
	["879"] = {
		Level = 879,
		XpToNextLevel = 9114,
		MaxCatchWeight = 8790,
	},
	["880"] = {
		Level = 880,
		XpToNextLevel = 9136,
		MaxCatchWeight = 8800,
	},
	["881"] = {
		Level = 881,
		XpToNextLevel = 9158,
		MaxCatchWeight = 8810,
	},
	["882"] = {
		Level = 882,
		XpToNextLevel = 9180,
		MaxCatchWeight = 8820,
	},
	["883"] = {
		Level = 883,
		XpToNextLevel = 9202,
		MaxCatchWeight = 8830,
	},
	["884"] = {
		Level = 884,
		XpToNextLevel = 9224,
		MaxCatchWeight = 8840,
	},
	["885"] = {
		Level = 885,
		XpToNextLevel = 9246,
		MaxCatchWeight = 8850,
	},
	["886"] = {
		Level = 886,
		XpToNextLevel = 9268,
		MaxCatchWeight = 8860,
	},
	["887"] = {
		Level = 887,
		XpToNextLevel = 9290,
		MaxCatchWeight = 8870,
	},
	["888"] = {
		Level = 888,
		XpToNextLevel = 9312,
		MaxCatchWeight = 8880,
	},
	["889"] = {
		Level = 889,
		XpToNextLevel = 9334,
		MaxCatchWeight = 8890,
	},
	["890"] = {
		Level = 890,
		XpToNextLevel = 9356,
		MaxCatchWeight = 8900,
	},
	["891"] = {
		Level = 891,
		XpToNextLevel = 9378,
		MaxCatchWeight = 8910,
	},
	["892"] = {
		Level = 892,
		XpToNextLevel = 9400,
		MaxCatchWeight = 8920,
	},
	["893"] = {
		Level = 893,
		XpToNextLevel = 9422,
		MaxCatchWeight = 8930,
	},
	["894"] = {
		Level = 894,
		XpToNextLevel = 9444,
		MaxCatchWeight = 8940,
	},
	["895"] = {
		Level = 895,
		XpToNextLevel = 9467,
		MaxCatchWeight = 8950,
	},
	["896"] = {
		Level = 896,
		XpToNextLevel = 9489,
		MaxCatchWeight = 8960,
	},
	["897"] = {
		Level = 897,
		XpToNextLevel = 9511,
		MaxCatchWeight = 8970,
	},
	["898"] = {
		Level = 898,
		XpToNextLevel = 9533,
		MaxCatchWeight = 8980,
	},
	["899"] = {
		Level = 899,
		XpToNextLevel = 9556,
		MaxCatchWeight = 8990,
	},
	["900"] = {
		Level = 900,
		XpToNextLevel = 9578,
		MaxCatchWeight = 9000,
	},
	["901"] = {
		Level = 901,
		XpToNextLevel = 9600,
		MaxCatchWeight = 9010,
	},
	["902"] = {
		Level = 902,
		XpToNextLevel = 9623,
		MaxCatchWeight = 9020,
	},
	["903"] = {
		Level = 903,
		XpToNextLevel = 9645,
		MaxCatchWeight = 9030,
	},
	["904"] = {
		Level = 904,
		XpToNextLevel = 9668,
		MaxCatchWeight = 9040,
	},
	["905"] = {
		Level = 905,
		XpToNextLevel = 9690,
		MaxCatchWeight = 9050,
	},
	["906"] = {
		Level = 906,
		XpToNextLevel = 9713,
		MaxCatchWeight = 9060,
	},
	["907"] = {
		Level = 907,
		XpToNextLevel = 9735,
		MaxCatchWeight = 9070,
	},
	["908"] = {
		Level = 908,
		XpToNextLevel = 9758,
		MaxCatchWeight = 9080,
	},
	["909"] = {
		Level = 909,
		XpToNextLevel = 9780,
		MaxCatchWeight = 9090,
	},
	["910"] = {
		Level = 910,
		XpToNextLevel = 9803,
		MaxCatchWeight = 9100,
	},
	["911"] = {
		Level = 911,
		XpToNextLevel = 9826,
		MaxCatchWeight = 9110,
	},
	["912"] = {
		Level = 912,
		XpToNextLevel = 9848,
		MaxCatchWeight = 9120,
	},
	["913"] = {
		Level = 913,
		XpToNextLevel = 9871,
		MaxCatchWeight = 9130,
	},
	["914"] = {
		Level = 914,
		XpToNextLevel = 9894,
		MaxCatchWeight = 9140,
	},
	["915"] = {
		Level = 915,
		XpToNextLevel = 9916,
		MaxCatchWeight = 9150,
	},
	["916"] = {
		Level = 916,
		XpToNextLevel = 9939,
		MaxCatchWeight = 9160,
	},
	["917"] = {
		Level = 917,
		XpToNextLevel = 9962,
		MaxCatchWeight = 9170,
	},
	["918"] = {
		Level = 918,
		XpToNextLevel = 9985,
		MaxCatchWeight = 9180,
	},
	["919"] = {
		Level = 919,
		XpToNextLevel = 10008,
		MaxCatchWeight = 9190,
	},
	["920"] = {
		Level = 920,
		XpToNextLevel = 10031,
		MaxCatchWeight = 9200,
	},
	["921"] = {
		Level = 921,
		XpToNextLevel = 10054,
		MaxCatchWeight = 9210,
	},
	["922"] = {
		Level = 922,
		XpToNextLevel = 10077,
		MaxCatchWeight = 9220,
	},
	["923"] = {
		Level = 923,
		XpToNextLevel = 10100,
		MaxCatchWeight = 9230,
	},
	["924"] = {
		Level = 924,
		XpToNextLevel = 10123,
		MaxCatchWeight = 9240,
	},
	["925"] = {
		Level = 925,
		XpToNextLevel = 10146,
		MaxCatchWeight = 9250,
	},
	["926"] = {
		Level = 926,
		XpToNextLevel = 10169,
		MaxCatchWeight = 9260,
	},
	["927"] = {
		Level = 927,
		XpToNextLevel = 10192,
		MaxCatchWeight = 9270,
	},
	["928"] = {
		Level = 928,
		XpToNextLevel = 10215,
		MaxCatchWeight = 9280,
	},
	["929"] = {
		Level = 929,
		XpToNextLevel = 10238,
		MaxCatchWeight = 9290,
	},
	["930"] = {
		Level = 930,
		XpToNextLevel = 10261,
		MaxCatchWeight = 9300,
	},
	["931"] = {
		Level = 931,
		XpToNextLevel = 10284,
		MaxCatchWeight = 9310,
	},
	["932"] = {
		Level = 932,
		XpToNextLevel = 10308,
		MaxCatchWeight = 9320,
	},
	["933"] = {
		Level = 933,
		XpToNextLevel = 10331,
		MaxCatchWeight = 9330,
	},
	["934"] = {
		Level = 934,
		XpToNextLevel = 10354,
		MaxCatchWeight = 9340,
	},
	["935"] = {
		Level = 935,
		XpToNextLevel = 10377,
		MaxCatchWeight = 9350,
	},
	["936"] = {
		Level = 936,
		XpToNextLevel = 10401,
		MaxCatchWeight = 9360,
	},
	["937"] = {
		Level = 937,
		XpToNextLevel = 10424,
		MaxCatchWeight = 9370,
	},
	["938"] = {
		Level = 938,
		XpToNextLevel = 10447,
		MaxCatchWeight = 9380,
	},
	["939"] = {
		Level = 939,
		XpToNextLevel = 10471,
		MaxCatchWeight = 9390,
	},
	["940"] = {
		Level = 940,
		XpToNextLevel = 10494,
		MaxCatchWeight = 9400,
	},
	["941"] = {
		Level = 941,
		XpToNextLevel = 10518,
		MaxCatchWeight = 9410,
	},
	["942"] = {
		Level = 942,
		XpToNextLevel = 10541,
		MaxCatchWeight = 9420,
	},
	["943"] = {
		Level = 943,
		XpToNextLevel = 10565,
		MaxCatchWeight = 9430,
	},
	["944"] = {
		Level = 944,
		XpToNextLevel = 10588,
		MaxCatchWeight = 9440,
	},
	["945"] = {
		Level = 945,
		XpToNextLevel = 10612,
		MaxCatchWeight = 9450,
	},
	["946"] = {
		Level = 946,
		XpToNextLevel = 10636,
		MaxCatchWeight = 9460,
	},
	["947"] = {
		Level = 947,
		XpToNextLevel = 10659,
		MaxCatchWeight = 9470,
	},
	["948"] = {
		Level = 948,
		XpToNextLevel = 10683,
		MaxCatchWeight = 9480,
	},
	["949"] = {
		Level = 949,
		XpToNextLevel = 10707,
		MaxCatchWeight = 9490,
	},
	["950"] = {
		Level = 950,
		XpToNextLevel = 10730,
		MaxCatchWeight = 9500,
	},
	["951"] = {
		Level = 951,
		XpToNextLevel = 10754,
		MaxCatchWeight = 9510,
	},
	["952"] = {
		Level = 952,
		XpToNextLevel = 10778,
		MaxCatchWeight = 9520,
	},
	["953"] = {
		Level = 953,
		XpToNextLevel = 10802,
		MaxCatchWeight = 9530,
	},
	["954"] = {
		Level = 954,
		XpToNextLevel = 10825,
		MaxCatchWeight = 9540,
	},
	["955"] = {
		Level = 955,
		XpToNextLevel = 10849,
		MaxCatchWeight = 9550,
	},
	["956"] = {
		Level = 956,
		XpToNextLevel = 10873,
		MaxCatchWeight = 9560,
	},
	["957"] = {
		Level = 957,
		XpToNextLevel = 10897,
		MaxCatchWeight = 9570,
	},
	["958"] = {
		Level = 958,
		XpToNextLevel = 10921,
		MaxCatchWeight = 9580,
	},
	["959"] = {
		Level = 959,
		XpToNextLevel = 10945,
		MaxCatchWeight = 9590,
	},
	["960"] = {
		Level = 960,
		XpToNextLevel = 10969,
		MaxCatchWeight = 9600,
	},
	["961"] = {
		Level = 961,
		XpToNextLevel = 10993,
		MaxCatchWeight = 9610,
	},
	["962"] = {
		Level = 962,
		XpToNextLevel = 11017,
		MaxCatchWeight = 9620,
	},
	["963"] = {
		Level = 963,
		XpToNextLevel = 11041,
		MaxCatchWeight = 9630,
	},
	["964"] = {
		Level = 964,
		XpToNextLevel = 11065,
		MaxCatchWeight = 9640,
	},
	["965"] = {
		Level = 965,
		XpToNextLevel = 11089,
		MaxCatchWeight = 9650,
	},
	["966"] = {
		Level = 966,
		XpToNextLevel = 11114,
		MaxCatchWeight = 9660,
	},
	["967"] = {
		Level = 967,
		XpToNextLevel = 11138,
		MaxCatchWeight = 9670,
	},
	["968"] = {
		Level = 968,
		XpToNextLevel = 11162,
		MaxCatchWeight = 9680,
	},
	["969"] = {
		Level = 969,
		XpToNextLevel = 11186,
		MaxCatchWeight = 9690,
	},
	["970"] = {
		Level = 970,
		XpToNextLevel = 11210,
		MaxCatchWeight = 9700,
	},
	["971"] = {
		Level = 971,
		XpToNextLevel = 11235,
		MaxCatchWeight = 9710,
	},
	["972"] = {
		Level = 972,
		XpToNextLevel = 11259,
		MaxCatchWeight = 9720,
	},
	["973"] = {
		Level = 973,
		XpToNextLevel = 11283,
		MaxCatchWeight = 9730,
	},
	["974"] = {
		Level = 974,
		XpToNextLevel = 11308,
		MaxCatchWeight = 9740,
	},
	["975"] = {
		Level = 975,
		XpToNextLevel = 11332,
		MaxCatchWeight = 9750,
	},
	["976"] = {
		Level = 976,
		XpToNextLevel = 11357,
		MaxCatchWeight = 9760,
	},
	["977"] = {
		Level = 977,
		XpToNextLevel = 11381,
		MaxCatchWeight = 9770,
	},
	["978"] = {
		Level = 978,
		XpToNextLevel = 11406,
		MaxCatchWeight = 9780,
	},
	["979"] = {
		Level = 979,
		XpToNextLevel = 11430,
		MaxCatchWeight = 9790,
	},
	["980"] = {
		Level = 980,
		XpToNextLevel = 11455,
		MaxCatchWeight = 9800,
	},
	["981"] = {
		Level = 981,
		XpToNextLevel = 11479,
		MaxCatchWeight = 9810,
	},
	["982"] = {
		Level = 982,
		XpToNextLevel = 11504,
		MaxCatchWeight = 9820,
	},
	["983"] = {
		Level = 983,
		XpToNextLevel = 11529,
		MaxCatchWeight = 9830,
	},
	["984"] = {
		Level = 984,
		XpToNextLevel = 11553,
		MaxCatchWeight = 9840,
	},
	["985"] = {
		Level = 985,
		XpToNextLevel = 11578,
		MaxCatchWeight = 9850,
	},
	["986"] = {
		Level = 986,
		XpToNextLevel = 11603,
		MaxCatchWeight = 9860,
	},
	["987"] = {
		Level = 987,
		XpToNextLevel = 11627,
		MaxCatchWeight = 9870,
	},
	["988"] = {
		Level = 988,
		XpToNextLevel = 11652,
		MaxCatchWeight = 9880,
	},
	["989"] = {
		Level = 989,
		XpToNextLevel = 11677,
		MaxCatchWeight = 9890,
	},
	["990"] = {
		Level = 990,
		XpToNextLevel = 11702,
		MaxCatchWeight = 9900,
	},
	["991"] = {
		Level = 991,
		XpToNextLevel = 11727,
		MaxCatchWeight = 9910,
	},
	["992"] = {
		Level = 992,
		XpToNextLevel = 11751,
		MaxCatchWeight = 9920,
	},
	["993"] = {
		Level = 993,
		XpToNextLevel = 11776,
		MaxCatchWeight = 9930,
	},
	["994"] = {
		Level = 994,
		XpToNextLevel = 11801,
		MaxCatchWeight = 9940,
	},
	["995"] = {
		Level = 995,
		XpToNextLevel = 11826,
		MaxCatchWeight = 9950,
	},
	["996"] = {
		Level = 996,
		XpToNextLevel = 11851,
		MaxCatchWeight = 9960,
	},
	["997"] = {
		Level = 997,
		XpToNextLevel = 11876,
		MaxCatchWeight = 9970,
	},
	["998"] = {
		Level = 998,
		XpToNextLevel = 11901,
		MaxCatchWeight = 9980,
	},
	["999"] = {
		Level = 999,
		XpToNextLevel = 11926,
		MaxCatchWeight = 9990,
	},
	["1,000"] = {
		Level = 1000,
		XpToNextLevel = 11951,
		MaxCatchWeight = 10000,
	},
	["1,001"] = {
		Level = 1001,
		XpToNextLevel = 11977,
		MaxCatchWeight = 10010,
	},
	["1,002"] = {
		Level = 1002,
		XpToNextLevel = 12002,
		MaxCatchWeight = 10020,
	},
	["1,003"] = {
		Level = 1003,
		XpToNextLevel = 12027,
		MaxCatchWeight = 10030,
	},
	["1,004"] = {
		Level = 1004,
		XpToNextLevel = 12052,
		MaxCatchWeight = 10040,
	},
	["1,005"] = {
		Level = 1005,
		XpToNextLevel = 12077,
		MaxCatchWeight = 10050,
	},
	["1,006"] = {
		Level = 1006,
		XpToNextLevel = 12103,
		MaxCatchWeight = 10060,
	},
	["1,007"] = {
		Level = 1007,
		XpToNextLevel = 12128,
		MaxCatchWeight = 10070,
	},
	["1,008"] = {
		Level = 1008,
		XpToNextLevel = 12153,
		MaxCatchWeight = 10080,
	},
	["1,009"] = {
		Level = 1009,
		XpToNextLevel = 12179,
		MaxCatchWeight = 10090,
	},
	["1,010"] = {
		Level = 1010,
		XpToNextLevel = 12204,
		MaxCatchWeight = 10100,
	},
	["1,011"] = {
		Level = 1011,
		XpToNextLevel = 12229,
		MaxCatchWeight = 10110,
	},
	["1,012"] = {
		Level = 1012,
		XpToNextLevel = 12255,
		MaxCatchWeight = 10120,
	},
	["1,013"] = {
		Level = 1013,
		XpToNextLevel = 12280,
		MaxCatchWeight = 10130,
	},
	["1,014"] = {
		Level = 1014,
		XpToNextLevel = 12306,
		MaxCatchWeight = 10140,
	},
	["1,015"] = {
		Level = 1015,
		XpToNextLevel = 12331,
		MaxCatchWeight = 10150,
	},
	["1,016"] = {
		Level = 1016,
		XpToNextLevel = 12357,
		MaxCatchWeight = 10160,
	},
	["1,017"] = {
		Level = 1017,
		XpToNextLevel = 12382,
		MaxCatchWeight = 10170,
	},
	["1,018"] = {
		Level = 1018,
		XpToNextLevel = 12408,
		MaxCatchWeight = 10180,
	},
	["1,019"] = {
		Level = 1019,
		XpToNextLevel = 12434,
		MaxCatchWeight = 10190,
	},
	["1,020"] = {
		Level = 1020,
		XpToNextLevel = 12459,
		MaxCatchWeight = 10200,
	},
	["1,021"] = {
		Level = 1021,
		XpToNextLevel = 12485,
		MaxCatchWeight = 10210,
	},
	["1,022"] = {
		Level = 1022,
		XpToNextLevel = 12511,
		MaxCatchWeight = 10220,
	},
	["1,023"] = {
		Level = 1023,
		XpToNextLevel = 12536,
		MaxCatchWeight = 10230,
	},
	["1,024"] = {
		Level = 1024,
		XpToNextLevel = 12562,
		MaxCatchWeight = 10240,
	},
	["1,025"] = {
		Level = 1025,
		XpToNextLevel = 12588,
		MaxCatchWeight = 10250,
	},
	["1,026"] = {
		Level = 1026,
		XpToNextLevel = 12614,
		MaxCatchWeight = 10260,
	},
	["1,027"] = {
		Level = 1027,
		XpToNextLevel = 12640,
		MaxCatchWeight = 10270,
	},
	["1,028"] = {
		Level = 1028,
		XpToNextLevel = 12665,
		MaxCatchWeight = 10280,
	},
	["1,029"] = {
		Level = 1029,
		XpToNextLevel = 12691,
		MaxCatchWeight = 10290,
	},
	["1,030"] = {
		Level = 1030,
		XpToNextLevel = 12717,
		MaxCatchWeight = 10300,
	},
	["1,031"] = {
		Level = 1031,
		XpToNextLevel = 12743,
		MaxCatchWeight = 10310,
	},
	["1,032"] = {
		Level = 1032,
		XpToNextLevel = 12769,
		MaxCatchWeight = 10320,
	},
	["1,033"] = {
		Level = 1033,
		XpToNextLevel = 12795,
		MaxCatchWeight = 10330,
	},
	["1,034"] = {
		Level = 1034,
		XpToNextLevel = 12821,
		MaxCatchWeight = 10340,
	},
	["1,035"] = {
		Level = 1035,
		XpToNextLevel = 12847,
		MaxCatchWeight = 10350,
	},
	["1,036"] = {
		Level = 1036,
		XpToNextLevel = 12873,
		MaxCatchWeight = 10360,
	},
	["1,037"] = {
		Level = 1037,
		XpToNextLevel = 12900,
		MaxCatchWeight = 10370,
	},
	["1,038"] = {
		Level = 1038,
		XpToNextLevel = 12926,
		MaxCatchWeight = 10380,
	},
	["1,039"] = {
		Level = 1039,
		XpToNextLevel = 12952,
		MaxCatchWeight = 10390,
	},
	["1,040"] = {
		Level = 1040,
		XpToNextLevel = 12978,
		MaxCatchWeight = 10400,
	},
	["1,041"] = {
		Level = 1041,
		XpToNextLevel = 13004,
		MaxCatchWeight = 10410,
	},
	["1,042"] = {
		Level = 1042,
		XpToNextLevel = 13031,
		MaxCatchWeight = 10420,
	},
	["1,043"] = {
		Level = 1043,
		XpToNextLevel = 13057,
		MaxCatchWeight = 10430,
	},
	["1,044"] = {
		Level = 1044,
		XpToNextLevel = 13083,
		MaxCatchWeight = 10440,
	},
	["1,045"] = {
		Level = 1045,
		XpToNextLevel = 13110,
		MaxCatchWeight = 10450,
	},
	["1,046"] = {
		Level = 1046,
		XpToNextLevel = 13136,
		MaxCatchWeight = 10460,
	},
	["1,047"] = {
		Level = 1047,
		XpToNextLevel = 13162,
		MaxCatchWeight = 10470,
	},
	["1,048"] = {
		Level = 1048,
		XpToNextLevel = 13189,
		MaxCatchWeight = 10480,
	},
	["1,049"] = {
		Level = 1049,
		XpToNextLevel = 13215,
		MaxCatchWeight = 10490,
	},
	["1,050"] = {
		Level = 1050,
		XpToNextLevel = 13242,
		MaxCatchWeight = 10500,
	},
	["1,051"] = {
		Level = 1051,
		XpToNextLevel = 13268,
		MaxCatchWeight = 10510,
	},
	["1,052"] = {
		Level = 1052,
		XpToNextLevel = 13295,
		MaxCatchWeight = 10520,
	},
	["1,053"] = {
		Level = 1053,
		XpToNextLevel = 13321,
		MaxCatchWeight = 10530,
	},
	["1,054"] = {
		Level = 1054,
		XpToNextLevel = 13348,
		MaxCatchWeight = 10540,
	},
	["1,055"] = {
		Level = 1055,
		XpToNextLevel = 13375,
		MaxCatchWeight = 10550,
	},
	["1,056"] = {
		Level = 1056,
		XpToNextLevel = 13401,
		MaxCatchWeight = 10560,
	},
	["1,057"] = {
		Level = 1057,
		XpToNextLevel = 13428,
		MaxCatchWeight = 10570,
	},
	["1,058"] = {
		Level = 1058,
		XpToNextLevel = 13455,
		MaxCatchWeight = 10580,
	},
	["1,059"] = {
		Level = 1059,
		XpToNextLevel = 13481,
		MaxCatchWeight = 10590,
	},
	["1,060"] = {
		Level = 1060,
		XpToNextLevel = 13508,
		MaxCatchWeight = 10600,
	},
	["1,061"] = {
		Level = 1061,
		XpToNextLevel = 13535,
		MaxCatchWeight = 10610,
	},
	["1,062"] = {
		Level = 1062,
		XpToNextLevel = 13562,
		MaxCatchWeight = 10620,
	},
	["1,063"] = {
		Level = 1063,
		XpToNextLevel = 13589,
		MaxCatchWeight = 10630,
	},
	["1,064"] = {
		Level = 1064,
		XpToNextLevel = 13615,
		MaxCatchWeight = 10640,
	},
	["1,065"] = {
		Level = 1065,
		XpToNextLevel = 13642,
		MaxCatchWeight = 10650,
	},
	["1,066"] = {
		Level = 1066,
		XpToNextLevel = 13669,
		MaxCatchWeight = 10660,
	},
	["1,067"] = {
		Level = 1067,
		XpToNextLevel = 13696,
		MaxCatchWeight = 10670,
	},
	["1,068"] = {
		Level = 1068,
		XpToNextLevel = 13723,
		MaxCatchWeight = 10680,
	},
	["1,069"] = {
		Level = 1069,
		XpToNextLevel = 13750,
		MaxCatchWeight = 10690,
	},
	["1,070"] = {
		Level = 1070,
		XpToNextLevel = 13777,
		MaxCatchWeight = 10700,
	},
	["1,071"] = {
		Level = 1071,
		XpToNextLevel = 13804,
		MaxCatchWeight = 10710,
	},
	["1,072"] = {
		Level = 1072,
		XpToNextLevel = 13831,
		MaxCatchWeight = 10720,
	},
	["1,073"] = {
		Level = 1073,
		XpToNextLevel = 13859,
		MaxCatchWeight = 10730,
	},
	["1,074"] = {
		Level = 1074,
		XpToNextLevel = 13886,
		MaxCatchWeight = 10740,
	},
	["1,075"] = {
		Level = 1075,
		XpToNextLevel = 13913,
		MaxCatchWeight = 10750,
	},
	["1,076"] = {
		Level = 1076,
		XpToNextLevel = 13940,
		MaxCatchWeight = 10760,
	},
	["1,077"] = {
		Level = 1077,
		XpToNextLevel = 13967,
		MaxCatchWeight = 10770,
	},
	["1,078"] = {
		Level = 1078,
		XpToNextLevel = 13995,
		MaxCatchWeight = 10780,
	},
	["1,079"] = {
		Level = 1079,
		XpToNextLevel = 14022,
		MaxCatchWeight = 10790,
	},
	["1,080"] = {
		Level = 1080,
		XpToNextLevel = 14049,
		MaxCatchWeight = 10800,
	},
	["1,081"] = {
		Level = 1081,
		XpToNextLevel = 14077,
		MaxCatchWeight = 10810,
	},
	["1,082"] = {
		Level = 1082,
		XpToNextLevel = 14104,
		MaxCatchWeight = 10820,
	},
	["1,083"] = {
		Level = 1083,
		XpToNextLevel = 14131,
		MaxCatchWeight = 10830,
	},
	["1,084"] = {
		Level = 1084,
		XpToNextLevel = 14159,
		MaxCatchWeight = 10840,
	},
	["1,085"] = {
		Level = 1085,
		XpToNextLevel = 14186,
		MaxCatchWeight = 10850,
	},
	["1,086"] = {
		Level = 1086,
		XpToNextLevel = 14214,
		MaxCatchWeight = 10860,
	},
	["1,087"] = {
		Level = 1087,
		XpToNextLevel = 14241,
		MaxCatchWeight = 10870,
	},
	["1,088"] = {
		Level = 1088,
		XpToNextLevel = 14269,
		MaxCatchWeight = 10880,
	},
	["1,089"] = {
		Level = 1089,
		XpToNextLevel = 14296,
		MaxCatchWeight = 10890,
	},
	["1,090"] = {
		Level = 1090,
		XpToNextLevel = 14324,
		MaxCatchWeight = 10900,
	},
	["1,091"] = {
		Level = 1091,
		XpToNextLevel = 14352,
		MaxCatchWeight = 10910,
	},
	["1,092"] = {
		Level = 1092,
		XpToNextLevel = 14379,
		MaxCatchWeight = 10920,
	},
	["1,093"] = {
		Level = 1093,
		XpToNextLevel = 14407,
		MaxCatchWeight = 10930,
	},
	["1,094"] = {
		Level = 1094,
		XpToNextLevel = 14435,
		MaxCatchWeight = 10940,
	},
	["1,095"] = {
		Level = 1095,
		XpToNextLevel = 14462,
		MaxCatchWeight = 10950,
	},
	["1,096"] = {
		Level = 1096,
		XpToNextLevel = 14490,
		MaxCatchWeight = 10960,
	},
	["1,097"] = {
		Level = 1097,
		XpToNextLevel = 14518,
		MaxCatchWeight = 10970,
	},
	["1,098"] = {
		Level = 1098,
		XpToNextLevel = 14546,
		MaxCatchWeight = 10980,
	},
	["1,099"] = {
		Level = 1099,
		XpToNextLevel = 14574,
		MaxCatchWeight = 10990,
	},
	["1,100"] = {
		Level = 1100,
		XpToNextLevel = 14601,
		MaxCatchWeight = 11000,
	},
	["1,101"] = {
		Level = 1101,
		XpToNextLevel = 14629,
		MaxCatchWeight = 11010,
	},
	["1,102"] = {
		Level = 1102,
		XpToNextLevel = 14657,
		MaxCatchWeight = 11020,
	},
	["1,103"] = {
		Level = 1103,
		XpToNextLevel = 14685,
		MaxCatchWeight = 11030,
	},
	["1,104"] = {
		Level = 1104,
		XpToNextLevel = 14713,
		MaxCatchWeight = 11040,
	},
	["1,105"] = {
		Level = 1105,
		XpToNextLevel = 14741,
		MaxCatchWeight = 11050,
	},
	["1,106"] = {
		Level = 1106,
		XpToNextLevel = 14769,
		MaxCatchWeight = 11060,
	},
	["1,107"] = {
		Level = 1107,
		XpToNextLevel = 14797,
		MaxCatchWeight = 11070,
	},
	["1,108"] = {
		Level = 1108,
		XpToNextLevel = 14825,
		MaxCatchWeight = 11080,
	},
	["1,109"] = {
		Level = 1109,
		XpToNextLevel = 14854,
		MaxCatchWeight = 11090,
	},
	["1,110"] = {
		Level = 1110,
		XpToNextLevel = 14882,
		MaxCatchWeight = 11100,
	},
	["1,111"] = {
		Level = 1111,
		XpToNextLevel = 14910,
		MaxCatchWeight = 11110,
	},
	["1,112"] = {
		Level = 1112,
		XpToNextLevel = 14938,
		MaxCatchWeight = 11120,
	},
	["1,113"] = {
		Level = 1113,
		XpToNextLevel = 14966,
		MaxCatchWeight = 11130,
	},
	["1,114"] = {
		Level = 1114,
		XpToNextLevel = 14995,
		MaxCatchWeight = 11140,
	},
	["1,115"] = {
		Level = 1115,
		XpToNextLevel = 15023,
		MaxCatchWeight = 11150,
	},
	["1,116"] = {
		Level = 1116,
		XpToNextLevel = 15051,
		MaxCatchWeight = 11160,
	},
	["1,117"] = {
		Level = 1117,
		XpToNextLevel = 15080,
		MaxCatchWeight = 11170,
	},
	["1,118"] = {
		Level = 1118,
		XpToNextLevel = 15108,
		MaxCatchWeight = 11180,
	},
	["1,119"] = {
		Level = 1119,
		XpToNextLevel = 15136,
		MaxCatchWeight = 11190,
	},
	["1,120"] = {
		Level = 1120,
		XpToNextLevel = 15165,
		MaxCatchWeight = 11200,
	},
	["1,121"] = {
		Level = 1121,
		XpToNextLevel = 15193,
		MaxCatchWeight = 11210,
	},
	["1,122"] = {
		Level = 1122,
		XpToNextLevel = 15222,
		MaxCatchWeight = 11220,
	},
	["1,123"] = {
		Level = 1123,
		XpToNextLevel = 15250,
		MaxCatchWeight = 11230,
	},
	["1,124"] = {
		Level = 1124,
		XpToNextLevel = 15279,
		MaxCatchWeight = 11240,
	},
	["1,125"] = {
		Level = 1125,
		XpToNextLevel = 15307,
		MaxCatchWeight = 11250,
	},
	["1,126"] = {
		Level = 1126,
		XpToNextLevel = 15336,
		MaxCatchWeight = 11260,
	},
	["1,127"] = {
		Level = 1127,
		XpToNextLevel = 15365,
		MaxCatchWeight = 11270,
	},
	["1,128"] = {
		Level = 1128,
		XpToNextLevel = 15393,
		MaxCatchWeight = 11280,
	},
	["1,129"] = {
		Level = 1129,
		XpToNextLevel = 15422,
		MaxCatchWeight = 11290,
	},
	["1,130"] = {
		Level = 1130,
		XpToNextLevel = 15451,
		MaxCatchWeight = 11300,
	},
	["1,131"] = {
		Level = 1131,
		XpToNextLevel = 15479,
		MaxCatchWeight = 11310,
	},
	["1,132"] = {
		Level = 1132,
		XpToNextLevel = 15508,
		MaxCatchWeight = 11320,
	},
	["1,133"] = {
		Level = 1133,
		XpToNextLevel = 15537,
		MaxCatchWeight = 11330,
	},
	["1,134"] = {
		Level = 1134,
		XpToNextLevel = 15566,
		MaxCatchWeight = 11340,
	},
	["1,135"] = {
		Level = 1135,
		XpToNextLevel = 15595,
		MaxCatchWeight = 11350,
	},
	["1,136"] = {
		Level = 1136,
		XpToNextLevel = 15624,
		MaxCatchWeight = 11360,
	},
	["1,137"] = {
		Level = 1137,
		XpToNextLevel = 15653,
		MaxCatchWeight = 11370,
	},
	["1,138"] = {
		Level = 1138,
		XpToNextLevel = 15681,
		MaxCatchWeight = 11380,
	},
	["1,139"] = {
		Level = 1139,
		XpToNextLevel = 15710,
		MaxCatchWeight = 11390,
	},
	["1,140"] = {
		Level = 1140,
		XpToNextLevel = 15739,
		MaxCatchWeight = 11400,
	},
	["1,141"] = {
		Level = 1141,
		XpToNextLevel = 15768,
		MaxCatchWeight = 11410,
	},
	["1,142"] = {
		Level = 1142,
		XpToNextLevel = 15798,
		MaxCatchWeight = 11420,
	},
	["1,143"] = {
		Level = 1143,
		XpToNextLevel = 15827,
		MaxCatchWeight = 11430,
	},
	["1,144"] = {
		Level = 1144,
		XpToNextLevel = 15856,
		MaxCatchWeight = 11440,
	},
	["1,145"] = {
		Level = 1145,
		XpToNextLevel = 15885,
		MaxCatchWeight = 11450,
	},
	["1,146"] = {
		Level = 1146,
		XpToNextLevel = 15914,
		MaxCatchWeight = 11460,
	},
	["1,147"] = {
		Level = 1147,
		XpToNextLevel = 15943,
		MaxCatchWeight = 11470,
	},
	["1,148"] = {
		Level = 1148,
		XpToNextLevel = 15972,
		MaxCatchWeight = 11480,
	},
	["1,149"] = {
		Level = 1149,
		XpToNextLevel = 16002,
		MaxCatchWeight = 11490,
	},
	["1,150"] = {
		Level = 1150,
		XpToNextLevel = 16031,
		MaxCatchWeight = 11500,
	},
	["1,151"] = {
		Level = 1151,
		XpToNextLevel = 16060,
		MaxCatchWeight = 11510,
	},
	["1,152"] = {
		Level = 1152,
		XpToNextLevel = 16090,
		MaxCatchWeight = 11520,
	},
	["1,153"] = {
		Level = 1153,
		XpToNextLevel = 16119,
		MaxCatchWeight = 11530,
	},
	["1,154"] = {
		Level = 1154,
		XpToNextLevel = 16148,
		MaxCatchWeight = 11540,
	},
	["1,155"] = {
		Level = 1155,
		XpToNextLevel = 16178,
		MaxCatchWeight = 11550,
	},
	["1,156"] = {
		Level = 1156,
		XpToNextLevel = 16207,
		MaxCatchWeight = 11560,
	},
	["1,157"] = {
		Level = 1157,
		XpToNextLevel = 16237,
		MaxCatchWeight = 11570,
	},
	["1,158"] = {
		Level = 1158,
		XpToNextLevel = 16266,
		MaxCatchWeight = 11580,
	},
	["1,159"] = {
		Level = 1159,
		XpToNextLevel = 16296,
		MaxCatchWeight = 11590,
	},
	["1,160"] = {
		Level = 1160,
		XpToNextLevel = 16325,
		MaxCatchWeight = 11600,
	},
	["1,161"] = {
		Level = 1161,
		XpToNextLevel = 16355,
		MaxCatchWeight = 11610,
	},
	["1,162"] = {
		Level = 1162,
		XpToNextLevel = 16384,
		MaxCatchWeight = 11620,
	},
	["1,163"] = {
		Level = 1163,
		XpToNextLevel = 16414,
		MaxCatchWeight = 11630,
	},
	["1,164"] = {
		Level = 1164,
		XpToNextLevel = 16444,
		MaxCatchWeight = 11640,
	},
	["1,165"] = {
		Level = 1165,
		XpToNextLevel = 16473,
		MaxCatchWeight = 11650,
	},
	["1,166"] = {
		Level = 1166,
		XpToNextLevel = 16503,
		MaxCatchWeight = 11660,
	},
	["1,167"] = {
		Level = 1167,
		XpToNextLevel = 16533,
		MaxCatchWeight = 11670,
	},
	["1,168"] = {
		Level = 1168,
		XpToNextLevel = 16563,
		MaxCatchWeight = 11680,
	},
	["1,169"] = {
		Level = 1169,
		XpToNextLevel = 16593,
		MaxCatchWeight = 11690,
	},
	["1,170"] = {
		Level = 1170,
		XpToNextLevel = 16622,
		MaxCatchWeight = 11700,
	},
	["1,171"] = {
		Level = 1171,
		XpToNextLevel = 16652,
		MaxCatchWeight = 11710,
	},
	["1,172"] = {
		Level = 1172,
		XpToNextLevel = 16682,
		MaxCatchWeight = 11720,
	},
	["1,173"] = {
		Level = 1173,
		XpToNextLevel = 16712,
		MaxCatchWeight = 11730,
	},
	["1,174"] = {
		Level = 1174,
		XpToNextLevel = 16742,
		MaxCatchWeight = 11740,
	},
	["1,175"] = {
		Level = 1175,
		XpToNextLevel = 16772,
		MaxCatchWeight = 11750,
	},
	["1,176"] = {
		Level = 1176,
		XpToNextLevel = 16802,
		MaxCatchWeight = 11760,
	},
	["1,177"] = {
		Level = 1177,
		XpToNextLevel = 16832,
		MaxCatchWeight = 11770,
	},
	["1,178"] = {
		Level = 1178,
		XpToNextLevel = 16862,
		MaxCatchWeight = 11780,
	},
	["1,179"] = {
		Level = 1179,
		XpToNextLevel = 16892,
		MaxCatchWeight = 11790,
	},
	["1,180"] = {
		Level = 1180,
		XpToNextLevel = 16922,
		MaxCatchWeight = 11800,
	},
	["1,181"] = {
		Level = 1181,
		XpToNextLevel = 16952,
		MaxCatchWeight = 11810,
	},
	["1,182"] = {
		Level = 1182,
		XpToNextLevel = 16983,
		MaxCatchWeight = 11820,
	},
	["1,183"] = {
		Level = 1183,
		XpToNextLevel = 17013,
		MaxCatchWeight = 11830,
	},
	["1,184"] = {
		Level = 1184,
		XpToNextLevel = 17043,
		MaxCatchWeight = 11840,
	},
	["1,185"] = {
		Level = 1185,
		XpToNextLevel = 17073,
		MaxCatchWeight = 11850,
	},
	["1,186"] = {
		Level = 1186,
		XpToNextLevel = 17104,
		MaxCatchWeight = 11860,
	},
	["1,187"] = {
		Level = 1187,
		XpToNextLevel = 17134,
		MaxCatchWeight = 11870,
	},
	["1,188"] = {
		Level = 1188,
		XpToNextLevel = 17164,
		MaxCatchWeight = 11880,
	},
	["1,189"] = {
		Level = 1189,
		XpToNextLevel = 17195,
		MaxCatchWeight = 11890,
	},
	["1,190"] = {
		Level = 1190,
		XpToNextLevel = 17225,
		MaxCatchWeight = 11900,
	},
	["1,191"] = {
		Level = 1191,
		XpToNextLevel = 17255,
		MaxCatchWeight = 11910,
	},
	["1,192"] = {
		Level = 1192,
		XpToNextLevel = 17286,
		MaxCatchWeight = 11920,
	},
	["1,193"] = {
		Level = 1193,
		XpToNextLevel = 17316,
		MaxCatchWeight = 11930,
	},
	["1,194"] = {
		Level = 1194,
		XpToNextLevel = 17347,
		MaxCatchWeight = 11940,
	},
	["1,195"] = {
		Level = 1195,
		XpToNextLevel = 17377,
		MaxCatchWeight = 11950,
	},
	["1,196"] = {
		Level = 1196,
		XpToNextLevel = 17408,
		MaxCatchWeight = 11960,
	},
	["1,197"] = {
		Level = 1197,
		XpToNextLevel = 17439,
		MaxCatchWeight = 11970,
	},
	["1,198"] = {
		Level = 1198,
		XpToNextLevel = 17469,
		MaxCatchWeight = 11980,
	},
	["1,199"] = {
		Level = 1199,
		XpToNextLevel = 17500,
		MaxCatchWeight = 11990,
	},
	["1,200"] = {
		Level = 1200,
		XpToNextLevel = 17531,
		MaxCatchWeight = 12000,
	},
	["1,201"] = {
		Level = 1201,
		XpToNextLevel = 17561,
		MaxCatchWeight = 12010,
	},
	["1,202"] = {
		Level = 1202,
		XpToNextLevel = 17592,
		MaxCatchWeight = 12020,
	},
	["1,203"] = {
		Level = 1203,
		XpToNextLevel = 17623,
		MaxCatchWeight = 12030,
	},
	["1,204"] = {
		Level = 1204,
		XpToNextLevel = 17654,
		MaxCatchWeight = 12040,
	},
	["1,205"] = {
		Level = 1205,
		XpToNextLevel = 17684,
		MaxCatchWeight = 12050,
	},
	["1,206"] = {
		Level = 1206,
		XpToNextLevel = 17715,
		MaxCatchWeight = 12060,
	},
	["1,207"] = {
		Level = 1207,
		XpToNextLevel = 17746,
		MaxCatchWeight = 12070,
	},
	["1,208"] = {
		Level = 1208,
		XpToNextLevel = 17777,
		MaxCatchWeight = 12080,
	},
	["1,209"] = {
		Level = 1209,
		XpToNextLevel = 17808,
		MaxCatchWeight = 12090,
	},
	["1,210"] = {
		Level = 1210,
		XpToNextLevel = 17839,
		MaxCatchWeight = 12100,
	},
	["1,211"] = {
		Level = 1211,
		XpToNextLevel = 17870,
		MaxCatchWeight = 12110,
	},
	["1,212"] = {
		Level = 1212,
		XpToNextLevel = 17901,
		MaxCatchWeight = 12120,
	},
	["1,213"] = {
		Level = 1213,
		XpToNextLevel = 17932,
		MaxCatchWeight = 12130,
	},
	["1,214"] = {
		Level = 1214,
		XpToNextLevel = 17963,
		MaxCatchWeight = 12140,
	},
	["1,215"] = {
		Level = 1215,
		XpToNextLevel = 17994,
		MaxCatchWeight = 12150,
	},
	["1,216"] = {
		Level = 1216,
		XpToNextLevel = 18025,
		MaxCatchWeight = 12160,
	},
	["1,217"] = {
		Level = 1217,
		XpToNextLevel = 18056,
		MaxCatchWeight = 12170,
	},
	["1,218"] = {
		Level = 1218,
		XpToNextLevel = 18088,
		MaxCatchWeight = 12180,
	},
	["1,219"] = {
		Level = 1219,
		XpToNextLevel = 18119,
		MaxCatchWeight = 12190,
	},
	["1,220"] = {
		Level = 1220,
		XpToNextLevel = 18150,
		MaxCatchWeight = 12200,
	},
	["1,221"] = {
		Level = 1221,
		XpToNextLevel = 18181,
		MaxCatchWeight = 12210,
	},
	["1,222"] = {
		Level = 1222,
		XpToNextLevel = 18213,
		MaxCatchWeight = 12220,
	},
	["1,223"] = {
		Level = 1223,
		XpToNextLevel = 18244,
		MaxCatchWeight = 12230,
	},
	["1,224"] = {
		Level = 1224,
		XpToNextLevel = 18275,
		MaxCatchWeight = 12240,
	},
	["1,225"] = {
		Level = 1225,
		XpToNextLevel = 18307,
		MaxCatchWeight = 12250,
	},
	["1,226"] = {
		Level = 1226,
		XpToNextLevel = 18338,
		MaxCatchWeight = 12260,
	},
	["1,227"] = {
		Level = 1227,
		XpToNextLevel = 18370,
		MaxCatchWeight = 12270,
	},
	["1,228"] = {
		Level = 1228,
		XpToNextLevel = 18401,
		MaxCatchWeight = 12280,
	},
	["1,229"] = {
		Level = 1229,
		XpToNextLevel = 18433,
		MaxCatchWeight = 12290,
	},
	["1,230"] = {
		Level = 1230,
		XpToNextLevel = 18464,
		MaxCatchWeight = 12300,
	},
	["1,231"] = {
		Level = 1231,
		XpToNextLevel = 18496,
		MaxCatchWeight = 12310,
	},
	["1,232"] = {
		Level = 1232,
		XpToNextLevel = 18527,
		MaxCatchWeight = 12320,
	},
	["1,233"] = {
		Level = 1233,
		XpToNextLevel = 18559,
		MaxCatchWeight = 12330,
	},
	["1,234"] = {
		Level = 1234,
		XpToNextLevel = 18590,
		MaxCatchWeight = 12340,
	},
	["1,235"] = {
		Level = 1235,
		XpToNextLevel = 18622,
		MaxCatchWeight = 12350,
	},
	["1,236"] = {
		Level = 1236,
		XpToNextLevel = 18654,
		MaxCatchWeight = 12360,
	},
	["1,237"] = {
		Level = 1237,
		XpToNextLevel = 18686,
		MaxCatchWeight = 12370,
	},
	["1,238"] = {
		Level = 1238,
		XpToNextLevel = 18717,
		MaxCatchWeight = 12380,
	},
	["1,239"] = {
		Level = 1239,
		XpToNextLevel = 18749,
		MaxCatchWeight = 12390,
	},
	["1,240"] = {
		Level = 1240,
		XpToNextLevel = 18781,
		MaxCatchWeight = 12400,
	},
	["1,241"] = {
		Level = 1241,
		XpToNextLevel = 18813,
		MaxCatchWeight = 12410,
	},
	["1,242"] = {
		Level = 1242,
		XpToNextLevel = 18845,
		MaxCatchWeight = 12420,
	},
	["1,243"] = {
		Level = 1243,
		XpToNextLevel = 18877,
		MaxCatchWeight = 12430,
	},
	["1,244"] = {
		Level = 1244,
		XpToNextLevel = 18908,
		MaxCatchWeight = 12440,
	},
	["1,245"] = {
		Level = 1245,
		XpToNextLevel = 18940,
		MaxCatchWeight = 12450,
	},
	["1,246"] = {
		Level = 1246,
		XpToNextLevel = 18972,
		MaxCatchWeight = 12460,
	},
	["1,247"] = {
		Level = 1247,
		XpToNextLevel = 19004,
		MaxCatchWeight = 12470,
	},
	["1,248"] = {
		Level = 1248,
		XpToNextLevel = 19036,
		MaxCatchWeight = 12480,
	},
	["1,249"] = {
		Level = 1249,
		XpToNextLevel = 19068,
		MaxCatchWeight = 12490,
	},
	["1,250"] = {
		Level = 1250,
		XpToNextLevel = 19101,
		MaxCatchWeight = 12500,
	},
	["1,251"] = {
		Level = 1251,
		XpToNextLevel = 19133,
		MaxCatchWeight = 12510,
	},
	["1,252"] = {
		Level = 1252,
		XpToNextLevel = 19165,
		MaxCatchWeight = 12520,
	},
	["1,253"] = {
		Level = 1253,
		XpToNextLevel = 19197,
		MaxCatchWeight = 12530,
	},
	["1,254"] = {
		Level = 1254,
		XpToNextLevel = 19229,
		MaxCatchWeight = 12540,
	},
	["1,255"] = {
		Level = 1255,
		XpToNextLevel = 19261,
		MaxCatchWeight = 12550,
	},
	["1,256"] = {
		Level = 1256,
		XpToNextLevel = 19294,
		MaxCatchWeight = 12560,
	},
	["1,257"] = {
		Level = 1257,
		XpToNextLevel = 19326,
		MaxCatchWeight = 12570,
	},
	["1,258"] = {
		Level = 1258,
		XpToNextLevel = 19358,
		MaxCatchWeight = 12580,
	},
	["1,259"] = {
		Level = 1259,
		XpToNextLevel = 19391,
		MaxCatchWeight = 12590,
	},
	["1,260"] = {
		Level = 1260,
		XpToNextLevel = 19423,
		MaxCatchWeight = 12600,
	},
	["1,261"] = {
		Level = 1261,
		XpToNextLevel = 19455,
		MaxCatchWeight = 12610,
	},
	["1,262"] = {
		Level = 1262,
		XpToNextLevel = 19488,
		MaxCatchWeight = 12620,
	},
	["1,263"] = {
		Level = 1263,
		XpToNextLevel = 19520,
		MaxCatchWeight = 12630,
	},
	["1,264"] = {
		Level = 1264,
		XpToNextLevel = 19553,
		MaxCatchWeight = 12640,
	},
	["1,265"] = {
		Level = 1265,
		XpToNextLevel = 19585,
		MaxCatchWeight = 12650,
	},
	["1,266"] = {
		Level = 1266,
		XpToNextLevel = 19618,
		MaxCatchWeight = 12660,
	},
	["1,267"] = {
		Level = 1267,
		XpToNextLevel = 19650,
		MaxCatchWeight = 12670,
	},
	["1,268"] = {
		Level = 1268,
		XpToNextLevel = 19683,
		MaxCatchWeight = 12680,
	},
	["1,269"] = {
		Level = 1269,
		XpToNextLevel = 19716,
		MaxCatchWeight = 12690,
	},
	["1,270"] = {
		Level = 1270,
		XpToNextLevel = 19748,
		MaxCatchWeight = 12700,
	},
	["1,271"] = {
		Level = 1271,
		XpToNextLevel = 19781,
		MaxCatchWeight = 12710,
	},
	["1,272"] = {
		Level = 1272,
		XpToNextLevel = 19814,
		MaxCatchWeight = 12720,
	},
	["1,273"] = {
		Level = 1273,
		XpToNextLevel = 19846,
		MaxCatchWeight = 12730,
	},
	["1,274"] = {
		Level = 1274,
		XpToNextLevel = 19879,
		MaxCatchWeight = 12740,
	},
	["1,275"] = {
		Level = 1275,
		XpToNextLevel = 19912,
		MaxCatchWeight = 12750,
	},
	["1,276"] = {
		Level = 1276,
		XpToNextLevel = 19945,
		MaxCatchWeight = 12760,
	},
	["1,277"] = {
		Level = 1277,
		XpToNextLevel = 19978,
		MaxCatchWeight = 12770,
	},
	["1,278"] = {
		Level = 1278,
		XpToNextLevel = 20011,
		MaxCatchWeight = 12780,
	},
	["1,279"] = {
		Level = 1279,
		XpToNextLevel = 20044,
		MaxCatchWeight = 12790,
	},
	["1,280"] = {
		Level = 1280,
		XpToNextLevel = 20076,
		MaxCatchWeight = 12800,
	},
	["1,281"] = {
		Level = 1281,
		XpToNextLevel = 20109,
		MaxCatchWeight = 12810,
	},
	["1,282"] = {
		Level = 1282,
		XpToNextLevel = 20142,
		MaxCatchWeight = 12820,
	},
	["1,283"] = {
		Level = 1283,
		XpToNextLevel = 20175,
		MaxCatchWeight = 12830,
	},
	["1,284"] = {
		Level = 1284,
		XpToNextLevel = 20209,
		MaxCatchWeight = 12840,
	},
	["1,285"] = {
		Level = 1285,
		XpToNextLevel = 20242,
		MaxCatchWeight = 12850,
	},
	["1,286"] = {
		Level = 1286,
		XpToNextLevel = 20275,
		MaxCatchWeight = 12860,
	},
	["1,287"] = {
		Level = 1287,
		XpToNextLevel = 20308,
		MaxCatchWeight = 12870,
	},
	["1,288"] = {
		Level = 1288,
		XpToNextLevel = 20341,
		MaxCatchWeight = 12880,
	},
	["1,289"] = {
		Level = 1289,
		XpToNextLevel = 20374,
		MaxCatchWeight = 12890,
	},
	["1,290"] = {
		Level = 1290,
		XpToNextLevel = 20407,
		MaxCatchWeight = 12900,
	},
	["1,291"] = {
		Level = 1291,
		XpToNextLevel = 20441,
		MaxCatchWeight = 12910,
	},
	["1,292"] = {
		Level = 1292,
		XpToNextLevel = 20474,
		MaxCatchWeight = 12920,
	},
	["1,293"] = {
		Level = 1293,
		XpToNextLevel = 20507,
		MaxCatchWeight = 12930,
	},
	["1,294"] = {
		Level = 1294,
		XpToNextLevel = 20541,
		MaxCatchWeight = 12940,
	},
	["1,295"] = {
		Level = 1295,
		XpToNextLevel = 20574,
		MaxCatchWeight = 12950,
	},
	["1,296"] = {
		Level = 1296,
		XpToNextLevel = 20607,
		MaxCatchWeight = 12960,
	},
	["1,297"] = {
		Level = 1297,
		XpToNextLevel = 20641,
		MaxCatchWeight = 12970,
	},
	["1,298"] = {
		Level = 1298,
		XpToNextLevel = 20674,
		MaxCatchWeight = 12980,
	},
	["1,299"] = {
		Level = 1299,
		XpToNextLevel = 20708,
		MaxCatchWeight = 12990,
	},
	["1,300"] = {
		Level = 1300,
		XpToNextLevel = 20741,
		MaxCatchWeight = 13000,
	},
	["1,301"] = {
		Level = 1301,
		XpToNextLevel = 20775,
		MaxCatchWeight = 13010,
	},
	["1,302"] = {
		Level = 1302,
		XpToNextLevel = 20808,
		MaxCatchWeight = 13020,
	},
	["1,303"] = {
		Level = 1303,
		XpToNextLevel = 20842,
		MaxCatchWeight = 13030,
	},
	["1,304"] = {
		Level = 1304,
		XpToNextLevel = 20876,
		MaxCatchWeight = 13040,
	},
	["1,305"] = {
		Level = 1305,
		XpToNextLevel = 20909,
		MaxCatchWeight = 13050,
	},
	["1,306"] = {
		Level = 1306,
		XpToNextLevel = 20943,
		MaxCatchWeight = 13060,
	},
	["1,307"] = {
		Level = 1307,
		XpToNextLevel = 20977,
		MaxCatchWeight = 13070,
	},
	["1,308"] = {
		Level = 1308,
		XpToNextLevel = 21010,
		MaxCatchWeight = 13080,
	},
	["1,309"] = {
		Level = 1309,
		XpToNextLevel = 21044,
		MaxCatchWeight = 13090,
	},
	["1,310"] = {
		Level = 1310,
		XpToNextLevel = 21078,
		MaxCatchWeight = 13100,
	},
	["1,311"] = {
		Level = 1311,
		XpToNextLevel = 21112,
		MaxCatchWeight = 13110,
	},
	["1,312"] = {
		Level = 1312,
		XpToNextLevel = 21146,
		MaxCatchWeight = 13120,
	},
	["1,313"] = {
		Level = 1313,
		XpToNextLevel = 21179,
		MaxCatchWeight = 13130,
	},
	["1,314"] = {
		Level = 1314,
		XpToNextLevel = 21213,
		MaxCatchWeight = 13140,
	},
	["1,315"] = {
		Level = 1315,
		XpToNextLevel = 21247,
		MaxCatchWeight = 13150,
	},
	["1,316"] = {
		Level = 1316,
		XpToNextLevel = 21281,
		MaxCatchWeight = 13160,
	},
	["1,317"] = {
		Level = 1317,
		XpToNextLevel = 21315,
		MaxCatchWeight = 13170,
	},
	["1,318"] = {
		Level = 1318,
		XpToNextLevel = 21349,
		MaxCatchWeight = 13180,
	},
	["1,319"] = {
		Level = 1319,
		XpToNextLevel = 21383,
		MaxCatchWeight = 13190,
	},
	["1,320"] = {
		Level = 1320,
		XpToNextLevel = 21417,
		MaxCatchWeight = 13200,
	},
	["1,321"] = {
		Level = 1321,
		XpToNextLevel = 21452,
		MaxCatchWeight = 13210,
	},
	["1,322"] = {
		Level = 1322,
		XpToNextLevel = 21486,
		MaxCatchWeight = 13220,
	},
	["1,323"] = {
		Level = 1323,
		XpToNextLevel = 21520,
		MaxCatchWeight = 13230,
	},
	["1,324"] = {
		Level = 1324,
		XpToNextLevel = 21554,
		MaxCatchWeight = 13240,
	},
	["1,325"] = {
		Level = 1325,
		XpToNextLevel = 21588,
		MaxCatchWeight = 13250,
	},
	["1,326"] = {
		Level = 1326,
		XpToNextLevel = 21622,
		MaxCatchWeight = 13260,
	},
	["1,327"] = {
		Level = 1327,
		XpToNextLevel = 21657,
		MaxCatchWeight = 13270,
	},
	["1,328"] = {
		Level = 1328,
		XpToNextLevel = 21691,
		MaxCatchWeight = 13280,
	},
	["1,329"] = {
		Level = 1329,
		XpToNextLevel = 21725,
		MaxCatchWeight = 13290,
	},
	["1,330"] = {
		Level = 1330,
		XpToNextLevel = 21760,
		MaxCatchWeight = 13300,
	},
	["1,331"] = {
		Level = 1331,
		XpToNextLevel = 21794,
		MaxCatchWeight = 13310,
	},
	["1,332"] = {
		Level = 1332,
		XpToNextLevel = 21829,
		MaxCatchWeight = 13320,
	},
	["1,333"] = {
		Level = 1333,
		XpToNextLevel = 21863,
		MaxCatchWeight = 13330,
	},
	["1,334"] = {
		Level = 1334,
		XpToNextLevel = 21897,
		MaxCatchWeight = 13340,
	},
	["1,335"] = {
		Level = 1335,
		XpToNextLevel = 21932,
		MaxCatchWeight = 13350,
	},
	["1,336"] = {
		Level = 1336,
		XpToNextLevel = 21966,
		MaxCatchWeight = 13360,
	},
	["1,337"] = {
		Level = 1337,
		XpToNextLevel = 22001,
		MaxCatchWeight = 13370,
	},
	["1,338"] = {
		Level = 1338,
		XpToNextLevel = 22036,
		MaxCatchWeight = 13380,
	},
	["1,339"] = {
		Level = 1339,
		XpToNextLevel = 22070,
		MaxCatchWeight = 13390,
	},
	["1,340"] = {
		Level = 1340,
		XpToNextLevel = 22105,
		MaxCatchWeight = 13400,
	},
	["1,341"] = {
		Level = 1341,
		XpToNextLevel = 22140,
		MaxCatchWeight = 13410,
	},
	["1,342"] = {
		Level = 1342,
		XpToNextLevel = 22174,
		MaxCatchWeight = 13420,
	},
	["1,343"] = {
		Level = 1343,
		XpToNextLevel = 22209,
		MaxCatchWeight = 13430,
	},
	["1,344"] = {
		Level = 1344,
		XpToNextLevel = 22244,
		MaxCatchWeight = 13440,
	},
	["1,345"] = {
		Level = 1345,
		XpToNextLevel = 22279,
		MaxCatchWeight = 13450,
	},
	["1,346"] = {
		Level = 1346,
		XpToNextLevel = 22313,
		MaxCatchWeight = 13460,
	},
	["1,347"] = {
		Level = 1347,
		XpToNextLevel = 22348,
		MaxCatchWeight = 13470,
	},
	["1,348"] = {
		Level = 1348,
		XpToNextLevel = 22383,
		MaxCatchWeight = 13480,
	},
	["1,349"] = {
		Level = 1349,
		XpToNextLevel = 22418,
		MaxCatchWeight = 13490,
	},
	["1,350"] = {
		Level = 1350,
		XpToNextLevel = 22453,
		MaxCatchWeight = 13500,
	},
	["1,351"] = {
		Level = 1351,
		XpToNextLevel = 22488,
		MaxCatchWeight = 13510,
	},
	["1,352"] = {
		Level = 1352,
		XpToNextLevel = 22523,
		MaxCatchWeight = 13520,
	},
	["1,353"] = {
		Level = 1353,
		XpToNextLevel = 22558,
		MaxCatchWeight = 13530,
	},
	["1,354"] = {
		Level = 1354,
		XpToNextLevel = 22593,
		MaxCatchWeight = 13540,
	},
	["1,355"] = {
		Level = 1355,
		XpToNextLevel = 22628,
		MaxCatchWeight = 13550,
	},
	["1,356"] = {
		Level = 1356,
		XpToNextLevel = 22663,
		MaxCatchWeight = 13560,
	},
	["1,357"] = {
		Level = 1357,
		XpToNextLevel = 22698,
		MaxCatchWeight = 13570,
	},
	["1,358"] = {
		Level = 1358,
		XpToNextLevel = 22733,
		MaxCatchWeight = 13580,
	},
	["1,359"] = {
		Level = 1359,
		XpToNextLevel = 22769,
		MaxCatchWeight = 13590,
	},
	["1,360"] = {
		Level = 1360,
		XpToNextLevel = 22804,
		MaxCatchWeight = 13600,
	},
	["1,361"] = {
		Level = 1361,
		XpToNextLevel = 22839,
		MaxCatchWeight = 13610,
	},
	["1,362"] = {
		Level = 1362,
		XpToNextLevel = 22874,
		MaxCatchWeight = 13620,
	},
	["1,363"] = {
		Level = 1363,
		XpToNextLevel = 22910,
		MaxCatchWeight = 13630,
	},
	["1,364"] = {
		Level = 1364,
		XpToNextLevel = 22945,
		MaxCatchWeight = 13640,
	},
	["1,365"] = {
		Level = 1365,
		XpToNextLevel = 22980,
		MaxCatchWeight = 13650,
	},
	["1,366"] = {
		Level = 1366,
		XpToNextLevel = 23016,
		MaxCatchWeight = 13660,
	},
	["1,367"] = {
		Level = 1367,
		XpToNextLevel = 23051,
		MaxCatchWeight = 13670,
	},
	["1,368"] = {
		Level = 1368,
		XpToNextLevel = 23087,
		MaxCatchWeight = 13680,
	},
	["1,369"] = {
		Level = 1369,
		XpToNextLevel = 23122,
		MaxCatchWeight = 13690,
	},
	["1,370"] = {
		Level = 1370,
		XpToNextLevel = 23158,
		MaxCatchWeight = 13700,
	},
	["1,371"] = {
		Level = 1371,
		XpToNextLevel = 23193,
		MaxCatchWeight = 13710,
	},
	["1,372"] = {
		Level = 1372,
		XpToNextLevel = 23229,
		MaxCatchWeight = 13720,
	},
	["1,373"] = {
		Level = 1373,
		XpToNextLevel = 23264,
		MaxCatchWeight = 13730,
	},
	["1,374"] = {
		Level = 1374,
		XpToNextLevel = 23300,
		MaxCatchWeight = 13740,
	},
	["1,375"] = {
		Level = 1375,
		XpToNextLevel = 23335,
		MaxCatchWeight = 13750,
	},
	["1,376"] = {
		Level = 1376,
		XpToNextLevel = 23371,
		MaxCatchWeight = 13760,
	},
	["1,377"] = {
		Level = 1377,
		XpToNextLevel = 23407,
		MaxCatchWeight = 13770,
	},
	["1,378"] = {
		Level = 1378,
		XpToNextLevel = 23443,
		MaxCatchWeight = 13780,
	},
	["1,379"] = {
		Level = 1379,
		XpToNextLevel = 23478,
		MaxCatchWeight = 13790,
	},
	["1,380"] = {
		Level = 1380,
		XpToNextLevel = 23514,
		MaxCatchWeight = 13800,
	},
	["1,381"] = {
		Level = 1381,
		XpToNextLevel = 23550,
		MaxCatchWeight = 13810,
	},
	["1,382"] = {
		Level = 1382,
		XpToNextLevel = 23586,
		MaxCatchWeight = 13820,
	},
	["1,383"] = {
		Level = 1383,
		XpToNextLevel = 23622,
		MaxCatchWeight = 13830,
	},
	["1,384"] = {
		Level = 1384,
		XpToNextLevel = 23658,
		MaxCatchWeight = 13840,
	},
	["1,385"] = {
		Level = 1385,
		XpToNextLevel = 23693,
		MaxCatchWeight = 13850,
	},
	["1,386"] = {
		Level = 1386,
		XpToNextLevel = 23729,
		MaxCatchWeight = 13860,
	},
	["1,387"] = {
		Level = 1387,
		XpToNextLevel = 23765,
		MaxCatchWeight = 13870,
	},
	["1,388"] = {
		Level = 1388,
		XpToNextLevel = 23801,
		MaxCatchWeight = 13880,
	},
	["1,389"] = {
		Level = 1389,
		XpToNextLevel = 23837,
		MaxCatchWeight = 13890,
	},
	["1,390"] = {
		Level = 1390,
		XpToNextLevel = 23874,
		MaxCatchWeight = 13900,
	},
	["1,391"] = {
		Level = 1391,
		XpToNextLevel = 23910,
		MaxCatchWeight = 13910,
	},
	["1,392"] = {
		Level = 1392,
		XpToNextLevel = 23946,
		MaxCatchWeight = 13920,
	},
	["1,393"] = {
		Level = 1393,
		XpToNextLevel = 23982,
		MaxCatchWeight = 13930,
	},
	["1,394"] = {
		Level = 1394,
		XpToNextLevel = 24018,
		MaxCatchWeight = 13940,
	},
	["1,395"] = {
		Level = 1395,
		XpToNextLevel = 24054,
		MaxCatchWeight = 13950,
	},
	["1,396"] = {
		Level = 1396,
		XpToNextLevel = 24091,
		MaxCatchWeight = 13960,
	},
	["1,397"] = {
		Level = 1397,
		XpToNextLevel = 24127,
		MaxCatchWeight = 13970,
	},
	["1,398"] = {
		Level = 1398,
		XpToNextLevel = 24163,
		MaxCatchWeight = 13980,
	},
	["1,399"] = {
		Level = 1399,
		XpToNextLevel = 24199,
		MaxCatchWeight = 13990,
	},
	["1,400"] = {
		Level = 1400,
		XpToNextLevel = 24236,
		MaxCatchWeight = 14000,
	},
	["1,401"] = {
		Level = 1401,
		XpToNextLevel = 24272,
		MaxCatchWeight = 14010,
	},
	["1,402"] = {
		Level = 1402,
		XpToNextLevel = 24309,
		MaxCatchWeight = 14020,
	},
	["1,403"] = {
		Level = 1403,
		XpToNextLevel = 24345,
		MaxCatchWeight = 14030,
	},
	["1,404"] = {
		Level = 1404,
		XpToNextLevel = 24382,
		MaxCatchWeight = 14040,
	},
	["1,405"] = {
		Level = 1405,
		XpToNextLevel = 24418,
		MaxCatchWeight = 14050,
	},
	["1,406"] = {
		Level = 1406,
		XpToNextLevel = 24455,
		MaxCatchWeight = 14060,
	},
	["1,407"] = {
		Level = 1407,
		XpToNextLevel = 24491,
		MaxCatchWeight = 14070,
	},
	["1,408"] = {
		Level = 1408,
		XpToNextLevel = 24528,
		MaxCatchWeight = 14080,
	},
	["1,409"] = {
		Level = 1409,
		XpToNextLevel = 24564,
		MaxCatchWeight = 14090,
	},
	["1,410"] = {
		Level = 1410,
		XpToNextLevel = 24601,
		MaxCatchWeight = 14100,
	},
	["1,411"] = {
		Level = 1411,
		XpToNextLevel = 24638,
		MaxCatchWeight = 14110,
	},
	["1,412"] = {
		Level = 1412,
		XpToNextLevel = 24674,
		MaxCatchWeight = 14120,
	},
	["1,413"] = {
		Level = 1413,
		XpToNextLevel = 24711,
		MaxCatchWeight = 14130,
	},
	["1,414"] = {
		Level = 1414,
		XpToNextLevel = 24748,
		MaxCatchWeight = 14140,
	},
	["1,415"] = {
		Level = 1415,
		XpToNextLevel = 24785,
		MaxCatchWeight = 14150,
	},
	["1,416"] = {
		Level = 1416,
		XpToNextLevel = 24821,
		MaxCatchWeight = 14160,
	},
	["1,417"] = {
		Level = 1417,
		XpToNextLevel = 24858,
		MaxCatchWeight = 14170,
	},
	["1,418"] = {
		Level = 1418,
		XpToNextLevel = 24895,
		MaxCatchWeight = 14180,
	},
	["1,419"] = {
		Level = 1419,
		XpToNextLevel = 24932,
		MaxCatchWeight = 14190,
	},
	["1,420"] = {
		Level = 1420,
		XpToNextLevel = 24969,
		MaxCatchWeight = 14200,
	},
	["1,421"] = {
		Level = 1421,
		XpToNextLevel = 25006,
		MaxCatchWeight = 14210,
	},
	["1,422"] = {
		Level = 1422,
		XpToNextLevel = 25043,
		MaxCatchWeight = 14220,
	},
	["1,423"] = {
		Level = 1423,
		XpToNextLevel = 25080,
		MaxCatchWeight = 14230,
	},
	["1,424"] = {
		Level = 1424,
		XpToNextLevel = 25117,
		MaxCatchWeight = 14240,
	},
	["1,425"] = {
		Level = 1425,
		XpToNextLevel = 25154,
		MaxCatchWeight = 14250,
	},
	["1,426"] = {
		Level = 1426,
		XpToNextLevel = 25191,
		MaxCatchWeight = 14260,
	},
	["1,427"] = {
		Level = 1427,
		XpToNextLevel = 25228,
		MaxCatchWeight = 14270,
	},
	["1,428"] = {
		Level = 1428,
		XpToNextLevel = 25265,
		MaxCatchWeight = 14280,
	},
	["1,429"] = {
		Level = 1429,
		XpToNextLevel = 25303,
		MaxCatchWeight = 14290,
	},
	["1,430"] = {
		Level = 1430,
		XpToNextLevel = 25340,
		MaxCatchWeight = 14300,
	},
	["1,431"] = {
		Level = 1431,
		XpToNextLevel = 25377,
		MaxCatchWeight = 14310,
	},
	["1,432"] = {
		Level = 1432,
		XpToNextLevel = 25414,
		MaxCatchWeight = 14320,
	},
	["1,433"] = {
		Level = 1433,
		XpToNextLevel = 25452,
		MaxCatchWeight = 14330,
	},
	["1,434"] = {
		Level = 1434,
		XpToNextLevel = 25489,
		MaxCatchWeight = 14340,
	},
	["1,435"] = {
		Level = 1435,
		XpToNextLevel = 25526,
		MaxCatchWeight = 14350,
	},
	["1,436"] = {
		Level = 1436,
		XpToNextLevel = 25564,
		MaxCatchWeight = 14360,
	},
	["1,437"] = {
		Level = 1437,
		XpToNextLevel = 25601,
		MaxCatchWeight = 14370,
	},
	["1,438"] = {
		Level = 1438,
		XpToNextLevel = 25639,
		MaxCatchWeight = 14380,
	},
	["1,439"] = {
		Level = 1439,
		XpToNextLevel = 25676,
		MaxCatchWeight = 14390,
	},
	["1,440"] = {
		Level = 1440,
		XpToNextLevel = 25714,
		MaxCatchWeight = 14400,
	},
	["1,441"] = {
		Level = 1441,
		XpToNextLevel = 25751,
		MaxCatchWeight = 14410,
	},
	["1,442"] = {
		Level = 1442,
		XpToNextLevel = 25789,
		MaxCatchWeight = 14420,
	},
	["1,443"] = {
		Level = 1443,
		XpToNextLevel = 25826,
		MaxCatchWeight = 14430,
	},
	["1,444"] = {
		Level = 1444,
		XpToNextLevel = 25864,
		MaxCatchWeight = 14440,
	},
	["1,445"] = {
		Level = 1445,
		XpToNextLevel = 25902,
		MaxCatchWeight = 14450,
	},
	["1,446"] = {
		Level = 1446,
		XpToNextLevel = 25939,
		MaxCatchWeight = 14460,
	},
	["1,447"] = {
		Level = 1447,
		XpToNextLevel = 25977,
		MaxCatchWeight = 14470,
	},
	["1,448"] = {
		Level = 1448,
		XpToNextLevel = 26015,
		MaxCatchWeight = 14480,
	},
	["1,449"] = {
		Level = 1449,
		XpToNextLevel = 26052,
		MaxCatchWeight = 14490,
	},
	["1,450"] = {
		Level = 1450,
		XpToNextLevel = 26090,
		MaxCatchWeight = 14500,
	},
	["1,451"] = {
		Level = 1451,
		XpToNextLevel = 26128,
		MaxCatchWeight = 14510,
	},
	["1,452"] = {
		Level = 1452,
		XpToNextLevel = 26166,
		MaxCatchWeight = 14520,
	},
	["1,453"] = {
		Level = 1453,
		XpToNextLevel = 26204,
		MaxCatchWeight = 14530,
	},
	["1,454"] = {
		Level = 1454,
		XpToNextLevel = 26242,
		MaxCatchWeight = 14540,
	},
	["1,455"] = {
		Level = 1455,
		XpToNextLevel = 26280,
		MaxCatchWeight = 14550,
	},
	["1,456"] = {
		Level = 1456,
		XpToNextLevel = 26318,
		MaxCatchWeight = 14560,
	},
	["1,457"] = {
		Level = 1457,
		XpToNextLevel = 26356,
		MaxCatchWeight = 14570,
	},
	["1,458"] = {
		Level = 1458,
		XpToNextLevel = 26394,
		MaxCatchWeight = 14580,
	},
	["1,459"] = {
		Level = 1459,
		XpToNextLevel = 26432,
		MaxCatchWeight = 14590,
	},
	["1,460"] = {
		Level = 1460,
		XpToNextLevel = 26470,
		MaxCatchWeight = 14600,
	},
	["1,461"] = {
		Level = 1461,
		XpToNextLevel = 26508,
		MaxCatchWeight = 14610,
	},
	["1,462"] = {
		Level = 1462,
		XpToNextLevel = 26546,
		MaxCatchWeight = 14620,
	},
	["1,463"] = {
		Level = 1463,
		XpToNextLevel = 26584,
		MaxCatchWeight = 14630,
	},
	["1,464"] = {
		Level = 1464,
		XpToNextLevel = 26622,
		MaxCatchWeight = 14640,
	},
	["1,465"] = {
		Level = 1465,
		XpToNextLevel = 26661,
		MaxCatchWeight = 14650,
	},
	["1,466"] = {
		Level = 1466,
		XpToNextLevel = 26699,
		MaxCatchWeight = 14660,
	},
	["1,467"] = {
		Level = 1467,
		XpToNextLevel = 26737,
		MaxCatchWeight = 14670,
	},
	["1,468"] = {
		Level = 1468,
		XpToNextLevel = 26775,
		MaxCatchWeight = 14680,
	},
	["1,469"] = {
		Level = 1469,
		XpToNextLevel = 26814,
		MaxCatchWeight = 14690,
	},
	["1,470"] = {
		Level = 1470,
		XpToNextLevel = 26852,
		MaxCatchWeight = 14700,
	},
	["1,471"] = {
		Level = 1471,
		XpToNextLevel = 26890,
		MaxCatchWeight = 14710,
	},
	["1,472"] = {
		Level = 1472,
		XpToNextLevel = 26929,
		MaxCatchWeight = 14720,
	},
	["1,473"] = {
		Level = 1473,
		XpToNextLevel = 26967,
		MaxCatchWeight = 14730,
	},
	["1,474"] = {
		Level = 1474,
		XpToNextLevel = 27006,
		MaxCatchWeight = 14740,
	},
	["1,475"] = {
		Level = 1475,
		XpToNextLevel = 27044,
		MaxCatchWeight = 14750,
	},
	["1,476"] = {
		Level = 1476,
		XpToNextLevel = 27083,
		MaxCatchWeight = 14760,
	},
	["1,477"] = {
		Level = 1477,
		XpToNextLevel = 27121,
		MaxCatchWeight = 14770,
	},
	["1,478"] = {
		Level = 1478,
		XpToNextLevel = 27160,
		MaxCatchWeight = 14780,
	},
	["1,479"] = {
		Level = 1479,
		XpToNextLevel = 27199,
		MaxCatchWeight = 14790,
	},
	["1,480"] = {
		Level = 1480,
		XpToNextLevel = 27237,
		MaxCatchWeight = 14800,
	},
	["1,481"] = {
		Level = 1481,
		XpToNextLevel = 27276,
		MaxCatchWeight = 14810,
	},
	["1,482"] = {
		Level = 1482,
		XpToNextLevel = 27315,
		MaxCatchWeight = 14820,
	},
	["1,483"] = {
		Level = 1483,
		XpToNextLevel = 27353,
		MaxCatchWeight = 14830,
	},
	["1,484"] = {
		Level = 1484,
		XpToNextLevel = 27392,
		MaxCatchWeight = 14840,
	},
	["1,485"] = {
		Level = 1485,
		XpToNextLevel = 27431,
		MaxCatchWeight = 14850,
	},
	["1,486"] = {
		Level = 1486,
		XpToNextLevel = 27470,
		MaxCatchWeight = 14860,
	},
	["1,487"] = {
		Level = 1487,
		XpToNextLevel = 27509,
		MaxCatchWeight = 14870,
	},
	["1,488"] = {
		Level = 1488,
		XpToNextLevel = 27548,
		MaxCatchWeight = 14880,
	},
	["1,489"] = {
		Level = 1489,
		XpToNextLevel = 27586,
		MaxCatchWeight = 14890,
	},
	["1,490"] = {
		Level = 1490,
		XpToNextLevel = 27625,
		MaxCatchWeight = 14900,
	},
	["1,491"] = {
		Level = 1491,
		XpToNextLevel = 27664,
		MaxCatchWeight = 14910,
	},
	["1,492"] = {
		Level = 1492,
		XpToNextLevel = 27703,
		MaxCatchWeight = 14920,
	},
	["1,493"] = {
		Level = 1493,
		XpToNextLevel = 27742,
		MaxCatchWeight = 14930,
	},
	["1,494"] = {
		Level = 1494,
		XpToNextLevel = 27781,
		MaxCatchWeight = 14940,
	},
	["1,495"] = {
		Level = 1495,
		XpToNextLevel = 27821,
		MaxCatchWeight = 14950,
	},
	["1,496"] = {
		Level = 1496,
		XpToNextLevel = 27860,
		MaxCatchWeight = 14960,
	},
	["1,497"] = {
		Level = 1497,
		XpToNextLevel = 27899,
		MaxCatchWeight = 14970,
	},
	["1,498"] = {
		Level = 1498,
		XpToNextLevel = 27938,
		MaxCatchWeight = 14980,
	},
	["1,499"] = {
		Level = 1499,
		XpToNextLevel = 27977,
		MaxCatchWeight = 14990,
	},
	["1,500"] = {
		Level = 1500,
		XpToNextLevel = 0,
		MaxCatchWeight = 15000,
	},
}

return data