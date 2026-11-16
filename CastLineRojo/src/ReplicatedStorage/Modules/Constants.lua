local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RarityConfig = require(script.Parent.RarityConfig)
local Constants = {}

-- 发布设置
-- 发布前必须设置为 false
Constants.DEBUG = false
-- Constants.DEBUG = true  -- 测试用

Constants.UPDATE_VERSION = "1.0"    -- 用于判断显示更新界面给用户
-- Constants.RESOURCE_VERSION = "0.0.3"  -- 详细版本号, 格式为三位, 细分小版本，用于 更新界面显示 和 GA
Constants.CODE_VERSION = "1"  -- 代码版本号，用于判断代码版本
Constants.PLAYER_TITLE_GUI_ENABLED = true -- 玩家头顶名牌
Constants.RESOURCE_VERSION = Workspace:WaitForChild("Version").Value

Constants.WEEKEND_EVENT_STRENGTH_ENABLED = false    -- 临时关闭周末力量加倍
Constants.WEEKEND_EVENT_WINS_ENABLED = false

Constants.CHARACTER_DEFAULT_PARAMS = {
    JUMP_POWER = 50,
}

Constants.CHARACTER_PHYSICS = {
    MASS = 10,
    HRP_DENSITY = 2,
    HRP_FRICTION = 1.0,
    HRP_ELASTICITY = 0,
    HRP_FRICTION_WEIGHT = 1,
    HRP_ELASTICITY_WEIGHT = 1,
}

Constants.ANIMAL_LEVEL_NAMES = {
    [0] = "1️⃣ Baby",
    [1] = "2️⃣ Small",
    [2] = "3️⃣ Big", 
    [3] = "4️⃣ Large",
    [4] = "5️⃣ Huge",
    [5] = "6️⃣ Giant",
    [6] = "7️⃣ Mega",
    [7] = "8️⃣ Ultra",
    [8] = "9️⃣ Colossal",
}

Constants.ANIMAL_LEVEL_MOVE_SPEED_ADD = {
    [0] = 0,
    [1] = 5,
    [2] = 10,
    [3] = 15,
    [4] = 20,
    [5] = 25,
    [6] = 30,
    [7] = 35,
    [8] = 40,
}

Constants.SYSTEM_NOTIFICATION_DURATION = 60 * 5       -- 系统通知显示时间
-- Constants.SYSTEM_NOTIFICATION_DURATION = 10         -- 系统通知显示时间, 测试用

Constants.LEADERBOARD_UPDATE_INTERVAL = 60 * 5    -- 排行榜更新间隔
-- Constants.LEADERBOARD_UPDATE_INTERVAL = 15          -- 排行榜更新间隔，测试用

Constants.MAX_IDLED_TIME = 60 * 18  -- 最长挂机时间，超时后会被重新重送
-- Constants.MAX_IDLED_TIME = 60 * 1    -- 最长挂机时间，超时后会被重新重送，测试用

Constants.CHEST_OPEN_COOLDOWN = 60 * 60 * 24
-- Constants.CHEST_OPEN_COOLDOWN = 5         -- 宝箱开启冷却时间，测试用

Constants.ONLINE_STARTER_PACK_TIME = 60 * 35      -- 新手礼包获得时间
-- Constants.ONLINE_STARTER_PACK_TIME = 60 * 1      -- 新手礼包获得时间,测试用
Constants.ONLINE_ADVANCED_PACK_TIME = 60 * 55      -- 进阶礼包获得时间
-- Constants.ONLINE_ADVANCED_PACK_TIME = 60 * 1       -- 进阶礼包获得时间,，测试用
Constants.ONLINE_QUEST_TIME = 60 * 16       -- 任务奖励时间
-- Constants.ONLINE_QUEST_TIME = 30      -- 任务奖励时间,，测试用
Constants.ONLINE_REWARDS_TIME = {                       -- 在线奖励时间
    [1] = 30 * 1, [2] = 60 * 2, [3] = 60 * 5, [4] = 60 * 7,
    [5] = 60 * 10, [6] = 60 * 15, [7] = 60 * 20, [8] = 60 * 30,
    [9] = 60 * 45, [10] = 60 * 60, [11] = 60 * 90, [12] = 60 * 120,
}
-- Constants.ONLINE_REWARDS_TIME = {        -- 在线奖励时间，测试用
--     [1] = 10, [2] = 25, [3] = 30, [4] = 40,
--     [5] = 50, [6] = 60, [7] = 70, [8] = 80,
--     [9] = 90, [10] = 100, [11] = 110, [12] = 120,
-- }
Constants.SPINNING_WHEEL_TIME = 60 * 60 * 24
-- Constants.SPINNING_WHEEL_TIME = 20       -- 转盘冷却时间，测试用
Constants.SPINNING_WHEEL_ROTATION_TIME = 2

