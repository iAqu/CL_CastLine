-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local MenuNavigation = require(game:GetService("ReplicatedStorage").Client.MenuNavigation)

return {
    new = function(p1, p2, p3, p4) -- new | line: 6
        -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy)
        local function resize() -- line: 7
            -- upvalues: p1 (copy)
            local v1 = p1.AbsoluteSize.Y < 340

            p1.Back.Position = UDim2.fromOffset(14, v1 and 4 or 12)
            p1.Title.Position = UDim2.fromOffset(118, v1 and 4 or 12)
            p1.Query.Position = UDim2.fromOffset(16, v1 and 52 or 68)
            p1.Find.Position = UDim2.new(1, -102, 0, v1 and 52 or 68)
            p1.AccountCard.Position = UDim2.fromOffset(16, v1 and 102 or 124)
            p1.AccountCard.Size = UDim2.new(1, -32, 0, v1 and 60 or 100)
            p1.AccountCard.Avatar.Position = UDim2.fromOffset(10, v1 and 8 or 12)
            p1.AccountCard.Avatar.Size = UDim2.fromOffset(v1 and 44 or 72, v1 and 44 or 72)
            p1.AccountCard.Account.Position = UDim2.fromOffset(v1 and 68 or 92, v1 and 2 or 10)
            p1.AccountCard.Status.Position = UDim2.fromOffset(v1 and 68 or 92, v1 and 30 or 66)
            p1.Send.Position = UDim2.new(0, 16, 1, v1 and -52 or -58)
            p1.AccountCard.UserId.Visible = not v1
            p1.Message.Visible = not v1
        end

        p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
        resize()

        local Data, v2
        local v3 = false
        local n1 = 0

        local function focus(p5) -- line: 35
            -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy)
            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = p5
            end
        end

        local function back() -- line: 38
            -- upvalues: p1 (copy), p4 (copy), n1 (ref)
            p1.Visible = false
            n1 += 1
            p4()
        end

        local function sendLabel() -- line: 43
            -- upvalues: Data (ref)
            if Data then
                return "Disguise as @" .. Data.Name
            end

            return "Disguise"
        end

        local function request(p6) -- line: 46
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), p4 (copy), Data (ref), v2 (ref), v3 (ref), n1 (ref), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
            if v3 or p6 == "confirm" and not Data then
                return
            end

            v3 = true

            local v4 = n1
            local t2 = if p6 == "find" then {
                action = p6,
                query = p1.Query.Text,
                target = v2
            } else {
                action = p6,
                token = Data.Token,
                target = v2
            }

            if p6 == "find" then
                Data = nil

                local AccountCard, Send = p1.AccountCard, p1.Send

                AccountCard.Visible = false
                Send.Visible = false
            end

            local Find, Send = p1.Find, p1.Send

            Find.Text = "Finding..."
            Send.Text = "Please wait..."

            local ok, result = pcall(p2, "disguisePlayer", t2)

            v3 = false

            local Find2, Send2 = p1.Find, p1.Send
            local v5 = if Data then "Disguise as @" .. Data.Name else "Disguise"

            Find2.Text = "Find"
            Send2.Text = v5

            if v4 == n1 then
                if not ok or not result then
                    p3("Could not complete the lookup. Try again.", false)
                else
                    p1.Message.Text = result.Message or ""

                    local Data2 = result.Data

                    if p6 == "find" and result.Ok and Data2 then
                        Data = Data2
                        p1.AccountCard.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. Data2.UserId .. "&w=420&h=420"
                        p1.AccountCard.Account.Text = "@" .. Data2.Name
                        p1.AccountCard.UserId.Text = "User ID: " .. Data2.UserId
                        p1.AccountCard.Status.Text = Data2.DisplayName

                        local AccountCard, Send = p1.AccountCard, p1.Send

                        AccountCard.Visible = true
                        Send.Visible = true

                        local Send2 = p1.Send

                        if Data then
                            Send2.Text = "Disguise as @" .. Data.Name
                        else
                            Send2.Text = "Disguise"
                        end

                        local Send3 = p1.Send

                        if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                            GuiService.SelectedObject = Send3
                        end
                    elseif p6 == "confirm" and result.Ok then
                        Data = nil
                        p1.Visible = false
                        n1 += 1
                        p4()
                    end
                end
            end
        end

        p1.Find.Activated:Connect(function() -- line: 79
            -- upvalues: request (copy)
            request("find")
        end)
        p1.Query.FocusLost:Connect(function(p7) -- line: 80
            -- upvalues: request (copy)
            if p7 then
                request("find")
            end
        end)
        p1.Query:GetPropertyChangedSignal("Text"):Connect(function() -- line: 81
            -- upvalues: p1 (copy), Data (ref), n1 (ref)
            n1 += 1
            Data = nil

            local AccountCard, Send = p1.AccountCard, p1.Send

            AccountCard.Visible = false
            Send.Visible = false
        end)
        p1.Send.Activated:Connect(function() -- line: 86
            -- upvalues: request (copy)
            request("confirm")
        end)
        p1.Back.Activated:Connect(back)

        return {
            Back = back,
            Open = function(p8) -- Open | line: 90
                -- upvalues: p1 (copy), Data (ref), v2 (ref), v3 (ref), n1 (ref), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
                if v3 then
                    return
                end

                v2 = p8
                n1 += 1
                Data = nil
                p1.Query.Text = ""

                local AccountCard, Send = p1.AccountCard, p1.Send

                AccountCard.Visible = false
                Send.Visible = false
                p1.Message.Text = "Find a player by username or user ID."
                p1.Visible = true

                local Find = p1.Find

                if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                    GuiService.SelectedObject = Find
                end
            end
        }
    end
}
