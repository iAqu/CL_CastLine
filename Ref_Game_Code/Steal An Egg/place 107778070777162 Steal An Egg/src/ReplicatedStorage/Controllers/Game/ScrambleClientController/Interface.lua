-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local AssetViewport = require(ReplicatedStorage.Client.AssetViewport)
local Trove = require(ReplicatedStorage.Packages.Trove)
local ScrambleRules = require(ReplicatedStorage.Shared.Util.ScrambleRules)
local Parts = ReplicatedStorage.Assets.Models.Scramble.Parts
local t1 = {}
local v1 = Color3.new()
local v2 = Color3.new(1, 1, 1)

local function countdown(p1) -- line: 16
    local v4 = math.max(0, (math.ceil(p1)))
    local v5 = v4 // 86400
    local v6 = v4 % 86400 // 3600
    local v7 = v4 % 3600 // 60

    if v5 > 0 then
        return string.format("%dd %dhr %dm", v5, v6, v7)
    end

    if v6 > 0 then
        return string.format("%dhr %dm", v6, v7)
    end

    if v7 > 0 then
        return string.format("%dm %ds", v7, v4 % 60)
    end

    return tostring(v4) .. "s"
end

function t1.new(p2) -- line: 31
    -- upvalues: GUI (copy), Tabs (copy), ButtonFX (copy), AssetViewport (copy), Trove (copy), ScrambleRules (copy), Parts (copy), v1 (copy), v2 (copy), countdown (copy)
    local t2 = {}
    local v8 = Trove.new()
    local StolenVaultEvent = GUI.Get("StolenVaultEvent")
    local StolenVaultEventUIMain = StolenVaultEvent:WaitForChild("StolenVaultEventUIMain")
    local ContentFrame = StolenVaultEventUIMain.ContentFrame
    local RequirementsHolder = ContentFrame.RequirementsHolder
    local Template_Unlocked, Template_Locked = RequirementsHolder.Template_Unlocked, RequirementsHolder.Template_Locked
    local Claim, VaultInComplete = ContentFrame.Claim, ContentFrame.VaultInComplete
    local t3 = {}
    local v9
    local v10 = false
    local v11 = true
    local v12

    StolenVaultEvent:SetAttribute("ImmediateClose", true)
    StolenVaultEvent.Enabled = false

    for _, child in RequirementsHolder:GetChildren() do
        if child:IsA("GuiObject") then
            child.Visible = false
        end
    end

    local ClaimPosition, Size = Claim.Position, Claim.Size

    VaultInComplete.Position = ClaimPosition
    VaultInComplete.Size = Size
    VaultInComplete.Active = false
    VaultInComplete.Interactable = false
    VaultInComplete.Selectable = false

    local function buildCards() -- line: 54
        -- upvalues: v8 (copy), RequirementsHolder (copy), Template_Unlocked (copy), t3 (copy), AssetViewport (copy), ScrambleRules (copy), Parts (copy)
        if #t3 > 0 then
            return
        end

        for v13, v14 in ScrambleRules.PART_IDS do
            local clone = Template_Unlocked:Clone()

            clone.Name = v14
            clone.LayoutOrder = v13
            clone.Visible = true
            clone.Parent = RequirementsHolder
            v8:Add(clone)

            local Icon = clone.Icon
            local v15 = AssetViewport.Mount(clone)
            local ZIndex = Icon.ZIndex

            v15.Name = "PartViewport"
            v15.ZIndex = ZIndex

            local IconPosition, Size, AnchorPoint = Icon.Position, Icon.Size, Icon.AnchorPoint

            v15.Position = IconPosition
            v15.Size = Size
            v15.AnchorPoint = AnchorPoint
            Icon:Destroy()

            local v16 = Parts:FindFirstChild(v14)

            if v16 and v16:IsA("Model") then
                v8:Add((AssetViewport.ShowModel(v16, v15)))
            else
                warn("[Scramble UI] Missing part viewport model: " .. v14)
            end

            table.insert(t3, {
                Owned = nil,
                Id = v14,
                Index = v13,
                Card = clone,
                View = v15,
                Ambient = v15.Ambient,
                LightColor = v15.LightColor
            })
        end
    end

    local function paintCard(p3, p4) -- line: 87
        -- upvalues: Template_Unlocked (copy), Template_Locked (copy), v1 (copy), v2 (copy)
        if p3.Owned == p4 then
            return
        end

        p3.Owned = p4

        local Card, View = p3.Card, p3.View
        local v18

        if p4 then
            v18 = Template_Unlocked
            View.Ambient = p3.Ambient
            View.LightColor = p3.LightColor
            View.ImageColor3 = v2
        else
            v18 = Template_Locked
            View.Ambient = v1
            View.LightColor = v1
            View.ImageColor3 = v1
        end

        Card.InnerUIStroke.Color = v18.InnerUIStroke.Color
        Card.UIShadow.Color = v18.UIShadow.Color

        local UIGradient = Card.InnerUIStroke:FindFirstChildOfClass("UIGradient")

        if UIGradient then
            UIGradient.Enabled = p4
        end

        Card.CompletedCheckmark.Visible = p4

        local ItemName = Card.ItemName

        if p4 then
            if p3.Index <= 2 then
                ItemName.Text = "Lost Part " .. p3.Index
            else
                ItemName.Text = "Drone Part " .. p3.Index - 2
            end
        else
            ItemName.Text = "???"
        end
    end

    local function available(p5) -- line: 111
        -- upvalues: v9 (ref)
        local Ready

        if v9 ~= nil then
            Ready = v9.Ready

            if Ready then
                Ready = v9.Enabled

                if Ready then
                    Ready = false

                    if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                        Ready = p5 < v9.EventEndsAt
                    end
                end
            end
        else
            Ready = false
        end

        return Ready
    end

    local function canClaim() -- line: 120
        -- upvalues: v9 (ref), v10 (ref)
        local ServerTimeNow = workspace:GetServerTimeNow()
        local Ready

        if v9 ~= nil then
            Ready = v9.Ready

            if Ready then
                Ready = v9.Enabled

                if Ready then
                    Ready = false

                    if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                        Ready = ServerTimeNow < v9.EventEndsAt
                    end
                end
            end
        else
            Ready = false
        end

        if Ready then
            Ready = v9.State.Discovered

            if Ready then
                Ready = not v9.State.Completed

                if Ready then
                    Ready = v9.State.TotalParts == 5 and v9.VaultRewardReady and not v10
                end
            end
        end

        return Ready
    end

    local function send(p6, p7) -- line: 128
        -- upvalues: p2 (copy), v10 (ref), v11 (ref), v12 (ref)
        if v10 then
            return nil
        end

        v10 = true
        v12()

        local ok, result = pcall(p2, p6, p7)

        v10 = false

        if v11 then
            v12()
        end

        if ok then
            return result
        end

        warn("[Scramble UI] Request failed: " .. tostring(result))

        return nil
    end

    v8:Add(ButtonFX(Claim, nil, function() -- line: 145
        -- upvalues: p2 (copy), t2 (copy), v9 (ref), v10 (ref), v11 (ref), v12 (ref)
        local ServerTimeNow = workspace:GetServerTimeNow()
        local Ready

        if v9 ~= nil then
            Ready = v9.Ready

            if Ready then
                Ready = v9.Enabled

                if Ready then
                    Ready = false

                    if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                        Ready = ServerTimeNow < v9.EventEndsAt
                    end
                end
            end
        else
            Ready = false
        end

        if Ready then
            Ready = v9.State.Discovered

            if Ready then
                Ready = not v9.State.Completed

                if Ready then
                    Ready = v9.State.TotalParts == 5 and v9.VaultRewardReady and not v10
                end
            end
        end

        if not Ready then
            return
        end

        t2.Close()

        local result

        if not v10 then
            v10 = true
            v12()

            local ok

            ok, result = pcall(p2, "Vault", nil)
            v10 = false

            if v11 then
                v12()
            end

            if not ok then
                warn("[Scramble UI] Request failed: " .. tostring(result))
                result = nil
            end
        end

        if not (not v11 or result and result.Ok) then
            t2.ShowVault()
        end
    end))
    v8:Add(Tabs.Activated:Connect(function(p8) -- line: 155
        -- upvalues: v12 (ref)
        if p8 == "StolenVaultEvent" then
            v12()
        end
    end))

    local function v20() -- line: 161
        -- upvalues: StolenVaultEventUIMain (copy)
        local CurrentCamera = workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local ViewportSize = CurrentCamera.ViewportSize
        local AspectRatio = StolenVaultEventUIMain.UIAspectRatioConstraint.AspectRatio
        local v28 = math.max(1, (math.min(math.max(477, (math.min(ViewportSize.X * 0.62, ViewportSize.Y * 0.75 * AspectRatio))), ViewportSize.X - 32, ViewportSize.Y * 0.78 * AspectRatio)))

        StolenVaultEventUIMain.UISizeConstraint.MinSize = Vector2.zero
        StolenVaultEventUIMain.Size = UDim2.fromOffset(v28, v28 / AspectRatio)
    end

    v12 = function() -- line: 173
        -- upvalues: t2 (copy), StolenVaultEvent (copy), StolenVaultEventUIMain (copy), ContentFrame (copy), Claim (copy), VaultInComplete (copy), t3 (copy), v9 (ref), v10 (ref), v11 (ref), buildCards (copy), paintCard (copy), v20 (copy)
        if v11 then
            v20()

            if v9 and v9.Ready and v9.State then
                local State = v9.State

                ContentFrame.LostParts.ProgressLabel.Text = tostring((if State.LostParts.LostPart1 then 1 else 0) + (if State.LostParts.LostPart2 then 1 else 0)) .. " / 2"
                ContentFrame.DroneParts.ProgressLabel.Text = tostring(State.DroneParts) .. " / 3"

                local v31 = math.max(0, 5 - State.TotalParts)
                local SubTitle = StolenVaultEventUIMain.SubTitle

                if State.Completed then
                    SubTitle.Text = "The vault is repaired. Your reward has been claimed!"
                elseif v31 == 0 then
                    SubTitle.Text = "All <font color=\"#FFD83D\">5 parts</font> found! Repair the vault and claim your reward."
                else
                    SubTitle.Text = "The vault is damaged and missing <font color=\"#FFD83D\">" .. v31 .. (v31 == 1 and " part" or " parts") .. "</font>"
                end

                local ServerTimeNow = workspace:GetServerTimeNow()
                local Ready

                if v9 ~= nil then
                    Ready = v9.Ready

                    if Ready then
                        Ready = v9.Enabled

                        if Ready then
                            Ready = false

                            if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                                Ready = ServerTimeNow < v9.EventEndsAt
                            end
                        end
                    end
                else
                    Ready = false
                end

                if Ready then
                    Ready = State.Discovered

                    if Ready then
                        Ready = not State.Completed

                        if Ready then
                            Ready = v31 == 0 and v9.VaultRewardReady
                        end
                    end
                end

                local v32 = not Ready

                Claim.Visible = Ready
                VaultInComplete.Visible = v32

                local v33, v34

                if Ready then
                    v33 = not v10
                    v34 = not v10
                    Ready = not v10
                else
                    v34 = Ready
                    v33 = Ready
                end

                Claim.Active = v33
                Claim.Interactable = v34
                Claim.Selectable = Ready
                Claim.txt.Text = v10 and "Claiming..." or "Claim"

                local txt = VaultInComplete.txt

                if State.Completed then
                    txt.Text = "Claimed"
                else
                    local ServerTimeNow = workspace:GetServerTimeNow()
                    local Ready

                    if v9 ~= nil then
                        Ready = v9.Ready

                        if Ready then
                            Ready = v9.Enabled

                            if Ready then
                                Ready = false

                                if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                                    Ready = ServerTimeNow < v9.EventEndsAt
                                end
                            end
                        end
                    else
                        Ready = false
                    end

                    if Ready then
                        if v9.VaultRewardReady then
                            txt.Text = "Vault incomplete"
                        else
                            txt.Text = "Reward unavailable"
                        end
                    else
                        txt.Text = "Event ended"
                    end
                end

                if StolenVaultEvent.Enabled then
                    buildCards()

                    for _, v35 in t3 do
                        paintCard(v35, if v35.Index <= 2 then State.LostParts[v35.Id] == true else State.DroneParts >= v35.Index - 2)
                    end
                end

                t2.Tick(workspace:GetServerTimeNow())
            end
        end
    end

    function t2.Update(p9) -- line: 220
        -- upvalues: t2 (copy), v9 (ref), v12 (ref)
        v9 = p9

        local ServerTimeNow = workspace:GetServerTimeNow()
        local Ready

        if v9 ~= nil then
            Ready = v9.Ready

            if Ready then
                Ready = v9.Enabled

                if Ready then
                    Ready = false

                    if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                        Ready = ServerTimeNow < v9.EventEndsAt
                    end
                end
            end
        else
            Ready = false
        end

        if not Ready then
            t2.Close()
        end

        v12()
    end

    function t2.ShowVault() -- line: 227
        -- upvalues: v9 (ref), v12 (ref), Tabs (copy)
        local ServerTimeNow = workspace:GetServerTimeNow()
        local Ready

        if v9 ~= nil then
            Ready = v9.Ready

            if Ready then
                Ready = v9.Enabled

                if Ready then
                    Ready = false

                    if v9.WorldReady == true and type(v9.EventEndsAt) == "number" then
                        Ready = ServerTimeNow < v9.EventEndsAt
                    end
                end
            end
        else
            Ready = false
        end

        if Ready and v9.State.Discovered then
            Tabs.Activate("StolenVaultEvent")
            v12()
        end
    end

    function t2.Close() -- line: 234
        -- upvalues: Tabs (copy)
        if Tabs.IsActive("StolenVaultEvent") then
            Tabs.Deactivate()
        end
    end

    function t2.Tick(p10) -- line: 239
        -- upvalues: t2 (copy), StolenVaultEvent (copy), ContentFrame (copy), v9 (ref), countdown (copy)
        if v9 and StolenVaultEvent.Enabled then
            local v38 = math.max(0, (v9.EventEndsAt or 0) - p10)
            local v39 = if v38 > 0 then countdown(v38) else "Event ended"

            if ContentFrame.Timer.Text ~= v39 then
                ContentFrame.Timer.Text = v39
            end

            if v38 <= 0 then
                t2.Close()
            end
        end
    end

    if workspace.CurrentCamera then
        v8:Add(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v20))
    end

    v20()

    function t2.Destroy() -- line: 256
        -- upvalues: v8 (copy), v11 (ref)
        v11 = false
        v8:Destroy()
    end

    return t2
end

return t1
