-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local t1 = {
    Notice = true,
    Warn = true,
    Confirm = true
}
local t2 = {
    Confirm = "Prompt",
    Notice = "Notice",
    Warn = "Failure"
}

local function child(p1, p2) -- line: 55
    local v1 = p1:FindFirstChild(p2)

    assert(v1, (("%* is missing %*"):format(p1:GetFullName(), p2)))

    return v1
end

local v3 = GUI.Message()
local Frame = v3:FindFirstChild("Frame")

assert(Frame, (("%* is missing Frame"):format((v3:GetFullName()))))

local Contents = Frame:FindFirstChild("Contents")

assert(Contents, (("%* is missing Contents"):format((Frame:GetFullName()))))

local t3 = {}
local Accept = Contents:FindFirstChild("Accept")

assert(Accept, (("%* is missing Accept"):format((Contents:GetFullName()))))
t3.accept = Accept

local Acknowledge = Contents:FindFirstChild("Acknowledge")

assert(Acknowledge, (("%* is missing Acknowledge"):format((Contents:GetFullName()))))
t3.acknowledge = Acknowledge

local Decline = Contents:FindFirstChild("Decline")

assert(Decline, (("%* is missing Decline"):format((Contents:GetFullName()))))
t3.decline = Decline

local Close = Frame:FindFirstChild("Close")

assert(Close, (("%* is missing Close"):format((Frame:GetFullName()))))
t3.dismiss = Close

local t4 = {}
local Top = Frame:FindFirstChild("Top")

assert(Top, (("%* is missing Top"):format((Frame:GetFullName()))))

local Title = Top:FindFirstChild("Title")

assert(Title, (("%* is missing Title"):format((Top:GetFullName()))))
t4.heading = Title

local IllustratedBody = Contents:FindFirstChild("IllustratedBody")

assert(IllustratedBody, (("%* is missing IllustratedBody"):format((Contents:GetFullName()))))
t4.illustrated = IllustratedBody

local Body = Contents:FindFirstChild("Body")

assert(Body, (("%* is missing Body"):format((Contents:GetFullName()))))
t4.plain = Body

local Artwork = Contents:FindFirstChild("Artwork")

assert(Artwork, (("%* is missing Artwork"):format((Contents:GetFullName()))))

local t5 = {}
local t6 = {}
local v15
local v16 = false

local function present(p3) -- line: 88
    -- upvalues: t3 (copy), t4 (copy), Artwork (copy)
    local v17 = p3.kind == "Confirm"
    local v18 = p3.image ~= nil

    t3.accept.Visible = v17
    t3.decline.Visible = v17
    t3.acknowledge.Visible = not v17
    t3.dismiss.Visible = true
    Artwork.Image = p3.image or ""
    Artwork.Visible = v18
    t4.illustrated.Visible = v18
    t4.plain.Visible = not v18
    t4.illustrated.Text = p3.body
    t4.plain.Text = p3.body

    local heading = t4.heading

    if p3.kind == "Warn" then
        heading.Text = "Uh-oh!"
    else
        heading.Text = p3.heading or "Heads up!"
    end
end

local function releaseActivation(p4) -- line: 109
    if typeof(p4) ~= "table" then
        return
    end

    for _, v19 in p4 do
        if typeof(v19) == "RBXScriptConnection" then
            v19:Disconnect()
        end
    end

    if typeof(p4.Disconnect) == "function" then
        p4:Disconnect()
    end
end

local function resumeIfWaiting(p5, ...) -- line: 123
    if coroutine.status(p5) == "suspended" then
        task.spawn(p5, ...)
    end
end

local function awaitVerdict(p6) -- line: 129
    -- upvalues: GUI (copy), v3 (copy), t3 (copy), releaseActivation (copy), resumeIfWaiting (copy)
    local thread = coroutine.running()
    local v20 = false
    local v21
    local t7 = {}
    local t8 = {}

    local function settle(p7) -- line: 136
        -- upvalues: thread (copy), v20 (ref), v21 (ref), t7 (copy), t8 (copy), releaseActivation (copy), resumeIfWaiting (copy)
        if v20 then
            return
        end

        v20 = true
        v21 = p7

        for _, v22 in t7 do
            releaseActivation(v22)
        end

        for _, v23 in t8 do
            v23:Disconnect()
        end

        resumeIfWaiting(thread)
    end

    local function bind(p8, p9) -- line: 151
        -- upvalues: t7 (copy), settle (copy), GUI (copy)
        table.insert(t7, GUI.OnActivated(p8, function() -- line: 152
            -- upvalues: p9 (copy), settle (copy)
            settle(p9)
        end))
    end

    local v25 = not p6 and nil
    local accept = t3.accept
    local OnActivated = GUI.OnActivated
    local v26 = true

    table.insert(t7, OnActivated(accept, function() -- line: 152
        -- upvalues: settle (copy), v26 (copy)
        settle(v26)
    end))

    local decline = t3.decline
    local OnActivated2 = GUI.OnActivated
    local v28 = false

    table.insert(t7, OnActivated2(decline, function() -- line: 152
        -- upvalues: settle (copy), v28 (copy)
        settle(v28)
    end))

    local acknowledge = t3.acknowledge
    local OnActivated3 = GUI.OnActivated
    local v30

    table.insert(t7, OnActivated3(acknowledge, function() -- line: 152
        -- upvalues: settle (copy), v30 (copy)
        settle(v30)
    end))

    local dismiss = t3.dismiss

    table.insert(t7, GUI.OnActivated(dismiss, function() -- line: 152
        -- upvalues: settle (copy), v25 (copy)
        settle(v25)
    end))
    table.insert(t8, v3:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 162
        -- upvalues: settle (copy), v25 (copy), v3 (copy)
        if not v3.Enabled then
            settle(v25)
        end
    end))

    if not v20 then
        coroutine.yield()
    end

    return v21
