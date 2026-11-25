# Kasih Product Requirements Document

**Status:** Draft PRD for product, design, business, legal, clinical, ops, and engineering alignment  
**Date:** 2 October 2026  
**Source:** Derived from `docs/plans/2026-09-30-e-patient-business-requirements.md`  
**Figma:** https://www.figma.com/design/cmjvwgZ153ZAFlQ3cU4QWz  
**Primary page:** `03 Material 3 UX Improved`  
**Owner:** Product Owner Kasih / Seribasa

---

## 1. Executive Summary

Kasih adalah aplikasi patient-facing untuk membantu pasien dan keluarga mengelola perjalanan kesehatan secara aman: membuat profil pasien, mengatur anggota keluarga/caregiver, mencari layanan kesehatan, melakukan booking, membayar, menerima reminder, melihat timeline kesehatan dasar, dan mengelola consent/privacy.

PRD ini mengerucutkan BRD menjadi requirement produk yang siap dipakai untuk validasi UX, penyusunan backlog, dan perencanaan engineering. Fokus awal adalah **MVP: Foundation and Care Access**, bukan seluruh visi longitudinal health platform.

### 1.1 Product Thesis

Kasih menjadi pendamping kesehatan keluarga yang membuat administrasi kesehatan lebih rapi tanpa mengorbankan privasi pasien.

### 1.2 MVP Promise

Pengguna dapat:

- Membuat akun dan profil pasien sendiri.
- Menambahkan dependent yang sah dikelola.
- Mengundang anggota dewasa/caregiver dengan akses terbatas dan dapat dicabut.
- Mencari fasyankes/provider/layanan.
- Booking layanan untuk diri sendiri atau anggota yang berhak dikelola.
- Melihat status booking, payment, reminder, dan QR/check-in.
- Melihat timeline aktivitas/dokumen dasar dengan label sumber.
- Mengelola consent, akses keluarga, audit aktivitas, dan support issue.

### 1.3 Critical Product Principle

**Household is not consent.** Satu rumah tangga/care circle hanya mengorganisasi orang, bukan otomatis membuka akses data medis. Akses harus eksplisit, granular, dapat dicabut, dan diaudit.

---

## 2. Goals and Non-Goals

### 2.1 Product Goals

| ID | Goal | Success Signal |
|---|---|---|
| G-01 | Pasien dapat menyelesaikan booking layanan kesehatan secara end-to-end | Search-to-booking conversion, booking confirmed rate |
| G-02 | Keluarga dapat membantu pasien tanpa akses berlebihan | Grant accepted rate, revoke success, low access dispute |
| G-03 | Payment dan appointment memiliki status jelas | Payment completion, payment mismatch rate |
| G-04 | Dokumen/aktivitas kesehatan dasar lebih mudah ditemukan | Timeline usage, document upload, record detail view |
| G-05 | Produk dipercaya karena consent dan audit transparan | Privacy center usage, audit visibility, low unauthorized access report |
| G-06 | Fasyankes/operator dapat menjalankan supply side minimum | Slot accuracy, check-in completion, reconciliation success |

### 2.2 MVP Non-Goals

- Tidak memberi diagnosis, rekomendasi pengobatan, atau clinical decision support otomatis.
- Tidak menjadi RME penuh untuk fasyankes.
- Tidak menjanjikan layanan emergency.
- Tidak memberikan akses medis penuh hanya karena satu KK/household.
- Tidak mengelola klaim BPJS/asuransi end-to-end.
- Tidak menyediakan e-prescription/pharmacy fulfillment pada MVP.
- Tidak melakukan broad SATUSEHAT sync sebelum jalur legal, partner, dan teknis selesai.

---

## 3. Target Users

### 3.1 Primary Personas

