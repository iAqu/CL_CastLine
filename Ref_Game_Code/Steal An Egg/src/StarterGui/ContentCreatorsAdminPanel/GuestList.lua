-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local MenuNavigation = require(game:GetService("ReplicatedStorage").Client.MenuNavigation)
local v1 = Color3.fromRGB(112, 255, 24)
local v2 = Color3.fromRGB(207, 208, 223)
local v3 = Color3.fromRGB(85, 85, 105)
local v4 = Color3.fromRGB(255, 50, 50)
local v5 = Color3.fromRGB(114, 114, 135)

local function focus(p1) -- line: 10
    -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy)
    if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
        GuiService.SelectedObject = p1
    end
end

local function avatar(p2, p3) -- line: 15
    return (("rbxthumb://type=AvatarHeadShot&id=%*&w=%*&h=%*"):format(p2, p3, p3))
end

local function lift(p4, p5) -- line: 18
    p4.ZIndex += p5

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("GuiObject") then
            descendant.ZIndex += p5
        end
    end
end

return {
    new = function(p6, p7, p8, p9, p10, p11) -- new | line: 27
        -- upvalues: GuiService (copy), UserInputService (copy), MenuNavigation (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), lift (copy)
        local v6, v7
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local v8 = "list"

        local function v9() -- line: 34
        end

        local function v10() -- line: 35
        end

        local function short() -- line: 37
            -- upvalues: p6 (copy)
            return p6.AbsoluteSize.Y < 350
        end

        local function server() -- line: 40
            -- upvalues: p10 (copy), v6 (ref)
            for _, v11 in p10().Servers do
                local Id = v11.Id

                if not Id then
                    Id = tostring(v11.OwnerUserId)
                end

                if Id == v6 then
                    return v11
                end
            end

            return nil
        end

        local function syncFooter() -- line: 48
            -- upvalues: p6 (copy), p10 (copy), t2 (copy), v8 (ref), server (copy), v1 (copy), v3 (copy)
            local n1 = 0

            for _ in t2 do
                n1 += 1
            end

            local v12 = v8 == "list"

            p6.RemoveSelected.Visible = v12 and n1 > 0
            p6.RemoveSelected.Text = ("Remove %*"):format(n1)

            local v13 = server()
            local v14 = v13 ~= nil and v13.Enabled == true
            local invitePlayers = p10().Commands.invitePlayers
            local Invite = p6.Invite

            if v12 then
                v12 = invitePlayers ~= nil and invitePlayers.Allowed == true
            end

            Invite.Visible = v12

            local v15 = v14 and n1 > 0

            p6.Invite.Active = v15

            local Invite2 = p6.Invite

            if v14 then
                if n1 == 0 then
                    Invite2.Text = "Select guests to invite"
                else
                    Invite2.Text = ("Invite %*"):format(n1)
                end
            else
                Invite2.Text = "Start your server to invite"
            end

            local Invite3 = p6.Invite

            if v15 then
                Invite3.BackgroundColor3 = v1
            else
                Invite3.BackgroundColor3 = v3
            end

            local v16 = p6.RemoveSelected.Visible and p6.Invite.Visible
            local Invite4 = p6.Invite

            if v16 then
                Invite4.Size = UDim2.new(0.5, -20, 0, 44)
            else
                Invite4.Size = UDim2.new(1, -32, 0, 44)
            end

            local RemoveSelected = p6.RemoveSelected

            if v16 then
                RemoveSelected.Position = UDim2.new(0.5, 4, 1, -58)
            else
                RemoveSelected.Position = UDim2.new(0, 16, 1, -58)
            end

            local RemoveSelected2 = p6.RemoveSelected

            if v16 then
                RemoveSelected2.Size = UDim2.new(0.5, -20, 0, 44)
            else
                RemoveSelected2.Size = UDim2.new(1, -32, 0, 44)
            end
        end

        local function show(p12) -- line: 78
            -- upvalues: p6 (copy), v8 (ref), server (copy), syncFooter (copy)
            v8 = p12
            p6.AddForm.Visible = p12 == "add"
            p6.Confirmation.Visible = p12 == "confirm"
            p6.Add.Visible = p12 == "list"
            p6.Search.Visible = p12 == "list"
            p6.Options.Visible = p12 == "list"
            p6.Empty.Visible = false

            local v17 = server()
            local v18 = v17 and v17.Name:match("^CC_(.+)_%d+$") or "creator"
            local Title = p6.Title

            if p12 == "add" then
                Title.Text = "Add guests"
            else
                Title.Text = "Guests · " .. v18
            end

            syncFooter()
        end

        local function tile(p13, p14, p15) -- line: 91
            -- upvalues: p6 (copy), p7 (copy), lift (copy)
            local clone = p7.PlayerTile:Clone()

            clone.Title.Text = p13.Name
            clone.Subtitle.Text = "ID: " .. p13.UserId
            clone.Image.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=%*&h=%*"):format(p13.UserId, 420, 420)
            clone.SelectionBadge.Visible = false

            if p6.AbsoluteSize.Y < 350 then
                clone.Image.Size = UDim2.fromOffset(40, 40)
                clone.Image.Position = UDim2.new(0.5, -20, 0, 4)
                clone.Title.Position = UDim2.new(0, 6, 0, 46)
                clone.Subtitle.Position = UDim2.new(0, 6, 0, 70)
            end

            lift(clone, p15)
            clone.Visible = true
            clone.LayoutOrder = p14

            return clone
        end

        local function grid(p16) -- line: 108
            -- upvalues: p6 (copy)
            local v21 = math.max(1, (math.floor((p16.AbsoluteSize.X - 14) / 130)))

            p16.Layout.CellSize = UDim2.new(1 / v21, -((v21 - 1) * 10 + 14) / v21, 0, p6.AbsoluteSize.Y < 350 and 96 or 124)
            p16.Layout.CellPadding = UDim2.fromOffset(10, 10)
        end

        local function clear(p17) -- line: 118
            for _, child in p17:GetChildren() do
                if child:IsA("GuiObject") then
                    child:Destroy()
                end
            end
        end

        local function showPreview(p18) -- line: 125
            -- upvalues: p6 (copy), v7 (ref), v8 (ref), server (copy), syncFooter (copy), tile (copy), grid (copy), clear (copy), GuiService (copy), UserInputService (copy), MenuNavigation (copy), v1 (copy), v4 (copy)
            v7 = p18

            local Confirmation = p6.Confirmation

            clear(Confirmation.Accounts)
            grid(Confirmation.Accounts)

            for v22, v23 in p18.Accounts do
                local v24 = tile(v23, v22, 26)

                v24.Name = "Account" .. v23.UserId
                v24.Selectable = false
                v24.AutoButtonColor = false
                v24.Parent = Confirmation.Accounts
            end

            local v25 = if p18.Skipped then #p18.Skipped else 0

            Confirmation.Message.Text = (if p18.Remove then ("Remove %* guest(s) from %*?"):format(#p18.Accounts, p18.Server) else ("Add %* guest(s) to %*?"):format(#p18.Accounts, p18.Server)) .. (if v25 > 0 then (" %* skipped."):format(v25) else "")
            Confirmation.Confirm.Text = p18.Remove and "Remove guests" or "Add guests"

            local Confirm = Confirmation.Confirm

            if p18.Remove then
                Confirm.BackgroundColor3 = v4
            else
                Confirm.BackgroundColor3 = v1
            end

            v8 = "confirm"
            p6.AddForm.Visible = false
            p6.Confirmation.Visible = true
            p6.Add.Visible = false
            p6.Search.Visible = false
            p6.Options.Visible = false
            p6.Empty.Visible = false

            local v26 = server()
            local v27 = v26 and v26.Name:match("^CC_(.+)_%d+$") or "creator"

            p6.Title.Text = "Guests · " .. v27
            syncFooter()

            local Cancel = Confirmation.Cancel

            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = Cancel
            end
        end

        local function render() -- line: 148
            -- upvalues: p6 (copy), t2 (copy), server (copy), syncFooter (copy), tile (copy), grid (copy), clear (copy), v4 (copy), v5 (copy)
            if p6.Visible then
                local v28 = server()

                if not v28 then
                    p6.Visible = false

                    return
                end

                clear(p6.Options)

                local t5 = {}

                for _, v29 in v28.Guests or {} do
                    t5[tostring(v29.UserId)] = true
                end

                for v30 in t2 do
                    if not t5[v30] then
                        t2[v30] = nil
                    end
                end

                local v31 = string.lower(p6.Search.Text)

                grid(p6.Options)

                local n2 = 0

                for _, v32 in v28.Guests or {} do
                    if string.find(string.lower(v32.Name .. " " .. v32.UserId), v31, 1, true) then
                        n2 += 1

                        local v33 = tostring(v32.UserId)
                        local v34 = tile(v32, n2, 20)

                        v34.Name = "Guest" .. v32.UserId

                        local function paint() -- line: 179
                            -- upvalues: v33 (copy), v34 (copy), t2 (copy), v4 (copy), v5 (copy)
                            local v35 = t2[v33] ~= nil

                            v34.SelectionBadge.Visible = v35

                            local Stroke = v34.Stroke

                            if v35 then
                                Stroke.Color = v4
                            else
                                Stroke.Color = v5
                            end
                        end

                        local v36 = t2[v33] ~= nil

                        v34.SelectionBadge.Visible = v36

                        local Stroke = v34.Stroke

                        if v36 then
                            Stroke.Color = v4
                        else
                            Stroke.Color = v5
                        end

                        v34.Parent = p6.Options
                        v34.Activated:Connect(function() -- line: 186
                            -- upvalues: v32 (copy), v33 (copy), v34 (copy), t2 (copy), syncFooter (copy), v4 (copy), v5 (copy)
                            t2[v33] = if t2[v33] then nil else v32.Name

                            local v37 = t2[v33] ~= nil

                            v34.SelectionBadge.Visible = v37

                            local Stroke = v34.Stroke

                            if v37 then
                                Stroke.Color = v4
                            else
                                Stroke.Color = v5
                            end

                            syncFooter()
                        end)
                    end
                end

                local Empty = p6.Empty

                if n2 == 0 then
                    Empty.Visible = p6.Options.Visible
                else
                    Empty.Visible = false
                end

                p6.Empty.Text = v31 == "" and "No guests yet. The creator always has access." or "No guests match that search."
                syncFooter()
            end
        end

        local v38

        v38 = function() -- line: 198
            -- upvalues: v38 (ref), p6 (copy), p7 (copy), t3 (copy), t4 (copy), v10 (ref), clear (copy), v1 (copy), v2 (copy), v3 (copy), lift (copy)
            local Entries = p6.AddForm.Entries

            clear(Entries)

            for v39, v40 in t3 do
                local clone = p7.EntryRow:Clone()

                clone.Name = "Entry" .. v39
                clone.LayoutOrder = v39
                clone.Input.Text = v40

                local v41 = t4[v40:match("^%s*(.-)%s*$")]

                if v41 then
                    if v41.UserId then
                        clone.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=%*&h=%*"):format(v41.UserId, 150, 150)
                        clone.Status.Text = ("@%* · %*"):format(v41.Name, v41.UserId)
                        clone.Status.TextColor3 = v1
                    else
                        clone.Avatar.Image = ""
                        clone.Status.Text = "No account with that name or ID"
                        clone.Status.TextColor3 = Color3.fromRGB(255, 153, 116)
                    end
                else
                    clone.Avatar.Image = ""
                    clone.Status.Text = "Checking…"
                    clone.Status.TextColor3 = v2
                end

                lift(clone, 20)
                clone.Visible = true
                clone.Parent = Entries
                clone.Input:GetPropertyChangedSignal("Text"):Connect(function() -- line: 223
                    -- upvalues: clone (copy), v39 (copy), t3 (copy)
                    t3[v39] = clone.Input.Text
                end)
                clone.Input.FocusLost:Connect(function() -- line: 227
                    -- upvalues: v38 (ref), v10 (ref)
                    task.defer(function() -- line: 228
                        -- upvalues: v38 (ref), v10 (ref)
                        v38()
                        v10()
                    end)
                end)
                clone.Discard.Activated:Connect(function() -- line: 233
                    -- upvalues: v39 (copy), v38 (ref), t3 (copy)
                    table.remove(t3, v39)
                    v38()
                end)
            end

            local Lookup = p6.AddForm.Lookup

            if #t3 == 0 then
                Lookup.Text = "Add guests"
            else
                Lookup.Text = `Add {#t3} guest(s)`
            end

            p6.AddForm.Lookup.Active = #t3 > 0

            local Lookup2 = p6.AddForm.Lookup

            if #t3 == 0 then
                Lookup2.BackgroundColor3 = v3
            else
                Lookup2.BackgroundColor3 = v1
            end
        end

        v10 = function() -- line: 244
            -- upvalues: v38 (ref), p8 (copy), v6 (ref), t3 (copy), t4 (copy)
            local t6 = {}
            local t7 = {}

            for _, v42 in t3 do
                local v43 = v42:match("^%s*(.-)%s*$")

                if #v43 > 0 and t4[v43] == nil and not t7[v43] and #t6 < 20 then
                    t7[v43] = true
                    table.insert(t6, v43)
                end
            end

            if #t6 ~= 0 then
                local v44 = p8("manageWhitelist", {
                    action = "resolve",
                    server = v6,
                    queries = t6
                })

                if v44 and v44.Ok and v44.Data then
                    for _, v45 in v44.Data.Accounts do
                        t4[v45.Query] = v45
                    end

                    v38()
                end
            end
        end

        local function queue(p19) -- line: 266
            -- upvalues: v38 (ref), p6 (copy), p9 (copy), t3 (copy), v10 (ref), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
            for match in string.gmatch(p19, "[^%s,]+") do
                if #t3 >= 20 then
                    p9("You can prepare 20 accounts at a time.", false)
                    break
                end

                table.insert(t3, match)
            end

            p6.AddForm.Query.Text = ""
            v38()

            local Query = p6.AddForm.Query

            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = Query
            end

            v10()
        end

        local function resize() -- line: 279
            -- upvalues: p6 (copy)
            local v46 = p6.AbsoluteSize.Y < 350

            p6.Search.Position = UDim2.fromOffset(16, v46 and 62 or 68)
            p6.Options.Position = UDim2.fromOffset(12, v46 and 114 or 122)
            p6.Options.Size = UDim2.new(1, -24, 1, v46 and -184 or -196)
            p6.Confirmation.Message.Position = UDim2.fromOffset(18, v46 and 44 or 52)
            p6.Confirmation.Message.Size = UDim2.new(1, -36, 0, v46 and 36 or 42)
            p6.Confirmation.Accounts.Position = UDim2.fromOffset(12, v46 and 84 or 98)
            p6.Confirmation.Accounts.Size = UDim2.new(1, -24, 1, v46 and -148 or -162)
        end

        local function back() -- line: 289
            -- upvalues: p6 (copy), v8 (ref), server (copy), syncFooter (copy), render (copy)
            if not p6.AddForm.Visible then
                p6.Visible = false

                return
            end

            v8 = "list"
            p6.AddForm.Visible = false
            p6.Confirmation.Visible = false
            p6.Add.Visible = true
            p6.Search.Visible = true
            p6.Options.Visible = true
            p6.Empty.Visible = false

            local v47 = server()
            local v48 = v47 and v47.Name:match("^CC_(.+)_%d+$") or "creator"

            p6.Title.Text = "Guests · " .. v48
            syncFooter()
            render()
        end

        local function cancel() -- line: 297
            -- upvalues: v38 (ref), p6 (copy), v7 (ref), t3 (copy), v8 (ref), server (copy), syncFooter (copy), render (copy)
            local v49 = v7 ~= nil and v7.Remove ~= true

            v7 = nil

            if v49 and #t3 > 0 then
                v8 = "add"
                p6.AddForm.Visible = true
                p6.Confirmation.Visible = false
                p6.Add.Visible = false
                p6.Search.Visible = false
                p6.Options.Visible = false
                p6.Empty.Visible = false

                local v50 = server()

                if v50 then
                    v50.Name:match("^CC_(.+)_%d+$")
                end

                p6.Title.Text = "Add guests"
                syncFooter()
                v38()
            else
                v8 = "list"
                p6.AddForm.Visible = false
                p6.Confirmation.Visible = false
                p6.Add.Visible = true
                p6.Search.Visible = true
                p6.Options.Visible = true
                p6.Empty.Visible = false

                local v51 = server()
                local v52 = v51 and v51.Name:match("^CC_(.+)_%d+$") or "creator"

                p6.Title.Text = "Guests · " .. v52
                syncFooter()
                render()
            end
        end

        p6:GetPropertyChangedSignal("AbsoluteSize"):Connect(resize)
        resize()
        p6.Add.Activated:Connect(function() -- line: 311
            -- upvalues: v38 (ref), p6 (copy), v8 (ref), server (copy), syncFooter (copy), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
            v8 = "add"
            p6.AddForm.Visible = true
            p6.Confirmation.Visible = false
            p6.Add.Visible = false
            p6.Search.Visible = false
            p6.Options.Visible = false
            p6.Empty.Visible = false

            local v53 = server()

            if not (v53 and v53.Name:match("^CC_(.+)_%d+$")) then
            end

            p6.Title.Text = "Add guests"
            syncFooter()
            p6.AddForm.Query.Text = ""
            v38()

            local Query = p6.AddForm.Query

            if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                GuiService.SelectedObject = Query
            end
        end)
        p6.AddForm.Queue.Activated:Connect(function() -- line: 317
            -- upvalues: p6 (copy), queue (copy)
            queue(p6.AddForm.Query.Text)
        end)
        p6.AddForm.Query.FocusLost:Connect(function(p20) -- line: 320
            -- upvalues: p6 (copy), queue (copy)
            if p20 then
                queue(p6.AddForm.Query.Text)
            end
        end)
        p6.RemoveSelected.Activated:Connect(function() -- line: 325
            -- upvalues: p8 (copy), p9 (copy), v6 (ref), t2 (copy), showPreview (copy)
            local t8 = {}

            for v54 in t2 do
                table.insert(t8, v54)
            end

            if #t8 ~= 0 then
                if #t8 > 20 then
                    p9("Remove up to 20 guests at a time.", false)
                else
                    local v55 = p8("manageWhitelist", {
                        action = "remove",
                        server = v6,
                        queries = t8
                    })

                    if v55 and v55.Ok and v55.Data then
                        showPreview(v55.Data)
                    end
                end
            end
        end)
        p6.Back.Activated:Connect(back)
        p6.Search:GetPropertyChangedSignal("Text"):Connect(render)
        p6.Options:GetPropertyChangedSignal("AbsoluteSize"):Connect(render)
        p6.AddForm.Lookup.Activated:Connect(function() -- line: 345
            -- upvalues: p8 (copy), p9 (copy), v6 (ref), t3 (copy), showPreview (copy)
            local t9 = {}

            for _, v56 in t3 do
                local v57 = v56:match("^%s*(.-)%s*$")

                if #v57 > 0 then
                    table.insert(t9, v57)
                end
            end

            if #t9 == 0 then
                p9("Add at least one username or user ID.", false)
            else
                local v58 = p8("manageWhitelist", {
                    action = "lookup",
                    server = v6,
                    queries = t9
                })

                if v58 and v58.Ok and v58.Data then
                    showPreview(v58.Data)
                end
            end
        end)
        p6.Confirmation.Cancel.Activated:Connect(cancel)
        p6.Confirmation.Confirm.Activated:Connect(function() -- line: 363
            -- upvalues: p6 (copy), p8 (copy), v7 (ref), t2 (copy), t3 (copy), v8 (ref), server (copy), syncFooter (copy), render (copy)
            if not v7 then
                return
            end

            local v59 = p8("manageWhitelist", {
                action = "confirm",
                token = v7.Token
            })

            if v59 and v59.Ok then
                v7 = nil
                table.clear(t2)
                table.clear(t3)
                v8 = "list"
                p6.AddForm.Visible = false
                p6.Confirmation.Visible = false
                p6.Add.Visible = true
                p6.Search.Visible = true
                p6.Options.Visible = true
                p6.Empty.Visible = false

                local v60 = server()
                local v61 = v60 and v60.Name:match("^CC_(.+)_%d+$") or "creator"

                p6.Title.Text = "Guests · " .. v61
                syncFooter()
                render()
            end
        end)
        p6.Invite.Activated:Connect(function() -- line: 376
            -- upvalues: p8 (copy), p9 (copy), p11 (copy), v6 (ref), t2 (copy), server (copy), render (copy)
            local v62 = server()

            if not (v62 and v62.Enabled) then
                p9("Start your server before inviting players.", false)
            else
                local t10 = {}

                for v63 in t2 do
                    table.insert(t10, v63)
                end

                if #t10 == 0 then
                    p9("Pick the guests you want to invite.", false)
                elseif #t10 > 20 then
                    p9("Invite up to 20 guests at a time.", false)
                else
                    local v64 = p8("invitePlayers", {
                        action = "guests",
                        server = v6,
                        targets = t10
                    })

                    if v64 and v64.Ok then
                        table.clear(t2)
                        render()

                        if v64.Data and v64.Data.Native then
                            p11(v64.Data.Native)
                        end
                    end
                end
            end
        end)

        return {
            Back = back,
            Cancel = cancel,
            Refresh = function() -- Refresh | line: 408
                -- upvalues: p6 (copy), syncFooter (copy), render (copy)
                if p6.Visible and p6.Options.Visible then
                    render()
                end

                syncFooter()
            end,
            Open = function(p21) -- Open | line: 414
                -- upvalues: p6 (copy), p8 (copy), v6 (ref), t2 (copy), t3 (copy), t4 (copy), v8 (ref), server (copy), syncFooter (copy), render (copy), GuiService (copy), UserInputService (copy), MenuNavigation (copy)
                v6 = p21

                local v65 = p8("manageWhitelist", {
                    action = "list",
                    server = p21
                })

                if not (v65 and v65.Ok) then
                    return
                end

                p6.Visible = true
                p6.Search.Text = ""
                table.clear(t2)
                table.clear(t3)
                table.clear(t4)
                v8 = "list"
                p6.AddForm.Visible = false
                p6.Confirmation.Visible = false
                p6.Add.Visible = true
                p6.Search.Visible = true
                p6.Options.Visible = true
                p6.Empty.Visible = false

                local v66 = server()
                local v67 = v66 and v66.Name:match("^CC_(.+)_%d+$") or "creator"

                p6.Title.Text = "Guests · " .. v67
                syncFooter()
                render()

                local Add = p6.Add

                if UserInputService.GamepadEnabled and not MenuNavigation.IsCursorActive() then
                    GuiService.SelectedObject = Add
                end
            end
        }
    end
}
