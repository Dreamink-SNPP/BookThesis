# Markdown to PDF Compilation Guide

🎨 **Academic-style PDF generation from Markdown files using Pandoc + LuaLaTeX**

This guide explains how to compile Markdown documents to PDF following the institutional academic style guide.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Style Guide](#style-guide)
- [Usage](#usage)
- [GitHub Actions](#github-actions)
- [Requirements](#requirements)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Overview

The Markdown compilation system converts `.md` files in the `docs/` directory to professionally formatted PDF documents that follow the institutional thesis style guide.

### Features

✅ **Automatic style formatting** - Applies font, margins, spacing per style guide
✅ **Batch compilation** - Process multiple files at once
✅ **Interactive menu** - Easy-to-use CLI interface
✅ **GitHub Actions** - Automatic compilation on push
✅ **Document merging** - Combine multiple files into one PDF
✅ **Quality validation** - Automatic PDF validation checks

---

## 🚀 Quick Start

### Compile a single file

```bash
./compile-md.sh 1
```

Select the file number when prompted.

### Compile all Markdown files

```bash
./compile-md.sh 2
```

All files in `docs/` will be compiled to `build/markdown/pdf/`

### Interactive mode

```bash
./compile-md.sh
```

Displays a menu with all available options.

---

## 📐 Style Guide

All compiled PDFs automatically follow these specifications:

| Property | Value |
|----------|-------|
| **Font** | TeX Gyre Termes (Times New Roman) |
| **Size** | 12pt |
| **Paper** | A4 |
| **Margins (Left/Right)** | 3cm |
| **Margins (Top/Bottom)** | 2.54cm |
| **Line Spacing** | 1.5 |
| **Paragraph Spacing** | 10pt after |
| **Paragraph Indentation** | None (0pt) |
| **Section Numbering** | Automatic |
| **Headers** | Empty (configurable) |
| **Footers** | Page numbers centered |

These settings are defined in `templates/thesis-template.tex` and match the requirements in `STYLE_GUIDE_DOC.md`.

---

## 💻 Usage

### Menu Options

Run `./compile-md.sh` to see the interactive menu:

```
╔════════════════════════════════════════════════════════════════╗
║         Markdown to PDF Compilation Menu                      ║
║         Pandoc + LuaLaTeX + Academic Style Guide              ║
╚════════════════════════════════════════════════════════════════╝

  1) Compile single file (interactive selection)
  2) Compile all Markdown files in docs/
  3) Compile custom file (specify path)
  4) Compile merged document (all files combined)
  5) Show PDF files information
  6) Clean build files
  7) Show help
  8) Exit
```

### Option Descriptions

#### 1. Single File Compilation
- Shows list of available Markdown files in `docs/`
- Select file by number
- Compiles to `build/markdown/pdf/[filename].pdf`

#### 2. Batch Compilation
- Compiles ALL `.md` files in `docs/` directory
- Processes files recursively (includes subdirectories)
- Shows summary of successes/failures

#### 3. Custom File
- Specify any Markdown file path
- Useful for files outside `docs/` directory
- Full or relative paths accepted

#### 4. Merged Document
- Combines all Markdown files into single PDF
- Files sorted alphabetically
- Output: `build/markdown/pdf/merged-document.pdf`
- Useful for creating complete document compilations

#### 5. PDF Information
- Lists all generated PDFs
- Shows file size, page count, PDF version
- Requires `pdfinfo` utility

#### 6. Clean Build Files
- Removes entire `build/markdown/` directory
- Frees disk space
- Useful before fresh compilation

#### 7. Show Help
- Displays usage information
- Lists style guide specifications
- Shows requirements

---

## 🤖 GitHub Actions

### Automatic Compilation

The workflow `.github/workflows/markdown-pdf-ci.yml` automatically:

1. ✅ Triggers on:
   - Push to `main` branch (when `.md` files change)
   - Pull requests to `main`
   - Manual workflow dispatch

2. 📦 Installs:
   - Pandoc
   - LuaLaTeX
   - Required fonts and packages

3. 🔨 Compiles:
   - All Markdown files individually
   - Merged document (on `main` branch only)

4. ✅ Validates:
   - PDF file integrity
   - Minimum file size
   - Valid PDF header

5. 📤 Uploads:
   - Individual PDFs as artifacts (30-day retention)
   - Compilation logs (7-day retention)
   - Merged document (90-day retention)

6. 🎉 Creates GitHub Release:
   - Tag: `markdown-pdfs-latest`
   - Contains all compiled PDFs
   - Only on `main` branch

### Manual Trigger

You can manually trigger the workflow from GitHub:

1. Go to **Actions** tab
2. Select **Markdown to PDF CI**
3. Click **Run workflow**

### Viewing Results

After workflow completes:

- **Artifacts**: Available in workflow run summary
- **Release**: Check the [Releases](../../releases) page
- **Summary**: View compilation report in workflow logs

---

## 🔧 Requirements

### System Dependencies

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install -y \
  pandoc \
  texlive-luatex \
  texlive-latex-extra \
  texlive-fonts-extra \
  texlive-lang-spanish \
  poppler-utils
```

#### Fedora/RHEL
```bash
sudo dnf install -y \
  pandoc \
  texlive-scheme-full \
  poppler-utils
```

#### macOS
```bash
brew install pandoc
brew install --cask mactex
```

### Minimal Requirements
- **Pandoc** ≥ 2.x
- **LuaLaTeX** (from TeX Live)
- **TeX Gyre Termes font** (included in texlive-fonts-extra)

### Optional Tools
- `pdfinfo` - For detailed PDF information (from poppler-utils)

---

## 🎨 Customization

### Modifying the Template

The LaTeX template is located at `templates/thesis-template.tex`.

#### Change Font
```latex
\setmainfont{TeX Gyre Termes}
```

Replace with another font name (must be installed on system).

#### Adjust Margins
```latex
\usepackage[
    left=3cm,
    right=3cm,
    top=2.54cm,
    bottom=2.54cm
]{geometry}
```

#### Line Spacing
```latex
\onehalfspacing  % 1.5 spacing
% or
\doublespacing   % 2.0 spacing
```

#### Add Headers/Footers
```latex
\fancyhead[L]{Left Header}
\fancyhead[C]{Center Header}
\fancyhead[R]{Right Header}
```

### Per-Document Customization

Add YAML frontmatter to your Markdown files:

```yaml
---
title: "Document Title"
author: "Author Name"
date: "2025-11-14"
toc: true           # Include table of contents
toc-depth: 3        # TOC depth level
lot: true           # List of tables
lof: true           # List of figures
---

# Your content here
```

### Script Configuration

Edit `compile-md.sh` variables at the top:

```bash
TEMPLATE_FILE="templates/thesis-template.tex"
BUILD_DIR="build/markdown"
DOCS_DIR="docs"
OUTPUT_DIR="$BUILD_DIR/pdf"
```

---

## 🔍 Troubleshooting

### Problem: Font not found

**Error:**
```
! Package fontspec Error: The font "TeX Gyre Termes" cannot be found.
```

**Solution:**
```bash
# Check if font is installed
fc-list | grep "TeX Gyre Termes"

# Install fonts package
sudo apt-get install texlive-fonts-extra

# Or download manually from GUST:
# https://www.gust.org.pl/projects/e-foundry/tex-gyre/termes
```

### Problem: Pandoc not found

**Solution:**
```bash
# Ubuntu/Debian
sudo apt-get install pandoc

# Check version
pandoc --version
```

### Problem: LuaLaTeX not found

**Solution:**
```bash
# Ubuntu/Debian
sudo apt-get install texlive-luatex

# Verify installation
lualatex --version
```

### Problem: Compilation fails with LaTeX errors

**Solutions:**

1. **Check log file:**
   ```bash
   cat build/markdown/last-compilation.log
   ```

2. **Try compiling single file first:**
   ```bash
   ./compile-md.sh 1
   ```

3. **Clean and retry:**
   ```bash
   ./compile-md.sh 6  # Clean
   ./compile-md.sh 2  # Compile all
   ```

4. **Validate Markdown syntax:**
   - Check for unclosed code blocks
   - Verify image paths
   - Ensure proper heading hierarchy

### Problem: PDF is empty or corrupt

**Checklist:**
- ✅ Markdown file contains content
- ✅ No LaTeX compilation errors in log
- ✅ Template file exists and is valid
- ✅ Sufficient disk space available

### Problem: Images not appearing in PDF

**Solutions:**

1. **Use relative paths from repository root:**
   ```markdown
   ![Caption](images/diagram.png)
   ```

2. **Ensure images exist:**
   ```bash
   ls images/diagram.png
   ```

3. **Use supported formats:**
   - PNG (recommended)
   - JPG/JPEG
   - PDF

### Problem: Special characters not rendering

**Solution:**

Add to Markdown frontmatter:
```yaml
---
lang: es-ES
---
```

Or ensure UTF-8 encoding:
```bash
file -i your-file.md
```

---

## 📚 Examples

### Example 1: Simple Document

**File:** `docs/example.md`

```markdown
# Introduction

This is a simple document that will be compiled to PDF.

## Section 1

Content here.

## Section 2

More content.
```

**Compile:**
```bash
./compile-md.sh 1
# Select file number
```

**Output:** `build/markdown/pdf/example.pdf`

### Example 2: Document with Metadata

**File:** `docs/thesis-chapter.md`

```markdown
---
title: "Chapter 1: Introduction"
author: "Student Name"
date: "2025-11-14"
toc: true
---

# Background

This chapter introduces...

## Problem Statement

The research problem is...
```

**Compile:**
```bash
pandoc docs/thesis-chapter.md \
  -o output.pdf \
  --pdf-engine=lualatex \
  --template=templates/thesis-template.tex
```

### Example 3: Batch Process Specific Files

```bash
# Compile only files matching pattern
for file in docs/chapter*.md; do
  pandoc "$file" \
    -o "build/$(basename "$file" .md).pdf" \
    --pdf-engine=lualatex \
    --template=templates/thesis-template.tex
done
```

---

## 📖 Additional Resources

### Documentation

- [Pandoc Manual](https://pandoc.org/MANUAL.html)
- [LuaLaTeX Documentation](http://www.luatex.org/documentation.html)
- [TeX Gyre Fonts](https://www.gust.org.pl/projects/e-foundry/tex-gyre)

### Related Files

- `compile.sh` - LaTeX compilation script (for `src/Libro.tex`)
- `STYLE_GUIDE_DOC.md` - Institutional style guide specifications
- `README_COMPILE.md` - LaTeX compilation documentation

### Project Structure

```
BookThesis/
├── compile-md.sh              # Markdown compilation script (this feature)
├── compile.sh                 # LaTeX compilation script
├── templates/
│   └── thesis-template.tex    # Pandoc LaTeX template
├── docs/                      # Markdown source files
│   ├── *.md
│   └── */
├── build/
│   └── markdown/
│       └── pdf/               # Compiled PDF outputs
└── .github/
    └── workflows/
        └── markdown-pdf-ci.yml  # GitHub Actions workflow
```

---

## 🤝 Contributing

If you improve the template or script, please update this documentation accordingly.

### Adding Features

1. Modify `compile-md.sh` or `templates/thesis-template.tex`
2. Test thoroughly with various Markdown files
3. Update this README with new features
4. Update the GitHub Actions workflow if needed

---

## 📄 License

- **Script**: MIT License
- **Template**: MIT License
- **Documentation**: CC BY-SA 4.0

Copyright (c) 2025 Fernando Cardozo and Alberto Álvarez

---

## ✨ Summary

This Markdown compilation system provides:

- ✅ Professional PDF output following academic standards
- ✅ Easy-to-use CLI interface
- ✅ Automated CI/CD with GitHub Actions
- ✅ Flexible customization options
- ✅ Comprehensive documentation

For questions or issues, please refer to the troubleshooting section or check the compilation logs.

**Happy writing! 📝**
