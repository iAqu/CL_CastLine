-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local AddCommas = require(ReplicatedStorage.Shared.Utils.Numbers).AddCommas
local Hud = require(ReplicatedStorage.Client.Hud)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local v1 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local v3 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
local v4 = TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local n1 = 0
local n2 = 0
local n3 = 1
local tween = nil
local NumberValue
local n4 = 0

return {
    Start = function() -- Start | line: 40
        -- upvalues: Debris (copy), ReplicatedStorage (copy), SoundService (copy), TweenService (copy), t (copy), AddCommas (copy), Hud (copy), Remotes (copy), Save (copy), Preferences (copy), Simple (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), n1 (ref), n2 (ref), n3 (ref), tween (ref), NumberValue (ref), n4 (ref)
        local CashCollect = SoundService.CashCollect
        local MoneyChange = ReplicatedStorage.Assets.MoneyChange
        local Money = Hud.Get("Money")
        local MoneyValue = Hud.Every("MoneyValue")

        local function playCashCollectSound() -- line: 55
            -- upvalues: CashCollect (copy), Preferences (copy), n2 (ref), n3 (ref)
            if not Preferences.IsOn("SFX") then
                return
            end

            if tick() - n2 > 2 or n3 >= 3 then
                n3 = 1
            end

            n2 = tick()
            CashCollect.TimePosition = 0
            CashCollect.PlaybackSpeed = n3
            CashCollect:Play()
            n3 += 0.07
        end

        local function createMoneyChangeClone() -- line: 72
            -- upvalues: MoneyChange (copy)
            local clone = MoneyChange:Clone()
            local Label, UIScale = clone.Label, clone.UIScale
            local UIStroke, More, Less = Label.UIStroke, Label.More, Label.Less
            local Icon = clone.Icon

            Label.TextTransparency = 1
            UIStroke.Transparency = 1
            UIScale.Scale = 0
            Icon.ImageTransparency = 1

            return clone, Label, UIScale, UIStroke, Icon, More, Less
        end

        local function getTransparencyProperty(p1) -- line: 97
            if p1:IsA("ImageLabel") or p1:IsA("ImageButton") then
                return "ImageTransparency"
            end

            if p1:IsA("TextLabel") or p1:IsA("TextButton") then
                return "TextTransparency"
            end

            return if p1:IsA("UIStroke") then "Transparency" else nil
        end

        local function animateNotification(p2, p3, p4, p5, p6) -- line: 109
            -- upvalues: getTransparencyProperty (copy), Debris (copy), TweenService (copy), v2 (copy), v3 (copy), v4 (copy)
            TweenService:Create(p3, v2, {
                TextTransparency = 0.25
            }):Play()
            TweenService:Create(p5, v2, {
                Transparency = 0.25
            }):Play()
            TweenService:Create(p4, v3, {
                Scale = 1
            }):Play()

            for _, v5 in ipairs(p6) do
                local v6 = getTransparencyProperty(v5)

                if v6 then
                    if v6 == "ImageTransparency" then
                        v5.ImageTransparency = 1
                    elseif v6 == "TextTransparency" then
                        v5.TextTransparency = 1
                    elseif v6 == "Transparency" then
                        v5.Transparency = 1
                    end

                    TweenService:Create(v5, v2, {
                        [v6] = 0
                    }):Play()
                end
            end

            task.delay(1, function() -- line: 135
                -- upvalues: p2 (copy), p3 (copy), p5 (copy), p6 (copy), getTransparencyProperty (copy), Debris (copy), TweenService (copy), v4 (copy)
                TweenService:Create(p3, v4, {
                    TextTransparency = 1
                }):Play()
                TweenService:Create(p5, v4, {
                    Transparency = 1
                }):Play()

                for _, v7 in ipairs(p6) do
                    local v8 = getTransparencyProperty(v7)

                    if v8 then
                        TweenService:Create(v7, v4, {
                            [v8] = 1
                        }):Play()
                    end
                end

                Debris:AddItem(p2, 0.75)
            end)
        end

        local function spawnFloatingMoney(p7, _) -- line: 150
            -- upvalues: MoneyChange (copy), Money (copy), animateNotification (copy), Simple (copy)
            local v9 = p7 < 0
            local v10 = if v9 then "-" else "+"
            local clone = MoneyChange:Clone()
            local Label, UIScale = clone.Label, clone.UIScale
            local UIStroke, More, Less = Label.UIStroke, Label.More, Label.Less
            local Icon = clone.Icon

            Label.TextTransparency = 1
            UIStroke.Transparency = 1
            UIScale.Scale = 0
            Icon.ImageTransparency = 1

            if More and More:IsA("UIGradient") then
                More.Enabled = not v9
            end

            if Less and Less:IsA("UIGradient") then
                Less.Enabled = v9
            end

            Label.Text = v10 .. "$" .. Simple.FormatCompact(math.round((math.abs(p7))), ".#")

            local t2 = {}

            Icon.Visible = false
            clone.ZIndex = 10
            clone.Parent = Money
            animateNotification(clone, Label, UIScale, UIStroke, t2)
        end

        local function displayMoneyChange(p9, p10, p11) -- line: 176
            -- upvalues: playCashCollectSound (copy), spawnFloatingMoney (copy)
            if p9 ~= 0 then
                if p9 > 0 and p11 ~= false then
                    playCashCollectSound()
                end

                spawnFloatingMoney(p9, p10)
            end
        end

        local function updateMoneyLabels(p12) -- line: 188
            -- upvalues: MoneyValue (copy), t (copy)
            t.strict(t.string)(p12)

            for _, v12 in MoneyValue do
                v12.Text = p12

                local Shadow = v12:FindFirstChild("Shadow")

                if Shadow ~= nil then
                    Shadow.Text = p12
                end
            end
        end

        local function formatMoneyText(p13) -- line: 200
            -- upvalues: AddCommas (copy), Simple (copy)
            if p13 > 99999 then
                return "$" .. Simple.FormatCompact(math.round(p13), ".#")
            end

            return "$" .. AddCommas((math.round(p13)))
        end

        local function setMoneyLabelValue(p14) -- line: 220
            -- upvalues: updateMoneyLabels (copy), AddCommas (copy), Simple (copy)
            updateMoneyLabels(if p14 > 99999 then "$" .. Simple.FormatCompact(math.round(p14), ".#") else "$" .. AddCommas((math.round(p14))))
        end

        local function tweenMoneyLabelValue(p15, p16) -- line: 222
            -- upvalues: updateMoneyLabels (copy), setMoneyLabelValue (copy), TweenService (copy), AddCommas (copy), Simple (copy), v1 (copy), tween (ref), NumberValue (ref)
            if tween then
                tween:Cancel()
                tween = nil
            end

            if NumberValue then
                NumberValue:Destroy()
                NumberValue = nil
            end

            local NumberValue2 = Instance.new("NumberValue")

            NumberValue2.Value = p15
            NumberValue = NumberValue2
            updateMoneyLabels(if p15 > 99999 then "$" .. Simple.FormatCompact(math.round(p15), ".#") else "$" .. AddCommas((math.round(p15))))
            NumberValue2.Changed:Connect(setMoneyLabelValue)

            local tween2 = TweenService:Create(NumberValue2, v1, {
                Value = p16
            })

            tween = tween2
            tween2.Completed:Once(function(p17) -- line: 235
                -- upvalues: p16 (copy), NumberValue2 (copy), tween2 (copy), updateMoneyLabels (copy), AddCommas (copy), Simple (copy), tween (ref), NumberValue (ref)
                if tween ~= tween2 then
                    return
                end

                tween = nil
                NumberValue = nil

                if p17 == Enum.PlaybackState.Completed then
                    updateMoneyLabels(if p16 > 99999 then "$" .. Simple.FormatCompact(math.round(p16), ".#") else "$" .. AddCommas((math.round(p16))))
                end

                NumberValue2:Destroy()
            end)
            tween2:Play()
        end

        local function updateMoney(p18) -- line: 252
            -- upvalues: playCashCollectSound (copy), spawnFloatingMoney (copy), updateMoneyLabels (copy), tweenMoneyLabelValue (copy), AddCommas (copy), Save (copy), Simple (copy), n1 (ref), tween (ref), NumberValue (ref), n4 (ref)
            local v16 = Save.Await()

            if not v16 then
                return
            end

            local Money = v16.Money
            local v17 = p18 and p18.forceUpdate

            if Money == n1 and not v17 then
                return
            end

            if not v17 and n1 < Money then
                tweenMoneyLabelValue(if NumberValue then NumberValue.Value else n1, Money)
            else
                if tween then
                    tween:Cancel()
                    tween = nil
                end

                if NumberValue then
                    NumberValue:Destroy()
                    NumberValue = nil
                end

                updateMoneyLabels(if Money > 99999 then "$" .. Simple.FormatCompact(math.round(Money), ".#") else "$" .. AddCommas((math.round(Money))))
            end

            if not v17 then
                local v20 = Money - n1

                if v20 > 0 and n4 > 0 then
                    local v22 = math.min(v20, n4)

                    v20 -= v22
                    n4 -= v22
                end

                if v20 ~= 0 then
                    local v23 = v20 > 0
                    local v24 = if p18 then p18.allowPositiveAnimation == nil else nil
                    local v25 = if not p18 or v24 then true else p18.allowPositiveAnimation

                    if (not v23 or v25) and v20 ~= 0 then
                        if v20 > 0 then
                            playCashCollectSound()
                        end

                        spawnFloatingMoney(v20, nil)
                    end
                end
            end

            n1 = Money
        end

        Save.Loaded:Connect(function() -- line: 301
            -- upvalues: updateMoney (copy)
            updateMoney({
                forceUpdate = true
            })
        end)

        local Treadmill = Hud.Frame("Treadmill")

        Treadmill:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 304
            -- upvalues: updateMoney (copy), Treadmill (copy)
            if Treadmill.Visible then
                updateMoney({
                    forceUpdate = true
                })
            end
        end)
        updateMoney({
            forceUpdate = true
        })
        Save.Changed:Connect(function(p19) -- line: 312
            -- upvalues: updateMoney (copy)
            if p19 == "Money" then
                updateMoney({
                    allowPositiveAnimation = false
                })
            end
        end)
        Remotes.PenRoster.CoinsGathered.OnClientEvent:Connect(function(p20, p21) -- line: 319
            -- upvalues: playCashCollectSound (copy), spawnFloatingMoney (copy), n4 (ref)
            if p20 and not p21 then
                local n5 = 0
                local v27 = false

                for _, v28 in ipairs(p20) do
                    if v28 and typeof(v28.amount) == "number" then
                        n5 += math.max(v28.amount, 0)

                        local v29 = v28.playSound ~= false and not v27
                        local amount2, icon = v28.amount, v28.icon

                        if amount2 ~= 0 then
                            if amount2 > 0 and v29 ~= false then
                                playCashCollectSound()
                            end

                            spawnFloatingMoney(amount2, icon)
                        end

                        if v28.amount > 0 and v29 then
                            v27 = true
                        end
                    end
                end

                if n5 > 0 then
                    n4 += n5
                end
            end
        end)
    end
}
