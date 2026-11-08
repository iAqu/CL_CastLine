-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local v1 = Color3.fromRGB(124, 255, 107)
local v2 = Color3.fromRGB(255, 255, 255)
local v3 = Color3.fromRGB(255, 120, 120)
local v4 = Color3.fromRGB(110, 255, 190)
local v5 = Color3.fromRGB(10, 60, 40)
local v6 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v7 = TryLock(8)
local t1 = {}

local function child(p1, p2) -- line: 41
    local v8 = p1:FindFirstChild(p2)

    assert(v8, (("%* needs a child named %*"):format(p1:GetFullName(), p2)))

    return v8
end

local function counts() -- line: 47
    -- upvalues: Save (copy)
    local v10 = if Save.IsLoaded() then Save.Peek() else nil
    local Butterflies = if v10 then v10.Butterflies else nil

    if typeof(Butterflies) == "table" then
        return Butterflies.Counts
    end

    return {
        Green = 0,
        Blue = 0,
        Purple = 0,
        Golden = 0
    }
end

local function setText(p3, p4, p5) -- line: 56
    if p3 and p3:IsA("TextLabel") then
        p3.Text = p4

        if p5 then
            p3.TextColor3 = p5
        end
    end
end

local function pop(p6) -- line: 65
    -- upvalues: TweenService (copy), v6 (copy)
    local PopScale = p6:FindFirstChild("PopScale")

    if PopScale == nil then
        PopScale = Instance.new("UIScale")
        PopScale.Name = "PopScale"
        PopScale.Parent = p6
    end

    PopScale.Scale = 1.12
    TweenService:Create(PopScale, v6, {
        Scale = 1
    }):Play()
end

local function deny(p7) -- line: 78
    -- upvalues: Audio (copy), ButterflyCatalog (copy), Toast (copy), v3 (copy)
    Audio.Play(ButterflyCatalog.Sounds.Deny, script, {
        Volume = 0.6
    })

    if p7 then
        Toast.Show({
            Lane = "Feed",
            Seconds = 2.5,
            Text = p7,
            Color = v3
        })
    end
end

local function request(p8) -- line: 85
    -- upvalues: v7 (copy)
    local v11, v12, v13, v14 = v7(function() -- line: 86
        -- upvalues: p8 (copy)
        local function v15() -- line: 87
            -- upvalues: p8 (copy)
            return p8:InvokeServer()
        end

        return pcall(v15)
    end)

    if v11 and v12 then
        local v16 = v13 == true

        if typeof(v14) == "string" then
            return v16, v14
        end

        return v16, nil
    end

    return false, nil
end

