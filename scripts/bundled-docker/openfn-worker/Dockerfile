# Dockerfile.worker
FROM openfn/ws-worker:v1.27.2

# Install OpenFn CLI and adaptors
RUN npm install -g @openfn/cli@1.38.5 && \
    openfn repo install \
    -a common@3.3.4 \
    -a collections@0.9.3 \
    -a http@6.5.1 \
    -a openmrs@4.1.3 \
    -a dhis2@5.0.1

# Create the lime directory
RUN mkdir -p /app/packages/ws-worker/lime

# Copy OpenFn configuration files
COPY configs/openfn/* /app/packages/ws-worker/lime/

# Set working directory
WORKDIR /app/packages/ws-worker/lime

# Keep the original entrypoint and command from base image
