-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RiftMachineSchedule = require(ReplicatedStorage.Shared.Util.RiftMachineSchedule)

return {
    Start = function() -- Start | line: 10
        -- upvalues: Players (copy), ReplicatedStorage (copy), Workspace (copy), RiftMachineSchedule (copy)
        if RiftMachineSchedule.IsLaboratoryTime() then
            return
        end

        local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
        local RiftEligibility = require(ReplicatedStorage.Shared.Util.RiftEligibility)
        local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
        local Save = require(ReplicatedStorage.Shared.Save)
        local Tabs = require(ReplicatedStorage.Client.Tabs)
        local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
        local LocalPlayer = Players.LocalPlayer
        local v1 = Workspace:WaitForChild("World"):WaitForChild("Machines"):WaitForChild("OldRiftMachine", 5)

        if v1 == nil then
            return
        end

        local Rift = v1:WaitForChild("Rift")
        local ProximityPrompt = v1:WaitForChild("Machine"):WaitForChild("Attachment"):WaitForChild("ProximityPrompt")
        local BillboardGui = v1:WaitForChild("Overhead"):WaitForChild("BillboardGui")
        local Timer = v1.Overhead:WaitForChild("TimerGui"):WaitForChild("Timer")
        local Shop = Timer:WaitForChild("Shop")

        Timer.Enabled = false

        local t2 = {}
        local t3 = {}

        for _, descendant in Rift:GetDescendants() do
            if descendant:IsA("BasePart") then
                t2[descendant] = {
                    Collide = descendant.CanCollide,
                    Query = descendant.CanQuery,
                    Touch = descendant.CanTouch
                }
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Light") then
                t3[descendant] = descendant.Enabled
            end
        end

        local clone, v2
        local t4 = {}
        local v3 = true

        local function resolveState() -- line: 54
            -- upvalues: RiftEligibility (copy), Save (copy), LocalPlayer (copy)
            if not RiftEligibility.IsFeatureLive() then
                return "Hidden"
            end

            local v4 = Save.Await()

            if v4 ~= nil and RiftEligibility.IsEligible(v4.SpeedPower) then
                return "Open"
            end

            local v5 = if v4 == nil then 0 else v4.SpeedPower
            local v6 = if v4 == nil then 0 else v4.LastLogout

            if RiftEligibility.IsRevealed(LocalPlayer, v5, v6) then
                return "Locked"
            end

            return "Hidden"
        end

        local function applyState(p1) -- line: 70
            -- upvalues: v1 (copy), Rift (copy), ProximityPrompt (copy), BillboardGui (copy), t2 (copy), t3 (copy), clone (ref), v2 (ref), ReplicatedStorage (copy)
            if v2 == p1 then
                return
            end

            v2 = p1

            local v7 = p1 == "Open"

            for v8, v9 in t2 do
                v8.LocalTransparencyModifier = v7 and 0 or 1

                if v7 then
                    v8.CanCollide = v9.Collide
                else
                    v8.CanCollide = false
                end

                if v7 then
                    v8.CanQuery = v9.Query
                else
                    v8.CanQuery = false
                end

                if v7 then
                    v8.CanTouch = v9.Touch
                else
                    v8.CanTouch = false
                end
            end

            for v10, v11 in t3 do
                if v7 then
                    v10.Enabled = v11
                else
                    v10.Enabled = false
                end
            end

            BillboardGui.Enabled = v7

            local Shop = BillboardGui:FindFirstChild("Shop")

            if Shop and Shop:IsA("TextLabel") then
                Shop.Text = "THE RIFT"
            end

            if p1 == "Locked" then
                if clone == nil then
                    local clone2 = ReplicatedStorage.Assets.VFX.RiftTradeIn.LockedPortal:Clone()
                    local RiftPivotOffset = clone2:GetAttribute("RiftPivotOffset")

                    assert(typeof(RiftPivotOffset) == "CFrame", "LockedPortal needs RiftPivotOffset")
                    clone2.Name = "LockedPortal"
                    clone2:PivotTo(Rift:GetPivot() * RiftPivotOffset)
                    clone = clone2
                end

                clone.Parent = v1
            elseif clone ~= nil then
                clone.Parent = nil
            end

            ProximityPrompt.ActionText = p1 == "Locked" and "Locked" or "The Rift"
            ProximityPrompt.Enabled = p1 ~= "Hidden"
        end

        local function refreshTimer() -- line: 107
            -- upvalues: RiftEligibility (copy), Timer (copy), Shop (copy), v2 (ref), Workspace (copy), RiftMachineSchedule (copy)
            local v13 = RiftMachineSchedule.GetSwapAt() - Workspace:GetServerTimeNow()
            local v14 = v2 == "Open" and RiftEligibility.IsFeatureLive() and v13 > 0

            Timer.Enabled = v14

            if v14 then
                local v15 = math.ceil(v13)
                local v17 = math.floor(v15 / 86400)
                local v19 = math.floor(v15 % 86400 / 3600)
                local v21 = math.floor(v15 % 3600 / 60)
                local v22 = v15 % 60

                if v17 > 0 then
                    Shop.Text = string.format("Animals Leaving In: %dd %dh", v17, v19)

                    return v13
                end

                if v19 > 0 then
                    Shop.Text = string.format("Animals Leaving In: %dh %dm", v19, v21)

                    return v13
                end

                Shop.Text = string.format("Animals Leaving In: %dm %ds", v21, v22)
            end

            return v13
        end

        local function refresh() -- line: 128
            -- upvalues: v1 (copy), v3 (ref), resolveState (copy), applyState (copy), refreshTimer (copy)
            if v3 and v1.Parent ~= nil then
                applyState((resolveState()))
                refreshTimer()
            end
        end

        table.insert(t4, ProximityPrompt.Triggered:Connect(function() -- line: 136
            -- upvalues: Toast (copy), RiftEligibility (copy), RiftFlags (copy), Tabs (copy), TreadmillUtil (copy), v1 (copy), v2 (ref), v3 (ref)
            if v3 and v1.Parent ~= nil then
                if v2 == "Locked" then
                    Toast.Show({
                        Seconds = 3,
                        Text = "You need " .. TreadmillUtil.FormatSpeedPower(RiftFlags.SpeedPowerRequirement:Get()) .. " Speed to use this!",
                        Color = Color3.fromRGB(196, 152, 255)
                    })
                elseif v2 == "Open" and RiftEligibility.IsFeatureLive() then
                    Tabs.Activate("RiftTradeIn")
                end
            end
        end))

        local function watch(p2) -- line: 153
            -- upvalues: t4 (copy), refresh (copy)
            table.insert(t4, p2:Connect(refresh))
        end

        local v24 = Save.WatchFields("SpeedPower", refresh)

        table.insert(t4, RiftFlags.SpeedPowerRequirement.Changed:Connect(refresh))
        table.insert(t4, RiftFlags.Retired.Changed:Connect(refresh))
        table.insert(t4, Workspace:GetAttributeChangedSignal(RiftEligibility.OpenAttribute):Connect(refresh))
        table.insert(t4, LocalPlayer:GetAttributeChangedSignal(RiftEligibility.CutsceneSeenAttribute):Connect(refresh))
        table.insert(t4, v1.AncestryChanged:Connect(function() -- line: 161
            -- upvalues: v1 (copy), Timer (copy), t4 (copy), v3 (ref), v24 (copy)
            if v1.Parent ~= nil then
                return
            end

            v3 = false
            Timer.Enabled = false
            v24:Clean()

            for _, v26 in t4 do
                v26:Disconnect()
            end
        end))

        if v3 and v1.Parent ~= nil then
            applyState((resolveState()))
            refreshTimer()
        end

        task.spawn(function() -- line: 174
            -- upvalues: v1 (copy), v3 (ref), refreshTimer (copy)
            while v3 and v1.Parent ~= nil do
                local v27 = refreshTimer()

                if v27 <= 0 then
                    break
                end

                task.wait((math.min(1, v27)))
            end
        end)
    end
}
