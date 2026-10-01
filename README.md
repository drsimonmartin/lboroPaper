# lboroPaper

Metadata-driven Quarto starter template for Loughborough University committee papers.

Naming is consistent throughout:

- repository: `drsimonmartin/lboroPaper`
- extension directory: `_extensions/lboroPaper/`
- custom format: `lboroPaper-docx`

## Start a new paper

```bash
quarto use template drsimonmartin/lboroPaper
```

Then enter the new directory, edit the generated `.qmd`, and render it:

```bash
quarto render test.qmd
```

The YAML must contain:

```yaml
format: lboroPaper-docx
```

Do not use the older names `committee-paper-docx` or `lboro-docx`.

## Check the local installation

The project should contain `_extensions/lboroPaper/_extension.yml`. You can also run:

```bash
quarto list extensions
```

If testing after updating this GitHub repository, create a fresh test project with `quarto use template` so that you are not using the extension copied from an earlier version.
