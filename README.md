# lboroPaper

Metadata-driven Quarto starter template for Loughborough University committee papers, based on `Section_14_Committee_Paper_Coversheet_2025.docx`.

## Create a paper

```bash
quarto use template drsimonmartin/lboroPaper
```

Edit the YAML metadata at the top of the generated `.qmd`; write only the main paper in the Markdown body.

```yaml
title: "Review of Academic Regulations"
paper-reference: "SEN26-P4"
committee: "SENATE"
origin: "Simon Martin, Associate Dean for Education and Student Experience"
action: "CONSIDER"
action-detail: "Consider the proposed changes and comment on the recommendations."
executive-summary: >
  Concise summary for the committee.
committees-consulted: "Education and Student Experience Committee"
edi-considerations: "Equality implications considered; see the accompanying EIA."
supplementary-reading: "Appendix 1: supporting analysis"
format: lboroPaper-docx
```

The `lboro-paper.lua` filter turns those fields into the committee-paper front matter automatically. The remaining Markdown is inserted as the body of the paper.

## Metadata fields

- `title`: paper title.
- `paper-reference`: committee paper reference.
- `committee`: committee name.
- `origin`: author/originating body.
- `action`: normally `APPROVE`, `CONSIDER`, `NOTE`, or `RECOMMEND`.
- `action-detail`: the specific action or questions for members.
- `executive-summary`: standalone summary.
- `committees-consulted`: previous committees that considered or informed the paper.
- `edi-considerations`: EDI considerations and EIA information where relevant.
- `supplementary-reading`: optional links/appendices; omit to suppress this section.

## Format

```yaml
format: lboroPaper-docx
```

The extension uses the supplied committee-paper Word document as its `reference.docx`, preserving the source page setup and Word styles. A Lua filter creates the metadata-driven content before Pandoc writes the `.docx`.
