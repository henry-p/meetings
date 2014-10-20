function startContactLoad() {
  var ajax = $.ajax({
    url: '/contacts/start_job',
    type: 'get'
  });
  ajax.success(function(data) {
    if (data.jid) {
      displayWaitMsg();
      checkOnContacts(data.jid);
    } 
  });
  ajax.fail(function() {
    displayFailureMsg();
  });
}


function checkOnContacts(jid) {
  interval = setInterval(function() {
    checkContactsAjaxCall(jid)
  }, 3000)
}

function checkContactsAjaxCall(jid) {
  var ajax = $.ajax({
    url: '/contacts/job_status?jid=' + jid,
    type: 'get'
  });
  ajax.success(function(data) {
    if (data.done) {
      displaySuccessMsg();
      clearInterval(interval);
    } else {
      displayWaitMsg();
    }
  });
  ajax.fail(function() {
    displayFailureMsg();
  });  
}


function displayWaitMsg() {
  clearMsg();
  $("<p class='load-msg'>We're loading your contacts from Google to make inviting people to meetings easier. This may take a few minutes.</p>").insertBefore('h1')
}

function displaySuccessMsg() {
  clearMsg();
  $("<p class='load-msg'>Your contacts have been successfully loaded.</p>").insertBefore('h1')
}

function displayFailureMsg() {
  clearMsg();
  $("<p class='load-msg'>There was an error loading your contacts.</p>").insertBefore('h1')
}

function clearMsg() {
  $('.load-msg').remove();
}