#!/usr/bin/env python3
from __future__ import annotations

import os
import re
import subprocess
import sys
import time
from pathlib import Path

from lib import xcode_env

ROOT = Path(__file__).resolve().parent.parent
BUNDLE_ID = os.environ.get("IOS_APP_BUNDLE_ID", "@ign-var:BUNDLE_IDENTIFIER=com.example.app@")
IPHONE_NAME = os.environ.get("IOS_APP_IPHONE_SIMULATOR", "iPhone 17")
IPAD_NAME = os.environ.get("IOS_APP_IPAD_SIMULATOR", "iPad (A16)")
IPHONE_APP = Path(os.environ.get("IOS_APP_IPHONE_APP", ".build/xcode-products/iphone/Debug-iphonesimulator/@ign-var:IOS_APP_TARGET=App@.app"))
IPAD_APP = Path(os.environ.get("IOS_APP_IPAD_APP", ".build/xcode-products/ipad/Debug-iphonesimulator/@ign-var:IOS_APP_TARGET=App@.app"))


def run_xcrun(*args: str, stdout: int | None = None, check: bool = True) -> subprocess.CompletedProcess[str]:
  return subprocess.run(
    ["xcrun", *args],
    cwd=ROOT,
    check=check,
    text=True,
    stdout=stdout,
    stderr=None,
    env=os.environ.copy(),
  )


def device_udid(name: str) -> str:
  output = run_xcrun("simctl", "list", "devices", "available", stdout=subprocess.PIPE).stdout
  pattern = re.compile(rf"^\s*{re.escape(name)} \(([0-9A-F-]{{36}})\)", re.MULTILINE)
  match = pattern.search(output)
  return match.group(1) if match else ""


def is_booted(udid: str) -> bool:
  output = run_xcrun("simctl", "list", "devices", stdout=subprocess.PIPE).stdout
  return udid in output and "(Booted)" in next((line for line in output.splitlines() if udid in line), "")


def smoke_device(label: str, name: str, app_path: Path, booted_by_script: list[str]) -> None:
  resolved_app_path = ROOT / app_path
  if not resolved_app_path.is_dir():
    raise SystemExit(f"{label} app bundle not found at {app_path}\nRun: task build:app")

  udid = device_udid(name)
  if not udid:
    raise SystemExit(f"Simulator '{name}' is not available.")

  was_booted = is_booted(udid)
  if not was_booted:
    run_xcrun("simctl", "boot", udid)
    booted_by_script.append(udid)
    run_xcrun("simctl", "bootstatus", udid, "-b")

  run_xcrun("simctl", "uninstall", udid, BUNDLE_ID, check=False)
  run_xcrun("simctl", "install", udid, str(resolved_app_path))
  run_xcrun("simctl", "launch", udid, BUNDLE_ID, stdout=subprocess.DEVNULL)
  time.sleep(2)
  run_xcrun("simctl", "appinfo", udid, BUNDLE_ID, stdout=subprocess.DEVNULL)
  run_xcrun("simctl", "terminate", udid, BUNDLE_ID, stdout=subprocess.DEVNULL)

  suffix = "left simulator booted" if was_booted else "simulator will shut down"
  print(f"{label} simulator smoke passed on {name} ({udid}); {suffix}.")


def main() -> int:
  xcode_env.apply_xcode_env()
  booted_by_script: list[str] = []
  try:
    smoke_device("iPhone", IPHONE_NAME, IPHONE_APP, booted_by_script)
    smoke_device("iPad", IPAD_NAME, IPAD_APP, booted_by_script)
  finally:
    for udid in booted_by_script:
      run_xcrun("simctl", "terminate", udid, BUNDLE_ID, check=False, stdout=subprocess.DEVNULL)
      run_xcrun("simctl", "shutdown", udid, check=False, stdout=subprocess.DEVNULL)
  return 0


if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except subprocess.CalledProcessError as error:
    raise SystemExit(error.returncode) from error
