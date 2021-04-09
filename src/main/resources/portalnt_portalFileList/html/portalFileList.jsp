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
<template:addResources type="css" resources="customer-portal.css" />
<template:addResources type="css" resources="fileList.css" />
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" />

<c:set var="targetNodePath" value="${renderContext.mainResource.node.path}"/>
<c:if test="${!empty param.targetNodePath}">
    <c:set var="targetNodePath" value="${param.targetNodePath}"/>
</c:if>
<c:if test="${!empty currentNode.properties['j:target']}">
    <c:set var="target" value="${currentNode.properties['j:target'].string}"/>
</c:if>
<c:if test="${!empty currentNode.properties.folder}">
    <c:set var="targetNodePath" value="${currentNode.properties.folder.node.path}"/>
</c:if>
<jcr:node var="targetNode" path="${targetNodePath}"/>
<c:set var="nodeSize" value="${targetNode.nodes.size}"/>
<div id="contentList-${currentNode.identifier}">
    <div class="module_header">
        <div class="module_title">${currentNode.properties['jcr:title'].string}</div>
        <div class="module_divider">&nbsp;</div>
    </div>
    <c:if test="${currentNode.properties['contentType'].string eq 'Case Studies'}">
        <div id="casestudies">
            <div class="module_body">
                <ul class="module_ul">
                    <c:forEach items="${targetNode.nodes}" var="subchild">
                        <li class="module_li">
                            <a href="${subchild.properties['j:subject'].string}" target="">${subchild.properties['jcr:title'].string}</a>
                            <div class="module_li_desc">${subchild.properties['jcr:description'].string}</div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </c:if>
    <c:if test="${currentNode.properties['contentType'].string eq 'Webinar Recordings'}">
        <div class="module_body">
            <div style="display:table;width:100%">
                <%
                    Long nodeSize = (Long)pageContext.getAttribute("nodeSize");
                    int min = 0;
                    int max = nodeSize.intValue();
                    int rand = ((int) (Math.random()*(max - min))) + min;
                    pageContext.setAttribute("rand", rand);
                %>
                <c:forEach items="${targetNode.nodes}" var="subchild" begin="${rand}" end="${rand}">
                    <div style="display: table-row;">
                        <div style="display:table-cell;width:100%;"><a href=""><img src="${url.files}${subchild.properties['j:fullpath'].string}"/></a></div>
                    </div>
                    <div style="display: table-row;">
                        <div style="display:table-cell;vertical-align:top">
                            <h4 style="margin-top:10px;">${subchild.properties['jcr:title'].string}</h4>
                            <p>${subchild.properties['jcr:description'].string}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
    <c:if test="${currentNode.properties['contentType'].string eq 'Product Information'}">
        <div class="module_body">
            <div style="display:table;width:100%;">
                <c:forEach items="${targetNode.nodes}" var="subchild">

                    <div style="display:table-row;text-align:center">
                        <div style="display:table-cell;width:100%;text-align:center"><center><a href=""><img style="height:300px;" src="${url.files}${subchild.properties['j:fullpath'].string}"/></a></center></div>
                    </div>
                    <div style="display: table-row;">
                        <div style="display:table-cell;vertical-align:top">
                            <h4 style="margin-top:10px;">${subchild.properties['jcr:title'].string}</h4>
                            <p>${subchild.properties['jcr:description'].string}</p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>
</div>
<template:addCacheDependency path="${targetNodePath}"/>