function t1.Start() -- line: 101
    -- upvalues: Audio (copy), ButterflyCatalog (copy), ButtonFX (copy), Flash (copy), GUI (copy), Remotes (copy), Save (copy), Tabs (copy), Toast (copy), v1 (copy), v2 (copy), v4 (copy), v5 (copy), v7 (copy), counts (copy), pop (copy), deny (copy)
    local EnchantedMutationShrine = GUI.Get("EnchantedMutationShrine")
    local Frame = EnchantedMutationShrine:FindFirstChild("Frame")

    assert(Frame, (("%* needs a child named Frame"):format((EnchantedMutationShrine:GetFullName()))))

    local ContentFrame = Frame:FindFirstChild("ContentFrame")

    assert(ContentFrame, (("%* needs a child named ContentFrame"):format((Frame:GetFullName()))))

    local RequirementsHolder = ContentFrame:FindFirstChild("RequirementsHolder")

    assert(RequirementsHolder, (("%* needs a child named RequirementsHolder"):format((ContentFrame:GetFullName()))))

    local Result = RequirementsHolder:FindFirstChild("Result")

    assert(Result, (("%* needs a child named Result"):format((RequirementsHolder:GetFullName()))))

    local Claim = ContentFrame:FindFirstChild("Claim")

    assert(Claim, (("%* needs a child named Claim"):format((ContentFrame:GetFullName()))))

    local VaultInComplete = ContentFrame:FindFirstChild("VaultInComplete")
    local ItemName = Result:FindFirstChild("ItemName")
    local EssenceName = ButterflyCatalog.EssenceName

    if ItemName and ItemName:IsA("TextLabel") then
        ItemName.Text = EssenceName
    end

    if VaultInComplete then
        local txt = VaultInComplete:FindFirstChild("txt")

        if txt and txt:IsA("TextLabel") then
            txt.Text = "Need More Butterflies"
        end
    end

    for _, v22 in ButterflyCatalog.Order do
        local v23 = RequirementsHolder:FindFirstChild(v22)

        if v23 then
            local ItemName = v23:FindFirstChild("ItemName")
            local DisplayName = ButterflyCatalog.Get(v22).DisplayName

            if ItemName and ItemName:IsA("TextLabel") then
                ItemName.Text = DisplayName
            end
        end
    end

    local function render() -- line: 121
        -- upvalues: RequirementsHolder (copy), Claim (copy), VaultInComplete (copy), ButterflyCatalog (copy), v1 (copy), v2 (copy), counts (copy)
        local v24 = counts()
        local v25 = ButterflyCatalog.EssenceRecipe()
        local v26 = true

        for _, v27 in ButterflyCatalog.Order do
            local v28 = v24[v27] or 0
            local v29 = v25[v27]
            local v30 = v29 <= v28

            v26 = v26 and v30

            local v31 = RequirementsHolder:FindFirstChild(v27)

            if v31 then
                local Quantity = v31:FindFirstChild("Quantity")
                local v32 = ("%*/%*"):format(math.min(v28, v29), v29)
                local v33 = if v30 then v1 else v2

                if Quantity and Quantity:IsA("TextLabel") then
                    Quantity.Text = v32

                    if v33 then
                        Quantity.TextColor3 = v33
                    end
                end
            end
        end

        Claim.Visible = v26 or VaultInComplete == nil

        if VaultInComplete then
            VaultInComplete.Visible = not v26
        end
    end

    ButtonFX(Claim)
    GUI.OnActivated(Claim, function() -- line: 146
        -- upvalues: Result (copy), Audio (copy), ButterflyCatalog (copy), Flash (copy), Remotes (copy), Toast (copy), v4 (copy), v5 (copy), v7 (copy), pop (copy), deny (copy)
        local AskCraftEssence = Remotes.Butterflies.AskCraftEssence
        local v34, v35, v36, v37 = v7(function() -- line: 86
            -- upvalues: AskCraftEssence (copy)
            local function v38() -- line: 87
                -- upvalues: AskCraftEssence (copy)
                return AskCraftEssence:InvokeServer()
            end

            return pcall(v38)
        end)
        local v39

        if v34 and v35 then
            v39 = v36 == true

            if typeof(v37) ~= "string" then
                v37 = nil
            end
        else
            v39 = false
            v37 = nil
        end

        if not v39 then
            deny(v37)

            return
        end

        Audio.Play(ButterflyCatalog.Sounds.Craft, script, {
            Volume = 0.85
        })
        Flash.Play({
            Attack = 0.05,
            Decay = 0.5,
            Opacity = 0.35,
            Tint = v4
        })
        pop(Result)
        Toast.Show({
            Lane = "Banner",
            Seconds = 3.5,
            ShowShadow = true,
            Text = ("You made an %*!"):format(ButterflyCatalog.EssenceName),
            Color = v4,
            StrokeColor = v5,
            Image = ButterflyCatalog.Icons.Essence
        })
    end)

    if VaultInComplete then
        ButtonFX(VaultInComplete)
        GUI.OnActivated(VaultInComplete, function() -- line: 167
            -- upvalues: deny (copy)
            deny("The altar needs more butterflies.")
        end)
    end

    Save.WatchFields("Butterflies", render)
    Tabs.Activated:Connect(function(p9) -- line: 173
        -- upvalues: render (copy)
        if p9 == "EnchantedMutationShrine" then
            render()
        end
    end)
    render()
end

return t1
