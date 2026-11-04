import { execFileSync } from 'node:child_process';
import { randomBytes } from 'node:crypto';
import { existsSync, mkdirSync, readFileSync, writeFileSync, rmSync, appendFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const xml = value => String(value).replace(/[<>&"']/g, c => ({ '<': '&lt;', '>': '&gt;', '&': '&amp;', '"': '&quot;', "'": '&apos;' })[c]);

export function profileSettings(profile, { team, bundle, method }, now = new Date()) {
  if (!/^[A-Z0-9]{10}$/.test(team || '')) throw new Error('Set IOS_TEAM_ID to the Apple team identifier');
  if (!/^[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$/.test(bundle || '')) throw new Error('Set IOS_BUNDLE_ID to a valid explicit Apple bundle identifier (no underscore)');
  if (!['debugging', 'release-testing', 'app-store-connect'].includes(method)) throw new Error('Unsupported export method');
  if (!/^[A-Fa-f0-9-]{36}$/.test(profile.UUID || '')) throw new Error('Invalid provisioning profile UUID');
  const expiry = new Date(profile.ExpirationDate);
  if (!Number.isFinite(expiry.getTime()) || expiry <= now) throw new Error('Provisioning profile expired or expiration missing');
  const entitlements = profile.Entitlements || {};
  if (!profile.TeamIdentifier?.includes(team) || entitlements['application-identifier'] !== `${team}.${bundle}`) {
    throw new Error('Provisioning profile does not match team and explicit bundle identifier');
  }
  const debug = entitlements['get-task-allow'] === true;
  const devices = Array.isArray(profile.ProvisionedDevices) && profile.ProvisionedDevices.length > 0;
  if (profile.ProvisionsAllDevices || (method === 'debugging' ? !debug || !devices : debug || (method === 'release-testing' ? !devices : devices))) {
    throw new Error('Provisioning profile does not match export method');
  }
  return `<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>method</key><string>${xml(method)}</string>
<key>teamID</key><string>${xml(team)}</string>
<key>signingStyle</key><string>manual</string>
<key>destination</key><string>export</string>
<key>manageAppVersionAndBuildNumber</key><false/>
<key>provisioningProfiles</key><dict><key>${xml(bundle)}</key><string>${xml(profile.UUID)}</string></dict>
</dict></plist>\n`;
}

export function runSigning(action, env = process.env) {
  if (env.GITHUB_ACTIONS !== 'true' || !env.RUNNER_TEMP || !env.GITHUB_ENV) throw new Error('Signing helper is restricted to GitHub-hosted CI');
  const directory = join(env.RUNNER_TEMP, 'e-patient-ios-signing');
  const keychain = join(directory, 'build.keychain-db');
  const profileRecord = join(directory, 'profile-path');
  const log = message => console.info(`[ios-signing] ${message}`);
  const security = (args, operation) => {
    try {
      return execFileSync('security', args, { stdio: ['ignore', 'pipe', 'pipe'] });
    } catch {
      throw new Error(`Apple signing operation failed: ${operation}`);
    }
  };
  if (action === 'cleanup') {
    if (!existsSync(directory)) return;
    log('Removing temporary signing material.');
    if (existsSync(keychain)) security(['delete-keychain', keychain], 'keychain cleanup');
    if (existsSync(profileRecord)) {
      const path = readFileSync(profileRecord, 'utf8');
      const profiles = join(env.HOME, 'Library/MobileDevice/Provisioning Profiles');
      if (!path.startsWith(`${profiles}/`) || !/^[A-Fa-f0-9-]{36}\.mobileprovision$/.test(path.slice(profiles.length + 1))) throw new Error('Unsafe profile cleanup path');
      rmSync(path, { force: true });
    }
    rmSync(directory, { recursive: true });
    log('Temporary signing material removed.');
    return;
  }
  if (action !== 'install') throw new Error('Use install or cleanup');
  log('Checking required signing configuration.');
  for (const name of ['IOS_CERTIFICATE_BASE64', 'IOS_CERTIFICATE_PASSWORD', 'IOS_PROVISION_PROFILE_BASE64', 'IOS_TEAM_ID', 'IOS_BUNDLE_ID']) {
    if (!env[name]) throw new Error(`Missing signing configuration: ${name}`);
  }
  mkdirSync(directory, { mode: 0o700 }); // Refuse to overwrite an existing signing directory.
  const decode = (name, path) => {
    const encoded = env[name].replace(/\s/g, '');
    if (!/^[A-Za-z0-9+/]+={0,2}$/.test(encoded) || encoded.length % 4) throw new Error(`Invalid base64 in ${name}`);
    writeFileSync(path, Buffer.from(encoded, 'base64'), { mode: 0o600, flag: 'wx' });
  };
  const certificate = join(directory, 'certificate.p12');
  const provision = join(directory, 'profile.mobileprovision');
  decode('IOS_CERTIFICATE_BASE64', certificate);
  decode('IOS_PROVISION_PROFILE_BASE64', provision);
  log('Decoding and validating the provisioning profile.');
  const plist = security(['cms', '-D', '-i', provision], 'profile decoding');
  const extract = (key, format = 'json', optional = false) => {
    try {
      if (format === 'raw') {
        return execFileSync('plutil', ['-extract', key, 'raw', '-o', '-', '-'], { input: plist, stdio: ['pipe', 'pipe', 'pipe'] }).toString().trim();
      }
      const binary = execFileSync('plutil', ['-extract', key, 'binary1', '-o', '-', '-'], { input: plist, stdio: ['pipe', 'pipe', 'pipe'] });
      const json = execFileSync('plutil', ['-convert', 'json', '-o', '-', '-'], { input: binary, stdio: ['pipe', 'pipe', 'pipe'] }).toString().trim();
      return JSON.parse(json);
    } catch {
      if (!optional) throw new Error(`Could not read required provisioning profile field: ${key}`);
    }
  };
  const profile = {
    UUID: extract('UUID', 'raw'),
    ExpirationDate: extract('ExpirationDate', 'raw'),
    TeamIdentifier: extract('TeamIdentifier'),
    Entitlements: extract('Entitlements'),
    ProvisionedDevices: extract('ProvisionedDevices', 'json', true),
    ProvisionsAllDevices: extract('ProvisionsAllDevices', 'json', true),
  };
  const options = profileSettings(profile, { team: env.IOS_TEAM_ID, bundle: env.IOS_BUNDLE_ID, method: env.IOS_EXPORT_METHOD });
  log('Provisioning profile matches the configured signing requirements.');
  writeFileSync(join(directory, 'ExportOptions.plist'), options, { mode: 0o600 });
  const profiles = join(env.HOME, 'Library/MobileDevice/Provisioning Profiles');
  mkdirSync(profiles, { recursive: true });
  const installed = join(profiles, `${profile.UUID}.mobileprovision`);
  writeFileSync(installed, readFileSync(provision), { mode: 0o600, flag: 'wx' });
  writeFileSync(profileRecord, installed, { mode: 0o600 });
  log('Importing the signing certificate into a temporary keychain.');
  const password = randomBytes(24).toString('hex');
  security(['create-keychain', '-p', password, keychain], 'temporary keychain creation');
  security(['set-keychain-settings', '-lut', '21600', keychain], 'temporary keychain configuration');
  security(['unlock-keychain', '-p', password, keychain], 'temporary keychain unlock');
  security(['import', certificate, '-P', env.IOS_CERTIFICATE_PASSWORD, '-k', keychain, '-T', '/usr/bin/codesign', '-T', '/usr/bin/security'], 'certificate import');
  security(['set-key-partition-list', '-S', 'apple-tool:,apple:,codesign:', '-k', password, keychain], 'keychain access configuration');
  security(['list-keychains', '-d', 'user', '-s', keychain], 'keychain selection');
  const identities = security(['find-identity', '-v', '-p', 'codesigning', keychain], 'signing identity validation').toString();
  const hashes = [...identities.matchAll(/\b([A-F0-9]{40})\b/g)].map(match => match[1]);
  if (hashes.length !== 1) throw new Error('Certificate must contain exactly one valid code signing identity');
  appendFileSync(env.GITHUB_ENV, `IOS_SIGNING_IDENTITY=${hashes[0]}\nIOS_PROFILE_UUID=${profile.UUID}\nIOS_TEAM_ID=${env.IOS_TEAM_ID}\nIOS_BUNDLE_ID=${env.IOS_BUNDLE_ID}\n`);
  log('iOS signing setup completed successfully.');
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  try { runSigning(process.argv[2]); }
  catch (error) {
    // Never print child-process output: security may include credential arguments.
    console.error(error.message);
    process.exitCode = 1;
  }
}
