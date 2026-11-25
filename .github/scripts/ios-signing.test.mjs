import test from 'node:test';
import assert from 'node:assert/strict';
import { profileSettings, runSigning } from './ios-signing.mjs';

const options = { team: 'ABCDE12345', bundle: 'com.example.epatient', method: 'debugging' };
const fixture = () => ({
  UUID: '12345678-abcd-1234-abcd-123456789012',
  TeamIdentifier: [options.team],
  ExpirationDate: '2099-01-01T00:00:00Z',
  Entitlements: { 'application-identifier': `${options.team}.${options.bundle}`, 'get-task-allow': true },
  ProvisionedDevices: ['test-device'],
});
test('generates manual export without automatic upload', () => {
  const output = profileSettings(fixture(), options);
  assert.match(output, /<key>destination<\/key><string>export<\/string>/);
  assert.match(output, /<key>com.example.epatient<\/key>/);
  assert.match(output, /<string>debugging<\/string>/);
  assert.doesNotMatch(output, /test-device/);
});
test('rejects invalid Apple identifiers and teams', () => {
  assert.throws(() => profileSettings(fixture(), { ...options, bundle: 'com.example.e_patient' }), /bundle identifier/);
  assert.throws(() => profileSettings(fixture(), { ...options, team: 'bad\nteam' }), /team identifier/);
});
test('rejects expired, missing-expiration and mismatched profiles', () => {
  for (const date of ['2020-01-01', undefined]) {
    assert.throws(() => profileSettings({ ...fixture(), ExpirationDate: date }, options), /expired/);
  }
  assert.throws(() => profileSettings(fixture(), { ...options, bundle: 'com.example.other' }), /does not match/);
  assert.throws(() => profileSettings({ ...fixture(), UUID: '../outside' }, options), /UUID/);
});
test('supports matching ad hoc and App Store profiles, rejects mismatched methods', () => {
  const profile = fixture();
  profile.Entitlements['get-task-allow'] = false;
  assert.match(profileSettings(profile, { ...options, method: 'release-testing' }), /release-testing/);
  assert.throws(() => profileSettings(profile, options), /export method/);
  assert.throws(() => profileSettings(profile, { ...options, method: 'app-store-connect' }), /export method/);
  delete profile.ProvisionedDevices;
  assert.match(profileSettings(profile, { ...options, method: 'app-store-connect' }), /app-store-connect/);
  profile.ProvisionsAllDevices = true;
  assert.throws(() => profileSettings(profile, { ...options, method: 'app-store-connect' }), /export method/);
  assert.throws(() => profileSettings(profile, { ...options, method: 'upload' }), /Unsupported/);
});
test('never installs signing credentials on a local workstation', () => {
  assert.throws(() => runSigning('install', {}), /restricted/);
  assert.throws(() => runSigning('cleanup', {}), /restricted/);
});
