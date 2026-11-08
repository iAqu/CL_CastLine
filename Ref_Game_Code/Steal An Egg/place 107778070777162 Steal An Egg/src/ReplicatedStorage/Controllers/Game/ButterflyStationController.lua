-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local ButterflyFlags = require(ReplicatedStorage.Shared.Flags.ButterflyFlags)
local GUI = require(ReplicatedStorage.Client.GUI)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local TryLock = require(ReplicatedStorage.Shared.Utils.TryLock)
local v1 = Color3.fromRGB(150, 255, 120)
local v2 = Color3.fromRGB(20, 70, 10)
local LocalPlayer = Players.LocalPlayer
local v3 = TryLock(8)
local t1 = {}

local function netClaimed() -- line: 49
    -- upvalues: Save (copy)
    local v4 = if Save.IsLoaded() then Save.Peek() else nil
    local Butterflies = if v4 then v4.Butterflies else nil

    if typeof(Butterflies) == "table" then
        return Butterflies.NetClaimed == true
    end

    return false
end

local function promptOf(p1, p2) -- line: 55
    local v5 = p1:WaitForChild(p2, 30)

    if v5 == nil then
        warn((("[ButterflyStation] ButterflyStation.%* is missing"):format(p2)))

        return nil
    end

    local v6 = v5:FindFirstChildWhichIsA("ProximityPrompt", true)

    if v6 == nil then
        warn((("[ButterflyStation] %* needs a ProximityPrompt"):format((v5:GetFullName()))))
    end

    return v6
end

local function openPanel(p3) -- line: 68
    -- upvalues: ButterflyFlags (copy), GUI (copy), Tabs (copy)
    if ButterflyFlags.Enabled:Get() then
        GUI.Get(p3)

        if not Tabs.IsActive(p3) then
            Tabs.Activate(p3)
        end
    end
end

local function ownsNetTool() -- line: 79
    -- upvalues: LocalPlayer (copy)
    for _, v7 in {
            LocalPlayer:FindFirstChildOfClass("Backpack"),
            LocalPlayer.Character
        } do
        if v7 ~= nil then
            for _, child in v7:GetChildren() do
                if child:IsA("Tool") and child:GetAttribute("ButterflyNet") == true then
                    return true
                end
            end
        end
    end

    return false
end

local function flyInto(p4) -- line: 93
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        local clone = p4:Clone()
        local Pivot = p4:GetPivot()
        local Scale = clone:GetScale()

        clone.Parent = Workspace

        local elapsed = os.clock()
        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 105
            -- upvalues: HumanoidRootPart (copy), clone (copy), Pivot (copy), Scale (copy), elapsed (copy), connection (ref), TweenService (copy)
            local v9 = math.clamp((os.clock() - elapsed) / 0.55, 0, 1)
            local Value = TweenService:GetValue(v9, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            local v10 = HumanoidRootPart.Position + Vector3.new(0, 0.6, 0)
            local v11 = Pivot.Position:Lerp(v10, Value)
            local v12 = CFrame.Angles(0, v9 * 3.141592653589793 * 3, 0)

            clone:ScaleTo(Scale * (1 - 0.92 * Value))
            clone:PivotTo(CFrame.new(v11) * Pivot.Rotation * v12)

            if v9 >= 1 then
                if connection then
                    connection:Disconnect()
                end

                clone:Destroy()
            end
        end)
    end
end

local function claimNet(p5) -- line: 122
    -- upvalues: Audio (copy), ButterflyCatalog (copy), Remotes (copy), Toast (copy), v1 (copy), v2 (copy), v3 (copy)
    v3(function() -- line: 123
        -- upvalues: p5 (copy), Audio (copy), ButterflyCatalog (copy), Remotes (copy), Toast (copy), v1 (copy), v2 (copy)
        local function v13() -- line: 124
            -- upvalues: Remotes (copy)
            return Remotes.Butterflies.AskClaimNet:InvokeServer()
        end

        local v14, v15, v16 = pcall(v13)

        if v14 then
            if v15 then
                p5()
                Audio.Play(ButterflyCatalog.Sounds.Craft, script, {
                    Volume = 0.7
                })
                Toast.Show({
                    Lane = "Banner",
                    Text = "You got a Butterfly Net!\nEquip it and swing at butterflies during the Butterfly Bloom!",
                    Seconds = 4.5,
                    ShowShadow = true,
                    Color = v1,
                    StrokeColor = v2,
                    Image = ButterflyCatalog.Icons.Net,
                    Size = UDim2.fromScale(1.5, 0.45)
                })
            elseif typeof(v16) == "string" then
                Audio.Play(ButterflyCatalog.Sounds.Deny, script, {
                    Volume = 0.6
                })
                Toast.Show({
                    Lane = "Feed",
                    Seconds = 2.5,
                    Text = v16,
                    Color = Color3.fromRGB(255, 120, 120)
                })
            end
        end
    end)
