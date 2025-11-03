# LaTeX Compilation Script

## Usage

Run the interactive menu:

```bash
./compile.sh
```

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

- `lualatex` (from texlive)
- `biber` (bibliography processor)
- `pdfinfo` (optional, for PDF details)

## Notes

The script is configured for `Libro.tex` as the main file. If your main file has a different name, edit the `MAIN_FILE` variable at the top of `compile.sh`.
