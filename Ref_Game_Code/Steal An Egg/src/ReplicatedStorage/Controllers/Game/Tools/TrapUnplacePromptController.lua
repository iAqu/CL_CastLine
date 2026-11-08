-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local LocalPlayer = Players.LocalPlayer
local UNPLACE_PROMPT = Constants.TAGS_MAP.Traps.UNPLACE_PROMPT
local t2 = {}

return {
    Start = function() -- Start | line: 28
        -- upvalues: CollectionService (copy), LocalPlayer (copy), UNPLACE_PROMPT (copy), t2 (copy)
        local function cleanupPromptConnections(p1) -- line: 30
            -- upvalues: t2 (copy)
            local v1 = t2[p1]

            if not v1 then
                return
            end

            local Owner = v1.Owner

            if Owner then
                Owner:Disconnect()
            end

            local Active = v1.Active

            if Active then
                Active:Disconnect()
            end

            t2[p1] = nil
        end

        local function updatePromptEnabled(p2) -- line: 49
            -- upvalues: LocalPlayer (copy)
            local Parent = p2.Parent

            if not Parent or not Parent:IsA("BasePart") then
                p2.Enabled = false

                return
            end

            local Owner = Parent:GetAttribute("Owner")
            local TrapActive = Parent:GetAttribute("TrapActive")

            if Owner == LocalPlayer.Name then
                p2.Enabled = TrapActive ~= true
            else
                p2.Enabled = false
            end
        end

        local function bindPromptConnections(p3) -- line: 61
            -- upvalues: LocalPlayer (copy), t2 (copy)
            local v2 = t2[p3]

            if v2 then
                local Owner = v2.Owner

                if Owner then
                    Owner:Disconnect()
                end

                local Active = v2.Active

                if Active then
                    Active:Disconnect()
                end

                t2[p3] = nil
            end

            local Parent = p3.Parent

            if not (Parent and Parent:IsA("BasePart")) then
                return
            end

            t2[p3] = {
                Owner = Parent:GetAttributeChangedSignal("Owner"):Connect(function() -- line: 72
                    -- upvalues: p3 (copy), LocalPlayer (copy)
                    local Parent = p3.Parent

                    if not Parent or not Parent:IsA("BasePart") then
                        p3.Enabled = false

                        return
                    end

                    local Owner = Parent:GetAttribute("Owner")
                    local TrapActive = Parent:GetAttribute("TrapActive")

                    p3.Enabled = Owner == LocalPlayer.Name and TrapActive ~= true
                end),
                Active = Parent:GetAttributeChangedSignal("TrapActive"):Connect(function() -- line: 75
                    -- upvalues: p3 (copy), LocalPlayer (copy)
                    local Parent = p3.Parent

                    if not Parent or not Parent:IsA("BasePart") then
                        p3.Enabled = false

                        return
                    end

                    local Owner = Parent:GetAttribute("Owner")
                    local TrapActive = Parent:GetAttribute("TrapActive")

                    p3.Enabled = Owner == LocalPlayer.Name and TrapActive ~= true
                end)
            }
        end

        local function refreshPrompt(p4) -- line: 79
            -- upvalues: bindPromptConnections (copy), LocalPlayer (copy)
            bindPromptConnections(p4)

            local Parent = p4.Parent

            if not Parent or not Parent:IsA("BasePart") then
                p4.Enabled = false

                return
            end

            local Owner = Parent:GetAttribute("Owner")
            local TrapActive = Parent:GetAttribute("TrapActive")

            if Owner == LocalPlayer.Name then
                p4.Enabled = TrapActive ~= true
            else
                p4.Enabled = false
            end
        end

        local function trackPrompt(p5) -- line: 84
            -- upvalues: bindPromptConnections (copy), LocalPlayer (copy), t2 (copy)
            bindPromptConnections(p5)

            local Parent = p5.Parent

            if Parent and Parent:IsA("BasePart") then
                local Owner = Parent:GetAttribute("Owner")
                local TrapActive = Parent:GetAttribute("TrapActive")

                p5.Enabled = Owner == LocalPlayer.Name and TrapActive ~= true
            else
                p5.Enabled = false
            end

            p5.AncestryChanged:Connect(function(_, p7) -- line: 87
                -- upvalues: p5 (copy), bindPromptConnections (copy), LocalPlayer (copy), t2 (copy)
                if p7 then
                    bindPromptConnections(p5)

                    local Parent = p5.Parent

                    if Parent and Parent:IsA("BasePart") then
                        local Owner = Parent:GetAttribute("Owner")
                        local TrapActive = Parent:GetAttribute("TrapActive")

                        p5.Enabled = Owner == LocalPlayer.Name and TrapActive ~= true
                    else
                        p5.Enabled = false
                    end
                else
                    local v7 = t2[p5]

                    if v7 then
                        local Owner = v7.Owner

                        if Owner then
                            Owner:Disconnect()
                        end

                        local Active = v7.Active

                        if Active then
                            Active:Disconnect()
                        end

                        t2[p5] = nil
                    end
                end
            end)
            p5.Destroying:Connect(function() -- line: 96
                -- upvalues: p5 (copy), t2 (copy)
                local v8 = t2[p5]

                if not v8 then
                    return
                end

                local Owner = v8.Owner

                if Owner then
                    Owner:Disconnect()
                end

                local Active = v8.Active

                if Active then
                    Active:Disconnect()
                end

                t2[p5] = nil
            end)
        end

        local function onPromptAdded(p8) -- line: 99
            -- upvalues: trackPrompt (copy)
            if p8:IsA("ProximityPrompt") then
                trackPrompt(p8)
            end
        end

        local function onPromptRemoved(p9) -- line: 107
            -- upvalues: t2 (copy)
            if p9:IsA("ProximityPrompt") then
                local v9 = t2[p9]

                if v9 then
                    local Owner = v9.Owner

                    if Owner then
                        Owner:Disconnect()
                    end

                    local Active = v9.Active

                    if Active then
                        Active:Disconnect()
                    end

                    t2[p9] = nil
                end
            end
        end

        for _, v10 in ipairs(CollectionService:GetTagged(UNPLACE_PROMPT)) do
            if v10:IsA("ProximityPrompt") then
                trackPrompt(v10)
            end
        end

        CollectionService:GetInstanceAddedSignal(UNPLACE_PROMPT):Connect(onPromptAdded)
        CollectionService:GetInstanceRemovedSignal(UNPLACE_PROMPT):Connect(onPromptRemoved)
    end
}
