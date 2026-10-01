local stringify = pandoc.utils.stringify

local function meta_text(meta, key, default)
  local v = meta[key]
  if v == nil then return default or '' end
  local s = stringify(v)
  if s == '' then return default or '' end
  return s
end

local function text_para(text)
  return pandoc.Para(pandoc.Inlines{pandoc.Str(text)})
end

local function labelled_para(label, text)
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

  blocks:insert(text_para(meta_text(m, 'paper-reference', 'Paper reference')))
  blocks:insert(labelled_para(string.upper(meta_text(m, 'committee', 'COMMITTEE NAME'))))
  blocks:insert(pandoc.Header(2, pandoc.Inlines{pandoc.Str(meta_text(m, 'title', 'Name of Paper'))}))
  blocks:insert(labelled_para('Origin:', meta_text(m, 'origin', 'List the author(s) of the paper')))
  blocks:extend(action_table(meta_text(m, 'action', 'CONSIDER'), meta_text(m, 'action-detail', 'Clearly indicate what the committee is being asked to do.')))
  blocks:insert(labelled_para('Executive Summary'))
  blocks:insert(text_para(meta_text(m, 'executive-summary', 'Provide a standalone executive summary.')))
  blocks:insert(labelled_para('Other Committees Consulted'))
  blocks:insert(text_para(meta_text(m, 'committees-consulted', 'None')))
  blocks:insert(labelled_para('Equity, Diversity and Inclusion Considerations'))
  blocks:insert(text_para(meta_text(m, 'edi-considerations', 'N/A')))
  blocks:insert(labelled_para(meta_text(m, 'title', 'Paper Name')))
  blocks:extend(doc.blocks)

  local supp = meta_text(m, 'supplementary-reading', '')
  if supp ~= '' then
    blocks:insert(labelled_para('Supplementary Reading'))
    blocks:insert(text_para(supp))
  end

  m.title = nil
  m.author = nil
  m.date = nil
  return pandoc.Pandoc(blocks, m)
end
