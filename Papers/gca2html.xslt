<?xml version="1.0" encoding="UTF-8"?>

<!-- XSLT for converting from gcapaper format to HTML + CSS
     Written by: Philip Mansfield
     History:
     version 1.0 - 10 November 2001 
        Created to handle gcapaper 6.0 (for XML 2001 Conference)
     version 1.1 - 25 February 2002
        Modified to also handle gcapaper 6.1 (for XML Europe 2002)
        Verified on gcapaper 6.2 (for XML Europe 2003)
     version 2.0 - 31 March 2003
        Modified to output XHTML 1.1 and to handle SVG images (for SVG Open 2003)
     version 2.1 - 20 August 2003
        Modified to not require DOCTYPE declaration (for XML 2003)
        Template priorities made explicit rather than order-dependent 
     Copyright:
     (c) 2001-3 Schema Software Inc.
     You may use, reproduce, modify or redistribute this software under
     the condition that you do not sell it and you include this copyright
     notice in all copies.  For more information, visit
     http://www.schemasoft.com or write to info@schemasoft.com -->

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
<xsl:param name="cssHref">gcapaper.css</xsl:param>

<xsl:output method="xml" doctype-public="-//W3C//DTD XHTML 1.1//EN"
doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" indent="yes" omit-xml-declaration="yes" />

<xsl:template match="gcapaper">
  <html xmlns="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
    <p class="credits"><small>XHTML rendition created by
      <a href="http://www.schemasoft.com/gcatools/">gcapaper Web Publisher v2.1</a>,
      <xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text>
      2001-3 <a href="http://www.schemasoft.com">Schema Software Inc.</a></small>
    </p>
    <xsl:text disable-output-escaping="yes">&lt;/body></xsl:text>
  </html>
</xsl:template>

<!-- Front matter -->
<!-- NOTE: The internal CSS is for a few style rules that are specified
     in gcapaper content; all other style rules should be in the external CSS -->
<xsl:template match="front">
  <head>
    <xsl:apply-templates select="title|keyword[1]|author" mode="head"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="Content-Style-Type" content="text/css"/>
    <style type="text/css">
ul.simple {list-style-type: none}
ul.bulleted {list-style-type: disc}
ul.dashed {list-style-type: square}
ol.arabic {list-style-type: decimal}
ol.ualpha {list-style-type: upper-alpha}
ol.uroman {list-style-type: upper-roman}
ol.lalpha {list-style-type: lower-alpha}
ol.lroman {list-style-type: lower-roman}
ol.ftnote {list-style-type: decimal}
    </style>
    <link rel="stylesheet" type="text/css" href="{$cssHref}"/>
  </head>
  <xsl:text disable-output-escaping="yes">&lt;body></xsl:text>
  <xsl:apply-templates select="keyword[1]|*[not(self::keyword)]"/>
</xsl:template>

<xsl:template match="title" mode="head">
  <title><xsl:value-of select=".//text()"/></title>
</xsl:template>

<xsl:template match="keyword[1]" mode="head">
  <meta name="keywords">
    <xsl:attribute name="content">
      <xsl:apply-templates/>
      <xsl:apply-templates select="following-sibling::keyword" mode="head"/>
    </xsl:attribute>
  </meta>
</xsl:template>

<xsl:template match="keyword[position()&gt;1]" mode="head">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="front/keyword[1]">
  <p class="keyword">
    <i class="keywordHeader"><xsl:text>Keywords: </xsl:text></i>
    <xsl:call-template name="keywordAnchor"/>
    <xsl:apply-templates/>
    <xsl:apply-templates select="following-sibling::keyword"/>
  </p>
</xsl:template>

<xsl:template match="keyword[position()&gt;1]">
  <xsl:text>, </xsl:text>
  <xsl:call-template name="keywordAnchor"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="author" mode="head">
  <meta name="author">
    <xsl:attribute name="content">
      <xsl:apply-templates select="fname|surname|suffix"/>
    </xsl:attribute>
  </meta>
</xsl:template>

<xsl:template match="surname">
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="suffix">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="title">
  <h1 class="title"><xsl:apply-templates/></h1>
