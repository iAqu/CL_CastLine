-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local AssetPlacementHints = require(script.Parent.Parent.Plots.ActiveAssetsController.AssetPlacementHints)
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Player = require(ReplicatedStorage.Shared.Player)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(85, 255, 85)
local v2 = Color3.fromRGB(255, 70, 70)
local LocalPlayer = Players.LocalPlayer
local v3 = Trove.new()
local v4 = Trove.new()
local v5, UID

return {
    Start = function() -- Start | line: 31
        -- upvalues: Assets (copy), AssetPlacementHints (copy), AssetRoster (copy), Toast (copy), Player (copy), v1 (copy), v2 (copy), LocalPlayer (copy), v3 (copy), v4 (copy), v5 (ref), UID (ref)
        local function isAssetTool(p1) -- line: 36
            return p1:GetAttribute("ItemType") == "Asset"
        end

        local function getAssetToolUid(p2) -- line: 38
            local UID = p2:GetAttribute("UID")

            return if typeof(UID) == "string" and UID ~= "" then UID else nil
        end

        local function getAssetToolCategory(p3) -- line: 43
            local Category = p3:GetAttribute("Category")

            return if typeof(Category) == "string" and Category ~= "" then Category else nil
        end

        local function isNearPetAreaSurface(p4, p5) -- line: 48
            local v6 = p4.CFrame:PointToObjectSpace(p5)
            local v7 = p4.Size * 0.5
            local v14 = Vector3.new(math.clamp(v6.X, -v7.X, v7.X), math.clamp(v6.Y, -v7.Y, v7.Y), (math.clamp(v6.Z, -v7.Z, v7.Z)))

            return (p5 - p4.CFrame:PointToWorldSpace(v14)).Magnitude <= 20
        end

        local function showGetCloserNotification() -- line: 61
            -- upvalues: Toast (copy), v2 (copy)
            Toast.Show({
                Text = "Get closer to your Pen to place pets!",
                Seconds = 2,
                Color = v2
            })
        end

        local function showEquipSuccessNotification(p6) -- line: 69
            -- upvalues: Assets (copy), Toast (copy), v1 (copy)
            local Category = p6:GetAttribute("Category")

            if typeof(Category) ~= "string" or Category == "" then
                Category = nil
            end

            if Category == nil then
                return
            end

            local v15 = Assets.Directory[Category]

            if v15.DisplayName ~= "" then
                Category = v15.DisplayName
            end

            local v16 = if v15.Rarity then v15.Rarity.Color else Color3.new(1, 1, 1)

            Toast.Show({
                Seconds = 2,
                Text = ("Sucessfully equipped <font color=\"#%*\">%*!</font>"):format(v16:ToHex(), Category),
                Color = v1
            })
        end

        local function showEquipErrorNotification(p7) -- line: 85
            -- upvalues: Toast (copy), v2 (copy)
            Toast.Show({
                Seconds = 2,
                Text = p7,
                Color = v2
            })
        end

        local function tryEquipToolAsset(p8) -- line: 93
            -- upvalues: isNearPetAreaSurface (copy), showEquipSuccessNotification (copy), AssetPlacementHints (copy), AssetRoster (copy), Toast (copy), Player (copy), v2 (copy), LocalPlayer (copy), v4 (copy), v5 (ref), UID (ref)
            local UID2 = p8:GetAttribute("UID")

            if typeof(UID2) ~= "string" or UID2 == "" then
                UID2 = nil
            end

            if UID2 ~= nil and UID ~= UID2 then
                local v17 = Player.FindRootPart(LocalPlayer)

                if v17 == nil or v17:IsA("BasePart") then
                    local v18 = AssetRoster.FindPenArea(LocalPlayer)

                    if v17 ~= nil and v18 ~= nil then
                        if isNearPetAreaSurface(v18, v17.Position) then
                            UID = UID2
                            AssetPlacementHints.SetFrontPlacement(UID2, v17.CFrame)

                            local v19, v20 = AssetRoster.WearAsset(UID2)

                            if UID == UID2 then
                                UID = nil
                            end

                            if v19 then
                                if v5 == p8 then
                                    showEquipSuccessNotification(p8)
                                    v4:Clean()
                                    v5 = nil
                                end
                            else
                                AssetPlacementHints.ClearFrontPlacement(UID2)

                                if v20 ~= nil then
                                    Toast.Show({
                                        Seconds = 2,
                                        Text = v20,
                                        Color = v2
                                    })
                                end
                            end
                        else
                            Toast.Show({
                                Text = "Get closer to your Pen to place pets!",
                                Seconds = 2,
                                Color = v2
                            })
                        end
                    end
                end
            end
        end

        local function bindTool(p9) -- line: 133
            -- upvalues: tryEquipToolAsset (copy), v4 (copy), v5 (ref)
            v4:Clean()
            v5 = p9
            v4:Connect(p9.Activated, function() -- line: 136
                -- upvalues: p9 (copy), tryEquipToolAsset (copy)
                tryEquipToolAsset(p9)
            end)
        end

        local function refreshCharacter(p10) -- line: 139
            -- upvalues: tryEquipToolAsset (copy), v4 (copy), v5 (ref)
            v4:Clean()
            v5 = nil

            local Tool = p10:FindFirstChildOfClass("Tool")

            if Tool == nil or Tool:GetAttribute("ItemType") ~= "Asset" then
                return
            end

            v4:Clean()
            v5 = Tool
            v4:Connect(Tool.Activated, function() -- line: 136
                -- upvalues: Tool (copy), tryEquipToolAsset (copy)
                tryEquipToolAsset(Tool)
            end)
        end

        local function bindCharacter(p11) -- line: 148
            -- upvalues: tryEquipToolAsset (copy), v3 (copy), v4 (copy), v5 (ref)
            v3:Clean()
            v4:Clean()
            v5 = nil

            local Tool = p11:FindFirstChildOfClass("Tool")

            if Tool ~= nil and Tool:GetAttribute("ItemType") == "Asset" then
                v4:Clean()
                v5 = Tool
                v4:Connect(Tool.Activated, function() -- line: 136
                    -- upvalues: Tool (copy), tryEquipToolAsset (copy)
                    tryEquipToolAsset(Tool)
                end)
            end

            v3:Connect(p11.ChildAdded, function(p12) -- line: 152
                -- upvalues: tryEquipToolAsset (copy), v4 (copy), v5 (ref)
                if not p12:IsA("Tool") or p12:GetAttribute("ItemType") ~= "Asset" then
                    return
                end

                v4:Clean()
                v5 = p12
                v4:Connect(p12.Activated, function() -- line: 136
                    -- upvalues: p12 (copy), tryEquipToolAsset (copy)
                    tryEquipToolAsset(p12)
                end)
            end)
            v3:Connect(p11.ChildRemoved, function(p13) -- line: 158
                -- upvalues: v4 (copy), v5 (ref)
                if p13 == v5 then
                    v4:Clean()
                    v5 = nil
                end
            end)
        end

        LocalPlayer.CharacterAdded:Connect(bindCharacter)
        LocalPlayer.CharacterRemoving:Connect(function() -- line: 171
            -- upvalues: v3 (copy), v4 (copy), v5 (ref), UID (ref)
            v3:Clean()
            v4:Clean()
            v5 = nil
            UID = nil
        end)

        if LocalPlayer.Character ~= nil then
            bindCharacter(LocalPlayer.Character)
        end
    end
}
