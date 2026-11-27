-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

for _, v1 in ipairs({
        Enum.CoreGuiType.Backpack,
        Enum.CoreGuiType.Health
    }) do
    local function v2() -- line: 7
        -- upvalues: StarterGui (copy), v1 (copy)
        StarterGui:SetCoreGuiEnabled(v1, false)
    end

    pcall(v2)
end

local Modules = script.Parent:WaitForChild("Modules")
local NumberFormat = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("NumberFormat"))
local UIKit = require(Modules.UIKit)
local DataClient = require(Modules.DataClient)
local Toasts = require(Modules.Toasts)
local Windows = require(Modules.Windows)
local HUD = require(Modules.HUD)
local ScreenFx = require(Modules.ScreenFx)
local IndexWindow = require(Modules.IndexWindow)
local CastController = require(Modules.CastController)
local RevealCutscene = require(Modules.RevealCutscene)
local FishWindows = require(Modules.FishWindows)
local PlotFish = require(Modules.PlotFish)
local TrainingController = require(Modules.TrainingController)
local BaitShop = require(Modules.BaitShop)
local RodShop = require(Modules.RodShop)
local UnlockPopup = require(Modules.UnlockPopup)
local Tutorial = require(Modules.Tutorial)
local SoundPlayer = require(Modules.SoundPlayer)
local HeldFish = require(Modules.HeldFish)
local ShopWindow = require(Modules.ShopWindow)
local EventFx = require(Modules.EventFx)
local SettingsWindow = require(Modules.SettingsWindow)
local PowerControl = require(Modules.PowerControl)
local ZoneAmbience = require(Modules.ZoneAmbience)
local BaitOffer = require(Modules.BaitOffer)
local CashOffer = require(Modules.CashOffer)
local StarterOffer = require(Modules.StarterOffer)
local TrainBonus = require(Modules.TrainBonus)
local HeldOthers = require(Modules.HeldOthers)
local AquariumView = require(Modules.AquariumView)
local OfflineEarnings = require(Modules.OfflineEarnings)
local EggHatch = require(Modules.EggHatch)
local HeldEgg = require(Modules.HeldEgg)
local AntiAfk = require(Modules.AntiAfk)
local PriceColors = require(Modules.PriceColors)
local AnnounceBanner = require(Modules.AnnounceBanner)
local AdminAnnouncementController = require(Modules.AdminAnnouncementController)
local ServerLuckHud = require(Modules.ServerLuckHud)
local ProgressionUI = require(Modules.ProgressionUI)
local TopBar = require(Modules.TopBar)
local SkipButton = require(Modules.SkipButton)
local CosmicEvent = require(Modules.CosmicEvent)
local BuffHud = require(Modules.BuffHud)
local StatusTray = require(Modules.StatusTray)
local CosmicBattle = require(Modules.CosmicBattle)
local CosmicSky = require(Modules.CosmicSky)
local AdminPanel = require(Modules.AdminPanel)
local TradeWindow = require(Modules.TradeWindow)
local CameraGuard = require(Modules.CameraGuard)

Toasts.Init()
Windows.Init()
HUD.Init()
TopBar.Init()
ScreenFx.Init()
IndexWindow.Init()
CastController.Init()
RevealCutscene.Init()
FishWindows.Init()
PlotFish.Init()
TrainingController.Init()
BaitShop.Init()
RodShop.Init()
UnlockPopup.Init()

UnlockPopup.OnShop = function(p1) -- line: 77
    -- upvalues: BaitShop (copy)
    BaitShop.Open(p1)
end

Tutorial.Init()
SoundPlayer.Init()
HeldFish.Init()
ShopWindow.Init()
EventFx.Init()
SettingsWindow.Init()
PowerControl.Init()
ZoneAmbience.Init()
BaitOffer.Init()
CashOffer.Init()
StarterOffer.Init()
TrainBonus.Init()
HeldOthers.Init()
AquariumView.Init()
OfflineEarnings.Init()
EggHatch.Init()
HeldEgg.Init()
AntiAfk.Init()
PriceColors.Init()
AnnounceBanner.Init()
AdminAnnouncementController:Initialize()
ServerLuckHud.Init()
ProgressionUI.Init()

local Shared = require(Modules.DailyLogin).Shared

Shared.Blocked = function() -- line: 104
    -- upvalues: Modules (copy), Tutorial (copy), OfflineEarnings (copy)
    return Tutorial.Active() or OfflineEarnings.Busy() or require(Modules.TutorialComplete).Busy()
end

Shared:Start()

local Shared2 = require(Modules.TierLadderUI).Shared

Shared2:Start()

local Shared3 = require(Modules.RandomFishOffer).Shared

