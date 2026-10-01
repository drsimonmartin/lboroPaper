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
local function esc(s)
  s=s:gsub('\\','\\textbackslash{}'):gsub('([%%#&_{}$])','\\%1'):gsub('%^','\\textasciicircum{}'):gsub('~','\\textasciitilde{}')
  return s
end
function Pandoc(doc)
  local m=doc.meta; local b=pandoc.Blocks{}
  if FORMAT:match('docx') then
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
  elseif FORMAT:match('latex') then
    local ref=esc(mt(m,'paper-reference','Paper reference'))
    local committee=esc(string.upper(mt(m,'committee','COMMITTEE NAME')))
    local title=esc(mt(m,'title','Name of Paper'))
    local origin=esc(mt(m,'origin','List the author(s) of the paper'))
    local action=esc(mt(m,'action','CONSIDER'))
    local detail=esc(mt(m,'action-detail','Clearly indicate what the committee is being asked to do.'))
    b:insert(pandoc.RawBlock('latex','{\\color{LboroGrey}\\bfseries '..ref..'}'))
    b:insert(pandoc.RawBlock('latex','\\begin{tcolorbox}[colback=LboroPurple,colframe=LboroPurple,boxrule=0pt,arc=0pt,left=2mm,right=2mm,top=1.5mm,bottom=1.5mm]\\color{white}\\bfseries\\large '..committee..'\\end{tcolorbox}'))
    b:insert(pandoc.RawBlock('latex','{\\Large\\bfseries '..title..'\\par}'))
    b:insert(pandoc.RawBlock('latex','\\textbf{Origin:} '..origin..'\\par'))
    b:insert(pandoc.RawBlock('latex','\\begin{tcolorbox}[colback=LboroLightPurple,colframe=LboroPurple,arc=0pt,boxrule=0.6pt]\\textbf{Action Required:}\\par\\textbf{'..action..'}\\par '..detail..'\\end{tcolorbox}'))
    local function sec(label,value)
      b:insert(pandoc.RawBlock('latex','\\textbf{'..esc(label)..'}\\par'))
      b:insert(normal(value))
    end
    sec('Executive Summary',mt(m,'executive-summary','Provide a standalone executive summary.'))
    sec('Other Committees Consulted',mt(m,'committees-consulted','None'))
    sec('Equity, Diversity and Inclusion Considerations',mt(m,'edi-considerations','N/A'))
    b:insert(pandoc.RawBlock('latex','\\textbf{'..title..'}\\par'))
    b:extend(doc.blocks)
    local s=mt(m,'supplementary-reading',''); if s~='' then sec('Supplementary Reading',s) end
  else
    return nil
  end
  m.title=nil; m.author=nil; m.date=nil
  return pandoc.Pandoc(b,m)
end
