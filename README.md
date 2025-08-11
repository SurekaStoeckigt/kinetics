# DOCX → HTML via Docker on GitHub Actions (with equations)

This repo converts a Word `.docx` into a static HTML site using Pandoc **inside Docker** on GitHub-hosted runners, and deploys it to **GitHub Pages**.
It preserves **equations** using **MathJax** (default) or **KaTeX**.

## How it works
- Push to `main` (update `src/document.docx` and optionally `theme/styles.css`).
- GitHub Actions builds a Docker image, runs the conversion in a container, and publishes the `site/` folder to Pages.
- Equations render in the browser via MathJax/KaTeX.

## Quick start
1. Put your DOCX at `src/document.docx`.
2. (Optional) Edit `theme/styles.css`.
3. Push to `main`.
4. In repo **Settings → Pages**, set **Source: GitHub Actions**.

## Math settings
- Default engine: `MATH_ENGINE=mathjax` (set in workflow env).
- Switch to KaTeX: set `MATH_ENGINE=katex`.
- Override CDNs via `MATHJAX_URL` / `KATEX_URL`.

## Notes
- Make sure your equations are **Office Math (OMML)** in Word (not legacy OLE or images).
- Images embedded in the DOCX are exported to `site/media/`.
- To change the page title, set `TITLE` in the workflow env.

## Local optional
If you do have Docker locally:
```
docker build -t local .
docker run --rm -v "$PWD":/work -w /work local
```
Output will be under `site/`.
