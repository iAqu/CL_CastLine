-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

return {
    Start = function() -- Start | line: 18
        -- upvalues: GUI (copy), Remotes (copy)
        local v1 = GUI.RollbackReward()
        local Main = v1.Main
        local Close, Contents = Main.Close, Main.Contents
        local Ok, Title, Description, ImageHolder = Contents.Ok, Contents.Title, Contents.Description, Contents.ImageHolder
        local ImageLabel = ImageHolder.ImageLabel

        local function hideModal() -- line: 34
            -- upvalues: v1 (copy)
            v1.Enabled = false
        end

        local function showNotice(p1, p2, p3, p4) -- line: 36
            -- upvalues: v1 (copy), Title (copy), Description (copy), ImageHolder (copy), ImageLabel (copy)
            Title.Text = p1 or ""
            Description.Text = p2 or ""
            ImageLabel.Image = p3 or ""

            local UIGradient = ImageHolder:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                UIGradient:Destroy()
            end

            if p4 then
                p4:Clone().Parent = ImageHolder
            end

            v1.Enabled = true
        end

        v1.Enabled = false
        GUI.OnActivated(Close, function() -- line: 65
            -- upvalues: v1 (copy)
            v1.Enabled = false
        end)
        GUI.OnActivated(Ok, function() -- line: 66
            -- upvalues: v1 (copy)
            v1.Enabled = false
        end)
        Remotes.RollbackRewards.ShowNotice.OnClientEvent:Connect(function(p5, p6, p7, p8) -- line: 69
            -- upvalues: v1 (copy), Title (copy), Description (copy), ImageHolder (copy), ImageLabel (copy)
            local v2 = if typeof(p8) == "Instance" and p8:IsA("UIGradient") then p8 else nil

            Title.Text = p5 or ""
            Description.Text = p6 or ""
            ImageLabel.Image = p7 or ""

            local UIGradient = ImageHolder:FindFirstChildOfClass("UIGradient")

            if UIGradient then
                UIGradient:Destroy()
            end

            if v2 then
                v2:Clone().Parent = ImageHolder
            end

            v1.Enabled = true
        end)
    end
}
