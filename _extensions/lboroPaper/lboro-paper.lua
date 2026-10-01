local stringify = pandoc.utils.stringify
local function mt(m,k,d) local v=m[k]; if v==nil then return d or '' end; local s=stringify(v); if s=='' then return d or '' end; return s end
local function sp(style, inlines) return pandoc.Div({pandoc.Para(inlines)}, pandoc.Attr('',{}, {['custom-style']=style})) end
local function txt(style, text) return sp(style, pandoc.Inlines{pandoc.Str(text)}) end
local function strongtxt(style, text) return sp(style, pandoc.Inlines{pandoc.Strong(pandoc.Inlines{pandoc.Str(text)})}) end
local function normal(text) return pandoc.Para(pandoc.Inlines{pandoc.Str(text)}) end
local function labelled(label,text)
  local x=pandoc.Inlines{pandoc.Strong(pandoc.Inlines{pandoc.Str(label)})}
  if text~='' then x:insert(pandoc.Space()); x:insert(pandoc.Str(text)) end
  return pandoc.Para(x)
end
function Pandoc(doc)
  if not FORMAT:match('docx') then return nil end
  local m=doc.meta; local b=pandoc.Blocks{}
  b:insert(txt('SectionHeading2',mt(m,'paper-reference','Paper reference')))
  b:insert(txt('Committee Banner',string.upper(mt(m,'committee','COMMITTEE NAME'))))
  b:insert(pandoc.Header(2,pandoc.Inlines{pandoc.Str(mt(m,'title','Name of Paper'))}))
  b:insert(labelled('Origin:',mt(m,'origin','List the author(s) of the paper')))
  b:insert(txt('Action Required Heading','Action Required:'))
  b:insert(sp('Action Required', pandoc.Inlines{pandoc.Strong(pandoc.Inlines{pandoc.Str(mt(m,'action','CONSIDER'))}), pandoc.LineBreak(), pandoc.Str(mt(m,'action-detail','Clearly indicate what the committee is being asked to do.'))}))
  b:insert(strongtxt('Committee Section Heading','Executive Summary')); b:insert(normal(mt(m,'executive-summary','Provide a standalone executive summary.')))
  b:insert(strongtxt('Committee Section Heading','Other Committees Consulted')); b:insert(normal(mt(m,'committees-consulted','None')))
  b:insert(strongtxt('Committee Section Heading','Equity, Diversity and Inclusion Considerations')); b:insert(normal(mt(m,'edi-considerations','N/A')))
  b:insert(strongtxt('Committee Section Heading',mt(m,'title','Paper Name')))
  b:extend(doc.blocks)
  local s=mt(m,'supplementary-reading',''); if s~='' then b:insert(strongtxt('Committee Section Heading','Supplementary Reading')); b:insert(normal(s)) end
  m.title=nil; m.author=nil; m.date=nil
  return pandoc.Pandoc(b,m)
end
