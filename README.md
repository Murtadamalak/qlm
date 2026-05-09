<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

# مكتبة القلم | Maktaba Al-Qalam

This repository contains two deployable frontends:

1. **Root Angular web app** — the app Vercel builds when the repository root is selected.
2. **`flutter_app/` Flutter web/mobile module** — prepared for Flutter Web and GitHub Pages.

## Fix for the Vercel build error

Vercel was failing because the root Angular project imported `./src/app.component` but the `src/` Angular files were missing from the repository, and `tsconfig.json` referenced the Node type library without installing Node type definitions.

The root app is now Vercel-ready:

- `src/` Angular components and services are restored.
- `tsconfig.json` no longer requests the missing `node` type library.
- `vercel.json` tells Vercel to run `npm run build` and publish `dist`.

## Run the Angular app locally

**Prerequisites:** Node.js

```bash
npm install
npm run build
npm run dev
```

## Deploy the Angular app to Vercel

Use these Vercel settings:

- **Framework Preset:** Angular
- **Build Command:** `npm run build`
- **Output Directory:** `dist`
- **Install Command:** `npm install`

These values are also committed in `vercel.json`, so Vercel should pick them up automatically.

## Flutter app

See [`flutter_app/README.md`](flutter_app/README.md) for Flutter Web, GitHub Pages, and Firebase setup instructions.
