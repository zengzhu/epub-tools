<?xml version="1.0"?>
<!-- 
TEI XSLT stylesheet family
$Date: 2007-11-20 09:40:42 +0000 (Tue, 20 Nov 2007) $, $Revision: 4004 $, $Author: rahtz $

XSL LaTeX stylesheet to make slides

##LICENSE
-->
<xsl:stylesheet 		
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:rng="http://relaxng.org/ns/structure/1.0" 
    xmlns:teix="http://www.tei-c.org/ns/Examples" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:s="http://www.ascc.net/xml/schematron" 
    xmlns:map="http://apache.org/cocoon/sitemap/1.0"
    exclude-result-prefixes="a s map atom xhtml teix tei rng"
    version="1.0">
  <xsl:import href="../latex/tei.xsl"/>
  <xsl:import href="../common/verbatim.xsl"/>
  <xsl:strip-space elements="teix:* rng:* xsl:* xhtml:* atom:*"/>
  <xsl:output method="text" encoding="utf-8"/>
  <xsl:variable name="docClass">beamer</xsl:variable>
  <xsl:param name="startNamespace">\color{black}</xsl:param>
  <xsl:param name="startElement">{\color{blue}</xsl:param>
  <xsl:param name="startElementName">\textbf{\color{blue}</xsl:param>
  <xsl:param name="startAttribute">{\color{blue}</xsl:param>
  <xsl:param name="startAttributeValue">{\color{blue}</xsl:param>
  <xsl:param name="startComment">\textit{</xsl:param>
  <xsl:param name="endElement">}</xsl:param>
  <xsl:param name="endElementName">}</xsl:param>
  <xsl:param name="endComment">}</xsl:param>
  <xsl:param name="endAttribute">}</xsl:param>
  <xsl:param name="endAttributeValue">}</xsl:param>
  <xsl:param name="endNamespace"/>
  <xsl:param name="spaceCharacter">\hspace*{1em}</xsl:param>
  <xsl:param name="classParameters"/>
  <xsl:param name="beamerClass">PaloAlto</xsl:param>

  <xsl:template name="lineBreak">
    <xsl:param name="id"/>
    <xsl:text>\mbox{}\newline &#10;</xsl:text>
  </xsl:template>

  <xsl:template name="latexPackages">
\usepackage{framed}
\definecolor{shadecolor}{gray}{0.95}
\usepackage{colortbl}
\usepackage{longtable}
\usetheme{<xsl:value-of select="$beamerClass"/>}
\usepackage{times}
\usepackage{fancyvrb}
\def\Gin@extensions{.pdf,.png,.jpg,.mps,.tif}
\setbeamercovered{transparent}
\let\mainmatter\relax
\let\frontmatter\relax
\let\backmatter\relax
\let\endfoot\relax
\let\endlastfoot\relax
</xsl:template>

  <xsl:template name="latexLayout">
\date{<xsl:value-of select="/TEI.2/teiHeader/fileDesc/editionStmt/edition/date"/>}
\institute{<xsl:value-of select="/TEI.2/teiHeader/fileDesc/publicationStmt/authority"/>}
<xsl:if test="not($latexLogo='')">
<xsl:text>\pgfdeclareimage[height=1cm]{logo}{</xsl:text>
<xsl:choose>
  <xsl:when test="$realFigures='true'">
    <xsl:value-of select="$latexLogo"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>FIG0</xsl:text>
  </xsl:otherwise>
</xsl:choose>
<xsl:text>}</xsl:text>
\logo{\pgfuseimage{logo}}
</xsl:if>
</xsl:template>

<xsl:template name="latexBegin">
\frame{\maketitle}
</xsl:template>

<xsl:template match="divGen[@type='toc']">
  \begin{frame} 
  \frametitle{Outline} 
  \tableofcontents
  \end{frame}
</xsl:template>

<xsl:template match="div/head"/>
<xsl:template match="div0/head"/>
<xsl:template match="div1/head"/>
<xsl:template match="div2/head"/>

<xsl:template match="div0">
 <xsl:call-template name="makeOuterFrame"/>
</xsl:template>

<xsl:template match="div1">
  <xsl:choose>
    <xsl:when test="parent::div0">
      <xsl:call-template name="makeFrame"/>
    </xsl:when>
    <xsl:when test="div2">
      <xsl:call-template name="makeOuterFrame"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="makeFrame"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="div2|div3">
  <xsl:call-template name="makeFrame"/>
</xsl:template>

