# Project Organization & Structure

## 📁 Directory Layout

```
BookThesis/
│
├── 📄 README.md                           # Main project documentation
├── 📄 README_COMPILE.md                   # LaTeX compilation guide
├── 📄 README_MARKDOWN_COMPILE.md          # Markdown compilation guide
├── 📄 STYLE_GUIDE_DOC.md                  # Institutional style guide
├── 📄 PROJECT_STRUCTURE.md               # This file - project organization
│
├── 🔨 compile.sh                          # LaTeX → PDF compilation script
├── 🔨 compile-md.sh                       # Markdown → PDF compilation script
│
├── 📁 src/                                # LaTeX source files
│   ├── Libro.tex                         # Main LaTeX document
│   ├── chapters/                         # Book chapters
│   └── sections/                         # Document sections
│
├── 📁 docs/                               # Markdown documentation files
│   ├── TiposInvestigacionCientifica.md
│   ├── ProtocoloBasico.md
│   ├── MatrizOperacionalizacion.md
│   ├── MatrizConsistencia.md
│   ├── gantt.md
│   ├── instrumento_entrevista/
│   │   ├── GuiaEntrevista.md
│   │   ├── ConsentimientoInformado.md
│   │   ├── ProtocoloAplicacion.md
│   │   └── README.md
│   └── diagrams/
│       ├── use_case/
│       ├── class/
│       └── erd/
│
├── 📁 templates/                          # Compilation templates
│   └── thesis-template.tex               # Pandoc LaTeX template
│
├── 📁 bibliography/                       # Bibliography files
│   └── referencias.bib                   # BibTeX references
│
├── 📁 images/                             # Image assets
│   ├── Gantt.png
│   └── ...
│
├── 📂 build/                              # ⚠️ Generated files (git-ignored)
│   ├── Libro.pdf                         # ← LaTeX compiled PDF
│   ├── Libro.aux                         # LaTeX auxiliary files
│   ├── Libro.log                         # LaTeX logs
│   └── markdown/                         # Markdown compilation output
│       ├── pdf/                          # ← Markdown compiled PDFs
│       │   ├── TiposInvestigacionCientifica.pdf
│       │   ├── ProtocoloBasico.pdf
│       │   ├── MatrizOperacionalizacion.pdf
│       │   ├── GuiaEntrevista.pdf
│       │   └── merged-document.pdf       # All docs combined
│       └── last-compilation.log          # Pandoc compilation log
│
└── 📁 .github/                            # GitHub configuration
    ├── workflows/                        # CI/CD workflows
    │   ├── latex-ci.yml                  # LaTeX compilation automation
    │   ├── markdown-pdf-ci.yml           # Markdown compilation automation
    │   └── claude-code-review.yml        # Code review automation
    └── pages-template/                   # GitHub Pages assets
        ├── index.html
        └── styles.css
```

---

## 🎯 Output Locations Summary

### LaTeX Compilation (`./compile.sh`)

| Source | Output Location | Description |
|--------|----------------|-------------|
| `src/Libro.tex` | `build/Libro.pdf` | Main thesis book |
| `src/**/*.tex` | `build/*.aux` | Auxiliary files |
| - | `build/*.log` | Compilation logs |

**Quick access:**
```bash
./compile.sh 1      # Full compilation
ls -lh build/*.pdf  # View output
```

### Markdown Compilation (`./compile-md.sh`)

| Source | Output Location | Description |
|--------|----------------|-------------|
| `docs/**/*.md` | `build/markdown/pdf/[name].pdf` | Individual PDFs |
| All `docs/*.md` | `build/markdown/pdf/merged-document.pdf` | Combined document |
| - | `build/markdown/last-compilation.log` | Compilation log |

**Quick access:**
```bash
./compile-md.sh 2                    # Compile all
ls -lh build/markdown/pdf/           # View outputs
./compile-md.sh 5                    # Show PDF info
```

---

## 🔍 Finding Compiled Documents

### For Developers (Local)

```bash
# List all compiled PDFs
find build -name "*.pdf" -type f

# LaTeX output
ls build/Libro.pdf

# Markdown outputs
ls build/markdown/pdf/

# With details
du -h build/**/*.pdf
```

### For Readers (GitHub)

#### Option 1: GitHub Actions Artifacts

1. Go to [Actions](../../actions) tab
2. Click on latest successful workflow run
3. Download artifacts:
   - **libro-pdf** (LaTeX compilation)
   - **markdown-pdfs-NNNN** (Markdown compilation)

#### Option 2: GitHub Releases

1. Go to [Releases](../../releases) page
2. Download from:
   - **Latest PDF Build** (LaTeX book)
   - **Latest Markdown PDFs** (All Markdown docs)

