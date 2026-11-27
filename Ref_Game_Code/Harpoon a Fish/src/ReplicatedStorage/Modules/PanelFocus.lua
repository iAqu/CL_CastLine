-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local t1 = {
    FEEL = {
        FROM = 0.35,
        OPEN_TIME = 0.32,
        CLOSE_TIME = 0.2,
        BUTTON_OUT = 0.12,
        BUTTON_IN = 0.28,
        FOV_DROP = 20,
        ZOOM_OUT = 0.14,
        BLUR = 18,
        CINE_FADE = 0.4,
        OPEN_SOUND = "PanelOpen",
        CLOSE_SOUND = "PanelClose"
    }
}
local FEEL = t1.FEEL

t1.popIn = TweenInfo.new(FEEL.OPEN_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
t1.popOut = TweenInfo.new(FEEL.CLOSE_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In)

local v1 = TweenInfo.new(FEEL.BUTTON_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v2 = TweenInfo.new(FEEL.BUTTON_IN, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(FEEL.OPEN_TIME * 0.5801025079151212, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(FEEL.ZOOM_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

function t1.Sound(p1) -- line: 44
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v5 = HarpoonSFX and HarpoonSFX:FindFirstChild(p1)

    if v5 then
        v5:Play()
    end
end

local t2
local t3 = {}

local function slots() -- line: 53
    -- upvalues: PlayerGui (copy), t2 (ref)
    if t2 then
        return t2
    end

    t2 = {}

    local MenuButtons = PlayerGui:WaitForChild("MenuButtons")
    local SideButtons = PlayerGui:WaitForChild("SideButtons")
    local SmallRow = MenuButtons:WaitForChild("SmallRow")

    for _, v6 in ipairs({
            { MenuButtons, "ShopSlot", true },
            { MenuButtons, "CrateSlot", true },
            { MenuButtons, "IndexSlot", true },
            { SmallRow, "SettingsSlot", true },
            { SmallRow, "HarpoonSlot", true },
            { SideButtons, "FishSlot", false },
            { SideButtons, "FeedSlot", false },
            { SideButtons, "QuestSlot", false }
        }) do
        local v7 = v6[1]:WaitForChild(v6[2])
        local t4 = t2

        t4[#t2 + 1] = {
            slot = v7,
            scale = v7:WaitForChild("Scale"),
            left = v6[3]
        }
    end

    return t2
end

function t1.MakeWay(p2) -- line: 69
    -- upvalues: TweenService (copy), v1 (copy), t3 (copy), slots (copy)
    table.clear(t3)

    for _, v8 in ipairs((slots())) do
        if v8.slot.Visible then
            t3[#t3 + 1] = v8

            local tween = TweenService:Create(v8.scale, v1, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 75
                -- upvalues: p2 (copy), v8 (copy)
                if p2() then
                    v8.slot.Visible = false
                end
            end)
            tween:Play()
        end
    end
end

local t5 = {
    FishSlot = true,
    FeedSlot = true
}
local t6 = { "AquariumGui", "FeedGui" }

local function sidePanelUp() -- line: 89
    -- upvalues: PlayerGui (copy), t6 (copy)
    for _, v9 in ipairs(t6) do
        local v10 = PlayerGui:FindFirstChild(v9)
        local Panel = v10 and v10:FindFirstChild("Panel")

        if Panel and Panel.Visible then
            return true
        end
    end

    return false
end

function t1.GiveBack() -- line: 97
    -- upvalues: Players (copy), TweenService (copy), v2 (copy), t3 (copy), t5 (copy), sidePanelUp (copy)
    local v11 = Players.LocalPlayer:GetAttribute("LocalEating") == true
    local v12 = sidePanelUp()

    for _, v13 in ipairs(t3) do
        if (not v13.left or not v11) and (not v12 or not t5[v13.slot.Name]) then
            v13.slot.Visible = true
            v13.scale.Scale = 0
            TweenService:Create(v13.scale, v2, {
                Scale = 1
            }):Play()
        end
    end

    table.clear(t3)
end

function t1.Arrive() -- line: 112
    -- upvalues: TweenService (copy), v2 (copy), t3 (copy), slots (copy)
    for _, v14 in ipairs((slots())) do
        if v14.left and v14.slot.Visible and not table.find(t3, v14) then
            v14.scale.Scale = 0
            TweenService:Create(v14.scale, v2, {
                Scale = 1
            }):Play()
        end
    end
end

function t1.GiveBackRight() -- line: 122
    -- upvalues: t3 (copy)
    for _, v15 in ipairs(t3) do
        if not v15.left then
            v15.slot.Visible = true
            v15.scale.Scale = 1
        end
    end

    table.clear(t3)
end

local BlurEffect = Instance.new("BlurEffect")

BlurEffect.Name = "PanelBlur"
BlurEffect.Size = 0
BlurEffect.Enabled = false

local t7 = {}

t7[1] = nil

local t8 = {}
local t9 = {
    "HUD",
    "MoneyGui"
}
local t10 = {
    ImageLabel = { "ImageTransparency", "BackgroundTransparency" },
    ImageButton = { "ImageTransparency", "BackgroundTransparency" },
    TextLabel = { "TextTransparency", "BackgroundTransparency" },
    TextButton = { "TextTransparency", "BackgroundTransparency" },
    Frame = { "BackgroundTransparency" },
    UIStroke = { "Transparency" }
}
local v16

local function fadeHud(p3, p4) -- line: 147
    -- upvalues: TweenService (copy), PlayerGui (copy), t8 (ref), t9 (copy), t10 (copy), v16 (ref)
    if p3 then
        v16 = v16 or {}

        if #v16 == 0 then
            for _, v17 in ipairs(t9) do
                local v18 = PlayerGui:FindFirstChild(v17)

                for _, v19 in ipairs(v18 and v18:GetChildren() or {}) do
                    if v19:IsA("GuiObject") then
                        local Descendants = v19:GetDescendants()

                        table.insert(Descendants, v19)

                        for _, v20 in ipairs(Descendants) do
                            for _, v21 in ipairs(t10[v20.ClassName] or {}) do
                                if v20[v21] < 1 then
                                    local v22 = v16

                                    v22[#v16 + 1] = {
                                        v20,
                                        v21,
                                        v20[v21]
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end

        for _, v23 in ipairs(v16) do
            local t11 = {}

            t11[v23[2]] = 1

            local t12 = t8

            t12[#t8 + 1] = TweenService:Create(v23[1], p4, t11)
        end
    elseif v16 then
        for _, v24 in ipairs(v16) do
            if v24[1].Parent then
                if p4 then
                    local t13 = {}

                    t13[v24[2]] = v24[3]

                    local t14 = t8

                    t14[#t8 + 1] = TweenService:Create(v24[1], p4, t13)
                else
                    v24[1][v24[2]] = v24[3]
                end
            end
        end

        v16 = nil
    end
end

function t1.Focus(p5, p6) -- line: 190
    -- upvalues: Players (copy), TweenService (copy), FEEL (copy), v3 (copy), v4 (copy), BlurEffect (copy), t7 (copy), t8 (ref), v16 (ref), fadeHud (copy)
    Players.LocalPlayer:SetAttribute("PanelOpen", p5 or nil)

    local CurrentCamera = workspace.CurrentCamera

    for _, v25 in ipairs(t8) do
        v25:Cancel()
    end

    table.clear(t8)
    BlurEffect.Parent = CurrentCamera

    if p5 then
        t7[1] = t7[1] or CurrentCamera.FieldOfView
        BlurEffect.Enabled = true
        t8 = {
            TweenService:Create(CurrentCamera, v3, {
                FieldOfView = if Players.LocalPlayer:GetAttribute("SetReduceFx") == true then t7[1] or t7[1] - FEEL.FOV_DROP else t7[1] - FEEL.FOV_DROP
            }),
            TweenService:Create(BlurEffect, v3, {
                Size = FEEL.BLUR
            })
        }
        fadeHud(true, v3)
    elseif t7[1] then
        if p6 then
            CurrentCamera.FieldOfView = t7[1]
            BlurEffect.Size = 0
            BlurEffect.Enabled = false
            t7[1] = nil

            if v16 then
                for _, v30 in ipairs(v16) do
                    if v30[1].Parent then
                        v30[1][v30[2]] = v30[3]
                    end
                end

                v16 = nil
            end

            return
        end

        local v31 = t7[1]

        t7[1] = nil
        t8 = {
            TweenService:Create(CurrentCamera, v4, {
                FieldOfView = v31
            }),
            TweenService:Create(BlurEffect, v4, {
                Size = 0
            })
        }
        t8[2].Completed:Once(function(p7) -- line: 221
            -- upvalues: BlurEffect (copy)
            if p7 == Enum.PlaybackState.Completed then
                BlurEffect.Enabled = false
            end
        end)
        fadeHud(false, v4)
    end

    for _, v32 in ipairs(t8) do
        v32:Play()
    end
end

local LocalPlayer = Players.LocalPlayer

LocalPlayer:GetAttributeChangedSignal("Cinematic"):Connect(function() -- line: 234
    -- upvalues: TweenService (copy), FEEL (copy), BlurEffect (copy), t7 (copy), LocalPlayer (copy)
    local v33, v34

    if LocalPlayer:GetAttribute("Cinematic") then
        v34 = false
    elseif t7[1] then
        local BLUR = FEEL.BLUR

        if BLUR then
            v33 = BLUR
            v34 = true
        else
            v34 = false
        end
    else
        v34 = false
    end

    if not v34 then
        v33 = 0
    end

    if v33 == BlurEffect.Size then
        return
    end

    if v33 > 0 then
        BlurEffect.Enabled = true
    end

    local tween = TweenService:Create(BlurEffect, TweenInfo.new(FEEL.CINE_FADE, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Size = v33
    })

    tween.Completed:Once(function(p8) -- line: 239
        -- upvalues: v33 (ref), BlurEffect (copy)
        if p8 == Enum.PlaybackState.Completed and v33 == 0 then
            BlurEffect.Enabled = false
        end
    end)
    tween:Play()
end)

return t1
