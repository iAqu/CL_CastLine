local preloaderPath = "src/StarterPlayer/StarterPlayerScripts/ResourcePreloader.client.lua"

local file = assert(io.open(preloaderPath, "r"))
local source = file:read("*a")
file:close()

assert(source:find(":WaitForChild%([\"']Sound[\"']%)"), "ResourcePreloader should wait for ReplicatedStorage.Sound before preloading")
assert(source:find(":WaitForChild%([\"']Animation[\"']%)"), "ResourcePreloader should wait for ReplicatedStorage.Animation before preloading")
assert(not source:find("AnimalRollerConfig"), "ResourcePreloader should not reference removed Roll assets")

print("ResourcePreloaderLoadOrder.test.lua passed")
