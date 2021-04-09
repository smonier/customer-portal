<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addResources type="javascript" resources="jquery.min.js,popper.min.js,bootstrap.min.js,owl.carousel.min.js"/>
<template:addResources type="css" resources="fileCarousel.css,owl.carousel.min.css,jquery.fancybox.min.css"/>

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
<c:set var="nodeUUID" value="${currentNode.UUID}"/>

<jcr:node var="targetNode" path="${targetNodePath}"/>
<div id="fileList${currentNode.identifier}">
    <div class="module_header">
        <div class="module_title">${currentNode.properties['jcr:title'].string}</div>
        <div class="module_divider">
        </div>
    </div>
    <div class="module_body">
        <div class="file-slider owl-carousel owl-theme col-sm4" id="fileCarousel-${nodeUUID}">

            <c:forEach items="${targetNode.nodes}" var="subchild">
                <c:if test="${jcr:isNodeType(subchild, 'jnt:file')}">
                    <div class="item">
                        <img src="${subchild.url}?t=thumbnail" alt="${subchild.name}"/><br/>

                        <template:module node="${subchild}" view="detail" editable="false">
                            <template:param name="useNodeNameAsTitle"
                                            value="${currentNode.properties.useNodeNameAsTitle.boolean}"/>
                            <template:param name="target" value="${target}"/>
                        </template:module>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>
</div>
<template:addCacheDependency path="${targetNodePath}"/>

<script>
    $('#fileCarousel-${nodeUUID}').owlCarousel({
        loop: true,
        margin: 10,
        dots: true,
        nav: true,
        autoplay: true,
        navText: ['<span class="ion-ios-arrow-back">', '<span class="ion-ios-arrow-forward">'],
        responsive: {
            0: {
                items: 1
            },
            600: {
                items: 1
            },
            1000: {
                items: 1
            }
        }
    });
</script>