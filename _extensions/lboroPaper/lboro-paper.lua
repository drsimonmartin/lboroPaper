local stringify = pandoc.utils.stringify

local function meta_text(meta, key, default)
  local v = meta[key]
  if v == nil then return default or '' end
  local s = stringify(v)
  if s == '' then return default or '' end
  return s
end

local function para(text)
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

local function action_table(action, detail)
  local md = '| **Action Required:** |\n|---|\n| **' .. action .. '**  \\n' .. detail .. ' |'
  return pandoc.read(md, 'markdown').blocks
end

function Pandoc(doc)
  if not FORMAT:match('docx') then return nil end

  local m = doc.meta
  local blocks = pandoc.Blocks{}

  blocks:insert(para(meta_text(m, 'paper-reference', 'Paper reference')))
  blocks:insert(bold_para(string.upper(meta_text(m, 'committee', 'COMMITTEE NAME'))))
  blocks:insert(pandoc.Header(2, pandoc.Inlines{pandoc.Str(meta_text(m, 'title', 'Name of Paper'))}))
  blocks:insert(bold_para('Origin:', meta_text(m, 'origin', 'List the author(s) of the paper')))

  local ab = action_table(meta_text(m, 'action', 'CONSIDER'), meta_text(m, 'action-detail', 'Clearly indicate what the committee is being asked to do.'))
  blocks:extend(ab)

  blocks:insert(bold_para('Executive Summary'))
  blocks:insert(para(meta_text(m, 'executive-summary', 'Provide enough detail to engage with the topic and highlight the critical information the committee needs.')))

  blocks:insert(bold_para('Other Committees Consulted'))
  blocks:insert(para(meta_text(m, 'committees-consulted', 'None')))

  blocks:insert(bold_para('Equity, Diversity and Inclusion Considerations'))
  blocks:insert(para(meta_text(m, 'edi-considerations', 'N/A')))

  blocks:insert(bold_para(meta_text(m, 'title', 'Paper Name')))
  blocks:extend(doc.blocks)

  local supp = meta_text(m, 'supplementary-reading', '')
  if supp ~= '' then
    blocks:insert(bold_para('Supplementary Reading'))
    blocks:insert(para(supp))
  end

  m.title = nil
  m.author = nil
  m.date = nil
  return pandoc.Pandoc(blocks, m)
end
