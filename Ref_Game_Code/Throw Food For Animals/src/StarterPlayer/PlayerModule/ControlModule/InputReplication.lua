-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserPlayerScriptsCCLIntegrationD = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD")
local UserControlModuleEnabledAPI = FlagUtil.getUserFlag("UserControlModuleEnabledAPI")
local StarterPlayer = game:GetService("StarterPlayer")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Workspace = game:GetService("Workspace")
local AvatarAbilitiesInterface = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
local UserAbilitiesUserInterfaceB = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceB")
local v1 = if UserAbilitiesUserInterfaceB then "ControlState" else "PlayerControlState"
local t1 = {}

t1.__index = t1

function t1._calculatePlayerInputValues(p1) -- line: 15
    local Character = p1.Character

    if Character ~= nil then
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil then
            local InputContexts = p1:FindFirstChild("InputContexts")

            if InputContexts ~= nil then
                local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

                if CharacterContext ~= nil then
                    local MoveAction = CharacterContext.MoveAction
                    local RotationAction = CharacterContext:FindFirstChild("RotationAction")
                    local v2 = RotationAction ~= nil and RotationAction:GetState()

                    local function isValidInput2D(p2) -- line: 36
                        return not (p2.X ~= p2.X or p2.Y ~= p2.Y or p2.X == 1e999 or p2.Y == 1e999)
                    end

                    local function isValidInput3D(p3) -- line: 44
                        return not (p3.X ~= p3.X
                            or p3.Y ~= p3.Y
                            or p3.Z ~= p3.Z
                            or p3.X == 1e999
                            or p3.Y == 1e999
                            or p3.Z == 1e999)
                    end

                    local v3 = if MoveAction == nil then Vector2.new(0, 0) else MoveAction:GetState()
                    local LookVector = p1:GetCameraState().CFrame.LookVector

                    if v3.X == v3.X and v3.Y == v3.Y and v3.X ~= 1e999 and v3.Y ~= 1e999 and LookVector.X == LookVector.X and LookVector.Y == LookVector.Y and LookVector.Z == LookVector.Z and LookVector.X ~= 1e999 and LookVector.Y ~= 1e999 and LookVector.Z ~= 1e999 and LookVector.Magnitude > 0 then
                        local v4 = if not Humanoid or Humanoid:GetState() == Enum.HumanoidStateType.Swimming then LookVector else Vector3.new(LookVector.X, 0, LookVector.Z).Unit
                        local Unit = v4:Cross((Vector3.new(0, 1, 0))).Unit

                        return v4 * v3.Y + Unit * v3.X, v4, v2
                    end
                end
            end
        end
    end

    return Vector3.new(0, 0, 0), Vector3.new(0, 0, 1), false
end

function t1.CloneInputsIfAbsent(p4) -- line: 74
    -- upvalues: StarterPlayer (copy)
    if p4:FindFirstChild("InputContexts") then
        return
    end

    local clone = StarterPlayer.PlayerModule.InputContexts:Clone()

    clone.CharacterContext.Enabled = true
    clone.CameraContext.Enabled = true
    clone.Parent = p4
end

function t1.FireCustomInputs(p5) -- line: 83
    -- upvalues: UserGameSettings (copy)
    local InputContexts = p5:FindFirstChild("InputContexts")

    if InputContexts then
        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext and InputContexts:FindFirstChild("CameraContext") then
            local RotationAction = CharacterContext:FindFirstChild("RotationAction")
            local RotationScriptableBinding, v5

            if RotationAction then
                RotationScriptableBinding = RotationAction:FindFirstChild("RotationScriptableBinding")

                if RotationScriptableBinding then
                    v5 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                    RotationScriptableBinding:Fire(v5)
                end
            end
        end
    end
end

