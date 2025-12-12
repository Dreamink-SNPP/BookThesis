# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic thesis book project titled "Sistema de Estructuración Dramática de Obras Audiovisuales" (Dramatic Structuring System for Audiovisual Works) by Fernando Cardozo and Alberto Álvarez. The project uses **dual compilation systems**: LaTeX for the main thesis book and Pandoc+LuaLaTeX for Markdown documentation.

## Build Commands

### LaTeX Compilation (Main Thesis Book)

Always run from repository root:

```bash
./compile.sh 1    # Full compilation (use when bibliography changed)
./compile.sh 2    # Quick compilation (text changes only)
./compile.sh 3    # Check warnings and errors
./compile.sh 4    # Clean auxiliary files
./compile.sh 5    # Show PDF information
./compile.sh 6    # Exit menu
```

**Critical**: Must run from repository root. The LaTeX file (`src/Libro.tex`) uses paths relative to root (`bibliography/`, `images/`). Direct compilation from `src/` will fail.

Full compilation sequence: LuaLaTeX → Biber → LuaLaTeX → LuaLaTeX (for bibliography resolution).

**Features**:
- Color-coded console output (info, success, warning, error)
- Automatic error detection from logs
- Optional pdfinfo integration for page/size information
- Interactive and non-interactive modes

### Markdown Compilation (Documentation)

```bash
./compile-md.sh 1    # Compile single file (interactive)
./compile-md.sh 2    # Compile all Markdown files (batch)
./compile-md.sh 3    # Compile custom file (specify path)
./compile-md.sh 4    # Compile merged document (all files combined)
./compile-md.sh 5    # Show PDF information
./compile-md.sh 6    # Clean build files
```

**Security Features**:
- Path traversal protection (blocks `..` in paths)
- Absolute path validation (ensures files within repository)
- TOCTOU (Time-of-check-time-of-use) mitigation

**Additional Features**:
- GitHub Flavored Markdown preprocessing (converts alerts to blockquotes)
- Mermaid diagram placeholder handling
- Automatic TOC generation based on content
- Parallel compilation support (currently disabled, configurable)
- Comprehensive error handling and file-by-file status reporting

### Output Locations

- LaTeX output: `build/Libro.pdf`
- Markdown PDFs: `build/markdown/pdf/`
- Merged Markdown: `build/markdown/pdf/merged-document.pdf`
- Logs: `build/Libro.log` (LaTeX), `build/markdown/logs/[filename].log` (Markdown)

### Finding Files

```bash
find build -name "*.pdf" -type f        # All compiled PDFs
ls build/*.pdf                          # LaTeX output
ls build/markdown/pdf/                  # Markdown outputs
```

## Repository Structure

### Content Organization

- `.claude/` - Claude Code configuration
- `.github/` - GitHub configuration
  - `CONTRIBUTING.md` - Contribution guidelines
  - `SECURITY.md` - Security reporting
  - `CODE_OF_CONDUCT.md` - Code of conduct
  - `ISSUE_TEMPLATE/` - Issue templates
  - `PULL_REQUEST_TEMPLATE.md` - PR template
  - `workflows/` - CI/CD automation (4 workflows)
  - `pages-template/` - GitHub Pages assets (HTML, CSS, JS)

