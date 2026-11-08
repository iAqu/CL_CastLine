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

        local Data
        local v2 = false
        local n1 = 0

        local function focus(p5) -- line: 34
            -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy)
            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = p5
            end
        end

        local function request(p6) -- line: 37
            -- upvalues: p1 (copy), p2 (copy), p3 (copy), Data (ref), v2 (ref), n1 (ref), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
            if v2 or not (p6 ~= "follow" or Data and Data.CanFollow) then
                return
            end

            v2 = true

            local v3 = n1
            local t2 = if p6 == "find" then {
                action = p6,
                query = p1.Query.Text
            } else {
                action = p6,
                token = Data.Token
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

            local ok, result = pcall(p2, "followPlayer", t2)

            v2 = false

            local Find2, Send2 = p1.Find, p1.Send

            Find2.Text = "Find"
            Send2.Text = "Follow player"

            if v3 == n1 then
                if not ok or not result then
                    p3("Could not complete the lookup. Try again.", false)
                else
                    p1.Message.Text = result.Message or ""

                    local Data2 = result.Data

                    if result.Ok and Data2 then
                        Data = Data2
                        p1.AccountCard.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. Data2.UserId .. "&w=420&h=420"
                        p1.AccountCard.Account.Text = "@" .. Data2.Name
                        p1.AccountCard.UserId.Text = "User ID: " .. Data2.UserId

                        local Status = p1.AccountCard.Status

                        if Data2.Status == "Online" then
                            Status.Text = "Online in game"
                        elseif Data2.Status == "Here" then
                            Status.Text = "In your server"
                        elseif Data2.Status == "Offline" then
                            Status.Text = "Offline / not in game"
                        else
                            Status.Text = "Unavailable"
                        end

                        local Status2 = p1.AccountCard.Status

                        if Data2.Status == "Online" or Data2.Status == "Here" then
                            Status2.TextColor3 = Color3.fromRGB(132, 255, 0)
                        else
                            Status2.TextColor3 = Color3.fromRGB(190, 190, 204)
                        end

                        p1.AccountCard.Visible = true
                        p1.Send.Visible = Data2.CanFollow == true

                        local v4 = if Data2.CanFollow then p1.Send else p1.Find

                        if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                            GuiService.SelectedObject = v4
                        end
                    elseif p6 == "follow" then
                        Data = nil
                        p1.Send.Visible = false
                    end
                end
            end
        end

        p1.Find.Activated:Connect(function() -- line: 74
            -- upvalues: request (copy)
            request("find")
        end)
        p1.Query.FocusLost:Connect(function(p7) -- line: 75
            -- upvalues: request (copy)
            if p7 then
                request("find")
            end
        end)
        p1.Query:GetPropertyChangedSignal("Text"):Connect(function() -- line: 76
            -- upvalues: p1 (copy), Data (ref), n1 (ref)
            n1 += 1
            Data = nil

            local AccountCard, Send = p1.AccountCard, p1.Send

            AccountCard.Visible = false
            Send.Visible = false
        end)
        p1.Send.Activated:Connect(function() -- line: 81
            -- upvalues: request (copy)
            request("follow")
        end)

        local function back() -- line: 82
            -- upvalues: p1 (copy), p4 (copy), n1 (ref)
            p1.Visible = false
            n1 += 1
            p4()
        end

        p1.Back.Activated:Connect(back)

        return {
            Back = back,
            Open = function() -- Open | line: 90
                -- upvalues: p1 (copy), Data (ref), v2 (ref), n1 (ref), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
                if v2 then
                    return
                end

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
