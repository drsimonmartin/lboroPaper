# lboroPaper v0.4

Metadata-driven Quarto starter template for Loughborough University committee papers.

This revision restores the colour/style information found in the supplied 2025 Word coversheet:

- `Committee Name` custom Word style, including white text;
- `SectionHeading2` custom style for the paper reference;
- source heading styles and purple theme palette from `reference.docx`;
- pale-purple `#E5DFEC` / `accent4` styling for the Action Required table.

## Create a paper

```bash
quarto use template drsimonmartin/lboroPaper
```

Use only:

```yaml
format: lboroPaper-docx
```

After replacing an older GitHub version, create a fresh test project because Quarto copies the extension into each project.
