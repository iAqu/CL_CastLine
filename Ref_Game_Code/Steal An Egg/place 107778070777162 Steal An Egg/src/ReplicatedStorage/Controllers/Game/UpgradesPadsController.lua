-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local Pads = require(ReplicatedStorage.Client.WorldFX.Pads)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)

return {
    Start = function() -- Start | line: 15
        -- upvalues: Workspace (copy), MonsterParasite (copy), Pads (copy), Tabs (copy), Trove (copy)
        local Pads2 = Workspace:WaitForChild("Stands"):WaitForChild("Pads")

        local function bindPad(p1, p2, p3) -- line: 20
            -- upvalues: Pads (copy), Tabs (copy)
            p1:Add(Pads.Track(p2, {
                Entered = function() -- Entered | line: 22
                    -- upvalues: p3 (copy), Tabs (copy)
                    Tabs.Activate(p3)
                end,
                Left = function() -- Left | line: 25
                    -- upvalues: p3 (copy), Tabs (copy)
                    if Tabs.Active() == p3 then
                        Tabs.Deactivate({
                            instant = true
                        })
                    end
                end
            }))
        end

        for _, child in Pads2:GetChildren() do
            if child:IsA("BasePart") and child.Name ~= MonsterParasite.PadName then
                bindPad(Trove.new(), child, child.Name)
            end
        end
    end
}