end

local function bindNetStand(p6, p7) -- line: 155
    -- upvalues: RunService (copy), Audio (copy), ButterflyCatalog (copy), Remotes (copy), Save (copy), Toast (copy), v1 (copy), v2 (copy), LocalPlayer (copy), v3 (copy), ownsNetTool (copy), flyInto (copy)
    local Float = p6:FindFirstChild("Float")
    local Ring = p6:FindFirstChild("Ring")
    local v17 = if not (Float and Float:IsA("Model")) then nil else Float:GetPivot()
    local v18 = if Ring then Ring:FindFirstChild("Spin", true) else nil
    local v19 = false
    local v20, connection

    local function step() -- line: 164
        -- upvalues: Float (copy), v18 (copy), v17 (copy)
        local elapsed = os.clock()

        if Float and Float:IsA("Model") and v17 then
            local v22 = math.sin(elapsed * 1.8) * 0.45

            Float:PivotTo(v17 * CFrame.new(0, v22, 0) * CFrame.Angles(0, elapsed * 0.7, 0))
        end

        if v18 and v18:IsA("GuiObject") then
            v18.Rotation = elapsed * 30 % 360
        end
    end

    local function setShown(p8) -- line: 175
        -- upvalues: p6 (copy), p7 (copy), Float (copy), Ring (copy), v20 (ref), connection (ref), step (copy), RunService (copy)
        if v20 == p8 then
            return
        end

        v20 = p8

        for _, v23 in { Float, Ring } do
            if v23 then
                if p8 then
                    v23.Parent = p6
                else
                    v23.Parent = nil
                end
            end
        end

        p7.ActionText = "Claim Net"
        p7.Enabled = p8

        if not p8 or connection ~= nil then
            if not p8 and connection then
                connection:Disconnect()
                connection = nil
            end
        else
            connection = RunService.RenderStepped:Connect(step)
        end
    end

    local function refresh() -- line: 195
        -- upvalues: v19 (ref), setShown (copy), Save (copy), ownsNetTool (copy)
        local v24 = v19

        if not v24 then
            local v25 = if Save.IsLoaded() then Save.Peek() else nil
            local Butterflies = if v25 then v25.Butterflies else nil

            v24 = typeof(Butterflies) == "table" and Butterflies.NetClaimed == true or ownsNetTool()
        end

        setShown(not v24)
    end

    local function watchBackpack() -- line: 199
        -- upvalues: v19 (ref), setShown (copy), refresh (copy), Save (copy), LocalPlayer (copy), ownsNetTool (copy)
        local v26 = LocalPlayer:WaitForChild("Backpack", 10)

        if v26 then
            v26.ChildAdded:Connect(refresh)
        end

        local v27 = v19

        if not v27 then
            local v28 = if Save.IsLoaded() then Save.Peek() else nil
            local Butterflies = if v28 then v28.Butterflies else nil

            v27 = typeof(Butterflies) == "table" and Butterflies.NetClaimed == true or ownsNetTool()
        end

        setShown(not v27)
    end

    p7.Triggered:Connect(function() -- line: 207
        -- upvalues: p7 (copy), Float (copy), Ring (copy), v19 (ref), v20 (ref), connection (ref), Audio (copy), ButterflyCatalog (copy), Remotes (copy), Toast (copy), v1 (copy), v2 (copy), v3 (copy), flyInto (copy)
        local function v29() -- line: 208
            -- upvalues: p7 (copy), Float (copy), Ring (copy), v19 (ref), v20 (ref), connection (ref), flyInto (copy)
            v19 = true

            if Float and Float:IsA("Model") and v20 then
                flyInto(Float)
            end

            if v20 == false then
                return
            end

            v20 = false

            for _, v30 in { Float, Ring } do
                if v30 then
                    v30.Parent = nil
                end
            end

            p7.ActionText = "Claim Net"
            p7.Enabled = false

            if connection then
                connection:Disconnect()
                connection = nil
            end
        end

        v3(function() -- line: 123
            -- upvalues: v29 (copy), Audio (copy), ButterflyCatalog (copy), Remotes (copy), Toast (copy), v1 (copy), v2 (copy)
            local function v31() -- line: 124
                -- upvalues: Remotes (copy)
                return Remotes.Butterflies.AskClaimNet:InvokeServer()
            end

            local v32, v33, v34 = pcall(v31)

            if v32 then
                if v33 then
                    v29()
                    Audio.Play(ButterflyCatalog.Sounds.Craft, script, {
                        Volume = 0.7
                    })
                    Toast.Show({
                        Lane = "Banner",
                        Text = "You got a Butterfly Net!\nEquip it and swing at butterflies during the Butterfly Bloom!",
                        Seconds = 4.5,
                        ShowShadow = true,
                        Color = v1,
                        StrokeColor = v2,
                        Image = ButterflyCatalog.Icons.Net,
                        Size = UDim2.fromScale(1.5, 0.45)
                    })
                elseif typeof(v34) == "string" then
                    Audio.Play(ButterflyCatalog.Sounds.Deny, script, {
                        Volume = 0.6
                    })
                    Toast.Show({
                        Lane = "Feed",
                        Seconds = 2.5,
                        Text = v34,
                        Color = Color3.fromRGB(255, 120, 120)
                    })
                end
            end
        end)
    end)
    Save.WatchFields("Butterflies", refresh)
    Remotes.Butterflies.NetClaimed.OnClientEvent:Connect(function() -- line: 217
        -- upvalues: v19 (ref), setShown (copy), Save (copy), ownsNetTool (copy)
        v19 = true

        local v35 = v19

        if not v35 then
            local v36 = if Save.IsLoaded() then Save.Peek() else nil
            local Butterflies = if v36 then v36.Butterflies else nil

            v35 = typeof(Butterflies) == "table" and Butterflies.NetClaimed == true or ownsNetTool()
        end

        setShown(not v35)
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 221
        -- upvalues: watchBackpack (copy)
        task.defer(watchBackpack)
    end)
    task.spawn(watchBackpack)
