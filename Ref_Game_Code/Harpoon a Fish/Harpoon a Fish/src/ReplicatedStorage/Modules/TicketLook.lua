-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local TicketConfig = require(Modules:WaitForChild("TicketConfig"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local t1 = {}
local t2 = {
    Color3.fromRGB(232, 168, 52),
    Color3.fromRGB(255, 238, 170),
    Color3.fromRGB(70, 40, 6)
}

local function template() -- line: 20
    -- upvalues: ReplicatedStorage (copy)
    return ReplicatedStorage:WaitForChild("TicketProps"):WaitForChild("Card")
end

local function paint(p1, p2) -- line: 25
    -- upvalues: RarityStyle (copy)
    local Grad = p1:FindFirstChild("Grad")

    if Grad then
        Grad.Color = RarityStyle.GradientOf(p2)
    end

    local UIStroke = p1:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = RarityStyle.StrokeOf(p2)
    end

    p1.TextColor3 = Color3.new(1, 1, 1)
end

local function gold(p3) -- line: 32
    -- upvalues: t2 (copy)
    local Grad = p3:FindFirstChild("Grad")

    if Grad then
        Grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, t2[1]),
            ColorSequenceKeypoint.new(0.5, t2[2]),
            ColorSequenceKeypoint.new(1, t2[1])
        })
    end

    local UIStroke = p3:FindFirstChildOfClass("UIStroke")

    if UIStroke then
        UIStroke.Color = t2[3]
    end
end

local function finish(p4, p5) -- line: 41
    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        end
    end

    if p5 and p5 ~= 1 then
        p4:ScaleTo(p5)
    end

    return p4
end

local function dress(p6, p7, p8, p9, p10) -- line: 53
    -- upvalues: ReplicatedStorage (copy), TicketConfig (copy), paint (copy), gold (copy), finish (copy)
    local v1 = TicketConfig.GROUPS[p6]
    local clone = ReplicatedStorage:WaitForChild("TicketProps"):WaitForChild("Card"):Clone()

    clone.Ticket.Color = v1.card

    local Print = clone.Face.Print
    local Body = Print.Body

    Body.Title.Text = string.upper(p7)
    paint(Body.Title, v1.text)
    Body.Kind.Text = p9
    gold(Body.Kind)
    Print.Group.Text = v1.stub
    gold(Print.Group)
    Body.Art.Image = ""

    if type(p8) == "table" then
        Body.ArtText.Text = p8.text
        paint(Body.ArtText, v1.text)
        Body.ArtText.Visible = true
    elseif p8 then
        Body.Art.Image = p8
    end

    return (finish(clone, p10))
end

function t1.Make(p11, p12) -- line: 77
    -- upvalues: TicketConfig (copy), dress (copy)
    local v2 = TicketConfig.Get(p11)

    assert(v2, "TicketLook: no ticket " .. tostring(p11))

    if v2.group == "Chest" then
        return (dress("Chest", v2.name, TicketConfig.CHEST_ART, "CHEST TICKET", p12))
    end

    return (dress(v2.group, v2.name, v2.art, v2.kind or string.upper(v2.group) .. " TICKET", p12))
end

function t1.MakeGroup(p13, p14) -- line: 86
    -- upvalues: TicketConfig (copy), dress (copy)
    if p13 == "Chest" then
        return (dress("Chest", "Treasure Chest", TicketConfig.CHEST_ART, "PICK A ZONE", p14))
    end

    if p13 == "Event" then
        return (dress("Event", "Event", {
            text = "COMING SOON"
        }, "EVENT TICKET", p14))
    end

    error("TicketLook.MakeGroup: " .. tostring(p13))
end

return t1