Constants.TRADE_TIME = {
    LOGIN_WAIT_TIME = 10, REQUEST_COOLDOWN = 15, CONFIRM_COOLDOWN = 5,
}

Constants.BADGE_ID = {
    WELCOME = 3903321308228340, WORLD_1 = 4468422012464160, WORLD_2 = 1826995868383382, WORLD_3 = 1169870335791720, WORLD_4 = 2435384010893845,
}

-- 转盘概率
Constants.SPINNING_WHEEL_CHANCE = {
	[1] = 350,           -- Double Wins Potion x2
    [2] = 250,           -- 500 Cash
	[3] = 350,           -- Double Exp Potion x1
    [4] = 49,            -- 25K Cash
    [5] = 350,             -- 100K Wins
}
Constants.CHEST_DAILY_CHANCE = {
	[1] = 40,           -- Potion_DoubleWins
	[2] = 32,           -- Potion_DoubleExp
	[3] = 18,           -- Potion_DoubleWinsSpeed
	[4] = 9,            -- Potion_Mutation
	[5] = 1,            -- Potion_Mutation
}

Constants.TRADE_HINT = {
    COMFIRM = "Press Confirm when you are satisfied with the trade!",
    COUNTDOWN = "⏳ #TIME seconds left...",

}


Constants.IMAGE = {
    WINS_ICON = "rbxassetid://116177940074290",
    STRENGTH_ICON = "rbxassetid://16572548460",
    DIAMOND_ICON = "rbxassetid://14630831827",
    SPIN = "rbxassetid://16876789994",
}

Constants.MAX_RANDOM_POTION_BUY_NUM = 4         -- 随机药水购买次数
Constants.RANDOM_POTION_BUY_COOLDOWN = 60 * 12  -- 随机药水购买冷却时间
Constants.RANDOM_POTION_PRICE = 10     -- 随机药水价格
Constants.POTION_IDS = {
	"Potion_DoubleWins",
	"Potion_DoubleWinsSpeed",
	"Potion_DoubleExp",
	"Potion_Mutation",
}

-- Set to true when Potion rewards and sales are ready to be re-enabled.
Constants.POTION_ACQUISITION_ENABLED = false

Constants.NOTIFICATION_NO_ENOUGH_WIN = "Not enough Cash 💴"
Constants.NOTIFICATION_NO_ENOUGH_DIAMOND = "Not enough Diamonds 💎"
Constants.NOTIFICATION = {
    REBIRTH_SUCCESS = "🎉 Rebirth to {amount}",
    SUPER_REBIRTH_SUCCESS = "🎉 Super Rebirth Success!",
    ALREADY_OWN_GAME_PASS = "💡 Already own this game pass",
    CANNOT_INVITE_FRIEND = "😢 Cannot invite friend",
    GOT_WINS = "💴 Got #NUM Cash",
    GOT_STRENGTH = "⚡ Got #NUM Power",
    GOT_DIAMOND = "💎 Got #NUM Gems",
    GOT_FRUIT = "🍎 Got #FRUIT",
    GOT_FRUIT_NUM = "🍎 Got #NUM #FRUIT",
    FRUIT_SHOP_RESTOCKED = "🍎 Fruit Shop restocked!",
    GOT_PROP = "🎁 Got #PROP",
    GOT_DECOR = "🎁 Got #DECOR",
    DECOR_SHOP_RESTOCKED = "🎁 Decor Shop restocked!",
    SELL_NEED_ANIMAL = "💡 You need to hold an animal!",
    SELL_NO_ANIMALS = "💡 No animals in backpack!",
    GOT_TOKEN_NUM = "🎟️ Got #NUM Tokens",
    GOT_SPIN_NUM = "🎡 Got #NUM Spins",
    GOT_POTION = "🧪 Got #POTION Potion",
    GOT_POTION_NUM = "🧪 Got #NUM #POTION Potion",
    GOT_POTION_PACK = "🧪 Got Potion Pack",
    GOT_GAMEPASS = "🎫 Got #NAME Gamepass",
    WAIT = "⏳ Please wait",
    PURCHASE_SUCCESS = "Purchase successful! Thank you so mush! 😊❤",
    PURCHASE_GIFT_SUCCESS = "🎁 Gift sent! Thank you so mush! 😊❤",
    PURCHASE_FAIL = "❌ Purchase Fail. You have not been charged. ({failReason})",
    TRADE_DECLINE = "Trade was Cancelled 😞",
    TRADE_SUCCESS = "✅ Trade Success!",
    TRADE_FAIL_NO_ENOUGH_DIAMOND = "❌ Trade failed! Not enough Diamonds",
    TRADE_FAIL_PLAYER_NOT_FOUND = "❌ Trade failed! Player not found",
    TRADE_FAIL_PLAYER_DISCONNECTED = "❌ Trade failed! Player disconnected",
    TRADE_FAIL_INVALID_DIAMOND = "❌ Trade failed! Invalid Diamonds",
    TRADE_WAITING_CONFIRM = "⌛️ Waiting for confirmation",
    TRADE_REQUEST_SEND = "📩 Trade request sent!",
    TRADE_REQUEST_FAIL_COOLDOWN = "💡 Trade this player too fast, try later",
    TRADE_REQUEST_FAIL_WAIT_PLAYER = "💡 #NAME need to wait #TIME seconds before trading",
    TRADE_REQUEST_FAIL_IN_OTHER_REQUEST = "💡 #NAME is in other trade request",
    TRADE_REQUEST_FAIL_WAIT = "💡 Please wait",
    TRADE_REQUEST_FAIL_BE_IGNORED = "😞 Trade request with #NAME was ignored",
    TRADE_REQUEST_MESSAGE = "#NAME sent you a trade request. Do you accept?",
    TRADE_IN_PROGRESS = "💡 Trade in progress",
    TRADE_TARGET_NOT_ENOUGH_REBIRTH = "💡 #NAME trade is not unlocked",
    CODE_INVALID = "❌ Invalid Code",
    CODE_INVALID_LIMIT = "❌ Code limit reached",
    CODE_INVALID_ALREADY_REDEEMED = "❌ Code already redeemed",
    CODE_GOT_ALL_GAMEPASS = "🎫 Got all gamepasses",
    CODE_GOT_VIP = "🎫 Got VIP",
    CODE_GOT_STARTER_PACK = "🎁 Got Starter Pack(ZooroMax Hero x1, Potion x5)",
    TOKENS_NOT_ENOUGH = "😢 Not enough Tokens",
    WRONG_INPUT = "💡 Wrong input",
}

