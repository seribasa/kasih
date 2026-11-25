// Resize the generated Kasih master into the existing platform icon slots.
// Run on macOS: node scripts/regenerate-brand-icons.mjs
import { readFileSync, copyFileSync, existsSync } from 'node:fs';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const master = resolve(root, 'assets/images/e_patient_logo.png');
if (!existsSync(master)) throw new Error('Kasih logo master is missing');

function resize(relativePath, size) {
  const target = resolve(root, relativePath);
  execFileSync('/usr/bin/sips', ['-z', String(size), String(size), master, '--out', target]);
  console.log(`${relativePath}: ${size}×${size}`);
}

for (const [density, size] of Object.entries({ mdpi: 48, hdpi: 72, xhdpi: 96, xxhdpi: 144, xxxhdpi: 192 })) {
  resize(`android/app/src/main/res/mipmap-${density}/ic_launcher.png`, size);
}
resize('android/app/src/main/res/drawable/ic_launcher.png', 72);

const iconDirectory = 'ios/Runner/Assets.xcassets/AppIcon.appiconset';
const catalog = JSON.parse(readFileSync(resolve(root, iconDirectory, 'Contents.json'), 'utf8'));
for (const icon of catalog.images) {
  if (!icon.filename) continue;
  const size = Number(icon.size.split('x')[0]) * Number(icon.scale.replace('x', ''));
  if (!Number.isInteger(size) || size <= 0) throw new Error(`Invalid icon size: ${icon.filename}`);
  resize(`${iconDirectory}/${icon.filename}`, size);
}
resize('web/favicon.png', 32);
resize('web/icons/Icon-192.png', 192);
resize('web/icons/Icon-512.png', 512);
// Keep compatibility with any external consumer of the previous asset path.
copyFileSync(master, resolve(root, 'assets/images/logo.png'));
