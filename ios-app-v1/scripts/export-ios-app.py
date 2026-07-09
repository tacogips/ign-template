#!/usr/bin/env python3
from __future__ import annotations

import os
import shutil
import subprocess
from pathlib import Path

from lib import xcode_env

ROOT = Path(__file__).resolve().parent.parent
APP_NAME = "@ign-var:IOS_APP_TARGET=App@"
ARCHIVE_PATH = Path(os.environ.get("IOS_APP_ARCHIVE_PATH", f".build/xcode-archives/{APP_NAME}.xcarchive"))
EXPORT_OPTIONS = Path(os.environ.get("IOS_APP_EXPORT_OPTIONS_PLIST", f"{APP_NAME}-ExportOptions.plist"))
EXPORT_PATH = Path(os.environ.get("IOS_APP_EXPORT_PATH", f".build/xcode-exports/{APP_NAME}"))
LOG_PATH = Path(os.environ.get("IOS_APP_EXPORT_LOG", ".build/xcode-exports/export.log"))


def main() -> int:
  developer_dir = xcode_env.apply_xcode_env()
  xcodebuild = xcode_env.xcodebuild_path(developer_dir)
  if not Path(xcodebuild).is_file():
    raise SystemExit(f"xcodebuild not found at {xcodebuild}")
  if not (ROOT / ARCHIVE_PATH).is_dir():
    raise SystemExit(f"Archive not found at {ARCHIVE_PATH}. Run task archive:ios-app-signed first.")
  if not (ROOT / EXPORT_OPTIONS).is_file():
    raise SystemExit(f"Export options plist not found at {EXPORT_OPTIONS}.")

  export_path = ROOT / EXPORT_PATH
  log_path = ROOT / LOG_PATH
  if export_path.exists():
    if not str(EXPORT_PATH).startswith(".build/"):
      raise SystemExit(f"Export path already exists outside .build: {EXPORT_PATH}")
    shutil.rmtree(export_path)
  export_path.mkdir(parents=True, exist_ok=True)
  log_path.parent.mkdir(parents=True, exist_ok=True)

  with log_path.open("w", encoding="utf-8") as log:
    subprocess.run(
      [
        xcodebuild,
        "-quiet",
        "-exportArchive",
        "-archivePath",
        str(ARCHIVE_PATH),
        "-exportPath",
        str(EXPORT_PATH),
        "-exportOptionsPlist",
        str(EXPORT_OPTIONS),
        "-allowProvisioningUpdates",
      ],
      cwd=ROOT,
      check=True,
      env=os.environ.copy(),
      stdout=log,
      stderr=subprocess.STDOUT,
    )

  ipa_files = sorted(export_path.glob("*.ipa"))
  if not ipa_files:
    raise SystemExit(f"Signed export completed, but no IPA was found in {EXPORT_PATH}. Full log: {LOG_PATH}")

  print(f"Export path: {EXPORT_PATH}")
  print(f"Archive path: {ARCHIVE_PATH}")
  print(f"IPA files: {len(ipa_files)}")
  print(f"Export log: {LOG_PATH}")
  return 0


if __name__ == "__main__":
  try:
    raise SystemExit(main())
  except subprocess.CalledProcessError as error:
    print(f"Signed export failed. Full xcodebuild export log: {LOG_PATH}")
    raise SystemExit(error.returncode) from error