</xsl:template>

<xsl:template match="subt[text() or *]">
  <h2 class="subt"><xsl:apply-templates/></h2>
</xsl:template>

<xsl:template match="author">
  <p class="author">
    <span class="authorName"><xsl:apply-templates select="fname|surname|suffix"/></span>
    <xsl:apply-templates select="jobtitle|address"/>
  </p>
  <xsl:apply-templates select="bio"/>
</xsl:template>

<xsl:template match="jobtitle">
  <br/><xsl:apply-templates/>
</xsl:template>

<xsl:template match="address/*" priority="0.25">
  <br/><xsl:apply-templates/>
</xsl:template>

<xsl:template match="address/email">
  <br/>
  <a class="email" href="mailto:{text()}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="address/web">
  <br/>
  <a class="web" href="{text()}">
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="bio">
  <p class="bioHeader"><i>Biography</i></p>
  <blockquote class="bio">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="bio/para[1]">
  <p>
    <xsl:apply-templates select="../@id" />
    <xsl:apply-templates select="@id" />
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="abstract">
  <hr class="upperBorder"/>
  <h2 class="abstractHeader">Abstract</h2>
  <hr class="lowerBorder"/>
  <div class="abstract">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- Body -->
<xsl:template match="body">
  <hr class="upperBorder"/>
  <h2 class="tocHeader">Table of Contents</h2>
  <hr class="lowerBorder"/>
  <p class="toc">
    <xsl:apply-templates select=".//title" mode="toc"/>
    <xsl:apply-templates select="/descendant::ftnote[position()=1]" mode="toc"/>
    <xsl:apply-templates select="..//acknowl|..//bibliog" mode="toc"/>
  </p>
  <xsl:apply-templates/>
  <xsl:apply-templates select="/descendant::ftnote[position()=1]" mode="footerStart"/>
</xsl:template>

<!-- Rear matter -->
<xsl:template match="acknowl">
  <h2 class="acknowlHeader">
    <a id="S.Acknowledgements">Acknowledgements</a>
  </h2>
  <div class="acknowl">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="acknowl/title">
  <h3 class="acknowlTitle">
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="bibliog">
  <h2 class="bibliogHeader">
    <a id="S.Bibliography">Bibliography</a>
  </h2>
  <dl class="bibliog">
    <xsl:apply-templates/>
  </dl>
</xsl:template>

<xsl:template match="bib">
  <dt class="bib">
    <xsl:apply-templates select="../@id"/>
    <b>[<xsl:apply-templates/>]</b>
  </dt>
</xsl:template>

<xsl:template match="@id">
  <a id="{.}"/>
</xsl:template>

<xsl:template match="pub">
  <dd class="pub">
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<xsl:template match="bibref">
  <a href="#{@refloc}" class="bibref">
    <b>[<xsl:value-of select="//bibitem[@id=current()/@refloc]/bib/text()"/>]</b>
  </a>
  <xsl:text> </xsl:text>
</xsl:template>

<!-- Elements that get copied -->
<xsl:template match="b|big|code|i|small|sub|sup|tt|li">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@id"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- Paragraphs -->
<xsl:template match="para">
  <p>
    <xsl:apply-templates select="@id"/>
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match="li/*[position()=1 and self::para]">
  <xsl:apply-templates select="@id"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="li/*[position()&gt;1 and self::para]">
  <br />
  <xsl:apply-templates select="@id"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="def/para[1]">
  <xsl:apply-templates select="@id"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="def/para[position()&gt;1]">
  <br />
  <xsl:apply-templates select="@id"/>
  <xsl:apply-templates/>
</xsl:template>

<!-- Inline keywords and anchors generated for all keywords -->
<xsl:template match="para/keyword" name="keywordAnchor">
  <xsl:variable name="anchor">
    <xsl:text>K</xsl:text>
    <xsl:number format="1." level="any"/>
    <xsl:value-of select="translate(text(),' ','.')"/>
  </xsl:variable>
  <a id="{$anchor}" title="{text()}"/>
</xsl:template>

