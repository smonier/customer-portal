<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<template:addResources type="css" resources="customer-portal.css"/>
<template:addResources type="css" resources="contentList.css"/>
<template:addResources type="javascript" resources="owl.carousel.min.js"/>
<template:addResources type="css" resources="owl.carousel.min.css"/>
<c:set var="siteNode" value="${renderContext.site}"/>
<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="nodeUUID" value="${currentNode.UUID}"/>

<jcr:nodeProperty node="${currentNode}" name="categoryFilter" var="categoryFilter"/>
<jcr:nodeProperty node="${currentNode}" name="portalListType" var="portalListType"/>
<jcr:nodeProperty node="${currentNode}" name="maxItems" var="maxItems"/>

<c:choose>
    <c:when test="${portalListType eq 'contentList'}">
        <jcr:nodeProperty node="${currentNode}" name='contentFolder' var="contentFolderNode"/>
        <jcr:nodeProperty node="${currentNode}" name='contentType' var="contentType"/>
        <jcr:jqom var="listQuery"
                  limit="${currentResource.moduleParams.queryLoadAllUnsorted == 'true' ? -1 : maxItems.long}">

            <query:selector nodeTypeName="${contentType.string}"/>
            <query:descendantNode path="${contentFolderNode.getNode().path}"/>
            <query:or>
                <c:forEach var="filter" items="${categoryFilter}">
                    <c:if test="${not empty filter.string}">
                        <query:equalTo propertyName="j:defaultCategory" value="${filter.string}"/>
                    </c:if>
                </c:forEach>
            </query:or>
        </jcr:jqom>

    </c:when>
    <c:when test="${portalListType eq 'folderList'}">
        <jcr:nodeProperty node="${currentNode}" name='fileFolder' var="fileFolderNode"/>
        <c:set var="contentType" value="jnt:file"/>
        <jcr:jqom var="listQuery"
                  limit="${currentResource.moduleParams.queryLoadAllUnsorted == 'true' ? -1 : maxItems.long}">

            <query:selector nodeTypeName="${contentType}"/>
            <query:descendantNode path="${fileFolderNode.getNode().path}"/>
            <query:or>
                <c:forEach var="filter" items="${categoryFilter}">
                    <c:if test="${not empty filter.string}">
                        <query:equalTo propertyName="j:defaultCategory" value="${filter.string}"/>
                    </c:if>
                </c:forEach>
            </query:or>
        </jcr:jqom>
    </c:when>
</c:choose>

<div class="container">
    <div class="row">
        <div class="module_header">
            <div class="module_title">${currentNode.properties['jcr:title'].string}</div>
            <div class="module_divider">&nbsp;</div>
        </div>
    </div>
    <div class="row">
        <div class="module_body_noheight">
            <div  class="carousel slide" data-ride="carousel" id="portalCarousel-${nodeUUID}">
                <div class="carousel-inner">
                <c:forEach items="${listQuery.nodes}" var="objects" varStatus="status">
                    <div class="carousel-item  <c:if test='${status.first}'>active</c:if>">
                        <template:module node="${objects}" view="portal"/>
                    </div>
                </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

