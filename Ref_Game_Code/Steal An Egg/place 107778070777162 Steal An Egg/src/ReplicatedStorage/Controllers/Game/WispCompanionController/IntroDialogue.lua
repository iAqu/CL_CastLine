-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Tabs = require(ReplicatedStorage.Client.Tabs)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Talk_UI = ReplicatedStorage.Assets.UI.Npcs.Talk_UI
local LocalPlayer = Players.LocalPlayer

return {
    new = function() -- new | line: 10
        -- upvalues: Tabs (copy), MessageTyper (copy), Talk_UI (copy), LocalPlayer (copy)
        local t2 = {}
        local t3

        local function display() -- line: 13
            -- upvalues: t3 (ref), Talk_UI (copy)
            local v1 = t3.Lines[t3.Index]
            local Size = Talk_UI.Size

            t3.Bubble.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * (#v1 > 45 and 2 or 1), Size.Y.Offset)

            local t4 = t3

            t4.NextAt = os.clock() + (utf8.len(v1) or #v1) * 0.06 + math.max(2.6, #v1 * 0.05)
            t3.Typer:Type(v1, t3.Label.TextColor3)
        end

        function t2.Close() -- line: 20
            -- upvalues: t3 (ref)
            local t5 = t3

            t3 = nil

            if not t5 then
                return
            end

            t5.Typer:Halt()
            t5.Bubble:Destroy()
            t5.Anchor:Destroy()
        end

        function t2.Start(p1, p2, p3) -- line: 28
            -- upvalues: t2 (copy), t3 (ref), display (copy), MessageTyper (copy), Talk_UI (copy), LocalPlayer (copy)
            t2.Close()

            local v4 = p1 and p1.PrimaryPart

            if not v4 or #p2 == 0 or not p1:IsDescendantOf(workspace) then
                return false
            end

            local BoundingBox, BoundingBox2 = p1:GetBoundingBox()
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "WispDialoguePoint"
            Attachment.Position = v4.CFrame:PointToObjectSpace(BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
            Attachment.Parent = v4

            local clone = Talk_UI:Clone()

            clone.Name = "WispDialogue"
            clone.Adornee = Attachment
            clone.MaxDistance = 45
            clone.Enabled = true
            clone.Parent = LocalPlayer.PlayerGui

            local TextLabel = clone.TextLabel

            TextLabel.Text = ""
            t3 = {
                Index = 1,
                NextAt = 0,
                Model = p1,
                Character = LocalPlayer.Character,
                Anchor = Attachment,
                Bubble = clone,
                Label = TextLabel,
                Typer = MessageTyper.new(TextLabel, nil, 0.06, false),
                Finished = p3,
                Lines = p2
            }
            display()

            return true
        end

        function t2.IsPlaying() -- line: 60
            -- upvalues: t3 (ref)
            return t3 ~= nil
        end

        function t2.Tick(p4) -- line: 63
            -- upvalues: t2 (copy), t3 (ref), display (copy), LocalPlayer (copy)
            if not t3 then
                return
            end

            local Character = LocalPlayer.Character
            local v6, v7

            if Character then
                v6 = Character:FindFirstChild("HumanoidRootPart")
                v7 = Character:FindFirstChildOfClass("Humanoid")
            else
                v7 = Character
                v6 = Character
            end

            if not p4
                or Character ~= t3.Character
                or not v6
                or not v7
                or v7.Health <= 0
                or not t3.Model:IsDescendantOf(workspace)
                or not t3.Anchor.Parent
                or (v6.Position - t3.Anchor.WorldPosition).Magnitude > 35 then
                t2.Close()

                return
            end

            if os.clock() >= t3.NextAt then
                if t3.Index < #t3.Lines then
                    t3.Index += 1
                    display()
                else
                    local Finished = t3.Finished

                    t2.Close()
                    Finished()
                end
            end
        end

        local connection = Tabs.Activated:Connect(t2.Close)

        function t2.Destroy() -- line: 86
            -- upvalues: t2 (copy), connection (copy)
            t2.Close()
            connection:Disconnect()
        end

        return t2
    end
}
