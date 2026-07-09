#!/usr/bin/env python3
from __future__ import annotations

import os
import platform
import subprocess
import sys
from pathlib import Path

from lib import xcode_env

ROOT = Path(__file__).resolve().parent.parent
PROJECT = "@ign-var:IOS_APP_TARGET=App@.xcodeproj"
TARGET = "@ign-var:IOS_APP_TARGET=App@"


def simulator_arch() -> str:
  machine = platform.machine()
  return "x86_64" if machine == "x86_64" else "arm64"


def build_for_device_family(label: str, device_family: str, developer_dir: str) -> None:
  xcodebuild = xcode_env.xcodebuild_path(developer_dir)
  if not Path(xcodebuild).is_file():
    raise SystemExit(f"xcodebuild not found at {xcodebuild}")

  subprocess.run(
    [
      xcodebuild,
      "-quiet",
      "-project",
      PROJECT,
      "-target",
      TARGET,
      "-configuration",
      "Debug",
      "-sdk",
      "iphonesimulator",
      "CODE_SIGNING_ALLOWED=NO",
      f"ARCHS={simulator_arch()}",
      "ONLY_ACTIVE_ARCH=NO",
      f"LD={xcode_env.clang_path(developer_dir)}",
      f"SYMROOT=.build/xcode-products/{label}",
      f"OBJROOT=.build/xcode-objects/{label}",
      f"TARGETED_DEVICE_FAMILY={device_family}",
      "build",
    ],
    cwd=ROOT,
    check=True,
    env=os.environ.copy(),
  )


def main() -> int:
  developer_dir = xcode_env.apply_xcode_env()
  build_for_device_family("iphone", "1", developer_dir)
  build_for_device_family("ipad", "2", developer_dir)
  return 0


if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except subprocess.CalledProcessError as error:
    raise SystemExit(error.returncode) from error
