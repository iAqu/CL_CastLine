-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Controller = require(script.Parent.Parent.Fishing.Controller)
local PowerMeter = require(script.Parent.Parent.Fishing.PowerMeter)
local Lift = require(script.Parent.Parent.World.Lift)
local RodShop = require(script.Parent.Parent.UI.RodShop)
local Controls = require(script.Parent.Parent.Character.Controls)
local Intro = require(script.Parent.Parent.Intro.Intro)
local TutorialText = require(script.Parent.TutorialText)
local ArrowBeam = require(script.Parent.ArrowBeam)
local FocusCube = require(script.Parent.FocusCube)
local TapPointer = require(script.Parent.TapPointer)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local v1
local v2 = false
local v3 = false
local v4 = false
local v5, update, v6
local v7 = false
local n1 = 0

local function report(p1) -- line: 67
    -- upvalues: Remotes (copy), t2 (copy)
    if not t2[p1] then
        t2[p1] = true
        Remotes.Tutorial:FireServer(p1)
    end
end

local function step() -- line: 74
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("Tutorial")
end

function t1.isActive() -- line: 78
    -- upvalues: Config (copy), LocalPlayer (copy)
    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    return Tutorial ~= nil and Tutorial < Config.TutorialDone
end

local function myPlot() -- line: 83
    -- upvalues: LocalPlayer (copy)
    for _, child in workspace.Map.World1.Plots:GetChildren() do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child
        end
    end

    return nil
end

local function dockSpot() -- line: 92
    local Deck = workspace.Map.World1.FishingDock:FindFirstChild("Deck")

    Deck = Deck and Vector3.new(Deck.Position.X, Deck.Position.Y + Deck.Size.Y / 2, Deck.Position.Z)

    return Deck
end

local function liftSpot() -- line: 97
    -- upvalues: myPlot (copy)
    local v9 = myPlot()
    local LiftZone = v9 and v9:FindFirstChild("LiftZone")
    local Center = LiftZone and LiftZone:FindFirstChild("Center")

    return Center and Center.Position
end

local function barbellSpot() -- line: 104
    -- upvalues: myPlot (copy)
    local v10 = myPlot()
    local BarbellUpgrade = v10 and v10:FindFirstChild("BarbellUpgrade")
    local Button = BarbellUpgrade and BarbellUpgrade:FindFirstChild("Button")

    return Button and Button.Position
end

local function wantsBarbellHint() -- line: 112
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v11 = Config.Barbells[2]

    if (LocalPlayer:GetAttribute("BarbellTier") or 1) ~= 1 or v11 == nil then
        return false
    end

    return (LocalPlayer:GetAttribute("Money") or 0) >= v11.Price
end

local function rodSpot() -- line: 117
    -- upvalues: myPlot (copy)
    local v12 = myPlot()
    local RodStand = v12 and v12:FindFirstChild("RodStand")
    local v13 = RodStand and RodStand:FindFirstChild("Inner", true)

    v13 = v13 and Vector3.new(v13.Position.X, v13.Position.Y - v13.Size.X / 2, v13.Position.Z)

    return v13
end

local function plotCenter() -- line: 124
    -- upvalues: myPlot (copy)
    local v15 = myPlot()
    local v16 = v15 and v15:FindFirstChild("Floor")

    v16 = v16 and v16.Position + Vector3.new(0, v16.Size.Y / 2, 0)

    return v16
end

local function castTapPoint() -- line: 132
    -- upvalues: PowerMeter (copy)
    return if PowerMeter.track() then workspace.CurrentCamera.ViewportSize / 2 else nil
end

local function nextRodButton() -- line: 136
    -- upvalues: LocalPlayer (copy)
    local RodShop = LocalPlayer.PlayerGui:FindFirstChild("RodShop")
    local v18 = RodShop and RodShop:FindFirstChild("Rod" .. 2, true)

    return v18 and v18:FindFirstChild("BuyButton")
end

local function ownsNextRod() -- line: 142
    -- upvalues: LocalPlayer (copy)
    for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
        if tonumber(match) == 2 then
            return true
        end
    end

    return false
end

local function canAffordNextRod() -- line: 151
    -- upvalues: Config (copy), LocalPlayer (copy)
    return (LocalPlayer:GetAttribute("Money") or 0) >= Config.rodPrice(2, LocalPlayer:GetAttribute("LegacyPrices") == true)
end

local function setForcing(p2) -- line: 156
    -- upvalues: RodShop (copy), v3 (ref)
    if p2 ~= v3 then
        v3 = p2
        RodShop.setForced(p2)
    end
end

