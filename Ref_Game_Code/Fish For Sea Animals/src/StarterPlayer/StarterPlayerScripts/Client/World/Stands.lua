-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Robux = require(script.Parent.Parent.Shop.Robux)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    "RodStand",
    "Mailbox"
}
local v1 = Color3.fromRGB(80, 215, 90)
local v2 = Color3.fromRGB(225, 65, 75)
local v3 = Color3.fromRGB(130, 130, 140)
local t3 = {}
local SurfaceGui, connection, ProximityPrompt

local function affordColor(p1) -- line: 36
    -- upvalues: LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy)
    if not p1 then
        return v3
    end

    if p1 <= (LocalPlayer:GetAttribute("Money") or 0) then
        return v1
    end

    return v2
end

local function myPlot() -- line: 44
    -- upvalues: Config (copy), LocalPlayer (copy)
    return Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
end

local function refreshPenColor() -- line: 48
    -- upvalues: Config (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy)
    for _, v4 in Config.allPlots() do
        local v5 = v4:GetAttribute("OwnerUserId") == LocalPlayer.UserId and v4:FindFirstChild("PenUpgrade")

        v5 = v5 and v5:FindFirstChild("Board") and v5.Board:FindFirstChild("Info")

        local Button = v5 and v5:FindFirstChild("Button")

        if Button then
            local v6 = Config.penNextPrice(LocalPlayer:GetAttribute("PenLevel") or 1, LocalPlayer:GetAttribute("TankBoost") or 0, LocalPlayer:GetAttribute("LegacyPrices") == true)

            if v6 then
                if v6 <= (LocalPlayer:GetAttribute("Money") or 0) then
                    Button.BackgroundColor3 = v1
                else
                    Button.BackgroundColor3 = v2
                end
            else
                Button.BackgroundColor3 = v3
            end
        end
    end
end

local function refreshBarbellPrompt(p2) -- line: 64
    -- upvalues: Config (copy), Remotes (copy), LocalPlayer (copy), ProximityPrompt (ref)
    local v7 = ProximityPrompt and ProximityPrompt.Parent

    if not (not ProximityPrompt or p2 and v7 and v7.Parent == p2) then
        v7:Destroy()
        ProximityPrompt = nil
    end

    if not p2 then
        return
    end

    if not ProximityPrompt then
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "BuyPrompt"
        Attachment.Parent = p2
        Attachment.WorldPosition = p2.Position + Vector3.new(0, 0.5, 0)

        local ProximityPrompt2 = Instance.new("ProximityPrompt")

        ProximityPrompt2.HoldDuration = 0
        ProximityPrompt2.MaxActivationDistance = 14
        ProximityPrompt2.RequiresLineOfSight = false
        ProximityPrompt2.Triggered:Connect(function() -- line: 82
            -- upvalues: Remotes (copy)
            Remotes.UpgradeBarbell:FireServer()
        end)
        ProximityPrompt2.Parent = Attachment
        ProximityPrompt = ProximityPrompt2
    end

    local v8 = (LocalPlayer:GetAttribute("BarbellTier") or 1) + 1
    local v9 = Config.Barbells[v8]
    local Character = LocalPlayer.Character
    local v10 = Character ~= nil and Character:GetAttribute("Lifting") == true
    local ProximityPrompt2 = ProximityPrompt

    if v9 ~= nil then
        ProximityPrompt2.Enabled = not v10
    else
        ProximityPrompt2.Enabled = false
    end

    local ProximityPrompt3 = ProximityPrompt

    ProximityPrompt3.ActionText = not (v9 and v9.Price == 0) and "Upgrade" or "Claim FREE"

    local ProximityPrompt4 = ProximityPrompt

    if v9 then
        ProximityPrompt4.ObjectText = ("Barbell Tier %*"):format(v8)
    else
        ProximityPrompt4.ObjectText = ""
    end
end

