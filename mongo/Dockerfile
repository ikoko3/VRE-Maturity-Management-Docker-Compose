# images/mongo/Dockerfile
FROM mongo:7

# Optional: used by .js init scripts; harmless here
ENV MONGO_INITDB_DATABASE=appdb

# Copy the init assets
COPY docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/

# Important on Windows: convert CRLF->LF and make scripts executable
# (Uses sed which is available in this base image)
RUN sed -i 's/\r$//' /docker-entrypoint-initdb.d/*.sh && \
    chmod +x /docker-entrypoint-initdb.d/*.sh
