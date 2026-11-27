-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local Toast = require(Modules:WaitForChild("Toast"))
local VFXBurst = require(Modules:WaitForChild("VFXBurst"))
local HarpoonSkins = require(Modules:WaitForChild("HarpoonSkins"))
local GunSkins = require(Modules:WaitForChild("GunSkins"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local PassPerks = require(Modules:WaitForChild("PassPerks"))
local Loc = require(Modules:WaitForChild("Loc"))
local InputMode = require(Modules:WaitForChild("InputMode"))
local ContextActionService = game:GetService("ContextActionService")
local LocalPlayer = Players.LocalPlayer
local DiveGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("DiveGui")
local Dive = DiveGui:WaitForChild("Dive")
local Equip = DiveGui:WaitForChild("Equip")
local HarpoonEquip = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("HarpoonEquip")
local GunEquip = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GunEquip")
local Plots = workspace:WaitForChild("Plots")
local t1 = {
    CHECK_EVERY = 0.2,
    SIZE = 0.8,
    GAP = 0.012,
    FROM = 0.35,
    BURST = 0.6,
    POP_IN = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    POP_OUT = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    QUIP_GOLD = Color3.fromRGB(255, 210, 74)
}

ButtonHover.Attach(Equip, {
    shine = false,
    highlight = true
})

local HoverScale = Equip:WaitForChild("HoverScale")
local v1 = false
local v2
local ImageLabel = Instance.new("ImageLabel")

ImageLabel.Name = "PadKey"
ImageLabel.BackgroundTransparency = 1
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.fromScale(0.2, 0.5)
ImageLabel.Size = UDim2.fromScale(1, 0.56)
ImageLabel.ZIndex = Equip.ZIndex + 3

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
UIAspectRatioConstraint.Parent = ImageLabel
ImageLabel.Parent = Equip

local function dressPad() -- line: 71
    -- upvalues: InputMode (copy), ImageLabel (copy)
    ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonY)
    ImageLabel.Visible = InputMode.Pad()
end

InputMode.Changed:Connect(dressPad)
ImageLabel.Image = InputMode.Icon(Enum.KeyCode.ButtonY)
ImageLabel.Visible = InputMode.Pad()

local function bindPad(p1) -- line: 79
    -- upvalues: ContextActionService (copy), v2 (ref)
    if p1 then
        ContextActionService:BindActionAtPriority("PadEquip", function(_, p3) -- line: 81
            -- upvalues: v2 (ref)
            if p3 == Enum.UserInputState.Begin and v2 then
                v2()
            end

            return Enum.ContextActionResult.Sink
        end, false, 3000, Enum.KeyCode.ButtonY)
    else
        ContextActionService:UnbindAction("PadEquip")
    end
end

local GrowBurst = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("GrowBurst")

local function playSound(p4) -- line: 91
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v3 = HarpoonSFX and HarpoonSFX:FindFirstChild(p4)

    if v3 then
        v3:Play()
    end
end

local function unscaledHalf(p5) -- line: 98
    local UIScale = p5:FindFirstChildOfClass("UIScale")

    return p5.AbsoluteSize.Y / math.max(UIScale and UIScale.Scale or 1, 0.01) / 2
end

local function place() -- line: 103
    -- upvalues: DiveGui (copy), Dive (copy), Equip (copy), t1 (copy)
    Equip.Size = UDim2.fromScale(Dive.Size.X.Scale * t1.SIZE, Dive.Size.Y.Scale * t1.SIZE)

    local Offset = Dive.Position.Y.Offset
    local UIScale = Dive:FindFirstChildOfClass("UIScale")
    local v4 = Offset - Dive.AbsoluteSize.Y / math.max(UIScale and UIScale.Scale or 1, 0.01) / 2
    local new = UDim2.new
    local v5 = v4 - t1.GAP * DiveGui.AbsoluteSize.Y
    local UIScale2 = Equip:FindFirstChildOfClass("UIScale")

    Equip.Position = new(0.5, 0, 0, v5 - Equip.AbsoluteSize.Y / math.max(UIScale2 and UIScale2.Scale or 1, 0.01) / 2)
end

Dive:GetPropertyChangedSignal("Position"):Connect(place)
Dive:GetPropertyChangedSignal("Size"):Connect(place)

local function show() -- line: 111
    -- upvalues: TweenService (copy), SoundService (copy), ContextActionService (copy), Equip (copy), t1 (copy), HoverScale (copy), v1 (ref), v2 (ref), place (copy)
    if v1 then
        return
    end

    v1 = true
    ContextActionService:BindActionAtPriority("PadEquip", function(_, p7) -- line: 81
        -- upvalues: v2 (ref)
        if p7 == Enum.UserInputState.Begin and v2 then
            v2()
        end

        return Enum.ContextActionResult.Sink
    end, false, 3000, Enum.KeyCode.ButtonY)
    place()
    HoverScale.Scale = t1.FROM
    Equip.Visible = true

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local PanelOpen = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelOpen")

    if PanelOpen then
        PanelOpen:Play()
    end

    TweenService:Create(HoverScale, t1.POP_IN, {
        Scale = 1
    }):Play()
end

local function hide() -- line: 121
    -- upvalues: TweenService (copy), SoundService (copy), ContextActionService (copy), Equip (copy), t1 (copy), HoverScale (copy), v1 (ref)
    if not v1 then
        return
    end

    v1 = false
    ContextActionService:UnbindAction("PadEquip")

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local PanelClose = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelClose")

    if PanelClose then
        PanelClose:Play()
    end

    local tween = TweenService:Create(HoverScale, t1.POP_OUT, {
        Scale = t1.FROM
    })

    tween.Completed:Once(function() -- line: 127
        -- upvalues: Equip (copy), v1 (ref)
        if not v1 then
            Equip.Visible = false
        end
    end)
    tween:Play()
end

local function heldHarpoon() -- line: 132
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")

    return if Tool and (Tool:GetAttribute("HarpoonSkin") or Tool:GetAttribute("GunSkin")) then Tool else nil
end

local n1 = 0

RunService.Heartbeat:Connect(function(p8) -- line: 139
    -- upvalues: LocalPlayer (copy), Dive (copy), t1 (copy), show (copy), hide (copy), n1 (ref)
    n1 += p8

    if n1 < t1.CHECK_EVERY then
        return
    end

    n1 = 0

    if Dive.Visible then
        local Character = LocalPlayer.Character
        local Tool = Character and Character:FindFirstChildOfClass("Tool")

        if Tool and (Tool:GetAttribute("HarpoonSkin") or Tool:GetAttribute("GunSkin")) and Tool then
            show()

            return
        end
    end

    hide()
end)

v2 = function() -- line: 146
    -- upvalues: SoundService (copy), ButtonHover (copy), LocalPlayer (copy), Equip (copy), HarpoonEquip (copy), GunEquip (copy), v1 (ref)
    if not v1 then
        return
    end

    local Character = LocalPlayer.Character
    local Tool = Character and Character:FindFirstChildOfClass("Tool")

    if not (Tool and (Tool:GetAttribute("HarpoonSkin") or Tool:GetAttribute("GunSkin")) and Tool) then
        return
    end

    ButtonHover.Press(Equip)

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local EquipSound = HarpoonSFX and HarpoonSFX:FindFirstChild("EquipSound")

    if EquipSound then
        EquipSound:Play()
    end

    local Character2 = LocalPlayer.Character
    local Tool2 = Character2 and Character2:FindFirstChildOfClass("Tool")

    if (if Tool2 and (Tool2:GetAttribute("HarpoonSkin") or Tool2:GetAttribute("GunSkin")) then Tool2 else nil):GetAttribute("GunSkin") then
        GunEquip:FireServer()
    else
        HarpoonEquip:FireServer()
    end
end

Equip.Activated:Connect(v2)

local function pc(p9) -- line: 157
    return (string.format("%.2f", p9 * 100):gsub("%.?0+$", ""))
end

local function upgradedQuip(p10) -- line: 158
    -- upvalues: PassPerks (copy), Loc (copy), LocalPlayer (copy)
    local function v7() -- line: 159
        -- upvalues: LocalPlayer (copy)
        return game:GetService("HttpService"):JSONDecode(LocalPlayer:GetAttribute("HarpoonUps") or "{}")
    end

    local ok, result = pcall(v7)

    if ok then
        ok = type(result) == "table" and result[p10]
    end

    if type(ok) ~= "table" or not ((ok.amp or 0) > 0) and not ok.s1 and not ok.s2 then
        return nil
    end

    local v8 = PassPerks.MyHarpoonPerks(LocalPlayer, p10)
    local t2 = {}

    if v8.hits > 0 then
        local v9 = #t2 + 1
        local v10

        if v8.hits == 1 then
            v10 = Loc.F("harpoon.hit", "-{n} Hit", {
                n = "1"
            })

            if not v10 then
                v10 = Loc.F("harpoon.hits", "-{n} Hits", {
                    n = tostring(v8.hits)
                })
            end
        else
            v10 = Loc.F("harpoon.hits", "-{n} Hits", {
                n = tostring(v8.hits)
            })
        end

        t2[v9] = v10
    end

    if v8.instant then
        t2[#t2 + 1] = Loc.F("harpoon.instant", "Instant Catch")
    end

    if not v8.instant and v8.instantChance > 0 then
        local v11 = #t2 + 1
        local F = Loc.F
        local instantChance = v8.instantChance

        t2[v11] = F("harpoon.instantChance", "{p}% Instant Catch Chance", {
            p = string.format("%.2f", instantChance * 100):gsub("%.?0+$", "")
        })
    end

    if v8.life > 0 then
        local v12 = #t2 + 1
        local F = Loc.F
        local life = v8.life

        t2[v12] = F("harpoon.life", "{p}% Extra Life Chance", {
            p = string.format("%.2f", life * 100):gsub("%.?0+$", "")
        })
    end

    if v8.double > 0 then
        local v13 = #t2 + 1
        local F = Loc.F
        local double = v8.double

        t2[v13] = F("harpoon.double", "{p}% Double Catch Chance", {
            p = string.format("%.2f", double * 100):gsub("%.?0+$", "")
        })
    end

    if v8.size > 0 then
        local v14 = #t2 + 1
        local F = Loc.F
        local size = v8.size

        t2[v14] = F("harpoon.size", "+{p}% Size Bonus", {
            p = string.format("%.2f", size * 100):gsub("%.?0+$", "")
        })
    end

    if v8.reel < 1 then
        local v15 = #t2 + 1
        local F = Loc.F
        local v16 = 1 - v8.reel

        t2[v15] = F("harpoon.slower_pct", "{p}% Slower Minigame", {
            p = string.format("%.2f", v16 * 100):gsub("%.?0+$", "")
        })
    end

    if v8.luck > 1 then
        local v17 = #t2 + 1
        local F = Loc.F
        local v18 = v8.luck - 1

        t2[v17] = F("harpoon.luck", "+{p}% Mutation Chance", {
            p = string.format("%.2f", v18 * 100):gsub("%.?0+$", "")
        })
    end

    if #t2 == 0 then
        return nil
    end

    local v19 = table.remove(t2)

    if #t2 > 0 then
        v19 = table.concat(t2, ", ") .. " " .. Loc.T("and") .. " " .. v19 or v19
    end

    return v19 .. "!"
end

HarpoonEquip.OnClientEvent:Connect(function(p11, p12) -- line: 180
    -- upvalues: Toast (copy), VFXBurst (copy), HarpoonSkins (copy), RarityDisplay (copy), ShopConfig (copy), PassPerks (copy), Loc (copy), LocalPlayer (copy), Plots (copy), t1 (copy), GrowBurst (copy), hide (copy), upgradedQuip (copy)
    if p11 ~= "Equipped" then
        return
    end

    local v20 = HarpoonSkins.Get(p12)

    if v20 then
        local v21 = RarityDisplay[v20.rarity]

        Toast.Show("Equipped", v20.name .. "!", v21 and v21.color or Color3.new(1, 1, 1), nil, "equip")

        local v22 = upgradedQuip(p12)

        if v22 then
            Toast.ShowAbove(v22, t1.QUIP_GOLD)
        end

        local v23 = v22 ~= nil

        for _, v24 in ipairs({
                ShopConfig.LIMITED,
                ShopConfig.BONE_PACK
            }) do
            for _, v26 in ipairs(v24) do
                if not v23 and v26.harpoon == p12 and v26.equipQuip then
                    v23 = true
                    Toast.ShowAbove(v26.equipQuip, t1.QUIP_GOLD)
                end
            end
        end

        if not v23 and v20.equipQuip then
            v23 = true
            Toast.ShowAbove(v20.equipQuip, t1.QUIP_GOLD)
        end

        local luck = PassPerks.HarpoonPerks(p12).luck

        if not v23 and luck > 1 then
            Toast.ShowAbove(Loc.F("harpoon.luck_quip", "+{p}% Mutation Chance!", {
                p = tostring((math.floor((luck - 1) * 100 + 0.5)))
            }), t1.QUIP_GOLD)
        end

        for _, child in ipairs(Plots:GetChildren()) do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                local v29 = child:FindFirstChild("Harpoon") and child.Harpoon:FindFirstChild("Spear")

                if v29 then
                    VFXBurst.Play(GrowBurst, v29:GetPivot(), t1.BURST)
                end
            end
        end

        hide()
    end
end)
GunEquip.OnClientEvent:Connect(function(p13, p14) -- line: 219
    -- upvalues: Toast (copy), VFXBurst (copy), GunSkins (copy), RarityDisplay (copy), LocalPlayer (copy), Plots (copy), t1 (copy), GrowBurst (copy), hide (copy)
    if p13 ~= "Equipped" then
        return
    end

    local v30 = GunSkins.Get(p14)

    if v30 then
        local v31 = RarityDisplay[v30.rarity]

        Toast.Show("Equipped", v30.name .. "!", v31 and v31.color or Color3.new(1, 1, 1), nil, "equip")

        for _, child in ipairs(Plots:GetChildren()) do
            if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                local v32 = child:FindFirstChild("Harpoon") and child.Harpoon:FindFirstChild("TopRotate")

                if v32 then
                    VFXBurst.Play(GrowBurst, v32:GetPivot(), t1.BURST * 2)
                end
            end
        end

        hide()
    end
end)