Constants.COLOR = {
    -- GREEN = Color3.fromRGB(66, 207, 56),
    GREEN = Color3.fromRGB(16, 244, 0),
    GREEN_LIGHT = Color3.fromRGB(64, 252, 59),
    GREEN_DARK = Color3.fromRGB(0, 113, 51),
    RED = Color3.fromRGB(213, 5, 38),
    RED_DARK = Color3.fromRGB(144, 37, 57),
    YELLOW = Color3.fromRGB(255, 204, 0),
    YELLOW_DARK = Color3.fromRGB(107, 60, 0),
    PURPLE = Color3.fromRGB(170, 0, 255),
    PURPLE_DARK = Color3.fromRGB(94, 59, 144),
    BLUE = Color3.fromRGB(59, 177, 252),
    BLUE_LIGHT = Color3.fromRGB(64, 224, 253),
    BLUE_LIGHT_GRAY = Color3.fromRGB(217,237,255),
    BLUE_BLACK = Color3.fromRGB(28, 69, 82),
    BLUE_DARK = Color3.fromRGB(24, 88, 149),
    WHITE = Color3.fromRGB(255, 255, 255),
    COMMON_OUTLINE = Color3.fromRGB(0, 59, 86),
}

-- Regular rarity colors share the code-defined gradient midpoint; special categories keep their palette.
Constants.RARITY_COLOR = {
    Limited = Color3.fromRGB(204, 0, 2),

    Crimson = Color3.fromRGB(210, 0, 120),
    Abyssal = Color3.fromRGB(0, 220, 200),
    Transcendent= Color3.fromRGB(150, 80, 255), 

    Exclusive = Color3.fromRGB(1, 193, 255),
}
for _, entry in ipairs(RarityConfig.List) do
    Constants.RARITY_COLOR[entry.Name] = entry.Color
end
Constants.RARITY_COLOR.Mythical = Constants.RARITY_COLOR.Mythic

Constants.SUPER_REBIRTH_UPGRADE_ID = {
    DIAMONDS = "Diamonds",
}

-- Upgrade
Constants.UPGRADE_ID = {
    WINS_BOOST = "Upgrade_WinsBoost",
    MOVE_SPEED = "Upgrade_MoveSpeed",
}

Constants.GAMEPASS = {
    VIP = "VIP",
    MAGNET = "Magnet",
    DOUBLE_WINS = "DoubleWins",
    TELEPORT = "Teleport",
    AUTO_REBIRTH = "AutoRebirth",
    AUTO_OPEN_CRATE = "AutoOpenCrate",
    DOUBLE_SPEED = "DoubleSpeed",
    FAST_MOVE = "FastMove",
    DOUBLE_CARRY = "DoubleCarry",
    SUPER_LUCK = "SuperLuck",
    DOUBLE_WINS_SPEED = "DoubleWinsSpeed",
    DOUBLE_EXP = "DoubleExp",
    MEGA_LUCK = "MegaLuck",
}