function t1.SendInputToCCLCharacter(p6) -- line: 102
    -- upvalues: AvatarAbilitiesInterface (copy), t1 (copy)
    if not p6 then
        return
    end

    local v6 = AvatarAbilitiesInterface.get(p6)
    local InputContexts = p6:FindFirstChild("InputContexts")

    if InputContexts then
        local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

        if CharacterContext then
            for _, v7 in v6:GetAbilities() do
                local v8 = CharacterContext:FindFirstChild(v7 .. "Action")

                if v8 then
                    v6:SendInput(v7, v8:GetState())
                end
            end

            local v9, v10, v11 = t1._calculatePlayerInputValues(p6)

            v6:SendInput("Move", v9)
            v6:SendInput("CameraLookDirection", v10)
            v6:SendInput("CameraRelativeRotation", v11)
        end
    end
end

function t1.SendInputToHumanoidForServerAuth(p7) -- line: 123
    -- upvalues: t1 (copy)
    local Character = p7.Character

    if Character ~= nil then
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil then
            local InputContexts = p7:FindFirstChild("InputContexts")

            if InputContexts ~= nil then
                local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

                if CharacterContext ~= nil then
                    local JumpAction = CharacterContext.JumpAction
                    local v12, v13, v14 = t1._calculatePlayerInputValues(p7)

                    Humanoid:Move(v12)
                    Humanoid.AutoRotate = not v14

                    if v14 and Humanoid.SeatPart == nil and Humanoid.RootPart ~= nil and not Humanoid.Sit and not Humanoid.RootPart:IsGrounded() then
                        Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + v13)
                    end

                    if JumpAction ~= nil then
                        Humanoid.Jump = JumpAction:GetState()
                    else
                        Humanoid.Jump = false
                    end
                end
            end
        end
    end
end

function t1.setupPlayerControlState(p8) -- line: 152
    p8:AddVector3Field("Move", Vector3.new(0, 0, 0), 1)
    p8:AddBoolField("Jump", false)
    p8:AddBoolField("RotateToLookDirection", false)
    p8:AddUnitVector3Field("LookDirection", (Vector3.new(0, 0, 1)))
end

function t1.watchForPlayerControlState(p9) -- line: 160
    -- upvalues: t1 (copy), v1 (copy)
    local function watchCharacter(p10) -- line: 161
        -- upvalues: t1 (copy), v1 (copy)
        local function onPCSAdded(p11) -- line: 162
            -- upvalues: t1 (copy), v1 (copy)
            if p11:IsA(v1) then
                t1.setupPlayerControlState(p11)
            end
        end

        local v15 = p10:FindFirstChildOfClass(v1)

        if v15 then
            t1.setupPlayerControlState(v15)
        end

        p10.ChildAdded:Connect(onPCSAdded)
    end

    if p9.Character then
        local Character = p9.Character

        local function onPCSAdded(p12) -- line: 162
            -- upvalues: t1 (copy), v1 (copy)
            if p12:IsA(v1) then
                t1.setupPlayerControlState(p12)
            end
        end

        local v16 = Character:FindFirstChildOfClass(v1)

        if v16 then
            t1.setupPlayerControlState(v16)
        end

        Character.ChildAdded:Connect(onPCSAdded)
    end

    p9.CharacterAdded:Connect(watchCharacter)
end

function t1.createPlayerControlState(p13) -- line: 176
    -- upvalues: UserAbilitiesUserInterfaceB (copy), t1 (copy), v1 (copy)
    local function createForCharacter(p14) -- line: 177
        -- upvalues: p13 (copy), UserAbilitiesUserInterfaceB (copy), t1 (copy), v1 (copy)
        local v17, v18

        if UserAbilitiesUserInterfaceB then
            v17 = p14:FindFirstChildOfClass(v1)
        else
            v18 = p14:FindFirstChild(v1)
        end

        if (not UserAbilitiesUserInterfaceB or v17) and (UserAbilitiesUserInterfaceB or v18) then
            return
        end

        local v19 = Instance.new(v1)

        v19.Owner = p13
        v19.Parent = p14
        t1.setupPlayerControlState(v19)
    end

    local Character, v20

    if p13.Character then
        Character = p13.Character
        v20 = if UserAbilitiesUserInterfaceB then not not Character:FindFirstChildOfClass(v1) else not not Character:FindFirstChild(v1)
    else
        v20 = true
    end

    if not v20 then
        local v21 = Instance.new(v1)

        v21.Owner = p13
        v21.Parent = Character
        t1.setupPlayerControlState(v21)
    end

    p13.CharacterAdded:Connect(createForCharacter)
