-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local PlotHead = PlayerGui:WaitForChild("HUD"):WaitForChild("PlotHead")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local PassPerks = require(Modules:WaitForChild("PassPerks"))
local Loc = require(Modules:WaitForChild("Loc"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local Plots = workspace:WaitForChild("Plots")
local t1 = {
    TIP = 7.08,
    LIFT = 27,
    BOB = 0.9,
    BOB_TIME = 1.7,
    SCAN = 1,
    POP = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}
local Ring = PlotHead.Holder.Ring
local t2 = {
    grad = Ring.UIGradient.Color,
    stroke = Ring.UIStroke.Color,
    face = Ring.Face.UIStroke.Color,
    name = PlotHead.Holder.Island.Grad.Color
}
local t3 = {
    grad = PassPerks.VIP_GRADIENT,
    stroke = PassPerks.VIP_STROKE,
    face = PassPerks.VIP_STROKE,
    name = PassPerks.VIP_GRADIENT
}

local function islandOf(p1) -- line: 49
    -- upvalues: Loc (copy)
    local DisplayName = p1.DisplayName

    if DisplayName:sub(-1):lower() == "s" then
        return Loc.F("plot.island_s", "{name}' Island", {
            name = DisplayName
        })
    end

    return Loc.F("plot.island", "{name}'s Island", {
        name = DisplayName
    })
end

local t4 = {}

local function dress(p2) -- line: 59
    -- upvalues: PassPerks (copy), t2 (copy), t3 (copy)
    local v1 = if p2.owner and PassPerks.Owns(p2.owner, "VIP") and t3 then t3 else t2

    p2.ring.UIGradient.Color = v1.grad
    p2.ring.UIStroke.Color = v1.stroke
    p2.face.UIStroke.Color = v1.face
    p2.island.Grad.Color = v1.name
    p2.island.UIStroke.Color = v1.stroke
end

local function boardOf(p3) -- line: 68
    -- upvalues: TweenService (copy), PlayerGui (copy), PlotHead (copy), t1 (copy), t4 (copy)
    local v2 = t4[p3]

    if v2 then
        return v2
    end

    local Part = Instance.new("Part")

    Part.Name = "PlotHeadAnchor_" .. p3.Name
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part.Parent = workspace

    local clone = PlotHead:Clone()

    clone.Name = "PlotHead_" .. p3.Name
    clone.Adornee = Part
    clone.Enabled = false
    clone.Parent = PlayerGui

    local Holder = clone.Holder
    local t5 = {
        gui = clone,
        anchor = Part,
        ring = Holder.Ring,
        face = Holder.Ring.Face,
        pop = Holder.Pop,
        island = Holder.Island
    }

    TweenService:Create(clone, TweenInfo.new(t1.BOB_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        StudsOffset = Vector3.new(0, t1.BOB, 0)
    }):Play()
    t4[p3] = t5

    return t5
end

local function scan() -- line: 90
    -- upvalues: Players (copy), TweenService (copy), ShopConfig (copy), Plots (copy), t1 (copy), islandOf (copy), dress (copy), boardOf (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        local v4 = boardOf(child)
        local Harpoon = child:FindFirstChild("Harpoon")
        local SurfaceTop = Harpoon and Harpoon:GetAttribute("SurfaceTop")

        if typeof(SurfaceTop) == "CFrame" and SurfaceTop ~= v4.rest then
            v4.rest = SurfaceTop
            v4.anchor.CFrame = CFrame.new(SurfaceTop.Position + Vector3.new(0, t1.TIP + t1.LIFT, 0))
        end

        local PlayerByUserId = Players:GetPlayerByUserId(child:GetAttribute("OwnerUserId") or 0)

        if PlayerByUserId ~= v4.owner then
            if v4.conn then
                v4.conn:Disconnect()
                v4.conn = nil
            end

            v4.owner = PlayerByUserId

            if PlayerByUserId then
                v4.face.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(PlayerByUserId.UserId)
                v4.island.Text = islandOf(PlayerByUserId)
                v4.conn = PlayerByUserId:GetAttributeChangedSignal(ShopConfig.PassAttr("VIP")):Connect(function() -- line: 108
                    -- upvalues: v4 (copy), dress (copy)
                    dress(v4)
                end)
                v4.pop.Scale = 0
                TweenService:Create(v4.pop, t1.POP, {
                    Scale = 1
                }):Play()
            end

            dress(v4)
        end

        local gui = v4.gui

        if PlayerByUserId ~= nil then
            gui.Enabled = v4.rest ~= nil
        else
            gui.Enabled = false
        end
    end
end

local v6 = t1.SCAN

RunService.Heartbeat:Connect(function(p4) -- line: 119
    -- upvalues: t1 (copy), scan (copy), v6 (ref)
    v6 += p4

    if not (v6 < t1.SCAN) then
        v6 = 0
        scan()
    end
end)
scan()