<xsl:template match="div">
  <xsl:choose>
    <xsl:when test="div and parent::body">
      <xsl:call-template name="makeOuterFrame"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="makeFrame"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="makeOuterFrame">
  <xsl:text>&#10;\section{</xsl:text>
  <xsl:for-each select="head">
    <xsl:apply-templates/>
  </xsl:for-each>
   <xsl:text>}</xsl:text>
  <xsl:text>&#10;\begin{frame} 
  \frametitle{</xsl:text>
    <xsl:for-each select="head">
      <xsl:apply-templates/>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
      <xsl:choose>
	<xsl:when test="*[not(starts-with(local-name(.),'div'))]">
	  <xsl:apply-templates
	      select="*[not(starts-with(local-name(.),'div'))]"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>{\Huge&#x2026;}</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;\end{frame}&#10;</xsl:text>
      <xsl:apply-templates select="div1|div2|div"/>
  </xsl:template>

<xsl:template name="makeFrame">
  <xsl:text>&#10;\begin{frame}</xsl:text>
  <xsl:choose>
    <xsl:when test="@rend='fragile'">
      <xsl:text>[fragile]</xsl:text>
    </xsl:when>
    <xsl:when test=".//eg">
      <xsl:text>[fragile]</xsl:text>
    </xsl:when>
    <xsl:when test=".//Output">
      <xsl:text>[fragile]</xsl:text>
    </xsl:when>
    <xsl:when test=".//Screen">
      <xsl:text>[fragile]</xsl:text>
    </xsl:when>
    <xsl:when test=".//teix:egXML">
      <xsl:text>[fragile]</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:text>&#10;\frametitle{</xsl:text>
  <xsl:for-each select="head">
    <xsl:apply-templates/>
  </xsl:for-each>
  <xsl:text>}</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;\end{frame}&#10;</xsl:text>
</xsl:template>

<xsl:template name="makePic">
  <xsl:if test="@id">
    <xsl:text>\hypertarget{</xsl:text>
    <xsl:value-of select="@id"/>
    <xsl:text>}{}</xsl:text>
  </xsl:if>
  <xsl:text>\includegraphics[</xsl:text>
  <xsl:call-template name="graphicsAttributes">
    <xsl:with-param name="mode">latex</xsl:with-param>
  </xsl:call-template>
  <xsl:if test="not(@width) and not (@height) and not(@scale)">
    <xsl:text>width=\textwidth</xsl:text>
  </xsl:if>
  <xsl:text>]{</xsl:text>
  <xsl:choose>
    <xsl:when test="@url">
      <xsl:value-of select="@url"/>
    </xsl:when>
    <xsl:when test="@entity">
      <xsl:value-of select="unparsed-entity-uri(@entity)"/>
    </xsl:when>
  </xsl:choose>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="hi[not(@rend)]">
  <xsl:text>\alert{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="item[@rend='pause']">
  <xsl:text>\item </xsl:text>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::item">
    <xsl:text>\pause </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="eg">
  <xsl:text>\begin{Verbatim}[fontsize=\scriptsize,frame=single,fillcolor=\color{yellow}]&#10;</xsl:text>
  <xsl:apply-templates mode="eg"/>
  <xsl:text>\end{Verbatim}&#10;</xsl:text>
</xsl:template>

  <xsl:template match="teix:egXML">
\bgroup\ttfamily\fontsize{9pt}{9pt}\selectfont\par
\begin{exampleblock}{}
\noindent\ttfamily\mbox{}<xsl:apply-templates mode="verbatim"/>
\end{exampleblock}
\par\egroup
  </xsl:template>

  <xsl:template match="p[@rend='box']">
    <xsl:text>\par\begin{exampleblock}{}&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{exampleblock}\par&#10;</xsl:text>
  </xsl:template>


<xsl:template match="table">
  <xsl:text>\par  
  \begin{scriptsize}
  \begin{longtable}</xsl:text>
  <xsl:call-template name="makeTable"/>
  <xsl:text>\end{longtable}
  \end{scriptsize}</xsl:text>
</xsl:template>

  <xsl:template name="makeFigureStart">
    \noindent
  </xsl:template>

  <xsl:template name="makeFigureEnd">
  </xsl:template>

<xsl:template name="tableHline">
<xsl:text> \hline </xsl:text>
</xsl:template>

<xsl:template match="att">
  <xsl:text>\emph{@</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>

</xsl:template>


  <xsl:template name="Text">
    <xsl:param name="words"/>
    <xsl:choose>
      <xsl:when test="contains($words,'&amp;')">
	<xsl:value-of
	    select="substring-before($words,'&amp;')"/>
	<xsl:text>&amp;amp;</xsl:text>
	<xsl:call-template name="Text">
	  <xsl:with-param name="words">
	<xsl:value-of select="translate(substring-after($words,'&amp;'),'\{}','&#8421;&#10100;&#10101;')"/>
	  </xsl:with-param>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="translate($words,'\{}','&#8421;&#10100;&#10101;')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>
