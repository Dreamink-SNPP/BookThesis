#!/bin/bash
# SPDX-License-Identifier: MIT
# Copyright (c) 2025 Fernando Cardozo and Alberto Álvarez

# ============================================================================
# Markdown to PDF Compilation Script
# Converts Markdown files to PDF using Pandoc + LuaLaTeX
# Follows institutional style guide requirements
# ============================================================================

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

TEMPLATE_FILE="templates/thesis-template.tex"
BUILD_DIR="build/markdown"
DOCS_DIR="docs"
OUTPUT_DIR="$BUILD_DIR/pdf"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Performance: Enable parallel compilation (requires GNU parallel)
# Set to 0 to disable, or number of jobs (e.g., 4)
PARALLEL_JOBS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${MAGENTA}[STEP]${NC} $1"
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

check_dependencies() {
    local missing_deps=()

    if ! command -v pandoc &> /dev/null; then
        missing_deps+=("pandoc")
    fi

    if ! command -v lualatex &> /dev/null; then
        missing_deps+=("lualatex")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        print_info "Install with:"
        echo "  Ubuntu/Debian: sudo apt-get install pandoc texlive-luatex texlive-fonts-extra"
        echo "  Fedora: sudo dnf install pandoc texlive-scheme-full"
        echo "  macOS: brew install pandoc mactex"
        return 1
    fi

    return 0
}

check_template() {
    if [ ! -f "$TEMPLATE_FILE" ]; then
        print_error "Template file not found: $TEMPLATE_FILE"
        return 1
    fi
    return 0
}

