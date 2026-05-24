"""Generate level packs for destinations missing from pack 1/2."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# (category_id, name, background_image, theme_key, words_pool)
DESTINATIONS = [
    (101, "London Heritage", "classic_travel/london.webp", "classic_travel",
     ["THAMES", "CROWN", "BIGBEN", "LONDON", "ROYAL", "BRIDGE", "PALACE", "GUARD"]),
    (104, "Amazon Quest", "forest_quest/amazon.webp", "forest_quest",
     ["JUNGLE", "RIVER", "TRIBE", "AMAZON", "VINE", "TOUCAN", "CANOPY", "RAIN"]),
    (105, "Redwood Trails", "forest_quest/redwood.webp", "forest_quest",
     ["REDWOOD", "TRAIL", "FERN", "TREES", "HIKING", "MOSS", "PATH", "GROVE"]),
    (106, "Alpine Forest", "forest_quest/alpine.webp", "forest_quest",
     ["ALPINE", "PEAK", "PINE", "VALLEY", "TRAIL", "MOSS", "FOREST", "CLIFF"]),
    (107, "Seoul Pulse", "neon_city/seoul_pulse.webp", "neon_city",
     ["SEOUL", "NEON", "PULSE", "KOREA", "HAN", "GLOW", "CITY", "LIGHT"]),
    (110, "Safari Adventure", "sunset_safari/safari.webp", "sunset_safari",
     ["SAFARI", "LION", "ZEBRA", "GIRAFFE", "SAVANNA", "HERD", "DUSK", "WILD"]),
    (111, "Cairo Dunes", "sunset_safari/cairo.webp", "sunset_safari",
     ["CAIRO", "PYRAMID", "SPHINX", "DESERT", "DUNES", "NILE", "SAND", "TOMB"]),
    (112, "Marrakech Escape", "sunset_safari/marrakech.webp", "sunset_safari",
     ["MEDINA", "SOUK", "MOROCCO", "SPICE", "RIAD", "PALM", "DUSK", "Atlas"]),
    (113, "Swiss Alps", "winter_alps/swiss.webp", "winter_alps",
     ["SWISS", "ALPS", "PEAK", "CHALET", "SKI", "GLACIER", "LAKE", "SNOW"]),
    (114, "Iceland Quest", "winter_alps/iceland.webp", "winter_alps",
     ["ICELAND", "GEYSER", "GLACIER", "FROST", "VOLCANO", "FALLS", "MIST", "LAVA"]),
    (115, "Aurora Escape", "winter_alps/aurora.webp", "winter_alps",
     ["AURORA", "NORTHERN", "LIGHTS", "POLAR", "STARS", "FROST", "NIGHT", "GLOW"]),
    (116, "Dubai Luxury", "dark_luxury/dubai.webp", "dark_luxury",
     ["DUBAI", "BURJ", "PALM", "LUXURY", "MARINA", "YACHT", "GOLD", "SKYLINE"]),
    (117, "Monaco Nights", "dark_luxury/monaco.webp", "dark_luxury",
     ["MONACO", "HARBOR", "YACHT", "RIVIERA", "CASINO", "LUXURY", "COAST", "NIGHT"]),
    (118, "Milan Prestige", "dark_luxury/milan.webp", "dark_luxury",
     ["MILAN", "DUOMO", "FASHION", "PRESTIGE", "ITALY", "LUXURY", "STYLE", "PLAZA"]),
    (119, "Santorini Coast", "ocean_escape/santorini.webp", "ocean_escape",
     ["SANTORINI", "GREECE", "DOME", "COAST", "BLUE", "ISLAND", "CLIFF", "WAVE"]),
    (120, "Bali Waves", "ocean_escape/bali.webp", "ocean_escape",
     ["BALI", "WAVES", "TEMPLE", "ISLAND", "SURF", "TROPIC", "SUNSET", "REEF"]),
]

DIFFICULTY = [
    (0, 8, 180, 3, 30),
    (1, 10, 240, 2, 50),
    (2, 12, 300, 2, 70),
    (3, 14, 360, 1, 90),
]


def words_for_level(pool: list[str], diff: int, level_idx: int) -> list[str]:
    count = 4 + diff
    out = []
    for i in range(count):
        out.append(pool[(level_idx + i) % len(pool)])
    return out


def build_category(cat_id: int, name: str, bg: str, theme: str, pool: list[str]) -> dict:
    levels = []
    level_num = 0
    for diff_idx, grid, time_limit, hints, base_coins in DIFFICULTY:
        for i in range(5):
            level_num += 1
            levels.append({
                "id": cat_id * 100 + level_num,
                "difficultyIndex": diff_idx,
                "gridSize": grid,
                "timeLimit": time_limit + i * 15,
                "hintsAllowed": hints,
                "coinsReward": base_coins + i * 5,
                "words": words_for_level(pool, diff_idx, level_num + i),
            })
    return {
        "id": cat_id,
        "name": name,
        "theme": theme,
        "backgroundImage": bg,
        "levels": levels,
    }


def main() -> None:
    categories = [
        build_category(cat_id, name, bg, theme, pool)
        for cat_id, name, bg, theme, pool in DESTINATIONS
    ]
    pack = {"version": "1.0", "categories": categories}
    out = ROOT / "assets" / "data" / "levels_pack_3.json"
    out.write_text(json.dumps(pack, indent=2), encoding="utf-8")
    total = sum(len(c["levels"]) for c in categories)
    print(f"Wrote {out.name}: {len(categories)} destinations, {total} levels")


if __name__ == "__main__":
    main()
