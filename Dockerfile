# Simple base
FROM alpine:3.20

WORKDIR /app

# Copy everything from current directory into the image
COPY . /app

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default output directory inside container (should be mounted from host)
ENV OUT_DIR=/out
ENV FILE_TO_COPY=sample.txt

ENTRYPOINT ["/entrypoint.sh"]
