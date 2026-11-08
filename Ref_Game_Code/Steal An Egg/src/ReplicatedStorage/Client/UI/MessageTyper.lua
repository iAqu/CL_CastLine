-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local Normal = require(ReplicatedStorage.Data.Sounds.Languages.Alphabet).Normal
local t1 = {}

t1.__index = t1
t1.__class = "MessageTyper"

local function splitGlyphs(p1) -- line: 32
    local v1 = string.gsub(p1, "<.->", "")
    local t2 = {}

    for v2, v3 in utf8.graphemes(v1) do
        t2[#t2 + 1] = string.sub(v1, v2, v3)
    end

    return t2
end

local function voiceGlyph(p2, p3) -- line: 42
    -- upvalues: ReplicatedFirst (copy), Audio (copy), Normal (copy)
    if p2 ~= " " then
        local v4 = Normal[string.lower(p2)]

        if v4 then
            Audio.PlaySound(v4.Sound:Clone(), v4.Sound.Parent)
        else
            Audio.Play(p3, ReplicatedFirst)
        end
    end
end

function t1.new(p4, p5, p6, p7) -- line: 56
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.label = p4
    self.run = 0
    self.clickSound = p5 or "rbxassetid://91414159854126"
    self.clicksOn = p7 ~= false
    self.pace = p6 or 0.09
    self.driver = nil
    self.watcher = nil
    self.sweep = nil

    return self
end

function t1:Halt() -- line: 74
    self.run += 1

    local sweep = self.sweep

    if sweep then
        sweep:Cancel()
        self.sweep = nil
    end

    local watcher = self.watcher

    if watcher then
        watcher:Disconnect()
        self.watcher = nil
    end

    local driver = self.driver

    if driver then
        driver:Destroy()
        self.driver = nil
    end

    self.label.MaxVisibleGraphemes = -1
end

function t1:Blank() -- line: 98
    self:Halt()
    self.label.Text = ""
end

function t1:ShowAll(p11, p12) -- line: 103
    local label = self.label

    if label.Text == p11 and label.TextColor3 == p12 and label.MaxVisibleGraphemes == -1 then
        return
    end

    self:Halt()
    label.RichText = true
    label.Text = p11
    label.TextColor3 = p12
    label.MaxVisibleGraphemes = -1
end

function t1:Type(p14, p15) -- line: 119
    -- upvalues: ReplicatedFirst (copy), TweenService (copy), Audio (copy), Normal (copy), splitGlyphs (copy)
    local label = self.label

    if label.Text == p14 and label.TextColor3 == p15 then
        return
    end

    self:Halt()
    self.run += 1

    local run = self.run

    label.RichText = true
    label.Text = p14
    label.TextColor3 = p15

    local v6 = splitGlyphs(p14)
    local v7 = #v6

    if v7 <= 0 then
        label.MaxVisibleGraphemes = -1
    else
        label.MaxVisibleGraphemes = 0

        local NumberValue = Instance.new("NumberValue")

        NumberValue.Value = 0
        self.driver = NumberValue

        local n1 = 0

        self.watcher = NumberValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 147
            -- upvalues: self (copy), label (copy), run (copy), v6 (copy), v7 (copy), NumberValue (copy), n1 (ref), ReplicatedFirst (copy), Audio (copy), Normal (copy)
            if run ~= self.run then
                return
            end

            local v10 = math.clamp(math.floor(NumberValue.Value + 0.5), 0, v7)

            if v10 == n1 then
                return
            end

            label.MaxVisibleGraphemes = v10

            if self.clicksOn then
                for i = n1 + 1, v10 do
                    local v11 = v6[i]

                    if v11 then
                        local clickSound = self.clickSound

                        if v11 ~= " " then
                            local v12 = Normal[string.lower(v11)]

                            if v12 then
                                Audio.PlaySound(v12.Sound:Clone(), v12.Sound.Parent)
                            else
                                Audio.Play(clickSound, ReplicatedFirst)
                            end
                        end
                    end
                end
            end

            n1 = v10
        end)

        local tween = TweenService:Create(NumberValue, TweenInfo.new(v7 * self.pace), {
            Value = v7
        })

        self.sweep = tween
        tween.Completed:Connect(function() -- line: 175
            -- upvalues: self (copy), label (copy), run (copy)
            if run ~= self.run then
                return
            end

            label.MaxVisibleGraphemes = -1

            local watcher = self.watcher

            if watcher then
                watcher:Disconnect()
                self.watcher = nil
            end

            local driver = self.driver

            if driver then
                driver:Destroy()
                self.driver = nil
            end

            self.sweep = nil
        end)
        tween:Play()
    end
end

return t1