- `src/` - LaTeX source files for main thesis book (~2,000 lines)
  - `Libro.tex` - Main document (article class, 12pt, A4)
  - `config/preamble.tex` - Packages and styling configuration (~115 lines)
    - Includes custom `\sectionplain{}` command for non-bold centered titles
    - Configures ToC, LoF, and LoT with centered non-bold 16pt titles and non-bold entries
  - `capitulos/` - Book chapters
    - `00_introduccion.tex` (24 lines) - Document overview
    - `01_marco_introductorio.tex` (110 lines) - Problem, objectives, scope
    - `02_marco_teorico.tex` (148 lines) - Background, theory, legal basis
    - `03_marco_metodologico.tex` (83 lines) - Research methodology
    - `04_marco_analitico.tex` (797 lines) - Data analysis, results (most substantial)
    - `05_requerimientos_software.tex` (353 lines) - Software requirements
  - `pretextual/` - Pre-textual matter
    - `portada.tex` (37 lines) - Cover/portrait page (no page number displayed)
    - `aprobacion.tex` (34 lines) - Approval/signature page (page ii, ToC entry without visible title)
    - `dedicatoria.tex` (17 lines) - Dedication page (vertically centered, right-aligned, ToC entry)
    - `agradecimientos.tex` (23 lines) - Acknowledgments page (vertically centered, right-aligned, ToC entry)
    - `resumen.tex` (22 lines) - Spanish summary (uses `\sectionplain{}`)
    - `abstract.tex` (22 lines) - English summary (uses `\sectionplain{}`)
  - `postextual/` - Post-textual matter
    - `conclusion.tex` (24 lines) - Final conclusions
    - `recomendaciones.tex` (48 lines) - Recommendations
    - `anexos.tex` (206 lines) - Appendices with interview data
    - `apendices.tex` (151 lines) - Additional content

- `docs/` - Markdown documentation (9 files)
  - `STYLE_GUIDE_DOC.md` - Institutional formatting standards
  - `ERS.md` - Software Requirements Specification (100+ pages, IEEE 830 compliant)
  - `MatrizConsistencia.md` - Research consistency matrix
  - `MatrizOperacionalizacion.md` - Research operationalization matrix
  - `gantt.md` - Project timeline
  - `instrumento_entrevista/` - Interview instruments
    - `GuiaEntrevista.md` - Interview guide
    - `ConsentimientoInformado.md` - Informed consent form
    - `ProtocoloAplicacion.md` - Application protocol
    - `README.md` - Documentation
  - `diagrams/` - UML and database diagrams (10 PDFs via Git LFS)
    - `use_case/` - 4 use case diagrams
    - `class/` - 4 class diagrams
    - `erd/` - 1 entity-relationship diagram

- `templates/` - Compilation templates
  - `thesis-template.tex` - Pandoc LaTeX template for Markdown→PDF
    - Implements all institutional style requirements
    - Font fallback chain: TeX Gyre Termes → Times New Roman → Liberation Serif
    - Supports title pages, TOC, lists, section numbering, hyperlinks

- `bibliography/` - BibTeX reference files (4 files)
  - `referencias.bib` (15 KB) - Main references
  - `sistematizacion_preescritura.bib` (11 KB) - Prewriting systematization
  - `planteamiento_problema.bib` (7.4 KB) - Problem statement
  - `tesis_metodologia_desarrollo.bib` (549 bytes) - Thesis methodology

- `images/` - Image assets (tracked with Git LFS)
  - `Gantt.png` (285 KB)

- `build/` - Generated files (git-ignored)
  - `Libro.pdf` - Main thesis PDF
  - `markdown/pdf/` - Individual Markdown PDFs + merged document
  - `markdown/logs/` - Compilation logs per file

- `data/transcripciones_entrevistas/` - Interview transcriptions
  - `Entrevista_E1.md` - Interview transcript 1
  - `Entrevista_E2.md` - Interview transcript 2 (446 lines with post-notes)
  - `Entrevista_E3.md` - Interview transcript 3 (452 lines, most detailed)
  - `Entrevista_Ex_Template.md` - Template for future interviews
  - `README.md` - Documentation for interview data

### Additional Documentation Files

- `README.md` - Main project overview with badges
- `README_COMPILE.md` - LaTeX compilation guide
- `README_MARKDOWN_COMPILE.md` - Markdown compilation guide (12 KB)
- `PROJECT_STRUCTURE.md` (9.4 KB) - Detailed project organization
- `GITHUB_ACTIONS_TROUBLESHOOTING.md` (8.6 KB) - CI/CD debugging guide
- `SECURITY_PERFORMANCE.md` (6.8 KB) - Security and optimization documentation
- `LICENSE` - CC BY 4.0 for content
- `LICENSE-CODE` - MIT for code

