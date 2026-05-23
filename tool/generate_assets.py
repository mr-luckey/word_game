"""Download images, Lottie animations, and generate game audio assets."""
from __future__ import annotations

import json
import math
import struct
import urllib.request
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ASSETS = ROOT / "assets"

IMAGES = {
    "images/splash/travel_bg.jpg": (
        "https://images.unsplash.com/photo-1488646953014-85cb44e25828"
        "?auto=format&fit=crop&w=1080&q=80"
    ),
    "images/themes/paris_bg.jpg": (
        "https://images.unsplash.com/photo-1502602898657-3e91760cbb34"
        "?auto=format&fit=crop&w=800&q=80"
    ),
    "images/themes/tokyo_bg.jpg": (
        "https://images.unsplash.com/photo-1540959733332-eab4deabeeaf"
        "?auto=format&fit=crop&w=800&q=80"
    ),
    "images/themes/nyc_bg.jpg": (
        "https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9"
        "?auto=format&fit=crop&w=800&q=80"
    ),
    "images/themes/rome_bg.jpg": (
        "https://images.unsplash.com/photo-1552832230-c0197dd311b5"
        "?auto=format&fit=crop&w=800&q=80"
    ),
    "images/themes/sydney_bg.jpg": (
        "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/"
        "Sydney_Opera_House_-_Dec_2008.jpg/1280px-Sydney_Opera_House_-_Dec_2008.jpg"
    ),
}

LOTTIES = {
    "animations/word_logo.json": (
        "https://lottie.host/0c6e6353-1d77-42ac-9f1f-5e8d4b54c0f6/8q8q8q8q8q.json"
    ),
}

# Public LottieFiles sample URLs (free to use in apps per LottieFiles license for preview assets)
LOTTIE_FALLBACKS = {
    "animations/word_logo.json": "https://assets2.lottiefiles.com/packages/lf20_ysrn2iwp.json",
    "animations/confetti.json": "https://assets1.lottiefiles.com/packages/lf20_u4yrau.json",
    "animations/star_burst.json": "https://assets9.lottiefiles.com/packages/lf20_qh5z2fdq.json",
    "animations/word_found.json": "https://assets4.lottiefiles.com/packages/lf20_swnrn2ly.json",
}


