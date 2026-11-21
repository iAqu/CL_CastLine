local WeightFormat = require("../src/ReplicatedStorage/Modules/WeightFormat")

assert(WeightFormat.FormatKg(2) == "2.0 kg")
assert(WeightFormat.FormatKg(9.79) == "9.8 kg")
assert(WeightFormat.FormatKg(9.9) == "9.9 kg")
assert(WeightFormat.FormatKg(10) == "10 kg")
assert(WeightFormat.FormatKg(10.1) == "10 kg")
assert(WeightFormat.FormatKg(11.5) == "12 kg")
assert(WeightFormat.FormatKg(19.6) == "20 kg")
assert(WeightFormat.FormatKg(1200) == "1200 kg")
assert(WeightFormat.FormatKg(1234567) == "1234567 kg")

print("WeightFormat.test.lua passed")