### LaTeX Document Structure

The main thesis follows institutional format with three parts:

1. **Pre-textual** (Lowercase Roman numerals: i, ii, iii...): Cover, approval, dedicatoria, agradecimientos, Resumen, Abstract, TOC, lists (tables/figures)
2. **Textual** (Arabic numerals: 1, 2, 3...): Introduction + 5 chapters
   - Chapter 0: Introduction (overview, chapter summaries)
   - Chapter I: Marco Introductorio (problem, questions, objectives, justification)
   - Chapter II: Marco Teórico (literature review, theoretical foundation)
   - Chapter III: Marco Metodológico (research design, methodology, sampling)
   - Chapter IV: Marco Analítico (data analysis, interview transcriptions, results)
   - Chapter V: Requerimientos del Software (DreamInk system specifications)
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
- **Headers/Footers**: Empty (centered page numbers only)

These are configured in `src/config/preamble.tex` (LaTeX) and `templates/thesis-template.tex` (Markdown).

**Special formatting notes:**
- Resumen and Abstract titles use the custom `\sectionplain{}` command (defined in preamble.tex)
- This command creates centered, non-bold titles at 16pt (meeting style guide requirement: "centrado y sin negrita")
- Keywords in both summaries are in normal text (not bold, not italic)
- Babel package configured with `es-lcroman` option to force lowercase Roman numerals (i, ii, iii) instead of uppercase (I, II, III) for Spanish documents
- Pre-textual pages (aprobacion, dedicatoria, agradecimientos) have ToC entries via `\addcontentsline` but no visible section titles on the pages themselves
- Table of Contents, List of Figures (Lista de gráficos), and List of Tables (Lista de tablas):
  - Titles are centered, non-bold, 16pt (using tocloft package customization)
  - All entries and page numbers use normal font (non-bold)
  - Minimal spacing between titles and entries (0pt before/after title)
  - Consistent 1.5 line spacing for entries matching document body text

## GitHub Actions Workflows

### LaTeX CI (`.github/workflows/latex-ci.yml`)

- **Triggers**: Push to main, PRs
- **Container**: danteev/texlive:latest
- **Process**:
  1. Checkout with Git LFS support
  2. Full LaTeX compilation with `./compile.sh 1`
  3. Warning/error checking
  4. PDF validation (header check, size verification)
  5. Style Guide PDF compilation (Markdown→PDF on main branch only)
  6. GitHub Release creation (tagged `pdf-latest`)
  7. GitHub Pages deployment with custom web interface
- **Artifacts**: libro-pdf (30-day retention)
- **Output**: Deployed to https://dreamink-snpp.github.io/BookThesis/

### Markdown PDF CI (`.github/workflows/markdown-pdf-ci.yml`)

- **Triggers**: Push to main (when `docs/*.md` changes), PRs, manual workflow_dispatch
- **Container**: ubuntu-latest (installs Pandoc + LuaLaTeX)
- **Process**:
  1. Install dependencies (pandoc, texlive-luatex, TeX Gyre Termes fonts)
  2. Verify font availability
  3. Compile all Markdown files with `./compile-md.sh 2`
  4. Validation of each generated PDF
  5. Detailed error reporting with file-by-file status
  6. Artifact upload with 30-day retention
  7. GitHub Release creation (tagged `markdown-pdfs-latest`)
- **Outputs**: Individual PDFs + merged-document.pdf
- **Features**: Comprehensive error summaries, PDF integrity validation

### Claude Code Review (`.github/workflows/claude-code-review.yml`)

- Automated code review trigger configuration

### Additional Workflow (`.github/workflows/claude.yml`)

- Additional Claude integration workflow

### Viewing CI Results

- **Artifacts**: Actions tab → workflow run → download artifacts
- **Releases**: Check [Releases](../../releases) page for `pdf-latest` and `markdown-pdfs-latest`
- **GitHub Pages**: https://dreamink-snpp.github.io/BookThesis/