| Persona | Main Job | MVP Need |
|---|---|---|
| Pasien dewasa mandiri | Mengatur layanan kesehatan sendiri | Profil, booking, payment, reminder, records, privacy |
| Orang tua/wali | Mengelola anak/dependent | Dependent profile, booking, payment, document timeline |
| Caregiver/pasangan | Membantu appointment/payment | Invitation, limited grant, audit, revoke handling |
| Admin fasyankes | Menjaga supply layanan tetap akurat | Catalog, schedule, booking worklist, check-in |
| Support | Menangani masalah tanpa akses berlebihan | Ticket, dispute, refund trace, elevated access audit |

### 3.2 Secondary Personas

- Nakes/provider yang menerbitkan ringkasan/record pada P1.
- Compliance/auditor yang memeriksa consent dan audit trail.
- Finance/operator yang melakukan reconciliation.

---

## 4. MVP Scope

### 4.1 In Scope

| Area | Included |
|---|---|
| Identity | Sign up/login, contact verification, recovery-safe flow, session/device management, PIN/biometric |
| Patient profile | Self profile, verification level, duplicate flag, patient switcher |
| Family/care circle | Household/care circle, dependent, adult invite, access grants, revoke, dispute |
| Directory | Search provider/fasyankes/service, filter, detail, freshness, verified status |
| Booking | Patient selection, provider/service/slot, pre-visit form, price/policy review, booking lifecycle |
| Payment | Invoice/order, payment pending/verified, receipt, refund status, reconciliation |
| Calendar/notification | Appointment reminders, notification center, quiet hours, privacy-safe lock screen |
| Records MVP | Activity/document timeline, user-uploaded document, source label, wrong-record report |
| Privacy | Consent records, privacy center, audit activity, data request entry point |
| Support | Booking, payment, data, and family access support ticket |
| Provider ops minimum | Provider onboarding, catalog, schedule, booking worklist, check-in, payment reconciliation, support/audit queue |

### 4.2 P1 Scope

- Provider-linked encounter summary/document publishing.
- Medication list/reminder.
- Preventive care schedule.
- Home measurements.
- Pediatric growth chart.
- More granular caregiver expiry and multi-caregiver support.
- Data export/share subset with expiry and revoke.
- Limited SATUSEHAT use cases only after approval.

### 4.3 P2 Scope

- Insurance/penjamin.
- Referral.
- Pharmacy fulfillment/e-prescription.
- Corporate/community programs.
- Family wellness package.
- Educational insights that are explainable and non-diagnostic.

---

## 5. Product Experience Overview

### 5.1 Navigation Model

Mobile app uses five primary destinations:

| Destination | Purpose |
|---|---|
| Home | Patient context, next appointment, quick actions, family profiles |
| Care | Provider/service search, provider detail, booking entry |
| Records | Timeline, documents, health items, upload/report |
| Calendar | Appointment, reminder, preventive schedule, medication reminders |
| Privacy | Consent, grants, audit, data rights, support/dispute |

### 5.2 Patient Context Model

Every sensitive workflow starts with a clear active patient context:

- Who is the patient?
- Who is acting?
- What permission does the actor have?
- Who is paying, if payment is required?

This prevents confusing “user account” with “patient profile”.

### 5.3 Design Reference

The Figma page `03 Material 3 UX Improved` contains the latest product design direction:

- 44 mobile screens.
- 8 provider/admin ops screens.
- Material 3-style navigation, surfaces, cards, chips, tonal buttons, and error states.
- UX architecture and review notes.

---

## 6. Core User Journeys

### 6.1 Onboarding Self-Managed Patient

1. User chooses sign-in method.
2. User verifies contact via OTP or equivalent.
3. User accepts required terms and privacy notice.
4. User creates self patient profile with minimum identity.
5. System checks duplicate risk.
6. User sets PIN/biometric and notification preference.
7. User lands on Home with primary actions: Book Care, Add Family, Complete Profile.

Acceptance:

- Contact is not trusted until verified.
- NIK is not required unless needed by a service/integration.
- Duplicate profile is flagged for review, not auto-merged.
- No clinical data appears during account recovery.

