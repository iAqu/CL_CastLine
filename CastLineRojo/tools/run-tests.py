#!/usr/bin/env python3
"""Run source-contract and mocked-service tests with the Luau CLI.

Usage: python3 tools/run-tests.py [EquipmentServices HomeLuckDisplay ...]
"""
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def luau_string(value):
    for length in range(1, 32):
        close = "]" + "=" * length + "]"
        if close not in value:
            return "[" + "=" * length + "[" + value + close
    raise ValueError("Could not delimit source text")


def main():
    executable = shutil.which("luau")
    if not executable:
        raise SystemExit("Install the Luau CLI before running these tests")
    tests = sorted((ROOT / "tests").glob("*.test.lua"))
    if sys.argv[1:]:
        requested = {Path(name).name.removesuffix(".test.lua") for name in sys.argv[1:]}
        tests = [test for test in tests if test.name.removesuffix(".test.lua") in requested]
        missing = requested - {test.name.removesuffix(".test.lua") for test in tests}
        if missing:
            raise SystemExit("Unknown tests: " + ", ".join(sorted(missing)))
    sources = sorted(path for path in (ROOT / "src").rglob("*") if path.suffix in {".lua", ".luau"})
    sources += sorted((ROOT / "tests" / "helpers").rglob("*.lua"))
    bundle = ["local sources = {"]
    bundle.extend(
        "[ " + luau_string(str(path.relative_to(ROOT))) + " ] = " + luau_string(path.read_text()) + ","
        for path in sources
    )
    bundle.append("""}
local base = getfenv()
local failures = 0
local function testEnvironment()
 local env = setmetatable({}, {__index = base})
 env._G = env
 env.io = {open = function(path)
  local source = sources[path]
  if not source then return nil, "Missing file: " .. path end
  return {read = function() return source end, close = function() end}
 end}
 env.loadstring = function(source, name)
  local chunk, err = loadstring(source, name)
  if chunk then setfenv(chunk, env) end
  return chunk, err
 end
 env.load = function(source, name, _mode, requestedEnv)
  local chunk, err = loadstring(source, name)
  if chunk then setfenv(chunk, requestedEnv or env) end
  return chunk, err
 end
 env.dofile = function(path) return assert(env.loadstring(sources[path], path))() end
 local cache = {}
 env.require = function(path)
  local normalized = path
  if string.sub(path, 1, 3) == "../" then normalized = string.sub(path, 4)
  elseif string.sub(path, 1, 2) == "./" then normalized = "tests/" .. string.sub(path, 3) end
  normalized ..= ".lua"
  if cache[normalized] == nil then cache[normalized] = env.dofile(normalized) end
  return cache[normalized]
 end
 return env
end
""")
    for test in tests:
        bundle.append(
            "do\n local env = testEnvironment()\n local chunk, err = env.loadstring("
            + luau_string(test.read_text()) + ", " + luau_string(test.name)
            + ")\n local ok = false\n if chunk then ok, err = pcall(chunk) end\n"
            + " if not ok then failures += 1; print(\"FAIL\", " + luau_string(test.name)
            + ", err) end\nend"
        )
    bundle.append(f'print("Tests: {len(tests)}; failures: " .. failures)\nif failures > 0 then error("Test failures") end')
    with tempfile.TemporaryDirectory(prefix="castline-tests-") as directory:
        script = Path(directory) / "run.luau"
        script.write_text("\n".join(bundle))
        return subprocess.run([executable, str(script)], cwd=ROOT).returncode


if __name__ == "__main__":
    raise SystemExit(main())
