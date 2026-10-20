#!/usr/bin/env python3
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
sys.argv = [sys.argv[0], "burn", *sys.argv[1:]]
from mik_aml.__main__ import main

if __name__ == "__main__":
    main()
