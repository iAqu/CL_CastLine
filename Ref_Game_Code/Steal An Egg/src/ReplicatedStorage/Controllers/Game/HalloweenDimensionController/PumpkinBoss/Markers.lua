-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Kit = require(script.Parent.Kit)
local TrapAttributes = PumpkinBossState.TrapAttributes

local function build(p1) -- line: 25
    -- upvalues: Kit (copy)
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "PumpkinTrapMarker"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.fromOffset(48, 48)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    BillboardGui.MaxDistance = 250
    BillboardGui.Adornee = p1

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.Text = "!"
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Kit.Red
    TextLabel.TextStrokeTransparency = 0
    TextLabel.Parent = BillboardGui
    BillboardGui.Parent = Kit.Debris()

    return BillboardGui
end

return {
    Start = function(p2) -- Start | line: 50
        -- upvalues: Players (copy), RunService (copy), Workspace (copy), TrapAttributes (copy), build (copy)
        local t2 = {}
        local n1 = 0

        p2:Add(function() -- line: 54
            -- upvalues: t2 (copy)
            for _, v1 in t2 do
                v1:Destroy()
            end

            table.clear(t2)
        end)
        p2:Connect(RunService.Heartbeat, function() -- line: 61
            -- upvalues: t2 (copy), n1 (ref), Players (copy), Workspace (copy), TrapAttributes (copy), build (copy)
            local elapsed = os.clock()

            for _, v2 in t2 do
                v2.StudsOffsetWorldSpace = Vector3.new(0, math.sin(elapsed * 6) * 0.4 + 3, 0)
            end

            if elapsed < n1 then
                return
            end

            n1 = elapsed + 0.2

            local ServerTimeNow = Workspace:GetServerTimeNow()

            for _, player in Players:GetPlayers() do
                local Attribute = player:GetAttribute(TrapAttributes.TrapEnds)
                local Character = player.Character
                local Head = Character and Character:FindFirstChild("Head")
                local v5 = typeof(Attribute) == "number" and ServerTimeNow < Attribute and Character ~= nil and Character:GetAttribute(TrapAttributes.Trapped) == true and Head ~= nil and Head:IsA("BasePart")
                local v6 = t2[player]

                if v5 then
                    if v6 then
                        if v6.Adornee ~= Head then
                            v6:Destroy()
                            t2[player] = build(Head)
                        end
                    else
                        t2[player] = build(Head)
                    end
                elseif v6 then
                    v6:Destroy()
                    t2[player] = nil
                end
            end

            for v7, v8 in t2 do
                if v7.Parent ~= Players then
                    v8:Destroy()
                    t2[v7] = nil
                end
            end
        end)
    end
}