<!-- Citations -->
<xsl:template match="cit">
  <cite>
    <xsl:apply-templates/>
  </cite>
</xsl:template>

<!-- Quotes -->
<xsl:template match="lquote">
  <blockquote class="lquote">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<!-- Acronyms -->
<xsl:template match="acronym">
  <acronym>
    <a>
      <xsl:apply-templates select="@refid"/>
      <xsl:apply-templates/>
    </a>
  </acronym>
</xsl:template>

<xsl:template match="acronym/@refid">
  <xsl:attribute name="href">
    <xsl:text>#</xsl:text>
    <xsl:value-of select="."/>
  </xsl:attribute>
</xsl:template>

<xsl:template match="acronym.grp/expansion">
  <xsl:apply-templates select="@id"/>
  <xsl:text> (</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>) </xsl:text>
</xsl:template>

<!-- Lists -->
<xsl:template match="randlist" name="randTemplate">
  <xsl:apply-templates select="title"/>
  <ul>
    <xsl:apply-templates select="@style"/>
    <xsl:if test="not(@style)">
      <xsl:attribute name="class">bulleted</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="li"/>
  </ul>
</xsl:template>

<xsl:template match="para/randlist">
  <xsl:text disable-output-escaping="yes">&lt;/p></xsl:text>
  <xsl:call-template name="randTemplate"/>
  <xsl:text disable-output-escaping="yes">&lt;p></xsl:text>
</xsl:template>

<xsl:template match="li/para/randlist|def/para/randlist" priority="1">
  <xsl:call-template name="randTemplate"/>
</xsl:template>

<xsl:template match="randlist/title">
  <h6 class="randlistTitle">
    <xsl:apply-templates/>
  </h6>
</xsl:template>

<xsl:template match="randlist/@style"/>

<xsl:template match="randlist/@style[.='simple']" priority="1">
  <xsl:attribute name="class">simple</xsl:attribute>
</xsl:template>

<xsl:template match="randlist/@style[.='bulleted']" priority="1">
  <xsl:attribute name="class">bulleted</xsl:attribute>
</xsl:template>

<xsl:template match="randlist/@style[.='dashed']" priority="1">
  <xsl:attribute name="class">dashed</xsl:attribute>
</xsl:template>

<xsl:template match="seqlist" name="seqTemplate">
  <xsl:apply-templates select="title"/>
  <ol>
    <xsl:apply-templates select="@number"/>
    <xsl:if test="not(@number)">
      <xsl:attribute name="class">arabic</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="li"/>
  </ol>
</xsl:template>

<xsl:template match="para/seqlist">
  <xsl:text disable-output-escaping="yes">&lt;/p></xsl:text>
  <xsl:call-template name="seqTemplate"/>
  <xsl:text disable-output-escaping="yes">&lt;p></xsl:text>
</xsl:template>

<xsl:template match="li/para/seqlist|def/para/seqlist" priority="1">
  <xsl:call-template name="seqTemplate"/>
</xsl:template>

<xsl:template match="seqlist/title">
  <h6 class="seqlistTitle">
    <xsl:apply-templates/>
  </h6>
</xsl:template>

<xsl:template match="seqlist/@number"/>

<xsl:template match="seqlist/@number[.='arabic']" priority="1">
  <xsl:attribute name="class">arabic</xsl:attribute>
</xsl:template>

<xsl:template match="seqlist/@number[.='ualpha']" priority="1">
  <xsl:attribute name="class">ualpha</xsl:attribute>
</xsl:template>

<xsl:template match="seqlist/@number[.='uroman']" priority="1">
  <xsl:attribute name="class">uroman</xsl:attribute>
</xsl:template>

<xsl:template match="seqlist/@number[.='lalpha']" priority="1">
  <xsl:attribute name="class">lalpha</xsl:attribute>
</xsl:template>

<xsl:template match="seqlist/@number[.='lroman']" priority="1">
  <xsl:attribute name="class">lroman</xsl:attribute>
</xsl:template>

<xsl:template match="deflist" name="defTemplate">
  <xsl:apply-templates select="title"/>
  <dl>
    <xsl:apply-templates select="*[not(self::title)]"/>
  </dl>