### 6.2 Add Dependent

1. Guardian selects Add Dependent.
2. Product explains dependent vs adult invite.
3. Guardian enters minimum identity and relationship.
4. Guardian confirms attestation/proof according to risk tier.
5. System checks duplicate risk.
6. Dependent profile is created as guardian-managed.
7. Audit record is created.

Acceptance:

- Dependent relationship has type and actor.
- Dependent creation does not grant another adult automatic access.
- Preventive setup can be offered but must not imply diagnosis.

### 6.3 Invite Adult Member or Caregiver

1. User sends invite to verified contact.
2. Recipient logs in/registers and verifies invite.
3. Recipient accepts or declines.
4. If accepted, patient/recipient selects access scopes.
5. Both sides see grant status.
6. Access can be revoked anytime.

Acceptance:

- No data is shared before acceptance.
- Default scope is minimum: appointment/payment support, no full clinical record.
- Full clinical access is never preselected.
- Declined invite reveals no medical data.

### 6.4 Book Appointment for Self or Family

1. Actor chooses eligible patient.
2. Actor searches service/provider.
3. Actor selects provider/service/slot.
4. System shows patient, actor, payer, price, policy, preparation, and emergency boundary.
5. Actor fills pre-visit questions.
6. Slot is held.
7. Payment is completed if required.
8. Backend confirms payment and appointment.
9. User gets appointment status, reminder, and QR/check-in token.

Acceptance:

- Slot ownership only starts after hold/confirmation.
- Paid status never comes from client redirect alone.
- Patient, actor, and payer are stored separately.
- Reminder is cancelled/replaced after reschedule/cancel.

### 6.5 Upload Document or Note

1. User chooses patient profile.
2. User chooses document type and event date.
3. System validates file and metadata.
4. Item appears in timeline.
5. Item is labeled user-added/non-verified.
6. User may share only with consent and audit.

Acceptance:

- User-uploaded items never appear provider-verified.
- Clinical provider records are read-only to patient.
- Wrong-patient report hides/quarantines affected item.

### 6.6 Revoke Family/Caregiver Access

1. Patient/guardian opens Privacy Center.
2. System shows active grants and last activity.
3. User selects revoke/reduce scope.
4. System explains consequences.
5. Access is revoked for future reads/actions.
6. Relevant sessions/tokens/deep links are invalidated.
7. Audit remains.

Acceptance:

- Revoke is effective immediately for future access.
- Historical audit is retained.
- Existing payment/appointment responsibility follows operational policy.

---

## 7. Functional Requirements

Priority:

- **MVP:** must be included for pilot readiness.
- **P1:** should follow after MVP stabilizes.
- **P2:** later expansion.
- **Out:** intentionally excluded.

### 7.1 Identity and Security

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-AUTH-001 | User can sign up/login with approved methods | MVP | Verified contact; error recovery; duplicate-account handling |
| PRD-AUTH-002 | Contact verification is required before recovery/sensitive actions | MVP | Unverified phone/email cannot be used for recovery |
| PRD-AUTH-003 | Account recovery protects medical data | MVP | Recovery uses step-up verification and audit |
| PRD-AUTH-004 | User can view/end active sessions | MVP | Revoked session cannot access protected endpoints |
| PRD-AUTH-005 | Device PIN/biometric is supported | MVP | Secure fallback exists |
| PRD-AUTH-006 | Risky actions require re-auth | MVP | Applies to export, delete account, full access grant, identity changes |
| PRD-AUTH-007 | Security alerts are sent for important changes | P1 | Login/new device/credential/grant alerts are visible |

