-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.Globals.Constants)

local Log = require(ReplicatedStorage.Packages.Log)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Storefront = require(ReplicatedStorage.Client.Functions.Storefront)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)

require(ReplicatedStorage.Data.Treadmills)

local Treadmills = require(ReplicatedStorage.Data.Treadmills)
local v1 = Color3.fromRGB(255, 64, 64)
local v2 = Log.new()
local t1 = {}

function t1.GetNextConfig(p1) -- line: 31
    -- upvalues: t (copy), Treadmills (copy)
    t.strict(t.intersection(t.integer, t.numberMin(0)))(p1.TreadmillUpgradeLevel)

    local v3 = p1.TreadmillUpgradeLevel + 1

    return v3, Treadmills.GetByUpgradeLevel(v3)
end

function t1.CanAffordNext(p2) -- line: 41
    -- upvalues: t1 (copy)
    local _, v4 = t1.GetNextConfig(p2)

    return v4 ~= nil and p2.Money >= v4.Price
end

function t1.RequestCashUpgrade() -- line: 46
    -- upvalues: Toast (copy), Remotes (copy), Save (copy), v1 (copy), v2 (copy), t1 (copy)
    local v5 = Save.Await()

    assert(v5 ~= nil, "Treadmill cash upgrade requires loaded data")

    local _, v7 = t1.GetNextConfig(v5)

    if v7 ~= nil then
        if v5.Money < v7.Price then
            Toast.Show({
                Text = "Not enough money",
                Seconds = 2,
                Color = v1
            })
        else
            local v8, v9 = Remotes.Treadmill.AskTierRaise:InvokeServer(v7._id)

            if v8 == true then
                return true
            end

            local v10 = v9 or "Treadmill upgrade failed"

            v2:AtWarning():Log(v10)
            Toast.Show({
                Seconds = 2,
                Text = v10,
                Color = v1
            })
        end
    else
        Toast.Show({
            Text = "Max treadmill upgrade reached",
            Seconds = 2
        })
    end

    return false
end

function t1.PromptRobuxUpgrade() -- line: 71
    -- upvalues: Toast (copy), Storefront (copy), Save (copy), v2 (copy), t1 (copy)
    local v11 = Save.Await()

    assert(v11 ~= nil, "Treadmill Robux upgrade requires loaded data")

    local _, v13 = t1.GetNextConfig(v11)

    if v13 == nil then
        Toast.Show({
            Text = "Max treadmill upgrade reached",
            Seconds = 2
        })

        return false
    end

    local ProductId = v13.ProductId

    if ProductId == nil then
        v2:AtWarning():Log((("Treadmill \"%*\" has no Robux upgrade product"):format(v13._id)))

        return false
    end

    Storefront.Prompt(ProductId, true)

    return true
end

return t1
