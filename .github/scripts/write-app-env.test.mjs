import test from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync, statSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const script = fileURLToPath(new URL('./write-app-env.mjs', import.meta.url));
const base = {
  SUPABASE_URL: 'https://project.example.invalid',
  SUPABASE_ANON_KEY: 'test-client-key',
  PAYMENT_URL: 'https://payment.example.invalid',
};

function run(env, args = ['--check'], cwd) {
  return spawnSync(process.execPath, [script, ...args], { env, cwd, encoding: 'utf8' });
}

test('Midtrans defaults work without Stripe key and do not log values', () => {
  const result = run(base);
  assert.equal(result.status, 0);
  assert.ok(!result.stdout.includes(base.SUPABASE_ANON_KEY));
  assert.ok(!result.stdout.includes(base.PAYMENT_URL));
});

test('Stripe requires a publishable key', () => {
  assert.notEqual(run({ ...base, PAYMENT_GATEWAY: 'stripe' }).status, 0);
  assert.equal(run({ ...base, PAYMENT_GATEWAY: 'stripe', STRIPE_PUBLISHABLE_KEY: 'pk_test_dummy', PAYMENT_CURRENCY: 'USD' }).status, 0);
});

test('OAuth callback must match the configured App Link host and root route', () => {
  assert.equal(run({ ...base, AUTH_REDIRECT_URL: 'https://kasih-app.peltops.com/' }).status, 0);
  for (const url of ['https://other.example/', 'http://kasih-app.peltops.com/',
    'https://kasih-app.peltops.com/callback', 'https://kasih-app.peltops.com/?next=other']) {
    assert.notEqual(run({ ...base, AUTH_REDIRECT_URL: url }).status, 0);
  }
});

test('missing config, invalid gateway/currency, HTTP URL, and multiline values fail', () => {
  for (const env of [
    {},
    { ...base, PAYMENT_GATEWAY: 'both' },
    { ...base, PAYMENT_CURRENCY: 'usd' },
    { ...base, PAYMENT_CURRENCY: 'US' },
    { ...base, PAYMENT_URL: 'http://payment.example.invalid' },
    { ...base, SUPABASE_ANON_KEY: 'key\nINJECTED=value' },
  ]) assert.notEqual(run(env).status, 0);
});

test('generated CI asset has seven fields, restricted permissions, and no real config', () => {
  const directory = mkdtempSync(join(tmpdir(), 'e-patient-ci-env-'));
  try {
    const result = run({}, ['--ci'], directory);
    assert.equal(result.status, 0);
    const file = join(directory, '.env');
    const content = readFileSync(file, 'utf8');
    assert.equal(content.trim().split('\n').length, 7);
    assert.ok(content.includes('ci.example.invalid'));
    assert.ok(content.includes('PAYMENT_GATEWAY="midtrans"'));
    assert.ok(content.includes('AUTH_REDIRECT_URL="https://kasih-app.peltops.com/"'));
    assert.equal(statSync(file).mode & 0o777, 0o600);
  } finally {
    rmSync(directory, { recursive: true });
  }
});
