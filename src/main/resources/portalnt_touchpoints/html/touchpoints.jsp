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
<template:addResources type="css" resources="touchpoints.css" />
<template:addResources type="javascript" resources="touchpoints.js" />
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<script type="text/javascript" src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<div id="touchpoints">
    <div class="module_header">
        <div class="module_title">${currentNode.displayableName}</div>
        <div class="module_divider"></div>
    </div>
    <jcr:sql var="result"
             sql="SELECT * FROM [portalnt:touchpointConfig] AS touchpointConfig WHERE ISDESCENDANTNODE(touchpointConfig, '${renderContext.site.path}') ORDER BY touchpointConfig.[jcr:title] ASC"/>
    <c:if test="${result.nodes != null && result.nodes.size > 0}">
        <div class="module_body">
            <div class="tabs">
                <c:forEach var="node" items="${result.nodes}">
                    <jcr:nodeProperty node="${node}" name="tabDisplayName" var="tabDisplayName"/>
                    <button class="tablinks" id="tablink-${node.properties['jcr:uuid'].string}">${tabDisplayName}</button>
                    <script>
                        $('#tablink-' + "${node.properties['jcr:uuid'].string}").on('click', function () {
                            $('[id^=widget-]').attr("style", "display: none"); //Hide the other tables
                            var tablinks = document.getElementsByClassName("tablinks");
                            for (i = 0; i < tablinks.length; i++) {
                                tablinks[i].className = tablinks[i].className.replace(" active", "");
                            }
                            document.getElementById("tablink-${node.properties['jcr:uuid'].string}").className += " active";
                            document.getElementById("widget-${node.properties['jcr:uuid'].string}").style.display = "block";
                        });
                    </script>
                </c:forEach>
            </div>
            <c:forEach var="node" items="${result.nodes}">
                <jcr:nodeProperty node="${node}" name="jsonType" var="jsonType"/>
                <jcr:nodeProperty node="${node}" name="jsonUrl" var="jsonUrl"/>
                <jcr:nodeProperty node="${node}" name="jsonBody" var="jsonBody"/>
                <jcr:nodeProperty node="${node}" name="defaultTab" var="defaultTab"/>
                <jcr:nodeProperty node="${node}" name="tabType" var="tabType"/>
                <div id="widget-${node.properties['jcr:uuid'].string}" class="tabcontent">
                    <c:if test="${defaultTab eq 'true'}">
                        <script>
                            document.getElementById("tablink-${node.properties['jcr:uuid'].string}").className += " active";
                            document.getElementById("widget-${node.properties['jcr:uuid'].string}").style.display = "block";
                        </script>
                    </c:if>
                    <c:if test="${(tabType eq 'Orders') or (tabType eq 'Tickets')}">
                        <c:if test="${(tabType eq 'Tickets')}">
                            <div
                                    style="float:left;line-height:12px;"><input style="font-size:12px" type="button"
                                                                                onclick="alert('Jira credentials required. Please contact Jahia portal administrator.')"
                                                                                value="New ticket"/></div>
                        </c:if>
                        <table id="table-${node.properties['jcr:uuid'].string}" class="display compact"
                               style="padding-top:5px;width:100%;"></table>
                        <c:if test="${(jsonType eq 'Url') and (not empty jsonUrl)}">
                            <script>
                                if ($.fn.DataTable.isDataTable("table-${node.properties['jcr:uuid'].string}")) { //Empty out previous table
                                    $("table-${node.properties['jcr:uuid'].string}").DataTable().clear().destroy();
                                    $("table-${node.properties['jcr:uuid'].string}").empty();
                                }
                                getJSONUrl("${tabType}", "${node.properties['jcr:uuid'].string}", "${jsonUrl}");
                            </script>
                        </c:if>
                        <c:if test="${(jsonType eq 'Body') and (not empty jsonBody)}">
                            <script>
                                if ($.fn.DataTable.isDataTable("table-${node.properties['jcr:uuid'].string}")) { //Empty out previous table
                                    $("table-${node.properties['jcr:uuid'].string}").DataTable().clear().destroy();
                                    $("table-${node.properties['jcr:uuid'].string}").empty();
                                }
                                var body = JSON.parse(JSON.stringify(${jsonBody}));
                                getJSONBody("${tabType}", "${node.properties['jcr:uuid'].string}", body);
                            </script>
                        </c:if>
                        <c:if test="${(empty jsonUrl) and (empty jsonBody)}">
                            <div style="height:180px">No data source (JSON) found</div>
                        </c:if>
                    </c:if>
                    <c:if test="${tabType eq 'Status'}">
                        <div style="padding-top:5px;height:180px;overflow-y:scroll;border-right:1px solid #f8f9fa;">
                            <%@ include file="status.jsp" %>
                        </div>
                    </c:if>
                    <c:if test="${tabType eq 'KPIs'}">
                        <div style="display:flex;justify-content: center;align-items: center; height:180px;">
                            <%@ include file="kpis.jsp" %>
                        </div>
                    </c:if>
                    <c:if test="${tabType eq 'YouTube'}">
                        <div style="padding-top:5px;height:185px;overflow-y:scroll;">
                            <%@ include file="youtube.jsp" %>
                        </div>
                    </c:if>
                    <c:if test="${tabType eq 'Twitter'}">
                        <div style="padding-top:5px;height:185px;overflow-y:scroll;">
                            <%@ include file="twitter.jsp" %>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </c:if>
    <c:if test="${result.nodes != null && result.nodes.size == 0}">
        <div class="warning-message">No touchpoint tabs found</div>
    </c:if>
</div>