-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local Assets = require(ReplicatedStorage.Data.Assets)
local GUI = require(ReplicatedStorage.Client.GUI)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)

return {
    Resolve = function(p1, p2) -- Resolve | line: 16
        -- upvalues: Players (copy), AssetRoster (copy), Assets (copy), GUI (copy), Simple (copy)
        local ApplyStarPopupConfirmationScreen = GUI.Get("ApplyStarPopupConfirmationScreen")
        local Frame = ApplyStarPopupConfirmationScreen:FindFirstChild("Frame")

        assert(Frame and Frame:IsA("GuiObject"), "Star confirmation needs Frame")

        local Content = Frame.Content
        local Template = Content.PetSlot.Template

        assert(Content.Yes:IsA("GuiButton") and Content.No:IsA("GuiButton"), "Star confirmation needs Yes/No")

        local v4 = assert(Assets.Directory[p2], "Unknown pet category")
        local v5 = v4.DisplayName or p2

        if v5 == p2 then
            v5 = v5:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2"):gsub("_", " ")
        end

        Template.Amount.RichText = false
        Template.Amount.Text = v5
        Template.Amount.TextWrapped = true
        Template.Icon.Image = v4.Icon or ""

        local v6 = AssetRoster.ReadOwnerPen(Players.LocalPlayer.UserId)[p1]
        local v7 = v6 and v6.MoneyPerSecond

        Template.Cash.Visible = typeof(v7) == "number"

        local Cash = Template.Cash

        if typeof(v7) == "number" then
            Cash.Text = ("$%*/s"):format((Simple.FormatCompact(v7)))
        else
            Cash.Text = ""
        end

        Frame.Header.Title.Text = "Apply Star?"

        if not Frame:FindFirstChild("Pop") then
            local UIScale = Instance.new("UIScale")

            UIScale.Name = "Pop"
            UIScale.Parent = Frame
        end

        return ApplyStarPopupConfirmationScreen, Frame
    end,
    Bind = function(p3, p4, p5, p6) -- Bind | line: 47
        -- upvalues: RunService (copy), MenuNavigation (copy)
        local t2 = {}

        for _, v8 in p4:QueryDescendants("ImageLabel[$Cells][$FPS]") do
            local Cells = v8:GetAttribute("Cells")
            local FPS = v8:GetAttribute("FPS")

            if typeof(Cells) == "Vector2" and Cells.X >= 1 and Cells.Y >= 1 and typeof(FPS) == "number" and FPS > 0 then
                v8.ImageRectOffset = Vector2.zero
                table.insert(t2, {
                    Frame = 0,
                    Image = v8,
                    Cells = Cells,
                    FPS = FPS
                })
            end
        end

        local n1 = 0

        p5:Connect(RunService.Heartbeat, function(p7) -- line: 59
            -- upvalues: p3 (copy), p4 (copy), t2 (copy), n1 (ref)
            if not p3.Enabled or not p4.Visible then
                return
            end

            n1 += p7

            for _, v9 in t2 do
                local v11 = n1
                local v12 = math.floor(v11 * v9.FPS) % (v9.Cells.X * v9.Cells.Y)

                if v12 ~= v9.Frame then
                    v9.Frame = v12

                    local ImageRectSize = v9.Image.ImageRectSize

                    v9.Image.ImageRectOffset = Vector2.new(v12 % v9.Cells.X * ImageRectSize.X, math.floor(v12 / v9.Cells.X) * ImageRectSize.Y)
                end
            end
        end)
        p5:Add(function() -- line: 71
            -- upvalues: t2 (copy), MenuNavigation (copy)
            for _, v15 in t2 do
                v15.Image.ImageRectOffset = Vector2.zero
            end

            MenuNavigation.SetOverride("MountStarConfirmation", nil)
        end)
        MenuNavigation.SetOverride("MountStarConfirmation", p4, p4.Content.No, p6, 100, true)
        p5:Connect(p3:GetPropertyChangedSignal("Enabled"), function() -- line: 76
            -- upvalues: p3 (copy), p6 (copy)
            if not p3.Enabled then
                p6()
            end
        end)
    end
}