local function barbellIntro() -- line: 167
    -- upvalues: RunService (copy), Remotes (copy), Controls (copy), TutorialText (copy), LocalPlayer (copy), t2 (copy), v4 (ref), update (ref), myPlot (copy)
    local v19 = myPlot()
    local LiftZone = v19 and v19:FindFirstChild("LiftZone")
    local Center = LiftZone and LiftZone:FindFirstChild("Center")
    local v20 = Center and Center.Position
    local Character = LocalPlayer.Character
    local v21 = Character

    if Character then
        v21 = Character:FindFirstChild("HumanoidRootPart")
        Character = Character:FindFirstChildOfClass("Humanoid")
    end

    local CurrentCamera, _CFrame, v22, v23

    if v4 then
        v23 = true
    elseif v20 and v21 and Character then
        v4 = true
        update()
        Controls.lock("Tutorial")
        CurrentCamera = workspace.CurrentCamera
        _CFrame = CurrentCamera.CFrame
        CurrentCamera.CameraType = Enum.CameraType.Scriptable

        local v26 = Vector3.new(v21.Position.X - v20.X, 0, v21.Position.Z - v20.Z)

        v22 = if v26.Magnitude > 1 then v26.Unit else Vector3.new(0, 0, 1)
        v23 = false
    else
        v23 = true
    end

    if v23 then
        return
    end

    local v27 = CFrame.lookAt(v20 + v22 * 15 + Vector3.new(0, 9, 0), v20 + Vector3.new(0, 1.5, 0))
    local elapsed = os.clock()
    local v28 = false

    while true do
        local v29 = os.clock() - elapsed
        local v31 = math.min(v29 / 1.4, 1)
        local v32 = v31 * v31 * (3 - v31 * 2)
        local v34 = math.max(0, v29 - 1.4) * 0.8

        CurrentCamera.CFrame = _CFrame:Lerp(v27, v32) * CFrame.new(0, 0, -v34)

        if not v28 and v31 >= 0.75 then
            v28 = true
            TutorialText.announce("Train to cast farther!")
        end

        if not (v29 >= 3.8) and v21.Parent then
            RunService.RenderStepped:Wait()
            continue
        end

        break
    end

    TutorialText.announce(nil)
    CurrentCamera.CFrame = _CFrame
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = Character
    Controls.unlock("Tutorial")
    v4 = false

    if not t2.BarbellIntro then
        t2.BarbellIntro = true
        Remotes.Tutorial:FireServer("BarbellIntro")
    end
end

local function padSelect(p3) -- line: 215
    -- upvalues: GuiService (copy), UserInputService (copy), v6 (ref)
    local v35 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
    local v36 = if not p3 or not v35 then nil else p3

    if not v36 or GuiService.SelectedObject ~= nil then
        if not v36 and v6 and GuiService.SelectedObject == v6 then
            GuiService.SelectedObject = nil
        end
    else
        GuiService.SelectedObject = v36
    end

    v6 = v36
end

local function wanted() -- line: 227
    -- upvalues: Config (copy), Remotes (copy), Controller (copy), Lift (copy), RodShop (copy), Intro (copy), ArrowBeam (copy), LocalPlayer (copy), t2 (copy), v1 (ref), v2 (ref), v4 (ref), v5 (ref), v7 (ref), n1 (ref), dockSpot (copy), liftSpot (copy), barbellSpot (copy), rodSpot (copy), plotCenter (copy)
    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    if not Intro.isDone() or not Tutorial or v4 then
        return nil
    end

    if Controller.isAiming() and Tutorial >= 2 and Tutorial <= 5 then
        if Tutorial == 2 then
            return "Place your animal on your plot!", plotCenter, true, nil, true
        end

        if Tutorial == 5 and (v2 or Lift.repCount() - (v1 or Lift.repCount()) >= 10) then
            return "Upgrade your fishing rod to catch stronger fish!", rodSpot, false, nil, true
        end

        return "Train to cast farther!", liftSpot, false, nil, true
    end

    if not Controller.isBusy() then
        if not (Config.TutorialDone <= Tutorial) then
            if Tutorial == 1 then
                if not t2.FirstStep then
                    t2.FirstStep = true
                    Remotes.Tutorial:FireServer("FirstStep")
                end

                return "Fish for a sea animal!", dockSpot, true
            end

            if Tutorial ~= 2 then
                if Tutorial == 4 then
                    if Lift.isActive() then
                        return nil
                    end

                    return "Train to cast farther!", liftSpot
                end

                if Tutorial ~= 5 then
                    if Tutorial == 6 then
                        return "Fish again!", dockSpot
                    end

                    return nil
                end

                v1 = v1 or Lift.repCount()

                if not RodShop.isOpen() then
                    local v37 = Lift.repCount() - v1
                    local v38, liftSpot2

                    if v37 < 10 and not v2 then
                        v38 = ("Train to cast farther (%*/%*)"):format(v37, 10)

                        if not Lift.isActive() then
                            liftSpot2 = liftSpot
                        end

                        return v38, liftSpot2, false, nil, true
                    end

                    local v39 = false
                    local v40

                    for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
                        if tonumber(match) == 2 then
                            v40 = true
                            v39 = true
                            break
                        end
                    end

                    if not v39 then
                        v40 = false
                    end

                    if not (v40 or v2 and not ((LocalPlayer:GetAttribute("Money") or 0) >= Config.rodPrice(2, LocalPlayer:GetAttribute("LegacyPrices") == true))) then
                        return "Upgrade your fishing rod to catch stronger fish!", rodSpot
                    end

                    if not t2.RodPanelClosed then
                        t2.RodPanelClosed = true
                        Remotes.Tutorial:FireServer("RodPanelClosed")
                    end

                    return nil
                end

                v2 = true

                if not t2.RodPanel then
                    t2.RodPanel = true
                    Remotes.Tutorial:FireServer("RodPanel")
                end

                local v41 = false
                local v42

                for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
                    if tonumber(match) == 2 then
                        v42 = true
                        v41 = true
                        break
                    end
                end

                if not v41 then
                    v42 = false
                end

                if v42 then
                    return nil
                end

                local RodShop2 = LocalPlayer.PlayerGui:FindFirstChild("RodShop")
                local v43 = RodShop2 and RodShop2:FindFirstChild("Rod" .. 2, true)

                return nil, nil, nil, v43 and v43:FindFirstChild("BuyButton")
            end

            return if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Holding") then "Place your animal on your plot!" else "Pick your animal from your hotbar!", plotCenter, true
        end

        if v7 then
            v7 = false
            n1 = os.clock() + 4
        end

        if os.clock() < n1 then
            return "Tutorial complete! Catch rarer sea animals!"
        end

        local v44 = ArrowBeam.current()
        local v45 = Config.Barbells[2]

        if (LocalPlayer:GetAttribute("BarbellTier") or 1) == 1 and v45 ~= nil and (LocalPlayer:GetAttribute("Money") or 0) >= v45.Price and (v44 == nil or v44 == v5) then
            return "Upgrade your barbell to train faster!", barbellSpot
        end
    end

    return nil
