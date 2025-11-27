# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic thesis book project titled "Sistema de Estructuración Dramática de Obras Audiovisuales" (Dramatic Structuring System for Audiovisual Works). The project uses **dual compilation systems**: LaTeX for the main thesis book and Pandoc+LuaLaTeX for Markdown documentation.

## Build Commands

### LaTeX Compilation (Main Thesis Book)

Always run from repository root:

```bash
./compile.sh 1    # Full compilation (use when bibliography changed)
./compile.sh 2    # Quick compilation (text changes only)
./compile.sh 3    # Check warnings and errors
./compile.sh 4    # Clean auxiliary files
./compile.sh 5    # Show PDF information
```

**Critical**: Must run from repository root. The LaTeX file (`src/Libro.tex`) uses paths relative to root (`bibliography/`, `images/`). Direct compilation from `src/` will fail.

Full compilation sequence: LuaLaTeX → Biber → LuaLaTeX → LuaLaTeX (for bibliography resolution).

### Markdown Compilation (Documentation)

```bash
./compile-md.sh 1    # Compile single file (interactive)
./compile-md.sh 2    # Compile all Markdown files
./compile-md.sh 3    # Compile custom file (specify path)
./compile-md.sh 4    # Compile merged document (all files combined)
./compile-md.sh 5    # Show PDF information
./compile-md.sh 6    # Clean build files
```

### Output Locations

- LaTeX output: `build/Libro.pdf`
- Markdown PDFs: `build/markdown/pdf/`
- Merged Markdown: `build/markdown/pdf/merged-document.pdf`
- Logs: `build/Libro.log` (LaTeX), `build/markdown/last-compilation.log` (Markdown)

### Finding Files

```bash
find build -name "*.pdf" -type f        # All compiled PDFs
ls build/*.pdf                          # LaTeX output
ls build/markdown/pdf/                  # Markdown outputs
```

## Repository Structure

### Content Organization

- `src/` - LaTeX source files for main thesis book
  - `Libro.tex` - Main document (article class, 12pt, A4)
  - `capitulos/` - Book chapters (00-05)
  - `pretextual/` - Cover, approval page
  - `postextual/` - Conclusions, recommendations, appendices
  - `config/preamble.tex` - Packages and styling configuration

- `docs/` - Markdown documentation files
  - Compiled individually and as merged document
  - Includes methodology matrices, interview instruments, diagrams

- `templates/` - Compilation templates
  - `thesis-template.tex` - Pandoc LaTeX template for Markdown→PDF

- `bibliography/` - BibTeX reference files (`referencias.bib`)
- `images/` - Image assets (tracked with Git LFS)
- `build/` - Generated files (git-ignored)
- `data/transcripciones_entrevistas/` - Interview transcriptions

### LaTeX Document Structure

The main thesis follows institutional format with three parts:

1. **Pre-textual** (Roman numerals): Cover, approval, TOC, lists (tables/figures)
2. **Textual** (Arabic numerals): Introduction + 5 chapters
   - Chapter I: Marco Introductorio (problem, objectives, scope)
   - Chapter II: Marco Teórico (background, theory, legal basis)
   - Chapter III: Marco Metodológico (research methodology)
   - Chapter IV: Marco Analítico (data analysis, results)
   - Chapter V: Requerimientos del Software (software requirements)
3. **Post-textual**: Conclusions, recommendations, appendices, annexes

## Style Guide Compliance

Both compilation systems enforce institutional standards from `docs/STYLE_GUIDE_DOC.md`:

- **Font**: TeX Gyre Termes (Times New Roman equivalent)
- **Size**: 12pt body, 14pt subtitles, 16pt titles
- **Paper**: A4
- **Margins**: 3cm (L/R), 2.54cm (T/B)
- **Line spacing**: 1.5
- **Paragraph spacing**: 10pt after, no indentation
- **Page numbers**: Roman (pre-textual), Arabic (textual/post-textual), centered bottom
- **Headers/Footers**: Empty