## Git Configuration

### Branch Structure

- **main**: Production branch (triggers full CI/CD, releases, deployments)
- **abstract-develop**: Development/working branch (current)

### Git LFS

This project uses Git LFS for binary files (images, PDFs):

```bash
git lfs install              # First-time setup
git lfs pull                 # Pull LFS objects after clone
```

**Tracked via Git LFS**:
- `*.pdf` - PDF files
- `*.png`, `*.jpg`, `*.jpeg`, `*.gif`, `*.tif`, `*.tiff` - Raster images
- `*.eps` - Vector formats

### What's Tracked/Ignored

**Tracked**:
- `src/*.tex` - LaTeX sources
- `docs/*.md` - Markdown documentation
- `bibliography/*.bib` - References (4 files)
- `images/*` - Images (via Git LFS)
- `*.sh` - Compilation scripts
- `.github/` - GitHub configuration and workflows

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
- **TeX Gyre Termes font** (Times New Roman equivalent)

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
git lfs pull                # IMPORTANT: Pull LFS objects first
./compile.sh 1              # Full LaTeX compilation
./compile-md.sh 2           # All Markdown files
```

### After Adding Citations

```bash
# Edit any bibliography/*.bib file
./compile.sh 1              # Full compilation required for bibliography
```

### Quick Text Edits

```bash
# Edit src/capitulos/*.tex or src/Libro.tex
./compile.sh 2              # Quick compilation sufficient
```

### Cleaning Build Files

```bash
./compile.sh 4              # Clean LaTeX auxiliaries
./compile-md.sh 6           # Clean Markdown builds
rm -rf build/               # Nuclear option (removes all build artifacts)
```

### Troubleshooting Compilation

```bash
./compile.sh 3                               # Check LaTeX errors/warnings
cat build/Libro.log                          # Full LaTeX log
cat build/markdown/logs/[filename].log       # Specific Markdown file log
```

**Additional Resources**:
- See `GITHUB_ACTIONS_TROUBLESHOOTING.md` for CI/CD issues
- See `SECURITY_PERFORMANCE.md` for security and optimization details
- See `README_COMPILE.md` and `README_MARKDOWN_COMPILE.md` for detailed compilation guides

## Important Constraints

1. **Path Requirements**: Always compile from repository root. LaTeX files use relative paths that won't resolve from subdirectories.

2. **Bibliography**: After modifying any `.bib` file in `bibliography/`, use full compilation (`./compile.sh 1`) to regenerate references properly.

3. **Git LFS**: After clone, always run `git lfs pull` before compiling to ensure image files and diagram PDFs are present.

4. **Output Directory**: The `build/` directory is git-ignored. CI/CD regenerates all outputs. Never commit build artifacts.

5. **Template Modifications**: Changes to `templates/thesis-template.tex` affect all Markdown compilation. Test thoroughly with `./compile-md.sh 2`.

6. **Security**: The `compile-md.sh` script includes path traversal protection. Do not bypass these security checks.

7. **Font Requirements**: Compilation requires TeX Gyre Termes font. CI/CD verifies font availability before compilation.

## Content Progress Status

**Current State** (~2,000 lines of LaTeX content):

- Introduction: Brief (24 lines)
- Marco Introductorio: Established (110 lines)
- Marco Teórico: Established (148 lines)
- Marco Metodológico: Established (83 lines)
- Marco Analítico: Most developed (797 lines with interview data)
- Requerimientos Software: Technical specifications (353 lines)
- Conclusions: Recently added (24 lines)
- Recommendations: Recently added (48 lines)
- Annexes: Interview transcriptions (206 lines)
- Appendices: Supporting materials (151 lines)

**Research Data**: 3 complete interview transcriptions integrated into analytical framework

## License

Dual-licensed project:
- **Content** (LaTeX, docs, images): Creative Commons Attribution 4.0 International (CC BY 4.0)
- **Code** (scripts, compilation tools): MIT License

> **Authors**: Fernando Cardozo and Alberto Álvarez
