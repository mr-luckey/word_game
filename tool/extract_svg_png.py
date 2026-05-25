"""Extract embedded PNG from splash_screen.svg."""
from __future__ import annotations

import base64
import io
import re
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SVG = ROOT / "design world tour" / "splash_screen.svg"
OUT_DIR = ROOT / "assets" / "images" / "themes" / "world_tour"


def main() -> None:
    text = SVG.read_text(encoding="utf-8", errors="ignore")
    m = re.search(r'xlink:href="data:image/png;base64,([^"]+)"', text)
    if not m:
        raise SystemExit("embedded PNG not found")
    data = base64.b64decode(m.group(1))
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    raw = OUT_DIR / "_full_design.png"
    raw.write_bytes(data)
    img = Image.open(io.BytesIO(data))
    print(f"extracted {img.size} -> {raw}")
    splash = img.resize((900, int(900 * img.height / img.width)), Image.Resampling.LANCZOS)
    splash_path = OUT_DIR / "splash.webp"
    splash.save(splash_path, "WEBP", quality=88, method=6)
    print(f"splash webp {splash_path} ({splash_path.stat().st_size // 1024} KB)")
    grid_path = OUT_DIR / "grid_full.webp"
    splash.save(grid_path, "WEBP", quality=85, method=6)
    print(f"grid webp {grid_path}")


if __name__ == "__main__":
    main()
