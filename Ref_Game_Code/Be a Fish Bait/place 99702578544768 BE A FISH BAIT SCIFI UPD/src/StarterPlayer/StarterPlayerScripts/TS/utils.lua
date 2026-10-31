-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GuiService, Players, Workspace = services.GuiService, services.Players, services.Workspace
local v1 = tostring(Players.LocalPlayer.UserId)

return {
    screenPointToRay = function(p1, p2) -- screenPointToRay | line: 9
        -- upvalues: GuiService (copy), Workspace (copy)
        return Workspace.CurrentCamera:ViewportPointToRay(p1, p2 + GuiService:GetGuiInset().Y)
    end,
    localPlayerUserId = v1
}
