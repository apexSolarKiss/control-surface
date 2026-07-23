#!/usr/bin/env python3
"""Machine-local verifier for the native private-persistent write gate (Claude Code).

Proves the STATIC class only: that an installed settings file carries the required
native permission rules, that bypass mode is disabled, that the runtime is at or
above the tested floor, and, when captured startup output is supplied, that it
contains no unmatched-rule warning. Without `--startup-log` that last check is not
performed, and the run reports so.

It NEVER emits ACTIVE-CONFORMANT.

Why it cannot: `autoMemoryDirectory` is read from any settings scope -- user,
project, local, policy, or `--settings`, with project and local additionally
gated by workspace trust -- so reading one settings file cannot establish the
effective auto-memory root. A `CLAUDE.md` may also import an instruction file
from an arbitrary absolute or home-relative path, and imports may recurse, so no
file inspection can enumerate the private instruction paths a session actually
loaded. Both are active-session facts.

Outcomes (this script):

    STATIC-CONFORMANT / ACTIVE-SESSION-UNVERIFIED      exit 0
    BLOCKED-MISSING-RULE                               exit 1
    BLOCKED-UNMATCHED-RULE                             exit 1
    BLOCKED-VERSION                                    exit 1

`ACTIVE-CONFORMANT` and `BLOCKED-UNCOVERED-PRIVATE-PATH` are OPERATOR
classifications attached to an active-session receipt, not states this script can
produce. The receipt template is printed on every run.

Usage:
  check-native-memory-gate.py [--settings PATH] [--fragment PATH]
                              [--startup-log PATH] [--version STRING]
"""
import argparse
import json
import os
import re
import shutil
import subprocess
import sys

VERSION_FLOOR = (2, 1, 212)

# The runtime reports a rule it accepted but will never match. Fail closed on any of these.
UNMATCHED_MARKERS = (
    "will never match",
    "not matched by",
    "unmatched permission rule",
    "invalid permission rule",
    "unknown tool in permission rule",
)


def load_json(path, label, errors):
    try:
        with open(os.path.expanduser(path)) as fh:
            return json.load(fh)
    except FileNotFoundError:
        errors.append("%s not found: %s" % (label, path))
    except Exception as exc:  # noqa: BLE001 - any parse failure is fail-closed
        errors.append("%s does not parse (%s): %s" % (label, exc, path))
    return None


def required_rules(fragment):
    perms = fragment.get("permissions") if isinstance(fragment, dict) else None
    ask = perms.get("ask") if isinstance(perms, dict) else None
    return list(ask) if isinstance(ask, list) else None