# Security: Validate file path to prevent path traversal attacks
validate_file_path() {
    local file_path="$1"

    # Check for path traversal attempts
    if [[ "$file_path" =~ \.\. ]]; then
        print_error "Security: Path traversal not allowed (..)"
        return 1
    fi

    # Check for absolute paths outside repository
    if [[ "$file_path" = /* ]]; then
        # Resolve to canonical path
        local canonical_path=$(readlink -f "$file_path" 2>/dev/null || realpath "$file_path" 2>/dev/null)
        if [ -z "$canonical_path" ]; then
            print_error "Security: Cannot resolve path: $file_path"
            return 1
        fi

        # Ensure it's within repository root
        if [[ ! "$canonical_path" =~ ^"$REPO_ROOT" ]]; then
            print_error "Security: File must be within repository: $file_path"
            return 1
        fi
    fi

    return 0
}

# Detect if document needs TOC based on content
should_generate_toc() {
    local input_file="$1"

    # Check YAML frontmatter for toc: true/false
    if grep -q "^toc: *false" "$input_file" 2>/dev/null; then
        return 1  # Don't generate TOC
    fi

    if grep -q "^toc: *true" "$input_file" 2>/dev/null; then
        return 0  # Generate TOC
    fi

    # Auto-detect: count headings (## or more)
    local heading_count=$(grep -c "^##" "$input_file" 2>/dev/null || echo "0")

    # Generate TOC if document has 3 or more sections
    if [ "$heading_count" -ge 3 ]; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# COMPILATION FUNCTIONS
# ============================================================================

# Preprocess markdown to handle GitHub-specific extensions
preprocess_markdown() {
    local input_file="$1"
    local temp_file="$2"

    # Copy file and process GitHub-specific syntax
    sed -E '
        # Convert GitHub alerts to blockquotes with bold labels
        s/^> \[!NOTE\]/> **Nota:**/g
        s/^> \[!WARNING\]/> **Advertencia:**/g
        s/^> \[!TIP\]/> **Consejo:**/g
        s/^> \[!IMPORTANT\]/> **Importante:**/g
        s/^> \[!CAUTION\]/> **Precaución:**/g
    ' "$input_file" > "$temp_file"

    # Handle Mermaid diagrams - replace with placeholder text
    # This is a simple solution; for production, consider using mermaid-filter
    local in_mermaid=false
    local temp_file2="${temp_file}.tmp"

    while IFS= read -r line; do
        if [[ "$line" == '```mermaid' ]]; then
            in_mermaid=true
            echo "" >> "$temp_file2"
            echo "> **Diagrama:** El diagrama original está disponible en la versión web del documento." >> "$temp_file2"
            echo "" >> "$temp_file2"
        elif [[ "$line" == '```' ]] && [ "$in_mermaid" = true ]; then
            in_mermaid=false
        elif [ "$in_mermaid" = false ]; then
            echo "$line" >> "$temp_file2"
        fi
    done < "$temp_file"

    mv "$temp_file2" "$temp_file"
}

compile_markdown_file() {
    local input_file="$1"
    local output_name="$2"
    local extra_args="${3:-}"
    local skip_toc_detection="${4:-false}"

    # Security: Validate file path
    if ! validate_file_path "$input_file"; then
        return 1
    fi

    # File existence check (note: TOCTOU is mitigated by pandoc's own error handling)
    if [ ! -f "$input_file" ]; then
        print_error "Input file not found: $input_file"
        return 1
    fi

    local output_file="$OUTPUT_DIR/${output_name}.pdf"

    print_step "Compiling: $(basename "$input_file") → $(basename "$output_file")"

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Preprocess markdown to handle GitHub-specific extensions
    local temp_input="$BUILD_DIR/temp_${output_name}.md"
    preprocess_markdown "$input_file" "$temp_input"

    # Build pandoc command with conditional TOC and numbering
    local pandoc_args=(
        "$temp_input"
        --output="$output_file"
        --from=markdown+yaml_metadata_block
        --to=pdf
        --pdf-engine=lualatex
        --pdf-engine-opt=-interaction=nonstopmode
        --template="$TEMPLATE_FILE"
        --variable=fontsize=12pt
        --variable=papersize=a4
        --variable=geometry:left=3cm
        --variable=geometry:right=3cm
        --variable=geometry:top=2.54cm
        --variable=geometry:bottom=2.54cm
        --variable=linestretch=1.5
    )

    # Conditionally add TOC and section numbering together
    # (numbering only makes sense with TOC)
    if [ "$skip_toc_detection" = "false" ] && should_generate_toc "$temp_input"; then
        pandoc_args+=(--toc --toc-depth=3 --number-sections)
    fi

    # Add extra args if provided (can override TOC and numbering)
    if [ -n "$extra_args" ]; then
        pandoc_args+=($extra_args)
    fi

    # Compile with pandoc (atomic operation, handles TOCTOU internally)
    # Use PIPESTATUS to capture pandoc's exit code, not tee's
    set +e  # Temporarily disable exit on error
    pandoc "${pandoc_args[@]}" 2>&1 | tee "$BUILD_DIR/last-compilation.log"
    local exit_code=${PIPESTATUS[0]}  # Get pandoc's exit code, not tee's
    set -e  # Re-enable exit on error

    # Verify successful compilation
    if [ $exit_code -eq 0 ] && [ -f "$output_file" ]; then
        local size=$(du -h "$output_file" | cut -f1)
        if command -v pdfinfo &> /dev/null; then
            local pages=$(pdfinfo "$output_file" 2>/dev/null | grep Pages | awk '{print $2}')
            print_success "Compiled successfully: $output_file ($pages pages, $size)"
        else
            print_success "Compiled successfully: $output_file ($size)"
        fi
        # Clean up temporary file
        rm -f "$temp_input" "${temp_input}.tmp"
        return 0
    else
        print_error "Compilation failed for: $input_file"
        print_info "Check log: $BUILD_DIR/last-compilation.log"

        # Show error details
        if [ -f "$BUILD_DIR/last-compilation.log" ]; then
            echo ""
            print_error "Compilation error details:"
            # Show pandoc errors (lines with ! or Error)
            if grep -E "^!|[Ee]rror" "$BUILD_DIR/last-compilation.log" > /dev/null 2>&1; then
                grep -E "^!|[Ee]rror" "$BUILD_DIR/last-compilation.log" | head -20
            else
                # If no clear errors, show last 10 lines
                tail -n 10 "$BUILD_DIR/last-compilation.log"
            fi
        fi
        # Clean up temporary file even on error
        rm -f "$temp_input" "${temp_input}.tmp"
        return 1
    fi
}

compile_single_file() {
    print_info "=== Single File Compilation ==="
    echo ""

    if ! check_dependencies || ! check_template; then
        return 1
    fi

    # Show available markdown files
    echo "Available Markdown files:"
    echo ""

    local files=($(find "$DOCS_DIR" -name "*.md" -type f | sort))

    if [ ${#files[@]} -eq 0 ]; then
        print_warning "No Markdown files found in $DOCS_DIR/"
        return 1
    fi

    local i=1
    for file in "${files[@]}"; do
        echo "  $i) ${file#$DOCS_DIR/}"
        ((i++))
    done
    echo ""

    read -p "Select file number [1-${#files[@]}]: " file_num

    if ! [[ "$file_num" =~ ^[0-9]+$ ]] || [ "$file_num" -lt 1 ] || [ "$file_num" -gt ${#files[@]} ]; then
        print_error "Invalid selection"
        return 1
    fi

    local selected_file="${files[$((file_num-1))]}"
    local output_name=$(basename "$selected_file" .md)

    # Ask about TOC and numbering
    echo ""
    echo "Table of Contents & Section Numbering options:"
    echo "  y = Generate TOC + numbering (always)"
    echo "  n = Skip TOC + numbering (cleaner for simple docs)"
    echo "  a = Auto-detect (default: 3+ sections)"
    echo ""
    read -p "Generate TOC & Numbering? [y/n/a] (default: a): " toc_choice
    toc_choice=${toc_choice:-a}  # Default to auto

    local extra_args=""
    local skip_auto="false"

    case "${toc_choice,,}" in
        y|yes)
            print_info "TOC & Numbering: Enabled (forced)"
            extra_args="--toc --toc-depth=3 --number-sections"
            skip_auto="true"
            ;;
        n|no)
            print_info "TOC & Numbering: Disabled (forced)"
            # Don't add any TOC or numbering flags - cleaner for simple docs
            extra_args=""
            skip_auto="true"
            ;;
        a|auto)
            if should_generate_toc "$selected_file"; then
                print_info "TOC & Numbering: Enabled (auto-detected)"
            else
                print_info "TOC & Numbering: Disabled (auto-detected)"
            fi
            # Let the compile function handle auto-detection
            skip_auto="false"
            ;;
        *)
            print_warning "Invalid choice, using auto-detect"
            skip_auto="false"
            ;;
    esac

    echo ""

    # Compile with appropriate TOC settings
    compile_markdown_file "$selected_file" "$output_name" "$extra_args" "$skip_auto"
}

compile_all_files() {
    print_info "=== Batch Compilation (All Files) ==="
    echo ""

    if ! check_dependencies || ! check_template; then
        return 1
    fi

    local files=($(find "$DOCS_DIR" -name "*.md" -type f | sort))

    if [ ${#files[@]} -eq 0 ]; then
        print_warning "No Markdown files found in $DOCS_DIR/"
        return 1
    fi

    print_info "Found ${#files[@]} Markdown file(s)"

    # Check if parallel is available and enabled
    if [ "$PARALLEL_JOBS" -gt 0 ] && command -v parallel &> /dev/null; then
        print_info "Using parallel compilation with $PARALLEL_JOBS jobs"
        echo ""

        # Export functions and variables for GNU parallel
        export -f compile_markdown_file validate_file_path should_generate_toc
        export -f print_info print_success print_error print_warning print_step
        export TEMPLATE_FILE BUILD_DIR OUTPUT_DIR REPO_ROOT
        export RED GREEN YELLOW BLUE MAGENTA CYAN NC

        # Compile in parallel (don't fail fast)
        local failed_files=()
        printf "%s\n" "${files[@]}" | \
            parallel --jobs "$PARALLEL_JOBS" --line-buffer --keep-order \
            'compile_markdown_file {} $(basename {} .md) || echo "FAILED:{}" >&2; echo ""'

        local exit_code=$?
    else
        if [ "$PARALLEL_JOBS" -gt 0 ]; then
            print_warning "GNU parallel not found, using sequential compilation"
        fi
        echo ""

        # Sequential compilation (continue on errors)
        local success_count=0
        local fail_count=0
        local failed_files=()

        for file in "${files[@]}"; do
            local output_name=$(basename "$file" .md)

            if compile_markdown_file "$file" "$output_name"; then
                ((success_count++))
            else
                ((fail_count++))
                failed_files+=("$file")
            fi
            echo ""
        done

        echo "═══════════════════════════════════════════"
        print_info "Compilation Summary:"
        print_success "Successful: $success_count / ${#files[@]}"

        if [ $fail_count -gt 0 ]; then
            print_error "Failed: $fail_count / ${#files[@]}"
            echo ""
            print_info "Failed files:"
            for failed_file in "${failed_files[@]}"; do
                echo "  • $(basename "$failed_file")"
            done
            echo ""
        fi
        echo "═══════════════════════════════════════════"

        # Return error if any files failed
        if [ $fail_count -gt 0 ]; then
            return 1
        fi
    fi

    return 0
}

compile_custom_file() {
    print_info "=== Custom File Compilation ==="
    echo ""

    if ! check_dependencies || ! check_template; then
        return 1
    fi

    read -p "Enter path to Markdown file: " input_file

    if [ ! -f "$input_file" ]; then
        print_error "File not found: $input_file"
        return 1
    fi

    local output_name=$(basename "$input_file" .md)

    # Ask about TOC and numbering
    echo ""
    echo "Table of Contents & Section Numbering options:"
    echo "  y = Generate TOC + numbering (always)"
    echo "  n = Skip TOC + numbering (cleaner for simple docs)"
    echo "  a = Auto-detect (default: 3+ sections)"
    echo ""
    read -p "Generate TOC & Numbering? [y/n/a] (default: a): " toc_choice
    toc_choice=${toc_choice:-a}  # Default to auto

    local extra_args=""
    local skip_auto="false"

    case "${toc_choice,,}" in
        y|yes)
            print_info "TOC & Numbering: Enabled (forced)"
            extra_args="--toc --toc-depth=3 --number-sections"
            skip_auto="true"
            ;;
        n|no)
            print_info "TOC & Numbering: Disabled (forced)"
            # Don't add any TOC or numbering flags - cleaner for simple docs
            extra_args=""
            skip_auto="true"
            ;;
        a|auto)
            if should_generate_toc "$input_file"; then
                print_info "TOC & Numbering: Enabled (auto-detected)"
            else
                print_info "TOC & Numbering: Disabled (auto-detected)"
            fi
            # Let the compile function handle auto-detection
            skip_auto="false"
            ;;
        *)
            print_warning "Invalid choice, using auto-detect"
            skip_auto="false"
            ;;
    esac

    echo ""

    # Compile with appropriate TOC settings
    compile_markdown_file "$input_file" "$output_name" "$extra_args" "$skip_auto"
}

