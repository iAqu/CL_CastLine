-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local Log = require(ReplicatedStorage.Packages.Log)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = Log.new()
local v2
local v3 = false

return {
    Start = function() -- Start | line: 27
        -- upvalues: GUI (copy), Remotes (copy), Tabs (copy), TryCall (copy), v1 (copy), v2 (ref), v3 (ref)
        local function resolveControls() -- line: 32
            -- upvalues: GUI (copy)
            local v4 = GUI.HUD()
            local GameHUD = if v4 == nil then nil else v4:FindFirstChild("GameHUD")
            local LeftControls = if GameHUD == nil then nil else GameHUD:FindFirstChild("LeftControls")

            if LeftControls == nil then
                return nil, nil
            end

            local ShopBTN = LeftControls:FindFirstChild("ShopBTN")
            local IndexBTN = LeftControls:FindFirstChild("IndexBTN")
            local NotificationBadge = if IndexBTN == nil then nil else IndexBTN:FindFirstChild("NotificationBadge")

            if ShopBTN == nil or not ShopBTN:IsA("GuiObject") then
                return nil, nil
            end

            if NotificationBadge == nil or not NotificationBadge:IsA("GuiObject") then
                return ShopBTN, nil
            end

            return ShopBTN, NotificationBadge
        end

        local function buildBadge() -- line: 49
            -- upvalues: resolveControls (copy), v1 (copy)
            local v5, v6 = resolveControls()

            if v5 ~= nil and v6 ~= nil then
                local ShopCtaBadge = v5:FindFirstChild("ShopCtaBadge")

                if ShopCtaBadge ~= nil then
                    ShopCtaBadge:Destroy()
                end

                local clone = v6:Clone()

                clone.Name = "ShopCtaBadge"

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("TextLabel") then
                        descendant.Text = "!"
                    end
                end

                clone.Size = UDim2.new(clone.Size.X.Scale * 1.4, clone.Size.X.Offset * 1.4, clone.Size.Y.Scale * 1.4, clone.Size.Y.Offset * 1.4)
                clone.Visible = true
                clone.Parent = v5

                return clone
            end

            v1:AtWarning():Log("Shop CTA badge could not find ShopBTN or the index badge to clone")

            return nil
        end

        local function destroyBadge() -- line: 79
            -- upvalues: resolveControls (copy), v2 (ref)
            v2 = nil

            local v7 = resolveControls()
            local ShopCtaBadge = if v7 == nil then nil else v7:FindFirstChild("ShopCtaBadge")

            if ShopCtaBadge ~= nil then
                ShopCtaBadge:Destroy()
            end
        end

        local function retire() -- line: 88
            -- upvalues: resolveControls (copy), Remotes (copy), TryCall (copy), v2 (ref), v3 (ref)
            if v3 then
                return
            end

            v3 = true
            v2 = nil

            local v8 = resolveControls()
            local ShopCtaBadge = if v8 == nil then nil else v8:FindFirstChild("ShopCtaBadge")

            if ShopCtaBadge ~= nil then
                ShopCtaBadge:Destroy()
            end

            TryCall(function() -- line: 94
                -- upvalues: Remotes (copy)
                return Remotes.ShopCta.FlagSeen:InvokeServer()
            end)
        end

        Tabs.Activated:Connect(function(p1) -- line: 101
            -- upvalues: resolveControls (copy), Remotes (copy), TryCall (copy), v2 (ref), v3 (ref)
            if p1 ~= "Shop" or v3 then
                return
            end

            v3 = true
            v2 = nil

            local v9 = resolveControls()
            local ShopCtaBadge = if v9 == nil then nil else v9:FindFirstChild("ShopCtaBadge")

            if ShopCtaBadge ~= nil then
                ShopCtaBadge:Destroy()
            end

            TryCall(function() -- line: 94
                -- upvalues: Remotes (copy)
                return Remotes.ShopCta.FlagSeen:InvokeServer()
            end)
        end)
        task.spawn(function() -- line: 107
            -- upvalues: resolveControls (copy), buildBadge (copy), Remotes (copy), Tabs (copy), TryCall (copy), v2 (ref), v3 (ref)
            local v10, v11 = TryCall(function() -- line: 108
                -- upvalues: Remotes (copy)
                return Remotes.ShopCta.FetchState:InvokeServer()
            end)

            if v10 and v11 == true then
                if v3 or Tabs.Active() == "Shop" then
                    if not v3 then
                        v3 = true
                        v2 = nil

                        local v12 = resolveControls()
                        local ShopCtaBadge = if v12 == nil then nil else v12:FindFirstChild("ShopCtaBadge")

                        if ShopCtaBadge ~= nil then
                            ShopCtaBadge:Destroy()
                        end

                        TryCall(function() -- line: 94
                            -- upvalues: Remotes (copy)
                            return Remotes.ShopCta.FlagSeen:InvokeServer()
                        end)
                    end
                else
                    v2 = buildBadge()
                end
            end
        end)
    end
}
