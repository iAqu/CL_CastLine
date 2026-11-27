-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MoneyGui = PlayerGui:WaitForChild("MoneyGui")
local Money = MoneyGui:WaitForChild("Money")
local Amount = Money:WaitForChild("Amount")
local Pop = Money:WaitForChild("Pop")
local MoneyPop = MoneyGui:WaitForChild("MoneyPop")
local Format = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Format"))
local LevelRewards = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("LevelRewards"))
local Size = MoneyPop.Size

local function outBack(p1) -- line: 92
    local v1 = p1 - 1

    return 1 + 2.70158 * v1 * v1 * v1 + 1.70158 * v1 * v1
end

local UserId = LocalPlayer.UserId
local t1 = {}
local n1 = 0
local v2 = false
local t2, v3
local v4 = Money.Visible
local v5

local function setText(p2) -- line: 109
    -- upvalues: Amount (copy), Format (copy)
    Amount.Text = Format.money(p2)
end

local function stepPiece(p3, p4) -- line: 116
    local v6 = p4 - p3.t0

    if v6 >= 0.95 then
        p3.gui:Destroy()
        p3.anchor:Destroy()

        return false
    end

    local v7 = v6 / 0.95

    p3.gui.StudsOffset = Vector3.new(0, 3 * (1 - (1 - v7) ^ 2), 0)

    local v9, v10

    if v6 < 0.22 then
        local v11 = v6 / 0.22 - 1

        v9 = 1 + 2.70158 * v11 * v11 * v11 + 1.70158 * v11 * v11
        v10 = 0
    elseif v6 > 0.55 then
        local v12 = (v6 - 0.55) / 0.3999999999999999

        v10 = v12 * v12 * (3 - v12 * 2)
        v9 = v10 * -0.15000000000000002 + 1
    else
        v9 = 1
        v10 = 0
    end

    local Frame = p3.gui.Frame

    Frame.Scale.Scale = v9
    Frame.Text.TextTransparency = v10
    Frame.Text.UIStroke.Transparency = v10
    Frame.Icon.ImageTransparency = v10

    return true
end

local function step() -- line: 143
    -- upvalues: Amount (copy), Format (copy), t1 (copy), n1 (ref), t2 (ref), v3 (ref), stepPiece (copy)
    local elapsed = os.clock()

    if t2 then
        local v14 = math.min(1, (elapsed - t2.t0) / 0.35)

        n1 = t2.from + (t2.to - t2.from) * (1 - (1 - v14) ^ 3)

        local v15 = n1

        Amount.Text = Format.money(v15)

        if v14 >= 1 then
            n1 = t2.to
            t2 = nil
        end
    end

    for i = #t1, 1, -1 do
        if not stepPiece(t1[i], elapsed) then
            table.remove(t1, i)
        end
    end

    if t2 or #t1 ~= 0 or not v3 then
        return
    end

    v3:Disconnect()
    v3 = nil
end

local function ensureLoop() -- line: 163
    -- upvalues: RunService (copy), v3 (ref), step (copy)
    v3 = v3 or RunService.RenderStepped:Connect(step)
end

local function popCounter() -- line: 167
    -- upvalues: TweenService (copy), Pop (copy), v4 (ref)
    if v4 then
        Pop.Scale = 1.09
        TweenService:Create(Pop, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end

local function spawnPop(_, p6, p7, p8) -- line: 180
    -- upvalues: PlayerGui (copy), MoneyPop (copy), Format (copy), Size (copy), t1 (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.WorldPosition = p6.Position
    Attachment.Parent = workspace.Terrain

    local clone = MoneyPop:Clone()

    clone.Frame.Text.Text = "+" .. Format.money(p7)
    clone.Frame.Scale.Scale = 0

    local v17 = math.clamp((p8 or 1) ^ 0.5, 1, 1.6)

    clone.Size = UDim2.fromScale(Size.X.Scale * v17, Size.Y.Scale * v17)
    clone.Adornee = Attachment
    clone.Enabled = true
    clone.ResetOnSpawn = false
    clone.Parent = PlayerGui
    t1[#t1 + 1] = {
        gui = clone,
        anchor = Attachment,
        t0 = os.clock()
    }
end

local function payFish() -- line: 201
    -- upvalues: LocalPlayer (copy), LevelRewards (copy), UserId (copy), spawnPop (copy)
    local Fish = workspace:FindFirstChild("Fish")
    local CurrentCamera = workspace.CurrentCamera

    if Fish and CurrentCamera then
        local CFramePosition = CurrentCamera.CFrame.Position

        for _, child in ipairs(Fish:GetChildren()) do
            local PenOwner = child:GetAttribute("PenOwner")

            if PenOwner and PenOwner == UserId then
                local v18 = child:GetAttribute("Rate") or 0

                if PenOwner == UserId then
                    v18 *= 1 + LevelRewards.Money(LocalPlayer:GetAttribute("Level") or 1) / 100
                end

                local v19 = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")

                if v18 > 0 and v19 and (v19.Position - CFramePosition).Magnitude <= 250 then
                    spawnPop(child, v19, v18, child:GetAttribute("Size"))
                end
            end
        end
    end
end

local function cashChanged() -- line: 220
    -- upvalues: RunService (copy), LocalPlayer (copy), Amount (copy), Format (copy), n1 (ref), v2 (ref), t2 (ref), v3 (ref), step (copy), popCounter (copy)
    local Cash = LocalPlayer:GetAttribute("Cash")

    if Cash == nil then
        return
    end

    if v2 and not (Cash <= n1) then
        t2 = {
            from = n1,
            to = Cash,
            t0 = os.clock()
        }
        popCounter()
        v3 = v3 or RunService.RenderStepped:Connect(step)

        return
    end

    v2 = true
    t2 = nil
    n1 = Cash
    Amount.Text = Format.money(Cash)
end

LocalPlayer:GetAttributeChangedSignal("IncomeTick"):Connect(function() -- line: 236
    -- upvalues: RunService (copy), v3 (ref), step (copy), payFish (copy)
    payFish()
    v3 = v3 or RunService.RenderStepped:Connect(step)
end)

local function refreshSlot() -- line: 248
    -- upvalues: TweenService (copy), LocalPlayer (copy), Money (copy), Pop (copy), v4 (ref), v5 (ref)
    local v20 = (LocalPlayer:GetAttribute("HudSlot") or "Both") == "Both"

    if v20 == v4 then
        return
    end

    v4 = v20

    if v5 then
        v5:Cancel()
        v5 = nil
    end

    if v20 then
        Money.Visible = true
        Pop.Scale = 0.6
        TweenService:Create(Pop, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    else
        v5 = TweenService:Create(Pop, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = 0
        })
        v5:Play()
        v5.Completed:Once(function(p9) -- line: 264
            -- upvalues: Money (copy), v4 (ref)
            if p9 == Enum.PlaybackState.Completed and not v4 then
                Money.Visible = false
            end
        end)
    end
end

LocalPlayer:GetAttributeChangedSignal("HudSlot"):Connect(refreshSlot)
MoneyGui:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 273
    -- upvalues: TweenService (copy), MoneyGui (copy), Pop (copy), v4 (ref)
    if MoneyGui.Enabled and v4 then
        Pop.Scale = 0.6
        TweenService:Create(Pop, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end
end)
LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(cashChanged)
refreshSlot()
cashChanged()
