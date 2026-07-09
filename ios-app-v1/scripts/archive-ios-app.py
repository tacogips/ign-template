#!/usr/bin/env python3
from __future__ import annotations

import os
import plistlib
import shutil
import subprocess
from pathlib import Path

from lib import xcode_env

ROOT = Path(__file__).resolve().parent.parent
PROJECT = "@ign-var:IOS_APP_TARGET=App@.xcodeproj"
SCHEME = "@ign-var:IOS_APP_TARGET=App@"
APP_NAME = "@ign-var:IOS_APP_TARGET=App@"
BUNDLE_ID = os.environ.get("IOS_APP_BUNDLE_ID", "@ign-var:BUNDLE_IDENTIFIER=com.example.app@")
ARCHIVE_PATH = Path(os.environ.get("IOS_APP_ARCHIVE_PATH", f".build/xcode-archives/{APP_NAME}.xcarchive"))


def plist_value(path: Path, *keys: str) -> object:
  with path.open("rb") as handle:
    value: object = plistlib.load(handle)
  for key in keys:
    if not isinstance(value, dict):
      raise KeyError(key)
    value = value[key]
  return value


def require_file(path: Path) -> None:
  if not path.is_file():
    raise SystemExit(f"Required archive file missing: {path}")


def main() -> int:
  developer_dir = xcode_env.apply_xcode_env()
  xcodebuild = xcode_env.xcodebuild_path(developer_dir)
  if not Path(xcodebuild).is_file():
    raise SystemExit(f"xcodebuild not found at {xcodebuild}")

  archive_path = ROOT / ARCHIVE_PATH
  if archive_path.exists():
    if not str(ARCHIVE_PATH).startswith(".build/"):
      raise SystemExit(f"Archive path already exists outside .build: {ARCHIVE_PATH}")
    shutil.rmtree(archive_path)
  archive_path.parent.mkdir(parents=True, exist_ok=True)

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
      "CODE_SIGNING_ALLOWED=NO",
      "CODE_SIGNING_REQUIRED=NO",
      "CODE_SIGN_IDENTITY=",
      "DEVELOPMENT_TEAM=",
      f"LD={xcode_env.clang_path(developer_dir)}",
      "archive",
    ],
    cwd=ROOT,
    check=True,
    env=os.environ.copy(),
  )

  app_path = archive_path / "Products/Applications" / f"{APP_NAME}.app"
  archive_info = archive_path / "Info.plist"
  app_info = app_path / "Info.plist"
  summary_path = archive_path / "archive-readiness.txt"

  require_file(archive_info)
  require_file(app_info)
  require_file(app_path / APP_NAME)
  require_file(app_path / "PrivacyInfo.xcprivacy")

  archive_bundle_id = plist_value(archive_info, "ApplicationProperties", "CFBundleIdentifier")
  app_bundle_id = plist_value(app_info, "CFBundleIdentifier")
  if archive_bundle_id != BUNDLE_ID or app_bundle_id != BUNDLE_ID:
    raise SystemExit(f"Unexpected bundle identifier: archive={archive_bundle_id} app={app_bundle_id} expected={BUNDLE_ID}")

  summary_path.write_text(
    "\n".join(
      [
        f"Archive path: {ARCHIVE_PATH}",
        f"Bundle identifier: {BUNDLE_ID}",
        f"Version: {plist_value(app_info, 'CFBundleShortVersionString')} ({plist_value(app_info, 'CFBundleVersion')})",
        "Signing status: unsigned",
        "Manual gate: configure Apple Developer signing before App Store/TestFlight export.",
        "",
      ]
    ),
    encoding="utf-8",
  )
  print(summary_path.read_text(encoding="utf-8"), end="")
  return 0


if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except subprocess.CalledProcessError as error:
    raise SystemExit(error.returncode) from error
