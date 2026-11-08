-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VisibleBounds = require(ReplicatedStorage.Shared.Utils.VisibleBounds)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Cash = ReplicatedStorage.Assets.Extra.Cash

assert(Cash:IsA("BillboardGui"), "Assets.Extra.Cash must be a BillboardGui")

local t1 = {}

local function playOnce(p1, p2, p3) -- line: 37
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, p2, p3)

    tween.Completed:Once(function() -- line: 39
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween:Play()
end

local function scaleBillboardSize(p4, p5) -- line: 45
    return UDim2.new(p4.X.Scale * p5, p4.X.Offset * p5, p4.Y.Scale * p5, p4.Y.Offset * p5)
end

local function getBillboardScale(p6) -- line: 54
    local v4 = math.min(p6.X / 2, p6.Y / 5.72646427154541, p6.Z / 5.299603462219238)

    if v4 <= 0 then
        return 0.9
    end

    return (math.clamp(v4, 0.9, 5))
end

local function fadeTextLabel(p7, p8, p9, p10) -- line: 67
    -- upvalues: TweenService (copy)
    p7.Text = p8
    p7.TextTransparency = 1

    local tween = TweenService:Create(p7, p9, {
        TextTransparency = 0
    })

    tween.Completed:Once(function() -- line: 39
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween:Play()
    task.delay(0.8499999999999999, function() -- line: 78
        -- upvalues: p7 (copy), p10 (copy), TweenService (copy)
        if p7.Parent then
            local tween = TweenService:Create(p7, p10, {
                TextTransparency = 1
            })

            tween.Completed:Once(function() -- line: 39
                -- upvalues: tween (copy)
                tween:Destroy()
            end)
            tween:Play()
        end
    end)
end

local function fadeTextButton(p11, p12, p13, p14) -- line: 87
    -- upvalues: TweenService (copy)
    p11.Text = p12
    p11.TextTransparency = 1

    local tween = TweenService:Create(p11, p13, {
        TextTransparency = 0
    })

    tween.Completed:Once(function() -- line: 39
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween:Play()
    task.delay(0.8499999999999999, function() -- line: 98
        -- upvalues: p11 (copy), p14 (copy), TweenService (copy)
        if p11.Parent then
            local tween = TweenService:Create(p11, p14, {
                TextTransparency = 1
            })

            tween.Completed:Once(function() -- line: 39
                -- upvalues: tween (copy)
                tween:Destroy()
            end)
            tween:Play()
        end
    end)
end

local function fadeTextBox(p15, p16, p17, p18) -- line: 107
    -- upvalues: TweenService (copy)
    p15.Text = p16
    p15.TextTransparency = 1

    local tween = TweenService:Create(p15, p17, {
        TextTransparency = 0
    })

    tween.Completed:Once(function() -- line: 39
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween:Play()
    task.delay(0.8499999999999999, function() -- line: 118
        -- upvalues: p15 (copy), p18 (copy), TweenService (copy)
        if p15.Parent then
            local tween = TweenService:Create(p15, p18, {
                TextTransparency = 1
            })

            tween.Completed:Once(function() -- line: 39
                -- upvalues: tween (copy)
                tween:Destroy()
            end)
            tween:Play()
        end
    end)
end

local function fadeImageObject(p19, p20, p21) -- line: 127
    -- upvalues: TweenService (copy)
    p19.ImageTransparency = 1

    local tween = TweenService:Create(p19, p20, {
        ImageTransparency = 0
    })

    tween.Completed:Once(function() -- line: 39
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween:Play()
    task.delay(0.8499999999999999, function() -- line: 137
        -- upvalues: p19 (copy), p21 (copy), TweenService (copy)
        if p19.Parent then
            local tween = TweenService:Create(p19, p21, {
                ImageTransparency = 1
            })

            tween.Completed:Once(function() -- line: 39
                -- upvalues: tween (copy)
                tween:Destroy()
            end)
            tween:Play()
        end
    end)
end

local function fadePopupDescendants(p22, p23, p24, p25) -- line: 146
    -- upvalues: TweenService (copy), fadeTextLabel (copy), fadeTextButton (copy), fadeTextBox (copy), fadeImageObject (copy)
    for _, descendant in ipairs(p22:GetDescendants()) do
        if descendant:IsA("TextLabel") then
            fadeTextLabel(descendant, p23, p24, p25)
        elseif descendant:IsA("TextButton") then
            fadeTextButton(descendant, p23, p24, p25)
        elseif descendant:IsA("TextBox") then
            fadeTextBox(descendant, p23, p24, p25)
        elseif descendant:IsA("UIStroke") then
            descendant.Transparency = 1

            local tween = TweenService:Create(descendant, p24, {
                Transparency = 0
            })

            tween.Completed:Once(function() -- line: 39
                -- upvalues: tween (copy)
                tween:Destroy()
            end)
            tween:Play()
            task.delay(0.8499999999999999, function() -- line: 164
                -- upvalues: p25 (copy), descendant (copy), TweenService (copy)
                if descendant.Parent then
                    local tween = TweenService:Create(descendant, p25, {
                        Transparency = 1
                    })

                    tween.Completed:Once(function() -- line: 39
                        -- upvalues: tween (copy)
                        tween:Destroy()
                    end)
                    tween:Play()
                end
            end)
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            fadeImageObject(descendant, p24, p25)
        end
    end
end

local function showAtCFrame(p26, p27, p28, p29, p30) -- line: 177
    -- upvalues: Debris (copy), TweenService (copy), Simple (copy), Cash (copy), fadePopupDescendants (copy)
    local Attachment = Instance.new("Attachment")

    Attachment.Name = "SyncedIncomeCashAttachment"
    Attachment.WorldCFrame = p26
    Attachment.Parent = workspace.Terrain

    local clone = Cash:Clone()

    clone.Name = "SyncedIncomeCash"
    clone.Adornee = Attachment
    clone.Parent = Attachment

    if not p28 or p28.alwaysOnTop == nil then
        clone.AlwaysOnTop = true
    else
        clone.AlwaysOnTop = p28.alwaysOnTop
    end

    local Size = clone.Size

    clone.Size = UDim2.new(Size.X.Scale * p30, Size.X.Offset * p30, Size.Y.Scale * p30, Size.Y.Offset * p30)
    fadePopupDescendants(clone, ("+$%*"):format((Simple.FormatCompact((math.round(p27))))), TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))

    local tween = TweenService:Create(Attachment, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        WorldPosition = p26.Position + Vector3.new(0, p29, 0)
    })

    tween.Completed:Once(function() -- line: 39
        -- upvalues: tween (copy)
        tween:Destroy()
    end)
    tween:Play()
    Debris:AddItem(clone, 1.4)
    Debris:AddItem(Attachment, 1.4)
end

function t1.Show(p31, p32, p33) -- line: 219
    -- upvalues: VisibleBounds (copy), Cash (copy), showAtCFrame (copy)
    local v6, v7 = VisibleBounds(p31)
    local v9 = v6 - Vector3.new(0, v7.Y / 1.5, 0)
    local v10 = assert(workspace.CurrentCamera, "Active asset income popup requires Workspace.CurrentCamera")
    local MaxDistance = Cash.MaxDistance

    if MaxDistance > 0 and MaxDistance < (v10.CFrame.Position - v9.Position).Magnitude then
        return
    end

    local v11 = v7.Y - v7.Y * 0.25
    local v15 = math.min(v7.X / 2, v7.Y / 5.72646427154541, v7.Z / 5.299603462219238)

    showAtCFrame(v9, p32, p33, v11, if v15 <= 0 then 0.9 else math.clamp(v15, 0.9, 5))
end

return t1