compile_merged_document() {
    print_info "=== Merged Document Compilation ==="
    echo ""

    if ! check_dependencies || ! check_template; then
        return 1
    fi

    local files=($(find "$DOCS_DIR" -name "*.md" -type f | sort))

    if [ ${#files[@]} -eq 0 ]; then
        print_warning "No Markdown files found in $DOCS_DIR/"
        return 1
    fi

    print_info "Found ${#files[@]} Markdown file(s) to merge"
    echo ""

    # Create temporary merged file
    local temp_file="$BUILD_DIR/merged-document.md"
    mkdir -p "$BUILD_DIR"

    # Merge all files
    print_step "Merging files..."
    > "$temp_file"  # Clear file

    for file in "${files[@]}"; do
        echo "---" >> "$temp_file"
        echo "" >> "$temp_file"
        cat "$file" >> "$temp_file"
        echo "" >> "$temp_file"
        echo "" >> "$temp_file"
    done

    print_success "Files merged successfully"
    echo ""

    compile_markdown_file "$temp_file" "merged-document"
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

show_pdf_info() {
    print_info "=== PDF Files Information ==="
    echo ""

    if [ ! -d "$OUTPUT_DIR" ]; then
        print_warning "Output directory does not exist: $OUTPUT_DIR/"
        print_info "Compile some files first with option 1 or 2"
        return 0
    fi

    # Check if any PDF files exist
    local pdf_count=$(find "$OUTPUT_DIR" -name "*.pdf" -type f 2>/dev/null | wc -l)

    if [ "$pdf_count" -eq 0 ]; then
        print_warning "No PDF files found in $OUTPUT_DIR/"
        print_info "Compile some files first with option 1 or 2"
        return 0
    fi

    print_info "Found $pdf_count PDF file(s)"
    echo ""

    for pdf in "$OUTPUT_DIR"/*.pdf; do
        # Double-check file exists (in case of race condition)
        if [ ! -f "$pdf" ]; then
            continue
        fi

        local filename=$(basename "$pdf")
        local size=$(du -h "$pdf" | cut -f1)

        echo -e "${CYAN}$filename${NC}"
        echo "  Location: $pdf"
        echo "  Size: $size"

        if command -v pdfinfo &> /dev/null; then
            local pages=$(pdfinfo "$pdf" 2>/dev/null | grep Pages | awk '{print $2}')
            local pdf_version=$(pdfinfo "$pdf" 2>/dev/null | grep "PDF version" | awk '{print $3}')
            echo "  Pages: $pages"
            echo "  PDF version: $pdf_version"
        fi
        echo ""
    done
}

clean_files() {
    print_info "Cleaning build files..."

    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
        print_success "Build directory cleaned: $BUILD_DIR"
    else
        print_info "Build directory does not exist"
    fi
}

show_help() {
    cat << EOF
╔════════════════════════════════════════════════════════════════╗
║         Markdown to PDF Compilation Script                    ║
║         Using Pandoc + LuaLaTeX                                ║
╚════════════════════════════════════════════════════════════════╝

USAGE:
  ./compile-md.sh [option]

OPTIONS:
  1  - Compile single file (interactive selection + TOC choice)
  2  - Compile all Markdown files in docs/
  3  - Compile custom file (specify path + TOC choice)
  4  - Compile merged document (all files combined)
  5  - Show PDF files information
  6  - Clean build files
  7  - Show this help
  8  - Exit

TABLE OF CONTENTS & NUMBERING OPTIONS:
  • Options 1 & 3 ask interactively: y/n/auto
  • y = TOC + section numbering enabled
  • n = TOC + section numbering disabled (cleaner for simple docs)
  • a = Auto-detect both (3+ sections = enabled)
  • Option 2 (batch) uses auto-detection for each file
  • YAML override: Add 'toc: true' or 'toc: false' in frontmatter

STYLE GUIDE APPLIED:
  • Font: TeX Gyre Termes (Times New Roman)
  • Size: 12pt
  • Margins: 3cm (left/right), 2.54cm (top/bottom)
  • Line spacing: 1.5
  • Paragraph spacing: 10pt after
  • Section numbering: Automatic
  • Headers/Footers: Page numbers centered at bottom

REQUIREMENTS:
  • pandoc
  • lualatex (texlive-luatex)
  • texlive-fonts-extra (for TeX Gyre Termes font)

OUTPUT:
  All PDF files are saved to: $OUTPUT_DIR/

EXAMPLES:
  ./compile-md.sh           # Interactive mode
  ./compile-md.sh 1         # Single file compilation
  ./compile-md.sh 2         # Batch compile all files

EOF
}

# ============================================================================
# MENU FUNCTIONS
# ============================================================================

show_menu() {
    clear
    cat << EOF
╔════════════════════════════════════════════════════════════════╗
║         Markdown to PDF Compilation Menu                      ║
║         Pandoc + LuaLaTeX + Academic Style Guide              ║
╚════════════════════════════════════════════════════════════════╝

  1) Compile single file (interactive + TOC choice)
  2) Compile all Markdown files in docs/
  3) Compile custom file (specify path + TOC choice)
  4) Compile merged document (all files combined)
  5) Show PDF files information
  6) Clean build files
  7) Show help
  8) Exit

  💡 Options 1 & 3 let you choose: TOC+Numbering Yes/No/Auto

EOF
}

execute_option() {
    local choice=$1
    case $choice in
        1)
            compile_single_file
            ;;
        2)
            compile_all_files
            ;;
        3)
            compile_custom_file
            ;;
        4)
            compile_merged_document
            ;;
        5)
            show_pdf_info
            ;;
        6)
            clean_files
            ;;
        7)
            show_help
            ;;
        8)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option. Please select 1-8."
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

# Check if argument provided (non-interactive mode)
if [ $# -gt 0 ]; then
    execute_option "$1"
    exit $?
fi

# Interactive mode - Main loop
while true; do
    show_menu
    read -p "Select an option [1-8]: " choice
    echo ""

    execute_option "$choice"

    echo ""
    read -p "Press Enter to continue..."
done
