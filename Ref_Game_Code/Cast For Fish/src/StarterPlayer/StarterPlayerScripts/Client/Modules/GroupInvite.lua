-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GroupService = game:GetService("GroupService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local fromRGB = Color3.fromRGB
local t1 = {}

t1.__index = t1

function t1.new() -- line: 11
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Remotes = ReplicatedStorage:WaitForChild("Remotes")
    self.GroupId = nil
    self.Reward = 0
    self.Shown = 0
    self.Mute = false
    self:Build()

    return self
end

function t1:Build() -- line: 22
    -- upvalues: UIKit (copy), fromRGB (copy)
    local v2 = UIKit.screenGui("GroupInvite", 18)
    local v3 = UIKit.frame(v2, {
        Name = "Card",
        Corner = 24,
        Stroke = 6,
        Size = UDim2.fromOffset(620, 300),
        Position = UDim2.fromScale(0.5, 0.45),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = fromRGB(40, 30, 80),
        Color2 = fromRGB(18, 14, 40)
    })

    UIKit.text(v3, {
        Name = "Title",
        Text = "WELCOME BACK!",
        TextSize = 50,
        Stroke = 5,
        ZIndex = 2,
        Size = UDim2.new(1, -40, 0, 60),
        Position = UDim2.fromOffset(20, 18),
        Color = fromRGB(255, 221, 40)
    })
    self.Body = UIKit.text(v3, {
        Name = "Body",
        Text = "",
        TextSize = 30,
        Stroke = 4,
        ZIndex = 2,
        Size = UDim2.new(1, -60, 0, 90),
        Position = UDim2.fromOffset(30, 86)
    })
    self.Body.TextWrapped = true
    UIKit.clover(v3, 60, {
        ZIndex = 3,
        Position = UDim2.new(0, 30, 1, -52),
        AnchorPoint = Vector2.new(0, 0.5)
    })
    UIKit.button(v3, {
        Name = "Join",
        Text = "JOIN GROUP",
        Corner = 16,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 3,
        Size = UDim2.fromOffset(300, 70),
        Position = UDim2.new(0.5, 0, 1, -22),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = fromRGB(130, 240, 60),
        Color2 = fromRGB(50, 190, 30),
        OnClick = function() -- OnClick | line: 29
            -- upvalues: self (copy)
            self:Join()
        end
    })
    UIKit.button(v3, {
        Name = "Close",
        Text = "X",
        Corner = 12,
        Stroke = 4,
        ZIndex = 4,
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(1, 14, 0, -14),
        AnchorPoint = Vector2.new(1, 0),
        Color = fromRGB(255, 90, 100),
        Color2 = fromRGB(200, 40, 60),
        OnClick = function() -- OnClick | line: 32
            -- upvalues: self (copy)
            self:Hide()
        end
    })
    v3.Visible = false
    self.Card = v3
end

function t1:GroupName() -- line: 39
    -- upvalues: GroupService (copy)
    local function v4() -- line: 40
        -- upvalues: self (copy), GroupService (copy)
        return GroupService:GetGroupInfoAsync(self.GroupId)
    end

    local ok, result = pcall(v4)

    if ok and result and result.Name then
        return result.Name
    end

    return "Cmnbltz"
end

function t1:Show(p4, p5) -- line: 46
    -- upvalues: UIKit (copy)
    self.GroupId = p4
    self.Reward = p5
    self.Shown += 1
    self.Body.Text = ("Join the %s group and get %d free Lucky Casts!"):format(self:GroupName(), p5)
    self.Card.Visible = true
    UIKit.pop(self.Card, 0.6)
    UIKit.sound("Unlock")
end

function t1:Hide() -- line: 56
    self.Card.Visible = false
end

function t1:Join() -- line: 60
    -- upvalues: GroupService (copy)
    if self.GroupId then
        local GroupId = self.GroupId

        task.spawn(function() -- line: 65
            -- upvalues: self (copy), GroupId (copy), GroupService (copy)
            if not self.Mute then
                local function v5() -- line: 67
                    -- upvalues: GroupId (copy), GroupService (copy)
                    GroupService:PromptJoinAsync(GroupId)
                end

                pcall(v5)
            end

            local function v6() -- line: 71
                -- upvalues: self (copy)
                return self.Remotes.ClaimGroupReward:InvokeServer()
            end

            local ok, result = pcall(v6)

            if ok and result then
                self:Hide()
            end
        end)
    end
end

function t1:Start() -- line: 80
    -- upvalues: UIKit (copy), HUD (copy)
    self.Remotes:WaitForChild("GroupInvite").OnClientEvent:Connect(function(p9, p10) -- line: 81
        -- upvalues: self (copy), UIKit (copy), HUD (copy)
        if type(p9) ~= "number" then
            return
        end

        local function waitForCalm() -- line: 83
            -- upvalues: UIKit (copy), HUD (copy)
            while true do
                if HUD.GetMode() ~= "normal" then
                    task.wait(1)
                    continue
                end

                if UIKit.anyWindowOpen() then
                    task.wait(1)
                    continue
                end

                break
            end
        end

        waitForCalm()
        self:Show(p9, tonumber(p10) or 10)
    end)

    return self
end

return t1
