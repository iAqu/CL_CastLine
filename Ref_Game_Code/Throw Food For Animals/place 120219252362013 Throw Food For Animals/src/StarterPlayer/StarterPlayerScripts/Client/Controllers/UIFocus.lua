-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Parent = script.Parent
local ClientState = require(Parent.ClientState)
local HUDController = require(Parent.HUDController)
local PowerSlider = require(Parent.PowerSlider)
local ShopFX = require(Parent.ShopFX)
local t1 = {}

local function bigWindowOpen() -- line: 28
    -- upvalues: ClientState (copy)
    return ClientState.ShopOpen or ClientState.ExclusiveShopOpen or ClientState.IndexOpen or ClientState.AnimalsOpen or ClientState.SellOpen
end

function t1.AnyWindowOpen() -- line: 33
    -- upvalues: ClientState (copy), PowerSlider (copy)
    return ClientState.ShopOpen
        or ClientState.ExclusiveShopOpen
        or ClientState.IndexOpen
        or ClientState.AnimalsOpen
        or ClientState.SellOpen
        or ClientState.InventoryOpen
        or PowerSlider.IsOpen()
end

local v1 = false

local function step() -- line: 39
    -- upvalues: ClientState (copy), HUDController (copy), PowerSlider (copy), ShopFX (copy), t1 (copy), v1 (ref)
    local ShopOpen = ClientState.ShopOpen or ClientState.ExclusiveShopOpen or ClientState.IndexOpen or ClientState.AnimalsOpen or ClientState.SellOpen

    if ShopOpen and not v1 and PowerSlider.IsOpen() then
        PowerSlider.Close()
    end

    v1 = ShopOpen

    local v2 = t1.AnyWindowOpen()

    HUDController.SetSideButtonsHidden(v2)
    ShopFX.SetWidgetHidden(v2)

    local PowerCog = HUDController.PowerCog

    if not PowerCog then
        return
    end

    if ClientState.TutorialActive and PowerSlider.IsOpen() then
        PowerSlider.Close()
    end

    if ClientState.Busy ~= nil then
        PowerCog.Visible = false
    else
        PowerCog.Visible = not ClientState.TutorialActive and (not v2 or PowerSlider.IsOpen())
    end
end

function t1.Init() -- line: 58
    -- upvalues: RunService (copy), step (copy)
    RunService.Heartbeat:Connect(step)
end

return t1
