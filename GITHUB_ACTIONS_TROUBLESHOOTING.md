# GitHub Actions Troubleshooting Guide

## 🔍 How to View Compilation Logs in GitHub Actions

### Quick Access

1. **Go to your repository on GitHub**
2. **Click the "Actions" tab** at the top
3. **Find the failed workflow run** (look for the red ❌)
4. **Click on the workflow run** to see details

**Direct URL format:**

```
https://github.com/Dreamink-SNPP/BookThesis/actions
```

---

## 📊 Understanding the Workflow Summary

When a workflow completes, GitHub shows a **Summary** page with:

### ✅ What Succeeded

- Number of PDFs successfully compiled
- List of generated files with page counts and sizes

### ❌ What Failed

- Number of files that failed
- Exact list of which `.md` files failed
- Links to error logs

**Example:**

```
📊 Compilation Summary

Total Markdown files: 9

✅ Successfully compiled 8 PDF file(s)
⚠️ 1 file(s) failed to compile

✅ Generated Files:
- 📄 MatrizConsistencia.pdf - 5 pages, 28K
- 📄 ProtocoloBasico.pdf - 3 pages, 24K
...

❌ Failed Files:
- ❌ GuiaEntrevista.md

💡 Tip: Check the compilation logs above for error details.
```

---

## 🔎 Viewing Detailed Error Logs

### Step-by-Step

1. **Open the failed workflow run**
2. **Click on the job name** (e.g., "compile-markdown")
3. **Find the step "Compile all Markdown files to PDF"**
4. **Click to expand it** - you'll see:

```
[STEP] Compiling: GuiaEntrevista.md → GuiaEntrevista.pdf
[ERROR] Compilation failed for: docs/instrumento_entrevista/GuiaEntrevista.md
[INFO] Check log: build/markdown/last-compilation.log

[INFO] Last error lines:
! Undefined control sequence.
l.172 \square
```

5. **Read the error message** - it tells you:
   - Which file failed
   - What line number (l.172)
   - What command caused the error (\square)

---

## 📥 Downloading Compilation Logs

For detailed analysis, download the full compilation log:

### Method 1: Artifacts

1. **Scroll to the bottom** of the workflow run
2. **Find "Artifacts" section**
3. **Download "compilation-log-XXXX"**
4. **Unzip and open** `last-compilation.log`

### Method 2: Using GitHub CLI

```bash
# List artifacts
gh run list --repo Dreamink-SNPP/BookThesis

# Download specific run artifacts
gh run download [RUN_ID] --repo Dreamink-SNPP/BookThesis
```

---

## 🐛 Common Errors and Solutions

### Error: `\square` undefined

**Problem:** Markdown checkboxes not supported

```
! Undefined control sequence.
l.231   \item[$\square$]
```

**Solution:** Already fixed! Update to latest template

```bash
git pull origin main
```

---

### Error: `\tightlist` undefined

**Problem:** Compact list formatting not defined

```
! Undefined control sequence.
l.172 \tightlist
```

**Solution:** Already fixed in template (templates/thesis-template.tex:86-87)

---

### Error: "Missing number"

**Problem:** LaTeX parsing error with certain Markdown constructs

```
Error producing PDF.
! Missing number, treated as zero.
```

**Solution:** Already fixed! Added BreakableAlign environment

---

### Error: Font not found

**Problem:** TeX Gyre Termes font not available

```
! Package fontspec Error: The font "TeX Gyre Termes" cannot be found.
```

**Solution:** Template automatically falls back to:

1. Times New Roman
2. Liberation Serif
3. Latin Modern Roman

No action needed! But for best results on local machine:

```bash
sudo apt-get install texlive-fonts-extra
```

---

### Error: Image not found

**Problem:** Image path is incorrect

```
! Package pdftex.def Error: File `images/diagram.png' not found
```

**Solution:** Use paths relative to repository root:

```markdown
<!-- ✅ Correct -->

![Diagram](images/diagram.png)

<!-- ❌ Incorrect -->

![Diagram](../images/diagram.png)
![Diagram](/absolute/path/diagram.png)
```

---

## 📋 Checking Specific Steps

### 1. Dependency Installation

**Step:** "Install dependencies"

**What to check:**

```
✓ Dependencies installed successfully

Versions:
  Pandoc: pandoc X.X.X
  LuaLaTeX: This is LuaTeX, Version X.X
```

**If failed:** Check package names for your OS

---

### 2. Compilation

**Step:** "Compile all Markdown files to PDF"

**What to check:**

```
[INFO] Found X Markdown file(s)