#### Option 3: GitHub Pages

- Visit: https://dreamink-snpp.github.io/BookThesis/
- Direct PDF link: https://dreamink-snpp.github.io/BookThesis/Libro.pdf

---

## 🔄 Compilation Workflows

### LaTeX Workflow (`.github/workflows/latex-ci.yml`)

```
Trigger: Push to main, PRs
↓
Clone repository + LFS
↓
Compile: src/Libro.tex
↓
Validate: PDF integrity
↓
Upload: Artifacts + Release
↓
Deploy: GitHub Pages
```

### Markdown Workflow (`.github/workflows/markdown-pdf-ci.yml`)

```
Trigger: Push to main (when docs/*.md changes), PRs
↓
Install: Pandoc + LuaLaTeX
↓
Compile: All docs/*.md → PDFs
↓
Validate: Each PDF integrity
↓
Create: Merged document
↓
Upload: Artifacts + Release
```

---

## 📊 File Organization Best Practices

### Source Files (Tracked by Git)

✅ **Keep in Git:**
- `src/*.tex` - LaTeX source
- `docs/*.md` - Markdown documentation
- `bibliography/*.bib` - References
- `images/*` - Images (with Git LFS)
- `templates/*.tex` - Templates
- `*.sh` - Compilation scripts

### Build Files (Git-Ignored)

❌ **NOT in Git** (automatically ignored via `.gitignore`):
- `build/` - ALL compilation outputs
- `*.aux`, `*.log`, `*.toc` - LaTeX auxiliary files
- `*.pdf` (except tracked LFS files)

### Why This Organization?

1. **Clear Separation**: Source vs. generated files
2. **Easy Navigation**: Predictable locations
3. **Git Efficiency**: Don't track generated files
4. **CI/CD Friendly**: Scripts know where to look
5. **User Friendly**: Simple paths to remember

---

## 🎓 Style Guide Compliance

Both compilation systems follow: `STYLE_GUIDE_DOC.md`

| Property | Value |
|----------|-------|
| Font | TeX Gyre Termes (Times New Roman) |
| Size | 12pt |
| Margins | 3cm (L/R), 2.54cm (T/B) |
| Line spacing | 1.5 |
| Section numbering | Automatic |

---

## 🛠️ Quick Commands Reference

### Compilation

```bash
# LaTeX
./compile.sh 1          # Full compilation
./compile.sh 2          # Quick compilation
./compile.sh 5          # Show PDF info

# Markdown
./compile-md.sh 2       # Compile all
./compile-md.sh 1       # Compile single file
./compile-md.sh 4       # Create merged document
./compile-md.sh 5       # Show PDF info
```

### File Management

```bash
# View outputs
ls -lh build/*.pdf
ls -lh build/markdown/pdf/

# Clean builds
./compile.sh 4          # Clean LaTeX build
./compile-md.sh 6       # Clean Markdown build
rm -rf build/           # Clean everything

# View logs
cat build/Libro.log                        # LaTeX log
cat build/markdown/last-compilation.log    # Markdown log
```

### Git Operations

```bash
# Check status (build/ should be ignored)
git status

# Verify gitignore
git check-ignore build/
git check-ignore build/markdown/pdf/*.pdf
```

---

## 📈 Workflow Badges

Add to README.md to show build status:

```markdown
[![LaTeX CI](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/latex-ci.yml/badge.svg?branch=main)](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/latex-ci.yml)
[![Markdown to PDF CI](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/markdown-pdf-ci.yml/badge.svg?branch=main)](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/markdown-pdf-ci.yml)
```

---

## 🔗 Related Documentation

- [README.md](README.md) - Main project information
- [README_COMPILE.md](README_COMPILE.md) - LaTeX compilation guide
- [README_MARKDOWN_COMPILE.md](README_MARKDOWN_COMPILE.md) - Markdown compilation guide
- [STYLE_GUIDE_DOC.md](STYLE_GUIDE_DOC.md) - Institutional formatting rules

---

## 🎯 Summary

### For Writers
- Put LaTeX in `src/`
- Put Markdown in `docs/`
- Run `./compile.sh` or `./compile-md.sh`
- Find PDFs in `build/`

### For Readers
- Download from [Releases](../../releases)
- Or get from [Actions](../../actions) artifacts
- Or view on [GitHub Pages](https://dreamink-snpp.github.io/BookThesis/)

### For Maintainers
- Source files are version controlled
- Build outputs are auto-generated
- CI/CD handles compilation
- Everything follows style guide

**Everything has a place. Everything in its place. 📂✨**
