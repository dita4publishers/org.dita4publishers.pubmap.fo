<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
  exclude-result-prefixes="xs ot-placeholder"
  version="2.0">
  <!-- Pubmap to XSLFO extensions for DITA Open Toolkit's PDF2 transform. 
    
       Copyright (c) DITA For Publishers 2010, 2015
  
  -->
  
  
  <xsl:template match="*[contains(@class, ' pubmap-d/part ')]" mode="determineTopicType" priority="10">
    <xsl:text>pubmapPart</xsl:text>
  </xsl:template>
  
  <!-- Handle unspecialized or unhandled topicrefs that are direct children of pubmap or bookmap part elements. These
       should be treated as chapters.
    -->
  <xsl:template match="*[contains(@class, '/part ')]/*[contains(@class, 'map/topicref')]" mode="determineTopicType" priority="5">
    <xsl:text>pubmapChapter</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/chapter ')]" mode="determineTopicType" priority="10">
    <xsl:text>pubmapChapter</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/article ')]" mode="determineTopicType" priority="10">
    <xsl:text>pubmapArticle</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/subsection ')]" mode="determineTopicType" priority="10">
    <xsl:text>pubmapSubsection</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/sidebar ')]" mode="determineTopicType" priority="10">
    <xsl:text>pubmapSidebar</xsl:text>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' pubmap-d/page ')]" mode="determineTopicType" priority="10">
    <xsl:text>pubmapPage</xsl:text>
  </xsl:template>
  
  
  <xsl:template match="*[contains(@class, ' topic/topic ')]">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
    <!-- This is a copy of this template from commons.xsl, since there's
         currently no way to extend it.
         
    -->
      <xsl:variable name="topicType">
          <xsl:call-template name="determineTopicType">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          </xsl:call-template>
      </xsl:variable>
    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] topic/topic: <xsl:value-of select="concat(name(..), '/', name(.))"/></xsl:message>
      <xsl:message> + [DEBUG] topic/topic: topicType="<xsl:value-of select="$topicType"/>"</xsl:message>
    </xsl:if>

      <xsl:choose>
        <!-- Pubmap stuff -->
        <xsl:when test="$topicType = 'pubmapPart'">
          <xsl:call-template name="processPubmapPart">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'pubmapChapter'">
          <xsl:call-template name="processPubmapChapter">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'pubmapSidebar'">
          <xsl:call-template name="processPubmapSidebar">
            <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'topicChapter'">
            <xsl:call-template name="processTopicChapter">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'topicAppendix'">
            <xsl:call-template name="processTopicAppendix">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'topicAppendices'">
            <xsl:call-template name="processTopicAppendices">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'topicPart'">
            <xsl:call-template name="processTopicPart">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'topicPreface'">
            <xsl:call-template name="processTopicPreface">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:when test="$topicType = 'topicNotices'">
            <xsl:if test="$retain-bookmap-order">
              <xsl:call-template name="processTopicNotices">
                <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
              </xsl:call-template>
            </xsl:if>
        </xsl:when>
        <xsl:when test="$topicType = 'topicSimple'">
            <xsl:variable name="page-sequence-reference">
                <xsl:choose>
                    <xsl:when test="$mapType = 'bookmap'">
                        <xsl:value-of select="'body-sequence'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'ditamap-body-sequence'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="(not(ancestor::*[contains(@class,' topic/topic ')]) and 
                                 not(ancestor::ot-placeholder:glossarylist)) 
                                ">
                    <fo:page-sequence master-reference="{$page-sequence-reference}" xsl:use-attribute-sets="__force__page__count">
                        <xsl:call-template name="startPageNumbering">
                          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
                        </xsl:call-template>
                        <xsl:call-template name="insertBodyStaticContents">
                          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
                        </xsl:call-template>
                        <fo:flow flow-name="xsl-region-body">
                            <xsl:choose>
                                <xsl:when test="contains(@class,' concept/concept ')"><xsl:apply-templates select="." mode="processConcept"/></xsl:when>
                                <xsl:when test="contains(@class,' task/task ')"><xsl:apply-templates select="." mode="processTask"/></xsl:when>
                                <xsl:when test="contains(@class,' reference/reference ')"><xsl:apply-templates select="." mode="processReference"/></xsl:when>
                                <xsl:otherwise><xsl:apply-templates select="." mode="processTopic">
                                  <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
                                </xsl:apply-templates></xsl:otherwise>
                            </xsl:choose>
                        </fo:flow>
                    </fo:page-sequence>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(@class,' concept/concept ')"><xsl:apply-templates select="." mode="processConcept"/></xsl:when>
                        <xsl:when test="contains(@class,' task/task ')"><xsl:apply-templates select="." mode="processTask"/></xsl:when>
                        <xsl:when test="contains(@class,' reference/reference ')"><xsl:apply-templates select="." mode="processReference"/></xsl:when>
                        <xsl:otherwise><xsl:apply-templates select="." mode="processTopic">
                          <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
                        </xsl:apply-templates></xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="processUnknowTopic">
              <xsl:with-param name="doDebug" as="xs:boolean" tunnel="yes" select="$doDebug"/>
              <xsl:with-param name="topicType" select="$topicType"/>
            </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="insertPartStaticContents">
    <xsl:call-template name="insertBodyStaticContents"/>
  </xsl:template>

  <xsl:template name="insertPartFirstpageStaticContent">
    
  </xsl:template>
  
  <xsl:template name="processPubmapPart">
    <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
      <xsl:call-template name="startPageNumbering"/>
      <xsl:call-template name="insertPartStaticContents"/>
      <fo:flow flow-name="xsl-region-body">
        <fo:block xsl:use-attribute-sets="topic">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
            <fo:marker marker-class-name="current-topic-number">
              <xsl:number format="1"/>
            </fo:marker>
            <fo:marker marker-class-name="current-header">
              <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getTitle"/>
            </fo:marker>
          </xsl:if>
          
          <xsl:call-template name="insertPubmapChapterFirstpageStaticContent">
            <xsl:with-param name="type" select="'part'"/>
          </xsl:call-template>      
          
          <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
          
          <fo:block xsl:use-attribute-sets="topic.title">
            <xsl:call-template name="pullPrologIndexTerms"/>
            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
              <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getTitle"/>
            </xsl:for-each>
          </fo:block>
          
          <fo:block>
            <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
              contains(@class, ' topic/prolog '))]"/>
            <xsl:apply-templates select="." mode="buildRelationships"/>
          </fo:block>
          
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
    
    <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
    
  </xsl:template>
  

  <xsl:template name="processPubmapChapter">
    <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
      <xsl:call-template name="startPageNumbering"/>
      <xsl:call-template name="insertBodyStaticContents"/>
      <fo:flow flow-name="xsl-region-body">
        <fo:block xsl:use-attribute-sets="topic">
          <xsl:attribute name="id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
          <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
            <fo:marker marker-class-name="current-topic-number">
              <xsl:number format="1"/>
            </fo:marker>
            <fo:marker marker-class-name="current-header">
              <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getTitle"/>
              </xsl:for-each>
            </fo:marker>
          </xsl:if>
          
          <xsl:call-template name="insertPubmapChapterFirstpageStaticContent">
            <xsl:with-param name="type" select="'chapter'"/>
          </xsl:call-template>      
          
          <fo:block xsl:use-attribute-sets="topic.title">
            <xsl:call-template name="pullPrologIndexTerms"/>
            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
              <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getTitle"/>
            </xsl:for-each>
          </fo:block>
          
          <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
          
          <fo:block>
            <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
              contains(@class, ' topic/prolog '))]"/>
            <xsl:apply-templates select="." mode="buildRelationships"/>
          </fo:block>
          
          <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
  
  
  <xsl:attribute-set name="pubmap-sidebar-container">
    <xsl:attribute name="border-before-style" select="'solid'"/>
    <xsl:attribute name="border-after-style" select="'solid'"/>
    <xsl:attribute name="border-start-style" select="'solid'"/>
    <xsl:attribute name="border-end-style" select="'solid'"/>
    <xsl:attribute name="border-width" select="'2pt'"/>
    <xsl:attribute name="padding" select="'2pc'"/>
  </xsl:attribute-set>
  
  <xsl:template name="processPubmapSidebar" match="*[contains(@class, ' sidebar/sidebar ')]" mode="processTopic">
    <fo:block
      xsl:use-attribute-sets="pubmap-sidebar-container"
      >
      <fo:block xsl:use-attribute-sets="topic">
        <xsl:apply-templates select="." mode="commonTopicProcessing"/>
      </fo:block>
    </fo:block>
  </xsl:template>
  
  <!-- NOTE: This is a copy of insertChapterFirstpageStaticContent from commons.xsl so that the logic for counting
             chapters can be overridden. At some point that counting should be made extensible so this copy is not
             required.
    -->
  <xsl:template name="insertPubmapChapterFirstpageStaticContent">
    <xsl:param name="type"/>
    <fo:block>
      <xsl:attribute name="id">
        <xsl:value-of select="concat('_OPENTOPIC_TOC_PROCESSING_', generate-id())"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="$type = 'chapter'">
          <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
            <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Chapter with number'"/>
              <xsl:with-param name="theParameters">
                <number>
                  <xsl:variable name="id" select="@id"/>
                  <xsl:variable name="topicChapters">
                    <xsl:copy-of select="$map//*[contains(@class, ' bookmap/chapter ')] | 
                      $map//*[contains(@class, ' pubmap-d/pubbody ')]/*[contains(@class, ' pubmap-d/chapter ')] | 
                      $map//*[contains(@class, ' pubmap-d/pubbody ')]/*[contains(@class, ' pubmap-d/part ')]/*[contains(@class, ' pubmap-d/chapter ')]
                      "/>
                  </xsl:variable>
                  <xsl:variable name="chapterNumber">
                    <xsl:number format="1" value="count($topicChapters/*[@id = $id]/preceding-sibling::*) + 1"/>
                  </xsl:variable>
                  <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                    <xsl:value-of select="$chapterNumber"/>
                  </fo:block>
                </number>
              </xsl:with-param>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
        <xsl:when test="$type = 'appendix'">
          <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
            <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Appendix with number'"/>
              <xsl:with-param name="theParameters">
                <number>
                  <xsl:variable name="id" select="@id"/>
                  <xsl:variable name="topicAppendixes">
                    <xsl:copy-of select="$map//*[contains(@class, ' bookmap/appendix ')] | 
                                         $map//*[contains(@class, ' pubmap-d/appendix ')]"/>
                  </xsl:variable>
                  <xsl:variable name="appendixNumber">
                    <xsl:number format="A" value="count($topicAppendixes/*[@id = $id]/preceding-sibling::*) + 1"/>
                  </xsl:variable>
                  <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                    <xsl:value-of select="$appendixNumber"/>
                  </fo:block>
                </number>
              </xsl:with-param>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
        
        <xsl:when test="$type = 'part'">
          <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
            <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Part with number'"/>
              <xsl:with-param name="theParameters">
                <number>
                  <xsl:variable name="id" select="@id"/>
                  <xsl:variable name="topicParts">
                    <xsl:copy-of select="$map//*[contains(@class, ' bookmap/part ')] | 
                                         $map//*[contains(@class, ' pubmap-d/part ')]"/>
                  </xsl:variable>
                  <xsl:variable name="partNumber">
                    <xsl:number format="I" value="count($topicParts/*[@id = $id]/preceding-sibling::*) + 1"/>
                  </xsl:variable>
                  <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                    <xsl:value-of select="$partNumber"/>
                  </fo:block>
                </number>
              </xsl:with-param>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
        <xsl:when test="$type = 'preface'">
          <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
            <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Preface title'"/>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
        <xsl:when test="$type = 'notices'">
          <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
            <xsl:call-template name="insertVariable">
              <xsl:with-param name="theVariableID" select="'Notices title'"/>
            </xsl:call-template>
          </fo:block>
        </xsl:when>
      </xsl:choose>
    </fo:block>
  </xsl:template>
  
</xsl:stylesheet>
