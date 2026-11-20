import {
  chmodSync,
  existsSync,
  mkdirSync,
  readFileSync,
  writeFileSync,
} from "node:fs";
import { execFileSync } from "node:child_process";
import { X509Certificate } from "node:crypto";
import { resolve, join } from "node:path";
import { fileURLToPath } from "node:url";

function property(value) {
  return [...value]
    .map((character) => {
      if ("\\ :=#!".includes(character)) return `\\${character}`;
      return character
        .split("")
        .map((unit) => {
          const code = unit.charCodeAt(0);
          return code < 32 || code > 126
            ? `\\u${code.toString(16).padStart(4, "0")}`
            : unit;
        })
        .join("");
    })
    .join("");
}

export function configureSigning({
  root = process.cwd(),
  env = process.env,
  buildType = env.BUILD_TYPE || "debug",
  keytool = "keytool",
  merge = false,
} = {}) {
  if (!["debug", "release"].includes(buildType))
    throw new Error("BUILD_TYPE must be debug or release");
  const prefix = buildType.toUpperCase();
  const required = [
    "KEYSTORE_BASE64",
    "KEY_ALIAS",
    "KEY_PASSWORD",
    "KEYSTORE_PASSWORD",
  ];
  for (const suffix of required) {
    if (!env[`${prefix}_${suffix}`])
      throw new Error(`Missing signing secret: ${prefix}_${suffix}`);
  }
  const encoded = env[`${prefix}_KEYSTORE_BASE64`].replace(/\s/g, "");
  if (!/^[A-Za-z0-9+/]+={0,2}$/.test(encoded) || encoded.length % 4 !== 0) {
    throw new Error(
      `${prefix}_KEYSTORE_BASE64 must contain a valid base64 keystore`,
    );
  }
  const directory = join(root, "android", "keystore");
  const keystore = join(directory, `${buildType}.jks`);
  const properties = join(root, "android", "key.properties");
  const previous = existsSync(properties)
    ? readFileSync(properties, "utf8")
    : "";
  const sameType =
    buildType === "debug"
      ? /^\s*debugStoreFile\s*[=:]/m
      : /^\s*storeFile\s*[=:]/m;
  if (
    existsSync(keystore) ||
    (existsSync(properties) && (!merge || sameType.test(previous)))
  ) {
    throw new Error(
      "Signing files already exist; refusing to overwrite local configuration",
    );
  }
  mkdirSync(directory, { recursive: true, mode: 0o700 });
  writeFileSync(keystore, Buffer.from(encoded, "base64"), {
    flag: "wx",
    mode: 0o600,
  });
  let certificate;
  try {
    const options = {
      env: { ...process.env, ...env },
      stdio: ["ignore", "pipe", "pipe"],
    };
    const args = [
      "-keystore",
      keystore,
      "-alias",
      env[`${prefix}_KEY_ALIAS`],
      "-storepass:env",
      `${prefix}_KEYSTORE_PASSWORD`,
    ];
    // Validate the private-key password as well; discard the generated CSR.
    execFileSync(
      keytool,
      ["-certreq", ...args, "-keypass:env", `${prefix}_KEY_PASSWORD`],
      options,
    );
    certificate = new X509Certificate(
      execFileSync(keytool, ["-exportcert", "-rfc", ...args], options),
    );
  } catch {
    throw new Error(
      `Cannot unlock ${buildType} keystore; check file, alias, and signing passwords`,
    );
  }
  const names =
    buildType === "debug"
      ? [
          "debugStoreFile",
          "debugKeyAlias",
          "debugKeyPassword",
          "debugStorePassword",
        ]
      : ["storeFile", "keyAlias", "keyPassword", "storePassword"];
  const values = [
    `keystore/${buildType}.jks`,
    env[`${prefix}_KEY_ALIAS`],
    env[`${prefix}_KEY_PASSWORD`],
    env[`${prefix}_KEYSTORE_PASSWORD`],
  ];
  const contents = names
    .map((name, index) => `${name}=${property(values[index])}`)
    .join("\n");
  writeFileSync(
    properties,
    `${previous}${previous && !previous.endsWith("\n") ? "\n" : ""}${contents}\n`,
    { flag: existsSync(properties) ? "w" : "wx", mode: 0o600 },
  );
  chmodSync(properties, 0o600);
  const buildGradlePath = join(root, "android", "app", "build.gradle");
  const buildGradleContent = readFileSync(buildGradlePath, "utf8");
  const appIdMatch = buildGradleContent.match(/applicationId\s+"([^"]+)"/);
  if (!appIdMatch) throw new Error("Cannot determine applicationId from android/app/build.gradle");
  const applicationId = appIdMatch[1];
  const assetlinks = [
    {
      relation: ["delegate_permission/common.handle_all_urls"],
      target: {
        namespace: "android_app",
        package_name: `${applicationId}${buildType === "debug" ? ".debug" : ""}`,
        sha256_cert_fingerprints: [certificate.fingerprint256],
      },
    },
  ];
  const output = join(root, "build", "app-links");
  mkdirSync(output, { recursive: true });
  writeFileSync(
    join(output, `assetlinks-${buildType}.json`),
    `${JSON.stringify(assetlinks, null, 2)}\n`,
  );
  return certificate.fingerprint256;
}

if (
  process.argv[1] &&
  resolve(process.argv[1]) === fileURLToPath(import.meta.url)
) {
  try {
    console.log(`Signing configured. Public SHA-256: ${configureSigning()}`);
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
