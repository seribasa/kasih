# Kasih brand assets

Generated with the built-in image generation tool on 11 October 2026, then resized for existing platform icon slots with macOS `sips`. These are raster originals, not editable vector artwork.

## Assets and usage

| Asset | Usage |
|---|---|
| `assets/images/e_patient_logo.png` | 1024 px square master; login, splash, first onboarding slide |
| `assets/images/e_patient_care.png` | General patient/caregiver illustration; home and second onboarding slide |
| `assets/images/logo.png` | Compatibility copy of the new logo |
| Android mipmap and drawable launcher icons | Existing icon slots, regenerated from the master |
| iOS AppIcon catalog | Existing icon slots, regenerated at sizes from Contents.json |
| Web favicon and icons | Existing 32/192/512 px slots |

Monochrome identity with a patient silhouette and sharp frame, white background, and no pediatric/vaccine-only symbolism. UI corners remain governed by the app theme; mobile operating systems may mask launcher icons into their own shapes.

The older baby/onboarding illustration files are retained for history but no longer referenced by the changed home/onboarding screens. The new onboarding copy describes self and family health coordination, without claiming unfinished features are available.

To regenerate platform sizes on macOS after replacing the square master:

```sh
node scripts/regenerate-brand-icons.mjs
```

## Final generation prompts

### Logo

Use case: logo-brand. Create one production logo symbol for Kasih, a general patient and family healthcare app for all ages. Asset: square app icon / in-app brand mark, no wordmark or letters. Design a distinctive bold geometric symbol that combines a human patient silhouette and a protective open frame with a subtle medical plus in negative space. Restrained Swiss modernist visual identity, exact black and white only, flat vector-like edges, sharp square corners in framing, no rounded container, no gradients, no shadows, no mockups. White background, centered black symbol, generous 18% safe margin all around, balanced proportions, very readable at 48 px. No baby, syringe, vaccine, heart pulse, red cross, text, watermark, or extra variants. Output a single high resolution square logo.

### Care illustration

Use case: illustration-story. Asset: onboarding and home illustration for Kasih, general healthcare coordination for patients of all ages. One wide landscape editorial illustration in crisp monochrome black white and light gray only. A young adult patient, an older adult, and a caregiver standing together beside a large abstract health organizer with calendar squares and a document, supportive calm inclusive atmosphere. Contemporary flat vector-like Swiss editorial composition, strong simple silhouettes and clean geometry, sharp corners for cards and panels, generous whitespace, plain white background. Do not include text, letters, logos, watermark, syringes, vaccination, babies, rounded cards, gradients or shadows. Single coherent illustration, no frames, no multiple variants. Suitable for a general patient app rather than pediatric immunization.
