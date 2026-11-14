#!/usr/bin/env python3
from __future__ import annotations

import os
import subprocess
from pathlib import Path


def resolve_developer_dir() -> str:
  configured = os.environ.get("IOS_APP_DEVELOPER_DIR")
  if configured:
    return configured

  developer_dir = os.environ.get("DEVELOPER_DIR")
  if developer_dir and Path(developer_dir, "usr/bin/xcodebuild").is_file():
    return developer_dir

  default = "/Applications/Xcode.app/Contents/Developer"
  if Path(default, "usr/bin/xcodebuild").is_file():
    return default

  selected = subprocess.run(
    ["xcode-select", "-p"],
    check=False,
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.DEVNULL,
  ).stdout.strip()
  return selected or developer_dir or default


def apply_xcode_env() -> str:
  developer_dir = resolve_developer_dir()
  original_path = os.environ.get("PATH", "/usr/bin:/bin:/usr/sbin:/sbin")
  os.environ["DEVELOPER_DIR"] = developer_dir
  os.environ["TOOLCHAINS"] = os.environ.get("TOOLCHAINS", "com.apple.dt.toolchain.XcodeDefault")
  os.environ["PATH"] = ":".join(
    [
      f"{developer_dir}/usr/bin",
      f"{developer_dir}/Toolchains/XcodeDefault.xctoolchain/usr/bin",
      original_path,
      "/usr/bin",
      "/bin",
      "/usr/sbin",
      "/sbin",
    ]
  )
  return developer_dir


def xcodebuild_path(developer_dir: str) -> str:
  return f"{developer_dir}/usr/bin/xcodebuild"


def clang_path(developer_dir: str) -> str:
  return f"{developer_dir}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"
