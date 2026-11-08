-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Codec = require(ReplicatedStorage.UserGenerated.Observability.Codec)
local BackpackOrder = require(ReplicatedStorage.UserGenerated.Observability.BackpackOrder)
local t1 = {}

t1.__index = t1

local function slotCount() -- line: 20
    -- upvalues: UserInputService (copy), VRService (copy)
    if VRService.VREnabled then
        return 6
    end

    local CurrentCamera = workspace.CurrentCamera

    if UserInputService.TouchEnabled and CurrentCamera and CurrentCamera.ViewportSize.X < 1024 then
        return 3
    end

    return 10
end

function t1.new(p1) -- line: 26
    -- upvalues: Players (copy), UserInputService (copy), RunService (copy), StarterGui (copy), GuiService (copy), VRService (copy), BackpackOrder (copy), t1 (copy)
    local t2 = {
        NextTool = 0,
        StateDirty = true,
        Destroyed = false,
        Registry = p1,
        Connections = {},
        Containers = {},
        Tools = {},
        Dirty = {},
        Removed = {}
    }
    local new = BackpackOrder.new
    local v1

    if VRService.VREnabled then
        v1 = 6
    else
        local CurrentCamera = workspace.CurrentCamera

        v1 = if UserInputService.TouchEnabled and CurrentCamera and CurrentCamera.ViewportSize.X < 1024 then 3 else 10
    end

    t2.Order = new(v1)
    t2.FrameKeys = {}
    t2.FrameEquips = {}

    local v2 = setmetatable(t2, t1)
    local LocalPlayer = Players.LocalPlayer

    local function connect(p2, p3) -- line: 31
        -- upvalues: v2 (copy)
        table.insert(v2.Connections, p2:Connect(p3))
    end

    local function invalidate() -- line: 34
        -- upvalues: v2 (copy)
        v2.Order:Invalidate()
        v2.StateDirty = true
        table.clear(v2.FrameKeys)
        table.clear(v2.FrameEquips)
    end

    local InputBegan = UserInputService.InputBegan

    local function v3(p4, p5) -- line: 40
        -- upvalues: v2 (copy), UserInputService (copy), StarterGui (copy), GuiService (copy)
        if UserInputService:GetFocusedTextBox() then
            return
        end

        local UserInputType, KeyCode = p4.UserInputType, p4.KeyCode

        if KeyCode ~= Enum.KeyCode.Backquote and (not p5 or UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch) and KeyCode ~= Enum.KeyCode.ButtonSelect then
            if UserInputType == Enum.UserInputType.Keyboard and StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) and not GuiService.MenuIsOpen then
                local v4 = KeyCode.Value - Enum.KeyCode.Zero.Value

                if v4 >= 0 and v4 <= 9 then
                    local FrameKeys = v2.FrameKeys

                    if v4 == 0 then
                        v4 = 10
                    end

                    table.insert(FrameKeys, v4)
                end
            end
        else
            v2.Order:Invalidate()
            v2.StateDirty = true
            table.clear(v2.FrameKeys)
            table.clear(v2.FrameEquips)
        end
    end

    table.insert(v2.Connections, InputBegan:Connect(v3))

    local PreRender = RunService.PreRender

    local function v5() -- line: 55
        -- upvalues: v2 (copy), LocalPlayer (copy)
        if #v2.FrameKeys == 1 and #v2.FrameEquips == 1 then
            local v6 = v2.FrameEquips[1]
            local v7 = v2.Tools[v6]

            if v7 and v6.Parent == LocalPlayer.Character then
                v2.Order:Recover(v2.FrameKeys[1], v7.Id)
                v2.StateDirty = true
            end
        end

        table.clear(v2.FrameKeys)
        table.clear(v2.FrameEquips)
    end

    table.insert(v2.Connections, PreRender:Connect(v5))

    local CoreGuiChangedSignal = StarterGui.CoreGuiChangedSignal

    local function v8(p6) -- line: 68
        -- upvalues: v2 (copy)
        if p6 ~= Enum.CoreGuiType.Backpack and p6 ~= Enum.CoreGuiType.All then
            return
        end

        v2.Order:Invalidate()
        v2.StateDirty = true
        table.clear(v2.FrameKeys)
        table.clear(v2.FrameEquips)
    end

    table.insert(v2.Connections, CoreGuiChangedSignal:Connect(v8))

    local CharacterAdded = LocalPlayer.CharacterAdded

    local function v9(p7) -- line: 71
        -- upvalues: v2 (copy)
        v2.Order:Invalidate()
        v2.StateDirty = true
        table.clear(v2.FrameKeys)
        table.clear(v2.FrameEquips)
        v2:_bind(p7)
    end

    table.insert(v2.Connections, CharacterAdded:Connect(v9))

    local CharacterRemoving = LocalPlayer.CharacterRemoving

    local function v10(p8) -- line: 76
        -- upvalues: v2 (copy)
        v2:_unbind(p8)
        v2.Order:Invalidate()
        v2.StateDirty = true
        table.clear(v2.FrameKeys)
        table.clear(v2.FrameEquips)
    end

    table.insert(v2.Connections, CharacterRemoving:Connect(v10))

    local ChildAdded = LocalPlayer.ChildAdded

    local function v11(p9) -- line: 77
        -- upvalues: v2 (copy)
        if p9:IsA("Backpack") then
            v2:_bind(p9)
        end
    end

    table.insert(v2.Connections, ChildAdded:Connect(v11))

    local ChildRemoved = LocalPlayer.ChildRemoved

    local function v12(p10) -- line: 78
        -- upvalues: v2 (copy)
        if v2.Containers[p10] then
            v2:_unbind(p10)
            v2.Order:Invalidate()
            v2.StateDirty = true
            table.clear(v2.FrameKeys)
            table.clear(v2.FrameEquips)
        end
    end

    table.insert(v2.Connections, ChildRemoved:Connect(v12))

    if LocalPlayer.Character then
        v2:_bind(LocalPlayer.Character)
    end

    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if Backpack then
        v2:_bind(Backpack)
    end

    table.clear(v2.FrameEquips)

    return v2
