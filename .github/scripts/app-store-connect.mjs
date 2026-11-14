import { existsSync, mkdirSync, writeFileSync, rmSync, chmodSync, appendFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { homedir } from 'node:os';
import { fileURLToPath } from 'node:url';

/**
 * Validate and normalize App Store Connect API credentials.
 * @param {{ keyId?: string, issuerId?: string, privateKey?: string }} creds
 * @returns {{ keyId: string, issuerId: string, privateKey: string }}
 */
export function normalizeAppStoreConnectKey({ keyId, issuerId, privateKey } = {}) {
  const cleanKeyId = (keyId || '').trim();
  if (!/^[A-Za-z0-9]{10}$/.test(cleanKeyId)) {
    throw new Error('APP_STORE_CONNECT_KEY_ID must be a 10-character alphanumeric string (e.g. 2X9R4HXF34)');
  }

  const cleanIssuerId = (issuerId || '').trim().toLowerCase();
  if (!/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/.test(cleanIssuerId)) {
    throw new Error('APP_STORE_CONNECT_ISSUER_ID must be a valid UUID (e.g. 57246542-96fe-1a63-e053-0824d0110072)');
  }

  if (!privateKey || typeof privateKey !== 'string' || !privateKey.trim()) {
    throw new Error('APP_STORE_CONNECT_PRIVATE_KEY is missing');
  }

  let cleanKey = privateKey.trim();
  if (!cleanKey.includes('BEGIN PRIVATE KEY')) {
    // Attempt base64 decode if the raw value doesn't have the PEM header
    try {
      const decoded = Buffer.from(cleanKey.replace(/\s/g, ''), 'base64').toString('utf8');
      if (decoded.includes('BEGIN PRIVATE KEY')) {
        cleanKey = decoded.trim();
      }
    } catch {
      // Fall through to validation failure below
    }
  }

  if (!cleanKey.includes('-----BEGIN PRIVATE KEY-----') || !cleanKey.includes('-----END PRIVATE KEY-----')) {
    throw new Error('APP_STORE_CONNECT_PRIVATE_KEY must contain a valid PEM PKCS#8 private key with BEGIN and END markers');
  }

  return {
    keyId: cleanKeyId,
    issuerId: cleanIssuerId,
    privateKey: cleanKey,
  };
}

/**
 * CLI helper to install or cleanup App Store Connect API keys for GitHub Actions runners.
 */
export function runAuthKey(action, env = process.env) {
  if (env.GITHUB_ACTIONS !== 'true' || !env.RUNNER_TEMP) {
    throw new Error('App Store Connect key helper is restricted to GitHub-hosted CI');
  }

  const home = env.HOME || homedir();
  const runnerKeyPath = join(env.RUNNER_TEMP, 'appstore_connect_key.p8');
  const ascDir = join(home, '.appstoreconnect', 'private_keys');

  if (action === 'cleanup') {
    if (existsSync(runnerKeyPath)) {
      rmSync(runnerKeyPath, { force: true });
    }
    // Also remove from ~/.appstoreconnect/private_keys if created
    const keyId = (env.APP_STORE_CONNECT_KEY_ID || '').trim();
    if (keyId && /^[A-Za-z0-9]{10}$/.test(keyId)) {
      const standardPath = join(ascDir, `AuthKey_${keyId}.p8`);
      if (existsSync(standardPath)) {
        rmSync(standardPath, { force: true });
      }
    }
    console.info('[app-store-connect] Temporary API key files removed.');
    return;
  }

  if (action === 'install') {
    const validated = normalizeAppStoreConnectKey({
      keyId: env.APP_STORE_CONNECT_KEY_ID,
      issuerId: env.APP_STORE_CONNECT_ISSUER_ID,
      privateKey: env.APP_STORE_CONNECT_PRIVATE_KEY,
    });

    // Write to RUNNER_TEMP with 0600 mode
    writeFileSync(runnerKeyPath, validated.privateKey, { mode: 0o600 });
    chmodSync(runnerKeyPath, 0o600);

    // Also place in ~/.appstoreconnect/private_keys/AuthKey_<KEY_ID>.p8 for xcrun altool / transporter
    mkdirSync(ascDir, { recursive: true, mode: 0o700 });
    const standardPath = join(ascDir, `AuthKey_${validated.keyId}.p8`);
    writeFileSync(standardPath, validated.privateKey, { mode: 0o600 });
    chmodSync(standardPath, 0o600);

    // Export validated PEM text to GITHUB_ENV for actions that consume multiline string input
    if (env.GITHUB_ENV) {
      appendFileSync(env.GITHUB_ENV, `APP_STORE_CONNECT_PEM<<ASC_EOF\n${validated.privateKey.trim()}\nASC_EOF\n`);
    }

    console.info(`[app-store-connect] API key AuthKey_${validated.keyId}.p8 configured successfully.`);
    return;
  }

  throw new Error('Usage: app-store-connect.mjs install | cleanup');
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try {
    runAuthKey(process.argv[2]);
  } catch (error) {
    console.error(`[app-store-connect] Error: ${error.message}`);
    process.exitCode = 1;
  }
}
