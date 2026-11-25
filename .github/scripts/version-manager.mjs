#!/usr/bin/env node
import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { join, dirname } from 'node:path';

export const ANDROID_MAX_VERSION_CODE = 2100000000;

/**
 * Format a Date object into CalVer YYYY.MM.DD (UTC or local).
 * @param {Date} date
 * @param {boolean} utc
 * @returns {string}
 */
export function formatDate(date = new Date(), utc = true) {
  const year = utc ? date.getUTCFullYear() : date.getFullYear();
  const month = String((utc ? date.getUTCMonth() : date.getMonth()) + 1).padStart(2, '0');
  const day = String(utc ? date.getUTCDate() : date.getDate()).padStart(2, '0');
  return `${year}.${month}.${day}`;
}

/**
 * Generate a build number from Unix epoch seconds.
 * Guaranteed to be positive and validated against Android 2.1B ceiling.
 * @param {Date} date
 * @returns {number}
 */
export function generateBuildNumber(date = new Date()) {
  const seconds = Math.floor(date.getTime() / 1000);
  if (seconds <= 0 || seconds > ANDROID_MAX_VERSION_CODE) {
    throw new Error(`Build number ${seconds} is out of safe Android versionCode bounds (1..${ANDROID_MAX_VERSION_CODE})`);
  }
  return seconds;
}

/**
 * Generate a full version string combining CalVer date and Unix timestamp.
 * @param {{ date?: Date, patch?: number|string, utc?: boolean, customVersionName?: string, customBuildNumber?: number|string }} options
 * @returns {{ versionName: string, buildNumber: number, fullVersion: string }}
 */
export function generateVersion({
  date = new Date(),
  patch = null,
  utc = true,
  customVersionName = null,
  customBuildNumber = null,
} = {}) {
  let versionName;
  if (customVersionName && customVersionName.trim() !== '') {
    versionName = customVersionName.trim();
  } else {
    const baseDate = formatDate(date, utc);
    versionName = patch != null && patch !== '' ? `${baseDate}.${patch}` : baseDate;
  }

  let buildNumber;
  if (customBuildNumber != null && String(customBuildNumber).trim() !== '') {
    const parsed = Number.parseInt(String(customBuildNumber).trim(), 10);
    if (Number.isNaN(parsed) || parsed <= 0 || parsed > ANDROID_MAX_VERSION_CODE) {
      throw new Error(`Custom build number "${customBuildNumber}" must be an integer between 1 and ${ANDROID_MAX_VERSION_CODE}`);
    }
    buildNumber = parsed;
  } else {
    buildNumber = generateBuildNumber(date);
  }

  return {
    versionName,
    buildNumber,
    fullVersion: `${versionName}+${buildNumber}`,
  };
}

/**
 * Read the version line from pubspec.yaml.
 * @param {string} content
 * @returns {{ versionName: string, buildNumber: number, fullVersion: string }}
 */
