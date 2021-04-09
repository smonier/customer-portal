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
<c:choose>
<c:when test="${jcr:isNodeType(currentNode, 'jmix:image')}">
    <div style="display: table-row;">
        <div style="display:table-cell;width:100%;"><a href=""><img
                src="${url.files}${currentNode.properties['j:fullpath'].string}"/></a></div>
    </div>
    <div style="display: table-row;">
        <div style="display:table-cell;vertical-align:top">
            <h4 style="margin-top:10px;">${currentNode.properties['jcr:title'].string}</h4>
            <p>${currentNode.properties['jcr:description'].string}</p>
        </div>
    </div>
</c:when>
    <c:otherwise>
        <div style="display: table-row;">
            <div style="display:table-cell;width:100%;"><a href="${currentNode.url}"><img
                    src="${currentNode.url}?t=thumbnail"/></a></div>
        </div>
        <div style="display: table-row;">
            <div style="display:table-cell;vertical-align:top">
                <h4 style="margin-top:10px;">${currentNode.properties['jcr:title'].string}</h4>
                <p>${currentNode.properties['jcr:description'].string}</p>
            </div>
        </div>

    </c:otherwise>
</c:choose>