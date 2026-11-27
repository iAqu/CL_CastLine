-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Products = require(ReplicatedStorage.Shared.Products)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Robux = require(script.Parent.Parent.Shop.Robux)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1
local v2 = Color3.fromRGB(110, 225, 60)
local v3 = Color3.fromRGB(130, 130, 140)
local v4 = Color3.fromRGB(140, 255, 90)
local v5 = Color3.fromRGB(255, 95, 95)

local function refresh() -- line: 25
    -- upvalues: Config (copy), Format (copy), Products (copy), LocalPlayer (copy), v1 (ref), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    if not v1 then
        return
    end

    local v6 = LocalPlayer:GetAttribute("Rebirths") or 0
    local v7 = LocalPlayer:GetAttribute("Strength") or 0
    local v8 = LocalPlayer:GetAttribute("Money") or 0
    local v9 = Config.rebirthStrength(v6)
    local v10 = Config.rebirthCost(v6)
    local Body = v1.Panel.Body

    Body.Multiplier.Value.Text = string.format("x%g <font color=\"#8CFF5A\">→ x%g</font>", Config.rebirthMultiplier(v6), Config.rebirthMultiplier(v6 + 1))
    Body.Cost.Value.Text = Format.money(v10)

    local Value = Body.Cost.Value

    if v10 <= v8 then
        Value.TextColor3 = v4
    else
        Value.TextColor3 = v5
    end

    local v12 = math.min(v7 / v9, 1)

    Body.Progress.Fill.Size = UDim2.fromScale(v12, 1)
    Body.Progress.Fill.Visible = v12 > 0
    Body.Progress.Label.Text = ("%* / %* Strength"):format(Format.short((math.floor(v7))), (Format.short(v9)))

    local RebirthButton = Body.Buttons.RebirthButton

    if not (v9 <= v7 and v10 <= v8) then
        RebirthButton.BackgroundColor3 = v3
    else
        RebirthButton.BackgroundColor3 = v2
    end

    Body.Buttons.SkipButton.Visible = Products.canSkipRebirth(v7, v9)
    Body.Buttons.KeepMoney.Visible = Body.Buttons.SkipButton.Visible
    v1.Panel.Header.Count.Text = ("Rebirths: %*"):format(v6)
end

function t1.isOpen() -- line: 53
    -- upvalues: v1 (ref)
    return v1 ~= nil and v1.Enabled
end

function t1.open() -- line: 57
    -- upvalues: UIUtil (copy), v1 (ref), refresh (copy)
    refresh()
    UIUtil.openPanel(v1)
end

function t1.close() -- line: 62
    -- upvalues: UIUtil (copy), v1 (ref)
    UIUtil.closePanel(v1)
end

function t1.init() -- line: 66
    -- upvalues: Remotes (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), t1 (copy), v1 (ref), v4 (copy), refresh (copy)
    v1 = UIUtil.gui("RebirthPanel")
    UIUtil.bindButton(v1.Panel.Header.Close, t1.close)
    UIUtil.bindButton(v1.Panel.Body.Buttons.RebirthButton, function() -- line: 69
        -- upvalues: Remotes (copy)
        Remotes.Rebirth:FireServer()
    end)

    local SkipButton = v1.Panel.Body.Buttons.SkipButton
    local Buttons = v1.Panel.Body.Buttons

    Buttons.Position = UDim2.new(0, 16, 1, -42)

    local clone = SkipButton.Label:Clone()

    clone.Name = "KeepMoney"
    clone.Text = "Keep your money!"
    clone.TextColor3 = v4
    clone.AnchorPoint = Vector2.new(0.5, 0)
    clone.Position = UDim2.new(0.75, 4, 1, 4)
    clone.Size = UDim2.new(0.5, -8, 0, 30)
    clone.Parent = Buttons
    UIUtil.bindButton(SkipButton, function() -- line: 85
        -- upvalues: Robux (copy)
        Robux.buy("RebirthSkip")
    end)

    local function showPrice() -- line: 88
        -- upvalues: SkipButton (copy), Robux (copy)
        SkipButton.Label.Text = SkipButton.Label.Text:gsub("%d+", (tostring(Robux.price("RebirthSkip"))))
    end

    Robux.onPrices(showPrice)
    SkipButton.Label.Text = SkipButton.Label.Text:gsub("%d+", (tostring(Robux.price("RebirthSkip"))))

    for _, v13 in { "Rebirths", "Strength", "Money" } do
        LocalPlayer:GetAttributeChangedSignal(v13):Connect(refresh)
    end

    refresh()
end

return t1
