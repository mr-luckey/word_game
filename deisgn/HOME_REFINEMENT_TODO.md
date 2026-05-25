# Home Screen — Design Refinement TODO

Reference mockups: `deisgn/home/` (7 themes: Paris, Maldives, Amazon, Safari, Tokyo, Dubai, Swiss Alps).

## Done (this pass)
- [x] Full-screen `CustomScrollView` — no Column+Expanded overflow
- [x] Responsive card heights via `HomeLayoutMetrics`
- [x] Tagline: "Travel the world with words" (was wrong theme label)
- [x] Airplane icon on JOURNEY (mockup)
- [x] Daily Bonus / Achievements: `minHeight` + ellipsis, matched row heights
- [x] Featured card: full-bleed for Safari, Dubai, Maldives themes
- [x] Bottom padding for shell nav bar
- [x] Coin "+" opens Shop

## Next (visual polish)
- [ ] Per-theme passport stamp assets (replace generic verified icon)
- [ ] Use `assets/images/home/` reference JPEGs only in design — wire theme splash/grid in app
- [ ] Daily bonus: real countdown from backend / local storage
- [ ] Achievements: live progress from profile cubit (not hardcoded 0/1)
- [ ] Play button: theme-specific textures (snow, moss, neon) from mockup
- [ ] Bottom nav: theme-specific icons (backpack, safari hat on forest theme)
- [ ] Featured card: frangipani / decorative overlays per destination
- [ ] Lottie subtle idle animation on gift box / plane (optional)

## QA checklist
- [ ] Test height 640px (small phone) — no yellow/black overflow stripes
- [ ] Test all 7 `AppThemePreset` home screens
- [ ] RTL / large font accessibility pass
- [ ] Tablet width — `JourneyContentWidth` max 520 centered
