function contactsMultiSearchBox() {
  var localData = [];
  $.ajax({
    async: false,
    type: "GET",
    url: "/contacts",
    success: function(response) {
      // localData = response;
      $.each(response, function(index, element) {
        var tmp = {
          full_name: element["full_name"] === null ? "no name" : element["full_name"],
          email: element["email"] === null ? "no email" : element["email"]
        };
        localData.push(tmp);
      });
    }
  });

  console.log(localData);

  // Make 'Mustache Syntax' Underscore's default script syntax
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
  };

  // Compile scripts with Underscore's template function
  var multiSearch = _.template($('#multisearch').html()),
    infoBox = _.template($('#contact-info').html());

  // Since you can use tab to go to next field, trigger a click event on box focus
  $(document.body).on('focusin', 'input, textarea', function(event) {
    $(event.target).trigger('click');
  });

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
    source: localData,

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
        organization: '',
        primary_phone: '',
        email: text
      };
    },

    adding: function(event, ui) {
      // ANY EMAIL:
      var validater = new RegExp('^(?:[^,]+@[^,/]+\.[^asasd,/]+|)$');
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
  })
}