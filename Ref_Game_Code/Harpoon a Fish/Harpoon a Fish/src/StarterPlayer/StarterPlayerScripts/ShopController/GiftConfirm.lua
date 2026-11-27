-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local PadMenu = require(Modules:WaitForChild("PadMenu"))
local Confirm = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GiftGui"):WaitForChild("Confirm")
local Scale = Confirm:WaitForChild("Scale")
local Main = Confirm:WaitForChild("Main")
local Subtitle = Main:WaitForChild("Subtitle")
local ItemIcon = Main:WaitForChild("ItemIcon")
local ItemName = Main:WaitForChild("ItemName")
local Head = Main:WaitForChild("Head")
local PlayerName = Main:WaitForChild("PlayerName")
local GiftButton = Main:WaitForChild("GiftButton")
local Close = Main:WaitForChild("Close")

for _, v1 in ipairs({ Subtitle, ItemName, PlayerName }) do
    v1.AutoLocalize = false
end

Confirm.Visible = false

local v2 = false
local v3, v4
local t1 = {}

function t1.IsOpen() -- line: 38
    -- upvalues: v2 (ref)
    return v2
end

local function esc(p1) -- line: 42
    return (tostring(p1):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

function t1.Open(p2, p3, p4, p5) -- line: 47
    -- upvalues: TweenService (copy), PanelFocus (copy), PadMenu (copy), Confirm (copy), Scale (copy), Subtitle (copy), ItemIcon (copy), ItemName (copy), Head (copy), PlayerName (copy), GiftButton (copy), Close (copy), v2 (ref), v3 (ref), v4 (ref)
    if v2 then
        return
    end

    v2 = true
    v3 = p4
    v4 = p5
    ItemIcon.Image = p3.icon or ""
    ItemName.Text = p3.name or ""
    Head.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p2.UserId .. "&w=150&h=150"
    PlayerName.Text = p2.DisplayName
    Subtitle.Text = ("You are gifting <font color=\"%s\">%s</font> to <font color=\"%s\">%s</font>!"):format("#FFD24A", tostring(p3.name or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"), "#FF8AD8", (tostring(p2.DisplayName):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    Scale.Scale = PanelFocus.FEEL.FROM
    Confirm.Visible = true
    TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    }):Play()
    PadMenu.Open(Confirm, function() -- line: 60
        -- upvalues: v2 (ref), v4 (ref)
        if v2 and v4 then
            v4()
        end
    end, {
        first = GiftButton,
        closeButton = Close
    })
end

function t1.Close(p6) -- line: 64
    -- upvalues: TweenService (copy), PanelFocus (copy), PadMenu (copy), Confirm (copy), Scale (copy), v2 (ref), v3 (ref), v4 (ref)
    if not v2 then
        return
    end

    v2 = false
    PadMenu.Close(Confirm)
    v3 = nil
    v4 = nil

    if p6 then
        Confirm.Visible = false
    else
        local tween = TweenService:Create(Scale, PanelFocus.popOut, {
            Scale = 0
        })

        tween.Completed:Once(function() -- line: 74
            -- upvalues: Confirm (copy), v2 (ref)
            if not v2 then
                Confirm.Visible = false
            end
        end)
        tween:Play()
    end
end

ButtonHover.Attach(GiftButton, {
    tile = 1,
    iconTilt = -20,
    highlight = true,
    highlightCorner = 0.3,
    highlightFade = 0.75,
    icon = GiftButton:FindFirstChild("Icon")
})
GiftButton.Activated:Connect(function() -- line: 81
    -- upvalues: ButtonHover (copy), GiftButton (copy), v2 (ref), v3 (ref)
    if v2 then
        ButtonHover.Press(GiftButton)

        if v3 then
            v3()
        end
    end
end)
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})
Close.Activated:Connect(function() -- line: 87
    -- upvalues: v2 (ref), v4 (ref)
    if v2 and v4 then
        v4()
    end
end)

return t1
