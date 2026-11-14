#!/usr/bin/env python3
"""Validate the signed App Store IPA before uploading it to App Store Connect."""

from __future__ import annotations

import os
import plistlib
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
APP_NAME = "@ign-var:IOS_APP_TARGET=App@"
BUNDLE_ID = os.environ.get("IOS_APP_BUNDLE_ID", "@ign-var:BUNDLE_IDENTIFIER=com.example.app@")
EXPORT_PATH = Path(os.environ.get("IOS_APP_EXPORT_PATH", f".build/xcode-exports/{APP_NAME}"))


def fail(message: str, code: int = 2) -> None:
  print(message, file=sys.stderr)
  raise SystemExit(code)


def run(command: list[str]) -> subprocess.CompletedProcess[str]:
  return subprocess.run(command, check=False, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)


def main() -> int:
  ipa_files = sorted((ROOT / EXPORT_PATH).glob("*.ipa"))
  if len(ipa_files) != 1:
    fail(f"Expected one signed IPA in {EXPORT_PATH}, found {len(ipa_files)}", 3)

  with tempfile.TemporaryDirectory(prefix="ios-ipa-readiness.") as temporary_directory:
    temporary_path = Path(temporary_directory)
    modes: dict[str, int] = {}
    try:
      with zipfile.ZipFile(ipa_files[0]) as archive:
        for item in archive.infolist():
          modes[item.filename] = (item.external_attr >> 16) & 0o777
        archive.extractall(temporary_path)
    except zipfile.BadZipFile as error:
      fail(f"Invalid IPA: {error}", 4)

    apps = sorted((temporary_path / "Payload").glob("*.app"))
    if len(apps) != 1:
      fail(f"Expected one app bundle in IPA Payload, found {len(apps)}", 4)
    app_path = apps[0]
    info_path = app_path / "Info.plist"
    if not info_path.is_file():
      fail("IPA app Info.plist is missing", 4)
    with info_path.open("rb") as handle:
      info = plistlib.load(handle)
    if info.get("CFBundleIdentifier") != BUNDLE_ID:
      fail(f"Unexpected IPA bundle identifier: {info.get('CFBundleIdentifier')!r}", 4)
    executable = info.get("CFBundleExecutable")
    if not executable or not (app_path / executable).is_file():
      fail("IPA CFBundleExecutable is missing", 4)
    executable_path = app_path / executable
    executable_path.chmod(modes.get(f"Payload/{app_path.name}/{executable}", 0o755))
    description = run(["file", str(executable_path)]).stdout
    if not all(marker in description for marker in ("Mach-O 64-bit", "executable", "arm64")):
      fail(f"IPA executable is not an arm64 Mach-O executable: {description.strip()}", 4)
    codesign = shutil.which("codesign")
    if not codesign:
      fail("codesign not found", 127)
    signature = run([codesign, "--verify", "--deep", "--strict", "--verbose=4", str(app_path)])
    if signature.returncode:
      fail(f"IPA code signature verification failed:\n{signature.stdout}", 4)

  print("iOS IPA readiness: passed")
  print(f"IPA: {ipa_files[0].relative_to(ROOT)}")
  print(f"Bundle identifier: {BUNDLE_ID}")
  print("Executable: arm64 Mach-O and validly signed")
  return 0


if __name__ == "__main__":
  raise SystemExit(main())
