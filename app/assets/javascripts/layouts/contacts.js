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
    checkContactsAjaxCall(jid);
  }, 3000);
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
  $('<div class="signal"></div><p class="load-msg"><br>Please wait while your contacts are loading. This may take a while.</p>').insertBefore('h1');
}

function displaySuccessMsg() {
  clearMsg();
  $("<p class='load-msg'><br>Your contacts have been successfully loaded.</p>").insertBefore('h1').fadeOut(1500, function() {
    $(this).remove();
  });
}

function displayFailureMsg() {
  clearMsg();
  $("<p class='load-msg'>There was an error loading your contacts.</p>").insertBefore('h1');
}

function clearMsg() {
  $('.signal, .load-msg').remove();
}