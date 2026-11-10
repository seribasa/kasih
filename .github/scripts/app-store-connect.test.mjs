import test from 'node:test';
import assert from 'node:assert/strict';
import { normalizeAppStoreConnectKey, runAuthKey } from './app-store-connect.mjs';

const samplePem = `-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAoGCCqGSM49AwEHoUQDQgAEAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
-----END PRIVATE KEY-----`;

test('validates and accepts valid PEM format', () => {
  const result = normalizeAppStoreConnectKey({
    keyId: '2X9R4HXF34',
    issuerId: '57246542-96fe-1a63-e053-0824d0110072',
    privateKey: samplePem,
  });

  assert.equal(result.keyId, '2X9R4HXF34');
  assert.equal(result.issuerId, '57246542-96fe-1a63-e053-0824d0110072');
  assert.ok(result.privateKey.includes('-----BEGIN PRIVATE KEY-----'));
});

test('validates and accepts base64-encoded PEM format', () => {
  const base64Key = Buffer.from(samplePem).toString('base64');
  const result = normalizeAppStoreConnectKey({
    keyId: '2X9R4HXF34',
    issuerId: '57246542-96fe-1a63-e053-0824d0110072',
    privateKey: base64Key,
  });

  assert.equal(result.keyId, '2X9R4HXF34');
  assert.ok(result.privateKey.includes('-----BEGIN PRIVATE KEY-----'));
});

test('rejects invalid keyId', () => {
  assert.throws(
    () =>
      normalizeAppStoreConnectKey({
        keyId: 'INVALID_ID_TOO_LONG',
        issuerId: '57246542-96fe-1a63-e053-0824d0110072',
        privateKey: samplePem,
      }),
    /10-character alphanumeric/,
  );

  assert.throws(
    () =>
      normalizeAppStoreConnectKey({
        keyId: '',
        issuerId: '57246542-96fe-1a63-e053-0824d0110072',
        privateKey: samplePem,
      }),
    /10-character alphanumeric/,
  );
});

test('rejects invalid issuerId', () => {
  assert.throws(
    () =>
      normalizeAppStoreConnectKey({
        keyId: '2X9R4HXF34',
        issuerId: 'not-a-uuid',
        privateKey: samplePem,
      }),
    /valid UUID/,
  );
});

test('rejects missing or corrupted privateKey', () => {
  assert.throws(
    () =>
      normalizeAppStoreConnectKey({
        keyId: '2X9R4HXF34',
        issuerId: '57246542-96fe-1a63-e053-0824d0110072',
        privateKey: '',
      }),
    /missing/,
  );

  assert.throws(
    () =>
      normalizeAppStoreConnectKey({
        keyId: '2X9R4HXF34',
        issuerId: '57246542-96fe-1a63-e053-0824d0110072',
        privateKey: 'random-gibberish-without-pem-markers',
      }),
    /PEM PKCS#8 private key/,
  );
});

test('restricts runAuthKey to GitHub-hosted CI', () => {
  assert.throws(() => runAuthKey('install', {}), /restricted/);
  assert.throws(() => runAuthKey('cleanup', {}), /restricted/);
});
