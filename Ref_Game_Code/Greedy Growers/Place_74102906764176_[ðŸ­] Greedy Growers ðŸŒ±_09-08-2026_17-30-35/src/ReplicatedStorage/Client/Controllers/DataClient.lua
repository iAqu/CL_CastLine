-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Packages = ReplicatedStorage.Packages
local Knit = require(Packages.Knit)
local Signal = require(Packages.Signal)

require(ReplicatedStorage.Shared.Info.CustomEnum)

local v1 = Knit.CreateController({
	Name = "DataClient"
})

v1.currentData = nil
v1.EV_FIRST_UPDATE = Signal.new()
v1.EV_UPDATE = Signal.new()

local function recursiveDataUpdate(p1, p2, p3) --[[ recursiveDataUpdate | Line: 22 ]]
	for v1, v2 in p2 do
		local v3 = p1[v2]

		if v3 == nil then
			v3 = p1[tostring(v2)]
		end

		if v1 < #p2 then
			if not p3[v2] then
				p3[v2] = {}
			end

			p1 = p1[v2]
			p3 = p3[v2]

			continue
		end

		p3[v2] = v3
	end
end

function v1.KnitStart(p1) --[[ KnitStart | Line: 41 | Upvalues: recursiveDataUpdate (copy), RunService (copy) ]]
	local v1 = true

	p1.DataService.DataUpdate:Connect(function(p12, p2) --[[ Line: 44 | Upvalues: p1 (copy), recursiveDataUpdate (ref), v1 (ref) ]]
		if p2 == nil then
			p1.currentData = p12
		else
			recursiveDataUpdate(p12, p2, p1.currentData)
		end

		if v1 then
			print("FIRST DATA UPDATE!!")
			p1.EV_FIRST_UPDATE:Fire()
			v1 = false
		end

		p1.EV_UPDATE:Fire()
	end)

	if RunService:IsStudio() then
		return
	end

	p1.AdminHandler.errorLog:Connect(function(p1, p2, p3) --[[ Line: 66 ]]
		warn("{SERVER ERROR}: ", p1)
		warn("stack trace ", p2)
	end)
end
function v1.KnitInit(p1) --[[ KnitInit | Line: 73 | Upvalues: Knit (copy) ]]
	p1.DataService = Knit.GetService("DataService")
	p1.AdminHandler = Knit.GetService("AdminHandler")
end
function v1.GetLoaded(p1) --[[ GetLoaded | Line: 78 | Upvalues: v1 (copy) ]]
	return v1.currentData ~= nil
end

return v1