### 7.2 Patient Profile

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-PROF-001 | User can create self patient profile | MVP | Name, DOB, admin sex, contact; required fields configurable |
| PRD-PROF-002 | Profile shows verification level | MVP | Unverified/contact-verified/identity-verified/facility-linked |
| PRD-PROF-003 | NIK or sensitive ID is masked and purpose-limited | MVP/P1 | Not required before business/legal basis exists |
| PRD-PROF-004 | Potential duplicate profile is flagged | MVP | No automatic clinical data merge |
| PRD-PROF-005 | User can update editable profile data | MVP | Verified fields use correction workflow |
| PRD-PROF-006 | User can manage language/timezone/accessibility preferences | P1 | Preferences affect UI/notification behavior |

### 7.3 Family, Dependent, and Access Grants

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-FAM-001 | User can create care circle/household | MVP | Household ID is not treated as KK or consent |
| PRD-FAM-002 | Guardian can add dependent profile | MVP | Relationship and attestation captured |
| PRD-FAM-003 | User can invite adult member/caregiver | MVP | No access before invite acceptance |
| PRD-FAM-004 | Adult member can choose access scope | MVP | Minimum default; full record not preselected |
| PRD-FAM-005 | Patient/guardian can view, reduce, revoke grants | MVP | Revoke applies to future access immediately |
| PRD-FAM-006 | Actor and patient are logged separately | MVP | Every action records actor, subject patient, outcome |
| PRD-FAM-007 | Payer can pay without clinical access | MVP | Invoice uses minimum necessary data |
| PRD-FAM-008 | Access dispute can suspend grant | MVP | Support can freeze grant without deleting evidence |
| PRD-FAM-009 | Dependent can later claim self-managed status | P1 | Verification and guardian notification exist |

### 7.4 Directory and Service Discovery

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-DIR-001 | User can search provider/fasyankes/service | MVP | Keyword and location supported |
| PRD-DIR-002 | User can filter results | MVP | Service, distance, schedule, mode, price/estimate |
| PRD-DIR-003 | Provider detail supports decision-making | MVP | Address, contact, service, schedule, price, policy |
| PRD-DIR-004 | Verified status is visible | MVP | Marketing claims are not shown as verified credentials |
| PRD-DIR-005 | Schedule/price freshness is visible | P1 | Last updated timestamp shown |

### 7.5 Appointment and Check-In

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-APT-001 | User selects patient before booking | MVP | Only eligible profiles with appointment scope appear |
| PRD-APT-002 | User selects provider/service/date/slot | MVP | Slot reconfirmed before final booking |
| PRD-APT-003 | Pre-visit form captures minimum data | MVP | Emergency disclaimer and privacy notice shown |
| PRD-APT-004 | Price/policy/refund shown before confirmation | MVP | Price change requires reconfirmation |
| PRD-APT-005 | Booking lifecycle is consistent | MVP | Draft, held, awaiting payment, confirmed, checked-in, completed, cancelled, no-show, expired |
| PRD-APT-006 | User can reschedule/cancel by policy | MVP | Fee/refund impact shown first |
| PRD-APT-007 | Double booking is prevented/explained | MVP | Idempotency and hold expiry are handled |
| PRD-APT-008 | QR/check-in token is supported | MVP/P1 | Token expires and reveals no medical data |
| PRD-APT-009 | Provider cancellation offers next action | MVP | User can choose refund/reschedule where applicable |
| PRD-APT-010 | Emergency use is redirected | MVP | App does not accept emergency as normal booking |

### 7.6 Payment, Invoice, and Refund

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-PAY-001 | System creates invoice/order for payable service | MVP | Items, fees, total, payer, patient, merchant visible |
| PRD-PAY-002 | Payment gateway is handled via backend | MVP | Secrets never live in client app |
| PRD-PAY-003 | Payment status is server-verified | MVP | Client redirect cannot mark paid |
| PRD-PAY-004 | Retry/webhook cannot duplicate payment/order | MVP | Idempotency on create and callback |
| PRD-PAY-005 | User sees latest invoice/payment status | MVP | Payment and appointment states are separate |
| PRD-PAY-006 | Refund status is trackable | MVP | SLA estimate and failure states visible |
| PRD-PAY-007 | Finance can reconcile payment | MVP | Gateway reference, order, payout, refund, exception available |

