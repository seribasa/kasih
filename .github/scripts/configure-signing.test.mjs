import test, { before, after } from "node:test";
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import {
  mkdtempSync,
  readFileSync,
  rmSync,
  existsSync,
  mkdirSync,
  statSync,
} from "node:fs";
  writeFileSync,
import { join } from "node:path";
import { tmpdir } from "node:os";
import { configureSigning } from "./configure-signing.mjs";

let fixture;
let secrets;
before(() => {
  fixture = mkdtempSync(join(tmpdir(), "kasih-signing-fixture-"));
  const keystore = join(fixture, "test.jks");
  const env = {
    ...process.env,
    DEBUG_KEYSTORE_PASSWORD: "test-only-password",
    DEBUG_KEY_PASSWORD: "test-only-password",
  };
  execFileSync(
    "keytool",
    [
      "-genkeypair",
      "-keystore",
      keystore,
      "-storetype",
      "JKS",
      "-alias",
      "development",
      "-keyalg",
      "RSA",
      "-keysize",
      "2048",
      "-validity",
      "30",
      "-dname",
      "CN=CI Fixture",
      "-storepass:env",
      "DEBUG_KEYSTORE_PASSWORD",
      "-keypass:env",
      "DEBUG_KEY_PASSWORD",
    ],
    { env, stdio: "pipe" },
  );
  secrets = {
    DEBUG_KEYSTORE_BASE64: readFileSync(keystore).toString("base64"),
    DEBUG_KEY_ALIAS: "development",
    DEBUG_KEY_PASSWORD: env.DEBUG_KEY_PASSWORD,
    DEBUG_KEYSTORE_PASSWORD: env.DEBUG_KEYSTORE_PASSWORD,
  };
});
after(() => {
  if (fixture) rmSync(fixture, { recursive: true });
});

function withProject(action) {
  const root = mkdtempSync(join(tmpdir(), "kasih-signing-test-"));
  mkdirSync(join(root, "android", "app"), { recursive: true });
  writeFileSync(join(root, "android", "app", "build.gradle"),
    'android {
  try {
    action(root);
  } finally {
    rmSync(root, { recursive: true });
  }
}

test("same key produces stable fingerprint and public App Link association", () => {
  const fingerprints = [];
  for (let i = 0; i < 2; i++)
    withProject((root) => {
      fingerprints.push(configureSigning({ root, env: secrets }));
      assert.match(fingerprints.at(-1), /^([A-F0-9]{2}:){31}[A-F0-9]{2}$/);
      const association = JSON.parse(
        readFileSync(join(root, "build/app-links/assetlinks-debug.json")),
      );
      assert.equal(
        association[0].target.package_name,
        "digital.seribasa.kasih.debug",
      );
      assert.deepEqual(association[0].target.sha256_cert_fingerprints, [
        fingerprints.at(-1),
      ]);
      assert.equal(
        statSync(join(root, "android/key.properties")).mode & 0o777,
        0o600,
      );
      assert.equal(
        statSync(join(root, "android/keystore/debug.jks")).mode & 0o777,
        0o600,
      );
      assert.throws(
        () => configureSigning({ root, env: secrets }),
        /refusing to overwrite/,
      );
    });
  assert.equal(fingerprints[0], fingerprints[1]);
});

test("missing or malformed keystore secrets fail before configuration", () => {
  withProject((root) => {
    assert.throws(
      () => configureSigning({ root, env: {} }),
      /Missing signing secret/,
    );
    assert.throws(
      () =>
        configureSigning({
          root,
          env: { ...secrets, DEBUG_KEYSTORE_BASE64: "not base64!" },
        }),
      /valid base64/,
    );
    assert.equal(existsSync(join(root, "android/key.properties")), false);
  });
});

test("wrong private-key password cannot silently fall back to a generated key", () => {
  withProject((root) => {
    assert.throws(
      () =>
        configureSigning({
          root,
          env: { ...secrets, DEBUG_KEY_PASSWORD: "wrong-password" },
        }),
      /Cannot unlock/,
    );
    assert.equal(existsSync(join(root, "android/key.properties")), false);
  });
});

test("release uses release credentials and package without the debug suffix", () => {
  const releaseSecrets = Object.fromEntries(
    Object.entries(secrets).map(([name, value]) => [
      name.replace("DEBUG_", "RELEASE_"),
      value,
    ]),
  );
  withProject((root) => {
    assert.throws(
      () => configureSigning({ root, env: secrets, buildType: "release" }),
      /Missing signing secret: RELEASE_/,
    );
    configureSigning({ root, env: releaseSecrets, buildType: "release" });
    const properties = readFileSync(
      join(root, "android/key.properties"),
      "utf8",
    );
    assert.ok(properties.includes("storeFile=keystore/release.jks"));
    assert.ok(!properties.includes("debugStoreFile"));
    const association = JSON.parse(
      readFileSync(join(root, "build/app-links/assetlinks-release.json")),
    );
    assert.equal(association[0].target.package_name, "digital.seribasa.kasih");
  });
});

test("explicit local merge preserves existing debug properties", () => {
  const releaseSecrets = Object.fromEntries(
    Object.entries(secrets).map(([name, value]) => [
      name.replace("DEBUG_", "RELEASE_"),
      value,
    ]),
  );
  withProject((root) => {
    configureSigning({ root, env: secrets });
    const previous = readFileSync(join(root, "android/key.properties"), "utf8");
    configureSigning({
      root,
      env: releaseSecrets,
      buildType: "release",
      merge: true,
    });
    const combined = readFileSync(join(root, "android/key.properties"), "utf8");
    assert.ok(combined.startsWith(previous));
    assert.ok(combined.includes("storeFile=keystore/release.jks"));
    assert.throws(
      () =>
        configureSigning({
          root,
          env: releaseSecrets,
          buildType: "release",
          merge: true,
        }),
      /refusing to overwrite/,
    );
  });
});

test("unsupported build types fail before writing anything", () => {
  withProject((root) => {
    assert.throws(
      () => configureSigning({ root, env: secrets, buildType: "both" }),
      /BUILD_TYPE/,
    );
    assert.equal(existsSync(join(root, "android/key.properties")), false);
  });
});
