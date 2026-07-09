#!/usr/bin/env python3
from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

from lib import xcode_env

ROOT = Path(__file__).resolve().parent.parent
PROJECT = "@ign-var:IOS_APP_TARGET=App@.xcodeproj"
SCHEME = "@ign-var:IOS_APP_TARGET=App@"
APP_NAME = "@ign-var:IOS_APP_TARGET=App@"
ARCHIVE_PATH = Path(os.environ.get("IOS_APP_ARCHIVE_PATH", f".build/xcode-archives/{APP_NAME}.xcarchive"))
LOG_PATH = Path(os.environ.get("IOS_APP_SIGNED_ARCHIVE_LOG", ".build/xcode-archives/signed-archive.log"))
TEAM_ID = os.environ.get("IOS_APP_APPLE_TEAM_ID", os.environ.get("APPLE_TEAM_ID", "@ign-var:DEVELOPMENT_TEAM=TEAMID@"))


def main() -> int:
  if not TEAM_ID or TEAM_ID == "TEAMID":
    raise SystemExit("Apple team ID is required. Set IOS_APP_APPLE_TEAM_ID or APPLE_TEAM_ID.")

  developer_dir = xcode_env.apply_xcode_env()
  xcodebuild = xcode_env.xcodebuild_path(developer_dir)
  if not Path(xcodebuild).is_file():
    raise SystemExit(f"xcodebuild not found at {xcodebuild}")

  archive_path = ROOT / ARCHIVE_PATH
  log_path = ROOT / LOG_PATH
  if archive_path.exists():
    if not str(ARCHIVE_PATH).startswith(".build/"):
      raise SystemExit(f"Archive path already exists outside .build: {ARCHIVE_PATH}")
    shutil.rmtree(archive_path)
  archive_path.parent.mkdir(parents=True, exist_ok=True)
  log_path.parent.mkdir(parents=True, exist_ok=True)

  with log_path.open("w", encoding="utf-8") as log:
    subprocess.run(
      [
        xcodebuild,
        "-quiet",
        "-project",
        PROJECT,
        "-scheme",
        SCHEME,
        "-configuration",
        "Release",
        "-destination",
        "generic/platform=iOS",
        "-archivePath",
        str(ARCHIVE_PATH),
        "-allowProvisioningUpdates",
        f"DEVELOPMENT_TEAM={TEAM_ID}",
        f"LD={xcode_env.clang_path(developer_dir)}",
        "archive",
      ],
      cwd=ROOT,
      check=True,
      env=os.environ.copy(),
      stdout=log,
      stderr=subprocess.STDOUT,
    )

  print(f"Signed archive created: {ARCHIVE_PATH}")
  print(f"Archive log: {LOG_PATH}")
  return 0


if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except subprocess.CalledProcessError as error:
    print(f"Signed archive failed. Full xcodebuild log: {LOG_PATH}")
    raise SystemExit(error.returncode) from error
