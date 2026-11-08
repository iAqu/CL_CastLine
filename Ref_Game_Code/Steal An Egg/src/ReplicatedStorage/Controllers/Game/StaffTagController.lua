-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Staff = require(ReplicatedStorage.Shared.Modules.Staff)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 26
        -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), Staff (copy), Trove (copy), LocalPlayer (copy)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local StaffTag = ReplicatedStorage.Assets.Billboards:WaitForChild("StaffTag")
        local t2 = {}
        local t3 = {}

        local function tagCharacter(p1, p2, p3) -- line: 33
            -- upvalues: PlayerGui (copy), StaffTag (copy), t3 (copy), Staff (copy)
            local v1 = p1:WaitForChild("Head", 10)
            local clone, Label, v2

            if v1 ~= nil then
                if not v1:IsA("BasePart") or p1.Parent == nil then
                    v2 = true
                else
                    clone = p3:Clone(StaffTag)
                    Label = clone:FindFirstChild("Label")

                    if Label == nil or not Label:IsA("TextLabel") then
                        error("Assets.Billboards.StaffTag is missing a TextLabel named Label")
                    end

                    v2 = false
                end
            else
                v2 = true
            end

            if v2 then
                return
            end

            Label.Text = Staff.OverheadLabel(p2)
            Label.TextColor3 = Color3.new(1, 1, 1)

            local v3 = Label:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

            v3.Name = "Sheen"
            v3.Color = Staff.GradientOf(p2)
            v3.Parent = Label
            t3[v3] = true
            p3:Add(function() -- line: 57
                -- upvalues: v3 (copy), t3 (copy)
                t3[v3] = nil
            end)
            clone.Name = ("StaffTag_%*"):format(p1.Name)
            clone.Adornee = v1
            clone.Enabled = true
            clone.Parent = PlayerGui
        end

        local function trackPlayer(p4) -- line: 67
            -- upvalues: t2 (copy), tagCharacter (copy), Staff (copy), Trove (copy)
            if t2[p4] then
                return
            end

            local v4 = Trove.new()
            local v5 = v4:Extend()

            t2[p4] = v4

            local function onCharacter(p5) -- line: 77
                -- upvalues: p4 (copy), v5 (copy), tagCharacter (copy), Staff (copy)
                v5:Clean()

                local CreatorDisguiseUserId = p4:GetAttribute("CreatorDisguiseUserId")
                local v6 = Staff.RoleOf(if typeof(CreatorDisguiseUserId) ~= "number" then p4.UserId else CreatorDisguiseUserId)

                if v6 ~= nil then
                    tagCharacter(p5, v6, v5)
                end
            end

            v4:Connect(p4.CharacterAdded, onCharacter)
            v4:Connect(p4:GetAttributeChangedSignal("CreatorDisguiseUserId"), function() -- line: 90
                -- upvalues: p4 (copy), onCharacter (copy)
                if p4.Character then
                    task.spawn(onCharacter, p4.Character)
                end
            end)
            v4:Connect(p4.CharacterRemoving, function() -- line: 95
                -- upvalues: v5 (copy)
                v5:Clean()
            end)

            if p4.Character then
                task.spawn(onCharacter, p4.Character)
            end
        end

        local function forgetPlayer(p6) -- line: 104
            -- upvalues: t2 (copy)
            local v7 = t2[p6]

            if v7 ~= nil then
                t2[p6] = nil
                v7:Destroy()
            end
        end

        local function sweep() -- line: 115
            -- upvalues: t3 (copy)
            if next(t3) == nil then
                return
            end

            local v8 = os.clock() % 2.4 / 2.4
            local v9 = Vector2.new(v8 * 2 - 1, 0)

            for v10 in t3 do
                v10.Offset = v9
            end
        end

        RunService.Heartbeat:Connect(sweep)

        for _, player in Players:GetPlayers() do
            trackPlayer(player)
        end

        Players.PlayerAdded:Connect(trackPlayer)
        Players.PlayerRemoving:Connect(forgetPlayer)
        Staff.Changed:Connect(function() -- line: 138
            -- upvalues: t2 (copy), trackPlayer (copy), Players (copy)
            for _, player in Players:GetPlayers() do
                local v11 = t2[player]

                if v11 ~= nil then
                    t2[player] = nil
                    v11:Destroy()
                end

                trackPlayer(player)
            end
        end)
    end
}
