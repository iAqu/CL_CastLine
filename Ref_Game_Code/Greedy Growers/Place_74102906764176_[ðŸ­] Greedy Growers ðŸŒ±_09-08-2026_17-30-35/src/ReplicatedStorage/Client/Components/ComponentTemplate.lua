-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMbB09uU3RhcnQFYXdhaXQDbmV3BV9tYWlkBVN0YXJ0B0Rlc3Ryb3kEU3RvcARnYW1lB1BsYXllcnMKR2V0U2VydmljZRFSZXBsaWNhdGVkU3RvcmFnZRFDb2xsZWN0aW9uU2VydmljZQxUd2VlblNlcnZpY2UHcmVxdWlyZQhQYWNrYWdlcwRLbml0CUNvbXBvbmVudARNYWlkBlNoYXJlZARJbmZvCUNvbnN0YW50cwZBc3NldHMMV2FpdEZvckNoaWxkCVBhcnRpY2xlcwRNaXNjA1RhZxFDb21wb25lbnRUZW1wbGF0ZQADAwECAAAADvsBAABNAQEFAAAAAJ8BAQK8AQENAQAAAJ8BAgH7AQEATQEB7wIAAACfAQECMAEAwQMAAACCAAEABAMBAwIDAwMEABUFARgAAAAAAAAAAgAAAAAAAhYAAAAAAwEAAAAACU0BAMEAAAAADgEFAE0BAMEAAAAAvAEBUAEAAACfAQIBggABAAIDBAMGABwHARgAAAABAAAAAAIdAAAAAA0AAAECAFCjAAAApAABAAAAAEBvAgIAvAAAFgMAAACfAAMCpAEBAAAAAEBvAwQAvAEBFgMAAACfAQMCpAIBAAAAAEBvBAUAvAICFgMAAACfAgMCpAMBAAAAAEBvBQYAvAMDFgMAAACfAwMCpAQIAAAAcEBNBQHmCQAAAE0FBXEKAAAAnwQCAqQFCAAAAHBATQYB5gkAAABNBgaICwAAAJ8FAgKkBggAAABwQE0HAeYJAAAATQcHdgwAAACfBgICpAcIAAAAcEBNCAESDQAAAE0ICHoOAAAATQgIBw8AAACfBwICbwoQALwIAdMRAAAAnwgDAm8LEgC8CQjTEQAAAJ8JAwJvDBMAvAoI0xEAAACfCgMCTQsF7xQAAADiDBcAnwsCAsAMGAASAAQAEgAGADAMCxwZAAAAwAwaADAMC/obAAAAggsCABwDCAQAAABAAwkDCgMLAwwDDQMOBAAAcEADDwMQAxEDEgMTAxQDFQMWAxcDGAMZAwMDGgMbCAEVFgAAAAYAAwUGAQMHAgABAQABGAAAAAAAAAABAAAAAAABAAAAAAABAAAAAAACAAAAAAAAAQAAAAAAAAEAAAAAAAACAAAAAAAAAAACAAAAAQAAAAEAAAADAAAABAAAAAAHAAAGAQAAAAACrrxJxsmk9CR9yGeuglZBDd6kXrKceCPH

-- https://lua.expert/
game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("CollectionService")
game:GetService("TweenService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)
local Maid = require(ReplicatedStorage.Packages.Maid)

require(ReplicatedStorage.Shared.Info.Constants)

local Assets = ReplicatedStorage:WaitForChild("Assets")

Assets:WaitForChild("Particles")
Assets:WaitForChild("Misc")

local v1 = Component.new({
	Tag = "ComponentTemplate"
})

function v1.Start(p1) --[[ Start | Line: 21 | Upvalues: Knit (copy), Maid (copy) ]]
	Knit.OnStart():await()
	p1._maid = Maid.new()
end
function v1.Stop(p1) --[[ Stop | Line: 28 ]]
	if not p1._maid then
		return
	end

	p1._maid:Destroy()
end

return v1