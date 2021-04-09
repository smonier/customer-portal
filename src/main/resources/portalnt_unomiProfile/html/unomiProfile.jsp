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
<template:addResources type="css" resources="unomiProfile.css"/>
<template:addResources type="javascript" resources="unomiProfile.js"/>

<c:set var="title" value="${currentNode.properties['jcr:title'].string}"/>
<c:set var="profileProperties" value="${currentNode.properties['jExpProperty']}"/>

<jcr:nodeProperty node="${currentNode}" name="j:defaultCategory" var="categories"/>

<div class="ml-auto profile-loaded-subscriber">
    <div class="container profile-data"></div>
</div>

<c:if test="${renderContext.loggedIn}">
    <jcr:node path="${currentUser.localPath}/profilePrefs" var="userPrefloc"/>
    <c:forEach items="${listUserPrefs.nodes}" var="prefs" varStatus="status">
        <c:set var="prefList" value="${prefList},${prefs.name}"/>
    </c:forEach>

    <script type="text/javascript">
        let portalPrefs = [];
        $(document).ready(function () {
            $(".profile-loaded-subscriber").bind("profileLoaded", (e, data) => {
                //var portalPrefs = data.profileProperties.portalInterests;
                var portalPrefs = data.profileProperties.leadPreferences;
                if (portalPrefs != null) {
                    portalPrefs.forEach(setChecked);

                    function setChecked(item, index) {
                        document.getElementById(item).checked = true;
                    }
                }
            });
            $('.form-check-input').click(function () {
                $('.form-check-input').not(this).prop('checked', false);
            });
        });
    </script>

    <div id="unomiProfile">
        <div class="module_header">
            <div class="module_title">${title}</div>
            <div class="module_divider"></div>
        </div>
        <div class="module_body">
            <div class="userGreeting">
                <span id="userGreeting"></span>
            </div>
            <div class="userTable">
                <div class="userPicCol">
                    <img id="userPic" class="profile-picture" src="/modules/jexperience/images/default-profile.jpg"/>
                    <div style="font-size:14px"><a data-toggle="modal" data-target="#myModal" href="">Personalize</a></div>
                </div>
                <div class="userCol">
                    <div class="profileTable">
                        <div class="profileRow">
                            <div class="profileCol">
                                <span id="firstName">Anonymous</span>&nbsp;<span id="lastName"></span>
                            </div>
                        </div>
                        <div class="profileRow">
                            <div class="profileCol">
                                <span id="userCompany">&nbsp;</span>
                            </div>
                        </div>
                        <div class="profileRow">
                            <div class="profileCol">
                                <span id="jobTitle">&nbsp;</span>
                            </div>
                        </div>
                        <div class="profileRow">
                            <div class="profileCol">
                                <a id="userEmail">&nbsp;</a>
                            </div>
                        </div>
                        <div class="profileRow">
                            <div class="profileCol">
                                <span id="userSince">&nbsp;</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div style="margin-top:10px;width:100%;">
                Need help?&nbsp;<a id="ownerEmail" href=""><span id="owner"></span></a>&nbsp;-&nbsp;<span
                    id="ownerPhone"></span>
            </div>
        </div>
    </div>
    <div id="portalPreferences">
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="module_header">
                        <div class="module_title">My Preferences</div>
                        <div class="module_divider"></div>
                    </div>
                    <form onsubmit="return false;" method="post"
                          id="profilePrefsForm">
                        <input id="pathURL"
                               value="<c:url value='${url.base}${currentNode.path}'/>" type="hidden"/>
                        <input name="jcrRedirectTo"
                               value="<c:url value='${url.base}${renderContext.mainResource.node.path}'/>" type="hidden"/>
                        <div class="modal-body">
                            <c:forEach items="${categories}" var="category">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="${category.node.name}"
                                           id="${category.node.name}" name="categoryPref"/>
                                    <label class="form-check-label" for="${category.node.name}">
                                            ${category.node.displayableName}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                        <div class="modal-buttons">
                            <button onclick="javascript:updateProfileProperties();" type="submit">Save changes</button>
                            <button type="button" data-dismiss="modal">Close</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</c:if>