def download(url: str, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
    with urllib.request.urlopen(req, timeout=60) as resp:
        dest.write_bytes(resp.read())
    print(f"  OK {dest.relative_to(ROOT)} ({dest.stat().st_size // 1024} KB)")


def write_wav(path: Path, samples: list[float], rate: int = 44100) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    pcm = bytearray()
    for s in samples:
        v = max(-1.0, min(1.0, s))
        pcm.extend(struct.pack("<h", int(v * 32767 * 0.85)))

    with wave.open(str(path), "wb") as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(rate)
        wf.writeframes(bytes(pcm))


def tone(freq: float, duration: float, rate: int, vol: float = 0.3) -> list[float]:
    n = int(rate * duration)
    return [
        vol * math.sin(2 * math.pi * freq * t / rate) * math.exp(-3 * t / n)
        for t in range(n)
    ]


def silence(duration: float, rate: int) -> list[float]:
    return [0.0] * int(rate * duration)


def generate_audio() -> None:
    rate = 44100
    audio_dir = ASSETS / "audio"

    word_found = tone(880, 0.08, rate) + tone(1175, 0.12, rate, 0.25)
    write_wav(audio_dir / "word_found.wav", word_found, rate)

    wrong = tone(220, 0.15, rate, 0.35) + tone(180, 0.2, rate, 0.3)
    write_wav(audio_dir / "wrong.wav", wrong, rate)

    complete = (
        tone(523, 0.1, rate)
        + tone(659, 0.1, rate)
        + tone(784, 0.1, rate)
        + tone(1047, 0.25, rate, 0.35)
    )
    write_wav(audio_dir / "level_complete.wav", complete, rate)

    bg: list[float] = []
    chords = [(262, 330, 392), (294, 370, 440), (330, 415, 494), (349, 440, 523)]
    for root, third, fifth in chords:
        seg = int(rate * 1.2)
        for t in range(seg):
            f = t / seg
            v = 0.08 * (0.6 + 0.4 * math.sin(2 * math.pi * f))
            s = (
                math.sin(2 * math.pi * root * t / rate)
                + math.sin(2 * math.pi * third * t / rate)
                + math.sin(2 * math.pi * fifth * t / rate)
            ) / 3
            bg.append(v * s)
    write_wav(audio_dir / "bg_music.wav", bg, rate)

    for name in ["word_found", "wrong", "level_complete", "bg_music"]:
        p = audio_dir / f"{name}.wav"
        print(f"  OK {p.relative_to(ROOT)} ({p.stat().st_size // 1024} KB)")


def minimal_lottie_logo(path: Path) -> None:
    """Tiny valid Lottie: pulsing blue circle (no network)."""
    data = {
        "v": "5.7.4",
        "fr": 30,
        "ip": 0,
        "op": 90,
        "w": 200,
        "h": 200,
        "nm": "word_search_logo",
        "ddd": 0,
        "assets": [],
        "layers": [
            {
                "ddd": 0,
                "ind": 1,
                "ty": 4,
                "nm": "circle",
                "sr": 1,
                "ks": {
                    "o": {"a": 0, "k": 100},
                    "r": {"a": 0, "k": 0},
                    "p": {"a": 0, "k": [100, 100, 0]},
                    "a": {"a": 0, "k": [0, 0, 0]},
                    "s": {
                        "a": 1,
                        "k": [
                            {
                                "i": {"x": [0.4, 0.4, 0.4], "y": [1, 1, 1]},
                                "o": {"x": [0.6, 0.6, 0.6], "y": [0, 0, 0]},
                                "t": 0,
                                "s": [80, 80, 100],
                            },
                            {
                                "t": 45,
                                "s": [110, 110, 100],
                            },
                            {"t": 90, "s": [80, 80, 100]},
                        ],
                    },
                },
                "ao": 0,
                "shapes": [
                    {
                        "ty": "gr",
                        "it": [
                            {
                                "ty": "el",
                                "p": {"a": 0, "k": [0, 0]},
                                "s": {"a": 0, "k": [100, 100]},
                            },
                            {
                                "ty": "fl",
                                "c": {"a": 0, "k": [0.08, 0.4, 0.75, 1]},
                                "o": {"a": 0, "k": 100},
                                "r": 1,
                            },
                            {"ty": "tr", "p": {"a": 0, "k": [0, 0]}, "a": {"a": 0, "k": [0, 0]}, "s": {"a": 0, "k": [100, 100]}, "r": {"a": 0, "k": 0}, "o": {"a": 0, "k": 100}},
                        ],
                    }
                ],
                "ip": 0,
                "op": 90,
                "st": 0,
            }
        ],
    }
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data), encoding="utf-8")
    print(f"  OK {path.relative_to(ROOT)} (generated)")


def main() -> None:
    print("Downloading images (Unsplash)...")
    for rel, url in IMAGES.items():
        dest = ASSETS / rel
        if dest.exists() and dest.stat().st_size > 10_000:
            print(f"  skip {dest.relative_to(ROOT)} (exists)")
            continue
        try:
            download(url, dest)
        except Exception as e:
            print(f"  WARN {rel}: {e}")

    print("Downloading Lottie animations...")
    for rel, url in LOTTIE_FALLBACKS.items():
        dest = ASSETS / rel
        if dest.exists() and dest.stat().st_size > 1000:
            print(f"  skip {dest.relative_to(ROOT)} (exists)")
            continue
        try:
            download(url, dest)
        except Exception as e:
            print(f"  WARN {rel}: {e}")
            if rel == "animations/word_logo.json":
                minimal_lottie_logo(dest)
            elif rel == "animations/word_found.json":
                fallback = ASSETS / "animations/star_burst.json"
                if fallback.exists():
                    dest.write_bytes(fallback.read_bytes())
                    print(f"  OK {dest.relative_to(ROOT)} (copy star_burst)")

    print("Generating audio (WAV)...")
    generate_audio()
    print("Done.")


if __name__ == "__main__":
    main()
