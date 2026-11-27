-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local CmdrClient = require(ReplicatedStorage:WaitForChild("CmdrClient"))
local v1 = false

CmdrClient:SetActivationKeys({
    Enum.KeyCode.F2,
    Enum.KeyCode.Z
})

local function setMobileButtonEnabled(p1) -- line: 16
    -- upvalues: ContextActionService (copy), UserInputService (copy), CmdrClient (copy), v1 (ref)
    local v2 = p1 and UserInputService.TouchEnabled

    if v2 ~= v1 then
        v1 = v2

        if v2 then
            ContextActionService:BindAction("OpenAdminCmdr", function(_, p3) -- line: 28
                -- upvalues: CmdrClient (copy)
                if p3 == Enum.UserInputState.Begin then
                    task.defer(function() -- line: 30
                        -- upvalues: CmdrClient (copy)
                        CmdrClient:Toggle()
                    end)
                end

                return Enum.ContextActionResult.Sink
            end, true)
            ContextActionService:SetTitle("OpenAdminCmdr", "CMD")
            ContextActionService:SetPosition("OpenAdminCmdr", UDim2.new(1, -165, 1, -155))
        else
            ContextActionService:UnbindAction("OpenAdminCmdr")
        end
    end
end

local function applyAuthorization() -- line: 40
    -- upvalues: LocalPlayer (copy), CmdrClient (copy), setMobileButtonEnabled (copy)
    local v3 = LocalPlayer:GetAttribute("CmdrAuthorized") == true

    CmdrClient:SetEnabled(v3)

    if not v3 then
        CmdrClient:Hide()
    end

    setMobileButtonEnabled(v3)
end

local v4 = LocalPlayer:GetAttribute("CmdrAuthorized") == true

CmdrClient:SetEnabled(v4)

if not v4 then
    CmdrClient:Hide()
end

setMobileButtonEnabled(v4)
LocalPlayer:GetAttributeChangedSignal("CmdrAuthorized"):Connect(applyAuthorization)
