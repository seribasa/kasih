// Values come from runner environment variables, never shell interpolation.
import { writeFileSync } from 'node:fs';

const ci = process.argv.includes('--ci');
const check = process.argv.includes('--check');
const values = ci ? {
  SUPABASE_URL: 'https://ci.example.invalid',
  SUPABASE_ANON_KEY: 'ci-placeholder-not-a-real-key',
  PAYMENT_URL: 'https://payments.example.invalid',
  STRIPE_PUBLISHABLE_KEY: '',
  PAYMENT_GATEWAY: 'midtrans',
  PAYMENT_CURRENCY: 'IDR',
  AUTH_REDIRECT_URL: 'https://kasih-app.peltops.com/',
} : Object.fromEntries([
  'SUPABASE_URL', 'SUPABASE_ANON_KEY', 'PAYMENT_URL',
  'STRIPE_PUBLISHABLE_KEY', 'PAYMENT_GATEWAY', 'PAYMENT_CURRENCY',
  'AUTH_REDIRECT_URL',
].map(key => [key, (process.env[key] || '').trim()]));

values.PAYMENT_GATEWAY ||= 'midtrans';
values.PAYMENT_CURRENCY ||= 'IDR';
values.AUTH_REDIRECT_URL ||= 'https://kasih-app.peltops.com/';
let redirect;
try {
  redirect = new URL(values.AUTH_REDIRECT_URL);
} catch {
  throw new Error('AUTH_REDIRECT_URL must be a valid HTTPS App Link URL');
}
if (redirect.protocol !== 'https:' ||
    redirect.host !== 'kasih-app.peltops.com' ||
    redirect.pathname !== '/' || redirect.search || redirect.hash || redirect.username || redirect.password) {
  throw new Error('AUTH_REDIRECT_URL must be the HTTPS root of a configured Android App Link domain');
}
for (const key of ['SUPABASE_URL', 'SUPABASE_ANON_KEY', 'PAYMENT_URL']) {
  if (!values[key]) throw new Error(`Missing configuration: ${key}`);
}
if (!['midtrans', 'stripe'].includes(values.PAYMENT_GATEWAY)) {
  throw new Error('PAYMENT_GATEWAY must be midtrans or stripe');
}
if (!/^[A-Z]{3}$/.test(values.PAYMENT_CURRENCY)) {
  throw new Error('PAYMENT_CURRENCY must be a three-letter uppercase currency code');
}
if (values.PAYMENT_GATEWAY === 'stripe' && !values.STRIPE_PUBLISHABLE_KEY) {
  throw new Error('STRIPE_PUBLISHABLE_KEY is required for Stripe');
}
for (const key of ['SUPABASE_URL', 'PAYMENT_URL']) {
  try {
    if (new URL(values[key]).protocol !== 'https:') throw new Error();
  } catch {
    throw new Error(`${key} must be an HTTPS URL`);
  }
}
for (const [key, value] of Object.entries(values)) {
  if (/[\r\n"\\]/.test(value)) throw new Error(`Unsupported characters in ${key}`);
}
if (!check) {
  const content = Object.entries(values).map(([key, value]) => `${key}="${value}"`).join('\n');
  writeFileSync('.env', `${content}\n`, { mode: 0o600 });
}
console.log(`${ci ? 'CI placeholder' : 'Development'} configuration validated${check ? '' : ' and written'}; values are not logged.`);