### 7.7 Records and Documents

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-REC-001 | User sees timeline per patient | MVP | No cross-profile data leakage |
| PRD-REC-002 | Every item shows type/date/source/status | MVP | User-generated is visually distinct from provider-verified |
| PRD-REC-003 | User can add document/note | MVP | File validation and source label applied |
| PRD-REC-004 | Wrong-patient report exists | MVP/P1 | Item can be hidden/quarantined and investigated |
| PRD-REC-005 | Provider-linked records are read-only | P1 | Patient can request correction |
| PRD-REC-006 | User can share subset with expiry | P1 | Share token/link is revocable and audited |

### 7.8 Calendar, Notification, and Messaging

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-CAL-001 | Calendar shows appointments and reminders | MVP/P1 | Filter by patient and type |
| PRD-CAL-002 | Lock-screen notification hides sensitive details | MVP | Default does not show diagnosis/medicine names |
| PRD-CAL-003 | User controls channels and quiet hours | MVP | Service notices and marketing are separated |
| PRD-CAL-004 | Reminder respects schedule changes | MVP | No stale reminder after cancel/reschedule |
| PRD-MSG-001 | Notification center stores read/unread status | MVP | Deep link revalidates session and grant |
| PRD-MSG-002 | Marketing consent is separate | MVP | Rejecting marketing does not block core service |

### 7.9 Privacy, Consent, and Data Rights

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-CON-001 | Consent is recorded per purpose/version | MVP | Who, what, purpose, time, channel, policy version |
| PRD-CON-002 | User can revoke revocable consent | MVP | Consequence shown before revoke |
| PRD-CON-003 | Family grant differs from terms/marketing consent | MVP | Consent is not bundled |
| PRD-CON-004 | User can request access/correction/export/delete | MVP/P1 | Request has SLA, verification, audit |
| PRD-CON-005 | Sensitive actions have audit trail | MVP | Actor, patient, action, time, device/context, outcome |
| PRD-CON-006 | Support has no default clinical access | MVP | Elevated access is reasoned, time-bound, approved, audited |

### 7.10 Support and Dispute

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-SUP-001 | User can create support ticket | MVP | Categories: account, booking, payment, data, family access |
| PRD-SUP-002 | Family access dispute gets priority flow | MVP | Grant can be suspended without deleting audit |
| PRD-SUP-003 | Payment dispute can be traced | MVP | Support sees minimum financial data, not clinical data |
| PRD-SUP-004 | Clinical concern is routed to provider | MVP | Generic support does not make clinical decision |
| PRD-SUP-005 | User receives ticket number/status | P1 | User does not need to send sensitive data informally |

### 7.11 Provider/Admin Operations

| ID | Requirement | Priority | Acceptance Criteria |
|---|---|---|---|
| PRD-OPS-001 | Provider/fasyankes onboarding and verification | MVP | Operational status and merchant readiness captured |
| PRD-OPS-002 | Service catalog management | MVP | Price, duration, preparation, policy, location |
| PRD-OPS-003 | Schedule and capacity management | MVP | Slots, blackout, cut-off, overbooking rule |
| PRD-OPS-004 | Booking worklist | MVP | Status transitions and action owner visible |
| PRD-OPS-005 | Check-in and completion handling | MVP | QR/manual fallback and audit |
| PRD-OPS-006 | Payment/refund/reconciliation view | MVP | Exceptions visible and traceable |
| PRD-OPS-007 | Role management and segregation of duties | MVP | Finance/support/clinical/admin permissions separated |
| PRD-OPS-008 | Audit/correction queue | MVP | Wrong patient, incident, elevated access tracked |
| PRD-OPS-009 | Provider-authorized record publishing | P1 | Only authorized role can publish provider-linked records |

---

## 8. State Machines

### 8.1 Booking State

