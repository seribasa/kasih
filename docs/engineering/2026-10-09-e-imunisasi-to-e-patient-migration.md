# e-Imunisasi to e-Patient Migration Tracker

**Date:** 2026-10-09
**Branch:** `codex/map-e-Patient-to-e-patient`
**Source baseline:** `/Users/rfaturriza/Documents/development/mobile/e-Patient/`
**Business reference:** `docs/plans/2026-09-30-e-patient-business-requirements.md` section 8.

## 1. Migration objective

Use the existing e-Imunisasi Flutter application as the technical baseline, then refactor it gradually into e-Patient according to the business mapping in section 8.

The first step in this branch is intentionally limited to bootstrapping the source code into the e-Patient repository. Feature/domain changes should be handled in focused follow-up commits so each migration decision remains reviewable.

## 2. Baseline copy scope

Copied:

- Flutter app source: `lib/`
- Tests: `test/`
- Flutter assets: `assets/`
- Platform projects: `android/`, `ios/`, `web/`
- Flutter package metadata: `pubspec.yaml`, `pubspec.lock`, `.metadata`, `.fvmrc`
- Existing CI/release workflow files under `.github/`
- Existing e-Imunisasi README and supporting project files

Excluded from copy:

- Git history from e-Imunisasi: `.git/`
- Build/cache folders: `build/`, `.dart_tool/`, `.gradle/`, `.fvm/`, `ios/Pods/`, `ios/.symlinks/`
- Local IDE/project state: `.idea/`, `.vscode/`, `.idx/`, `.DS_Store`
- Local secret/config files: `.env`, `.env.*`, `android/local.properties`, `android/key.properties`, `android/keystore/`
- Generated iOS local environment files containing absolute local paths: `ios/Flutter/Generated.xcconfig`, `ios/Flutter/flutter_export_environment.sh`

## 3. Section 8 migration order

| Order | e-Imunisasi capability | e-Patient direction | Suggested first refactor target |
|---:|---|---|---|
| 1 | App identity and copy baseline | Rename user-facing product surface from e-Imunisasi to e-Patient | Package metadata, app labels, README, constants, route naming |
| 2 | Onboarding | Redesign to choose goals and create self profile first | `lib/features/onboarding/` |
| 3 | Authentication and local PIN | Keep and extend with device/session/step-up auth | `lib/features/authentication/` |
| 4 | Parent profile and multi-child | Generalize to patient, household, dependent, caregiver delegation | `lib/features/profile/` |
| 5 | Child selection for booking | Generalize to “patient being served” | Profile selection models + booking entry points |
| 6 | Immunization booking | Generalize to consultation, control, vaccine, lab, home care catalog | `lib/features/vaccination/` and appointment models |
| 7 | QR check-in | Keep pattern with expiry/fallback manual | Appointment confirmation/check-in screens |
| 8 | Payment | Keep conditionally for invoice/payment/reconciliation | `lib/features/payment/` |
| 9 | Buku KIA / Buku Sehat | Redesign into longitudinal health timeline | `lib/features/healthy_book/` |
| 10 | Growth chart | Keep as pediatric module only | Growth chart models/screens under health timeline |
| 11 | Calendar | Extend to appointments, medication, routine checks, vaccines | `lib/features/calendar/` |
| 12 | Clinic/health worker directory | Extend filters, service catalog, schedule, price/channel | `lib/features/contact/`, `lib/features/health_worker/` |
| 13 | Messages | Expand into notification center and education content | `lib/features/message/` |

## 4. First recommended follow-up commit

Start with a safe rename/setup pass before deep feature refactoring:

1. Rename product metadata from e-Imunisasi to e-Patient.
2. Update app labels, package/application identifiers only after deciding final bundle IDs.
3. Replace obvious user-facing strings while preserving domain-specific code until its target module is refactored.
4. Add an `.env.example` instead of committing real `.env` values.
5. Run Flutter dependency resolution and static analysis after environment setup.

## 5. Notes and risks

- The copied code still contains e-Imunisasi domain names, routes, feature names, UI strings, and assumptions around child/pediatric workflows.
- Android and iOS release workflows may reference e-Imunisasi package IDs, signing, store metadata, and secret names. These should be reviewed before any release pipeline is enabled.
- Generated Dart files are ignored by the copied `.gitignore`; if the project requires them for build/test without code generation, they should be intentionally regenerated or force-added in a later setup commit.
- The source copy is not yet a functional e-Patient implementation; it is the migration baseline.
