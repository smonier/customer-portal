const USER_DATA_KEY = "wemUserData";

//Load the profile from Unomi
loadProfile = (completed) => {
    if (window.cxs === undefined) return;

    var url = window.digitalData.contextServerPublicUrl + '/context.json?sessionId=' + window.cxs.sessionId;
    var payload = {
        source: {
            itemId: window.digitalData.page.pageInfo.pageID,
            itemType: "page",
            scope: window.digitalData.scope
        },
        requiredProfileProperties: ["*"],
        requiredSessionProperties: ["*"],
        requireSegments: true
    };

    fetch(url, {
        method: 'POST',
        headers: {
            'Accept': "application/json",
            'Content-Type': "text/plain;charset=UTF-8"
        },
        body: JSON.stringify(payload)
    })
        .then((response) => response.json())
        .then((data) => {
            if (completed) {
                var profilePictureUrl,firstName,lastName,userCompany,jobTitle,userEmail,userSince,owner,ownerEmail,ownerPhone;
                if (data.profileProperties.profilePictureUrl) {
                    profilePictureUrl = data.profileProperties.profilePictureUrl;
                } else {
                    profilePictureUrl =  '/modules/jexperience/images/default-profile.jpg';
                }
                if (data.profileProperties.firstName) {
                    firstName = data.profileProperties.firstName;
                } else {
                    firstName = 'Anonymous';
                }
                if (data.profileProperties.lastName) {
                    lastName = data.profileProperties.lastName;
                }
                if (data.profileProperties.email) {
                    userEmail = data.profileProperties.email;
                } else {
                    userEmail = '<email>';
                }
                if (data.profileProperties.company) {
                    userCompany = data.profileProperties.company;
                } else {
                    userCompany = '<company>';
                }
                if (data.profileProperties.jobTitle) {
                    jobTitle = data.profileProperties.jobTitle;
                } else {
                    jobTitle = '<title>';
                }
                if (data.profileProperties.firstVisit) {
                    var mydate = new Date(data.profileProperties.firstVisit);
                    userSince = mydate.getFullYear().toString();
                }
                if (data.profileProperties.leadAssignedTo) {
                    owner = data.profileProperties.leadAssignedTo;
                } else {
                    owner = 'TBD';
                }
                if (data.profileProperties.AssignedToEmail) {
                    ownerEmail = data.profileProperties.AssignedToEmail;
                } else {
                    ownerEmail = 'TBD';
                }
                if (data.profileProperties.assignedToPhone){
                    ownerPhone = data.profileProperties.assignedToPhone;
                } else {
                    ownerPhone = 'TBD';
                }
                $("#userPic").attr("src", profilePictureUrl);
                $("#userGreeting").text(getGreeting() + firstName);
                $("#firstName").text(firstName);
                $("#lastName").text(lastName);
                $("#userCompany").text(userCompany);
                $("#jobTitle").text(jobTitle);
                $("#userEmail").attr("href", 'mailto:' + userEmail);
                $("#userEmail").text(userEmail);
                $("#userSince").text("Customer since " + userSince);
                $("#owner").text(owner);
                $("#ownerEmail").attr("href", 'mailto:' + ownerEmail);
                $("#ownerPhone").text(ownerPhone);

                completed(data);
            }
            //add the user data to window
            window[USER_DATA_KEY] = data;

            //notify any subscribers that the patient data has been loaded
            $(".profile-loaded-subscriber").trigger("profileLoaded", data);
        });
}

$(function () {
    var interval = setInterval(loadProfile, 500, (data) => {
        clearInterval(interval);
    });
});

function walk(obj,target) {
    for (var key in obj) {
        if (obj.hasOwnProperty(key)) {
            var val = obj[key];
            $("<p>").html(key + " : " +val).appendTo(target);
            if(typeof(val) === "object"){
                walk(val);
            }
        }
    }
}

function contains(array, value) {
    for (var i = 0; i < array.length; i++) {
        if (array[i] === value) {
            return true;
        }
    }
    return false;
}

/**
 * This function update profile properties.
 *
 */
updateProfileProperties = function () {
    var propertyValue = $('#profilePrefsForm [type="checkbox"]:checked').map(function () {
        return this.value;
    }).get();
    var pathURL = document.getElementById("pathURL").value;
    //const propertyKey = "portalInterests";
    const propertyKey = "leadPreferences";
    console.info('[UNOMI-PROFILE-CARD] Call event update profile properties: '+pathURL+' - '+propertyValue);
    wem.ajax({
        url: encodeURI(pathURL + '.updatePortalProfile.do'),
        type: 'POST',
        dataType: 'application/json',
        contentType: 'application/json',
        data: JSON.stringify(
            {
                'profileId': cxs.profileId,
                'sessionId': wem.sessionID,
                'propertyKey': propertyValue ? propertyKey : '',
                'propertyValue': propertyValue ? propertyValue : ''
            }
        ),
        success: function (data) {
            console.log(data);
            var result = JSON.parse(data.response);
            console.log(result);
            if (result.status === 'profile-updated') {
                console.info('[UNOMI-PROFILE-CARD] Profile properties successfully updated');
                setTimeout(location.reload.bind(location), 300);
            }  else {
                console.error('[UNOMI-PROFILE-CARD] Could not update profile properties');
            }
        },
        error: function (err) {
            console.log(err.response);
            console.error('[UNOMI-PROFILE-CARD] Could not update profile properties', err);
        }
    });
}

function getGreeting() {
    var myDate = new Date();
    var hrs = myDate.getHours();
    var greet;
    if (hrs < 12) {
        greet = 'Good morning, ';
    } else if (hrs >= 12 && hrs <= 17) {
        greet = 'Good afternoon, ';
    } else if (hrs >= 17 && hrs <= 24) {
        greet = 'Good evening, ';
    }
    return greet;
}