| State | Meaning | Exit |
|---|---|---|
| Draft | User has not selected final slot/service | Slot selected |
| Slot Held | Slot temporarily reserved | Payment required or confirm booking |
| Awaiting Payment | Invoice created, payment not verified | Paid, expired, cancelled |
| Confirmed | Booking accepted and scheduled | Check-in, reschedule, cancel |
| Checked In | Patient arrived/verified | Complete, no-show correction |
| Completed | Visit completed | Link encounter/summary if P1 |
| Cancelled | Cancelled by user/provider | Refund/reschedule if applicable |
| No-show | Patient did not attend | Operational handling |
| Expired | Hold/payment window expired | New booking required |

### 8.2 Payment State

| State | Meaning |
|---|---|
| Invoice Created | Order exists |
| Gateway Pending | Payment started but not verified |
| Paid | Server webhook verified payment |
| Failed | Gateway/server confirms failure |
| Refund Requested | Refund process initiated |
| Refund Processing | Waiting gateway/finance |
| Refunded | Refund completed |
| Exception | Requires reconciliation |

### 8.3 Access Grant State

| State | Meaning |
|---|---|
| Pending Invite | Invite sent, no access |
| Declined | Invite rejected, no access |
| Active | Scope is granted |
| Reduced | Scope changed to narrower access |
| Expired | Expiry reached |
| Revoked | Patient/guardian revoked access |
| Suspended | Support/legal dispute freeze |

---

## 9. Data and Permission Rules

### 9.1 Must-Have Rules

- Patient profile is not the same as user account.
- Household/care circle is not consent.
- Payer is not automatically clinical viewer.
- User-generated health data is not provider-verified.
- Provider-verified record cannot be edited directly by patient.
- Diagnosis/condition cannot be inferred by the app.
- Client redirect cannot mark payment as paid.
- Support cannot view clinical data by default.
- Lock-screen notification hides sensitive content by default.
- Analytics must not include NIK, KK, clinical free text, diagnosis, prescriptions, or file content.

### 9.2 Minimum Role Permissions

| Capability | Patient | Guardian | Delegated Caregiver | Payer Only | Provider | Faskes Admin | Support |
|---|---:|---:|---:|---:|---:|---:|---:|
| Edit demographic | Own | Grant | Grant | No | Limited | Limited | Elevated |
| Create appointment | Own | Grant | Grant | Limited | Operational | Operational | Elevated |
| Pay invoice | Own | Grant | Grant | Yes | No | Operational | Elevated |
| View invoice | Own | Grant | Limited | Minimum | No | Operational | Elevated |
| View clinical record | Own | Grant | Grant only | No | Authorized | No | Elevated only |
| Publish provider record | No | No | No | No | Authorized | Authorized | No |
| Grant family access | Own | Guardian basis | No | No | No | No | No |
| Suspend access dispute | No | No | No | No | No | No | Approved support |

---

## 10. Metrics

### 10.1 North Star

**Monthly Completed Care Actions (MCCA):** number of meaningful care actions completed per month, such as completed visit, completed follow-up, verified vaccination record, reviewed result, or active reminder regimen.

### 10.2 Funnel Metrics

- Registration completion.
- Self-profile completion.
- Household created → invite sent → invite accepted.
- Search → provider detail → slot selected → booking confirmed.
- Awaiting payment → paid → attended/completed.
- Reminder sent → opened → action completed.
- First completed care action → 30/90-day retained household.

### 10.3 Guardrail Metrics

- Unauthorized access report rate.
- Access grant dispute rate.
- Duplicate/mismatched patient incident rate.
- Payment mismatch rate.
- Refund SLA breach.
- Provider cancellation/no-show rate.
- Notification opt-out/complaint rate.
- Clinical data correction request and resolution time.
- Support contact per completed booking.
- Crash-free session and critical API failure rate.

---

## 11. Non-Functional Requirements

### 11.1 Security and Privacy

