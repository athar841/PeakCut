# Experimental deployment on Render Free

This is a free-plan experiment, not reliable hosting for the video pipeline.
No paid database, persistent disk, or background worker is provisioned.

## Deploy from your connected GitHub account

1. Sign in at https://dashboard.render.com/.
2. Choose **New > Blueprint**, then select `athar841/PeakCut` and branch `main`.
3. Render should find the root `render.yaml` and propose one Docker web service named `peakcut`.
4. Check that its plan is **Free** and that there are no paid resources. If Free is unavailable or a payment method is required, stop; do not select a paid plan.
5. Deploy the Blueprint. The image build installs FFmpeg and downloads the speech model. The server starts without downloading it again.
6. Open the actual `https://...onrender.com` URL shown by Render. Sign up using a strong, unique password.
7. Check the service's `/healthz` URL; it should return `{"ok":true}`. Then test a very short video separately. A healthy dashboard does not prove that video processing fits the free hardware.

If Blueprint deployment is unavailable for a private repository, use **New > Web Service**:

- Repository: `athar841/PeakCut`; branch: `main`
- Language/runtime: Docker
- Root directory: leave empty
- Dockerfile path: `./deploy/render/Dockerfile`
- Docker build context: repository root (`.`)
- Instance type: **Free**
- Health check path: `/healthz`
- Copy the environment variables from `render.yaml` into the service's Environment page.
- Leave the Docker command override empty; the image supplies its command.

The image derives `PEAKCUT_PORT` from Render's `PORT` and `PEAKCUT_PUBLIC_URL` from `RENDER_EXTERNAL_URL`. Do not set the public URL to localhost. Keep accounts enabled on the public service.

## Limits and security

- All accounts, uploaded files, clips, sessions, and saved settings use temporary local storage. They can disappear on restart, redeploy, or host replacement. Download anything you want to keep.
- Free services can sleep. Do not depend on continuous recording, scheduled posting, or uninterrupted background processing.
- Transcription and rendering can exceed the free service's memory/CPU allowance. The model is available in the image, but that does not mean it fits in runtime RAM.
- The app's resource guard may leave jobs waiting when memory is low. Do not disable protection expecting that to create more memory.
- Settings limit one processing job at a time, 100 MB uploads, six-minute videos/recordings, and 1 GB storage per user. These are safety limits, not a performance promise.
- Sign-in is required, but registration is still open: this is NOT a single-user access restriction. Do not share an AI key on this public experiment without adding private access controls. No AI key is included; without one the app uses loudness-based clip selection.
- No email provider is configured. HTTPS password resets need SMTP; keep your password safe. Social posting needs separate OAuth setup.
- YouTube can refuse downloads from data-center IPs. Test a file upload first.
- Never commit `.env`, credentials, uploaded media, database files, or API keys. If needed, use Render's secret environment settings and remember that external AI services may charge separately.

## Updates and verification

Push changes to GitHub and use Render's deploy controls (or enable its automatic deployment setting). Updating the Blueprint may also be needed when `render.yaml` changes.

Check build logs for package/model download failures and runtime logs for memory kills or startup errors. This configuration has been inspected locally; only a successful Render build and live checks can validate the hosted deployment.
