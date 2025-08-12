FROM pandoc/core:3.1 AS builder
WORKDIR /app
COPY scripts/convert.sh scripts/convert.sh
COPY theme/ theme/
COPY src/ src/
ARG SRC_DOC=src/Kinetics_Appendix.docx
ARG OUT_DIR=site
ARG OUT_HTML=index.html
ARG TITLE="Kinetics Appendix"
ARG MATHJAX_URL="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
RUN chmod +x scripts/convert.sh
RUN SRC_DOC="$SRC_DOC" OUT_DIR="$OUT_DIR" OUT_HTML="$OUT_HTML" TITLE="$TITLE" MATHJAX_URL="$MATHJAX_URL" sh scripts/convert.sh
FROM node:20-alpine AS runtime
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev || npm install --omit=dev
COPY server.js ./
COPY --from=builder /app/site ./site
EXPOSE 3000
CMD ["node", "server.js"]
