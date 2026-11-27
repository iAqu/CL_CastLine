-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RodShop = require(script.Parent.Parent.UI.RodShop)
local BaitShop = require(script.Parent.Parent.UI.BaitShop)
local SellPanel = require(script.Parent.Parent.UI.SellPanel)
local Menus = require(script.Parent.Parent.UI.Menus)
local LocalPlayer = Players.LocalPlayer
local t1 = {}

local function v1() -- line: 16
    return false
end

local Zone
local t2 = {
    RodShop = {
        open = RodShop.open,
        close = RodShop.close
    },
    BaitShop = {
        open = BaitShop.open,
        close = BaitShop.close
    },
    Sell = {
        open = SellPanel.open,
        close = SellPanel.close
    }
}

local function padUnder(p1) -- line: 28
    -- upvalues: CollectionService (copy)
    for _, v2 in CollectionService:GetTagged("GlowPad") do
        if v2:IsDescendantOf(workspace) then
            local v3 = p1 - v2.Position
            local Size = v2:GetAttribute("Size")
            local v4 = if Size then math.abs(v3.X) <= Size / 2 and math.abs(v3.Z) <= Size / 2 else Vector3.new(v3.X, 0, v3.Z).Magnitude <= (v2:GetAttribute("Radius") or 4)

            if v4 and math.abs(v3.Y) < 7 then
                return v2
            end
        end
    end

    return nil
end

function t1.setBusyCheck(p2) -- line: 48
    -- upvalues: v1 (ref)
    v1 = p2
end

function t1.init() -- line: 52
    -- upvalues: CollectionService (copy), RunService (copy), Menus (copy), LocalPlayer (copy), v1 (ref), Zone (ref), t2 (copy), padUnder (copy)
    local t3 = {}

    local function addSpinner(p3) -- line: 54
        -- upvalues: t3 (copy)
        if p3:IsA("Model") then
            t3[p3] = p3:GetPivot()
        end
    end

    CollectionService:GetInstanceAddedSignal("Spin"):Connect(addSpinner)
    CollectionService:GetInstanceRemovedSignal("Spin"):Connect(function(p4) -- line: 60
        -- upvalues: t3 (copy)
        t3[p4] = nil
    end)

    for _, v5 in CollectionService:GetTagged("Spin") do
        if v5:IsA("Model") then
            t3[v5] = v5:GetPivot()
        end
    end

    RunService.Heartbeat:Connect(function() -- line: 67
        -- upvalues: t3 (copy), Menus (copy), LocalPlayer (copy), v1 (ref), Zone (ref), t2 (copy), padUnder (copy)
        local elapsed = os.clock()

        for v6, v7 in t3 do
            if v6.Parent then
                v6:PivotTo(v7 * CFrame.new(0, math.sin(elapsed * 2) * 0.4, 0) * CFrame.Angles(0, elapsed * 1.2, 0))
            end
        end

        local v9 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        v9 = v9 and not v1() and padUnder(v9.Position)

        local Zone2 = v9 and v9:GetAttribute("Zone")

        if not t2[Zone2] then
            Zone2 = nil
        end

        if Zone2 == Zone then
            return
        end

        if Zone then
            task.spawn(t2[Zone].close)
        end

        Zone = Zone2

        if Zone2 then
            Menus.closeAll()
            t2[Zone2].open()
        end
    end)
end

return t1
