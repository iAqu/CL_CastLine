local function read(path)
 local file = assert(io.open(path, "r"))
 local source = file:read("*a")
 file:close()
 return source
end
local config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local settings = config.Bite.Drip
local warnings, sources, records = 0, true, {}
local points = {}
for _, name in ipairs(settings.Points) do
 points["FishDrip_" .. name] = {
  Name = name,
  Parent = { IsA = function(_, class) return class == "Bone" end },
  IsA = function(_, class) return class == "Attachment" end,
 }
end
local function range(low, high) return { Min = low, Max = high or low } end
local function vector(x, y, z) return { X = x, Y = y, Z = z } end
local prototype = {}
function prototype:Clone()
 local emitter = {
  Rate = 4, Enabled = false, Drag = 10, Acceleration = vector(0, -150, 0),
  Lifetime = range(0.25, 0.6), TimeScale = 0.5, cleared = 0, destroyed = 0,
 }
 function emitter:Emit(count)
  table.insert(records, { emitter = self, point = self.Parent.Name, count = count })
 end
 function emitter:Clear() self.cleared += 1 end
 function emitter:Destroy() self.destroyed += 1 end
 return emitter
end
local template = { FindFirstChildOfClass = function() return prototype end }
local storage = { FindFirstChild = function()
 if not sources then return nil end
 return { FindFirstChild = function()
  return { FindFirstChild = function() return template end }
 end }
end }
local environment = setmetatable({
 script = { Parent = { FishingConfig = "config" } },
 game = { GetService = function() return storage end },
 require = function(name) assert(name == "config") return config end,
 NumberRange = { new = range }, Vector2 = { new = vector }, Vector3 = { new = vector },
 Enum = { NormalId = { Top = "Top" } },
 warn = function() warnings += 1 end,
}, { __index = getfenv() })
local Drip = assert(load(read("src/ReplicatedStorage/Modules/FishDripEffect.lua"), "Drip", "t", environment))()
local fish = { PrimaryPart = { FindFirstChild = function(_, name) return points[name] end } }
local function rng()
 local seed = 71
 return { NextInteger = function(_, low, high)
  seed = (seed * 48271) % 2147483647
  return low + seed % (high - low + 1)
 end }
end
local function effect()
 records = {}
 return Drip.new(fish, rng())
end
local current = effect()
assert(#current.emitters == 24 and #current.burstEmitters == 24, "Both layers need all surface points")
for _, emitter in ipairs(current.emitters) do
 assert(not emitter.Enabled and emitter.Rate == 0, "Native emitters must not batch automatic droplets")
 assert(emitter.Drag == 10 and emitter.Acceleration.Y == -150 and emitter.TimeScale == 0.5)
end
for _, emitter in ipairs(current.burstEmitters) do
 assert(not emitter.Enabled and emitter.Rate == 0)
 assert(emitter.Speed.Min == 10 and emitter.Speed.Max == 16 and emitter.Drag == 2)
 assert(emitter.Acceleration.Y == -60 and emitter.Lifetime.Min == 0.45 and emitter.Lifetime.Max == 0.65)
end
for _, phase in ipairs({ "Waiting", "Struggling", "Lifting", "Escaped" }) do
 current:Update(phase, 1, { name = "ShowcaseFlop", token = 0, position = 0.15 })
end
assert(#records == 0, "Droplets leaked outside Caught")

-- Same absolute clock at low and high frame rates: no density dependence on point count/FPS.
for _, fps in ipairs({ 15, 30, 60, 144 }) do
 current = effect()
 for frame = 0, fps * 10 do current:Update("Caught", frame / fps) end
 assert(#records == 80, "Decay integral should produce 50 droplets in 4s, then 5/s")
 for first = 1, 49, 24 do
  local seen = {}
  for index = first, first + 23 do
   local record = records[index]
   assert(record.count == 1 and not seen[record.point], "Point repeated inside shuffled cycle")
   seen[record.point] = true
  end
 end
 local before = #records
 current:Update("Caught", 10)
 assert(#records == before, "Repeated Present emitted the same time slice twice")
 current:Update("Caught", 100)
 assert(#records - before == 4, "Long frame exceeded catch-up cap")
 before = #records
 current:Update("Caught", 100.01)
 assert(#records == before, "Expired particles accumulated as emission debt")
 current:Destroy()
end

current = effect()
current:Update("Caught", 0, { name = "ShowcaseFlop", token = 0, position = 0 })
assert(#records == 0, "Burst preceded the actual tail movement")
current:Update("Caught", 0.15, { name = "ShowcaseFlop", token = 0, position = 0.15 })
local seen, burstCount = {}, 0
for _, record in ipairs(records) do
 if record.emitter.Name == "ShowcaseBurst" then
  assert(not seen[record.point], "Burst reused a surface point")
  seen[record.point], burstCount = true, burstCount + record.count
 end
end
assert(burstCount == 10, "One flop should emit exactly 10 droplets across distinct points")
local before = #records
current:Update("Caught", 0.15, { name = "ShowcaseFlop", token = 0, position = 0.15 })
assert(#records == before, "Repeated animation token duplicated burst")
current:Update("Caught", 0.4, { name = "ShowcaseFlop", token = 1, position = 0.4 })
assert(current.lastBurst == 1, "Expired window was not consumed")
current:Update("Caught", 0.4, { name = "ShowcaseFlop", token = 1, position = 0.2 })
for _, emitter in ipairs(current.emitters) do
 assert(emitter.Speed.Min == 0.2 and emitter.Speed.Max == 0.6 and emitter.Drag == 10, "Burst changed live drip motion")
end
local emitters = {}
for _, layer in ipairs({ current.emitters, current.burstEmitters }) do
 for _, emitter in ipairs(layer) do table.insert(emitters, emitter) end
end
current:Update("Escaped", 0)
current:Update("Escaped", 0)
for _, emitter in ipairs(emitters) do assert(emitter.cleared == 1 and not emitter.Enabled) end
current:Destroy()
current:Destroy()
for _, emitter in ipairs(emitters) do assert(emitter.destroyed == 1 and emitter.cleared == 2) end
before = #records
current:Update("Caught", 0.15, { name = "ShowcaseFlop", token = 4, position = 0.15 })
assert(#records == before, "Destroyed effect emitted again")
sources = false
local missing = effect()
for _ = 1, 10 do missing:Update("Caught", 10) end
assert(warnings == 1 and #missing.emitters == 0, "Missing template warned every frame")
missing:Destroy()
