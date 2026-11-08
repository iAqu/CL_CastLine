-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local HoverCard = require(ReplicatedStorage.Client.HoverCard)
local Save = require(ReplicatedStorage.Shared.Save)
local Trove = require(ReplicatedStorage.Packages.Trove)

local function count(p1) -- line: 12
    local n1 = 0

    for _ in p1 or {} do
        n1 += 1
    end

    return n1
end

return function(p2, p3) -- line: 18
    -- upvalues: RunService (copy), TweenService (copy), Constants (copy), Eggs (copy), HoverCard (copy), Save (copy), Trove (copy)
    local v1 = Trove.new()
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Capacity"
    TextButton.BackgroundTransparency = 1
    TextButton.AutoButtonColor = false
    TextButton.TextXAlignment = Enum.TextXAlignment.Left
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextScaled = true

    local v2 = UDim2.fromScale(0.015, 0.1)

    TextButton.Position = v2
    TextButton.Size = UDim2.fromScale(0.3, 0.06)
    TextButton.TextColor3 = Color3.fromRGB(225, 225, 235)
    TextButton.TextStrokeColor3 = Color3.fromRGB(20, 20, 25)
    TextButton.TextStrokeTransparency = 0.3
    TextButton.Selectable = true
    TextButton.ZIndex = 3
    TextButton.Parent = p2
    v1:Add(TextButton)

    local v3 = "Pets"
    local n2 = 0
    local v4 = Constants.BACKPACK.LIMIT
    local v5 = false
    local n3 = 0
    local tween
    local n4 = 0
    local ScreenGui = p2:FindFirstAncestorOfClass("ScreenGui")

    local function isOpen() -- line: 44
        -- upvalues: p2 (copy), p3 (copy), TextButton (copy), ScreenGui (copy)
        return TextButton.Visible and p2.Visible and p3.Visible and ScreenGui ~= nil and ScreenGui.Enabled
    end

    local function stopWiggle() -- line: 47
        -- upvalues: TextButton (copy), v2 (copy), n3 (ref), tween (ref), n4 (ref)
        n4 += 1

        if tween then
            tween:Cancel()
            tween = nil
        end

        TextButton.Position = v2
        n3 = 0
    end

    local function refresh() -- line: 53
        -- upvalues: p2 (copy), TextButton (copy), v2 (copy), v3 (ref), n2 (ref), v4 (ref), v5 (ref), n3 (ref), tween (ref), n4 (ref), Constants (copy), Eggs (copy), Save (copy)
        v3 = p2:GetAttribute("CapacityCategory") or "Pets"
        TextButton.Visible = v3 == "Pets" or v3 == "Eggs"

        if TextButton.Visible then
            local v7 = Save.Await()

            if v7 then
                local v8 = if v3 == "Pets" then v7.Inventory else v7.EggInventory
                local n5 = 0

                for _ in v8 or {} do
                    n5 += 1
                end

                n2 = n5
                v4 = if v3 == "Pets" then Constants.BACKPACK.LIMIT else Eggs.MAX_INVENTORY
                TextButton.Text = ("%*: %*/%*"):format(v3, n2, v4)

                local v9 = n2 / v4

                v5 = v9 >= 1
                TextButton.TextColor3 = if v9 >= 0.9 then Color3.fromRGB(255, 80, 85) else Color3.fromRGB(225, 225, 235)

                if not v5 then
                    n4 += 1

                    if tween then
                        tween:Cancel()
                        tween = nil
                    end

                    TextButton.Position = v2
                    n3 = 0
                end
            else
                TextButton.Text = "Capacity loading..."
            end
        else
            v5 = false
            n4 += 1

            if tween then
                tween:Cancel()
                tween = nil
            end

            TextButton.Position = v2
            n3 = 0
        end
    end

    local function tooltipRows() -- line: 75
        -- upvalues: TextButton (copy), v3 (ref), n2 (ref), v4 (ref)
        if not TextButton.Visible then
            return nil
        end

        local t1 = {
            {
                kind = "heading",
                text = ("%*: %* / %*"):format(v3, n2, v4)
            }
        }

        if n2 > v4 then
            table.insert(t1, {
                kind = "rule"
            })
            table.insert(t1, {
                kind = "body",
                text = `Overflow: +{ n2 - v4 }. Purchases or special grants can exceed the limit.`
            })
        end

        return t1
    end

    local v11 = HoverCard.Attach(TextButton, tooltipRows)

    v1:Add(function() -- line: 85
        -- upvalues: v11 (ref)
        v11()
    end)
    v1:Add(p2:GetAttributeChangedSignal("CapacityCategory"):Connect(function() -- line: 86
        -- upvalues: TextButton (copy), v2 (copy), n3 (ref), tween (ref), n4 (ref), refresh (copy), tooltipRows (copy), v11 (ref), HoverCard (copy)
        v11()
        n4 += 1

        if tween then
            tween:Cancel()
            tween = nil
        end

        TextButton.Position = v2
        n3 = 0
        refresh()
        v11 = HoverCard.Attach(TextButton, tooltipRows)
    end))
    v1:Add(Save.Watch("Inventory"):Connect(refresh))
    v1:Add(Save.Watch("EggInventory"):Connect(refresh))
    v1:Add(Save.Loaded:Connect(refresh))
    v1:Add(RunService.Heartbeat:Connect(function(p4) -- line: 95
        -- upvalues: p2 (copy), p3 (copy), TextButton (copy), v2 (copy), v5 (ref), n3 (ref), tween (ref), n4 (ref), ScreenGui (copy), TweenService (copy)
        if v5 then
            local Visible = TextButton.Visible and p2.Visible and p3.Visible and ScreenGui ~= nil and ScreenGui.Enabled

            if Visible then
                n3 += p4

                if not (n3 < 8) then
                    n3 = 0
                    n4 += 1

                    local v12 = n4

                    task.spawn(function() -- line: 105
                        -- upvalues: v12 (copy), p2 (copy), p3 (copy), TextButton (copy), v2 (copy), tween (ref), n4 (ref), ScreenGui (copy), TweenService (copy)
                        for _, v13 in { -2, 2, -1, 0 } do
                            if v12 ~= n4 or not TextButton.Parent then
                                return
                            end

                            local Visible = TextButton.Visible and p2.Visible and p3.Visible and ScreenGui ~= nil and ScreenGui.Enabled

                            if not Visible then
                                return
                            end

                            local tween2 = TweenService:Create(TextButton, TweenInfo.new(0.09), {
                                Position = v2 + UDim2.fromOffset(v13, 0)
                            })

                            tween = tween2
                            tween2:Play()
                            tween2.Completed:Wait()
                        end

                        if v12 == n4 then
                            tween = nil
                        end
                    end)
                end

                return
            end
        end

        if not (n3 > 0 or tween) then
            return
        end

        n4 += 1

        if tween then
            tween:Cancel()
            tween = nil
        end

        TextButton.Position = v2
        n3 = 0
    end))
    v1:Add(stopWiggle)
    p2.Destroying:Once(function() -- line: 119
        -- upvalues: v1 (copy)
        v1:Destroy()
    end)
    refresh()
end
