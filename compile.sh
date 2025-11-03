#!/bin/bash

# LaTeX Compilation Menu
# Compatible with LuaLaTeX and Biber

MAIN_FILE="Libro.tex"
PDF_OUTPUT="Libro.pdf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
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

# Function to compile full sequence
full_compile() {
    print_info "Starting full compilation sequence..."
    echo ""

    print_info "Step 1/4: Running LuaLaTeX (first pass)..."
    lualatex -interaction=nonstopmode "$MAIN_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_success "LuaLaTeX first pass completed"
    else
        print_error "LuaLaTeX first pass failed"
        return 1
    fi

    print_info "Step 2/4: Running Biber..."
    biber Libro 2>&1 | grep -E "INFO|WARN|ERROR"
    if [ $? -eq 0 ]; then
        print_success "Biber completed"
    else
        print_warning "Biber completed with warnings"
    fi

    print_info "Step 3/4: Running LuaLaTeX (second pass)..."
    lualatex -interaction=nonstopmode "$MAIN_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_success "LuaLaTeX second pass completed"
    else
        print_error "LuaLaTeX second pass failed"
        return 1
    fi

    print_info "Step 4/4: Running LuaLaTeX (final pass)..."
    lualatex -interaction=nonstopmode "$MAIN_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_success "LuaLaTeX final pass completed"
    else
        print_error "LuaLaTeX final pass failed"
        return 1
    fi

    echo ""
    if [ -f "$PDF_OUTPUT" ]; then
        local pages=$(pdfinfo "$PDF_OUTPUT" 2>/dev/null | grep Pages | awk '{print $2}')
        local size=$(du -h "$PDF_OUTPUT" | cut -f1)
        print_success "Compilation complete! Output: $PDF_OUTPUT ($pages pages, $size)"
    else
        print_error "PDF was not generated"
        return 1
    fi
}

# Function to do quick compile
quick_compile() {
    print_info "Running quick compilation (LuaLaTeX only)..."
    lualatex -interaction=nonstopmode "$MAIN_FILE"
    if [ $? -eq 0 ]; then
        print_success "Quick compilation completed"
        if [ -f "$PDF_OUTPUT" ]; then
            local pages=$(pdfinfo "$PDF_OUTPUT" 2>/dev/null | grep Pages | awk '{print $2}')
            local size=$(du -h "$PDF_OUTPUT" | cut -f1)
            print_success "Output: $PDF_OUTPUT ($pages pages, $size)"
        fi
    else
        print_error "Quick compilation failed"
    fi
}

# Function to check for warnings and errors
check_warnings() {
    print_info "Checking for warnings and errors..."
    echo ""

    print_info "Running LuaLaTeX to generate log..."
    lualatex -interaction=nonstopmode "$MAIN_FILE" > /dev/null 2>&1

    if [ -f "Libro.log" ]; then
        local errors=$(grep -c "^!" Libro.log)
        local warnings=$(grep -c "Warning" Libro.log)

        echo ""
        echo "=== Summary ==="
        if [ "$errors" -gt 0 ]; then
            print_error "Found $errors error(s)"
            echo ""
            print_info "Errors:"
            grep "^!" Libro.log | head -10
        else
            print_success "No errors found"
        fi

        echo ""
        if [ "$warnings" -gt 0 ]; then
            print_warning "Found $warnings warning(s)"
            echo ""
            print_info "Warnings (first 10):"
            grep "Warning" Libro.log | head -10
        else
            print_success "No warnings found"
        fi
    else
        print_error "Log file not found"
    fi
}

# Function to clean auxiliary files
clean_files() {
    print_info "Cleaning auxiliary files..."
    rm -f *.aux *.log *.out *.toc *.bbl *.bcf *.blg *.run.xml *.lof *.lot
    print_success "Auxiliary files cleaned"
}

# Function to show file info
show_info() {
    if [ -f "$PDF_OUTPUT" ]; then
        print_info "PDF Information:"
        echo ""
        pdfinfo "$PDF_OUTPUT" 2>/dev/null | grep -E "Pages|File size|PDF version"
        echo ""
        print_info "File details:"
        ls -lh "$PDF_OUTPUT"
    else
        print_warning "PDF file does not exist. Compile first."
    fi
}

# Main menu
show_menu() {
    clear
    echo "╔════════════════════════════════════════════════╗"
    echo "║       LaTeX Compilation Menu (LuaLaTeX)       ║"
    echo "╚════════════════════════════════════════════════╝"
    echo ""
    echo "  1) Full compilation (LuaLaTeX → Biber → LuaLaTeX → LuaLaTeX)"
    echo "  2) Quick compilation (LuaLaTeX only)"
    echo "  3) Check warnings and errors"
    echo "  4) Clean auxiliary files"
    echo "  5) Show PDF information"
    echo "  6) Exit"
    echo ""
}

# Main loop
while true; do
    show_menu
    read -p "Select an option [1-6]: " choice
    echo ""

    case $choice in
        1)
            full_compile
            ;;
        2)
            quick_compile
            ;;
        3)
            check_warnings
            ;;
        4)
            clean_files
            ;;
        5)
            show_info
            ;;
        6)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option. Please select 1-6."
            ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
done
