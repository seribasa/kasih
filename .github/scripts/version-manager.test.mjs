import test from 'node:test';
import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  formatDate,
  generateBuildNumber,
  generateVersion,
  parsePubspecVersion,
  replacePubspecVersion,
  validateVersion,
} from './version-manager.mjs';

const script = fileURLToPath(new URL('./version-manager.mjs', import.meta.url));

function run(args = [], env = {}, cwd = process.cwd()) {
  return spawnSync(process.execPath, [script, ...args], { env: { ...process.env, ...env }, cwd, encoding: 'utf8' });
}

test('formatDate formats YYYY.MM.DD with padding', () => {
  const d = new Date(Date.UTC(2026, 0, 5, 12, 0, 0));
  assert.equal(formatDate(d, true), '2026.01.05');

  const d2 = new Date(Date.UTC(2026, 10, 8, 8, 30, 0));
  assert.equal(formatDate(d2, true), '2026.11.08');
});

test('generateBuildNumber generates positive integer <= 2100000000', () => {
  const d = new Date(Date.UTC(2026, 10, 8, 8, 0, 0));
  const num = generateBuildNumber(d);
  assert.equal(typeof num, 'number');
  assert.ok(num > 0);
  assert.ok(num <= 2100000000);
});

test('generateVersion supports optional patch and timestamp', () => {
  const d = new Date(Date.UTC(2026, 10, 8, 0, 0, 0));
  const expectedSeconds = Math.floor(d.getTime() / 1000);

  const v1 = generateVersion({ date: d, utc: true });
  assert.equal(v1.versionName, '2026.11.08');
  assert.equal(v1.buildNumber, expectedSeconds);
  assert.equal(v1.fullVersion, `2026.11.08+${expectedSeconds}`);

  const v2 = generateVersion({ date: d, patch: 2, utc: true });
  assert.equal(v2.versionName, '2026.11.08.2');
  assert.equal(v2.buildNumber, expectedSeconds);
  assert.equal(v2.fullVersion, `2026.11.08.2+${expectedSeconds}`);
});

test('generateVersion supports custom overrides', () => {
  const v = generateVersion({ customVersionName: '2026.11.08.special', customBuildNumber: '999999' });
  assert.equal(v.versionName, '2026.11.08.special');
  assert.equal(v.buildNumber, 999999);
  assert.equal(v.fullVersion, '2026.11.08.special+999999');
});

test('parsePubspecVersion extracts version and build number', () => {
  const sample = `name: kasih\nversion: 2026.11.08+1794099220\nenvironment:\n  sdk: ">=3.7.0 <4.0.0"\n`;
  const parsed = parsePubspecVersion(sample);
  assert.equal(parsed.versionName, '2026.11.08');
  assert.equal(parsed.buildNumber, 1794099220);
  assert.equal(parsed.fullVersion, '2026.11.08+1794099220');
});

test('replacePubspecVersion updates version in place', () => {
  const original = `name: kasih\n# comment\nversion: 2.1.1+10\ndescription: test\n`;
  const updated = replacePubspecVersion(original, '2026.11.08+1794099220');
  assert.equal(updated, `name: kasih\n# comment\nversion: 2026.11.08+1794099220\ndescription: test\n`);
});

test('validateVersion accepts valid CalVer and rejects invalid inputs', () => {
  assert.doesNotThrow(() => validateVersion('2026.11.08+1794099220'));
  assert.doesNotThrow(() => validateVersion('2026.11.08.1+1794099220'));

  // Invalid formats
  assert.throws(() => validateVersion('2.1.1'));
  assert.throws(() => validateVersion('invalid'));
  assert.throws(() => validateVersion('2026.1.1+100')); // Needs 2-digit MM and DD
  assert.throws(() => validateVersion('2026.11.08+notanumber'));
  assert.throws(() => validateVersion('2026.11.08+2500000000')); // Exceeds Android 2.1B
});

test('CLI --generate outputs CalVer version string', () => {
  const res = run(['--generate']);
  assert.equal(res.status, 0);
  assert.match(res.stdout.trim(), /^\d{4}\.\d{2}\.\d{2}\+\d{10}$/);
});

test('CLI --bump updates custom pubspec.yaml file and --check verifies it', () => {
  const tempDir = mkdtempSync(join(tmpdir(), 'version-test-'));
  const tempPubspec = join(tempDir, 'pubspec.yaml');
  try {
    writeFileSync(tempPubspec, 'name: test\nversion: 1.0.0+1\n', 'utf8');

    const bumpRes = run(['--bump', '--path', tempPubspec]);
    assert.equal(bumpRes.status, 0);

    const content = readFileSync(tempPubspec, 'utf8');
    assert.match(content, /^version:\s*\d{4}\.\d{2}\.\d{2}\+\d{10}$/m);

    const checkRes = run(['--check', '--path', tempPubspec]);
    assert.equal(checkRes.status, 0);
    assert.match(checkRes.stdout, /is valid/);
  } finally {
    rmSync(tempDir, { recursive: true, force: true });
  }
});

test('CLI --ci outputs to GITHUB_OUTPUT and GITHUB_ENV', () => {
  const tempDir = mkdtempSync(join(tmpdir(), 'version-ci-test-'));
  const tempPubspec = join(tempDir, 'pubspec.yaml');
  const tempOutput = join(tempDir, 'github_output');
  const tempEnv = join(tempDir, 'github_env');

  try {
    writeFileSync(tempPubspec, 'name: test\nversion: 2026.11.08+1794099220\n', 'utf8');
    writeFileSync(tempOutput, '', 'utf8');
    writeFileSync(tempEnv, '', 'utf8');

    const res = run(
      ['--bump', '--ci', '--path', tempPubspec],
      { GITHUB_OUTPUT: tempOutput, GITHUB_ENV: tempEnv }
    );
    assert.equal(res.status, 0);

    const outContent = readFileSync(tempOutput, 'utf8');
    assert.match(outContent, /version_name=\d{4}\.\d{2}\.\d{2}/);
    assert.match(outContent, /build_number=\d{10}/);
    assert.match(outContent, /full_version=\d{4}\.\d{2}\.\d{2}\+\d{10}/);

    const envContent = readFileSync(tempEnv, 'utf8');
    assert.match(envContent, /APP_VERSION_NAME=\d{4}\.\d{2}\.\d{2}/);
    assert.match(envContent, /APP_BUILD_NUMBER=\d{10}/);
  } finally {
    rmSync(tempDir, { recursive: true, force: true });
  }
});
