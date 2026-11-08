-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Tabs = require(ReplicatedStorage.Client.Tabs)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Talk_UI = ReplicatedStorage.Assets.UI.Npcs.Talk_UI
local LocalPlayer = Players.LocalPlayer

return {
    new = function() -- new | line: 12
        -- upvalues: Tabs (copy), MessageTyper (copy), Talk_UI (copy), LocalPlayer (copy)
        local t2 = {}
        local t3

        local function display() -- line: 15
            -- upvalues: t3 (ref), Talk_UI (copy)
            local v1 = t3.Lines[t3.Index]
            local Size = Talk_UI.Size

            t3.Bubble.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * (#v1 > 45 and 2 or 1), Size.Y.Offset)

            local t4 = t3

            t4.NextAt = os.clock() + (utf8.len(v1) or #v1) * 0.03 + math.max(1.3, #v1 * 0.025)
            t3.Typer:Type(v1, t3.Label.TextColor3)
        end

        function t2.Close(p1) -- line: 23
            -- upvalues: t3 (ref)
            local t5 = t3

            t3 = nil

            if not t5 then
                return
            end

            t5.Typer:Halt()
            t5.Bubble:Destroy()
            t5.Anchor:Destroy()

            if t5.Prompt.Parent then
                t5.Prompt.Enabled = t5.Enabled and p1 ~= false
            end
        end

        function t2.Start(p2, p3, p4) -- line: 36
            -- upvalues: t2 (copy), t3 (ref), display (copy), MessageTyper (copy), Talk_UI (copy), LocalPlayer (copy)
            t2.Close()

            local PrimaryPart = p2.PrimaryPart

            if not PrimaryPart then
                return
            end

            local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
            local Attachment = Instance.new("Attachment")

            Attachment.Name = "ScrambleDialoguePoint"
            Attachment.Position = PrimaryPart.CFrame:PointToObjectSpace(BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
            Attachment.Parent = PrimaryPart

            local clone = Talk_UI:Clone()

            clone.Name = "ScrambleDialogue"
            clone.Adornee = Attachment
            clone.MaxDistance = 45
            clone.Enabled = true
            clone.Parent = LocalPlayer.PlayerGui

            local TextLabel = clone.TextLabel

            TextLabel.Text = ""
            t3 = {
                Index = 1,
                NextAt = 0,
                Model = p2,
                Character = LocalPlayer.Character,
                Prompt = p3,
                Enabled = p3.Enabled,
                Anchor = Attachment,
                Bubble = clone,
                Label = TextLabel,
                Typer = MessageTyper.new(TextLabel, nil, 0.03, false),
                Finished = p4,
                Lines = { "SHHH! Don't tell him I'm here!", "I stole this when I escaped his lab...", "But it broke on the way out.", "I lost two of the parts... and his drones took the other three.", "Help me fix it and whatever's inside is yours." }
            }
            p3.Enabled = false
            display()
        end

        function t2.IsPlaying(p5) -- line: 78
            -- upvalues: t3 (ref)
            if t3 == nil then
                return false
            end

            if p5 == nil then
                return true
            end

            return t3.Model == p5
        end

        function t2.Tick(p6) -- line: 81
            -- upvalues: t2 (copy), t3 (ref), display (copy), LocalPlayer (copy)
            if not t3 then
                return
            end

            local Character = LocalPlayer.Character
            local v5, v6

            if Character then
                v5 = Character:FindFirstChild("HumanoidRootPart")
                v6 = Character:FindFirstChildOfClass("Humanoid")
            else
                v6 = Character
                v5 = Character
            end

            if not p6
                or Character ~= t3.Character
                or not v5
                or not v6
                or v6.Health <= 0
                or not t3.Model:IsDescendantOf(workspace)
                or not t3.Prompt.Parent
                or (v5.Position - t3.Anchor.WorldPosition).Magnitude > t3.Prompt.MaxActivationDistance + 8 then
                t2.Close(p6)

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

        local connection = Tabs.Activated:Connect(function() -- line: 112
            -- upvalues: t2 (copy)
            t2.Close()
        end)

        function t2.Destroy() -- line: 115
            -- upvalues: t2 (copy), connection (copy)
            t2.Close()
            connection:Disconnect()
        end

        return t2
    end
}