end

local function bindStation(p9) -- line: 227
    -- upvalues: ButterflyFlags (copy), GUI (copy), Tabs (copy), promptOf (copy), bindNetStand (copy)
    local NetStand = promptOf(p9, "NetStand")
    local ButterflyMachine = promptOf(p9, "ButterflyMachine")
    local MutationShrine = promptOf(p9, "MutationShrine")

    if NetStand then
        bindNetStand(p9:FindFirstChild("NetStand"), NetStand)
    end

    if ButterflyMachine then
        ButterflyMachine.Triggered:Connect(function() -- line: 235
            -- upvalues: ButterflyFlags (copy), GUI (copy), Tabs (copy)
            if ButterflyFlags.Enabled:Get() then
                GUI.Get("ButterflyMachine")

                if not Tabs.IsActive("ButterflyMachine") then
                    Tabs.Activate("ButterflyMachine")
                end
            end
        end)
    end

    if MutationShrine then
        MutationShrine.Triggered:Connect(function() -- line: 240
            -- upvalues: ButterflyFlags (copy), GUI (copy), Tabs (copy)
            if ButterflyFlags.Enabled:Get() then
                GUI.Get("EnchantedMutationShrine")

                if not Tabs.IsActive("EnchantedMutationShrine") then
                    Tabs.Activate("EnchantedMutationShrine")
                end
            end
        end)
    end
end

function t1.Start() -- line: 250
    -- upvalues: Workspace (copy), Tabs (copy), LocalPlayer (copy), bindStation (copy)
    task.spawn(function() -- line: 251
        -- upvalues: Workspace (copy), bindStation (copy)
        local v37 = Workspace:WaitForChild("World"):WaitForChild("Machines"):WaitForChild("ButterflyStation", 60)

        if v37 ~= nil then
            bindStation(v37)
        else
            warn("[ButterflyStation] Workspace.World.Machines.ButterflyStation is missing")
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function() -- line: 261
        -- upvalues: Tabs (copy)
        if Tabs.IsActive("ButterflyMachine") or Tabs.IsActive("EnchantedMutationShrine") then
            Tabs.Deactivate({
                instant = true
            })
        end
    end)
end

return t1
