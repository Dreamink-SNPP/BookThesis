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

# ============================================================================
# COMPILATION FUNCTIONS
# ============================================================================

compile_markdown_file() {
    local input_file="$1"
    local output_name="$2"
    local extra_args="${3:-}"

    if [ ! -f "$input_file" ]; then
        print_error "Input file not found: $input_file"
        return 1
    fi

    local output_file="$OUTPUT_DIR/${output_name}.pdf"

    print_step "Compiling: $(basename "$input_file") → $(basename "$output_file")"

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Compile with pandoc
    pandoc "$input_file" \
        --output="$output_file" \
        --from=markdown \
        --to=pdf \
        --pdf-engine=lualatex \
        --template="$TEMPLATE_FILE" \
        --variable=fontsize=12pt \
        --variable=papersize=a4 \
        --variable=geometry:left=3cm \
        --variable=geometry:right=3cm \
        --variable=geometry:top=2.54cm \
        --variable=geometry:bottom=2.54cm \
        --variable=linestretch=1.5 \
        --number-sections \
        --toc \
        --toc-depth=3 \
        $extra_args \
        2>&1 | tee "$BUILD_DIR/last-compilation.log"

    local exit_code=${PIPESTATUS[0]}

    if [ $exit_code -eq 0 ] && [ -f "$output_file" ]; then
        local size=$(du -h "$output_file" | cut -f1)
        if command -v pdfinfo &> /dev/null; then
            local pages=$(pdfinfo "$output_file" 2>/dev/null | grep Pages | awk '{print $2}')
            print_success "Compiled successfully: $output_file ($pages pages, $size)"
        else
            print_success "Compiled successfully: $output_file ($size)"
        fi
        return 0
    else
        print_error "Compilation failed for: $input_file"
        print_info "Check log: $BUILD_DIR/last-compilation.log"
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

    echo ""
    compile_markdown_file "$selected_file" "$output_name"
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
    echo ""

    local success_count=0
    local fail_count=0

    for file in "${files[@]}"; do
        local output_name=$(basename "$file" .md)

        if compile_markdown_file "$file" "$output_name"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
        echo ""
    done

    echo "═══════════════════════════════════════════"
    print_info "Compilation Summary:"
    print_success "Successful: $success_count"
    if [ $fail_count -gt 0 ]; then
        print_error "Failed: $fail_count"
    fi
    echo "═══════════════════════════════════════════"
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

    echo ""
    compile_markdown_file "$input_file" "$output_name"
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

    if [ ! -d "$OUTPUT_DIR" ] || [ -z "$(ls -A "$OUTPUT_DIR" 2>/dev/null)" ]; then
        print_warning "No PDF files found in $OUTPUT_DIR/"
        return 1
    fi

    for pdf in "$OUTPUT_DIR"/*.pdf; do
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
  1  - Compile single file (interactive selection)
  2  - Compile all Markdown files in docs/
  3  - Compile custom file (specify path)
  4  - Compile merged document (all files combined)
  5  - Show PDF files information
  6  - Clean build files
  7  - Show this help
  8  - Exit

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

  1) Compile single file (interactive selection)
  2) Compile all Markdown files in docs/
  3) Compile custom file (specify path)
  4) Compile merged document (all files combined)
  5) Show PDF files information
  6) Clean build files
  7) Show help
  8) Exit

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
