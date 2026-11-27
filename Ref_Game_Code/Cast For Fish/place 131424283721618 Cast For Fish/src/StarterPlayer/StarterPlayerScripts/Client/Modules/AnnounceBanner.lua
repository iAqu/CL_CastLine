-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local UIKit = require(script.Parent.UIKit)
local t1 = {
    Shown = 0,
    Last = nil
}
local fromRGB = Color3.fromRGB
local v1 = utf8.char(57344)
local v2

local function topY() -- line: 24
    -- upvalues: Players (copy), v2 (ref)
    local PlayerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    local TopBar = PlayerGui and PlayerGui:FindFirstChild("TopBar")
    local Row = TopBar and TopBar:FindFirstChild("Row")
    local FitScale = v2 and v2:FindFirstChild("FitScale")
    local v3 = if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale
    local v4 = if Row and v2 and Row.AbsoluteSize.Y > 0 then math.max(70, (Row.AbsolutePosition.Y + Row.AbsoluteSize.Y - v2.AbsolutePosition.Y) / v3 + 14) else 70
    local EventHUD = PlayerGui and PlayerGui:FindFirstChild("EventHUD")
    local Banner = EventHUD and EventHUD:FindFirstChild("Banner")

    if Banner and Banner.Visible then
        v4 = math.max(v4, Banner.Position.Y.Offset + Banner.Size.Y.Offset + 40)
    end

    local ServerLuck = PlayerGui and PlayerGui:FindFirstChild("ServerLuck")
    local Pill = ServerLuck and ServerLuck:FindFirstChild("Pill")

    if Pill and Pill.Visible and Pill.Position.X.Offset == 0 then
        v4 = math.max(v4, Pill.Position.Y.Offset + Pill.Size.Y.Offset + 8)
    end

    return v4
end

