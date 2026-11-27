-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Format = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Format"))
local GrowthDisplay = require(ReplicatedStorage.Modules:WaitForChild("GrowthDisplay"))
local FishDisplay = require(ReplicatedStorage.Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(ReplicatedStorage.Modules:WaitForChild("RarityDisplay"))
local RarityStyle = require(ReplicatedStorage.Modules:WaitForChild("RarityStyle"))
local Loc = require(ReplicatedStorage.Modules:WaitForChild("Loc"))
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HoverTag = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HUD"):WaitForChild("HoverTag")
local t1 = {
    Boy = "rbxassetid://73180912046307",
    Girl = "rbxassetid://82539350511915"
}
local v1 = Vector2.new(HoverTag.Size.X.Scale, HoverTag.Size.Y.Scale)

local function paint(p1, p2) -- line: 66
    -- upvalues: RarityStyle (copy)
    p1.TextColor3 = p2
    p1.UIStroke.Color = RarityStyle.Glows(p2) and RarityStyle.StrokeOf(p2) or Color3.new(0, 0, 0)
end

local v2
local Attachment = Instance.new("Attachment")

Attachment.Name = "HoverAnchor"

local function show(p3) -- line: 79
    -- upvalues: Format (copy), GrowthDisplay (copy), FishDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Loc (copy), HoverTag (copy), t1 (copy), v1 (copy), v2 (ref), Attachment (copy)
    if p3 == v2 then
        return
    end

    v2 = p3

    if p3 then
        local ExtentsSize = p3:GetExtentsSize()
        local v5 = math.clamp(math.sqrt(math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z) / 12), 1, 8)

        HoverTag.Size = UDim2.fromScale(v1.X * v5, v1.Y * v5)

        local v6 = FishDisplay[p3.Name]
        local RarityDisplay2, v7, v8

        if v6 then
            local rarity = v6.rarity

            if rarity then
                RarityDisplay2 = RarityDisplay
                v7 = v6.shown or v6.rarity
                v8 = RarityDisplay2[v7]
            else
                v8 = rarity
            end
        else
            v8 = v6
        end

        HoverTag.Rarity.Text = v8 and Loc.T(v8.display) or ""

        if v8 then
            local Rarity = HoverTag.Rarity
            local color = v8.color

            Rarity.TextColor3 = color
            Rarity.UIStroke.Color = RarityStyle.Glows(color) and RarityStyle.StrokeOf(color) or Color3.new(0, 0, 0)
        end

        HoverTag.Icon.Image = t1[p3:GetAttribute("Gender")] or ""
        HoverTag.Kg.Text = Format.kg(p3:GetAttribute("Weight") or 0)

        local Stage = p3:GetAttribute("Stage")

        HoverTag.Stage.Text = Stage and GrowthDisplay.Span(Stage, nil, p3:GetAttribute("Inf")) or ""

        local v9 = Stage and GrowthDisplay.gradients[Stage]

        HoverTag.Stage.Grad.Enabled = v9 ~= nil

        if v9 then
            HoverTag.Stage.Grad.Color = v9
        end

        local v10 = p3.PrimaryPart or p3:FindFirstChildWhichIsA("BasePart")
        local TagOffset = p3:GetAttribute("TagOffset")

        if typeof(TagOffset) == "Vector3" then
            Attachment.Position = TagOffset * (p3:GetAttribute("Size") or 1)
            Attachment.Parent = v10
            HoverTag.Adornee = Attachment
        else
            Attachment.Parent = nil
            HoverTag.Adornee = v10
        end

        HoverTag.Enabled = true
    else
        HoverTag.Enabled = false
        HoverTag.Adornee = nil
        Attachment.Parent = nil
    end
end

local function hittable(p4) -- line: 120
    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = true
        end
    end
end

local t2 = {}

local function watch(p5) -- line: 131
    -- upvalues: hittable (copy), t2 (copy)
    if p5:GetAttribute("PenOwner") then
        hittable(p5)
    elseif not t2[p5] then
        t2[p5] = p5:GetAttributeChangedSignal("PenOwner"):Connect(function() -- line: 137
            -- upvalues: p5 (copy), hittable (copy), t2 (copy)
            local v11 = t2[p5]

            if v11 then
                v11:Disconnect()
                t2[p5] = nil
            end

            if p5:GetAttribute("PenOwner") then
                hittable(p5)
            end
        end)
    end
