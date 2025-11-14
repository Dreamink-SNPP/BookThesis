[![LaTeX CI](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/latex-ci.yml/badge.svg?branch=main)](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/latex-ci.yml)
[![Markdown to PDF CI](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/markdown-pdf-ci.yml/badge.svg?branch=main)](https://github.com/Dreamink-SNPP/BookThesis/actions/workflows/markdown-pdf-ci.yml)

# Proyecto Técnico

## Documentación básica

Se debe entregar una documentación básica para la primera entrega de este proyecto, respondiendo a varias cuestiones por el cual se necesitan obtener los requisitos del problema en el cual se quiere trabajar.

## Documentación a trabajar

Aquí se presentará el documento **oficial** del libro para la entrega del proyecto, en el cual contendrá todos los elementos requeridos para su entrega.

### Compilación de documentos

Este proyecto incluye dos sistemas de compilación:

1. **LaTeX → PDF**: Para el libro principal (`src/Libro.tex`)
   - Script: `./compile.sh`
   - Documentación: [README_COMPILE.md](README_COMPILE.md)

2. **Markdown → PDF**: Para documentos en `docs/`
   - Script: `./compile-md.sh`
   - Documentación: [README_MARKDOWN_COMPILE.md](README_MARKDOWN_COMPILE.md)
   - Compilación automática: [Markdown PDF CI](.github/workflows/markdown-pdf-ci.yml)

Ambos sistemas siguen el [STYLE_GUIDE_DOC.md](STYLE_GUIDE_DOC.md) institucional.

### Tema

- **Tema:** Sistema de Estructuración Dramática de Obras Audiovisuales

### Integrantes

- Fernando Cardozo
- Alberto Álvarez

## License

Dreamink Thesis Book (c) by Fernando Cardozo and Alberto Álvarez.

This project uses dual licensing:

### Content License (LaTeX files, documentation, images)

The book content is licensed under **Creative Commons Attribution 4.0 International (CC BY 4.0)**.

See the [LICENSE](LICENSE) file for details, or visit https://creativecommons.org/licenses/by/4.0/

### Code License (scripts and programs)

The code is licensed under the **MIT License**.

See the [LICENSE-CODE](LICENSE-CODE) file for details.

Both licenses are Free Software / Open Source approved licenses.