end

function t1._bind(p11, p12) -- line: 87
    if p11.Containers[p12] then
        return
    end

    p11.Containers[p12] = {
        p12.ChildAdded:Connect(function(p13) -- line: 90
            -- upvalues: p11 (copy)
            p11:_observe(p13)
        end),
        p12.ChildRemoved:Connect(function(p14) -- line: 91
            -- upvalues: p11 (copy)
            if p11.Tools[p14] then
                p11.Dirty[p14] = true
            end
        end)
    }

    for _, child in p12:GetChildren() do
        p11:_observe(child)
    end
end

function t1._unbind(p15, p16) -- line: 98
    local v13 = p15.Containers[p16]

    if not v13 then
        return
    end

    for _, v14 in v13 do
        v14:Disconnect()
    end

    p15.Containers[p16] = nil

    for v15 in p15.Tools do
        if v15.Parent == p16 then
            p15.Dirty[v15] = true
        end
    end
end

function t1._observe(p17, p18) -- line: 106
    -- upvalues: Players (copy)
    if not p18:IsA("Tool") then
        return
    end

    if not p17.Tools[p18] then
        p17.NextTool += 1

        local t3 = {
            Id = p17.NextTool,
            Connections = {}
        }

        p17.Tools[p18] = t3
        p17.Order:Add(t3.Id)

        for _, v16 in { "Name", "TextureId", "ToolTip" } do
            table.insert(t3.Connections, p18:GetPropertyChangedSignal(v16):Connect(function() -- line: 115
                -- upvalues: p17 (copy), p18 (copy)
                p17.Dirty[p18] = true
            end))
        end

        p17.StateDirty = true
    end

    if p18.Parent == Players.LocalPlayer.Character then
        table.insert(p17.FrameEquips, p18)
    end

    p17.Dirty[p18] = true