end

function t1.writeInputToPCS(p15, p16, p17) -- line: 193
    -- upvalues: UserPlayerScriptsCCLIntegrationD (copy), UserControlModuleEnabledAPI (copy), UserGameSettings (copy), Workspace (copy), AvatarAbilitiesInterface (copy), UserAbilitiesUserInterfaceB (copy), v1 (copy)
    local data = if UserControlModuleEnabledAPI then p16.data else nil
    local Character = p15.Character

    if Character then
        local v22 = if UserAbilitiesUserInterfaceB then Character:FindFirstChildOfClass(v1) else Character:FindFirstChild(v1)

        if v22 then
            local humanoid = p16.humanoid

            if humanoid then
                local InputContexts = if p17 then p15:FindFirstChild("InputContexts") else script.Parent.Parent:FindFirstChild("InputContexts")
                local v23, v24

                if UserControlModuleEnabledAPI then
                    v24 = data.isJumping
                    v23 = data.worldMoveVector
                else
                    local CharacterContext = InputContexts and InputContexts:FindFirstChild("CharacterContext")

                    if not CharacterContext then
                        return
                    end

                    local MoveAction = CharacterContext:FindFirstChild("MoveAction")
                    local JumpAction = CharacterContext:FindFirstChild("JumpAction")
                    local v25 = if MoveAction then MoveAction:GetState() else Vector2.zero

                    v24 = if JumpAction then JumpAction:GetState() else false
                    v23 = p16:calculateRawMoveVector(humanoid, (Vector3.new(v25.X, 0, -v25.Y)))
                end

                local v27 = UserGameSettings.RotationType == Enum.RotationType.CameraRelative
                local LookVector = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1)
                local v28 = Vector3.new(LookVector.X, 0, LookVector.Z)
                local t2 = {
                    Move = v23,
                    RotateToLookDirection = v27,
                    LookDirection = if v28.Magnitude > 0.001 then v28.Unit else Vector3.new(0, 0, 1)
                }

                if not (UserPlayerScriptsCCLIntegrationD and AvatarAbilitiesInterface.get(p15):isEnabled()) then
                    t2.Jump = v24
                end

                v22:UpdateFields(t2)
            end
        end
    end
end

function t1.processPCSInputs(p18) -- line: 247
    -- upvalues: UserAbilitiesUserInterfaceB (copy), v1 (copy)
    local Character = p18.Character

    if Character ~= nil then
        local Humanoid = Character:FindFirstChild("Humanoid")

        if Humanoid ~= nil then
            local v29 = if UserAbilitiesUserInterfaceB then Character:FindFirstChildOfClass(v1) else Character:FindFirstChild(v1)

            if v29 ~= nil then
                local State = v29:GetState()
                local Move, Jump, RotateToLookDirection, LookDirection = State.Move, State.Jump, State.RotateToLookDirection, State.LookDirection

                if Move then
                    Humanoid:Move(Move)
                end

                Humanoid.AutoRotate = not RotateToLookDirection

                if RotateToLookDirection and LookDirection ~= nil and Humanoid.RootPart ~= nil and not Humanoid.Sit and Humanoid.SeatPart == nil and not Humanoid.RootPart:IsGrounded() then
                    Humanoid.RootPart.CFrame = CFrame.new(Humanoid.RootPart.CFrame.Position, Humanoid.RootPart.CFrame.Position + LookDirection)
                end

                Humanoid.Jump = Jump or false
            end
        end
    end
end

return t1
