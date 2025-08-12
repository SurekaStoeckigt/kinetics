#!/usr/bin/env sh
set -eu

# Use your actual file by default:
SRC_DOC=${SRC_DOC:-src/Kinetics_Appendix.docx}
OUT_DIR=${OUT_DIR:-site}
OUT_HTML=${OUT_HTML:-index.html}
CSS_PATH=${CSS_PATH:-theme/styles.css}
TITLE=${TITLE:-Kinetics Appendix}
MATHJAX_URL=${MATHJAX_URL:-https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js}

mkdir -p "$OUT_DIR" "$OUT_DIR/assets"

CSS_LINK=""
if [ -f "$CSS_PATH" ]; then
  cp "$CSS_PATH" "$OUT_DIR/assets/styles.css"
  CSS_LINK="-c assets/styles.css"
fi

HEAD_FILE="$(mktemp)"
cat > "$HEAD_FILE" <<'EOF'
<script>
  window.MathJax = {
    tex: {
      inlineMath: [['$', '$'], ['\\(', '\\)']],
      displayMath: [['$$','$$'], ['\\[','\\]']],
      tags: 'ams', tagSide: 'right', tagIndent: '0em'
    },
    options: { skipHtmlTags: ['script','noscript','style','textarea','pre','code'] }
  };
</script>
EOF
echo "<script src=\"$MATHJAX_URL\" id=\"MathJax-script\" async></script>" >> "$HEAD_FILE"

if [ -f "$SRC_DOC" ]; then
  pandoc "$SRC_DOC" \
    -o "$OUT_DIR/$OUT_HTML" \
    --extract-media="$OUT_DIR/media" \
    --standalone \
    --toc --toc-depth=3 \
    --section-divs \
    -H "$HEAD_FILE" \
    --metadata "title:$TITLE" \
    $CSS_LINK
  echo "Converted $SRC_DOC -> $OUT_DIR/$OUT_HTML"
else
  printf '%s\n' '<!doctype html><meta charset="utf-8"><title>Missing DOCX</title><h1>Put your DOCX at src/Kinetics_Appendix.docx</h1>' > "$OUT_DIR/index.html"
fi
