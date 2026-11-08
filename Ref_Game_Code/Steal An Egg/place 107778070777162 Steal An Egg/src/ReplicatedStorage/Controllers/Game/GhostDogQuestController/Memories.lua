-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fx = require(script.Parent.Fx)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local GUI = require(ReplicatedStorage.Client.GUI)
local SurfaceButton = require(ReplicatedStorage.Client.UI.VFX.SurfaceButton)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local CollectSecretRing = ReplicatedStorage.Assets.Sounds.LightVsDarknessSounds.CollectSecretRing
local FFE15A = Color3.fromHex("FFE15A")
local DogsMemoriesFrame
local v1 = {}
local v2
local v3 = Trove.new()
local t1 = {}

local function screenOf() -- line: 33
    -- upvalues: GUI (copy), DogsMemoriesFrame (ref)
    local DogsMemoriesFrame2 = DogsMemoriesFrame

    if DogsMemoriesFrame2 and DogsMemoriesFrame2.Parent then
        return DogsMemoriesFrame2
    end

    local Get = GUI.Get
    local DogsMemoriesFrame3, DogsMemoriesFrame4 = pcall(Get, "DogsMemoriesFrame")

    if not DogsMemoriesFrame3 or DogsMemoriesFrame4 == nil then
        return nil
    end

    DogsMemoriesFrame = DogsMemoriesFrame4

    return DogsMemoriesFrame
end

local function mainOf(p1) -- line: 46
    return p1.Frame.Main
end

local function slotOf(p2, p3) -- line: 50
    local v4 = p2.Frame.Main.Slots:FindFirstChild((("Slot%*"):format(p3)))

    return if v4 and v4:IsA("Frame") then v4 else nil
end

local function selectedStrokeOf(p4) -- line: 55
    -- upvalues: FFE15A (copy)
    local SelectedStroke = p4:FindFirstChild("SelectedStroke")

    if SelectedStroke and SelectedStroke:IsA("UIStroke") then
        return SelectedStroke
    end

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Name = "SelectedStroke"
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = FFE15A
    UIStroke.Thickness = 3
    UIStroke.Transparency = 1
    UIStroke.Parent = p4

    return UIStroke
end

local function render(p5) -- line: 77
    -- upvalues: GhostDogQuest (copy), FFE15A (copy), v1 (ref), v2 (ref)
    for v5, v6 in GhostDogQuest.Artifacts do
        local v7 = p5.Frame.Main.Slots:FindFirstChild((("Slot%*"):format(v5)))

        if not (v7 and v7:IsA("Frame")) then
            v7 = nil
        end

        if v7 ~= nil then
            local v9 = v1
            local v8 = v9[v6.Id] == true
            local Unknown = v7:FindFirstChild("Unknown")
            local CompletedCheckmark = v7:FindFirstChild("CompletedCheckmark")

            if Unknown and Unknown:IsA("GuiObject") then
                Unknown.Visible = not v8
            end

            if CompletedCheckmark and CompletedCheckmark:IsA("GuiObject") then
                CompletedCheckmark.Visible = v8
            end

            local SelectedStroke = v7:FindFirstChild("SelectedStroke")

            if not (SelectedStroke and SelectedStroke:IsA("UIStroke")) then
                SelectedStroke = Instance.new("UIStroke")
                SelectedStroke.Name = "SelectedStroke"
                SelectedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                SelectedStroke.Color = FFE15A
                SelectedStroke.Thickness = 3
                SelectedStroke.Transparency = 1
                SelectedStroke.Parent = v7
            end

            SelectedStroke.Transparency = v6.Id == v2 and 0 or 1
        end
    end

    for _, v10 in GhostDogQuest.Artifacts do
        if v10.Id == v2 then
            local Hint = p5.Frame.Main:FindFirstChild("Hint")

            if Hint and Hint:IsA("TextLabel") then
                local v11 = v1

                if v11[v10.Id] == true then
                    Hint.Text = ("\"%*\""):format(v10.Found)
                else
                    Hint.Text = ("\"%*\""):format(v10.Hint)
                end
            end

            return
        end
    end
end

local function select(p6) -- line: 105
    -- upvalues: Fx (copy), GUI (copy), DogsMemoriesFrame (ref), v2 (ref), render (copy)
    local DogsMemoriesFrame2 = DogsMemoriesFrame

    if not (DogsMemoriesFrame2 and DogsMemoriesFrame2.Parent) then
        local Get = GUI.Get
        local DogsMemoriesFrame3, DogsMemoriesFrame4 = pcall(Get, "DogsMemoriesFrame")

        if not DogsMemoriesFrame3 or DogsMemoriesFrame4 == nil then
            DogsMemoriesFrame2 = nil
        else
            DogsMemoriesFrame = DogsMemoriesFrame4
            DogsMemoriesFrame2 = DogsMemoriesFrame
        end
    end

    if DogsMemoriesFrame2 == nil then
        return
    end

    local v12 = v2 ~= p6

    v2 = p6
    render(DogsMemoriesFrame2)

    local Hint = DogsMemoriesFrame2.Frame.Main:FindFirstChild("Hint")

    if v12 and Hint and Hint:IsA("TextLabel") then
        Hint.TextTransparency = 1
        Fx.Tween(Hint, 0.3, {
            TextTransparency = 0
        })
    end
