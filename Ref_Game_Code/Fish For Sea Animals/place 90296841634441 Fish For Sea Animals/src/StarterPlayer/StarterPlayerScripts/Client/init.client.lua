-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.UI.UIUtil)
local Settings = require(script.UI.Settings)
local RarityText = require(script.UI.RarityText)
local Boost = require(script.UI.Boost)
local Hud = require(script.UI.Hud)
local Tooltip = require(script.UI.Tooltip)
local Unlocks = require(script.UI.Unlocks)
local RodShop = require(script.UI.RodShop)
local BaitShop = require(script.UI.BaitShop)
local SellPanel = require(script.UI.SellPanel)
local Menus = require(script.UI.Menus)
local Backpack = require(script.UI.Backpack)
local MiniGames = require(script.MiniGames.MiniGames)
local Pads = require(script.World.Pads)
local PlotAnimals = require(script.World.PlotAnimals)
local Stands = require(script.World.Stands)
local Lift = require(script.World.Lift)
local Placement = require(script.World.Placement)
local HeldAnimal = require(script.World.HeldAnimal)
local Poses = require(script.Character.Poses)
local Controller = require(script.Fishing.Controller)
local KeepFishingButton = require(script.Fishing.KeepFishingButton)
local Spectate = require(script.Fishing.Spectate)
local RevealPreview = require(script.Fishing.RevealPreview)
local AdminPanel = require(script.UI.AdminPanel)
local SnackBubble = require(script.UI.SnackBubble)
local Offers = require(script.Shop.Offers)
local StarterPack = require(script.Shop.StarterPack)
local Showcase = require(script.World.Showcase)
local Mailbox = require(script.World.Mailbox)
local DockGlow = require(script.World.DockGlow)
local FeedbackPanel = require(script.UI.FeedbackPanel)
local RebirthBadge = require(script.UI.RebirthBadge)
local LevelBar = require(script.UI.LevelBar)
local LevelUpFx = require(script.UI.LevelUpFx)
local Intro = require(script.Intro.Intro)
local Tutorial = require(script.Tutorial.Tutorial)
local Favorite = require(script.UI.Favorite)
local WelcomeBack = require(script.UI.WelcomeBack)
local TankFull = require(script.UI.TankFull)
local Promo = require(script.Promo.Promo)
local BestMarker = require(script.World.BestMarker)
local EventHole = require(script.World.EventHole)
local Diag = require(script.Character.Diag)
local BossCombat = require(script.Boss.BossCombat)
local SubDock = require(script.World2Trip.SubDock)
local SubBossClient = require(script.SubBoss.SubBossClient)
local TripPrivacy = require(script.World2Trip.TripPrivacy)

UIUtil.init()
Diag.init()
Settings.init()
Intro.init()
RarityText.init()
Hud.init()
require(script.UI.LiveOpsClient).init()
LevelUpFx.init()
LevelBar.init()
Tooltip.init()
RodShop.init()
BaitShop.init()
SellPanel.init()
Menus.init()
Backpack.init()
MiniGames.init()
Poses.init()
PlotAnimals.init()
Stands.init()

local function busy() -- line: 74
    -- upvalues: Lift (copy), Controller (copy), RevealPreview (copy), Intro (copy), Promo (copy), BossCombat (copy), SubDock (copy), SubBossClient (copy)
    return Controller.isBusy()
        or Lift.isActive()
        or RevealPreview.isActive()
        or Intro.isPlaying()
        or Promo.isActive()
        or BossCombat.isActive()
        or SubDock.isPlaying()
        or SubBossClient.isActive()
end

local function quiet() -- line: 79
    -- upvalues: Tutorial (copy), WelcomeBack (copy), busy (copy)
    return busy() or Tutorial.isActive() or WelcomeBack.isShowing()
end