- Encryption in transit and at rest for sensitive data.
- Server-side object authorization on every protected resource.
- Cross-profile authorization tests for family/caregiver cases.
- Secrets only in secure backend/server environment.
- Tamper-evident audit log for sensitive actions.
- File upload type/size validation, malware scan, and temporary serving URLs.
- Threat model for family linking, recovery, support impersonation, QR, and deep links.

### 11.2 Reliability and Performance Targets

| Area | Initial Target |
|---|---|
| Core booking availability | 99.9% monthly target for pilot |
| API read p95 | <= 2 seconds |
| Search result p95 | <= 3 seconds |
| Payment callback processing | <= 60 seconds for majority webhook |
| Reminder dispatch processing | >= 99% jobs processed within window |

### 11.3 Accessibility

- WCAG 2.2 AA target for relevant interfaces.
- Font scaling and screen reader labels.
- Sufficient contrast and touch target size.
- Status must not rely only on color.
- Low-literacy caregiver flows use plain language.
- Bahasa Indonesia MVP copy should avoid unexplained clinical jargon.

---

## 12. Release Plan

### R0 Discovery and Policy

Outcome: product assumptions and governance are validated.

Included:

- User research.
- Legal/clinical policy.
- Consent/access model.
- UX prototype.
- Pilot provider agreement.

Excluded:

- Production app.

### R1 Self Care Access

Outcome: self-managed adult can book and pay.

Included:

- Auth.
- Self profile.
- Directory.
- Booking.
- Payment.
- Reminder.
- Provider ops minimum.

Excluded:

- Family clinical access.
- Full record timeline.

### R2 Family Coordination

Outcome: family can help safely.

Included:

- Dependent profile.
- Adult invite.
- Appointment/payment grant.
- Revoke.
- Audit.
- Dispute.

Excluded:

- Full shared clinical record by default.

### R3 Health Timeline

Outcome: basic health timeline is useful and safe.

Included:

- Document upload.
- Source label.
- Wrong-record report.
- Provider-linked summary only if authorized.

Excluded:

- Broad SATUSEHAT sync.

### R4 Care Continuity

Outcome: reminders and longitudinal care begin.

Included:

- Medication reminder.
- Preventive care.
- Measurement.
- Pediatric growth chart.
- Care plan concept.

Excluded:

- AI diagnosis.

---

## 13. UAT Scenarios

### 13.1 Identity and Family

- UAT-001: Adult patient creates self profile and cannot see another user's data.
- UAT-002: Guardian adds dependent and invites another adult with selected scope.
- UAT-003: Adult invite is declined and inviter gets no data.
- UAT-004: Patient grants caregiver appointment-only access; caregiver cannot see diagnosis.
- UAT-005: Patient revokes access; caregiver with active session cannot open protected data.
- UAT-006: Duplicate patient identity is flagged and held for review.
- UAT-007: Payer pays for another patient without gaining clinical access.

### 13.2 Booking and Payment

- UAT-008: Two users select the last slot; only one booking is finalized.
- UAT-009: Client returns from gateway but webhook is absent; status remains pending.
- UAT-010: Duplicate webhook does not duplicate payment/booking.
- UAT-011: Provider cancels; patient sees refund/reschedule options.
- UAT-012: Reschedule cancels old reminders and creates new reminders.
- UAT-013: Expired QR has manual fallback and audit.

### 13.3 Records and Privacy

- UAT-014: User-uploaded lab result is labeled non-verified.
- UAT-015: Patient cannot edit provider diagnosis; correction request is available.
- UAT-016: Wrong-patient document is reported, hidden, and investigated.
- UAT-017: Notification deep link fails when session is invalid or grant revoked.
- UAT-018: Support requires elevated access with reason, expiry, approval, and audit.
- UAT-019: Export only includes selected patient and date range.
- UAT-020: Lock-screen notification hides sensitive condition/medicine details.

---

## 14. Go/No-Go Criteria

### 14.1 Go if All Are True

