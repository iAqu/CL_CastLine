-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local RiftEligibility = require(ReplicatedStorage.Shared.Util.RiftEligibility)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local ScrambleTradeInEligibility = require(ReplicatedStorage.Shared.Util.ScrambleTradeInEligibility)
local ScrambleTradeInFlags = require(ReplicatedStorage.Shared.Flags.ScrambleTradeInFlags)
local ScrambleLeaveTimer = require(ReplicatedStorage.Shared.Util.ScrambleLeaveTimer)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)

return {
    Start = function() -- Start | line: 20
        -- upvalues: Players (copy), ReplicatedStorage (copy), Workspace (copy), Toast (copy), RiftEligibility (copy), RiftFlags (copy), ScrambleTradeInEligibility (copy), ScrambleTradeInFlags (copy), ScrambleLeaveTimer (copy), Trove (copy), Save (copy), Tabs (copy), TreadmillUtil (copy)
        local RiftTradeIn = ReplicatedStorage.Assets.VFX.RiftTradeIn
        local v1 = Color3.fromRGB(196, 152, 255)
        local LocalPlayer = Players.LocalPlayer
        local Machines = Workspace:WaitForChild("World"):WaitForChild("Machines")
        local v2 = Trove.new()
        local v3 = Trove.new()

        v2:Add(v3)

        local RiftMachine
        local n1 = 0

        v2:Add(function() -- line: 40
            -- upvalues: n1 (ref)
            n1 += 1
        end)

        local function bindMachine(p1) -- line: 42
            -- upvalues: RiftTradeIn (copy), v1 (copy), LocalPlayer (copy), Machines (copy), v3 (copy), n1 (ref), Workspace (copy), Toast (copy), RiftEligibility (copy), RiftFlags (copy), ScrambleTradeInEligibility (copy), ScrambleTradeInFlags (copy), ScrambleLeaveTimer (copy), Save (copy), Tabs (copy), TreadmillUtil (copy)
            local v4 = n1
            local Rift = p1:WaitForChild("Rift")
            local ProximityPrompt = p1:WaitForChild("Machine"):WaitForChild("Attachment"):WaitForChild("ProximityPrompt")
            local ObjectText = ProximityPrompt.ObjectText
            local BillboardGui = p1:WaitForChild("Overhead"):WaitForChild("BillboardGui")
            local Timer = p1:WaitForChild("Overhead"):WaitForChild("TimerGui"):WaitForChild("Timer")
            local Shop = Timer:WaitForChild("Shop")
            local v5 = Color3.new(1, 1, 1)
            local v6 = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 52, 52)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 30, 40)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 170))
            })
            local UIGradient = Shop:FindFirstChildOfClass("UIGradient")
            local StudsOffset, Size = Timer.StudsOffset, Timer.Size
            local TextColor3 = Shop.TextColor3
            local Color = if UIGradient then UIGradient.Color else nil

            Timer.Enabled = false

            local t2 = {}
            local t3 = {}

            for _, descendant in Rift:GetDescendants() do
                if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") then
                    t2[descendant] = descendant.Enabled
                elseif descendant:IsA("BasePart") then
                    t3[descendant] = {
                        CanCollide = descendant.CanCollide,
                        CanQuery = descendant.CanQuery,
                        CanTouch = descendant.CanTouch
                    }
                end
            end

            local clone

            v3:Add(function() -- line: 82
                -- upvalues: ProximityPrompt (copy), BillboardGui (copy), Timer (copy), t2 (copy), t3 (copy), clone (ref)
                ProximityPrompt.Enabled = false
                BillboardGui.Enabled = false
                Timer.Enabled = false

                if clone then
                    clone:Destroy()
                end

                for v7, v8 in t3 do
                    v7.LocalTransparencyModifier = 0
                    v7.CanCollide = v8.CanCollide
                    v7.CanQuery = v8.CanQuery
                    v7.CanTouch = v8.CanTouch
                end

                for v9, v10 in t2 do
                    v9.Enabled = v10
                end
            end)

            local v11
            local v12 = false
            local v13 = false
            local Shop2 = BillboardGui:FindFirstChild("Shop")

            local function lockedVisual() -- line: 102
                -- upvalues: Rift (copy), clone (ref), v13 (ref), RiftTradeIn (copy), ScrambleTradeInFlags (copy)
                local v14 = ScrambleTradeInFlags.Enabled:Get()
                local clone2 = clone

                if clone2 ~= nil then
                    if v13 == v14 then
                        return clone2
                    end

                    clone2:Destroy()
                end

                v13 = v14

                local clone3 = (if v14 then RiftTradeIn.LockedLaboratory else RiftTradeIn.LockedPortal):Clone()
                local RiftPivotOffset = clone3:GetAttribute("RiftPivotOffset")

                assert(typeof(RiftPivotOffset) == "CFrame", "LockedPortal needs a RiftPivotOffset CFrame attribute")
                clone3.Name = "LockedPortal"
                clone3:PivotTo(Rift:GetPivot() * RiftPivotOffset)
                clone = clone3

                return clone3
            end

            local function laboratoryActive() -- line: 122
                -- upvalues: ScrambleTradeInFlags (copy)
                return ScrambleTradeInFlags.Enabled:Get()
            end

            local function resolveState() -- line: 126
                -- upvalues: LocalPlayer (copy), RiftEligibility (copy), ScrambleTradeInEligibility (copy), ScrambleTradeInFlags (copy), ScrambleLeaveTimer (copy), Save (copy)
                if ScrambleLeaveTimer.IsExpired() then
                    return "Hidden"
                end

                if ScrambleTradeInFlags.Enabled:Get() then
                    local v16 = Save.Await()

                    if v16 == nil or ScrambleTradeInEligibility.RequiredSpeedPower() == nil then
                        return "Hidden"
                    end

                    if ScrambleTradeInEligibility.IsEligible(v16.SpeedPower) then
                        return "Open"
                    end

                    if not RiftEligibility.IsEligible(v16.SpeedPower) and v16.LastLogout == 0 and not RiftEligibility.HasSeenReveal(LocalPlayer) then
                        return "Hidden"
                    end

                    return "Locked"
                end

                if RiftEligibility.IsFeatureLive() then
                    local v17 = Save.Await()

                    if v17 ~= nil and RiftEligibility.IsEligible(v17.SpeedPower) then
                        return "Open"
                    end

                    local v18 = if v17 == nil then 0 else v17.SpeedPower
                    local v19 = if v17 == nil then 0 else v17.LastLogout

                    if RiftEligibility.IsRevealed(LocalPlayer, v18, v19) then
                        return "Locked"
                    end
                end

                return "Hidden"
            end

            local function applyState(p2) -- line: 158
                -- upvalues: p1 (copy), ProximityPrompt (copy), ObjectText (copy), BillboardGui (copy), t2 (copy), t3 (copy), clone (ref), v11 (ref), v12 (ref), Shop2 (copy), lockedVisual (copy), ScrambleTradeInEligibility (copy), ScrambleTradeInFlags (copy), TreadmillUtil (copy)
                local v20 = ScrambleTradeInEligibility.RequiredSpeedPower()
                local v21 = p2 == "Locked" and ScrambleTradeInFlags.Enabled:Get() and v20 ~= nil

                ProximityPrompt:SetAttribute("ObjectTextBelow", v21)
                ProximityPrompt.ObjectText = if v21 then ("Unlocked at %* speed"):format((TreadmillUtil.FormatSpeedPower(v20))) else ObjectText

                local v23 = v11 == p2

                if v23 then
                    local v24 = v12

                    v23 = v24 == ScrambleTradeInFlags.Enabled:Get()
                end

                if v23 then
                    return
                end

                v11 = p2
                v12 = ScrambleTradeInFlags.Enabled:Get()

                local v25 = p2 == "Open"

                for v26, v27 in t3 do
                    v26.LocalTransparencyModifier = v25 and 0 or 1

                    if v25 then
                        v26.CanCollide = v27.CanCollide
                    else
                        v26.CanCollide = false
                    end

                    if v25 then
                        v26.CanQuery = v27.CanQuery
                    else
                        v26.CanQuery = false
                    end

                    if v25 then
                        v26.CanTouch = v27.CanTouch
                    else
                        v26.CanTouch = false
                    end
                end

                for v28, v29 in t2 do
                    if v25 then
                        v28.Enabled = v29
                    else
                        v28.Enabled = false
                    end
                end

                BillboardGui.Enabled = v25

                if Shop2 then
                    Shop2.Text = v12 and "DR. SCRAMBLE'S LABORATORY" or "THE RIFT"
                end

                if p2 == "Locked" then
                    lockedVisual().Parent = p1
                elseif clone ~= nil then
                    clone.Parent = nil
                end

                ProximityPrompt.ActionText = if p2 == "Locked" then "Locked" elseif v12 then "Dr. Scramble's Laboratory" else "The Rift"
                ProximityPrompt.Enabled = p2 ~= "Hidden"
            end

            local function paintTimer(p3) -- line: 196
                -- upvalues: BillboardGui (copy), Timer (copy), Shop (copy), v5 (copy), v6 (copy), UIGradient (copy), StudsOffset (copy), Size (copy), TextColor3 (copy), Color (copy)
                if p3 then
                    Timer.StudsOffset = BillboardGui.StudsOffset + Vector3.new(0, 1.8, 0)
                    Timer.Size = UDim2.new(Size.X.Scale * 0.75, Size.X.Offset * 0.75, Size.Y.Scale * 0.75, Size.Y.Offset * 0.75)
                    Shop.TextColor3 = v5

                    if UIGradient then
                        UIGradient.Color = v6
                    end
                else
                    Timer.StudsOffset = StudsOffset
                    Timer.Size = Size
                    Shop.TextColor3 = TextColor3

                    if UIGradient and Color then
                        UIGradient.Color = Color
                    end
                end
            end

            local function refreshTimer() -- line: 219
                -- upvalues: BillboardGui (copy), Timer (copy), Shop (copy), v5 (copy), v6 (copy), UIGradient (copy), StudsOffset (copy), Size (copy), TextColor3 (copy), v11 (ref), Color (copy), Workspace (copy), ScrambleTradeInFlags (copy), ScrambleLeaveTimer (copy)
                if ScrambleTradeInFlags.Enabled:Get() then
                    Timer.StudsOffset = BillboardGui.StudsOffset + Vector3.new(0, 1.8, 0)
                    Timer.Size = UDim2.new(Size.X.Scale * 0.75, Size.X.Offset * 0.75, Size.Y.Scale * 0.75, Size.Y.Offset * 0.75)
                    Shop.TextColor3 = v5

                    if UIGradient then
                        UIGradient.Color = v6
                    end

                    local v32 = ScrambleLeaveTimer.SecondsLeft()

                    Timer.Enabled = v11 == "Open" and v32 > 0
                    Shop.Text = ScrambleLeaveTimer.Text(v32)

                    return 1
                end

                Timer.StudsOffset = StudsOffset
                Timer.Size = Size
                Shop.TextColor3 = TextColor3

                if UIGradient and Color then
                    UIGradient.Color = Color
                end

                local v34 = 1790434800 - Workspace:GetServerTimeNow()
                local v35 = v11 == "Open" and v34 > 0

                Timer.Enabled = v35

                if v35 then
                    local v36 = math.ceil(v34)
                    local v38 = math.floor(v36 / 86400)
                    local v40 = math.floor(v36 % 86400 / 3600)
                    local v42 = math.floor(v36 % 3600 / 60)
                    local v43 = v36 % 60

                    if v38 > 0 then
                        Shop.Text = string.format("%s%dd %dh", "Animals Leaving In: ", v38, v40)

                        return v34
                    end

                    if v40 > 0 then
                        Shop.Text = string.format("%s%dh %dm", "Animals Leaving In: ", v40, v42)

                        return v34
                    end

                    Shop.Text = string.format("%s%dm %ds", "Animals Leaving In: ", v42, v43)
                end

                return v34
            end

            local function refresh() -- line: 248
                -- upvalues: resolveState (copy), applyState (copy), refreshTimer (copy)
                applyState((resolveState()))
                refreshTimer()
            end

            ProximityPrompt.ActionText = "The Rift"
            v3:Connect(ProximityPrompt.Triggered, function() -- line: 254
                -- upvalues: v11 (ref), resolveState (copy), applyState (copy), refreshTimer (copy), v1 (copy), Toast (copy), RiftFlags (copy), ScrambleTradeInEligibility (copy), ScrambleTradeInFlags (copy), ScrambleLeaveTimer (copy), Tabs (copy), TreadmillUtil (copy)
                if ScrambleLeaveTimer.IsExpired() or v11 == "Hidden" then
                    applyState((resolveState()))
                    refreshTimer()
                elseif v11 == "Locked" then
                    local v44 = if ScrambleTradeInFlags.Enabled:Get() then ScrambleTradeInEligibility.RequiredSpeedPower() else RiftFlags.SpeedPowerRequirement:Get()

                    if v44 ~= nil then
                        Toast.Show({
                            Seconds = 3,
                            Text = ("You need %* Speed to use this!"):format((TreadmillUtil.FormatSpeedPower(v44))),
                            Color = if ScrambleTradeInFlags.Enabled:Get() then Color3.fromRGB(81, 226, 36) else v1
                        })
                    else
                        applyState((resolveState()))
                        refreshTimer()
                    end
                else
                    Tabs.Activate(ScrambleTradeInFlags.Enabled:Get() and "DrScrambleTradeIn" or "RiftTradeIn")
                end
            end)
            applyState("Hidden")
            Save.Await()

            if not p1:IsDescendantOf(Machines) then
                return
            end

            applyState((resolveState()))
            refreshTimer()
            v3:Add(Save.WatchFields("SpeedPower", refresh))
            v3:Connect(RiftFlags.SpeedPowerRequirement.Changed, refresh)
            v3:Connect(RiftFlags.Retired.Changed, refresh)
            v3:Connect(ScrambleTradeInEligibility.Changed, refresh)
            v3:Connect(ScrambleTradeInFlags.Enabled.Changed, refresh)
            v3:Connect(ScrambleTradeInFlags.SpeedPowerRequirement.Changed, refresh)
            v3:Connect(ScrambleTradeInFlags.LeavesAtUnix.Changed, refresh)
            v3:Connect(Workspace:GetAttributeChangedSignal(RiftEligibility.OpenAttribute), refresh)
            v3:Connect(LocalPlayer:GetAttributeChangedSignal(RiftEligibility.CutsceneSeenAttribute), refresh)
            task.spawn(function() -- line: 291
                -- upvalues: p1 (copy), v4 (copy), resolveState (copy), applyState (copy), refreshTimer (copy), Machines (copy), n1 (ref)
                while n1 == v4 and p1:IsDescendantOf(Machines) do
                    applyState((resolveState()))

                    local v45 = refreshTimer()

                    if v45 <= 0 then
                        break
                    end

                    task.wait((math.min(1, v45)))
                end
            end)
        end

        local function refreshMachine() -- line: 304
            -- upvalues: Machines (copy), v3 (copy), RiftMachine (ref), n1 (ref), bindMachine (copy)
            local RiftMachine2 = Machines:FindFirstChild("RiftMachine")

            if RiftMachine2 == RiftMachine then
                return
            end

            n1 += 1
            v3:Clean()
            RiftMachine = RiftMachine2

            if RiftMachine2 then
                bindMachine(RiftMachine2)
            end
        end

        v2:Connect(Machines.ChildAdded, refreshMachine)
        v2:Connect(Machines.ChildRemoved, refreshMachine)

        local RiftMachine2 = Machines:FindFirstChild("RiftMachine")

        if RiftMachine2 ~= RiftMachine then
            n1 += 1
            v3:Clean()
            RiftMachine = RiftMachine2

            if RiftMachine2 then
                bindMachine(RiftMachine2)
            end
        end

        return v2
    end
}