[STEP] Compiling: file1.md → file1.pdf
[SUCCESS] Compiled successfully: build/markdown/pdf/file1.pdf (5 pages, 28K)

═══════════════════════════════════════════
[INFO] Compilation Summary:
[SUCCESS] Successful: 8 / 9
[ERROR] Failed: 1 / 9

Failed files:
  • GuiaEntrevista.md
```

**Look for:**

- `[ERROR]` lines - which files failed
- `Failed files:` list - names of problematic files
- Error messages with line numbers

---

### 3. Validation

**Step:** "Validate PDF outputs"

**What to check:**

```
═══════════════════════════════════════════
📊 Validation Summary:
  ✅ Valid PDFs: 8
  ❌ Failed PDFs: 0
═══════════════════════════════════════════
```

**If PDFs fail validation:**

- Check file size (should be > 1KB)
- Verify PDF header (`%PDF`)
- Review compilation errors above

---

## 🔄 Workflow Behavior

### Continue on Error

The workflow is designed to:

- ✅ **Continue compiling** even if one file fails
- ✅ **Upload valid PDFs** to artifacts
- ✅ **Show summary** of what succeeded/failed
- ⚠️ **Mark workflow as failed** if any compilation failed
- ✅ **Still create release** with valid PDFs

This means you'll get:

- All successfully compiled PDFs
- Clear indication of which files need fixing
- Artifacts to download

---

## 🛠️ Local Testing

Before pushing to GitHub, test locally:

### Test Single File

```bash
./compile-md.sh 1
# Select the problematic file
```

### Test All Files

```bash
./compile-md.sh 2
```

### View Errors

```bash
cat build/markdown/last-compilation.log | grep -A5 "^!"
```

---

## 📞 Getting Help

### 1. Check Logs First

- Expand all workflow steps
- Read error messages carefully
- Note the line numbers

### 2. Check Documentation

- [README_MARKDOWN_COMPILE.md](README_MARKDOWN_COMPILE.md) - Usage guide
- [SECURITY_PERFORMANCE.md](SECURITY_PERFORMANCE.md) - Advanced features
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - File organization

### 3. Common Issues

- Checkbox errors → Template includes `amssymb`
- Font errors → Auto-fallback enabled
- Path errors → Use relative paths from repo root
- TOC errors → Can disable with `toc: false` in frontmatter

---

## 💡 Pro Tips

### Tip 1: Use Workflow Summary

Always check the **Summary** tab first - it shows exactly which files failed

### Tip 2: Download Artifacts

For complex errors, download the `compilation-log` artifact

### Tip 3: Test Locally

Faster iteration when fixing errors:

```bash
./compile-md.sh 1  # Test single file
```

### Tip 4: Check File Names

If a PDF is missing, ensure:

- `.md` file exists in `docs/`
- Filename doesn't contain special characters
- File isn't in `.gitignore`

### Tip 5: Enable Detailed Logging

Edit the problematic `.md` file to test specific features:

```markdown
---
toc: false # Disable TOC if causing issues
---

# Test Document
```

---

## ✅ Quick Checklist

When a workflow fails:

- [ ] Check the Summary tab
- [ ] Expand "Compile all Markdown files" step
- [ ] Find which file(s) failed
- [ ] Read the error message
- [ ] Note the line number
- [ ] Check the problematic Markdown file at that line
- [ ] Test locally with `./compile-md.sh 1`
- [ ] Fix the issue
- [ ] Push and verify

---

## 📖 Example Debugging Session

**Scenario:** GuiaEntrevista.md fails to compile

### Step 1: Check Summary

```
❌ Failed Files:
- ❌ GuiaEntrevista.md
```

### Step 2: Expand Compilation Step

```
[ERROR] Compilation failed for: docs/instrumento_entrevista/GuiaEntrevista.md

[INFO] Last error lines:
! Undefined control sequence.
\square
l.231   \item[$\square$]
```

### Step 3: Identify Issue

- Error at line 231
- Problem with `\square` command
- This is from a Markdown checkbox

### Step 4: Check Markdown File

```markdown
Line 231: - [ ] Checkbox item
```

### Step 5: Verify Fix

- Template should include `\usepackage{amssymb}`
- Check `templates/thesis-template.tex:82-83`

### Step 6: Test Locally

```bash
./compile-md.sh 1
# Select GuiaEntrevista.md
# Verify it compiles successfully
```

### Step 7: Commit and Push

```bash
git add templates/thesis-template.tex
git commit -m "Fix checkbox support"
git push
```

---

**Happy debugging! 🐛🔍**