local function refreshButton() -- line: 97
    -- upvalues: Config (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), refreshPenColor (copy), refreshBarbellPrompt (copy)
    local v11 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local Button

    for _, v12 in Config.allPlots() do
        local v13 = v12:GetAttribute("OwnerUserId") == LocalPlayer.UserId and v12:FindFirstChild("BarbellUpgrade")
        local Button2 = v13 and v13:FindFirstChild("Button")

        if Button2 then
            local v14 = (LocalPlayer:GetAttribute("BarbellTier") or 1) + 1
            local v15 = if Config.Barbells[v14] then Config.barbellPrice(v14, LocalPlayer:GetAttribute("LegacyPrices") == true) else nil

            if v15 then
                if v15 <= (LocalPlayer:GetAttribute("Money") or 0) then
                    Button2.Color = v1
                else
                    Button2.Color = v2
                end
            else
                Button2.Color = v3
            end

            if v12 == v11 then
                Button = Button2
            end
        end
    end

    refreshBarbellPrompt(Button)
    refreshPenColor()
end

local function refreshPenButton() -- line: 117
    -- upvalues: Config (copy), Remotes (copy), UIUtil (copy), Robux (copy), LocalPlayer (copy), SurfaceGui (ref), connection (ref), refreshPenColor (copy)
    local v16 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
    local PenUpgrade = v16 and v16:FindFirstChild("PenUpgrade")
    local Board = PenUpgrade and PenUpgrade:FindFirstChild("Board")

    if SurfaceGui and SurfaceGui.Adornee == Board then
        return
    end

    if SurfaceGui then
        SurfaceGui:Destroy()
        SurfaceGui = nil
    end

    local Info = Board and Board:FindFirstChild("Info")
    local Button = Info and Info:FindFirstChild("Button")

    if not Button then
        return
    end

    local SurfaceGui2 = Instance.new("SurfaceGui")

    SurfaceGui2.Name = "PenUpgradeHitbox"
    SurfaceGui2.Adornee = Board
    SurfaceGui2.Face = Info.Face
    SurfaceGui2.SizingMode = Info.SizingMode
    SurfaceGui2.PixelsPerStud = Info.PixelsPerStud
    SurfaceGui2.ResetOnSpawn = false

    local t4 = {}

    local function hitbox(p3, p4) -- line: 142
        -- upvalues: SurfaceGui2 (copy), t4 (copy), UIUtil (copy)
        local TextButton = Instance.new("TextButton")

        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.Parent = SurfaceGui2
        UIUtil.bindButton(TextButton, p4, p3)
        t4[TextButton] = p3
    end

    local function v17() -- line: 150
        -- upvalues: Remotes (copy)
        Remotes.UpgradePen:FireServer()
    end

    local TextButton = Instance.new("TextButton")

    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Parent = SurfaceGui2
    UIUtil.bindButton(TextButton, v17, Button)
    t4[TextButton] = Button

    local RobuxButton = Info:FindFirstChild("RobuxButton")

    if RobuxButton then
        local function v18() -- line: 155
            -- upvalues: Robux (copy)
            Robux.buy("NextPen")
        end

        local TextButton = Instance.new("TextButton")

        TextButton.Text = ""
        TextButton.BackgroundTransparency = 1
        TextButton.Parent = SurfaceGui2
        UIUtil.bindButton(TextButton, v18, RobuxButton)
        t4[TextButton] = RobuxButton
    end

    local function follow() -- line: 160
        -- upvalues: t4 (copy), RobuxButton (copy), Robux (copy)
        for v19, v20 in t4 do
            v19.AnchorPoint = v20.AnchorPoint
            v19.Position = v20.Position
            v19.Size = v20.Size
            v19.Visible = v20.Visible
        end

        if not RobuxButton then
            return
        end

        RobuxButton.Price.Text = tostring(Robux.price("NextPen"))
    end

    follow()
    SurfaceGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    SurfaceGui = SurfaceGui2

    if connection then
        connection:Disconnect()
    end

    connection = Button:WaitForChild("Price"):GetPropertyChangedSignal("Text"):Connect(function() -- line: 178
        -- upvalues: follow (copy), refreshPenColor (copy)
        task.defer(refreshPenColor)
        task.defer(follow)
    end)
    refreshPenColor()
