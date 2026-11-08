-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)

require(ReplicatedStorage.Shared.Types.AssetItem)

local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
local Audio = require(ReplicatedStorage.Shared.Audio)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local Message = require(ReplicatedStorage.Client.Message)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

require(ReplicatedStorage.Packages.Trove)

local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local Streamable = require(ReplicatedStorage.Packages.Streamable).Streamable
local Log = require(ReplicatedStorage.Packages.Log)
local v1 = Color3.fromRGB(0, 255, 8):ToHex()
local v2 = Color3.fromRGB(255, 170, 0):ToHex()
local v3 = Color3.fromRGB(207, 58, 255):ToHex()

return {
    Start = function() -- Start | line: 45
        -- upvalues: Players (copy), Workspace (copy), Assets (copy), AssetItems (copy), Audio (copy), EggRecords (copy), Message (copy), Remotes (copy), Save (copy), Simple (copy), TryCall (copy), Streamable (copy), Log (copy), v1 (copy), v2 (copy), v3 (copy)
        local Stands = Workspace.Stands

        assert(Stands:IsA("Folder"), "Workspace.Stands must be a Folder")

        local Prompts = Stands.Prompts

        assert(Prompts:IsA("Folder"), "Workspace.Stands.Prompts must be a Folder")

        local LocalPlayer = Players.LocalPlayer
        local v4 = Log.new()

        local function getInventoryItemData(p1) -- line: 61
            -- upvalues: v4 (copy), AssetItems (copy), Save (copy), TryCall (copy)
            local v5 = Save.Await()
            local v6 = v5 and v5.Inventory

            if v6 then
                local v7 = v6[p1]

                if v7 then
                    local v8, v9 = TryCall(AssetItems.Decode, v7)

                    if v8 then
                        return v9
                    end

                    v4:AtDebug():Log((("Skipped invalid seller inventory item %*"):format(p1)))
                end
            end

            return nil
        end

        local function isEquipped(p2) -- line: 82
            -- upvalues: Save (copy)
            local v10 = Save.Await()

            return v10 ~= nil and table.find(v10.EquippedAssets, p2) ~= nil
        end

        local function computeItemValue(p3) -- line: 87
            -- upvalues: LocalPlayer (copy), AssetItems (copy)
            local v11 = AssetItems.SalePrice(p3)

            if LocalPlayer:GetAttribute("VIP") then
                v11 *= 2
            end

            return v11
        end

        local function getEggItemData(p4) -- line: 97
            -- upvalues: EggRecords (copy), Save (copy)
            local v12 = Save.Await()
            local v13 = v12 and v12.EggInventory

            if v13 == nil then
                return nil, nil, nil
            end

            local v14 = v13[p4]

            if v14 == nil or v14.Placement ~= nil then
                return nil, nil, nil
            end

            local v15 = EggRecords.Decode(v14)

            return EggRecords.ToAssetItemData(v15), EggRecords.SellPrice(v15), EggRecords.DisplayNameWithWeight(v15)
        end

        local function formatPrice(p5) -- line: 115
            -- upvalues: Simple (copy), v1 (copy)
            return string.format("<font color='#%s'>$%s</font>", v1, Simple.FormatCompact(p5, "."))
        end

        local function promptSellHeld() -- line: 123
            -- upvalues: LocalPlayer (copy), getInventoryItemData (copy), getEggItemData (copy), formatPrice (copy), Assets (copy), AssetItems (copy), Audio (copy), Message (copy), Remotes (copy), Save (copy), v3 (copy)
            local Character = LocalPlayer.Character

            if Character then
                local Tool = Character:FindFirstChildWhichIsA("Tool")
                local UID = if Tool then Tool:GetAttribute("UID") else nil
                local v16 = false
                local v17 = false
                local v18 = false
                local v19 = false
                local v20 = false
                local v21 = false

                if Tool ~= nil then
                    v16 = true
                else
                    v21 = true
                end

                if v16 then
                    if type(UID) == "string" then
                        v17 = true
                    else
                        v21 = true
                    end
                end

                v16 = false

                local ItemType

                if v17 then
                    ItemType = Tool:GetAttribute("ItemType")

                    if ItemType == "AssetEgg" then
                        v18 = true
                    else
                        v16 = true
                    end
                end

                v17 = false

                if v16 then
                    if ItemType == "Asset" then
                        v17 = true
                    else
                        v21 = false
                    end
                end

                v16 = false

                local v22

                if v17 then
                    v22 = getInventoryItemData(UID)

                    if v22 ~= nil then
                        v16 = true
                    else
                        v21 = false
                    end
                end

                v17 = false

                local v23, v24

                if v16 then
                    v23 = Save.Await()

                    if v23 ~= nil then
                        v17 = true
                    else
                        v24 = false
                        v19 = true
                    end
                end

                v16 = false

                if v17 then
                    if table.find(v23.EquippedAssets, UID) ~= nil then
                        v16 = true
                    else
                        v20 = true
                    end
                end

                if v16 then
                    v24 = true
                    v19 = true
                end

                v16 = false

                if v20 then
                    v24 = false
                    v19 = true
                end

                v20 = false

                if v19 then
                    if v24 then
                        v21 = false
                    else
                        v20 = true
                    end
                end

                v19 = false

                if v20 then
                    if v22.InFuse then
                        v21 = false
                    else
                        v19 = true
                    end
                end

                v20 = false

                local t3, v25

                if v19 then
                    t3 = {
                        kind = "pet"
                    }

                    local DisplayName = Assets.Directory[v22.Category].DisplayName

                    if DisplayName then
                        v25 = DisplayName
                        v16 = true
                    else
                        v20 = true
                    end
                end

                v19 = false

                if v20 then
                    v25 = v22.Category
                    v16 = true
                end

                v20 = false

                if v16 then
                    t3.displayName = v25

                    if v22.IsFavorite == true then
                        v19 = true
                    else
                        v20 = true
                    end
                end

                v16 = false

                local v26

                if v20 then
                    v26 = false
                    v16 = true
                end

                v20 = false

                if v19 then
                    v26 = true
                    v16 = true
                end

                v19 = false

                local v27, v28

                if v16 then
                    t3.isFavorite = v26
                    t3.itemData = v22
                    v27 = AssetItems.SalePrice(v22)

                    if LocalPlayer:GetAttribute("VIP") then
                        v19 = true
                    else
                        v28 = v27
                        v20 = true
                    end
                end

                if v19 then
                    v28 = v27 * 2
                    v20 = true
                end

                local t2

                if v20 then
                    t3.price = v28
                    t3.uid = UID
                    t2 = t3
                    v21 = false
                end

                v20 = false

                local v29, v30, v31

                if v18 then
                    v29, v30, v31 = getEggItemData(UID)

                    if v29 ~= nil then
                        v20 = true
                    else
                        t2 = nil
                        v21 = false
                    end
                end

                v18 = false

                if v20 then
                    if v30 ~= nil then
                        v18 = true
                    else
                        t2 = nil
                        v21 = false
                    end
                end

                v20 = false

                if v18 then
                    if v31 ~= nil then
                        v20 = true
                    else
                        t2 = nil
                        v21 = false
                    end
                end

                if v20 then
                    t2 = {
                        isFavorite = false,
                        kind = "egg",
                        displayName = v31,
                        itemData = v29,
                        price = v30,
                        uid = UID
                    }
                    v21 = false
                end

                if not v21 then
                    if t2 ~= nil then
                        if t2.isFavorite then
                            local v32 = string.format("<font color='#%s'>favorited</font>", v3)

                            Message.Notice(string.format("You can't sell %s items.", v32))
                        else
                            local itemData = t2.itemData
                            local v33 = Assets.Directory[itemData.Category].Rarity.Color:ToHex()
                            local v34 = string.format("Would you like to sell %s <font color='#%s'>%s</font> for %s?", t2.kind, v33, t2.displayName, formatPrice(t2.price))

                            if Message.Confirm(v34) then
                                Remotes.PetSatchel.SellPet:FireServer({
                                    t2.uid
                                })
                                Audio.Chime("Prompt")
                            end
                        end
                    else
                        Message.Notice("No item equipped.")
                    end

                    return
                end
            end

            Message.Notice("No item equipped.")
        end

        local function getSellableInventory() -- line: 195
            -- upvalues: AssetItems (copy), Save (copy), TryCall (copy)
            local t4 = {}
            local v35 = Save.Await()
            local v36 = v35 and v35.Inventory

            if v36 then
                for v37, v38 in pairs(v36) do
                    local v39, v40 = TryCall(AssetItems.Decode, v38)

                    if v39 and v40.IsFavorite ~= true then
                        local v41 = Save.Await()

                        if (v41 == nil or table.find(v41.EquippedAssets, v37) == nil) and not v40.InFuse then
                            table.insert(t4, {
                                uid = v37,
                                itemData = v40
                            })
                        end
                    end
                end
            end

            return t4
        end

        local function promptSellAll() -- line: 213
            -- upvalues: LocalPlayer (copy), formatPrice (copy), getSellableInventory (copy), AssetItems (copy), Audio (copy), Message (copy), Remotes (copy), v2 (copy)
            local v42 = getSellableInventory()

            if #v42 == 0 then
                Message.Notice("You don't have any pets in your inventory.")
            else
                local t6 = {}
                local n1 = 0

                for _, v43 in ipairs(v42) do
                    local itemData = v43.itemData
                    local v44 = AssetItems.SalePrice(itemData)

                    if LocalPlayer:GetAttribute("VIP") then
                        v44 *= 2
                    end

                    n1 += v44
                    table.insert(t6, v43.uid)
                end

                local v45 = string.format("Would you like to sell <font color='#%s'>%d pets</font> for %s?", v2, #v42, formatPrice(n1))

                if Message.Confirm(v45) then
                    Remotes.PetSatchel.SellEveryPet:FireServer(t6)
                    Audio.Chime("Prompt")
                end
            end
        end

        local function bindPrompt(p6, _) -- line: 241
            -- upvalues: Prompts (copy), Streamable (copy)
            Streamable.new(Prompts, p6):Observe(function(p8, p9) -- line: 243
                -- upvalues: Streamable (copy)
                local ProximityPrompt = Streamable.new(p8, "ProximityPrompt")

                p9:Add(function() -- line: 245
                    -- upvalues: ProximityPrompt (copy)
                    ProximityPrompt:Destroy()
                end)
                p9:Add(ProximityPrompt:Observe(function(p10, _) -- line: 246
                    p10.Enabled = false
                end))
            end)
        end

        Streamable.new(Prompts, "SellHeldAsset"):Observe(function(p12, p13) -- line: 243
            -- upvalues: Streamable (copy)
            local ProximityPrompt = Streamable.new(p12, "ProximityPrompt")

            p13:Add(function() -- line: 245
                -- upvalues: ProximityPrompt (copy)
                ProximityPrompt:Destroy()
            end)
            p13:Add(ProximityPrompt:Observe(function(p14, _) -- line: 246
                p14.Enabled = false
            end))
        end)
        Streamable.new(Prompts, "SellAll"):Observe(function(p16, p17) -- line: 243
            -- upvalues: Streamable (copy)
            local ProximityPrompt = Streamable.new(p16, "ProximityPrompt")

            p17:Add(function() -- line: 245
                -- upvalues: ProximityPrompt (copy)
                ProximityPrompt:Destroy()
            end)
            p17:Add(ProximityPrompt:Observe(function(p18, _) -- line: 246
                p18.Enabled = false
            end))
        end)
    end
}
