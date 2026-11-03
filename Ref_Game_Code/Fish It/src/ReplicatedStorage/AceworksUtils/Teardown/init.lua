-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
require(script:WaitForChild("types-teardown-fn"))
local createFn = require(script:WaitForChild("createFn"))
local join = require(script:WaitForChild("join"))
local teardown = require(script:WaitForChild("teardown"))
require(script:WaitForChild("types"))
return {
	fn = createFn,
	teardown = teardown,
	join = join
}