local function escape(p1) -- line: 47
    return (p1:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function chatLine(p2) -- line: 51
    -- upvalues: TextChatService (copy)
    local function v8() -- line: 52
        -- upvalues: p2 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")
        local RBXGeneral = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

        if RBXGeneral then
            RBXGeneral:DisplaySystemMessage("<font color=\"#FFD23C\"><b>[ANNOUNCEMENT]</b></font> " .. p2:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
        end
    end

    pcall(v8)
end

local t2 = {}

t2.__index = t2

function t2.new(p3) -- line: 64
    -- upvalues: TextService (copy), Players (copy), UIKit (copy), fromRGB (copy), v1 (copy), t2 (copy)
    local self = setmetatable({}, t2)
    local v10 = p3.from .. " " .. v1 .. ": " .. p3.text
    local TextSize = TextService:GetTextSize(v10, 28, UIKit.Font, Vector2.new(634, 2000))
    local v12 = math.min(634, TextSize.X + 4)

    self.Width = v12 + 126
    self.Height = math.max(108, 36 + TextSize.Y)
    self.Life = math.clamp(#p3.text / 16 + 5, 6, 15)
    self.Closed = false

    local CanvasGroup = Instance.new("CanvasGroup")

    CanvasGroup.Name = "Banner"
    CanvasGroup.BackgroundTransparency = 1
    CanvasGroup.AnchorPoint = Vector2.new(0.5, 0)
    CanvasGroup.Size = UDim2.fromOffset(self.Width + 80, self.Height + 80)
    CanvasGroup.GroupTransparency = 1
    self.Holder = CanvasGroup

    local Frame = Instance.new("Frame")

    Frame.Name = "Content"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.fromOffset(self.Width, self.Height)
    Frame.Position = UDim2.fromOffset(40, 40)
    Frame.ZIndex = 2
    Frame.Parent = CanvasGroup

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Avatar"
    ImageLabel.BackgroundColor3 = fromRGB(255, 255, 255)
    ImageLabel.BackgroundTransparency = 0.85
    ImageLabel.Size = UDim2.fromOffset(72, 72)
    ImageLabel.Position = UDim2.new(0, 18, 0.5, 0)
    ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
    ImageLabel.ScaleType = Enum.ScaleType.Crop
    ImageLabel.ZIndex = 3
    ImageLabel.Parent = Frame
    UIKit.corner(ImageLabel, 36)

    if p3.fromId and p3.fromId > 0 then
        task.spawn(function() -- line: 103
            -- upvalues: p3 (copy), ImageLabel (copy), Players (copy)
            local function v15() -- line: 104
                -- upvalues: p3 (copy), Players (copy)
                return Players:GetUserThumbnailAsync(p3.fromId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            end

            local ok, result = pcall(v15)

            if ok and ImageLabel.Parent then
                ImageLabel.Image = result
            end
        end)
    end

    UIKit.text(Frame, {
        Name = "Message",
        TextSize = 28,
        Stroke = 2,
        ZIndex = 3,
        Text = v10,
        Size = UDim2.fromOffset(v12, TextSize.Y + 4),
        Position = UDim2.new(0, 108, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        XAlign = Enum.TextXAlignment.Left,
        YAlign = Enum.TextYAlignment.Center,
        Color = fromRGB(255, 255, 255),
        StrokeColor = fromRGB(0, 0, 0)
    }).TextWrapped = true

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Close"
    TextButton.BackgroundTransparency = 1
    TextButton.Text = ""
    TextButton.Size = UDim2.fromScale(1, 1)
    TextButton.ZIndex = 6
    TextButton.Parent = Frame
    self.Tap = TextButton

    return self
end

function t2:Place(p5, p6) -- line: 127
    -- upvalues: UIKit (copy)
    self.Y = p5

    local v16 = UDim2.new(0.5, 0, 0, p5 - 40)

    if p6 then
        UIKit.tween(self.Holder, 0.3, {
            Position = v16
        }, Enum.EasingStyle.Quad)
    else
        self.Holder.Position = v16
    end
end

local t4 = {}

t4.__index = t4

function t4.new() -- line: 140
    -- upvalues: t4 (copy)
    local self = setmetatable({}, t4)

    self.Items = {}

    return self
end

function t4:Layout(p8) -- line: 146
    -- upvalues: topY (copy)
    local v18 = topY()

    for _, v19 in ipairs(self.Items) do
        v19:Place(v18, p8)
        v18 += v19.Height + 4
    end
end

function t4:Remove(p10) -- line: 154
    -- upvalues: UIKit (copy)
    if p10.Closed then
        return
    end

    p10.Closed = true

    local v20 = table.find(self.Items, p10)

    if v20 then
        table.remove(self.Items, v20)
    end

    self:Layout(true)
    UIKit.tween(p10.Holder, 0.45, {
        GroupTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, p10.Y - 40 - 30)
    }, Enum.EasingStyle.Quad, Enum.EasingDirection.In).Completed:Once(function() -- line: 165
        -- upvalues: p10 (copy)
        p10.Holder:Destroy()
    end)
end

function t4:Add(p12) -- line: 170
    -- upvalues: UIKit (copy), v2 (ref), t2 (copy)
    local v21 = t2.new(p12)

    table.insert(self.Items, v21)

    while #self.Items > 4 do
        self:Remove(self.Items[1])
    end

    self:Layout(true)
    v21.Holder.Position = UDim2.new(0.5, 0, 0, v21.Y - 40 + 16)
    v21.Holder.Parent = v2
    UIKit.tween(v21.Holder, 0.3, {
        GroupTransparency = 0,
        Position = UDim2.new(0.5, 0, 0, v21.Y - 40)
    }, Enum.EasingStyle.Quad)
    UIKit.sound("ToastGold")
    v21.Tap.Activated:Connect(function() -- line: 181
        -- upvalues: self (copy), v21 (copy)
        self:Remove(v21)
    end)
    task.delay(v21.Life, function() -- line: 184
        -- upvalues: self (copy), v21 (copy)
        self:Remove(v21)
    end)
end

local v22 = t4.new()

function t1.Show(p13, p14, p15) -- line: 191
    -- upvalues: TextChatService (copy), t1 (copy), v22 (copy)
    local function v23() -- line: 52
        -- upvalues: p13 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")
        local RBXGeneral = TextChannels and TextChannels:FindFirstChild("RBXGeneral")

        if RBXGeneral then
            RBXGeneral:DisplaySystemMessage("<font color=\"#FFD23C\"><b>[ANNOUNCEMENT]</b></font> " .. p13:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
        end
    end

    pcall(v23)
    t1.Shown += 1
    t1.Last = p13
    v22:Add({
        text = p13,
        from = p14 or "Admin",
        fromId = p15
    })
end

function t1.Count() -- line: 198
    -- upvalues: v22 (copy)
    return #v22.Items
end

function t1.Init() -- line: 202
    -- upvalues: ReplicatedStorage (copy), UIKit (copy), t1 (copy), v2 (ref)
    v2 = UIKit.screenGui("Announcement", 45)
    task.spawn(function() -- line: 204
        -- upvalues: ReplicatedStorage (copy), t1 (copy)
        local v24 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("AdminAnnounce", 60)

        if v24 then
            v24.OnClientEvent:Connect(function(p16) -- line: 207
                -- upvalues: t1 (copy)
                local Show, text, from, v25

                if type(p16) == "table" then
                    if type(p16.text) ~= "string" or p16.text == "" then
                        v25 = true
                    else
                        Show = t1.Show
                        text = p16.text

                        if type(p16.from) == "string" then
                            from = p16.from
                        end

                        v25 = false
                    end
                else
                    v25 = true
                end

                if v25 then
                    return
                end

                Show(text, from, if type(p16.fromId) == "number" then p16.fromId else nil)
            end)
        end
    end)
end

return t1
