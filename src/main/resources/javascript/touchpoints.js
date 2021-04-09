function getJSONUrl(type, uuid, jsonUrl) {
    $.ajax({
        url: jsonUrl,
        dataType: 'json',
        success: function (result) {
            if (type == 'Orders') {
                console.info("Module - Touchpoints: Building " + type + " table...");
                buildOrders(uuid, result);
            } else if (type == 'Tickets') {
                console.info("Module - Touchpoints: Building " + type + " table...");
                buildTickets(uuid, result);
            } else {
                console.error("Error-No table type found");
                return;
            }
        },
        error: function (jqXHR, textStatus, error) {
            console.log("Error-" + textStatus + "-" + error);
        }
    });
}

function getJSONBody(type, uuid, jsonBody) {
    if (type == 'Orders') {
        console.info("Module - Touchpoints: Building " + type + " table...");
        buildOrders(uuid, jsonBody);
    } else if (type == 'Tickets') {
        console.info("Module - Touchpoints: Building " + type + " table...");
        buildTickets(uuid, jsonBody);
    } else {
        console.error("Error-No table type found");
        return;
    }
}

function buildTickets(uuid, result) {
    var tableID = '#table-' + uuid;
    $(tableID).DataTable({
        data: result.items,
        order: [[4, "desc"]],
        columns: [
            {data: "CriticalFlag"},
            {data: "SeverityCdMeaning"},
            {data: "SrNumber"},
            {data: "Title"},
            {data: "LastUpdateDate"},
            {data: "StatusCdMeaning"}
        ],
        columnDefs: [
            {
                title: " ", targets: 0, orderable: false, render: function (data, type, row, meta) {
                    var image = '';
                    if (data === true) {
                        image = '<img alt="Critical" src="/modules/customer-portal/img/alert.png">';
                    }
                    return image;
                }
            },
            {title: "Severity", targets: 1, orderable: false},
            {title: "Number", targets: 2, orderable: false},
            {
                title: "Title", targets: 3, orderable: false, render: function (data, type, row, meta) {
                    if (data.length > 30) {
                        return data.substring(0, 30) + '...';
                    } else {
                        return data;
                    }
                }
            },
            {
                title: "Last Updated", targets: 4, orderable: true, render: function (data, type, row, meta) {
                    return formatDate(data, true)
                }, type: "date"
            },
            {title: "Status", targets: 5, orderable: false},
            {
                title: "", targets: 6, orderable: false, className: 'dt-body-right', render: function (data, type, row, meta) {
                    return '<a href=""><img height="25px" width="25px" alt="Chat"' +
                        ' src="/modules/customer-portal/img/chat.png"></a>';
                }
            }
        ],
        language: {
            emptyTable: 'No Tickets found'
        },
        lengthChange: false,
        pageLength: 3,
        destroy: true,
        searching: false
    });
}

function buildOrders(uuid, result) {
    var tableID = '#table-' + uuid;
    $(tableID).DataTable({
        data: result.items,
        order: [[3, "asc"]],
        columns: [
            {data: "WebOrder"},
            {data: "Invoice"},
            {data: "Product"},
            {data: "Date"}
        ],
        columnDefs: [
            {title: "Web Order #", targets: 0, orderable: false},
            {title: "Invoice #", targets: 1, orderable: false},
            {title: "Product", targets: 2, orderable: false},
            {
                title: "Date", targets: 3, orderable: false,
                render: function (data, type, row, meta) {
                    return formatDate(data, false)
                }
            },
            {
                title: "", targets: 4, orderable: false, className: 'dt-body-right',
                render: function (data, type, row, meta) {
                    return '<a href=""><img height="25px" width="25px" alt="Details"' +
                        ' src="/modules/customer-portal/img/orders.png"></a>';
                }
            }
        ],
        language: {emptyTable: 'No Orders found'},
        lengthChange: false,
        pageLength: 3,
        destroy: true,
        searching: false
    });
}

function formatDate(value, showTime) {
    if (value === null) return "";

    function addZero(i) {
        if (i < 10) {
            i = "0" + i;
        }
        return i;
    }

    var mydate = new Date(value);
    var yyyy = mydate.getFullYear().toString();
    var mm = addZero((mydate.getMonth() + 1).toString()); // getMonth() is zero-based
    var dd = addZero(mydate.getDate().toString());
    var h = mydate.getHours();
    var ap = "AM";
    if (h > 12) {
        h -= 12;
        ap = "PM";
    } else if (h === 0) {
        h = 12;
    }
    var m = mydate.getMinutes();
    var parts;
    if (m <= 0) {
        parts = mm + '/' + dd + '/' + yyyy;
    } else {
        if (showTime) {
            parts = mm + '/' + dd + '/' + yyyy + ' ' + addZero(h) + ':' + addZero(m) + ' ' + ap;
        } else {
            parts = mm + '/' + dd + '/' + yyyy;
        }
    }
    var mydatestr = new Date(parts);
    return parts;
}