Shared3:Start(function(p2) -- line: 111
    -- upvalues: HeldFish (copy)
    HeldFish.Show({
        uid = p2.uid,
        fishId = p2.fishId,
        variant = p2.variant,
        size = p2.size,
        base = p2.base
    }, true)
end)
SkipButton.Init()
BuffHud.Init()
StatusTray.Init()
CosmicEvent.Init()
AdminPanel.Init()
TradeWindow.Init()
CameraGuard.new():Start()

local v3 = require(Modules.GoalTracker).new()

v3.Hidden = Tutorial.Active
v3:Start()
require(Modules.LuckBar).new():Start()
require(Modules.GroupInvite).new():Start()
require(Modules.VipChatTag).Shared:Start()

local v4 = require(Modules.PhoneLayout).new(UIKit.Windows)

v4:Apply()
require(Modules.TextFloor).ForWindows(UIKit.Windows)

local MoveLock = require(Modules.MoveLock)
local t1 = {
    aim = function() -- aim | line: 138
        -- upvalues: CastController (copy)
        return CastController.State == "aiming"
    end,
    cast = function() -- cast | line: 141
        -- upvalues: CastController (copy)
        return CastController.State ~= "idle"
    end,
    hatch = function() -- hatch | line: 144
        -- upvalues: EggHatch (copy)
        return EggHatch.Playing == true
    end,
    train = function() -- train | line: 147
        -- upvalues: TrainingController (copy)
        return TrainingController.Active == true
    end,
    cosmic = function() -- cosmic | line: 150
        -- upvalues: CosmicEvent (copy)
        return CosmicEvent.IntroCamera == true
    end,
    battle = function() -- battle | line: 153
        -- upvalues: CosmicBattle (copy)
        return CosmicBattle.Watching == true
    end
}
local t2 = {}

task.spawn(function() -- line: 158
    -- upvalues: MoveLock (copy), t1 (copy), t2 (copy)
    while true do
        task.wait(1)

        for v5, v6 in pairs(t1) do
            local ok, result = pcall(v6)

            if not MoveLock.IsHeld(v5) or not ok or result then
                t2[v5] = nil
            else
                t2[v5] = (t2[v5] or 0) + 1

                if t2[v5] >= 3 then
                    t2[v5] = nil
                    warn("[MoveLock] let go of a hold nothing was using: " .. v5)
                    MoveLock.Free(v5)
                end
            end
        end
    end
end)

local CutsceneFx = require(Modules.CutsceneFx)

CutsceneFx.Init()
CastController.AfterCatch = HeldFish.Show

RevealCutscene.AutoHold = function() -- line: 183
    -- upvalues: CastController (copy)
    return CastController.AutoRun
end

AntiAfk.AutoCasting = function() -- line: 186
    -- upvalues: CastController (copy)
    return CastController.AutoOn() and CastController.State ~= "idle"
end

Tutorial.IsCasting = function() -- line: 189
    -- upvalues: CastController (copy)
    return CastController.State
end

Tutorial.IsTraining = function() -- line: 192
    -- upvalues: TrainingController (copy)
    return TrainingController.Active
end

Tutorial.StopTraining = TrainingController.Stop
UnlockPopup.Suppressed = Tutorial.Active

local OfferGate = require(Modules.OfferGate)

OfferGate.Shared.TutorialActive = Tutorial.Active

CastController.NoLuckyOffer = function() -- line: 199
    -- upvalues: OfferGate (copy)
    return not OfferGate.Shared:Allowed()
end

CastController.TutorialActive = Tutorial.Active
HUD.TutorialHides = Tutorial.Active
require(Modules.TopBar).Hidden = Tutorial.Active
BuffHud.Hidden = Tutorial.Active

require(Modules.Notifications).Shared.Blocked = function(p3) -- line: 206
    -- upvalues: Tutorial (copy)
    if not Tutorial.Active() then
        return false
    end

    local v7 = p3.key or ""

    if v7 == "tip" then
        return false
    end

    return string.sub(v7, 1, 12) ~= "toast:error:"
end

TrainingController.Quiet = function() -- line: 213
    -- upvalues: Tutorial (copy)
    return Tutorial.Before("circle")
end

TrainingController.CanStart = function() -- line: 216
    -- upvalues: CastController (copy), Tutorial (copy)
    if CastController.State == "idle" then
        return not Tutorial.Before("circle")
    end

    return false
end

