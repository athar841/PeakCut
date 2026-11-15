# Experimental Render free-plan image. Application data is NOT persistent.
FROM python:3.11-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates bzip2 \
 && rm -rf /var/lib/apt/lists/*
COPY --from=denoland/deno:bin /deno /usr/local/bin/deno

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY studio studio
COPY web web

ENV PEAKCUT_DATA=/tmp/peakcut \
    PEAKCUT_MODELS=/opt/peakcut-models \
    PEAKCUT_HOST=0.0.0.0 \
    PEAKCUT_TRUST_PROXY=1 \
    PEAKCUT_ACCOUNTS=1 \
    PEAKCUT_AUTO_RELOAD=0 \
    PYTHONUNBUFFERED=1

# Keep the large model in the image so cold starts do not download it again.
# Transcription can still exceed the free service's memory allowance.
RUN python -m studio.fetch_model

EXPOSE 10000
# Render supplies PORT and RENDER_EXTERNAL_URL at runtime. The latter is
# needed for secure cookies, same-origin checks, and public links.
CMD ["sh", "-c", "export PEAKCUT_PORT=\"${PORT:-10000}\"; export PEAKCUT_PUBLIC_URL=\"${RENDER_EXTERNAL_URL:-http://127.0.0.1:10000}\"; exec python -m studio.server"]