end

function t1._write(p19, p20, p21, p22, p23, p24) -- line: 123
    -- upvalues: HttpService (copy), Observability (copy), Codec (copy)
    local Registry = p19.Registry
    local Stream = Registry.Stream
    local W = Registry.Stream.W
    local v18 = Registry.ClassPropsByName.Folder[p23]
    local NextId

    if p20 then
        Stream:Time((math.max(Registry.Clock(), Registry.AddFloor)))
        W:u8(Observability.Op.Prop)
        Codec.varuint(W, p20)
        NextId = p20
    else
        NextId = Registry.NextId
        Registry.NextId += 1
        Registry:AddTime()
        Registry.Copies:WriteHead(W, NextId, p21, Registry.ClassIndex.Folder, p22, false)
        W:u16(1)
    end

    Codec.varuint(W, v18)
    Codec.writeValue(W, Observability.ValueType.String, HttpService:JSONEncode(p24))
    Stream:EndRecord()

    return NextId
end

function t1.Flush(p25) -- line: 144
    -- upvalues: Players (copy), UserInputService (copy), VRService (copy), Observability (copy), Codec (copy), BackpackOrder (copy)
    local v20

    if VRService.VREnabled then
        v20 = 6
    else
        local CurrentCamera = workspace.CurrentCamera

        v20 = if UserInputService.TouchEnabled and CurrentCamera and CurrentCamera.ViewportSize.X < 1024 then 3 else 10
    end

    if v20 ~= p25.Order.Count then
        p25.Order = BackpackOrder.new(v20)
        p25.Order:Invalidate()
        p25.StateDirty = true
    end

    if not p25.Root then
        p25.Root = p25:_write(nil, Observability.RootId.PlayerGui, "Backpack (best effort)", "UGBackpackState", {
            slots = p25.Order.Slots,
            guessed = p25.Order.Guessed
        })
    end

    for v21 in p25.Dirty do
        local v22 = p25.Tools[v21]

        if p25.Containers[v21.Parent] then
            v22.StreamId = p25:_write(v22.StreamId, p25.Root, "Tool", "UGBackpackTool", {
                id = v22.Id,
                name = v21.Name,
                texture = v21.TextureId,
                tooltip = v21.ToolTip,
                equipped = v21.Parent == Players.LocalPlayer.Character
            })
        else
            if v22.StreamId then
                local Stream = p25.Registry.Stream

                Stream:Time((math.max(p25.Registry.Clock(), p25.Registry.AddFloor)))
                Stream.W:u8(Observability.Op.Remove)
                Codec.varuint(Stream.W, v22.StreamId)
                Stream:EndRecord()
                p25.Registry.Copies:Forget(v22.StreamId)
            end

            for _, v24 in v22.Connections do
                v24:Disconnect()
            end

            p25.Tools[v21] = nil
            p25.Order:Remove(v22.Id)
            p25.StateDirty = true
        end
    end

    table.clear(p25.Dirty)

    if p25.StateDirty then
        p25:_write(p25.Root, 0, "", "UGBackpackState", {
            slots = p25.Order.Slots,
            guessed = p25.Order.Guessed
        })
        p25.StateDirty = false
    end
end

function t1.Destroy(p26) -- line: 184
    p26.Destroyed = true

    for _, v25 in p26.Connections do
        v25:Disconnect()
    end

    for _, v26 in p26.Containers do
        for _, v27 in v26 do
            v27:Disconnect()
        end
    end

    for _, v28 in p26.Tools do
        for _, v29 in v28.Connections do
            v29:Disconnect()
        end
    end

    table.clear(p26.Tools)
    table.clear(p26.Dirty)
    table.clear(p26.Containers)
end

return t1
