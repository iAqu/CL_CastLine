-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Loc = require(Modules:WaitForChild("Loc"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RestartGui = PlayerGui:WaitForChild("RestartGui")
local Dim = RestartGui:WaitForChild("Dim")
local Card = RestartGui:WaitForChild("Card")
local Pop = Card:WaitForChild("Pop")
local Title = Card:WaitForChild("Title")
local Note = Card:WaitForChild("Note")
local EffectsGui = PlayerGui:WaitForChild("EffectsGui")
local t1 = {
    DIM = 0.35,
    HOLD = 4,
    WAIT = 30,
    SKIP_UNDER = 10,
    LANDED = 0.12,
    CARD_IN = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    DIM_IN = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    FLY = TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
    FADE = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
}
local CardPosition = Card.Position

Dim.Visible = false
Card.Visible = false
Title.AutoLocalize = false
Note.AutoLocalize = false

local elapsed = os.clock()

task.spawn(function() -- line: 51
    -- upvalues: Card (copy)
    local function v1() -- line: 52
        -- upvalues: Card (copy)
        game:GetService("ContentProvider"):PreloadAsync({ Card:WaitForChild("Icon") })
    end

    pcall(v1)
end)

local function secondsLeft() -- line: 55
    local ServerRestartAt = workspace:GetAttribute("ServerRestartAt")

    return type(ServerRestartAt) == "number" and ServerRestartAt - workspace:GetServerTimeNow() or 0
end

local function showRow() -- line: 60
    -- upvalues: LocalPlayer (copy)
    LocalPlayer:SetAttribute("RestartRow", true)
end

local function rowIcon() -- line: 65
    -- upvalues: EffectsGui (copy)
    local Stack = EffectsGui:FindFirstChild("Stack")
    local v2, v3

    if Stack then
        v3 = Stack:FindFirstChild("Pop")
        v2 = Stack:FindFirstChild("Restart")
    else
        v2 = Stack
        v3 = Stack
    end

    local Icon = v2 and v2:FindFirstChild("Icon")

    return if Icon and v2.Visible and v3 and v3.Scale > 0.9 * (Stack:GetAttribute("Fit") or 1) then Icon else nil
end

local function intro() -- line: 75
    -- upvalues: RunService (copy), TweenService (copy), Loc (copy), PanelFocus (copy), LocalPlayer (copy), Dim (copy), Card (copy), Pop (copy), Title (copy), Note (copy), t1 (copy), CardPosition (copy), rowIcon (copy)
    Title.Text = Loc.T("SERVER RESTARTING")

    local ServerRestartNote = workspace:GetAttribute("ServerRestartNote")

    Note.Text = if type(ServerRestartNote) ~= "string" or not ServerRestartNote then Loc.T("The game is updating! You'll be moved to a new server.") else ServerRestartNote
    Card.Position = CardPosition
    Pop.Scale = 0
    Dim.BackgroundTransparency = 1
    Dim.Visible = true
    Card.Visible = true
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    TweenService:Create(Dim, t1.DIM_IN, {
        BackgroundTransparency = t1.DIM
    }):Play()
    TweenService:Create(Pop, t1.CARD_IN, {
        Scale = 1
    }):Play()
    task.wait(t1.HOLD)
    LocalPlayer:SetAttribute("RestartRow", true)
    RunService.Heartbeat:Wait()
    RunService.Heartbeat:Wait()
    TweenService:Create(Dim, t1.FADE, {
        BackgroundTransparency = 1
    }):Play()

    local v4 = rowIcon()
    local v5

    if v4 then
        local v6 = v4.AbsolutePosition + v4.AbsoluteSize / 2

        v5 = TweenService:Create(Card, t1.FLY, {
            Position = UDim2.fromOffset(v6.X, v6.Y)
        })
        TweenService:Create(Pop, t1.FLY, {
            Scale = t1.LANDED
        }):Play()
    else
        v5 = TweenService:Create(Pop, t1.FADE, {
            Scale = 0
        })
    end

    v5.Completed:Once(function() -- line: 101
        -- upvalues: Dim (copy), Card (copy), Pop (copy), CardPosition (copy)
        Card.Visible = false
        Dim.Visible = false
        Card.Position = CardPosition
        Pop.Scale = 1
    end)
    v5:Play()
end

local v7 = false

local function scheduled(p1) -- line: 111
    -- upvalues: LocalPlayer (copy), PlayerGui (copy), t1 (copy), intro (copy), v7 (ref)
    local ServerRestartAt = workspace:GetAttribute("ServerRestartAt")

    if not ((type(ServerRestartAt) == "number" and ServerRestartAt - workspace:GetServerTimeNow() or 0) <= 0) then
        if p1 then
            if not v7 then
                v7 = true
                task.spawn(function() -- line: 116
                    -- upvalues: LocalPlayer (copy), PlayerGui (copy), t1 (copy), intro (copy), v7 (ref)
                    local elapsed = os.clock()

                    while (PlayerGui:FindFirstChild("LoadingGui") or LocalPlayer:GetAttribute("Cinematic")) and os.clock() - elapsed < t1.WAIT do
                        task.wait(0.25)
                    end

                    local ServerRestartAt = workspace:GetAttribute("ServerRestartAt")

                    if (type(ServerRestartAt) == "number" and ServerRestartAt - workspace:GetServerTimeNow() or 0) < t1.SKIP_UNDER then
                        LocalPlayer:SetAttribute("RestartRow", true)
                    else
                        intro()
                    end

                    v7 = false
                end)
            end
        else
            LocalPlayer:SetAttribute("RestartRow", true)
        end
    end
end

workspace:GetAttributeChangedSignal("ServerRestartAt"):Connect(function() -- line: 125
    -- upvalues: LocalPlayer (copy), PlayerGui (copy), t1 (copy), elapsed (copy), intro (copy), v7 (ref)
    local v8 = os.clock() - elapsed > 5 and not PlayerGui:FindFirstChild("LoadingGui")
    local ServerRestartAt = workspace:GetAttribute("ServerRestartAt")

    if not ((type(ServerRestartAt) == "number" and ServerRestartAt - workspace:GetServerTimeNow() or 0) <= 0) then
        if v8 then
            if not v7 then
                v7 = true
                task.spawn(function() -- line: 116
                    -- upvalues: LocalPlayer (copy), PlayerGui (copy), t1 (copy), intro (copy), v7 (ref)
                    local elapsed = os.clock()

                    while (PlayerGui:FindFirstChild("LoadingGui") or LocalPlayer:GetAttribute("Cinematic")) and os.clock() - elapsed < t1.WAIT do
                        task.wait(0.25)
                    end

                    local ServerRestartAt = workspace:GetAttribute("ServerRestartAt")

                    if (type(ServerRestartAt) == "number" and ServerRestartAt - workspace:GetServerTimeNow() or 0) < t1.SKIP_UNDER then
                        LocalPlayer:SetAttribute("RestartRow", true)
                    else
                        intro()
                    end

                    v7 = false
                end)
            end
        else
            LocalPlayer:SetAttribute("RestartRow", true)
        end
    end
end)

local ServerRestartAt = workspace:GetAttribute("ServerRestartAt")

if not ((type(ServerRestartAt) == "number" and ServerRestartAt - workspace:GetServerTimeNow() or 0) <= 0) then
    LocalPlayer:SetAttribute("RestartRow", true)
end
