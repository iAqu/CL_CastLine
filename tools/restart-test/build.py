#!/usr/bin/env python3
"""Build a deterministic local Studio plugin; optionally install with backup."""
import argparse
from datetime import datetime, timezone
import hashlib
from pathlib import Path
import shutil
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parent


def script_item(parent, class_name, name, source):
    item = ET.SubElement(parent, "Item", {"class": class_name})
    props = ET.SubElement(item, "Properties")
    ET.SubElement(props, "string", {"name": "Name"}).text = name
    ET.SubElement(props, "ProtectedString", {"name": "Source"}).text = source
    return item


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--install", action="store_true")
    parser.add_argument("--plugins-dir", type=Path, default=Path.home() / "Documents/Roblox/Plugins")
    args = parser.parse_args()
    model = ET.Element("roblox", {"version": "4"})
    entry_source = (ROOT / "init.server.luau").read_text()
    controller_source = (ROOT / "Controller.luau").read_text()
    main_script = script_item(model, "Script", "RestartTest", entry_source)
    script_item(main_script, "ModuleScript", "Controller", controller_source)
    build_id = hashlib.sha256((entry_source + "\n" + controller_source).encode()).hexdigest()[:12]
    version = ET.SubElement(main_script, "Item", {"class": "StringValue"})
    props = ET.SubElement(version, "Properties")
    ET.SubElement(props, "string", {"name": "Name"}).text = "BuildId"
    ET.SubElement(props, "string", {"name": "Value"}).text = build_id
    ET.indent(model, space="\t")
    output = ROOT / "RestartTest.rbxmx"
    # Roblox tooling identifies XML models by the opening <roblox tag.
    ET.ElementTree(model).write(output, encoding="utf-8", xml_declaration=False)
    # Verify serialization preserves the source exactly, including XML metacharacters.
    parsed = ET.parse(output)
    for item, filename in zip(parsed.findall(".//Item"), ("init.server.luau", "Controller.luau")):
        assert item.find("./Properties/ProtectedString").text == (ROOT / filename).read_text()
    print(f"Built: {output}")
    if args.install:
        args.plugins_dir.mkdir(parents=True, exist_ok=True)
        target = args.plugins_dir / output.name
        if target.exists():
            backup_dir = args.plugins_dir / "RestartTest.backups"
            backup_dir.mkdir(exist_ok=True)
            stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
            backup = backup_dir / f"RestartTest.{stamp}.rbxmx.bak"
            shutil.copy2(target, backup)
            print(f"Backup: {backup}")
        temp = target.with_suffix(".rbxmx.tmp")
        shutil.copy2(output, temp)
        temp.replace(target)
        print(f"Installed: {target}")
        print("Stop testing, then Reload Plugin in EVERY open Studio window (even if its button is visible).")
        print("Editor and test plugin versions must match; reopening Studio after saving also works.")


if __name__ == "__main__":
    main()
