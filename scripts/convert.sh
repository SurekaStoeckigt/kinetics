#!/usr/bin/env sh
set -eu

OUT_DIR=${OUT_DIR:-site}
CSS_PATH=${CSS_PATH:-theme/styles.css}
MATHJAX_URL=${MATHJAX_URL:-https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js}

mkdir -p "$OUT_DIR" "$OUT_DIR/assets"

CSS_LINK=""
if [ -f "$CSS_PATH" ]; then
  cp -f "$CSS_PATH" "$OUT_DIR/assets/styles.css"
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

slugify () {
  printf "%s" "$1" \
    | tr '[:upper:] ' '[:lower:]-' \
    | sed -e 's/[^a-z0-9_-]/-/g' -e 's/-\+/-/g' -e 's/^-//' -e 's/-$//'
}

count=0

# Build all DOCX in src/
if ls src/*.docx >/dev/null 2>&1; then
  for f in src/*.docx; do
    [ -e "$f" ] || continue
    name="$(basename "$f" .docx)"
    slug="$(slugify "$name")"
    outdir="$OUT_DIR/$slug"
    mkdir -p "$outdir"
    pandoc "$f" \
      -o "$outdir/index.html" \
      --extract-media="$outdir/media" \
      --standalone \
      --toc --toc-depth=3 \
      --section-divs \
      -H "$HEAD_FILE" \
      --metadata "title:$name" \
      $CSS_LINK
    echo "Built $outdir/index.html"
    count=$((count+1))
  done
fi

# Optional: Markdown pages in docs/
if ls docs/*.md >/dev/null 2>&1; then
  for f in docs/*.md; do
    [ -e "$f" ] || continue
    name="$(basename "$f" .md)"
    slug="$(slugify "$name")"
    outdir="$OUT_DIR/$slug"
    mkdir -p "$outdir"
    pandoc "$f" \
      -o "$outdir/index.html" \
      --standalone \
      --toc --toc-depth=3 \
      --section-divs \
      -H "$HEAD_FILE" \
      --metadata "title:$name" \
      $CSS_LINK
    echo "Built $outdir/index.html"
    count=$((count+1))
  done
fi

# Homepage
{
  echo '<!doctype html><meta charset="utf-8"><title>Kinetics Documents</title>'
  [ -f "$OUT_DIR/assets/styles.css" ] && echo '<link rel="stylesheet" href="assets/styles.css">'
  echo '<h1>Kinetics Documents</h1>'
  if [ "$count" -eq 0 ]; then
    echo '<p>No documents found. Add .docx to <code>src/</code> (or .md to <code>docs/</code>) and push.</p>'
  else
    echo '<ul>'
    for d in "$OUT_DIR"/*; do
      [ -d "$d" ] || continue
      base="$(basename "$d")"
      case "$base" in assets|media) continue ;; esac
      title="$(printf "%s" "$base" | tr '-' ' ')"
      printf '<li><a href="%s/">%s</a></li>\n' "$base" "$title"
    done
    echo '</ul>'
  fi
} > "$OUT_DIR/index.html"

touch "$OUT_DIR/.nojekyll"
echo "Built $count page(s)."