Controller.setBusyCheck(function() -- line: 82
    -- upvalues: Lift (copy), RevealPreview (copy), Intro (copy), Promo (copy), BossCombat (copy), SubDock (copy), SubBossClient (copy)
    local v1 = Lift.isActive()

    v1 = v1
        or RevealPreview.isActive()
        or Intro.isPlaying()
        or Promo.isActive()
        or BossCombat.isActive()
        or BossCombat.holdsDock()
        or SubDock.isPlaying()
        or SubBossClient.isActive()
        or SubBossClient.holdsDock()

    return v1
end)
Lift.setBusyCheck(function() -- line: 85
    -- upvalues: Controller (copy), RevealPreview (copy), Intro (copy), BossCombat (copy), SubBossClient (copy)
    return Controller.isBusy() or RevealPreview.isActive() or Intro.isPlaying() or BossCombat.isActive() or SubBossClient.isActive()
end)
RevealPreview.setBusyCheck(function() -- line: 88
    -- upvalues: Lift (copy), Controller (copy), Promo (copy), BossCombat (copy), SubBossClient (copy)
    return Controller.isBusy() or Lift.isActive() or Promo.isActive() or BossCombat.isActive() or SubBossClient.isActive()
end)
Promo.setBusyCheck(function() -- line: 91
    -- upvalues: Lift (copy), Controller (copy), RevealPreview (copy), Intro (copy)
    return Controller.isBusy() or Lift.isActive() or RevealPreview.isActive() or Intro.isPlaying()
end)
Backpack.setBusyCheck(busy)
Unlocks.setBusyCheck(quiet)
Pads.setBusyCheck(busy)
EventHole.setBusyCheck(busy)
SubDock.setBusyCheck(function() -- line: 98
    -- upvalues: Lift (copy), Controller (copy), RevealPreview (copy), Intro (copy), Promo (copy), BossCombat (copy), SubBossClient (copy)
    return Controller.isBusy()
        or Lift.isActive()
        or RevealPreview.isActive()
        or Intro.isPlaying()
        or Promo.isActive()
        or BossCombat.isActive()
        or SubBossClient.isActive()
end)
Offers.setBusyCheck(quiet)
StarterPack.setBusyCheck(quiet)
RebirthBadge.setQuietCheck(quiet)
Showcase.setHiddenCheck(Intro.isPlaying)
DockGlow.setHiddenCheck(function() -- line: 105
    -- upvalues: Controller (copy), Intro (copy)
    return Controller.isBusy() or Intro.isPlaying()
end)
Favorite.setStartCheck(Intro.isDone)
WelcomeBack.setReadyCheck(function() -- line: 109
    -- upvalues: Intro (copy), busy (copy)
    return Intro.isDone() and not busy()
end)
Favorite.setBusyCheck(function() -- line: 112
    -- upvalues: Controller (copy), RevealPreview (copy), Intro (copy), WelcomeBack (copy), Promo (copy)
    return Controller.isBusy() or RevealPreview.isActive() or Intro.isPlaying() or Promo.isActive() or WelcomeBack.isShowing()
end)
FeedbackPanel.setBusyCheck(function() -- line: 116
    -- upvalues: Controller (copy), RevealPreview (copy), Intro (copy), Promo (copy)
    return Controller.isBusy() or RevealPreview.isActive() or Intro.isPlaying() or Promo.isActive()
end)
Offers.setFishingCheck(Controller.isBusy)
Offers.setCastingCheck(Controller.isCasting)
Offers.setLuckHeldCheck(Tutorial.isActive)
StarterPack.setLiftingCheck(function() -- line: 122
    -- upvalues: MiniGames (copy), Lift (copy), WelcomeBack (copy)
    return Lift.isActive() and not MiniGames.isOpen() and not WelcomeBack.isShowing()
end)
Boost.setReadyCheck(function() -- line: 126
    -- upvalues: MiniGames (copy), Lift (copy), SnackBubble (copy)
    return Lift.isActive() and not MiniGames.isOpen() and not SnackBubble.isShowing()
end)
SnackBubble.setReadyCheck(function() -- line: 129
    -- upvalues: MiniGames (copy), Lift (copy)
    return Lift.isActive() and not MiniGames.isOpen()
end)
SnackBubble.setBlockedCheck(Boost.isShowing)
Diag.addState("fish", Controller.stateName)
Diag.addState("lift", function() -- line: 135
    -- upvalues: Lift (copy)
    return if Lift.isActive() then "on" else nil
end)
Diag.addState("busy", function() -- line: 138
    -- upvalues: MiniGames (copy), RevealPreview (copy), Intro (copy), Tutorial (copy), Promo (copy), BossCombat (copy), SubBossClient (copy)
    local t1 = {}

    for v2, v3 in {
            preview = RevealPreview.isActive(),
            intro = Intro.isPlaying(),
            promo = Promo.isActive(),
            tutorial = Tutorial.isActive(),
            minigame = MiniGames.isOpen(),
            boss = BossCombat.isActive(),
            subboss = SubBossClient.isActive()
        } do
        if v3 then
            table.insert(t1, v2)
        end
    end

    return table.concat(t1, ",")
end)
Diag.addState("hold", function() -- line: 147
    local Character = game:GetService("Players").LocalPlayer.Character

    return Character and Character:GetAttribute("Holding")
end)
Controller.init()
KeepFishingButton.init()
Spectate.init()
Lift.init()
Placement.init()
HeldAnimal.init()
BossCombat.init()
SubBossClient.init()
Pads.init()
Unlocks.init()
Boost.init()
SnackBubble.init()
Offers.init()
StarterPack.init()
Showcase.init()
Mailbox.init()
DockGlow.init()
RebirthBadge.init()
Tutorial.init()
AdminPanel.init()
Favorite.init()
WelcomeBack.init()
TankFull.init()
BestMarker.init()
EventHole.init()
SubDock.init()
TripPrivacy.init()

local Sound = Instance.new("Sound")

Sound.Name = "Ambience"
Sound.SoundId = Config.Sounds.Ambience
Sound.Looped = true
Sound.Volume = 0.35
Sound:SetAttribute("FullVolume", Sound.Volume)
Sound.SoundGroup = Settings.group("Music")
Sound.Parent = SoundService
Sound:Play()
