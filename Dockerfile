# Use the Alpine-based Pandoc image
FROM pandoc/core:3.1 AS builder

# Work inside /app
WORKDIR /app

# Install Perl (needed for the bracket → $$ normalization in convert.sh)
# If you removed that Perl line from convert.sh, you can delete this RUN.
RUN apk add --no-cache perl

# Bring in your build inputs
COPY scripts/convert.sh scripts/convert.sh
COPY theme/ theme/
COPY src/ src/
# NOTE: this COPY requires that a docs/ folder exists in your repo (even empty)
COPY docs/ docs/

# Run the converter
RUN chmod +x scripts/convert.sh
RUN sh scripts/convert.sh