end

local function bind(p7) -- line: 133
    -- upvalues: GhostDogQuest (copy), SurfaceButton (copy), select (copy)
    if p7:GetAttribute("GhostDogBound") == true then
        return
    end

    p7:SetAttribute("GhostDogBound", true)

    for v13, v14 in GhostDogQuest.Artifacts do
        local v15 = p7.Frame.Main.Slots:FindFirstChild((("Slot%*"):format(v13)))

        if not (v15 and v15:IsA("Frame")) then
            v15 = nil
        end

        if v15 ~= nil then
            SurfaceButton(v15, nil, function() -- line: 143
                -- upvalues: v14 (copy), select (copy)
                select(v14.Id)
            end)
        end
    end
end

function t1.IsOpen() -- line: 149
    -- upvalues: Tabs (copy)
    return Tabs.IsActive("DogsMemoriesFrame")
end

function t1.Open(p8) -- line: 153
    -- upvalues: GhostDogQuest (copy), GUI (copy), Tabs (copy), LocalPlayer (copy), DogsMemoriesFrame (ref), v1 (ref), v2 (ref), v3 (copy), t1 (copy), render (copy), bind (copy)
    local DogsMemoriesFrame2 = DogsMemoriesFrame

    if not (DogsMemoriesFrame2 and DogsMemoriesFrame2.Parent) then
        local Get = GUI.Get
        local DogsMemoriesFrame3, DogsMemoriesFrame4 = pcall(Get, "DogsMemoriesFrame")

        if not DogsMemoriesFrame3 or DogsMemoriesFrame4 == nil then
            DogsMemoriesFrame2 = nil
        else
            DogsMemoriesFrame = DogsMemoriesFrame4
            DogsMemoriesFrame2 = DogsMemoriesFrame
        end
    end

    if DogsMemoriesFrame2 == nil then
        return
    end

    bind(DogsMemoriesFrame2)

    local v16 = v2
    local v17

    if not v16 or v1[v2] == true then
        local v18 = false

        for _, v19 in GhostDogQuest.Artifacts do
            if v1[v19.Id] ~= true then
                v17 = v19.Id
                v18 = true
                break
            end
        end

        if not v18 then
            local v21 = GhostDogQuest.Artifacts[1]

            v17 = v21 and v21.Id
        end
    else
        v17 = v2
    end

    v2 = v17
    render(DogsMemoriesFrame2)
    Tabs.Activate("DogsMemoriesFrame")
    v3:Clean()
    v3:Add(task.spawn(function() -- line: 163
        -- upvalues: p8 (copy), Tabs (copy), LocalPlayer (copy), t1 (copy)
        while true do
            if t1.IsOpen() then
                task.wait(0.25)

                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if p8 and HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and (HumanoidRootPart.Position - p8.Position).Magnitude > 40 then
                    break
                end

                continue
            end

            return
        end

        Tabs.Deactivate()
    end))
end

function t1.Close() -- line: 181
    -- upvalues: Tabs (copy), v3 (copy), t1 (copy)
    v3:Clean()

    if t1.IsOpen() then
        Tabs.Deactivate()
    end
end

function t1.Sync(p9, p10) -- line: 188
    -- upvalues: DogsMemoriesFrame (ref), v1 (ref), t1 (copy), render (copy)
    v1 = table.clone(p9)

    if p10 then
        local DogsMemoriesFrame2 = DogsMemoriesFrame

        if DogsMemoriesFrame2 and t1.IsOpen() then
            render(DogsMemoriesFrame2)
        end
    else
        t1.Close()
    end
end

function t1.Celebrate(p11) -- line: 200
    -- upvalues: Fx (copy), CollectSecretRing (copy), DogsMemoriesFrame (ref), v1 (ref), t1 (copy), render (copy)
    v1[p11] = true
    Fx.Play(CollectSecretRing, {
        Volume = 0.6
    })

    local DogsMemoriesFrame2 = DogsMemoriesFrame

    if DogsMemoriesFrame2 and t1.IsOpen() then
        render(DogsMemoriesFrame2)
    end
end

function t1.Reset() -- line: 209
    -- upvalues: v1 (ref), v2 (ref), t1 (copy)
    t1.Close()
    v2 = nil
    table.clear(v1)
end

return table.freeze(t1)
