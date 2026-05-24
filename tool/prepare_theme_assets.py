"""Split user-provided 2x2 theme grid PNGs into destination + splash WebP crops."""
from __future__ import annotations

from pathlib import Path

try:
    from PIL import Image
except ImportError:
    raise SystemExit("Install Pillow: pip install Pillow")

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "assets" / "images" / "source"
OUT = ROOT / "assets" / "images" / "themes"

THEMES: dict[str, dict] = {
    "classic_travel": {
        "file": "classic_travel_grid.png",
        "dest1": "paris.webp",
        "dest2": "london.webp",
        "dest3": "rome.webp",
        "splash": "br",
    },
    "forest_quest": {
        "file": "forest_quest_grid.png",
        "dest1": "amazon.webp",
        "dest2": "redwood.webp",
        "dest3": "alpine.webp",
        "splash": "br",
    },
    "neon_city": {
        "file": "neon_city_grid.png",
        "dest1": "tokyo_nights.webp",
        "dest2": "seoul_pulse.webp",
        "dest3": "nyc_neon.webp",
        "splash": "br",
    },
    "sunset_safari": {
        "file": "sunset_safari_grid.png",
        "dest1": "safari.webp",
        "dest2": "cairo.webp",
        "dest3": "marrakech.webp",
        "splash": "br",
    },
    "winter_alps": {
        "file": "winter_alps_grid.png",
        "dest1": "swiss.webp",
        "dest2": "iceland.webp",
        "dest3": "aurora.webp",
        "splash": "bl",
    },
    "dark_luxury": {
        "file": "dark_luxury_grid.png",
        "dest1": "dubai.webp",
        "dest2": "monaco.webp",
        "dest3": "milan.webp",
        "splash": "tl",
    },
    "ocean_escape": {
        "file": "ocean_escape_grid.png",
        "dest1": "maldives.webp",
        "dest2": "santorini.webp",
        "dest3": "bali.webp",
        "splash": "tl",
    },
}

CURSOR_ASSETS = Path(
    r"C:\Users\engin\.cursor\projects\d-Playstore-word-game\assets"
)

SOURCE_MAP = {
    "classic_travel_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.24_AM-cfd145dc-29d5-4588-93b5-c8bf4e3c1e74.png",
    "ocean_escape_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.24_AM__1_-c944baf8-3e32-45a7-a583-4eef3b49efb5.png",
    "forest_quest_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.24_AM__2_-85a18160-44e9-48fd-a32a-765fab771d29.png",
    "sunset_safari_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.25_AM-41b3b4bc-bdb4-45c0-9553-497c74c6f6c9.png",
    "neon_city_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.25_AM__1_-1233bfe0-a4f7-4554-8a57-0dd9b024079f.png",
    "dark_luxury_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.25_AM__2_-c14302f4-5b22-48f4-a66e-cc329fd466f9.png",
    "winter_alps_grid.png": "c__Users_engin_AppData_Roaming_Cursor_User_workspaceStorage_0d16f3106255c0e9b5117bd207c9db76_images_WhatsApp_Image_2026-05-24_at_11.47.26_AM-831f6af1-ddf6-4fe1-b0e5-3ebbd4f57d7f.png",
}


def copy_sources() -> None:
    SOURCE.mkdir(parents=True, exist_ok=True)
    for short, original in SOURCE_MAP.items():
        dest = SOURCE / short
        if dest.exists():
            continue
        src = CURSOR_ASSETS / original
        if not src.exists():
            print(f"  SKIP missing: {original[:60]}...")
            continue
        dest.write_bytes(src.read_bytes())
        print(f"  Copied {short}")


def crop_quadrants(img: Image.Image) -> dict[str, Image.Image]:
    w, h = img.size
    hw, hh = w // 2, h // 2
    return {
        "tl": img.crop((0, 0, hw, hh)),
        "tr": img.crop((hw, 0, w, hh)),
        "bl": img.crop((0, hh, hw, h)),
        "br": img.crop((hw, hh, w, h)),
    }


def save_webp(img: Image.Image, path: Path, max_width: int = 900) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if img.mode != "RGB":
        img = img.convert("RGB")
    if img.width > max_width:
        ratio = max_width / img.width
        img = img.resize((max_width, int(img.height * ratio)), Image.Resampling.LANCZOS)
    img.save(path, "WEBP", quality=85, method=6)
    kb = path.stat().st_size // 1024
    print(f"    OK {path.relative_to(ROOT)} ({kb} KB)")


def process_theme(name: str, cfg: dict) -> None:
    src_path = SOURCE / cfg["file"]
    if not src_path.exists():
        print(f"  MISSING {cfg['file']}")
        return
    img = Image.open(src_path)
    quads = crop_quadrants(img)
    out_dir = OUT / name
    save_webp(quads["tl"], out_dir / cfg["dest1"])
    save_webp(quads["tr"], out_dir / cfg["dest2"])
    save_webp(quads["bl"], out_dir / cfg["dest3"])
    save_webp(quads[cfg["splash"]], out_dir / "splash.webp")
    save_webp(img, out_dir / "grid_full.webp", max_width=1200)


def main() -> None:
    print("Copying source grids...")
    copy_sources()
    print("\nProcessing themes...")
    for name, cfg in THEMES.items():
        print(f"  {name}:")
        process_theme(name, cfg)
    print("\nDone.")


if __name__ == "__main__":
    main()
