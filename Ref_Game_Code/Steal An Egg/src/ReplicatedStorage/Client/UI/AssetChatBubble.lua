-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Vector2.new(1084, 144)
local v2 = Vector2.new(251, 72)
local v3 = Vector2.new(213.84, 56.4)
local v4 = TweenInfo.new(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = t.strict(t.instanceIsA("Model"))
local v7 = t.strict(t.instanceIsA("BasePart"))
local v8 = t.strict(t.boolean)
local v9 = t.strict(t.string)
local t1 = {}

t1.__index = t1
t1.__class = "AssetChatBubble"

local ChatBubble = ReplicatedStorage.Assets.Billboards.ChatBubble
local Frame = ChatBubble.Frame

assert(ChatBubble:IsA("BillboardGui") and Frame:IsA("Frame") and Frame.TextLabel:IsA("TextLabel"), "the chat bubble blueprint has the wrong instance shape")

local v10 = true

local function claimAdornee(p1) -- line: 65
    local adornee = p1.adornee

    if adornee ~= nil then
        return adornee
    end

    assert(p1.proxied, "a bubble without an adornee must have been built in proxy mode")

    local Part = Instance.new("Part")

    Part.Name = "AssetBubbleProxy"
    Part.Size = Vector3.new(0.2, 0.2, 0.2)
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Anchored = false
    Part.Massless = true
    Part.CFrame = p1.centre.CFrame + Vector3.new(0, -1, 0)
    Part.Parent = p1.model

    local Motor6D

    if p1.centre.Anchored then
        Motor6D = Instance.new("Motor6D")
        Motor6D.C0 = p1.centre.CFrame:ToObjectSpace(Part.CFrame)
    else
        Motor6D = Instance.new("WeldConstraint")
    end

    Motor6D.Part0 = p1.centre
    Motor6D.Part1 = Part
    Motor6D.Parent = p1.centre
    p1.lifetime:Add(Part)
    p1.adornee = Part

    return Part
end

local function tearDown(p2, p3) -- line: 101
    local showing = p2.showing

    if showing == nil or p3 ~= nil and showing ~= p3 then
        return
    end

    p2.showing = nil
    showing:Destroy()
end

local function widenToFit(p4, p5, p6) -- line: 111
    -- upvalues: TextService (copy), v1 (copy), v2 (copy), v3 (copy)
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

    GetTextBoundsParams.Font = p5.FontFace
    GetTextBoundsParams.Size = v3.Y
    GetTextBoundsParams.Width = 10000
    GetTextBoundsParams.Text = p6

    local TextBoundsAsync = TextService:GetTextBoundsAsync(GetTextBoundsParams)

    GetTextBoundsParams:Destroy()
    assert(TextBoundsAsync.Y > 0, "measured chat bubble text has no height")

    local Size = p4.Size

    assert(Size.X.Offset == 0 and Size.Y.Offset == 0, "the chat bubble frame must be sized purely in scale")

    local v13 = v2.X - v3.X
    local v15 = math.max(v2.X, TextBoundsAsync.X + v13)

    p4.Size = UDim2.fromScale(v15 / v1.X, Size.Y.Scale)
end

function t1.new(p7, p8, p9) -- line: 132
    -- upvalues: Trove (copy), v6 (copy), v7 (copy), v8 (copy), t1 (copy)
    v6(p7)
    v7(p8)
    v8(p9)

    local self = setmetatable({}, t1)

    self.lifetime = Trove.new()
    self.showing = nil
    self.model = p7
    self.centre = p8

    if p9 then
        self.adornee = nil
    else
        self.adornee = p8
    end

    self.sizeFactor = math.max(p8.Size.X / 0.49799999594688416, p8.Size.Y / 0.4440000057220459)
    self.proxied = p9
    self.muted = false

    return self
end

function t1:Destroy() -- line: 151
    local showing = self.showing

    if showing ~= nil then
        self.showing = nil
        showing:Destroy()
    end

    self.lifetime:Destroy()
end

function t1.PinAbove(p11) -- line: 156
    -- upvalues: v8 (copy), v10 (ref)
    v8(p11)
    v10 = p11
end

function t1:Mute(p13) -- line: 161
    -- upvalues: v8 (copy)
    v8(p13)

    if self.muted ~= p13 then
        self.muted = p13

        if p13 then
            local showing = self.showing

            if showing ~= nil then
                self.showing = nil
                showing:Destroy()
            end
        end
    end
end

function t1:Say(p15, p16) -- line: 173
    -- upvalues: TweenService (copy), EnsureUIScale (copy), MessageTyper (copy), Trove (copy), v4 (copy), v5 (copy), v9 (copy), ChatBubble (copy), v10 (ref), claimAdornee (copy), widenToFit (copy)
    v9(p15)

    if self.muted then
        if p16 ~= nil then
            p16()
        end
    else
        local showing = self.showing

        if showing ~= nil then
            self.showing = nil
            showing:Destroy()
        end

        local clone = ChatBubble:Clone()
        local Frame = clone.Frame
        local TextLabel = Frame.TextLabel

        assert(Frame:IsA("Frame"), "the cloned chat bubble lost its Frame")
        assert(TextLabel:IsA("TextLabel"), "the cloned chat bubble lost its TextLabel")

        local Size = clone.Size

        clone.Size = UDim2.new(Size.X.Scale * self.sizeFactor, Size.X.Offset * self.sizeFactor, Size.Y.Scale * self.sizeFactor, Size.Y.Offset * self.sizeFactor)
        Frame.AutomaticSize = Enum.AutomaticSize.None
        clone.Adornee = claimAdornee(self)
        clone.AlwaysOnTop = v10
        clone.Parent = self.model
        clone.Enabled = true
        TextLabel.Text = ""

        local v19 = Trove.new()

        self.showing = v19
        v19:Add(clone)
        v19:Add(task.spawn(function() -- line: 208
            -- upvalues: self (copy), p15 (copy), p16 (copy), Frame (copy), TextLabel (copy), v19 (copy), TweenService (copy), EnsureUIScale (copy), MessageTyper (copy), v4 (copy), v5 (copy), widenToFit (copy)
            if self.showing ~= v19 then
                return
            end

            widenToFit(Frame, TextLabel, p15)

            if self.showing == v19 then
                local v20 = EnsureUIScale(Frame)

                v20.Scale = 0

                local v21 = MessageTyper.new(TextLabel, nil, nil, false)

                v19:Add(function() -- line: 221
                    -- upvalues: v21 (copy)
                    v21:Halt()
                end)

                local tween = TweenService:Create(v20, v4, {
                    Scale = 1
                })

                v19:Add(tween)
                v19:Add(task.delay(4, function() -- line: 225
                    -- upvalues: v20 (copy), self (copy), p16 (copy), v19 (copy), TweenService (copy), v5 (copy)
                    if self.showing ~= v19 then
                        return
                    end

                    local tween = TweenService:Create(v20, v5, {
                        Scale = 0
                    })

                    v19:Add(tween)
                    v19:Add(tween.Completed:Connect(function() -- line: 232
                        -- upvalues: self (copy), p16 (copy), v19 (copy)
                        local showing = self.showing

                        if showing ~= nil and (v19 == nil or showing == v19) then
                            self.showing = nil
                            showing:Destroy()
                        end

                        if p16 ~= nil then
                            p16()
                        end
                    end))
                    tween:Play()
                end))
                task.delay(0.2, function() -- line: 241
                    -- upvalues: v21 (copy), p15 (copy), TextLabel (copy)
                    v21:Type(p15, TextLabel.TextColor3)
                end)
                tween:Play()
            end
        end))
    end
end

return t1
