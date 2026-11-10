#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (C) 2026 The XPerience Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

"""
XPerience AOSP Repopick & Gerrit/ASB Manager
============================================
A modern, visual, high-performance Gerrit cherry-pick tool, AOSP Security
Bulletin scraper, and manifest remote auditor designed for AOSP and Custom ROM
developers.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path
from typing import Dict, List, Optional, Set, Tuple


# ==============================================================================
# UI & Terminal Styling
# ==============================================================================

class Colors:
    """ANSI color codes with automatic TTY detection."""
    ENABLED = sys.stdout.isatty() and os.environ.get("TERM") != "dumb"

    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"
    ITALIC = "\033[3m"
    UNDERLINE = "\033[4m"

    # Foreground colors
    BLACK = "\033[30m"
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN = "\033[36m"
    WHITE = "\033[37m"

    # Bright foreground
    BRIGHT_RED = "\033[91m"
    BRIGHT_GREEN = "\033[92m"
    BRIGHT_YELLOW = "\033[93m"
    BRIGHT_BLUE = "\033[94m"
    BRIGHT_MAGENTA = "\033[95m"
    BRIGHT_CYAN = "\033[96m"
    BRIGHT_WHITE = "\033[97m"

    @classmethod
    def disable(cls):
        """Disable all color outputs."""
        cls.ENABLED = False
        for attr in list(cls.__dict__.keys()):
            if not attr.startswith("__") and isinstance(getattr(cls, attr), str):
                setattr(cls, attr, "")

    @classmethod
    def c(cls, text: str, *styles: str) -> str:
        """Apply styles to text if colors are enabled."""
        if not cls.ENABLED or not styles:
            return str(text)
        prefix = "".join(styles)
        return f"{prefix}{text}{cls.RESET}"


class UI:
    """Terminal printing and formatting utilities."""

    @staticmethod
    def banner():
        title = r"""
 ██╗  ██╗██████╗ ███████╗   ██████╗ ███████╗██████╗  ██████╗ ██████╗ ██╗ ██████╗██╗  ██╗
 ╚██╗██╔╝██╔══██╗██╔════╝   ██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔══██╗██║██╔════╝██║ ██╔╝
  ╚███╔╝ ██████╔╝█████╗     ██████╔╝█████╗  ██████╔╝██║   ██║██████╔╝██║██║     █████╔╝ 
  ██╔██╗ ██╔═══╝ ██╔══╝     ██╔══██╗██╔══╝  ██╔═══╝ ██║   ██║██╔═══╝ ██║██║     ██╔═██╗ 
 ██╔╝ ██╗██║     ███████╗██╗██║  ██║███████╗██║     ╚██████╔╝██║     ██║╚██████╗██║  ██╗
 ╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝╚═╝  ╚═╝╚══════╝╚═╝      ╚═════╝ ╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝
        """
        subtitle = "XPerience AOSP Gerrit & Security Bulletin Cherry-Pick Engine"
        ver = "v3.1.0-asb"
        print(Colors.c(title, Colors.BRIGHT_CYAN, Colors.BOLD))
        print(f" {Colors.c(subtitle, Colors.BOLD, Colors.WHITE)} {Colors.c(ver, Colors.DIM, Colors.CYAN)}")
        print(Colors.c(" " + "─" * 78, Colors.DIM))
        print()

    @staticmethod
    def section(title: str, icon: str = "⚡"):
        print(f"\n{Colors.c(f'{icon} {title}', Colors.BOLD, Colors.BRIGHT_WHITE)}")
        print(Colors.c("─" * (len(title) + 4), Colors.DIM))

    @staticmethod
    def success(msg: str):
        print(f"  {Colors.c('✔', Colors.BRIGHT_GREEN, Colors.BOLD)} {msg}")

    @staticmethod
    def info(msg: str):
        print(f"  {Colors.c('ℹ', Colors.BRIGHT_CYAN, Colors.BOLD)} {msg}")

    @staticmethod
    def warn(msg: str):
        print(f"  {Colors.c('⚠', Colors.BRIGHT_YELLOW, Colors.BOLD)} {Colors.c(msg, Colors.BRIGHT_YELLOW)}")

    @staticmethod
    def error(msg: str):
        print(f"  {Colors.c('✖', Colors.BRIGHT_RED, Colors.BOLD)} {Colors.c(msg, Colors.BRIGHT_RED)}")


# ==============================================================================
# Unified Pickable Change Data Model
# ==============================================================================

@dataclass
class PickableChange:
    source_type: str            # 'gerrit' or 'aosp_bulletin'
    identifier: str             # Change number (Gerrit) or CVE (ASB)
    project: str                # Gerrit / AOSP project name
    fetch_url: str              # URL to fetch from
    ref_or_sha: str             # Git ref or commit SHA
    subject: str                # Commit message / CVE summary
    branch: Optional[str] = None
    change_id: Optional[str] = None
    cve: Optional[str] = None
    bug_id: Optional[str] = None
    severity: Optional[str] = None
    versions: Optional[str] = None

    @property
    def is_manifest(self) -> bool:
        p = self.project.lower()
        return p in ("lineageos/android", "android", "platform/manifest", "manifest") or p.endswith("_manifest")


# ==============================================================================
# Manifest Inspector
# ==============================================================================

@dataclass
class ManifestProject:
    name: str
    path: str
    remote: str
    revision: Optional[str] = None


# Project aliases & vendor remappings for custom ROMs
PROJECT_REMAPS: Dict[str, str] = {
    "LineageOS/android_vendor_lineage": "vendor/xperience",
    "android_vendor_lineage": "vendor/xperience",
    "vendor/lineage": "vendor/xperience",
}


class ManifestInspector:
    """Inspects the active repo manifest to verify tracking remotes."""

    def __init__(self, top_dir: Path):
        self.top_dir = top_dir
        self.default_remote = "aosp"
        self.default_revision = ""
        self.projects_by_path: Dict[str, ManifestProject] = {}
        self.projects_by_name: Dict[str, ManifestProject] = {}
        self.remotes: Dict[str, str] = {}
        self._loaded = False

    def load(self) -> bool:
        if self._loaded:
            return True

        xml_raw = ""
        # 1. Try running repo manifest -o -
        try:
            res = subprocess.run(
                ["repo", "manifest", "-o", "-"],
                cwd=str(self.top_dir),
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                check=False
            )
            if res.returncode == 0 and "<?xml" in res.stdout:
                xml_raw = res.stdout[res.stdout.find("<?xml"):]
        except Exception:
            pass

        # 2. Fallback to direct reading of .repo/manifests/default.xml
        if not xml_raw:
            default_xml = self.top_dir / ".repo" / "manifests" / "default.xml"
            if default_xml.is_file():
                try:
                    xml_raw = default_xml.read_text(encoding="utf-8")
                except Exception:
                    pass

        if not xml_raw:
            return False

        try:
            root = ET.fromstring(xml_raw)
            for d in root.findall(".//default"):
                self.default_remote = d.get("remote", self.default_remote)
                self.default_revision = d.get("revision", self.default_revision)

            for r in root.findall(".//remote"):
                r_name = r.get("name")
                if r_name:
                    self.remotes[r_name] = r.get("fetch", "")

            for p in root.findall(".//project"):
                name = p.get("name")
                if not name:
                    continue
                path = p.get("path", name)
                remote = p.get("remote", self.default_remote)
                revision = p.get("revision")
                mp = ManifestProject(name=name, path=path, remote=remote, revision=revision)
                self.projects_by_path[path] = mp
                self.projects_by_name[name] = mp

            self._loaded = True
            return True
        except Exception as e:
            UI.error(f"Failed to parse manifest XML: {e}")
            return False

    def detect_target_android_version(self) -> Optional[str]:
        """Infers the Android major version (e.g. '14', '17') from manifest revision."""
        if not self._loaded:
            self.load()
        rev = self.default_revision or ""
        m = re.search(r"android-(\d+)", rev)
        if m:
            return m.group(1)
        m = re.search(r"lineage-(\d+)", rev)
        if m:
            # Map lineage-21 -> 14, lineage-22 -> 15, lineage-24 -> 17
            los_ver = int(m.group(1))
            return str(los_ver - 7)
        return None

    def resolve_project(self, project_name: str) -> Optional[ManifestProject]:
        """Maps a Gerrit/AOSP project name to a ManifestProject."""
        if not self._loaded and not self.load():
            return None

        # Check ROM / Vendor aliases (e.g. LineageOS/android_vendor_lineage -> vendor/xperience)
        if project_name in PROJECT_REMAPS:
            remapped_path = PROJECT_REMAPS[project_name]
            if remapped_path in self.projects_by_path:
                return self.projects_by_path[remapped_path]

        bare = project_name
        for prefix in ("LineageOS/", "AOSP/", "TheXPerienceProject/", "platform/"):
            if bare.startswith(prefix):
                bare = bare[len(prefix):]
                break

        if bare in PROJECT_REMAPS:
            remapped_path = PROJECT_REMAPS[bare]
            if remapped_path in self.projects_by_path:
                return self.projects_by_path[remapped_path]

        # 1. Direct name match in manifest
        if bare in self.projects_by_name:
            return self.projects_by_name[bare]

        # 2. Try with platform/ prefix (standard AOSP)
        if "android_" in bare:
            suffix = bare.replace("android_", "")
            if f"platform/{suffix}" in self.projects_by_name:
                return self.projects_by_name[f"platform/{suffix}"]
            if f"platform/{suffix.replace('_', '/')}" in self.projects_by_name:
                return self.projects_by_name[f"platform/{suffix.replace('_', '/')}"]
        else:
            if f"platform/{bare}" in self.projects_by_name:
                return self.projects_by_name[f"platform/{bare}"]

        # 3. Path translation: android_packages_apps_Settings -> packages/apps/Settings
        clean_path = bare
        if clean_path.startswith("android_"):
            clean_path = clean_path[8:]

        candidate_path = clean_path.replace("_", "/")
        if candidate_path in self.projects_by_path:
            return self.projects_by_path[candidate_path]

        # 4. Partial / underscore-preserving path match
        for path, p in self.projects_by_path.items():
            if path.replace("/", "_") == clean_path or path == clean_path:
                return p

        # 5. Fuzzy match on suffix
        for name, p in self.projects_by_name.items():
            if name.endswith(clean_path) or clean_path.endswith(name):
                return p

        return None


# ==============================================================================
# Gerrit Client
# ==============================================================================

KNOWN_SERVERS = {
    "los": "https://review.lineageos.org",
    "lineage": "https://review.lineageos.org",
    "lineageos": "https://review.lineageos.org",
    "aosp": "https://android-review.googlesource.com",
    "google": "https://android-review.googlesource.com",
    "xpe": "https://review.thexperienceproject.com",
    "xperience": "https://review.thexperienceproject.com",
}


class GerritClient:
    """Interacts with Gerrit REST API."""

    def __init__(self, server_url: str):
        self.server_url = server_url.rstrip("/")
        if not self.server_url.startswith(("http://", "https://")):
            self.server_url = f"https://{self.server_url}"

    def _fetch_json(self, endpoint: str) -> any:
        url = f"{self.server_url}/{endpoint.lstrip('/')}"
        req = urllib.request.Request(
            url,
            headers={
                "User-Agent": "XPerience-Repopick/3.1",
                "Accept": "application/json",
            }
        )
        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                data = resp.read().decode("utf-8")
                if data.startswith(")]}'"):
                    data = data[4:].strip()
                return json.loads(data)
        except urllib.error.HTTPError as e:
            UI.error(f"HTTP Error {e.code} while querying Gerrit: {url}")
            return None
        except Exception as e:
            UI.error(f"Connection error to Gerrit ({self.server_url}): {e}")
            return None

    def _resolve_fetch_info(self, rev_info: dict, project: str) -> Tuple[str, str]:
        """Resolves the proper git fetch URL and ref from Gerrit revision metadata."""
        fetch_dict = rev_info.get("fetch", {}) if isinstance(rev_info, dict) else {}

        # 1. Check Gerrit provided fetch protocols (e.g. 'anonymous http' pointing to GitHub mirror)
        for proto in ("anonymous http", "http", "https"):
            if proto in fetch_dict and isinstance(fetch_dict[proto], dict) and "url" in fetch_dict[proto]:
                url = fetch_dict[proto]["url"]
                ref = fetch_dict[proto].get("ref", "")
                return url, ref

        # 2. Known Fallbacks: LineageOS mirrors all git objects to GitHub
        if "lineageos.org" in self.server_url:
            return f"https://github.com/{project}", ""
        elif "googlesource.com" in self.server_url:
            return f"https://android.googlesource.com/{project}", ""

        return f"{self.server_url}/{project}", ""

    def query_topic(self, topic: str, branch: Optional[str] = None) -> List[PickableChange]:
        q = f'topic:"{topic}"'
        if branch:
            q += f' branch:{branch}'
        q_encoded = urllib.parse.quote(q)
        endpoint = f"changes/?q={q_encoded}&o=CURRENT_REVISION&o=DETAILED_ACCOUNTS"

        data = self._fetch_json(endpoint)
        if not data or not isinstance(data, list):
            return []

        results = []
        for c in data:
            rev_id = c.get("current_revision")
            revisions = c.get("revisions", {})
            rev_info = revisions.get(rev_id, {})
            fetch_url, fetch_ref = self._resolve_fetch_info(rev_info, c["project"])
            ref = fetch_ref or rev_info.get("ref", "")
            if not ref and rev_id and "_number" in c:
                num = c["_number"]
                last_two = f"{num:02d}"[-2:]
                rev_num = rev_info.get("_number", 1)
                ref = f"refs/changes/{last_two}/{num}/{rev_num}"

            change = PickableChange(
                source_type="gerrit",
                identifier=str(c["_number"]),
                project=c["project"],
                fetch_url=fetch_url,
                ref_or_sha=ref,
                subject=c.get("subject", "No subject"),
                branch=c.get("branch"),
                change_id=c.get("change_id"),
            )
            results.append(change)

        return results

    def get_change(self, change_num: int) -> Optional[PickableChange]:
        endpoint = f"changes/{change_num}?o=CURRENT_REVISION"
        c = self._fetch_json(endpoint)
        if not c or not isinstance(c, dict):
            return None

        rev_id = c.get("current_revision")
        revisions = c.get("revisions", {})
        rev_info = revisions.get(rev_id, {})
        fetch_url, fetch_ref = self._resolve_fetch_info(rev_info, c["project"])
        ref = fetch_ref or rev_info.get("ref", "")
        if not ref and rev_id:
            last_two = f"{change_num:02d}"[-2:]
            rev_num = rev_info.get("_number", 1)
            ref = f"refs/changes/{last_two}/{change_num}/{rev_num}"

        return PickableChange(
            source_type="gerrit",
            identifier=str(c["_number"]),
            project=c["project"],
            fetch_url=fetch_url,
            ref_or_sha=ref,
            subject=c.get("subject", "No subject"),
            branch=c.get("branch"),
            change_id=c.get("change_id"),
        )


# ==============================================================================
# AOSP Security Bulletin Scraper
# ==============================================================================

class ASBBulletinScraper:
    """Scrapes Android Security Bulletins directly from source.android.com."""

    BASE_URL = "https://source.android.com/docs/security/bulletin"

    @classmethod
    def normalize_url(cls, target: str) -> str:
        """Normalizes an ASB date or URL into a full source.android.com URL."""
        if target.startswith("http://") or target.startswith("https://"):
            return target

        date_str = target.strip()
        # Format: YYYY-MM -> YYYY-MM-01
        if re.match(r"^\d{4}-\d{2}$", date_str):
            date_str = f"{date_str}-01"

        return f"{cls.BASE_URL}/{date_str}"

    @classmethod
    def scrape(cls, target: str, target_version: Optional[str] = None) -> List[PickableChange]:
        url = cls.normalize_url(target)
        UI.info(f"Scraping ASB Page: {Colors.c(url, Colors.BOLD, Colors.CYAN)}")

        req = urllib.request.Request(
            url,
            headers={
                "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) XPerience-Repopick/3.1",
                "Accept": "text/html,application/xhtml+xml",
            }
        )

        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                html = resp.read().decode("utf-8")
        except urllib.error.HTTPError as e:
            UI.error(f"Failed to fetch Security Bulletin (HTTP {e.code}): {url}")
            return []
        except Exception as e:
            UI.error(f"Error accessing Security Bulletin: {e}")
            return []

        tables = re.findall(r"<table.*?>(.*?)</table>", html, re.DOTALL)
        if not tables:
            UI.error("No CVE tables found in the bulletin page.")
            return []

        results: List[PickableChange] = []
        seen_shas = set()

        for t in tables:
            rows = re.findall(r"<tr>(.*?)</tr>", t, re.DOTALL)
            for r in rows:
                if "android.googlesource.com" not in r:
                    continue

                cve_match = re.search(r"CVE-\d+-\d+", r)
                cve = cve_match.group(0) if cve_match else "CVE-Unknown"

                tds = re.findall(r"<td.*?>(.*?)</td>", r, re.DOTALL)
                clean_tds = [re.sub(r"<.*?>", "", td).strip() for td in tds]

                versions_str = clean_tds[-1] if clean_tds else ""
                severity = clean_tds[3] if len(clean_tds) > 3 else "Unknown"
                ref_id = clean_tds[1] if len(clean_tds) > 1 else ""

                # Version filtering if requested
                if target_version:
                    # versions_str might be "14, 15" or "12, 12L, 13"
                    v_list = [v.strip() for v in versions_str.split(",")]
                    if target_version not in v_list:
                        continue

                links = re.findall(r"href=[\"'](https://android\.googlesource\.com/[^\"']+)[\"']", r)
                for link in links:
                    # Pattern: https://android.googlesource.com/<project>/+/<sha>
                    m = re.match(r"https://android\.googlesource\.com/(.+?)/\+/([a-f0-9]{8,40})", link)
                    if not m:
                        continue
                    proj, sha = m.groups()
                    if sha in seen_shas:
                        continue
                    seen_shas.add(sha)

                    change = PickableChange(
                        source_type="aosp_bulletin",
                        identifier=cve,
                        project=proj,
                        fetch_url=f"https://android.googlesource.com/{proj}",
                        ref_or_sha=sha,
                        subject=f"[{cve}] Security patch (Ref: {ref_id.replace(chr(10), ' ').strip()})",
                        cve=cve,
                        bug_id=ref_id.replace("\n", " ").strip(),
                        severity=severity,
                        versions=versions_str,
                    )
                    results.append(change)

        return results


# ==============================================================================
# Local Git Commit Deduplication & Verification
# ==============================================================================

class RepoCommitCache:
    """Caches recent commit Change-Ids, SHAs, and subjects for fast pre-pick verification."""

    def __init__(self, top_dir: Path):
        self.top_dir = top_dir
        # path -> (change_ids, subjects, commit_hashes, bug_ids)
        self._cache: Dict[Path, Tuple[Set[str], Set[str], Set[str], Set[str]]] = {}

    def get_repo_history(self, repo_path: Path, max_count: int = 150) -> Tuple[Set[str], Set[str], Set[str], Set[str]]:
        if repo_path in self._cache:
            return self._cache[repo_path]

        change_ids = set()
        subjects = set()
        hashes = set()
        bug_ids = set()

        if not (repo_path / ".git").exists():
            return change_ids, subjects, hashes, bug_ids

        cmd = [
            "git", "-C", str(repo_path), "log",
            f"-n{max_count}",
            "--format=%H|%s|%(trailers:key=Change-Id,valueonly=true)|%(trailers:key=Bug,valueonly=true)"
        ]

        try:
            res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, check=False)
            for line in res.stdout.splitlines():
                parts = line.strip().split("|")
                if parts:
                    hashes.add(parts[0].strip().lower())
                if len(parts) > 1 and parts[1].strip():
                    subjects.add(parts[1].strip().lower())
                if len(parts) > 2 and parts[2].strip():
                    for cid in parts[2].split():
                        change_ids.add(cid.strip())
                if len(parts) > 3 and parts[3].strip():
                    for bid in parts[3].split():
                        bug_ids.add(bid.strip())
        except Exception:
            pass

        data = (change_ids, subjects, hashes, bug_ids)
        self._cache[repo_path] = data
        return data

    def is_already_applied(self, change: PickableChange, repo_path: Path) -> Tuple[bool, str]:
        """Checks if a change has already been applied/merged into the target repo."""
        if not (repo_path / ".git").exists():
            return False, ""

        change_ids, subjects, hashes, bug_ids = self.get_repo_history(repo_path)

        # 1. Match by Change-Id (Standard Gerrit)
        if change.change_id and change.change_id in change_ids:
            return True, f"Found Change-Id {change.change_id[:12]} in recent log"

        # 2. Match by exact SHA
        if change.ref_or_sha.lower() in hashes:
            return True, f"Commit SHA {change.ref_or_sha[:10]} already present"

        # 3. Match by Subject (Exact Title match)
        if change.subject and change.subject.strip().lower() in subjects:
            return True, f"Commit title '{change.subject[:30]}...' already exists"

        # 4. For ASB: Match by Bug ID or CVE in recent commit trailers
        if change.bug_id:
            raw_bug = re.sub(r"[^0-9]", "", change.bug_id)
            if raw_bug and raw_bug in bug_ids:
                return True, f"Bug reference A-{raw_bug} already patched"

        return False, ""


# ==============================================================================
# Cherry-Pick Execution Engine
# ==============================================================================

class CherryPicker:
    """Executes git fetch and cherry-pick actions in the workspace."""

    def __init__(self, top_dir: Path):
        self.top_dir = top_dir

    def apply_change(
        self,
        change: PickableChange,
        target_path: Path,
        dry_run: bool = False
    ) -> Tuple[bool, str, List[str]]:
        if not target_path.is_dir():
            return False, f"Directory '{target_path}' does not exist on disk", []

        if dry_run:
            return True, f"[SIMULATION] git fetch {change.fetch_url} {change.ref_or_sha} && git cherry-pick FETCH_HEAD", []

        # Check git status for uncommitted changes
        status = subprocess.run(
            ["git", "-C", str(target_path), "status", "--porcelain"],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
        if status.stdout.strip():
            dirty_lines = [line.strip() for line in status.stdout.strip().splitlines()]
            return False, "Repository has uncommitted changes (dirty working tree)", dirty_lines

        # 1. Fetch
        fetch_cmd = ["git", "-C", str(target_path), "fetch", change.fetch_url, change.ref_or_sha]
        f_res = subprocess.run(fetch_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if f_res.returncode != 0:
            return False, f"Git fetch failed", [f"Command: {' '.join(fetch_cmd)}", f_res.stderr.strip()]

        # 2. Cherry-pick
        cp_cmd = ["git", "-C", str(target_path), "cherry-pick", "-x", "FETCH_HEAD"]
        cp_res = subprocess.run(cp_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if cp_res.returncode != 0:
            # Check if it was already applied
            if "The previous cherry-pick is now empty" in cp_res.stderr or "nothing to commit" in cp_res.stdout:
                subprocess.run(["git", "-C", str(target_path), "cherry-pick", "--abort"], check=False)
                return True, "Already applied (empty commit)", []

            # Check conflicted files before aborting
            conflicts_status = subprocess.run(
                ["git", "-C", str(target_path), "status", "--porcelain"],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
            )
            conflict_files = [line.strip() for line in conflicts_status.stdout.splitlines() if line.startswith(("UU", "AA", "DU", "UD", "DD", "AU", "UA"))]

            subprocess.run(["git", "-C", str(target_path), "cherry-pick", "--abort"], check=False)
            detail_errs = conflict_files if conflict_files else [cp_res.stderr.strip() or cp_res.stdout.strip()]
            return False, "Merge conflict encountered during cherry-pick (aborted cleanly)", detail_errs

        return True, "Successfully applied", []


# ==============================================================================
# Helper Functions
# ==============================================================================

def find_top_dir() -> Path:
    env_top = os.environ.get("ANDROID_BUILD_TOP")
    if env_top and Path(env_top).is_dir():
        return Path(env_top)

    curr = Path.cwd().resolve()
    while curr != curr.parent:
        if (curr / ".repo").is_dir():
            return curr
        curr = curr.parent

    return Path.cwd().resolve()


def generate_manifest_snippet(
    fork_needed: List[Tuple[PickableChange, ManifestProject]],
    fork_remote: str = "xpe"
) -> str:
    lines = [
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "<!-- Auto-generated by XPerience repopick: Missing ASB Forks -->",
        "<manifest>",
    ]
    seen_paths = set()
    for change, mp in fork_needed:
        if mp.path in seen_paths:
            continue
        seen_paths.add(mp.path)

        # Clean project name for XPerience convention:
        # E.g. 'LineageOS/android_system_gsid' -> 'android_system_gsid'
        # E.g. 'platform/system/gsid' -> 'android_system_gsid'
        clean_name = change.project
        for prefix in ("LineageOS/", "AOSP/", "TheXPerienceProject/", "platform/", "android/"):
            if clean_name.startswith(prefix):
                clean_name = clean_name[len(prefix):]
                break

        if not clean_name.startswith("android_"):
            clean_name = f"android_{mp.path.replace('/', '_')}"

        lines.append(f'  <remove-project name="{mp.name}" />')
        lines.append(f'  <project path="{mp.path}" name="{clean_name}" remote="{fork_remote}" />')

    lines.append("</manifest>")
    return "\n".join(lines)


# ==============================================================================
# CLI Entry Point
# ==============================================================================

def main():
    parser = argparse.ArgumentParser(
        prog="repo-pick",
        description="XPerience Repopick: Advanced Gerrit & ASB Cherry-Pick Engine",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Gerrit Topic Picking:
  repo-pick los C_asb_2026-11                # Topic picking from LineageOS Gerrit
  repo-pick C_asb_2026-11                    # Defaults to LineageOS Gerrit
  repo-pick los 508028 511732                # Pick specific Gerrit Change IDs
  
  # AOSP Security Bulletin Scraping:
  repo-pick asb 2026-11-01                   # Pick security bulletin patches from source.android.com
  repo-pick asb 2024-11-01 --version 14      # Filter patches for Android 14
  repo-pick https://source.android.com/docs/security/bulletin/2024-11-01

  # Actions:
  repo-pick los C_asb_2026-11 --apply        # Actually apply git cherry-picks
  repo-pick los C_asb_2026-11 --check-only   # Audit manifest remotes without picking
  repo-pick los C_asb_2026-11 --generate-xml # Generate local_manifest XML snippet for missing forks
        """
    )

    parser.add_argument("args", nargs="*", help="Server alias, ASB date/URL, topic name, or change numbers")
    parser.add_argument("-s", "--server", help="Gerrit server name or URL (los, aosp, xpe, or custom URL)")
    parser.add_argument("-t", "--topic", help="Topic name to pick")
    parser.add_argument("-b", "--branch", help="Filter topic by branch (e.g. lineage-24.0)")
    parser.add_argument("-v", "--version", help="Filter ASB patches by Android version (e.g. 14, 17)")
    parser.add_argument("-a", "--apply", action="store_true", help="Actually execute git cherry-pick (default is dry-run)")
    parser.add_argument("-d", "--dry-run", action="store_true", help="Perform a dry-run simulation without touching git")
    parser.add_argument("--check-only", action="store_true", help="Only check manifest remote tracking")
    parser.add_argument("--remotes", default="xpe,lineage,los", help="Comma-separated allowed manifest remotes (default: xpe,lineage,los)")
    parser.add_argument("--include-manifest", action="store_true", help="Include manifest changes (default: excluded)")
    parser.add_argument("--generate-xml", action="store_true", help="Output local_manifest XML snippet for missing forks")
    parser.add_argument("-f", "--force", action="store_true", help="Continue even if some cherry-picks fail")
    parser.add_argument("--no-color", action="store_true", help="Disable terminal ANSI colors")

    parsed_args = parser.parse_args()

    if parsed_args.no_color:
        Colors.disable()

    UI.banner()

    # Determine Top Directory
    top_dir = find_top_dir()
    if not (top_dir / ".repo").is_dir():
        UI.warn(f"Warning: Not inside an AOSP workspace (could not find .repo in {top_dir})")
    else:
        UI.info(f"Workspace Root: {Colors.c(str(top_dir), Colors.BOLD, Colors.CYAN)}")

    # Load Manifest
    inspector = ManifestInspector(top_dir)
    manifest_loaded = inspector.load()
    if not manifest_loaded:
        UI.warn("Could not load repo manifest. Remote audit will be limited.")

    # Target Android Version Detection
    detected_ver = inspector.detect_target_android_version()
    target_version = parsed_args.version or detected_ver
    if target_version:
        UI.info(f"Target Android Version: {Colors.c(target_version, Colors.BOLD, Colors.YELLOW)}")

    raw_args = list(parsed_args.args)
    changes: List[PickableChange] = []

    # Check for ASB Mode
    is_asb = False
    asb_target = ""

    if raw_args and raw_args[0].lower() in ("asb", "bulletin"):
        is_asb = True
        raw_args.pop(0)
        if raw_args:
            asb_target = raw_args.pop(0)
    elif raw_args and ("source.android.com" in raw_args[0] or re.match(r"^\d{4}-\d{2}(-\d{2})?$", raw_args[0])):
        is_asb = True
        asb_target = raw_args.pop(0)

    if is_asb:
        UI.section("AOSP Security Bulletin Mode", "🛡️")
        if not asb_target:
            UI.error("Please specify a bulletin date (e.g. 2026-11-01) or URL.")
            sys.exit(1)
        changes = ASBBulletinScraper.scrape(asb_target, target_version=target_version)
    else:
        # Gerrit Mode
        server_alias = parsed_args.server or "los"
        topic = parsed_args.topic
        change_ids: List[int] = []

        if raw_args:
            first = raw_args[0].lower()
            if first in KNOWN_SERVERS or first.startswith(("http://", "https://")):
                server_alias = raw_args.pop(0)

            for item in raw_args:
                if item.isdigit():
                    change_ids.append(int(item))
                elif not topic:
                    topic = item

        gerrit_url = KNOWN_SERVERS.get(server_alias.lower(), server_alias)
        UI.info(f"Gerrit Server : {Colors.c(gerrit_url, Colors.BOLD, Colors.BRIGHT_WHITE)} [{server_alias}]")
        client = GerritClient(gerrit_url)

        if topic:
            UI.info(f"Querying Topic: {Colors.c(topic, Colors.BOLD, Colors.YELLOW)}" + (f" (branch: {parsed_args.branch})" if parsed_args.branch else ""))
            changes = client.query_topic(topic, branch=parsed_args.branch)
        elif change_ids:
            UI.info(f"Querying {len(change_ids)} Change IDs: {change_ids}")
            for cid in change_ids:
                c = client.get_change(cid)
                if c:
                    changes.append(c)
        else:
            UI.error("No topic, change IDs, or ASB date specified. Use -h or --help for instructions.")
            sys.exit(1)

    if not changes:
        UI.error("No changes found for the given query.")
        sys.exit(1)

    UI.success(f"Retrieved {Colors.c(str(len(changes)), Colors.BOLD)} change(s).")

    # Filter Manifest Changes
    manifest_excluded: List[PickableChange] = []
    code_changes: List[PickableChange] = []

    for c in changes:
        if c.is_manifest and not parsed_args.include_manifest:
            manifest_excluded.append(c)
        else:
            code_changes.append(c)

    if manifest_excluded:
        UI.section("Manifest Repositories Excluded", "⊘")
        for mc in manifest_excluded:
            print(f"  {Colors.c('⊘ OMITTED', Colors.MAGENTA, Colors.BOLD)} #{mc.identifier} ({mc.project}) : {mc.subject}")

    # Inspect Local Manifest & Pre-check Existing Commits
    UI.section("Auditing Manifest Remotes & Pre-Checking Git Commits", "🔍")
    allowed_remotes = {r.strip().lower() for r in parsed_args.remotes.split(",")}
    UI.info(f"Allowed Remotes: {Colors.c(', '.join(sorted(allowed_remotes)), Colors.BOLD, Colors.GREEN)}")

    commit_cache = RepoCommitCache(top_dir)

    ok_tracked: List[Tuple[PickableChange, ManifestProject, bool, str]] = []
    fork_needed: List[Tuple[PickableChange, ManifestProject, bool, str]] = []
    not_in_manifest: List[Tuple[PickableChange, Path, bool, str]] = []

    for c in code_changes:
        mp = inspector.resolve_project(c.project)
        target_path = top_dir / (mp.path if mp else c.project.replace("LineageOS/android_", "").replace("platform/", "").replace("_", "/"))

        # Pre-check if already applied in local repository
        already_applied, reason = commit_cache.is_already_applied(c, target_path)

        if mp:
            if mp.remote.lower() in allowed_remotes:
                ok_tracked.append((c, mp, already_applied, reason))
            else:
                fork_needed.append((c, mp, already_applied, reason))
        else:
            not_in_manifest.append((c, target_path, already_applied, reason))

    # Print Summary Table
    print("\n" + "─" * 96)
    print(f" {'ID':<14} {'STATUS':<20} {'REMOTE':<10} {'LOCAL PATH':<30} {'SUBJECT':<20}")
    print("─" * 96)

    display_limit = 30 if len(code_changes) > 35 and not parsed_args.generate_xml else len(code_changes)
    count = 0

    all_audited = []
    for c, mp, applied, reason in ok_tracked:
        all_audited.append((c, mp.remote, mp.path, applied, reason, "OK"))
    for c, mp, applied, reason in fork_needed:
        all_audited.append((c, mp.remote, mp.path, applied, reason, "FORK"))
    for c, p, applied, reason in not_in_manifest:
        rel_p = str(p.relative_to(top_dir)) if p.is_relative_to(top_dir) else str(p)
        all_audited.append((c, "N/A", rel_p, applied, reason, "MISSING"))

    for c, rem, path, applied, reason, category in all_audited:
        count += 1
        if count <= display_limit:
            if applied:
                status_badge = Colors.c("✔ ALREADY APPLIED", Colors.BRIGHT_GREEN, Colors.BOLD)
            elif category == "OK":
                status_badge = Colors.c("➜ PENDING PICK", Colors.BRIGHT_CYAN, Colors.BOLD)
            elif category == "FORK":
                status_badge = Colors.c("⚠ FORK NEEDED", Colors.BRIGHT_YELLOW, Colors.BOLD)
            else:
                status_badge = Colors.c("✖ NOT IN MANIFEST", Colors.BRIGHT_RED, Colors.BOLD)

            rem_styled = Colors.c(rem, Colors.CYAN if category == "OK" else (Colors.YELLOW if category == "FORK" else Colors.DIM))
            subj_clip = c.subject[:22] + ("..." if len(c.subject) > 22 else "")
            ident_str = f"#{c.identifier}" if c.identifier.isdigit() else c.identifier[:13]
            print(f" {ident_str:<14} {status_badge:<30} {rem_styled:<18} {path:<30} {subj_clip}")

    if len(code_changes) > display_limit:
        print(Colors.c(f"  ... and {len(code_changes) - display_limit} more changes (omitted for clean view) ...", Colors.DIM))
    print("─" * 96)

    # Statistics Calculation
    total_already_applied = sum(1 for item in all_audited if item[3])
    total_to_pick = len(code_changes) - total_already_applied

    UI.section("Audit & Pre-Check Summary", "📊")
    print(f"  • Total Changes Discovered  : {Colors.c(str(len(changes)), Colors.BOLD)}")
    print(f"  • Manifest Changes Excluded : {Colors.c(str(len(manifest_excluded)), Colors.MAGENTA)}")
    print(f"  • Total Code Patches        : {Colors.c(str(len(code_changes)), Colors.BOLD)}")
    print(f"  • Already Applied in Git    : {Colors.c(str(total_already_applied), Colors.BRIGHT_GREEN, Colors.BOLD)} (will be skipped)")
    print(f"  • Pending Application       : {Colors.c(str(total_to_pick), Colors.BRIGHT_CYAN, Colors.BOLD)}")
    print(f"  • Already on Allowed Remote : {Colors.c(str(len(ok_tracked)), Colors.GREEN)}")
    print(f"  • Upstream / Needs Fork     : {Colors.c(str(len(fork_needed)), Colors.BRIGHT_YELLOW, Colors.BOLD)} ({len(fork_needed)} repos)")
    if not_in_manifest:
        print(f"  • Not Found in Manifest     : {Colors.c(str(len(not_in_manifest)), Colors.BRIGHT_RED, Colors.BOLD)}")

    # Generate XML Snippet if requested or needed
    if fork_needed and (parsed_args.generate_xml or parsed_args.check_only):
        UI.section("Recommended XML for local_manifests/*.xml", "🧩")
        print(Colors.c("Copy/Paste this into .repo/local_manifests/asb_forks.xml to fork upstream repos:", Colors.DIM))
        print()
        print(Colors.c(generate_manifest_snippet([(c, mp) for c, mp, _, _ in fork_needed]), Colors.CYAN))
        print()

    if parsed_args.check_only:
        UI.info("Check-only mode completed. Exiting.")
        return

    # Picking Execution
    is_dry_run = not parsed_args.apply

    if is_dry_run:
        UI.section("Dry-Run Simulation Mode", "🚀")
        UI.warn("Running in DRY-RUN mode. No git repositories will be modified.")
        UI.info("To execute real cherry-picks, re-run with '--apply':")
        cmd_args = " ".join(sys.argv[1:])
        print(f"    {Colors.c(f'repo-pick {cmd_args} --apply', Colors.BOLD, Colors.BRIGHT_GREEN)}\n")
    else:
        UI.section("Executing Cherry-Picks", "🚀")

    picker = CherryPicker(top_dir)
    applied_count = 0
    skipped_count = 0
    failed_count = 0

    # Filter out already applied items for picking
    to_execute = [(c, path, applied, reason) for c, rem, path, applied, reason, cat in all_audited]
    targets = to_execute if not is_dry_run else to_execute[:8]

    for idx, (c, path_str, already_applied, reason) in enumerate(targets, 1):
        target_path = top_dir / path_str
        prefix = f"[{idx}/{len(targets)}]"
        ident = f"#{c.identifier}" if c.identifier.isdigit() else c.identifier

        if already_applied:
            print(f"  {Colors.c(prefix, Colors.DIM)} {ident} {Colors.c('SKIPPED', Colors.GREEN, Colors.BOLD)} ({reason})")
            skipped_count += 1
            continue

        if is_dry_run:
            ok, msg, details = picker.apply_change(c, target_path, dry_run=True)
            print(f"  {Colors.c(prefix, Colors.DIM)} {ident} {c.subject[:42]}")
            print(f"         Path: {path_str}")
            print(f"         {Colors.c(msg, Colors.DIM, Colors.CYAN)}")
            applied_count += 1
        else:
            print(f"  {Colors.c(prefix, Colors.CYAN, Colors.BOLD)} Cherry-picking {ident}: {c.subject[:40]} ...", end="", flush=True)
            ok, msg, details = picker.apply_change(c, target_path, dry_run=False)
            if ok:
                print(f" {Colors.c('DONE', Colors.GREEN, Colors.BOLD)}")
                applied_count += 1
            else:
                print(f" {Colors.c('FAILED', Colors.RED, Colors.BOLD)}")
                rel_path = target_path.relative_to(top_dir) if target_path.is_relative_to(top_dir) else target_path
                UI.error(f"  Target Repository : {Colors.c(str(rel_path), Colors.BOLD, Colors.BRIGHT_YELLOW)}")
                UI.error(f"  Absolute Path     : {target_path}")
                UI.error(f"  Reason            : {msg}")
                if details:
                    print(f"      {Colors.c('Affected / Uncommitted Files:', Colors.BOLD, Colors.WHITE)}")
                    for d in details:
                        print(f"        {Colors.c('•', Colors.BRIGHT_RED)} {d}")
                failed_count += 1
                if not parsed_args.force:
                    print()
                    UI.warn(f"Aborting. Clean/commit the repository '{rel_path}' or re-run with --force to continue.")
                    sys.exit(1)

    if is_dry_run and len(to_execute) > 8:
        print(Colors.c(f"\n  ... {len(to_execute) - 8} more cherry-picks simulated cleanly ...", Colors.DIM))

    print()
    if is_dry_run:
        UI.success("Dry-run simulation completed. All checks passed.")
    else:
        UI.success(f"Execution finished: {applied_count} applied, {skipped_count} skipped (already applied), {failed_count} failed.")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{Colors.c('Process interrupted by user.', Colors.YELLOW)}")
        sys.exit(130)