These are configured in `src/config/preamble.tex` (LaTeX) and `templates/thesis-template.tex` (Markdown).

## GitHub Actions Workflows

### LaTeX CI (`.github/workflows/latex-ci.yml`)

- Triggers: Push to main, PRs
- Compiles `src/Libro.tex` using LuaLaTeX + Biber
- Validates PDF integrity
- Uploads artifacts (libro-pdf)
- Creates releases (tagged `pdf-latest`)
- Deploys to GitHub Pages

### Markdown PDF CI (`.github/workflows/markdown-pdf-ci.yml`)

- Triggers: Push to main (when `docs/*.md` changes), PRs
- Compiles all Markdown files individually
- Creates merged document (main branch only)
- Validates each PDF
- Uploads artifacts with 30-day retention
- Creates releases (tagged `markdown-pdfs-latest`)

### Viewing CI Results

- Artifacts: Actions tab → workflow run → download artifacts
- Releases: Check [Releases](../../releases) page
- GitHub Pages: https://dreamink-snpp.github.io/BookThesis/

## Git Configuration

### Git LFS

This project uses Git LFS for binary files (images, PDFs):

```bash
git lfs install              # First-time setup
git lfs pull                 # Pull LFS objects after clone
```

### What's Tracked/Ignored

**Tracked:**
- `src/*.tex` - LaTeX sources
- `docs/*.md` - Markdown documentation
- `bibliography/*.bib` - References
- `images/*` - Images (via Git LFS)
- `*.sh` - Compilation scripts

**Ignored** (`.gitignore`):
- `build/` - All compilation outputs
- `*.aux`, `*.log`, `*.toc`, `*.out` - LaTeX auxiliary files
- `*.pdf` (except those tracked via LFS)

## Dependencies

### Required

- **LuaLaTeX** (from texlive-luatex or texlive-full)
- **Biber** (bibliography processor)
- **Pandoc** ≥ 2.x (for Markdown compilation)
- **Git LFS** (for binary file handling)

### Optional

- `pdfinfo` (from poppler-utils) - for PDF information display

### Installation (Ubuntu/Debian)

```bash
sudo apt-get install texlive-luatex biber pandoc \
  texlive-latex-extra texlive-fonts-extra \
  texlive-lang-spanish poppler-utils git-lfs
git lfs install
```

## Common Tasks

### Starting Fresh

```bash
git clone <repo>
git lfs pull
./compile.sh 1         # Full LaTeX compilation
./compile-md.sh 2      # All Markdown files
```

### After Adding Citations

```bash
# Edit bibliography/referencias.bib
./compile.sh 1         # Full compilation required
```

### Quick Text Edits

```bash
# Edit src/capitulos/*.tex or src/Libro.tex
./compile.sh 2         # Quick compilation sufficient
```

### Cleaning Build Files

```bash
./compile.sh 4         # Clean LaTeX auxiliaries
./compile-md.sh 6      # Clean Markdown builds
rm -rf build/          # Nuclear option
```

### Troubleshooting Compilation

```bash
./compile.sh 3                               # Check LaTeX errors/warnings
cat build/Libro.log                          # Full LaTeX log
cat build/markdown/last-compilation.log      # Markdown log
```

## Important Constraints

1. **Path Requirements**: Always compile from repository root. LaTeX files use relative paths that won't resolve from subdirectories.

2. **Bibliography**: After modifying `.bib` files, use full compilation (`./compile.sh 1`) to regenerate references properly.

3. **Git LFS**: After clone, always run `git lfs pull` before compiling to ensure image files are present.

4. **Output Directory**: The `build/` directory is git-ignored. CI/CD regenerates all outputs. Never commit build artifacts.

5. **Template Modifications**: Changes to `templates/thesis-template.tex` affect all Markdown compilation. Test thoroughly.

## License

Dual-licensed project:
- **Content** (LaTeX, docs, images): CC BY 4.0
- **Code** (scripts): MIT

> **Authors**: Fernando Cardozo and Alberto Álvarez
