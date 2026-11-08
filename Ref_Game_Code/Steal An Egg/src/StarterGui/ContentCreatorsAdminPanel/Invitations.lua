-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local UserInputService = game:GetService("UserInputService")
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)

local function focus(p1) -- line: 8
    -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy)
    if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
        GuiService.SelectedObject = p1
    end
end

local t1 = {}

local function avatar(p2) -- line: 14
    return (("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(p2))
end

function t1.new(p3, p4, p5, p6) -- line: 17
    -- upvalues: GuiService (copy), Players (copy), ReplicatedStorage (copy), SocialService (copy), UserInputService (copy), MenuNavigation (copy)
    local InvitePrompt = p3.InvitePrompt
    local Confirmation = p4.Confirmation
    local Request = ReplicatedStorage:WaitForChild("ContentCreatorRemotes"):WaitForChild("Request")

    local function resize() -- line: 22
        -- upvalues: p4 (copy)
        local v1 = p4.AbsoluteSize.Y < 340

        p4.Back.Position = UDim2.fromOffset(14, v1 and 4 or 12)
        p4.Title.Position = UDim2.fromOffset(118, v1 and 4 or 12)
        p4.Query.Position = UDim2.fromOffset(16, v1 and 52 or 68)
        p4.Find.Position = UDim2.new(1, -102, 0, v1 and 52 or 68)
        p4.AccountCard.Position = UDim2.fromOffset(16, v1 and 102 or 124)
        p4.AccountCard.Size = UDim2.new(1, -32, 0, v1 and 60 or 100)
        p4.AccountCard.Avatar.Position = UDim2.fromOffset(10, v1 and 8 or 12)
        p4.AccountCard.Avatar.Size = UDim2.fromOffset(v1 and 44 or 72, v1 and 44 or 72)
        p4.AccountCard.Account.Position = UDim2.fromOffset(v1 and 68 or 92, v1 and 2 or 10)
        p4.AccountCard.Status.Position = UDim2.fromOffset(v1 and 68 or 92, v1 and 30 or 66)
        p4.Send.Position = UDim2.new(0, 16, 1, v1 and -52 or -58)
        p4.AccountCard.UserId.Visible = not v1
        p4.Message.Visible = not v1
    end

    p4:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
    resize()

    local v2, Data, Preview, v3, SelectedObject
    local t2 = {}
    local v4 = false

    local function resultView(p7) -- line: 48
        -- upvalues: p4 (copy), p6 (copy), Confirmation (copy), Data (ref), Preview (ref), GuiService (copy), Players (copy), SocialService (copy), UserInputService (copy), MenuNavigation (copy)
        if not p7 then
            return
        end

        p4.Message.Text = p7.Message or ""

        if p7.Ok then
            local Data2 = p7.Data

            if Data2 then
                if Data2.NeedsWhitelist then
                    Preview = Data2.Preview

                    local v5 = Preview.Accounts[1]
                    local AccountCard, Send = p4.AccountCard, p4.Send

                    AccountCard.Visible = false
                    Send.Visible = false
                    Confirmation.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(v5.UserId)
                    Confirmation.Account.Text = "@" .. v5.Name
                    Confirmation.UserId.Text = "User ID: " .. v5.UserId
                    Confirmation.Message.Text = "Are you sure you want to whitelist " .. v5.Name .. "?"
                    Confirmation.Visible = true

                    local Cancel = Confirmation.Cancel

                    if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                        GuiService.SelectedObject = Cancel
                    end
                elseif Data2.Native then
                    p4.Send.Visible = false

                    local function v6() -- line: 76
                        -- upvalues: Data2 (copy), Players (copy), SocialService (copy)
                        return SocialService:CanSendGameInviteAsync(Players.LocalPlayer, Data2.UserId)
                    end

                    local ok, result = pcall(v6)

                    if not ok or not result then
                        p4.Message.Text = "Roblox cannot invite this account. They may need to be your friend or change their invite settings."
                        p6(p4.Message.Text, false)
                    else
                        local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

                        ExperienceInviteOptions.InviteUser = Data2.UserId
                        ExperienceInviteOptions.LaunchData = Data2.LaunchData
                        ExperienceInviteOptions.PromptMessage = "Join " .. Data2.ServerName

                        local function v7() -- line: 92
                            -- upvalues: ExperienceInviteOptions (copy), Players (copy), SocialService (copy)
                            SocialService:PromptGameInvite(Players.LocalPlayer, ExperienceInviteOptions)
                        end

                        local v8 = pcall(v7)

                        ExperienceInviteOptions:Destroy()

                        if not v8 then
                            p4.Message.Text = "Roblox could not open the invite prompt. Find the account and try again."
                            p6(p4.Message.Text, false)
                        end
                    end
                elseif Data2.Token then
                    Data = Data2
                    Confirmation.Visible = false
                    p4.AccountCard.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(Data2.UserId)
                    p4.AccountCard.Account.Text = "@" .. Data2.Name
                    p4.AccountCard.UserId.Text = "User ID: " .. Data2.UserId
                    p4.AccountCard.Status.Text = Data2.Online and "● Online in game" or "● Not in game"

                    local Status = p4.AccountCard.Status

                    if Data2.Online then
                        Status.TextColor3 = Color3.fromRGB(132, 255, 0)
                    else
                        Status.TextColor3 = Color3.fromRGB(190, 190, 204)
                    end

                    p4.Send.Text = Data2.Online and "Send invitation" or "Open Roblox invite"

                    local AccountCard, Send = p4.AccountCard, p4.Send

                    AccountCard.Visible = true
                    Send.Visible = true
                    p4.Message.Text = Data2.Online and "They can accept or decline without leaving their current server first." or "Roblox will ask you to confirm. The creator must be present or within their return period when this player joins."
                end
            else
                p4.Send.Visible = false
            end
        end
    end

    local function request(p8) -- line: 122
        -- upvalues: p4 (copy), p5 (copy), v4 (ref), resultView (copy)
        if v4 then
            return
        end

        v4 = true
        p4.Find.Text = "…"

        local function v9() -- line: 128
            -- upvalues: p8 (copy), p4 (copy), p5 (copy), resultView (copy)
            local v10 = p5("invitePlayers", p8)

            if v10 == nil then
                p4.Message.Text = "The panel was busy with another action. Press it again."
            end

            resultView(v10)
        end

        local ok, result = pcall(v9)

        v4 = false
        p4.Find.Text = "Find"

        if not ok then
            warn(result)
            p4.Message.Text = "Could not complete this invitation. Try again."
        end
    end

    p4.Find.Activated:Connect(function() -- line: 145
        -- upvalues: p4 (copy), Confirmation (copy), v2 (ref), Data (ref), Preview (ref), request (copy)
        local AccountCard, Send = p4.AccountCard, p4.Send

        AccountCard.Visible = false
        Send.Visible = false
        Confirmation.Visible = false
        Data = nil
        Preview = nil
        request({
            action = "find",
            server = v2,
            query = p4.Query.Text
        })
    end)
    p4.Send.Activated:Connect(function() -- line: 151
        -- upvalues: Data (ref), request (copy)
        if Data then
            request({
                action = "send",
                token = Data.Token
            })
        end
    end)
    Confirmation.Confirm.Activated:Connect(function() -- line: 156
        -- upvalues: Preview (ref), request (copy)
        if Preview then
            request({
                action = "confirm",
                token = Preview.Token
            })
        end
    end)

    local function cancelWhitelist() -- line: 161
        -- upvalues: Confirmation (copy), Preview (ref)
        Confirmation.Visible = false
        Preview = nil
    end

    Confirmation.Cancel.Activated:Connect(cancelWhitelist)

    local v11 = false

    local function promptNative(p9) -- line: 169
        -- upvalues: p6 (copy), v11 (ref), Players (copy), SocialService (copy)
        if v11 or type(p9) ~= "table" or #p9 == 0 then
            return
        end

        v11 = true

        local t3 = {}

        for v12, v13 in p9 do
            if #p9 > 1 then
                p6(("Roblox invite %* of %* · @%*"):format(v12, #p9, v13.Name), true)
            end

            local function v14() -- line: 182
                -- upvalues: v13 (copy), Players (copy), SocialService (copy)
                return SocialService:CanSendGameInviteAsync(Players.LocalPlayer, v13.UserId)
            end

            local ok, result = pcall(v14)

            if ok and result then
                local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")

                ExperienceInviteOptions.InviteUser = v13.UserId
                ExperienceInviteOptions.LaunchData = v13.LaunchData
                ExperienceInviteOptions.PromptMessage = "Join " .. v13.ServerName

                local v15 = false
                local connection = SocialService.GameInvitePromptClosed:Connect(function(p10) -- line: 198
                    -- upvalues: v15 (ref), Players (copy)
                    if p10 == Players.LocalPlayer then
                        v15 = true
                    end
                end)

                local function v16() -- line: 204
                    -- upvalues: ExperienceInviteOptions (copy), Players (copy), SocialService (copy)
                    SocialService:PromptGameInvite(Players.LocalPlayer, ExperienceInviteOptions)
                end

                local v17 = pcall(v16)

                ExperienceInviteOptions:Destroy()

                if v17 then
                    local v18 = os.clock() + 30

                    while not v15 and os.clock() < v18 do
                        task.wait(0.1)
                    end
                else
                    table.insert(t3, v13.Name)
                end

                connection:Disconnect()
                continue
            end

            table.insert(t3, v13.Name)
        end

        v11 = false

        if #t3 > 0 then
            p6(("Roblox would not invite %*. They may need to be your friend or change their invite settings."):format((table.concat(t3, ", "))), false)
        end
    end

    local function back() -- line: 226
        -- upvalues: p4 (copy), v4 (ref)
        if not v4 then
            p4.Visible = false
        end
    end

    p4.Back.Activated:Connect(back)

    local function showNext() -- line: 232
        -- upvalues: InvitePrompt (copy), v3 (ref), SelectedObject (ref), t2 (copy), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
        v3 = nil

        while #t2 > 0 do
            local v19 = table.remove(t2, 1)

            if v19.ExpiresAt > os.time() then
                v3 = v19
                break
            end
        end

        InvitePrompt.Visible = v3 ~= nil

        if v3 then
            InvitePrompt.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=420&h=420"):format(v3.InviterUserId)
            InvitePrompt.Account.Text = "@" .. v3.InviterName
            InvitePrompt.Server.Text = v3.ServerName
            InvitePrompt.Accept.Text = "Accept & join"
            InvitePrompt.Decline.Text = "Decline"

            local Decline = InvitePrompt.Decline

            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = Decline
            end
        elseif SelectedObject and SelectedObject.Parent then
            local SelectedObject2 = SelectedObject

            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = SelectedObject2
            end
        end
    end

    local v20 = false

    local function respond(p11) -- line: 254
        -- upvalues: p6 (copy), InvitePrompt (copy), Request (copy), v3 (ref), showNext (copy), v20 (ref)
        local ok, result

        if v3 and not v20 then
            v20 = true

            local Token = v3.Token

            InvitePrompt.Accept.Text = "Please wait…"

            local function v21() -- line: 261
                -- upvalues: p11 (copy), Token (copy), Request (copy)
                return Request:InvokeServer("respondInvite", {
                    token = Token,
                    accept = p11
                })
            end

            ok, result = pcall(v21)
            v20 = false

            if ok and result then
                p6(result.Message, result.Ok)
            else
                p6("Could not respond. Try again.", false)
            end

            if not ok or not result then
                InvitePrompt.Accept.Text = "Try again"
            else
                showNext()
            end
        end
    end

    InvitePrompt.Accept.Activated:Connect(function() -- line: 279
        -- upvalues: respond (copy)
        respond(true)
    end)
    InvitePrompt.Decline.Activated:Connect(function() -- line: 282
        -- upvalues: respond (copy)
        respond(false)
    end)
    task.spawn(function() -- line: 285
        -- upvalues: p3 (copy), InvitePrompt (copy), v3 (ref), showNext (copy), v20 (ref)
        while p3.Parent do
            if v3 and not v20 then
                local v22 = v3.ExpiresAt - os.time()

                if v22 <= 0 then
                    showNext()
                else
                    InvitePrompt.Message.Text = "Accept to join their server. Expires in " .. v22 .. "s."
                end
            end

            task.wait(1)
        end
    end)

    return {
        Back = back,
        CancelWhitelist = cancelWhitelist,
        Native = promptNative,
        Decline = function() -- Decline | line: 304
            -- upvalues: respond (copy)
            respond(false)
        end,
        Open = function(p12) -- Open | line: 305
            -- upvalues: p4 (copy), Confirmation (copy), v2 (ref), Data (ref), Preview (ref), v4 (ref)
            if v4 then
                return
            end

            v2 = p12
            Data = nil
            Preview = nil
            p4.Query.Text = ""

            local AccountCard, Send = p4.AccountCard, p4.Send

            AccountCard.Visible = false
            Send.Visible = false
            Confirmation.Visible = false
            p4.Message.Text = "Find someone by username or user ID."
            p4.Visible = true
        end,
        Receive = function(p13) -- Receive | line: 316
            -- upvalues: Request (copy), v3 (ref), SelectedObject (ref), t2 (copy), showNext (copy), GuiService (copy)
            local v23 = type(p13) == "table"
            local v24 = if v23 then type(p13.Token) == "string" else nil

            if v23 and v24 and (not v3 or v3.Token ~= p13.Token) then
                for _, v25 in t2 do
                    if v25.Token == p13.Token then
                        return
                    end
                end

                if #t2 >= 5 then
                    task.spawn(function() -- line: 329
                        -- upvalues: p13 (copy), Request (copy)
                        local function v26() -- line: 330
                            -- upvalues: p13 (copy), Request (copy)
                            Request:InvokeServer("respondInvite", {
                                accept = false,
                                token = p13.Token
                            })
                        end

                        pcall(v26)
                    end)
                else
                    table.insert(t2, p13)

                    if not v3 then
                        SelectedObject = GuiService.SelectedObject
                        showNext()
                    end
                end
            end
        end
    }
end

return t1
