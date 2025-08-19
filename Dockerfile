FROM pandoc/core:3.1 AS builder
WORKDIR /app

# Add this line:
RUN apt-get update && apt-get install -y perl && rm -rf /var/lib/apt/lists/*

COPY scripts/convert.sh scripts/convert.sh
COPY theme/ theme/
COPY src/ src/
COPY docs/ docs/
RUN chmod +x scripts/convert.sh
RUN sh scripts/convert.sh

