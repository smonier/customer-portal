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
<template:addResources type="css" resources="contentList.css" />
<jcr:sql var="result"
         sql="SELECT * FROM [jcnt:article] AS tipstricks WHERE ISDESCENDANTNODE('/sites/www/contents/Tips and Tricks')"/>
<c:if test="${result.nodes != null && result.nodes.size > 0}">
    <c:set var="nodeSize" value="${result.nodes.size}"/>
    <%
        Long nodeSize = (Long)pageContext.getAttribute("nodeSize");
        int min = 0;
        int max = nodeSize.intValue();
        int rand = ((int) (Math.random()*(max - min))) + min;
        pageContext.setAttribute("rand", rand);
    %>
    <div id="tipstricks">
        <div class="module_header">
            <div class="module_title">${currentNode.properties['jcr:title'].string}</div>
            <div class="module_divider">&nbsp;</div>
        </div>
        <div class="module_body">
            <c:forEach var="node" items="${result.nodes}" begin="${rand}" end="${rand}">
                <h4 style="margin-top:10px;">${node.properties['jcr:title'].string}</h4>
                <p>${node.properties['text'].string}</p>
            </c:forEach>
        </div>
    </div>
</c:if>