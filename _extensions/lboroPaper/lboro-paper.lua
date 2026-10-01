local stringify = pandoc.utils.stringify

local function meta_text(meta, key, default)
  local v = meta[key]
  if v == nil then return default or '' end
  local s = stringify(v)
  if s == '' then return default or '' end
  return s
end

local function styled_para(style, inlines)
  return pandoc.Div({pandoc.Para(inlines)}, pandoc.Attr('', {}, {['custom-style'] = style}))
end

local function normal_para(text)
  return pandoc.Para(pandoc.Inlines{pandoc.Str(text)})
end

local function bold_para(label, text)
  local xs = pandoc.Inlines{pandoc.Strong(pandoc.Inlines{pandoc.Str(label)})}
  if text and text ~= '' then
    xs:insert(pandoc.Space())
    xs:insert(pandoc.Str(text))
  end
  return pandoc.Para(xs)
end

local function heading_para(text)
  return styled_para('Heading 3', pandoc.Inlines{pandoc.Strong(pandoc.Inlines{pandoc.Str(text)})})
end

local function action_table(action, detail)
  -- The source reference.docx includes the Table Grid style and its theme palette.
  -- A Markdown table is used here for robust DOCX generation. The companion
  -- reference.docx has been patched so Table Grid carries the source pale-purple
  -- E5DFEC cell fill, making generated action boxes inherit that colour.
  local md = '| **Action Required:** |\n|---|\n| **' .. action .. '**  \\\n' .. detail .. ' |'
  return pandoc.read(md, 'markdown').blocks
end

function Pandoc(doc)
  if not FORMAT:match('docx') then return nil end
  local m = doc.meta
  local blocks = pandoc.Blocks{}

  blocks:insert(styled_para('SectionHeading2', pandoc.Inlines{pandoc.Str(meta_text(m, 'paper-reference', 'Paper reference'))}))
  blocks:insert(styled_para('Committee Name', pandoc.Inlines{pandoc.Str(string.upper(meta_text(m, 'committee', 'COMMITTEE NAME')))}))
  blocks:insert(pandoc.Header(2, pandoc.Inlines{pandoc.Str(meta_text(m, 'title', 'Name of Paper'))}))
  blocks:insert(bold_para('Origin:', meta_text(m, 'origin', 'List the author(s) of the paper')))
  blocks:extend(action_table(meta_text(m, 'action', 'CONSIDER'), meta_text(m, 'action-detail', 'Clearly indicate what the committee is being asked to do.')))

  blocks:insert(heading_para('Executive Summary'))
  blocks:insert(normal_para(meta_text(m, 'executive-summary', 'Provide a standalone executive summary.')))
  blocks:insert(heading_para('Other Committees Consulted'))
  blocks:insert(normal_para(meta_text(m, 'committees-consulted', 'None')))
  blocks:insert(heading_para('Equity, Diversity and Inclusion Considerations'))
  blocks:insert(normal_para(meta_text(m, 'edi-considerations', 'N/A')))
  blocks:insert(heading_para(meta_text(m, 'title', 'Paper Name')))
  blocks:extend(doc.blocks)

  local supp = meta_text(m, 'supplementary-reading', '')
  if supp ~= '' then
    blocks:insert(heading_para('Supplementary Reading'))
    blocks:insert(normal_para(supp))
  end

  m.title = nil; m.author = nil; m.date = nil
  return pandoc.Pandoc(blocks, m)
end
