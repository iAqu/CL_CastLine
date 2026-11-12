local preloaderPath = "src/StarterPlayer/StarterPlayerScripts/ResourcePreloader.client.lua"

local file = assert(io.open(preloaderPath, "r"))
local source = file:read("*a")
file:close()

assert(source:find('ReplicatedFirst:WaitForChild("CriticalResourcePreloader")', 1, true),
	"Fallback startup must use the same ReplicatedFirst preloader as the loading screen")
assert(source:find("CriticalResourcePreloader.Start()", 1, true))
assert(not source:find("PreloadAsync", 1, true), "Do not start a competing general preload")
assert(not source:find("AnimalRollerConfig"), "ResourcePreloader should not reference removed Roll assets")

print("ResourcePreloaderLoadOrder.test.lua passed")