Constants.PURCHASE_TYPE = {
    GAMEPASS = "GamePass",
    PACK = "Pack",
    DIAMOND = "Diamond",
    WINS = "Wins",
}

Constants.PURCHASE_ID = {
    STARTER_PACK = "StarterPack",
    ADVANCED_PACK = "AdvancedPack",
    POTION_BUNDLE = "PotionBundle",
    GAMEPASS_BUNDLE = "GamepassBundle",
    GAMEPASS_BUNDLE_1 = "GamepassBundle1",
    GAMEPASS_BUNDLE_2 = "GamepassBundle2",
    SKIP_REBIRTH = "SkipRebirth",
    SKIP_REBIRTH_FIRST_TIME = "SkipRebirth_FirstTime",
    SEASON_1 = "Season_1",
    SEASON_SKIP_LEVEL = "Season_SkipLevel",
    SEASON_UNLOCK_ALL = "Season_UnlockAll",
    SEASON_RESTART = "Season_Restart",
    SKIP_ONLINE_REWARDS = "SkipOnlineRewards",
    RESTOCK_FRUITS = "Restock Fruits",
    RESTOCK_DECOR = "Restock Decor",
    EVENT_PACK_LARGE = "EventPackLarge",
    EVENT_PACK_SMALL = "EventPackSmall",
    ONLINE_QUEST = "OnlineQuest",
    LIMITED_STARTER_PACK = "LimitedStarterPack",
    LIMITED_ADVANCED_PACK = "LimitedAdvancedPack",
    LIMITED_CHRISTMAS_PACK = "LimitedChristmasPack",
    LIMITED_SQUID_PACK = "LimitedSquidPack",
    LIMITED_DAILY_POTION_BUNDLE = "LimitedDailyPotionBundle",
}

Constants.SEASON_TASK_TYPE = {
    DAILY = "Daily",
    WEEKLY = "Weekly",
}

Constants.EVENT_REWARD_ID = {
    STARTER_PACK = "StarterPack",
    ADVANCED_PACK = "AdvancedPack",
}

Constants.DETECT_RANGE = {
    DIAMOND = 15,
    CHEST = 15,
}

Constants.SETTINGS_ID = {
    SHOW_YOUR_PETS = "ShowYourPets",
    SHOW_OTHER_PETS = "ShowOtherPets",
    MUSIC = "Music",
    AUTO_REBIRTH = "AutoRebirth",
    SOUND = "Sound",
    TRADE = "Trade",
    GLOBAL_MESSAGE = "GlobalMessage",
    PERFORMANCE_MODE = "PerformanceMode",
}

Constants.POTION_ID = {
    DOUBLE_WINS = "Potion_DoubleWins",
    DOUBLE_WINS_SPEED = "Potion_DoubleWinsSpeed",
    DOUBLE_EXP = "Potion_DoubleExp",
    MUTATION = "Potion_Mutation",
	-- 旧奖励脚本仍会传递这些 ID；PotionService 会在发奖时转换为 Mutation，
	-- 不会创建或使用这些已下架药水。
	DOUBLE_STRENGTH = "Potion_DoubleStrength",
	DOUBLE_DAMAGE = "Potion_DoubleDamage",
	SUPER_LUCKY = "Potion_SuperLucky",
	GOLDEN = "Potion_Golden",
	RAINBOW = "Potion_Rainbow",
}

Constants.POTION_LAST_TIME = {
    Potion_DoubleWins = 60 * 10,
    Potion_DoubleWinsSpeed = 60 * 10,
    Potion_DoubleExp = 60 * 10,
    Potion_Mutation = 60 * 5,
}

-- Constants.POTION_LAST_TIME = {
--     Potion_DoublePower = 20,
--     Potion_DoubleWins = 20,
--     Potion_DoubleDamage = 20,
--     Potion_SuperLucky = 20,
--     Potion_UltraLucky = 20,
-- }

Constants.AREA_NAME = {
    Area_1 = "Area_1",
}

local Sound = ReplicatedStorage:WaitForChild("Sound")

Constants.SoundRes = {
    DIAMOND_PICKUP = Sound.Attack.Gear_Pickup,
    GUI_BUTTON_CLICK = Sound.Gui.Gui_Button_Click,
    GUI_HATCH_OPEN = Sound.Gui.Gui_Fuse_Success,
    GUI_HATCH_CHEER = Sound.Gui.Gui_Fuse_Success,
    GUI_FUSE_WHEEL = Sound.Gui.Gui_Fuse_Wheel,
    GUI_FUSE_SUCCESS = Sound.Gui.Gui_Fuse_Success,
}

return Constants