</xsl:template>

<xsl:template match="para/deflist">
  <xsl:text disable-output-escaping="yes">&lt;/p></xsl:text>
  <xsl:call-template name="defTemplate"/>
  <xsl:text disable-output-escaping="yes">&lt;p></xsl:text>
</xsl:template>

<xsl:template match="li/para/deflist|def/para/deflist" priority="1">
  <xsl:call-template name="defTemplate"/>
</xsl:template>

<xsl:template match="deflist/title">
  <h6 class="deflistTitle">
    <xsl:apply-templates/>
  </h6>
</xsl:template>

<xsl:template match="term.heading">
  <dt class="termHeading"><i>
    <xsl:apply-templates/>
  </i></dt>
</xsl:template>

<xsl:template match="def.heading">
  <dd class="defHeading"><i>
    <xsl:apply-templates/>
  </i></dd>
</xsl:template>

<xsl:template match="def.term">
  <dt>
    <xsl:apply-templates/>
  </dt>
</xsl:template>

<xsl:template match="def">
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- Code blocks -->
<xsl:template match="code.block">
  <table class="codeBlock">
    <tr><td><pre>
      <xsl:apply-templates/>
     </pre></td></tr>
  </table>
</xsl:template>

<!-- Notes -->
<xsl:template match="note">
  <table class="note">
    <tr>
      <td>
        <p>
          <span class="noteHeader">
            <xsl:text>NOTE: </xsl:text>
          </span>
          <xsl:apply-templates select="para[1]/node()"/>
        </p>
        <xsl:apply-templates select="para[position()&gt;1]"/>
       </td>
    </tr>
  </table>
</xsl:template>

<!-- Hyperlinks -->
<xsl:template match="a">
  <a href="{@href}">
    <xsl:value-of select="@href"/>
  </a>
</xsl:template>

<!-- Footnotes -->
<xsl:template match="fnref">
  <a href="#{@refloc}" class="fnref"><b>
    <xsl:apply-templates select="//ftnote[@id=current()/@refloc]" mode="reference"/>
  </b></a>
</xsl:template>

