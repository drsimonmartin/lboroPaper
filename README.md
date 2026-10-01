# lboroPaper v0.6

Metadata-driven Quarto template for Loughborough University committee papers, with Word and PDF output.

## Create a project

```bash
quarto use template drsimonmartin/lboroPaper
```

## Render Word

```bash
quarto render test.qmd --to lboroPaper-docx
```

## Render PDF

```bash
quarto render test.qmd --to lboroPaper-pdf
```

PDF rendering requires a TeX installation. If needed:

```bash
quarto install tinytex
```

The same metadata and Markdown body are used for both formats. PDF uses an A4 LaTeX layout with matching purple banner, pale-purple Action Required panel, compact margins and committee-paper typography.
