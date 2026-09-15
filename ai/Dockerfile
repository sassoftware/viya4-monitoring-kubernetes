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
RUN mkdir -p docs/viya4-monitoring-kubernetes cache \
 && tar xzf /tmp/v4m.tgz -C docs/viya4-monitoring-kubernetes --strip-components=1 \
 && rm /tmp/v4m.tgz

# SAS doc-set PDFs (ai/docs-pdfs/ in the repo) are baked in alongside the repo
# markdown — the docs set is fixed per image build, with no runtime injection.
# To add or update docs: change ai/docs-pdfs/ and rebuild the image; the docs
# fingerprint change triggers one re-embed on the next pod start.
COPY docs-pdfs/ docs/sas-pdfs/

# --- Application ---
COPY rag.py .
COPY app.py .

# DOCS_PATH covers everything under /app/docs: the baked-in repo markdown and the baked-in SAS PDFs.
ENV DOCS_PATH=/app/docs \
    INDEX_CACHE=/app/cache/doc_index.npz \
    EMBED_BASE_URL=http://localhost:11434/v1 \
    EMBED_MODEL=nomic-embed-text \
    EMBED_API_KEY=ollama \
    PORT=8000

EXPOSE 8000
CMD ["python", "app.py"]