end

local function refresh(p5) -- line: 185
    -- upvalues: LocalPlayer (copy), t2 (copy), t3 (copy), refreshButton (copy), refreshPenButton (copy)
    local v21 = p5:GetAttribute("OwnerUserId") == LocalPlayer.UserId
    local v22 = t3[p5] or {}

    t3[p5] = v22

    for _, v23 in t2 do
        if v21 then
            local v24 = v22[v23]

            if v24 then
                v22[v23] = nil
                v24.Parent = p5
            end
        else
            local v25 = p5:FindFirstChild(v23)

            if v25 then
                v22[v23] = v25
                v25.Parent = nil
            end
        end
    end

    refreshButton()
    refreshPenButton()
end

local function watch(p6) -- line: 208
    -- upvalues: t2 (copy), refresh (copy)
    p6:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- line: 209
        -- upvalues: p6 (copy), refresh (copy)
        refresh(p6)
    end)
    p6.ChildAdded:Connect(function(p7) -- line: 213
        -- upvalues: p6 (copy), t2 (copy), refresh (copy)
        if table.find(t2, p7.Name) or p7.Name == "PenUpgrade" then
            task.defer(refresh, p6)
        end
    end)
    refresh(p6)
end

function t1.init() -- line: 221
    -- upvalues: RunService (copy), Config (copy), LocalPlayer (copy), refreshButton (copy), refreshPenButton (copy), watch (copy)
    local Map = workspace:WaitForChild("Map")
    local t5 = { Map:WaitForChild("World1"):WaitForChild("Plots") }
    local v26 = Map:WaitForChild("World2", 10)
    local v27 = v26 and v26:WaitForChild("Plots", 10)

    if v27 then
        table.insert(t5, v27)
    end

    for _, v28 in t5 do
        v28.ChildAdded:Connect(watch)

        for _, child in v28:GetChildren() do
            watch(child)
        end
    end

    LocalPlayer:GetAttributeChangedSignal("World"):Connect(function() -- line: 236
        -- upvalues: refreshButton (copy), refreshPenButton (copy)
        refreshButton()
        refreshPenButton()
    end)
    RunService.Heartbeat:Connect(function() -- line: 240
        -- upvalues: Config (copy)
        local v31 = Vector3.new(0, 0.85 - (math.sin(os.clock() * 5) * 0.5 + 0.5) * 0.3, 0)

        for _, v32 in Config.allPlots() do
            local BarbellUpgrade = v32:FindFirstChild("BarbellUpgrade")
            local Display = BarbellUpgrade and BarbellUpgrade:FindFirstChild("Display")
            local Arrow = Display and Display:FindFirstChild("Arrow")

            if Arrow then
                Arrow.StudsOffset = v31
            end
        end
    end)
    LocalPlayer:GetAttributeChangedSignal("Money"):Connect(refreshButton)
    LocalPlayer:GetAttributeChangedSignal("BarbellTier"):Connect(refreshButton)
    LocalPlayer:GetAttributeChangedSignal("PenLevel"):Connect(refreshButton)
    LocalPlayer:GetAttributeChangedSignal("TankBoost"):Connect(refreshButton)

    local function watchCharacter(p8) -- line: 256
        -- upvalues: refreshButton (copy)
        p8:GetAttributeChangedSignal("Lifting"):Connect(refreshButton)
        refreshButton()
    end

    LocalPlayer.CharacterAdded:Connect(watchCharacter)

    if LocalPlayer.Character then
        LocalPlayer.Character:GetAttributeChangedSignal("Lifting"):Connect(refreshButton)
        refreshButton()
    end
end

return t1
