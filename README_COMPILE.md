# LaTeX Compilation Script

## Usage

### Interactive mode

Run the interactive menu:

```bash
./compile.sh
```

### Non-interactive mode (direct execution)

Execute specific option directly:

```bash
./compile.sh 1    # Full compilation
./compile.sh 2    # Quick compilation
./compile.sh 3    # Check warnings and errors
./compile.sh 4    # Clean auxiliary files
./compile.sh 5    # Show PDF information
```

This mode is useful for automation and scripting.

## Menu Options

1. **Full compilation** - Complete build sequence:
   - LuaLaTeX (first pass) - processes document structure
   - Biber - processes bibliography
   - LuaLaTeX (second pass) - incorporates bibliography
   - LuaLaTeX (final pass) - resolves all references

   Use this when:
   - You've added new citations
   - Starting fresh compilation
   - Before final submission

2. **Quick compilation** - Single LuaLaTeX pass

   Use this when:
   - Making small text changes
   - No bibliography updates needed
   - Quick preview during editing

3. **Check warnings and errors** - Analyzes compilation log

   Shows:
   - Number of errors found
   - Number of warnings found
   - First 10 of each for quick review

4. **Clean auxiliary files** - Removes temporary files

   Removes: `*.aux`, `*.log`, `*.out`, `*.toc`, `*.bbl`, `*.bcf`, `*.blg`, `*.run.xml`, `*.lof`, `*.lot`

   Use this when:
   - Starting fresh compilation
   - Files are corrupted
   - Troubleshooting issues

5. **Show PDF information** - Display output file details

   Shows:
   - Number of pages
   - File size
   - PDF version
   - Creation date

6. **Exit** - Close the menu

## Features

- Color-coded output (info, success, warning, error)
- Progress tracking for full compilation
- Automatic error detection
- Clean, interactive interface
- Compatible with automation tools (Claude Code)

## Requirements

### Essential

- `lualatex` (from texlive-luatex or texlive-full)
- `biber` (bibliography processor)
- `git-lfs` (Git Large File Storage for images and PDFs)

### Optional

- `pdfinfo` (for PDF details in option 5)

### Installation

Ubuntu/Debian:

```bash
apt-get install texlive-luatex biber git-lfs
git lfs install
```

After cloning the repository:

```bash
git lfs pull
```

## Notes

The script is configured for `src/Libro.tex` as the main file. If your main file has a different name, edit the `MAIN_FILE` variable at the top of `compile.sh`.

## Important: Path Requirements

The compilation script **must be run from the repository root directory**. The LaTeX source file uses paths relative to the repository root:

- `bibliography/referencias.bib` - Bibliography files
- `images/Gantt.png` - Image files

**Do not** try to compile `src/Libro.tex` directly from the `src/` directory. Always use:

```bash
./compile.sh
```

from the repository root. The script automatically handles the correct paths and output directories.