- Legal/privacy and clinical safety sign-off are complete.
- Pilot fasyankes, merchant, refund, and support ownership are clear.
- No unresolved critical/high security finding.
- Cross-profile authorization tests pass for all critical cases.
- Payment idempotency and reconciliation tests pass.
- Consent/access audit can be reconstructed end-to-end.
- Wrong-patient containment flow is ready.
- Accessibility has no blocker on critical flows.
- Support SLA and escalation path are ready.
- Analytics/logging do not contain prohibited health identifiers or clinical free text.

### 14.2 No-Go if Any Are True

- Family access depends only on household membership.
- User-generated and provider-verified data are visually/functionally indistinguishable.
- Client can mark payment as paid.
- Wrong-patient data has no containment flow.
- Refund, clinical escalation, or security incident owner is missing.
- External production integration is used without proper agreement/authorization.

---

## 15. Open Decisions

### P0 Before Engineering

1. Who is the primary customer: patient, family, fasyankes, employer, or B2B2C mix?
2. What is the launch wedge: outpatient booking, chronic care, family organizer, or home care?
3. Is Seribasa only a platform operator or also a healthcare service operator?
4. Is health record a user-controlled vault, provider copy, or part of official RME?
5. Which pilot provider and region?
6. Is household based on official KK or flexible care circle? Recommendation: flexible care circle.
7. What is default family grant? Recommendation: appointment + payment only.
8. How is guardian/dependent proof verified?
9. Who is merchant of record?
10. Who owns refund/chargeback liability?

### P1 Before Final MVP Backlog

1. Is guest browsing allowed?
2. Can profile without NIK book certain services?
3. Is QR check-in mandatory or optional by provider?
4. Which document/record types are in MVP?
5. Which notification channels are transactional vs promotional?
6. Is Stripe relevant for Indonesia launch or should Midtrans-like local gateway be primary?
7. Is MVP Bahasa Indonesia only?
8. What are support SLAs for account takeover, access dispute, and wrong-patient data?
9. Is telemedicine/home care included or delayed?
10. Who owns SATUSEHAT integration path?

---

## 16. Implementation Readiness

Engineering should not begin until these are ready:

- Business model and launch wedge are approved.
- Pilot provider and service types are confirmed.
- Persona and critical journeys are validated.
- Account/patient/household policy is final.
- Consent/access grant matrix is final.
- Booking/payment/refund status machines are final.
- Record scope and source-of-truth policy are final.
- Legal/privacy/clinical sign-off exists.
- UAT scenarios and go/no-go controls are accepted.
- Backlog has owners and acceptance criteria.

---

## 17. Traceability

| PRD Area | BRD Source |
|---|---|
| Product goals | BRD sections 2, 4, 18 |
| Persona | BRD section 6 |
| Account/patient/household model | BRD section 7 |
| MVP/P1/P2 scope | BRD section 9 |
| Functional requirements | BRD section 10 |
| Business rules | BRD section 11 |
| Critical flows | BRD section 12 |
| Permission/data minimization | BRD sections 13-14 |
| NFR and trust | BRD section 15 |
| Compliance assumptions | BRD section 16 |
| Release/UAT/go-no-go | BRD sections 21-24 |

---

## Appendix A. References

- BRD: `docs/plans/2026-09-30-e-patient-business-requirements.md`
- Figma design: https://www.figma.com/design/cmjvwgZ153ZAFlQ3cU4QWz
- UU Nomor 27 Tahun 2022 tentang Pelindungan Data Pribadi: https://peraturan.bpk.go.id/Home/Download/224884/UU%20Nomor%2027%20Tahun%202022.pdf
- Permenkes Nomor 24 Tahun 2022 tentang Rekam Medis: https://peraturan.bpk.go.id/Download/301563/Permenkes%20Nomor%2024%20Tahun%202022.pdf
- SATUSEHAT interoperability docs: https://satusehat.kemkes.go.id/platform/docs/id/interoperability/

