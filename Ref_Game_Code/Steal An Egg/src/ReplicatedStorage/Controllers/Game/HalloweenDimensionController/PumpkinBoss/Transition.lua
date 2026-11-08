-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Transition = require(script.Parent.Parent.Transition)
local v1 = Color3.fromRGB(20, 8, 0)
local t1 = {
    Core = Color3.fromRGB(196, 84, 10),
    Edge = Color3.fromRGB(46, 16, 2),
    Shade = Color3.fromRGB(255, 170, 70),
    Embers = {
        Color3.fromRGB(255, 200, 110),
        Color3.fromRGB(255, 140, 30),
        Color3.fromRGB(255, 230, 170)
    },
    Veil = Color3.fromRGB(46, 16, 2),
    VeilTint = ColorSequence.new(Color3.fromRGB(214, 100, 18), Color3.new(1, 1, 1)),
    PuffTint = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 150, 120))
}
local LocalPlayer = Players.LocalPlayer
local ScreenGui, Frame
local tween = nil
local n1 = 0
local v4 = false
local Position
local v5 = false
local v6 = false

local function ensureGui() -- line: 59
    -- upvalues: v1 (copy), LocalPlayer (copy), ScreenGui (ref), Frame (ref)
    if ScreenGui and ScreenGui.Parent and Frame then
        return Frame
    end

    local ScreenGui2 = Instance.new("ScreenGui")

    ScreenGui2.Name = "PumpkinTransition"
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.DisplayOrder = 1000
    ScreenGui2.Enabled = false

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Cover"
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.BackgroundColor3 = v1
    Frame2.BackgroundTransparency = 1
    Frame2.BorderSizePixel = 0
    Frame2.Parent = ScreenGui2
    ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui = ScreenGui2
    Frame = Frame2

    return Frame2
end

local function fadeTo(p1, p2, p3) -- line: 85
    -- upvalues: TweenService (copy), ScreenGui (ref), tween (ref), ensureGui (copy)
    local v7 = ensureGui()

    if tween then
        tween:Cancel()
    end

    ScreenGui.Enabled = true

    local tween2 = TweenService:Create(v7, TweenInfo.new(p2), {
        BackgroundTransparency = p1
    })

    tween = tween2
    tween2.Completed:Connect(function(p4) -- line: 95
        -- upvalues: p3 (copy), tween2 (copy), tween (ref)
        if p4 == Enum.PlaybackState.Completed and tween == tween2 and p3 then
            p3()
        end
    end)
    tween2:Play()
end

local function rootPosition() -- line: 103
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v8 = Player.FindRootPart(LocalPlayer)

    return if v8 then v8.Position else nil
end

local t2 = {}

function t2.Cover(p5, p6, p7) -- line: 110
    -- upvalues: Player (copy), LocalPlayer (copy), ScreenGui (ref), tween (ref), n1 (ref), v4 (ref), Position (ref), ensureGui (copy), fadeTo (copy), t2 (copy)
    n1 += 1

    local v9 = n1
    local v10 = Player.FindRootPart(LocalPlayer)

    Position = if v10 then v10.Position else nil
    v4 = true
    task.delay(math.max(p6 or 0, 5), function() -- line: 116
        -- upvalues: v9 (copy), n1 (ref), v4 (ref), t2 (copy)
        if n1 == v9 and v4 then
            t2.Reveal()
        end
    end)

    if not p5 then
        fadeTo(0, p7 or 0.18)

        return
    end

    if tween then
        tween:Cancel()
        tween = nil
    end

    ensureGui().BackgroundTransparency = 0
    ScreenGui.Enabled = true
end

function t2.Reveal(p8) -- line: 137
    -- upvalues: ScreenGui (ref), v4 (ref), fadeTo (copy)
    if v4 then
        v4 = false
        fadeTo(1, p8 or 0.3, function() -- line: 143
            -- upvalues: ScreenGui (ref), v4 (ref)
            if ScreenGui and not v4 then
                ScreenGui.Enabled = false
            end
        end)
    end
end

function t2.RevealAfterMove() -- line: 150
    -- upvalues: Player (copy), LocalPlayer (copy), n1 (ref), Position (ref), t2 (copy)
    local v12 = n1
    local Position2 = Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 155
        -- upvalues: v12 (copy), Position2 (copy), elapsed (copy), Player (copy), LocalPlayer (copy), n1 (ref), t2 (copy)
        while true do
            if os.clock() - elapsed < 0.75 then
                if n1 == v12 then
                    local v13 = Player.FindRootPart(LocalPlayer)
                    local Position = if v13 then v13.Position else nil

                    if Position2 == nil or Position and (Position - Position2).Magnitude > 12 then
                        break
                    end

                    task.wait()
                    continue
                end

                return
            end

            break
        end

        task.wait(0.08)

        if n1 == v12 then
            t2.Reveal()
        end
    end)
end

function t2.Listen() -- line: 175
    -- upvalues: Remotes (copy), Transition (copy), t1 (copy), v5 (ref), v6 (ref), t2 (copy)
    if not v5 then
        v5 = true
        Remotes.PumpkinBoss.Transition.OnClientEvent:Connect(function(p9, p10, p11, p12) -- line: 182
            -- upvalues: Transition (copy), t1 (copy), v6 (ref), t2 (copy)
            local v14 = if type(p11) == "number" then p11 else nil

            if p9 == "Cover" and p12 == "Clouds" then
                v6 = true
                Transition.Cover(t1, (v14 or 0) + 8)
            elseif p9 == "Cover" then
                if not (v6 and Transition.IsCovering()) then
                    v6 = false
                    t2.Cover(p10 == true, v14)
                end
            elseif p9 == "Reveal" then
                if v6 then
                    v6 = false
                    Transition.RevealAfterMove()
                else
                    t2.RevealAfterMove()
                end
            end
        end)
    end
end

return t2
