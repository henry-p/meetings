function Meeting() {
  this.allContacts = [];
  this.selectedContacts = [];
  this.selectedEmails = [];
}

var meeting = new Meeting();

function contactsMultiSearchBox() {
  // Make 'Mustache Syntax' Underscore's default script syntax
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
  };

  // Compile scripts with Underscore's template function
  var multiSearch = _.template($('#multisearch').html()),
    infoBox = _.template($('#contact-info').html());

  // Make div look like a form input
  $('[data-control="multisearch"]').append(multiSearch())
    .children()
    .on('click', function simulateFocus(event) {
      var $me = $(this),
        $panel = $me.find('.panel');

      if (!$panel.is('.focus')) {

        $panel.addClass('focus');

        _.defer(function() {
          $(document.body).on('click.focus', function(e) {
            if ($me.has(e.target).length === 0) {
              $panel.removeClass('focus');
              $(document.body).off('click.focus');
            }
          });
        });
      }
    })
  // Maka div a 'multisearch' box
  .multisearch({
    source: meeting.allContacts,

    maxShowOptions: 100,

    keyAttrs: ['id'],
    searchAttrs: ['full_name', 'email'],

    formatPickerItem: _.template($('#contact-item').html()),
    formatSelectedItem: _.template($('#selected-item').html()),

    // Validation
    buildNewItem: function(text) {
      return {
        id: null,
        full_name: text,
        email: text
      };
    },

    adding: function(event, ui) {
      // ANY EMAIL:
      var validater = /^(?:[^,]+@[^,/]+\.[^,/]+|)$/;
      // ONLY @GMAIL.COM
      // var validater = new RegExp('^(?:[^,]+@gmail.com)$');

      $(this).find('input').removeClass('error');
      if (ui.notfound) {
        if (!validater.test(ui.data.email)) {
          $(this).find('input').addClass('error');
          return false;
        }
      }
    },

    added: function(event, ui) {
      meeting.selectedEmails.push(ui.data.email);
    },

    removed: function(event, ui) {
      meeting.selectedEmails.removeByValue(ui.data.email);
    },

    // Popover box
    itemselect: function(event, ui) {
      var $info = $(infoBox(ui.data)).insertAfter($(this)).show();

      $info.position({
        my: 'center top+10',
        at: 'center bottom',
        of: ui.element
      });

      $info.addClass('in');

      _.defer(function() {
        $(document).on('click.info', function(e) {
          if ($info.has(e.target).length === 0) {
            $info.removeClass('in');
            _.delay(function() {
              $info.remove();
            }, 500);
            $(document).off('click.info');
          }
        });
      });
    },
  });
}

function getAllContacts() {
  $.ajax({
    async: false,
    type: "GET",
    url: "/profile/contacts",
    success: function(response) {
      $.each(response, function(index, element) {
        var contact = {
          full_name: element["full_name"] === null ? "no name" : element["full_name"],
          email: element["email"] === null ? "no email" : element["email"]
        };
        meeting.allContacts.push(contact);
      });
    }
  });
}

function makeDateTimePicker(picker1, picker2) {
  $(picker1)
    .datetimepicker()
    .on("dp.change", function(e) {
      var today = new Date();
      today = (new Date(today.getTime() - 60000));
      $(picker1).data("DateTimePicker").setMinDate(today);
      console.log(new Date(new Date(e.date._i).getTime() + 120000))
      $(picker2).data("DateTimePicker").setDate(new Date(new Date(e.date._i).getTime() + 120000));
      $(picker2).data("DateTimePicker").setMinDate(new Date(new Date(e.date._i).getTime() + 120000));
    });
  $(picker2)
    .datetimepicker()
    .on("dp.change", function(e) {
      $(picker1).data("DateTimePicker").setMaxDate(e.date);
    });
}

function submitFormEventHandler() {
  var form = $("form#new_meeting, form.edit_meeting");
  form.submit(function(event) {
    // var formData = prepareFormData(getFormData());

    $("button[type=submit]").before($('<input/>', {
      type: 'hidden',
      id: "attendees",
      name: "attendees",
      value: prepareSelectedEmails()
    }));
  });
}

function prepareSelectedEmails() {
  var emails = "";
  for (var i = 0; i < meeting.selectedEmails.length; i++) {
    emails += meeting.selectedEmails[i] + ",";
  }
  return emails.substring(0, emails.length - 1);
}

// function getFormData() {
//   return $('form#new_meeting').serializeArray();
// }

// function prepareFormData(formData) {
//   formData = formData.slice(2);
//   var formattedData = {};
//   for (i = 0; i < formData.length; i++) {
//     var element = formData[i];
//     var name = /\[([^)]+)\]/.exec(element.name)[1];
//     var value = element.value;
//     formattedData[name] = value;
//   }
//   return { meetings: formattedData };
// }

function makeWholeBoxClickable() {
  $("div.panel-body").on("click", function(event) {
    $(".pull-left").trigger("focus");
  });
}

function showNameOnHover() {
  $('body').on('mouseenter', '.agenda img', function(event) {
    $(this).first().next().css({
      'display': 'inline-block',
      'position': 'absolute',
      'background-color': 'white',
      'font-weight': '900',
      'padding': '5px',
      'opacity': '0.8'
    });
    $(this).on('mouseleave', function() {
      $(this).first().next().css('display', 'none');
    });
  });
}

Array.prototype.removeByValue = function() {
  var what;
  var a = arguments;
  var l = a.length;
  var ax;
  while (l && this.length) {
    what = a[--l];
    while ((ax = this.indexOf(what)) !== -1) {
      this.splice(ax, 1);
    }
  }
  return this;
};

function fillContactsBoxWithAttendees() {
  for (var i = 0; i < meeting.selectedEmails.length; i++) {
    $('[data-control="multisearch"]').children().multisearch('add', meeting.selectedContacts[i]);
  }
}

function getInvitedContacts(path) {
  $.ajax({
    async: false,
    type: "GET",
    url: path,
    success: function(response) {
      $.each(response, function(index, element) {
        var contact = {
          full_name: element["full_name"] === null ? "no name" : element["full_name"],
          email: element["email"] === null ? "no email" : element["email"]
        };
        meeting.selectedContacts.push(contact);

        var email = element["email"] === null ? "no email" : element["email"];
        meeting.selectedEmails.push(email);
      });
    }
  });
}