end

function update() -- line: 300
    -- upvalues: GuiService (copy), UserInputService (copy), Config (copy), Controller (copy), RodShop (copy), Intro (copy), TutorialText (copy), ArrowBeam (copy), FocusCube (copy), TapPointer (copy), LocalPlayer (copy), v3 (ref), v5 (ref), v6 (ref), castTapPoint (copy), wanted (copy)
    local v46 = false

    if LocalPlayer:GetAttribute("Tutorial") == 5 then
        local v47 = RodShop.isOpen()

        if v47 then
            local v48 = false
            local v49

            for match in string.gmatch(LocalPlayer:GetAttribute("RodsOwned") or "1", "%d+") do
                if tonumber(match) == 2 then
                    v49 = true
                    v48 = true
                    break
                end
            end

            if not v48 then
                v49 = false
            end

            v46 = not v49 and (LocalPlayer:GetAttribute("Money") or 0) >= Config.rodPrice(2, LocalPlayer:GetAttribute("LegacyPrices") == true)
        else
            v46 = v47
        end
    end

    if v46 ~= v3 then
        v3 = v46
        RodShop.setForced(v46)
    end

    local v50, v51, v52, v53, v54 = wanted()

    TutorialText.set(v50, v54)

    if v51 then
        ArrowBeam.show(v51, v52)
        v5 = v51
    elseif v5 then
        if ArrowBeam.current() == v5 then
            ArrowBeam.hide()
        end

        v5 = nil
    end

    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    if Intro.isDone() and (Tutorial == 1 or Tutorial == 6) and Controller.isAiming() then
        TapPointer.showOnScreen(castTapPoint)
    else
        TapPointer.hide()
    end

    if v53 then
        FocusCube.show(v53)
    elseif FocusCube.isShowing() then
        FocusCube.hide()
    end

    local v55 = UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil

    if not v53 or not v55 then
        v53 = nil
    end

    if not v53 or GuiService.SelectedObject ~= nil then
        if not v53 and v6 and GuiService.SelectedObject == v6 then
            GuiService.SelectedObject = nil
        end
    else
        GuiService.SelectedObject = v53
    end

    v6 = v53
end

function t1.init() -- line: 328
    -- upvalues: RunService (copy), Config (copy), TutorialText (copy), ArrowBeam (copy), FocusCube (copy), TapPointer (copy), LocalPlayer (copy), update (ref), v7 (ref), barbellIntro (copy)
    TutorialText.init()
    ArrowBeam.init()
    FocusCube.init()
    TapPointer.init()

    local Tutorial = LocalPlayer:GetAttribute("Tutorial")

    LocalPlayer:GetAttributeChangedSignal("Tutorial"):Connect(function() -- line: 334
        -- upvalues: Tutorial (ref), Config (copy), LocalPlayer (copy), v7 (ref), barbellIntro (copy)
        local Tutorial2 = LocalPlayer:GetAttribute("Tutorial")
        local v56 = type(Tutorial) == "number"

        v56 = v56 and Tutorial < Config.TutorialDone and type(Tutorial2) == "number" and Config.TutorialDone <= Tutorial2

        if v56 then
            v7 = true
        end

        if Tutorial == 2 and Tutorial2 == 4 then
            task.spawn(barbellIntro)
        end

        Tutorial = Tutorial2
    end)

    local n2 = 0

    RunService.Heartbeat:Connect(function(p4) -- line: 346
        -- upvalues: n2 (ref), update (ref)
        n2 += p4

        if n2 >= 0.1 then
            n2 = 0
            update()
        end
    end)
end

return t1