end

local function ask(p10) -- line: 174
    -- upvalues: Audio (copy), Tabs (copy), t2 (copy), present (copy), awaitVerdict (copy)
    present(p10)

    if Tabs.IsActive("Message") or Tabs.Activate("Message") then
        Audio.Chime(t2[p10.kind])

        return awaitVerdict(p10.kind == "Confirm"), true
    end

    return nil, false
end

local function drain() -- line: 186
    -- upvalues: Tabs (copy), t6 (copy), v15 (ref), v16 (ref), resumeIfWaiting (copy), ask (copy)
    if not v16 then
        v16 = true

        local v34 = Tabs.Active()

        if v34 == "Message" then
            v34 = nil
        end

        while true do
            local v35 = table.remove(t6, 1)

            if v35 == nil then
                break
            end

            v15 = v35

            local v36, v37 = ask(v35)

            v15 = nil

            local v38 = #t6 == 0

            if v38 then
                v16 = false

                if v37 then
                    if v34 == nil or v35.leaveClosed then
                        Tabs.Deactivate()
                    else
                        Tabs.Activate(v34, {
                            instant = true
                        })
                    end
                end
            end

            resumeIfWaiting(v35.waiter, v36)

            if v38 then
                return
            end
        end

        v16 = false
    end
end

local function alreadyQueued(p11, p12) -- line: 224
    -- upvalues: t6 (copy), v15 (ref)
    if v15 and v15.body == p11 and v15.kind == p12 then
        return true
    end

    for _, v39 in t6 do
        if v39.body == p11 and v39.kind == p12 then
            return true
        end
    end

    return false
end

function t5.Show(p13) -- line: 241
    -- upvalues: Save (copy), t1 (copy), t6 (copy), drain (copy), alreadyQueued (copy)
    assert(type(p13) == "table", "dialog request must be a table")

    local Body = p13.Body

    assert(type(Body) == "string", "dialog body must be a string")

    local v42 = p13.Kind or "Notice"

    assert(t1[v42] == true, (("unknown dialog kind %*"):format((tostring(v42)))))

    if Save.Await() == nil or alreadyQueued(Body, v42) or #t6 >= 3 then
        return nil
    end

    table.insert(t6, {
        body = Body,
        kind = v42,
        heading = p13.Heading,
        image = p13.Image,
        leaveClosed = p13.LeaveClosed == true,
        waiter = coroutine.running()
    })
    task.spawn(drain)

    return (coroutine.yield())
end

local function withBody(p14, p15, p16) -- line: 267
    local v45 = if p16 == nil then {} else table.clone(p16)

    v45.Body = p14
    v45.Kind = p15

    return v45
end

function t5.Notice(p17, p18) -- line: 275
    -- upvalues: t5 (copy)
    local Show = t5.Show
    local v46 = if p18 == nil then {} else table.clone(p18)

    v46.Body = p17
    v46.Kind = "Notice"
    Show(v46)
end

function t5.Warn(p19, p20) -- line: 280
    -- upvalues: t5 (copy)
    local Show = t5.Show
    local v47 = if p20 == nil then {} else table.clone(p20)

    v47.Body = p19
    v47.Kind = "Warn"
    Show(v47)
end

function t5.Confirm(p21, p22) -- line: 286
    -- upvalues: t5 (copy)
    local Show = t5.Show
    local v48 = if p22 == nil then {} else table.clone(p22)

    v48.Body = p21
    v48.Kind = "Confirm"

    return Show(v48)
end

function t5.WarnGeneric() -- line: 290
    -- upvalues: t5 (copy)
    t5.Warn("That didn't go through. Please try again in a moment.")
end

t4.illustrated.RichText = true
t4.plain.RichText = true
v3:SetAttribute("ModalDialog", true)

for _, v49 in {
        t3.acknowledge,
        t3.accept,
        t3.decline,
        t3.dismiss
    } do
    ButtonFX(v49)
end

Remotes.Toasts.Line.OnClientEvent:Connect(function(p23) -- line: 304
    -- upvalues: t5 (copy)
    local v50, v51

    if typeof(p23) == "table" then
        if typeof(p23.Body) == "string" then
            v50 = table.clone(p23)

            if v50.Kind ~= "Warn" then
                v50.Kind = "Notice"
            end

            v51 = false
        else
            v51 = true
        end
    else
        v51 = true
    end

    if not v51 then
        t5.Show(v50)
    else
        warn((("Toasts.Line expects a dialog request table, got %*"):format((typeof(p23)))))
    end
end)

Remotes.Haul.OfferFullSatchelSale.OnClientInvoke = function(p24) -- line: 316
    -- upvalues: t5 (copy)
    return t5.Confirm(p24) == true
end

return table.freeze(t5)
