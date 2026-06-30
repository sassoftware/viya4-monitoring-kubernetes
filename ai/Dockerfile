FROM python:3.11-slim
WORKDIR /app

# --- Python dependencies ---
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- Bake the SAS Viya Monitoring docs into the image at build time ---
# Pinned via build arg for reproducible images:
#   docker build --build-arg V4M_REF=main .
ARG V4M_REF=main
ADD https://codeload.github.com/sassoftware/viya4-monitoring-kubernetes/tar.gz/refs/heads/${V4M_REF} /tmp/v4m.tgz
RUN mkdir -p docs/viya4-monitoring-kubernetes docs/pdfs cache \
 && tar xzf /tmp/v4m.tgz -C docs/viya4-monitoring-kubernetes --strip-components=1 \
 && rm /tmp/v4m.tgz

# --- Application ---
COPY rag.py .
COPY app.py .

# DOCS_PATH spans BOTH the baked-in repo and the runtime PDF mount. Drop PDFs into /app/docs/pdfs (volume / configMap) and they get indexed alongside the repo. 
ENV DOCS_PATH=/app/docs \
    INDEX_CACHE=/app/cache/doc_index.npz \
    EMBED_BASE_URL=http://localhost:11434/v1 \
    EMBED_MODEL=nomic-embed-text \
    EMBED_API_KEY=ollama \
    PORT=8000

EXPOSE 8000
CMD ["python", "app.py"]