<xsl:template match="ftnote|ftnote//*" mode="reference" priority="-0.1">
  <xsl:text>[</xsl:text>
  <xsl:value-of select="count(preceding::ftnote)+count(ancestor-or-self::ftnote)"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="ftnote">
  <a href="#FT{count(preceding::ftnote)+count(ancestor-or-self::ftnote)}" class="fnref"><b>
    <xsl:apply-templates select="." mode="reference"/>
  </b></a>
</xsl:template>

<xsl:template match="ftnote" mode="footerStart">
  <h2 class="ftnoteHeader">
    <a id="S.Footnotes">Footnotes</a>
  </h2>
  <ol class="ftnote">
    <xsl:apply-templates select="//ftnote" mode="footer"/>
  </ol>
</xsl:template>

<xsl:template match="ftnote" mode="footer">
  <li>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<xsl:template match="ftnote/para[1]">
  <p>
    <a id="FT{count(preceding::ftnote)+count(ancestor-or-self::ftnote)}"/>
    <xsl:apply-templates select="../@id" />
    <xsl:apply-templates select="@id" />
    <xsl:apply-templates/>
  </p>
</xsl:template>

<!-- Internal links -->
<xsl:template match="xref">
  <a href="#{@refloc}" class="xref"><b>
    <xsl:apply-templates select="//*[@id=current()/@refloc]" mode="reference"/>
  </b></a>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="figure|figure//*" mode="reference" priority="-0.15">
  <xsl:text>Figure </xsl:text>
  <xsl:value-of select="count(preceding::figure)+1"/>
</xsl:template>

<xsl:template match="table|table//*" mode="reference" priority="-0.2">
  <xsl:text>Table </xsl:text>
  <xsl:value-of select="count(preceding::table)+count(ancestor-or-self::table)"/>
</xsl:template>

<xsl:template match="section" mode="reference">
  <xsl:choose>
    <xsl:when test="/gcapaper/@secnumbers='1'">
      <xsl:text>Chapter </xsl:text>
      <xsl:value-of select="count(preceding::section)+1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="title//text()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="subsec1|subsec2|subsec3" mode="reference">
  <xsl:choose>
    <xsl:when test="/gcapaper/@secnumbers='1'">
      <xsl:text>Section </xsl:text>
      <xsl:number level="multiple" format="1.1.1.1"
        count="section|subsec1|subsec2|subsec3"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="title//text()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="bio" mode="reference">
  <xsl:apply-templates select="preceding-sibling::fname|preceding-sibling::surname"/>
</xsl:template>

<xsl:template match="*" mode="reference">
  <xsl:text>Paragraph </xsl:text>
  <xsl:value-of select="count(preceding::para)+count(ancestor-or-self::para)-count(preceding::ftnote//para)"/>
</xsl:template>

<!-- The table element and its descendants are copied -->
<xsl:template match="table">
  <table>
    <xsl:attribute name="class">table</xsl:attribute>
    <xsl:apply-templates select="*|@*|text()" mode="copy"/>
  </table>
  <blockquote class="tableHeader">
    <p>
      <b>
        <xsl:text>Table </xsl:text>
        <xsl:value-of select="count(preceding::table)+count(ancestor-or-self::table)"/>
      </b>
    </p>
  </blockquote>
</xsl:template>

<xsl:template match="td|th|caption" mode="copy">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*" mode="copy"/>
    <!-- Resume normal translation upon exit of table module -->
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="*|@*|text()" mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="@*|text()" mode="copy">
  <xsl:copy>
    <xsl:apply-templates select="*|@*|text()" mode="copy"/>
  </xsl:copy>
</xsl:template>

<!-- Figures -->
<xsl:template match="figure">
  <div class="figure">
    <xsl:apply-templates select="@id"/>
    <xsl:apply-templates select="graphic|code.block|para[1]"/>
    <xsl:if test="not(title)">
      <xsl:call-template name="figureNumber"/>
    </xsl:if>
    <xsl:apply-templates select="title|figcaption"/>
  </div>
</xsl:template>

<xsl:template name="figureNumber">
  <blockquote class="figureTitle">
    <p>
      <b>
        <xsl:text>Figure </xsl:text>
        <xsl:value-of select="count(preceding::figure)+1"/>
      </b>
    </p>
  </blockquote>
</xsl:template>

<xsl:template match="figure/title">
  <blockquote class="figureTitle">
    <p>
      <b>
        <xsl:text>Figure </xsl:text>
        <xsl:value-of select="count(preceding::figure)+1"/>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates/>
      </b>
    </p>
  </blockquote>
</xsl:template>

<xsl:template match="figcaption">
  <blockquote class="figcaption">
    <xsl:apply-templates/>
  </blockquote>
</xsl:template>

<xsl:template match="figure/para[1]">
  <blockquote class="figurePara">
    <p>
      <xsl:apply-templates select="@id"/>
      <xsl:apply-templates/>
    </p>
    <xsl:apply-templates select="following-sibling::para"/>
  </blockquote>
</xsl:template>

<xsl:template match="graphic">
  <div class="graphic">
    <xsl:call-template name="Image"/>
  </div>
</xsl:template>

<xsl:template name="Image" match="inline.graphic">
  <xsl:variable name="altText">
    <xsl:choose>
      <xsl:when test="boolean(@href)">
        <!-- If there is an href attribute, use it directly -->
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Otherwise, there is a figname attribute that takes an entity -->
        <xsl:value-of select="@figname"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="srcURL">
    <xsl:choose>
      <xsl:when test="boolean(@href)">
        <!-- If there is an href attribute, use it directly -->
        <xsl:value-of select="@href"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- Otherwise, there is a figname attribute that takes an entity -->
        <!-- Compute the relative URI of the graphic file -->
        <xsl:call-template name="SubstringAfterLast">
          <xsl:with-param name="string" select="unparsed-entity-uri(@figname)"/>
          <xsl:with-param name="token" select="'/'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- If this is an SVG file, use the 'object' element -->
  <xsl:choose>
    <xsl:when test="substring-after(@href,'.')='svg' or substring-after(@href,'.')='svgz'">
      <object type="image/svg+xml" data="{$srcURL}">
        <xsl:call-template name="dimensions" />
        <xsl:value-of select="$altText"/>
      </object>
    </xsl:when>
    <xsl:otherwise>
      <img alt="{$altText}" src="{$srcURL}">
        <xsl:call-template name="dimensions" />
      </img>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Template to insert width and height attributes as appropriate -->
<xsl:template name="dimensions">
  <!-- If scaled, use given height and width numbers as pixels.
       When height and width are given in CSS units (e.g. "6in"), compute
       pixels assuming 96dpi. When in unrecognized units, set width="100%" -->
  <xsl:if test="@scalefit='1'">
    <xsl:variable name="pixelWidth">
      <xsl:choose>
        <xsl:when test="@width">
          <xsl:call-template name="ConvertToPixels">
            <xsl:with-param name="length" select="@width"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>400</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="pixelHeight">
      <xsl:choose>
        <xsl:when test="@height">
          <xsl:call-template name="ConvertToPixels">
            <xsl:with-param name="length" select="@height"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>300</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="number($pixelWidth) &gt; 0 or number($pixelHeight) &gt; 0">
        <xsl:if test="number($pixelWidth) &gt; 0">
          <xsl:attribute name="width">
            <xsl:value-of select="$pixelWidth"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="number($pixelHeight) &gt; 0">
          <xsl:attribute name="height">
            <xsl:value-of select="$pixelHeight"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="width">100%</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- Utility function to convert lengths to pixels -->
<xsl:template name="ConvertToPixels">
  <xsl:param name="length"/>
  <xsl:variable name="pixels" select="number(substring-before($length,'px'))"/>
  <xsl:variable name="inches" select="number(substring-before($length,'in'))"/>
  <xsl:variable name="cms" select="number(substring-before($length,'cm'))"/>
  <xsl:variable name="mms" select="number(substring-before($length,'mm'))"/>
  <xsl:variable name="pts" select="number(substring-before($length,'pt'))"/>
  <xsl:variable name="picas" select="number(substring-before($length,'pc'))"/>
  <xsl:choose>
    <xsl:when test="boolean(number($length))">
      <xsl:value-of select="$length"/>
    </xsl:when>
    <xsl:when test="boolean($pixels)">
      <xsl:value-of select="$pixels"/>
    </xsl:when>
    <xsl:when test="boolean($inches)">
      <xsl:value-of select="96 * $inches"/>
    </xsl:when>
    <xsl:when test="boolean($cms)">
      <xsl:value-of select="(96 * $cms) div 2.54"/>
    </xsl:when>
    <xsl:when test="boolean($mms)">
      <xsl:value-of select="(96 * $mms) div 25.4"/>
    </xsl:when>
    <xsl:when test="boolean($pts)">
      <xsl:value-of select="(96 * $pts) div 72"/>
    </xsl:when>
    <xsl:when test="boolean($picas)">
      <xsl:value-of select="(96 * $picas) div 6"/>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Utility function to find the substring after the last occurrence of a token -->
<xsl:template name="SubstringAfterLast">
  <xsl:param name="string"/>
  <xsl:param name="token"/>
  <xsl:choose>
    <xsl:when test="contains($string,$token)">
      <xsl:call-template name="SubstringAfterLast">
        <xsl:with-param name="string" select="substring-after($string,$token)"/>
        <xsl:with-param name="token" select="$token"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Section/subsection titles become h2, h3, h4, h5
     The titles are numbered if the secnumbers attribute is 1
     Two kinds of anchors are generated at each heading:
     1. An anchor whose name is the section id attribute, if it exists
     2. A unique numerical anchor used by Table of Contents -->
<xsl:template match="section|subsec1|subsec2|subsec3">
  <xsl:apply-templates select="keyword[1]|*[not(self::keyword)]"/>
</xsl:template>

<xsl:template match="section/title">
  <h2>
    <xsl:call-template name="anchoredNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="single" format="1."
          count="section"/>
      </xsl:with-param>
    </xsl:call-template>
  </h2>      
</xsl:template>

<xsl:template match="subsec1/title">
  <h3>
    <xsl:call-template name="anchoredNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="multiple" format="1.1"
          count="section|subsec1"/>
      </xsl:with-param>
    </xsl:call-template>
  </h3>      
</xsl:template>

<xsl:template match="subsec2/title">
  <h4>
    <xsl:call-template name="anchoredNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="multiple" format="1.1.1"
          count="section|subsec1|subsec2"/>
      </xsl:with-param>
    </xsl:call-template>
  </h4>      
</xsl:template>

<xsl:template match="subsec3/title">
  <h5>
    <xsl:call-template name="anchoredNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="multiple" format="1.1.1.1"
          count="section|subsec1|subsec2|subsec3"/>
      </xsl:with-param>
    </xsl:call-template>
  </h5>      
</xsl:template>

<xsl:template name="anchoredNumberedTitle">
  <xsl:param name="prefix"/>
  <xsl:apply-templates select="../@id"/>
  <a id="S{$prefix}">
    <xsl:if test="/gcapaper/@secnumbers='1'">
      <xsl:value-of select="$prefix"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </a>
</xsl:template>

<xsl:template match="section/keyword[1]|subsec1/keyword[1]
  |subsec2/keyword[1]|subsec3/keyword[1]">
  <p class="sectKeyword">
    <i class="sectKeywordHeader"><xsl:text>Keywords: </xsl:text></i>
    <xsl:call-template name="keywordAnchor"/>
    <xsl:apply-templates/>
    <xsl:apply-templates select="following-sibling::keyword"/>
  </p>
</xsl:template>

<!-- Table of Contents -->
<xsl:template match="title" mode="toc"/>

<xsl:template match="section/title" mode="toc">
  <b>
    <xsl:call-template name="linkedNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="single" format="1."
          count="section"/>
      </xsl:with-param>
    </xsl:call-template>
  </b>
  <br/>
</xsl:template>

<xsl:template match="subsec1/title" mode="toc">
  <xsl:text disable-output-escaping="yes">
    <![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;]]>
  </xsl:text>
    <xsl:call-template name="linkedNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="multiple" format="1.1"
          count="section|subsec1"/>
      </xsl:with-param>
    </xsl:call-template>
  <br/>
