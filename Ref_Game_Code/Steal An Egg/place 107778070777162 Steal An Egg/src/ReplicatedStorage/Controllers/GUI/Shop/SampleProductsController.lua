-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Client.Types.GUI)

return {
    Start = function() -- Start | line: 10
        -- upvalues: GUI (copy)
        local v1 = GUI.Shop()
        local Samples = v1.Frame.ScrollingFrame.Samples
        local Samples2 = v1.Frame.ButtonsHolder.Samples

        Samples.Visible = false
        Samples2.Visible = false
        Samples2.Active = false
        Samples2.Selectable = false
        Samples2.Interactable = false

        for _, descendant in Samples:GetDescendants() do
            if descendant:IsA("GuiButton") then
                descendant.Active = false
                descendant.Selectable = false
                descendant.Interactable = false
            end
        end
    end
}
