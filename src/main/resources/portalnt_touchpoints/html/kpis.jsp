<template:addResources type="css" resources="kpis.css" />
<script>
    console.info("Module - User Activity: Building KPIs table...");
</script>
<div class="kpiBoxes">
    <div class="kpiBox">
        <div style="width:100%;display:table;">
            <div style="display:table-row">
                <div class="kpiImage">
                    <img src="<c:url value="${url.currentModule}/img/hours.png"/>">
                </div>
                <div class="kpiValue">
                    <span>21</span>
                </div>
            </div>
        </div>
        <div style="width:100%;">
            <div class="kpiTitle">
                <span>Service Hours</span>
            </div>
        </div>
    </div>
    <div class="kpiBox">
        <div style="width:100%;display:table;">
            <div style="display:table-row">
                <div class="kpiImage">
                    <img src="<c:url value="${url.currentModule}/img/tickets.png"/>">
                </div>
                <div class="kpiValue">
                    <span>3</span>
                </div>
            </div>
        </div>
        <div style="width:100%;">
            <div class="kpiTitle">
                <span>Open Tickets</span>
            </div>
        </div>
    </div>
    <div class="kpiBox">
        <div style="width:100%;display:table;">
            <div style="display:table-row">
                <div class="kpiImage">
                    <img src="<c:url value="${url.currentModule}/img/uptime.png"/>">
                </div>
                <div class="kpiValue">
                    <span>100%</span>
                </div>
            </div>
        </div>
        <div style="width:100%;">
            <div class="kpiTitle">
                <span>Platform Uptime</span>
            </div>
        </div>
    </div>
</div>