</xsl:template>

<xsl:template match="subsec2/title" mode="toc">
  <xsl:text disable-output-escaping="yes">
    <![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]>
  </xsl:text>
    <xsl:call-template name="linkedNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="multiple" format="1.1.1"
          count="section|subsec1|subsec2"/>
      </xsl:with-param>
    </xsl:call-template>
  <br/>
</xsl:template>

<xsl:template match="subsec3/title" mode="toc">
  <xsl:text disable-output-escaping="yes">
    <![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp;&nbsp;&nbsp;]]>
  </xsl:text>
    <xsl:call-template name="linkedNumberedTitle">
      <xsl:with-param name="prefix">
        <xsl:number level="multiple" format="1.1.1.1"
          count="section|subsec1|subsec2|subsec3"/>
      </xsl:with-param>
    </xsl:call-template>
  <br/>
</xsl:template>

<xsl:template name="linkedNumberedTitle">
  <xsl:param name="prefix"/>
  <a href="#S{$prefix}">
    <xsl:if test="/gcapaper/@secnumbers='1'">
      <xsl:value-of select="$prefix"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates mode="titleText"/>
  </a>
</xsl:template>

<xsl:template match="expansion|ftnote" mode="titleText"/>

<xsl:template match="text()" mode="titleText">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="ftnote" mode="toc">
  <b><a href="#S.Footnotes">Footnotes</a></b>
  <br/>
</xsl:template>

<xsl:template match="acknowl" mode="toc">
  <b><a href="#S.Acknowledgements">Acknowledgements</a></b>
  <br/>
</xsl:template>

<xsl:template match="bibliog" mode="toc">
  <b><a href="#S.Bibliography">Bibliography</a></b>
  <br/>
</xsl:template>

</xsl:stylesheet>