export function parsePubspecVersion(content) {
  const match = content.match(/^version:\s*([^\s#]+)/m);
  if (!match) {
    throw new Error('version field not found in pubspec.yaml');
  }
  const fullVersion = match[1];
  const parts = fullVersion.split('+');
  const versionName = parts[0];
  const buildNumber = parts.length > 1 ? Number.parseInt(parts[1], 10) : 1;
  return { versionName, buildNumber, fullVersion };
}

/**
 * Replace the version field in pubspec.yaml content.
 * @param {string} content
 * @param {string} newVersion
 * @returns {string}
 */
export function replacePubspecVersion(content, newVersion) {
  if (!/^version:\s*[^\s#]+/m.test(content)) {
    throw new Error('version field not found in pubspec.yaml');
  }
  return content.replace(/^version:\s*[^\s#]+/m, `version: ${newVersion}`);
}

/**
 * Validate that a version string complies with date-based versioning and Android bounds.
 * @param {string} fullVersion
 */
export function validateVersion(fullVersion) {
  const parts = fullVersion.split('+');
  if (parts.length !== 2) {
    throw new Error(`Invalid version format "${fullVersion}". Expected format: <versionName>+<buildNumber> (e.g. 2026.11.08+1794099220)`);
  }
  const [versionName, buildNumberStr] = parts;
  if (!/^\d{4}\.\d{2}\.\d{2}(\.\d+)?$/.test(versionName)) {
    throw new Error(`Version name "${versionName}" does not match CalVer date pattern YYYY.MM.DD or YYYY.MM.DD.<patch>`);
  }
  const buildNumber = Number.parseInt(buildNumberStr, 10);
  if (Number.isNaN(buildNumber) || buildNumber <= 0 || buildNumber > ANDROID_MAX_VERSION_CODE) {
    throw new Error(`Build number "${buildNumberStr}" must be an integer between 1 and ${ANDROID_MAX_VERSION_CODE}`);
  }
  return { versionName, buildNumber, fullVersion };
}

// CLI handler if executed directly
const isDirectExecution = process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1];

if (isDirectExecution) {
  const args = process.argv.slice(2);
  const defaultPubspecPath = join(dirname(dirname(dirname(fileURLToPath(import.meta.url)))), 'pubspec.yaml');

  let command = '--get';
  let targetVersion = null;
  let customVersionName = process.env.CUSTOM_VERSION_NAME || null;
  let customBuildNumber = process.env.CUSTOM_BUILD_NUMBER || null;
  let pubspecPath = defaultPubspecPath;
  let emitCi = false;

  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (arg === '--get' || arg === '--generate' || arg === '--bump' || arg === '--check') {
      command = arg;
    } else if (arg === '--set') {
      command = '--set';
      targetVersion = args[++i];
    } else if (arg === '--version-name') {
      customVersionName = args[++i];
    } else if (arg === '--build-number') {
      customBuildNumber = args[++i];
    } else if (arg === '--ci') {
      emitCi = true;
    } else if (arg === '--path') {
      pubspecPath = args[++i];
    } else if (arg === '--help' || arg === '-h') {
      console.log(`
Kasih App Version Manager (CalVer Date + Timestamp Build Number)

Usage:
  node .github/scripts/version-manager.mjs [options]

Options:
  --get                     Print the current version from pubspec.yaml (default)
  --generate                Generate and print a new CalVer + timestamp version without modifying files
  --bump                    Generate a new CalVer + timestamp version and update pubspec.yaml
  --set <version>           Set a specific version (e.g. 2026.11.08+1794099220) in pubspec.yaml
  --check                   Verify current pubspec.yaml follows CalVer and integer constraints
  --version-name <name>     Override version name (defaults to YYYY.MM.DD)
  --build-number <number>   Override build number (defaults to Unix timestamp)
  --ci                      Export VERSION_NAME, BUILD_NUMBER, and FULL_VERSION to $GITHUB_OUTPUT / $GITHUB_ENV
  --path <path>             Custom path to pubspec.yaml (default: root pubspec.yaml)
`);
      process.exit(0);
    }
  }

  try {
    let result;
    if (command === '--get') {
      const content = readFileSync(pubspecPath, 'utf8');
      result = parsePubspecVersion(content);
      console.log(result.fullVersion);
    } else if (command === '--generate') {
      result = generateVersion({ customVersionName, customBuildNumber });
      console.log(result.fullVersion);
    } else if (command === '--bump') {
      result = generateVersion({ customVersionName, customBuildNumber });
      const content = readFileSync(pubspecPath, 'utf8');
      const updated = replacePubspecVersion(content, result.fullVersion);
      writeFileSync(pubspecPath, updated, 'utf8');
      console.log(`Bumped version in ${pubspecPath} to ${result.fullVersion}`);
    } else if (command === '--set') {
      if (!targetVersion) {
        throw new Error('Missing version argument for --set');
      }
      result = validateVersion(targetVersion);
      const content = readFileSync(pubspecPath, 'utf8');
      const updated = replacePubspecVersion(content, result.fullVersion);
      writeFileSync(pubspecPath, updated, 'utf8');
      console.log(`Set version in ${pubspecPath} to ${result.fullVersion}`);
    } else if (command === '--check') {
      const content = readFileSync(pubspecPath, 'utf8');
      const parsed = parsePubspecVersion(content);
      result = validateVersion(parsed.fullVersion);
      console.log(`Version "${parsed.fullVersion}" is valid.`);
    }

    if (emitCi && result) {
      if (process.env.GITHUB_OUTPUT) {
        const outputData = `version_name=${result.versionName}\nbuild_number=${result.buildNumber}\nfull_version=${result.fullVersion}\n`;
        writeFileSync(process.env.GITHUB_OUTPUT, outputData, { flag: 'a' });
      }
      if (process.env.GITHUB_ENV) {
        const envData = `APP_VERSION_NAME=${result.versionName}\nAPP_BUILD_NUMBER=${result.buildNumber}\nAPP_FULL_VERSION=${result.fullVersion}\n`;
        writeFileSync(process.env.GITHUB_ENV, envData, { flag: 'a' });
      }
    }
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
}