def detect_version(explicit):
    raw = explicit
    if raw is None:
        exe = shutil.which("claude")
        if exe is None:
            return None, "claude executable not on PATH"
        try:
            raw = subprocess.run([exe, "--version"], capture_output=True, text=True,
                                 timeout=30).stdout
        except Exception as exc:  # noqa: BLE001
            return None, "could not run `claude --version` (%s)" % exc
    match = re.search(r"(\d+)\.(\d+)\.(\d+)", raw or "")
    if not match:
        return None, "no version number in %r" % (raw or "")
    return tuple(int(g) for g in match.groups()), None


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--settings", default="~/.claude/settings.json",
                        help="installed settings file to inspect")
    parser.add_argument("--fragment",
                        default=os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                             "native-memory-write-gate.settings.fragment.json"),
                        help="owner fragment that defines the required rules")
    parser.add_argument("--startup-log", default=None,
                        help="captured Claude Code startup output, if available")
    parser.add_argument("--version", default=None,
                        help="version string to test instead of running `claude --version`")
    args = parser.parse_args()

    hard = []
    fragment = load_json(args.fragment, "owner fragment", hard)
    if hard:
        for line in hard:
            print("HARD ERROR : %s" % line)
        print("\nVERDICT: BLOCKED-MISSING-RULE  <-- the owner fragment is the rule source; it must be readable")
        return 1
    wanted = required_rules(fragment)
    if wanted is None:
        print("HARD ERROR : owner fragment has no permissions.ask list")
        print("\nVERDICT: BLOCKED-MISSING-RULE")
        return 1
    want_bypass = (fragment.get("permissions") or {}).get("disableBypassPermissionsMode")

    print("settings inspected   : %s" % args.settings)
    print("required rules from  : %s (%d rules)" % (args.fragment, len(wanted)))

    # ---- version floor (fail closed: an undetermined version is not evidence of conformance) ----
    version, why = detect_version(args.version)
    if version is None:
        print("runtime version      : UNDETERMINED (%s)" % why)
    else:
        print("runtime version      : %s (floor %s)" % (".".join(map(str, version)),
                                                        ".".join(map(str, VERSION_FLOOR))))

    # ---- installed settings ----
    errs = []
    settings = load_json(args.settings, "settings", errs)
    if errs:
        for line in errs:
            print("FAIL : %s" % line)
        print("\nVERDICT: BLOCKED-MISSING-RULE  <-- no readable installed settings, so no rule is proven present")
        receipt()
        return 1

    perms = settings.get("permissions") if isinstance(settings, dict) else None
    installed = perms.get("ask") if isinstance(perms, dict) else None
    installed = installed if isinstance(installed, list) else []
    missing = [r for r in wanted if r not in installed]
    unmatchable = [r for r in installed if r.startswith("Write(")]
    bypass = (perms or {}).get("disableBypassPermissionsMode")

    for rule in wanted:
        print("%s : %s" % ("ok   " if rule in installed else "MISS ", rule))
    print("%s : disableBypassPermissionsMode == %r (want %r)"
          % ("ok   " if bypass == want_bypass else "MISS ", bypass, want_bypass))

    # ---- startup-log evidence (only when supplied; absence is not evidence) ----
    unmatched_hits = []
    if args.startup_log:
        try:
            with open(os.path.expanduser(args.startup_log)) as fh:
                text = fh.read().lower()
            unmatched_hits = [m for m in UNMATCHED_MARKERS if m in text]
            print("startup log          : inspected (%s)" % args.startup_log)
        except Exception as exc:  # noqa: BLE001
            print("startup log          : UNREADABLE (%s)" % exc)
            unmatched_hits = ["startup log supplied but unreadable"]
    else:
        print("startup log          : not supplied -- unmatched-rule check NOT performed")

    # ---- verdict, most-blocking first ----
    if version is None or version < VERSION_FLOOR:
        verdict, note, rc = "BLOCKED-VERSION", (why or "below tested floor"), 1
    elif missing or bypass != want_bypass:
        detail = ", ".join(missing) if missing else "disableBypassPermissionsMode != %r" % want_bypass
        verdict, note, rc = "BLOCKED-MISSING-RULE", detail, 1
    elif unmatchable or unmatched_hits:
        detail = ", ".join(unmatchable + unmatched_hits)
        verdict, note, rc = "BLOCKED-UNMATCHED-RULE", detail, 1
    else:
        verdict = "STATIC-CONFORMANT / ACTIVE-SESSION-UNVERIFIED"
        note = "static installation conforms; the effective memory root and the loaded private imports are NOT proven here"
        rc = 0

    print("\nVERDICT: %s  <-- %s" % (verdict, note))
    receipt()
    return rc


def receipt():
    print("""
Active-session receipt required before this gate may be called conformant
(operator evidence -- this script cannot produce it):

  /permissions   every required rule present, with its source scope
  /context       every loaded instruction file and recursive import, each classified as
                   checked-in reviewed carrier | managed policy | private path covered by an ask rule
                 no unclassified private instruction path
  /memory        the effective auto-memory root, observed and canonicalized
  coverage       every governed private persistent path matched by an installed ask rule
  active mode    acceptable for private persistent-context maintenance

  all satisfied  -> ACTIVE-CONFORMANT                 (operator classification)
  any uncovered  -> BLOCKED-UNCOVERED-PRIVATE-PATH    (operator classification)
                    and the receipt names the exact rule required:
                        Edit(//<canonical-absolute-path>/**)""")


if __name__ == "__main__":
    sys.exit(main())
