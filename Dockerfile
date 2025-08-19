# Alpine-based Pandoc image
FROM pandoc/core:3.1 AS builder
WORKDIR /app

# Optional: Perl only if you kept the bracket→$$ post-process in convert.sh
RUN apk add --no-cache perl

# Copy files
COPY scripts/convert.sh scripts/convert.sh
# Normalize line endings inside the container and make executable
RUN sed -i 's/\r$//' scripts/convert.sh && chmod +x scripts/convert.sh

COPY theme/ theme/
COPY src/ src/
# Keep this only if docs/ exists in your repo (even empty with .gitkeep)
COPY docs/ docs/

# Run the converter
RUN sh scripts/convert.sh