end

local function drop(p6) -- line: 147
    -- upvalues: t2 (copy)
    local v12 = t2[p6]

    if v12 then
        v12:Disconnect()
        t2[p6] = nil
    end
end

local Fish = workspace:WaitForChild("Fish")

for _, child in ipairs(Fish:GetChildren()) do
    watch(child)
end

Fish.ChildAdded:Connect(watch)
Fish.ChildRemoved:Connect(drop)

local v13 = false

if UserInputService.TouchEnabled then
    UserInputService.TouchStarted:Connect(function(_, p8) -- line: 165
        -- upvalues: v13 (ref)
        if not p8 then
            v13 = true
        end
    end)
    UserInputService.TouchEnded:Connect(function() -- line: 168
        -- upvalues: v13 (ref)
        v13 = false
    end)
end

local InputMode = require(ReplicatedStorage.Modules:WaitForChild("InputMode"))

if UserInputService.MouseEnabled or UserInputService.TouchEnabled then
    RunService.Heartbeat:Connect(function() -- line: 172
        -- upvalues: UserInputService (copy), Mouse (copy), HoverTag (copy), v2 (ref), Attachment (copy), show (copy), v13 (ref), InputMode (copy)
        if InputMode.Pad() then
            return
        end

        if UserInputService.MouseEnabled or v13 then
            local Target = Mouse.Target
            local v14 = Target and Target:FindFirstAncestorOfClass("Model")
            local PenOwner = v14 and v14:GetAttribute("PenOwner")
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local v15 = PenOwner ~= nil and PenOwner ~= LocalPlayer.UserId and (LocalPlayer:GetAttribute("SetOtherAquariums") == false or LocalPlayer:GetAttribute("Potato") == true)
            local v16, v17

            if PenOwner == nil or v15 then
                v17 = false
            elseif v14 then
                v16 = v14
                v17 = true
            else
                v17 = false
            end

            if not v17 then
                v16 = nil
            end

            show(v16)
        elseif v2 ~= nil then
            v2 = nil
            HoverTag.Enabled = false
            HoverTag.Adornee = nil
            Attachment.Parent = nil
        end
    end)
end

local v18 = RaycastParams.new()

v18.FilterType = Enum.RaycastFilterType.Exclude

local n1 = 0

RunService.Heartbeat:Connect(function(p9) -- line: 197
    -- upvalues: LocalPlayer (copy), show (copy), InputMode (copy), v18 (copy), n1 (ref)
    if not InputMode.Pad() then
        return
    end

    n1 += p9

    if not (n1 < 0.1) then
        n1 = 0

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            v18.FilterDescendantsInstances = { LocalPlayer.Character }

            local v19 = CurrentCamera:ViewportPointToRay(CurrentCamera.ViewportSize.X / 2, CurrentCamera.ViewportSize.Y / 2)
            local v20 = workspace:Raycast(v19.Origin, v19.Direction * 80, v18)
            local v21 = v20 and v20.Instance:FindFirstAncestorOfClass("Model")
            local PenOwner = v21 and v21:GetAttribute("PenOwner")
            local v22 = PenOwner ~= nil and PenOwner ~= LocalPlayer.UserId and (LocalPlayer:GetAttribute("SetOtherAquariums") == false or LocalPlayer:GetAttribute("Potato") == true)
            local v23, v24

            if PenOwner == nil or v22 then
                v24 = false
            elseif v21 then
                v23 = v21
                v24 = true
            else
                v24 = false
            end

            if not v24 then
                v23 = nil
            end

            show(v23)
        end
    end
end)
InputMode.Changed:Connect(function(p10) -- line: 213
    -- upvalues: HoverTag (copy), v2 (ref), Attachment (copy)
    if p10 or v2 == nil then
        return
    end

    v2 = nil
    HoverTag.Enabled = false
    HoverTag.Adornee = nil
    Attachment.Parent = nil
end)
