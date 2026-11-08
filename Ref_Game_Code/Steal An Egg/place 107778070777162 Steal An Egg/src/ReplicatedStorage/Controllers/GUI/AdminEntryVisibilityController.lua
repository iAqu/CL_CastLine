-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AdminPanelEntry = require(ReplicatedStorage.Client.AdminPanelEntry)
local GUI = require(ReplicatedStorage.Client.GUI)

return {
    Start = function() -- Start | line: 20
        -- upvalues: AdminPanelEntry (copy), GUI (copy)
        local v1 = GUI.PlayerGui()

        local function bindAdminPanelEntry(p1) -- line: 28
            -- upvalues: AdminPanelEntry (copy)
            if p1.Name == "AdminPanel" then
                assert(p1:IsA("ScreenGui"), "PlayerGui.AdminPanel must be a ScreenGui")

                local Toggle = p1.Toggle

                assert(Toggle:IsA("TextButton"), "PlayerGui.AdminPanel.Toggle must be a TextButton")
                Toggle.Visible = AdminPanelEntry.CanShowPanel()
                AdminPanelEntry.Changed:Connect(function(p2) -- line: 36
                    -- upvalues: Toggle (copy)
                    if Toggle.Parent ~= nil then
                        Toggle.Visible = p2
                    end
                end)
            end
        end

        for _, child in v1:GetChildren() do
            bindAdminPanelEntry(child)
        end

        v1.ChildAdded:Connect(bindAdminPanelEntry)
    end
}