CastController.OnCaught = function(p4, p5) -- line: 220
    -- upvalues: Modules (copy), NumberFormat (copy), Toasts (copy), ScreenFx (copy), CastController (copy), RevealCutscene (copy)
    local Play = RevealCutscene.Play
    local ok, result = pcall(Play, p4, p5)

    if not ok then
        warn("[RevealCutscene] " .. tostring(result))
        RevealCutscene.Cleanup()

        local ClearWarm = require(game:GetService("ReplicatedStorage").Shared.FishModels).ClearWarm

        pcall(ClearWarm)
        ScreenFx.Fade(1, 0, Color3.new(1, 1, 1))
    end

    if (p4.trainPower or 0) > 0 then
        Toasts.Show("gold", "FISHING XP!  +" .. NumberFormat.abbr(p4.trainPower) .. " Cast Power")
    end

    if not CastController.AutoRun then
        require(Modules.FavoritePrompt).Shared:AfterCatch(p4)
    end
end

if RunService:IsStudio() then
    local BindableFunction = Instance.new("BindableFunction")

    BindableFunction.Name = "TestHook"

    BindableFunction.OnInvoke = function(p6, p7, p8) -- line: 240
        -- upvalues: Modules (copy), UIKit (copy), DataClient (copy), Toasts (copy), HUD (copy), CastController (copy), RevealCutscene (copy), PlotFish (copy), TrainingController (copy), BaitShop (copy), RodShop (copy), UnlockPopup (copy), Tutorial (copy), SoundPlayer (copy), HeldFish (copy), ShopWindow (copy), EventFx (copy), SettingsWindow (copy), PowerControl (copy), ZoneAmbience (copy), BaitOffer (copy), CashOffer (copy), StarterOffer (copy), TrainBonus (copy), AquariumView (copy), OfflineEarnings (copy), EggHatch (copy), HeldEgg (copy), AntiAfk (copy), PriceColors (copy), AnnounceBanner (copy), TopBar (copy), SkipButton (copy), CosmicEvent (copy), BuffHud (copy), CosmicBattle (copy), CosmicSky (copy), AdminPanel (copy), TradeWindow (copy), Shared (copy), Shared2 (copy), Shared3 (copy), v4 (copy), CutsceneFx (copy)
        if p6 == "toast" then
            Toasts.Show(p7, p8)
        else
            if p6 == "window" then
                local v8 = UIKit.Windows[p7]

                if v8 then
                    v8.Toggle()
                end

                return v8 ~= nil and v8.IsOpen
            end

            if p6 == "mode" then
                HUD.SetMode(p7)
            elseif p6 == "instruction" then
                HUD.SetInstruction(p7)
            elseif p6 == "closeAll" then
                UIKit.closeAllWindows()
            else
                if p6 == "tap" then
                    return CastController.Tap()
                end

                if p6 == "powerPanel" then
                    PowerControl.Open(p7)
                else
                    local v9, EggsOut, egg, v10, v11, v12

                    if p6 == "topbar" then
                        local t3 = {}
                        local Row = TopBar.Row
                        local Children = Row and Row:GetChildren() or {}

                        table.sort(Children, function(p9, p10) -- line: 263
                            return (p9:IsA("GuiObject") and p9.LayoutOrder or 0) < (p10:IsA("GuiObject") and p10.LayoutOrder or 0)
                        end)

                        for _, v13 in ipairs(Children) do
                            if v13:IsA("GuiObject") then
                                EggsOut = v13.Name
                                v12 = if v13.Visible then "" else "(hidden)"
                                v10 = v13.AbsolutePosition.X
                                egg = math.floor(v10)
                                v11 = v13.AbsolutePosition.Y
                                EggsOut ..= v12 .. "@" .. egg .. "," .. math.floor(v11)
                                table.insert(t3, EggsOut)
                            end
                        end

                        if p7 == "pack" then
                            TopBar.ToggleInventory()
                        end

                        return table.concat(t3, " ") .. " | opened " .. TopBar.Opened
                    end

                    local v14, v15, v16, v17, Index, v18

                    if p6 == "auto" then
                        if p7 == "toggle" then
                            CastController.ToggleAuto()
                        elseif p7 == "mute" then
                            CastController.MuteAutoPrompt = true
                        end

                        v17 = CastController.AutoOn
                        v14 = tostring(v17())
                        Index = CastController.OwnsAuto
                        v16 = tostring(Index())
                        v15 = CastController.State
                        v18 = CastController.AutoRun

                        return v14 .. "|owns:" .. v16 .. "|state:" .. v15 .. "|run:" .. tostring(v18) .. "|prompts:" .. CastController.AutoPrompts
                    end

                    if p6 == "pauseAt" then
                        CastController.PauseAt = p7
                    else
                        local v19

                        if p6 == "castState" then
                            v14 = CastController.State
                            Index = CastController.PausedAt
                            v16 = tostring(Index)
                            v19 = RevealCutscene.PausedAt
                            v15 = tostring(v19)
                            v18 = RevealCutscene.Waiting

                            return v14 .. "|" .. v16 .. "|reveal:" .. v15 .. "|waiting:" .. tostring(v18)
                        end

                        if p6 == "revealLegend" then
                            RevealCutscene.ForceLegend = p7
                            v14 = RevealCutscene.Intro

                            return (tostring(v14))
                        end

                        if p6 == "revealIntro" then
                            RevealCutscene.ForceIntro = p7
                            v14 = RevealCutscene.Intro

                            return (tostring(v14))
                        end

                        if p6 == "ambience" then
                            v14 = ZoneAmbience.Zone

                            return (tostring(v14))
                        end

                        if p6 == "aquarium" then
                            v14 = AquariumView.Count

                            return (tostring(v14))
                        end

                        if p6 == "code" then
                            if p7 then
                                SettingsWindow.Redeem(p7)
                            end

                            v14 = SettingsWindow.CodeResult

                            return (tostring(v14))
                        end

                        if p6 == "afk" then
                            AntiAfk.Check(p7)
                            v14 = AntiAfk.Asked

                            return (tostring(v14))
                        end

                        if p6 == "heldEgg" then
                            if p7 == "placeAt" then
                                HeldEgg.Place(p8)
                            elseif p7 then
                                HeldEgg.Show(p7)
                            end

                            v17 = HeldEgg.Key

                            return tostring(v17) .. "|" .. HeldEgg.Placed
                        end

                        if p6 == "egg" then
                            if p7 == "tap" then
                                EggHatch.Tap()
                            end

                            v14 = EggHatch.Played
                            Index = EggHatch.Stage
                            v16 = tostring(Index)
                            v19 = EggHatch.Playing

                            return v14 .. "|" .. v16 .. "|" .. tostring(v19)
                        end

                        if p6 == "priceColor" then
                            v14 = PriceColors.Last

                            return (tostring(v14))
                        end

                        if p6 == "skipped" then
                            v17 = RevealCutscene.Skipped
                            v14 = tostring(v17)
                            Index = RevealCutscene.Intro

                            return v14 .. "|" .. tostring(Index)
                        end

                        if p6 == "offline" then
                            if p7 == "close" then
                                OfflineEarnings.Close()
                            end

                            v14 = OfflineEarnings.Shown
                            v16 = OfflineEarnings.Doubled
                            v19 = OfflineEarnings.Last and OfflineEarnings.Last.amount
                            v15 = tostring(v19)
                            v18 = OfflineEarnings.Last

                            if not v18 then
                                return v14 .. "|doubled:" .. v16 .. "|" .. v15 .. "|" .. tostring(v18)
                            end

                            v18 = OfflineEarnings.Last.seconds

                            return v14 .. "|doubled:" .. v16 .. "|" .. v15 .. "|" .. tostring(v18)
                        end

                        if p6 == "baitOffer" then
                            if p7 == "buy" then
                                BaitOffer.Buy()
                            end

                            if p7 ~= "close" then
                                v17 = BaitOffer.Offered
                                v14 = tostring(v17)
                                Index = BaitOffer.IsVisible

                                return v14 .. "|" .. tostring(Index())
                            end

                            BaitOffer.Close()
                            v17 = BaitOffer.Offered
                            v14 = tostring(v17)
                            Index = BaitOffer.IsVisible

                            return v14 .. "|" .. tostring(Index())
                        end

                        if p6 == "luckyOffer" then
                            if p7 == "mute" then
                                CastController.MuteLucky = true
                            elseif p7 == "press" then
                                CastController.BuyLucky()
                            elseif p7 == "toggle" then
                                CastController.ToggleLucky()
                            end

                            v17 = CastController.LuckyOffered
                            v14 = tostring(v17)
                            v16 = CastController.LuckyPrompts
                            v19 = CastController.UseLucky

                            return v14 .. "|" .. v16 .. "|use:" .. tostring(v19)
                        end

                        local v20, KhaosScale, FullName

                        if p6 == "fx" then
                            if p7 == "fake" then
                                CutsceneFx.ForceFakeOut = p8
                            elseif p7 == "held" then
                                CutsceneFx.SetHeld(p8 == true)
                            elseif p7 == "beam" then
                                CutsceneFx.Beam(p8, Color3.fromRGB(255, 220, 110), 4)
                            end

                            local t4 = {}

                            for v21, v22 in pairs(CutsceneFx.Counts) do
                                v20 = v21 .. "=" .. v22
                                table.insert(t4, v20)
                            end

                            table.sort(t4)
                            v16 = CutsceneFx.Level
                            v19 = CutsceneFx.Zone
                            v15 = tostring(v19)
                            v18 = CutsceneFx.Muffled
                            FullName = tostring(v18)
                            KhaosScale = CutsceneFx.Graded

                            return "level:" .. v16 .. " zone:" .. v15 .. " muffled:" .. FullName .. " graded:" .. tostring(KhaosScale) .. " | " .. table.concat(t4, " ")
                        end

                        if p6 == "sounds" then
                            return SoundPlayer.LoadReport()
                        end

                        if p6 == "cashOffer" then
                            if p7 == "mute" then
                                CashOffer.Mute = true
                            end

                            v17 = CashOffer.Last

                            return tostring(v17) .. "|" .. CashOffer.Count
                        end

                        if p6 == "starter" then
                            if p7 == "mute" then
                                StarterOffer.Mute = true
                            elseif p7 == "close" then
                                StarterOffer.Close()
                            elseif p7 == "toggle" then
                                StarterOffer.Toggle()
                            elseif p7 == "buy" then
                                StarterOffer.Buy()
                            end

                            v17 = StarterOffer.IsVisible
                            v14 = tostring(v17())
                            v16 = StarterOffer.Prompts
                            v19 = StarterOffer.IsOpen

                            return v14 .. "|" .. v16 .. "|open:" .. tostring(v19())
                        end

                        if p6 == "trainBonus" then
                            if p7 == "press" then
                                TrainBonus.Press()
                            end

                            return TrainBonus.Offers .. "|" .. TrainBonus.Actives
                        end

                        if p6 == "hotbarSlots" then
                            v9 = 0

                            for _, child in ipairs(HUD.Hotbar:GetChildren()) do
                                if child:IsA("Frame") and child.Visible then
                                    v9 += 1
                                end
                            end

                            return (tostring(v9))
                        end

                        if p6 == "revealPauseAt" then
                            RevealCutscene.PauseAt = p7
                        else
                            if p6 == "held" then
                                v14 = HeldFish.Uid

                                return (tostring(v14))
                            end

                            if p6 == "heldPlace" then
                                HeldFish.Place()
                            else
                                if p6 == "sounds" then
                                    local t5 = {}

                                    for v23, v24 in pairs(SoundPlayer.Counts) do
                                        v20 = v23 .. "=" .. v24
                                        table.insert(t5, v20)
                                    end

                                    table.sort(t5)

                                    return SoundPlayer.LoadReport() .. "\nplayed: " .. table.concat(t5, " ")
                                end

                                if p6 == "tutorial" then
                                    local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui

                                    v14 = PlayerGui.HUD:FindFirstChild("Instruction", true)

                                    local Arrow = PlayerGui:FindFirstChild("Arrow")

                                    v15 = Tutorial.Step()
                                    v14 = v14 and HUD.InstructionVisible() and v14.Text
                                    FullName = tostring(v14)

                                    if not Arrow then
                                        v20 = tostring(Arrow)
                                        v12 = PlayerGui.TutorialArrow:FindFirstChildOfClass("ImageLabel").Visible

                                        return "step:" .. v15 .. "|text:" .. FullName .. "|arrow:" .. v20 .. "|uiArrow:" .. tostring(v12)
                                    end

                                    Arrow = Arrow.Enabled
                                    v20 = tostring(Arrow)
                                    v12 = PlayerGui.TutorialArrow:FindFirstChildOfClass("ImageLabel").Visible

                                    return "step:" .. v15 .. "|text:" .. FullName .. "|arrow:" .. v20 .. "|uiArrow:" .. tostring(v12)
                                end

                                if p6 == "baitShop" then
                                    BaitShop.Open(p7)
                                elseif p6 == "rodShop" then
                                    RodShop.Open(p7)
                                else
                                    if p6 == "popup" then
                                        v14 = UnlockPopup.Showing

                                        return (tostring(v14))
                                    end

                                    if p6 == "popupHide" then
                                        UnlockPopup.Hide()
                                    else
                                        if p6 == "trainState" then
                                            return TrainingController.State()
                                        end

                                        if p6 == "trainStop" then
                                            TrainingController.Stop()
                                        else
                                            if p6 == "gift" then
                                                if p7 == "self" then
                                                    ShopWindow.MuteGiftPrompt = true
                                                    ShopWindow.SetGiftTarget(game:GetService("Players").LocalPlayer)
                                                elseif p7 == "off" then
                                                    ShopWindow.SetGiftTarget(nil)
                                                end

                                                v9 = ShopWindow.LastGift

                                                if not v9 then
                                                    return "none"
                                                end

                                                v16 = v9.productId
                                                v17 = tostring(v16)
                                                v15 = v9.started

                                                return v17 .. "|started:" .. tostring(v15)
                                            end

                                            if p6 == "announce" then
                                                v14 = AnnounceBanner.Shown
                                                Index = AnnounceBanner.Last

                                                return v14 .. "|" .. tostring(Index)
                                            end

                                            if p6 == "plotFishCount" then
                                                return PlotFish.Count()
                                            end

                                            if p6 == "eventFx" then
                                                v17 = EventFx.Active

                                                return tostring(v17) .. "|cards:" .. EventFx.CardsShown
                                            end

                                            if p6 == "daily" then
                                                if p7 == "open" then
                                                    Shared.Window.Open()
                                                elseif p7 == "claim" then
                                                    Shared:Claim()
                                                elseif p7 == "celebrate" and type(p8) == "table" then
                                                    Shared.HoldTime = p8.hold or Shared.HoldTime
                                                    task.spawn(Shared.Celebrate, Shared, p8)
                                                end

                                                v9, v14 = Shared:State()
                                                v17 = "day:%d ready:%s open:%s dot:%s claimed:%d celebrations:%d auto:%s last:%s"
                                                v15 = tostring(v14)
                                                FullName = Shared.Window.IsOpen
                                                v19 = tostring(FullName)
                                                v18 = Shared.Dot.Visible
                                                FullName = tostring(v18)
                                                v18 = Shared.Claimed
                                                v20 = Shared.Celebrations
                                                EggsOut = Shared.AutoOpened
                                                KhaosScale = tostring(EggsOut)
                                                v12 = Shared.LastResult

                                                if not v12 then
                                                    return v17:format(v9, v15, v19, FullName, v18, v20, KhaosScale, (tostring(v12)))
                                                end

                                                v12 = Shared.LastResult.text

                                                return v17:format(v9, v15, v19, FullName, v18, v20, KhaosScale, (tostring(v12)))
                                            end

                                            local v25

                                            if p6 == "ladder" then
                                                if p7 == "open" then
                                                    Shared2.Window.Open()
                                                elseif p7 == "close" then
                                                    Shared2.Window.Close()
                                                elseif p7 == "act" then
                                                    Shared2:Act(p8)
                                                elseif p7 == "odds" then
                                                    Shared2:OddsPanel(p8)
                                                elseif p7 == "hold" then
                                                    Shared2.HoldTime = tonumber(p8) or Shared2.HoldTime
                                                elseif p7 == "purchaseFx" then
                                                    Shared2:PurchaseFx()
                                                end

                                                local t6 = {}

                                                for v26, v27 in pairs(Shared2.Tiles) do
                                                    v18 = {}
                                                    v12 = if v27.Covered then "c" else ""
                                                    v25 = if v27.State == "current" then "*" elseif v27.State == "claimed" then "v" else ""
                                                    EggsOut = v26 .. v12 .. v25
                                                    v18[1] = v26
                                                    v18[2] = EggsOut
                                                    table.insert(t6, v18)
                                                end

                                                table.sort(t6, function(p11, p12) -- line: 461
                                                    return p11[1] < p12[1]
                                                end)

                                                local t7 = {}

                                                for _, v28 in t6 do
                                                    v20 = v28[2]
                                                    table.insert(t7, v20)
                                                end

                                                Index = Shared2:Progress()
                                                v19 = Shared2.Window.IsOpen
                                                v15 = tostring(v19)
                                                FullName = Shared2.Celebrating
                                                v19 = tostring(FullName)
                                                v18 = Shared2.Pending

                                                return ("progress:%d open:%s celebrating:%s pending:%s queue:%d celebrations:%d claimed:%d shown:%d tiles:%s live:%s button:%s"):format(Index, v15, v19, tostring(v18), #Shared2.Queue, Shared2.Celebrations, Shared2.Claimed, Shared2.Shown, table.concat(t7, ","), tostring(Shared2:Live()), Shared2:ButtonText())
                                            end

                                            if p6 == "randomFish" then
                                                if p7 == "odds" then
                                                    Shared3.Odds:Open()
                                                elseif p7 == "closeOdds" then
                                                    Shared3.Odds:Close()
                                                elseif p7 == "buy" then
                                                    Shared3:Buy()
                                                elseif p7 == "reveal" and type(p8) == "table" then
                                                    task.spawn(Shared3.Reveal.Play, Shared3.Reveal, p8, Shared3.Card)
                                                elseif p7 == "tap" and Shared3.Reveal.Close then
                                                    task.spawn(Shared3.Reveal.Close)
                                                end

                                                v9 = Shared3.Reveal
                                                v14 = "open:%s visible:%s stage:%s played:%d odds:%s prompts:%d held:%s"
                                                Index = Shared3.Open
                                                v16 = tostring(Index)
                                                v15 = Shared3.Card

                                                if not v15 then
                                                    Index = tostring(v15)
                                                    v15 = v9.Stage
                                                    v19 = v9.Played
                                                    v18 = Shared3.Odds.Gui.Enabled
                                                    FullName = tostring(v18)
                                                    v18 = Shared3.Prompts
                                                    KhaosScale = HeldFish.Uid

                                                    return v14:format(v16, Index, v15, v19, FullName, v18, (tostring(KhaosScale)))
                                                end

                                                v15 = Shared3.Card.Visible
                                                Index = tostring(v15)
                                                v15 = v9.Stage
                                                v19 = v9.Played
                                                v18 = Shared3.Odds.Gui.Enabled
                                                FullName = tostring(v18)
                                                v18 = Shared3.Prompts
                                                KhaosScale = HeldFish.Uid

                                                return v14:format(v16, Index, v15, v19, FullName, v18, (tostring(KhaosScale)))
                                            end

                                            if p6 == "revealTap" then
                                                RevealCutscene.Tap()
                                            else
                                                if p6 == "phoneLayout" then
                                                    return v4:Apply(true)
                                                end

                                                if p6 == "forceTouch" then
                                                    HUD.ForceTouch = p7

                                                    for _, v29 in ipairs({ HUD.PlaceCorner }) do
                                                        v29()
                                                    end

                                                    v14 = HUD.IsTouch

                                                    return (tostring(v14()))
                                                end

                                                if p6 == "moveLock" then
                                                    if p7 then
                                                        require(Modules.MoveLock).Hold(p7)
                                                    end

                                                    return require(Modules.MoveLock).Holders()
                                                end

                                                if p6 == "cosmic" then
                                                    if p7 == "admin" then
                                                        AdminPanel.Call(p8[1], p8[2])
                                                    elseif p7 == "open" then
                                                        AdminPanel.Open()
                                                    else
                                                        if p7 == "announce" then
                                                            AdminPanel.Announce(p8[1], p8[2])
                                                            v14 = AdminPanel.LastReply

                                                            return (tostring(v14))
                                                        end

                                                        if p7 == "skip" then
                                                            SkipButton.Press()
                                                        elseif p7 == "bet" then
                                                            game:GetService("ReplicatedStorage").Remotes.CosmicEvent:FireServer("bet", p8)
                                                        elseif p7 == "cards" then
                                                            CosmicEvent.Cards = {}
                                                        end
                                                    end

                                                    local t8 = {}

                                                    for v30 in pairs(CosmicBattle.Fired) do
                                                        table.insert(t8, v30)
                                                    end

                                                    table.sort(t8)
                                                    v14 = CosmicEvent.Got
                                                    v17 = "phase:%s act:%s level:%.1f space:%s under:%s khaos:%s scale:%.2f drops:%d got:L%d/P%d/E%d intro:%s/%d watching:%s bet:%s result:%s beams:%d mutations:%d swept:%d buffs:%d bannerUp:%s skip:%s fired:%s cards:%s"
                                                    Index = CosmicEvent.Phase
                                                    v15 = CosmicEvent.Act
                                                    v19 = CosmicEvent.Level
                                                    v18 = CosmicEvent.Space
                                                    FullName = tostring(v18)
                                                    v20 = CosmicEvent.Under
                                                    v18 = tostring(v20)
                                                    KhaosScale = CosmicEvent.KhaosShown
                                                    v20 = tostring(KhaosScale)
                                                    KhaosScale = CosmicEvent.KhaosScale
                                                    EggsOut = CosmicEvent.EggsOut
                                                    v12 = v14.lucky or 0
                                                    v25 = v14.potion or 0
                                                    egg = v14.egg

                                                    local IntroPlayed, v31, v32, Beams, Mutations, Swept, Count, v33, BannerUp, Showing

                                                    if egg then
                                                        IntroPlayed = CosmicEvent.IntroCamera
                                                        v10 = tostring(IntroPlayed)
                                                        IntroPlayed = CosmicEvent.IntroPlayed
                                                        v31 = CosmicBattle.Watching
                                                        v11 = tostring(v31)
                                                        v32 = CosmicBattle.MyBet
                                                        v31 = tostring(v32)
                                                        Beams = CosmicBattle.BetResult
                                                        v32 = tostring(Beams)
                                                        Beams = CosmicSky.Beams
                                                        Mutations = CosmicSky.Mutations
                                                        Swept = CosmicSky.Swept
                                                        Count = BuffHud.Count
                                                        BannerUp = BuffHud.BannerUp
                                                        v33 = tostring(BannerUp)
                                                        Showing = SkipButton.Showing

                                                        return v17:format(Index, v15, v19, FullName, v18, v20, KhaosScale, EggsOut, v12, v25, egg, v10, IntroPlayed, v11, v31, v32, Beams, Mutations, Swept, Count, v33, tostring(Showing()), table.concat(t8, ","), table.concat(CosmicEvent.Cards, ","))
                                                    end

                                                    egg = 0
                                                    v10 = tostring(CosmicEvent.IntroCamera)
                                                    IntroPlayed = CosmicEvent.IntroPlayed
                                                    v11 = tostring(CosmicBattle.Watching)

                                                    return v17:format(Index, v15, v19, FullName, v18, v20, KhaosScale, EggsOut, v12, v25, egg, v10, IntroPlayed, v11, tostring(CosmicBattle.MyBet), tostring(CosmicBattle.BetResult), CosmicSky.Beams, CosmicSky.Mutations, CosmicSky.Swept, BuffHud.Count, tostring(BuffHud.BannerUp), tostring(SkipButton.Showing()), table.concat(t8, ","), table.concat(CosmicEvent.Cards, ","))
                                                end

                                                if p6 == "trade" then
                                                    if not p7 then
                                                        return TradeWindow.Describe()
                                                    end

                                                    v9 = TradeWindow.Test(p7, p8)

                                                    if p7 == "addFish" then
                                                        return v9
                                                    end

                                                    return TradeWindow.Describe()
                                                end

                                                if p6 == "pad" then
                                                    v9 = require(Modules.Pad)
                                                    v14 = require(Modules.PowerControl)
                                                    v17 = game:GetService("GuiService")

                                                    if p7 == "force" then
                                                        v9.SetForce(p8)
                                                    elseif p7 == "select" then
                                                        v16 = game:GetService("Players").LocalPlayer.PlayerGui

                                                        for match in string.gmatch(p8 or "", "[^%.]+") do
                                                            v16 = v16 and v16:FindFirstChild(match)
                                                        end

                                                        v17.SelectedObject = v16
                                                    elseif p7 == "nudge" then
                                                        v14.Slider.Nudge(p8)
                                                    elseif p7 == "cycle" then
                                                        HUD.CycleHotbar(p8)
                                                    end

                                                    v16 = v17.SelectedObject
                                                    Index = "using:%s sel:%s back:%d saves:%d held:%d limit:%s power:%s"
                                                    v19 = tostring(v9.Using())

                                                    if v16 then
                                                        FullName = v16:GetFullName()
                                                    end

                                                    if v16 and FullName then
                                                        v18 = v9.BackPresses
                                                        v20 = v14.Saves
                                                        KhaosScale = HUD.HeldSlot()
                                                        v12 = DataClient.Get
                                                        EggsOut = tostring(v12("CastLimit"))
                                                        v25 = DataClient.Get

                                                        return Index:format(v19, FullName, v18, v20, KhaosScale, EggsOut, (tostring(v25("CastPower"))))
                                                    end

                                                    FullName = "nil"
                                                    v18 = v9.BackPresses
                                                    v20 = v14.Saves
                                                    KhaosScale = HUD.HeldSlot()
                                                    v12 = DataClient.Get
                                                    EggsOut = tostring(v12("CastLimit"))
                                                    v25 = DataClient.Get

                                                    return Index:format(v19, FullName, v18, v20, KhaosScale, EggsOut, (tostring(v25("CastPower"))))
                                                end

                                                if p6 ~= "showcase" then
                                                    return true
                                                end

                                                local Showcase = require(Modules.Showcase)

                                                if p7 == "state" then
                                                    v16 = Showcase.Playing
                                                    v17 = tostring(v16)
                                                    Index = Showcase.Index
                                                    FullName = RevealCutscene.Intro
                                                    v19 = tostring(FullName)
                                                    v18 = if Showcase.Fails then #Showcase.Fails else -1

                                                    return v17 .. "|" .. Index .. "|" .. v19 .. "|fails:" .. v18
                                                end

                                                if p7 == "stop" then
                                                    Showcase.Stop = true
                                                elseif p7 ~= "one" or type(p8) ~= "table" then
                                                    task.spawn(Showcase.Play, tonumber(p7), (tonumber(p8)))
                                                else
                                                    task.spawn(function() -- line: 560
                                                        -- upvalues: p8 (copy), Showcase (copy)
                                                        Showcase.Playing = true
                                                        Showcase.PlayOne(p8[1], p8[2], p8[3], p8[4], p8[5])
                                                        Showcase.Playing = false
                                                    end)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        return true
    end

    BindableFunction.Parent = script.Parent
    game:GetService("TextChatService").MessageReceived:Connect(function(p13) -- line: 575
        -- upvalues: Modules (copy)
        local TextSource = p13.TextSource

        if TextSource and TextSource.UserId == game:GetService("Players").LocalPlayer.UserId then
            local v34, v35 = string.match(p13.Text or "", "^;showcase%s*(%S*)%s*(%S*)")

            if v34 ~= nil then
                local Showcase = require(Modules.Showcase)

                if v34 == "stop" then
                    Showcase.Stop = true
                else
                    task.spawn(Showcase.Play, tonumber(v34), (tonumber(v35)))
                end
            end
        end
    end)
end

DataClient.Init()
