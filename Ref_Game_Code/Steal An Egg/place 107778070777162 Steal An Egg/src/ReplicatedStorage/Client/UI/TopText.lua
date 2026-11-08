-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local GamepadService = game:GetService("GamepadService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local t1 = {
    Response_UI = true,
    Talk_UI = true
}
local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
local v2 = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
local Talk_UI, Response_UI, Option_UI = ReplicatedStorage.Assets.UI.Npcs.Talk_UI, ReplicatedStorage.Assets.UI.Npcs.Response_UI, ReplicatedStorage.Assets.UI.Npcs.Option_UI
local Response_Text = SoundService.Response_Text
local t2 = {}

task.wait(1)

local function jitter(p1) -- line: 36
    return 1 + math.random(-p1, p1) / 100
end

local function eachScript(p2, p3) -- line: 38
    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BaseScript") then
            p3(descendant)
        end
    end
end

local function switchOn(p4) -- line: 46
    p4.Enabled = true
end

local function discard(p5) -- line: 48
    p5:Destroy()
end

local function revealNpcText(p6, p7) -- line: 50
    -- upvalues: SoundService (copy)
    local v4 = string.len((p6.Text:gsub("<.->", "")))
    local v5 = p7 and SoundService.NPC_SFX:FindFirstChild(p7) or SoundService.NPC_Text

    p6.MaxVisibleGraphemes = 0

    while v4 >= 1 do
        task.wait()

        if v5.TimePosition > 0.07 or v5.Playing == false then
            v5.TimePosition = 0
            v5.Playing = true
            v5.PlaybackSpeed = 1 + math.random(-5, 5) / 100
        end

        v4 -= 1
        p6.MaxVisibleGraphemes += 1
    end
end

local function revealPlayerText(p8) -- line: 69
    -- upvalues: Debris (copy), SoundService (copy), Response_Text (copy)
    local v7 = string.len((p8.Text:gsub("<.->", "")))

    p8.MaxVisibleGraphemes = 0

    local v8 = v7

    while v8 >= 1 do
        task.wait()

        if math.floor(v8 / 3) * 3 == v8 or v8 == v7 then
            local clone = Response_Text:Clone()

            clone.Parent = SoundService
            clone.Name = "SFX"
            clone.PlaybackSpeed = 1 + math.random(-15, 15) / 100
            clone.Playing = true
            Debris:AddItem(clone, clone.TimeLength * clone.PlaybackSpeed)
        end

        v8 -= 1
        p8.MaxVisibleGraphemes += 1
    end
end

local function restockScripts(p9, p10, p11) -- line: 91
    for _, descendant in p9:GetDescendants() do
        if descendant:IsA("BaseScript") then
            for _, descendant2 in p10:GetDescendants() do
                if descendant2.Name == descendant.Parent.Name then
                    if p11 then
                        descendant.Enabled = false
                    end

                    local clone = descendant:Clone()

                    clone.Parent = descendant2
                    clone.Enabled = true
                end
            end
        end
    end
end

local function raiseBubble(p12, p13, p14, p15, p16, p17, p18) -- line: 113
    -- upvalues: Talk_UI (copy), eachScript (copy), switchOn (copy), discard (copy), revealNpcText (copy), revealPlayerText (copy), restockScripts (copy)
    local Head = p13.Head
    local v10 = Head:FindFirstChild(Talk_UI.Name)
    local v11 = p15 == true
    local v12

    if v10 ~= nil then
        v12 = v10

        if v11 then
            eachScript(v10, discard)
        end
    else
        v12 = p12:Clone()
        v12.Parent = Head
    end

    v12.TextLabel.Text = p14

    if p16 then
        revealNpcText(v12.TextLabel, p17)
    else
        revealPlayerText(v12.TextLabel)
    end

    if not v11 or v10 ~= nil then
        if v11 then
            restockScripts(p12, v12, p18)
        end
    else
        eachScript(v12, switchOn)
    end

    return v12
end

local function clearSideFrame(p19) -- line: 150
    for _, child in p19.PlayerGui.Billboard_UI:GetChildren() do
        if child.Name ~= "UIListLayout" then
            child:Destroy()
        end
    end
end

function t2.Speak(p20, p21, p22) -- line: 158
    -- upvalues: Talk_UI (copy), raiseBubble (copy)
    return (raiseBubble(Talk_UI, p20, p21, p22, true, p20.Name, false))
end

function t2.Reply(p23, p24, p25) -- line: 162
    -- upvalues: Talk_UI (copy), raiseBubble (copy)
    return (raiseBubble(Talk_UI, p23, p24, p25, true, nil, true))
end

function t2.Echo(p26, p27, p28) -- line: 166
    -- upvalues: Response_UI (copy), raiseBubble (copy)
    if p27 == nil then
        return
    end

    return (raiseBubble(Response_UI, p26, p27, p28, false, nil, true))
end

function t2.OfferChoices(p29, p30) -- line: 174
    -- upvalues: Debris (copy), GamepadService (copy), TweenService (copy), v1 (copy), Option_UI (copy)
    local t3 = {}
    local n1 = 0

    for _, v13 in pairs(p30) do
        n1 += 1

        local clone = Option_UI:Clone()

        clone.Parent = p29.PlayerGui.Billboard_UI
        clone.Frame.Frame.Text_Element.Text = v13
        clone.Frame.Frame.TextLabel.Text = tostring(n1) .. "."

        local UIPadding = clone.Frame.Frame.Text_Element.UIPadding

        UIPadding.PaddingLeft = UDim.new(string.len(v13) * 0.001 + 0.04, 0)

        local tween = TweenService:Create(UIPadding, v1, {
            PaddingLeft = UDim.new(0, 0)
        })

        tween:Play()
        Debris:AddItem(tween, v1.Time)
        table.insert(t3, clone)
        clone.Frame.Frame.Text_Element:SetAttribute("Text", v13)
        task.wait(0.075)
    end

    if t3[1] then
        GamepadService:EnableGamepadCursor(t3[1])
    end

    return t3
end

function t2.FadeOut(p31, p32) -- line: 203
    -- upvalues: Debris (copy), TweenService (copy), t1 (copy), v2 (copy), clearSideFrame (copy)
    clearSideFrame(p32)

    for _, child in p31.Head:GetChildren() do
        if child:IsA("BillboardGui") and t1[child.Name] then
            for _, child in child:GetChildren() do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, v2, {
                        TextTransparency = 1
                    }):Play()
                elseif child:IsA("ImageLabel") then
                    TweenService:Create(child, v2, {
                        ImageTransparency = 1
                    }):Play()
                end
            end

            Debris:AddItem(child, v2.Time)
        end
    end
end

function t2.ClearChoices(p33) -- line: 221
    -- upvalues: GamepadService (copy), clearSideFrame (copy)
    clearSideFrame(p33)
    GamepadService:DisableGamepadCursor()
end

return t2
