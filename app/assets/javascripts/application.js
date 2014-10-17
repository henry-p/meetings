// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
//= require jquery-ui.min
//= require underscore.min
//= require jqueryui-multisearch.min

$(function() {
  _.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
  };

  var multiSearch = _.template($('#multisearch').html()),
    infoBox = _.template($('#contact-info').html());

  // Since you can tab through fields, redirect the focus
  // event to click just in case.
  $(document.body).on('focusin', 'input, textarea', function(event) {
    $(event.target).trigger('click');
  });

  $('[data-control="multisearch"]').append(multiSearch())
    .children()

  .on('click', function simulateFocus(event) {

    /*
     *  Simulate the nice input focus effect for
     *  Bootstrap form-controls.  Since there's one
     *  on the page, it looks wierd if these boxes
     *  don't match.
     */

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

  .multisearch({

    source: localData,

    keyAttrs: ['id'],
    searchAttrs: ['display_name', 'primary_email'],

    formatPickerItem: _.template($('#contact-item').html()),
    formatSelectedItem: _.template($('#selected-item').html()),

    buildNewItem: function(text) {
      return {
        id: null,
        display_name: text,
        organization: '',
        primary_phone: '',
        primary_email: text
      };
    },

    adding: function(event, ui) {
      // var validater = new RegExp('^(?:[^,]+@[^,/]+\.[^,/]+|)$');
      var validater = new RegExp('^(?:[^,]+@gmail.com');

      $(this).find('input').removeClass('error');
      if (ui.notfound) {
        if (!validater.test(ui.data.primary_email)) {
          $(this).find('input').addClass('error');
          return false;
        }
      }
    },

    itemselect: function(event, ui) {

      // Generate from template and add to DOM
      var $info = $(infoBox(ui.data)).insertAfter($(this)).show();

      // Use jQueryUI Position utility to move it to the right spot
      $info.position({
        my: 'center top+10',
        at: 'center bottom',
        of: ui.element
      });

      // Trigger the Bootstrap fade transition
      $info.addClass('in');

      // Several things are happening here:
      //  1) This click event is still bubbling, listen to
      //     click now, and it will be caught before the popover
      //     ever appears.  Deferring it pushes the execution outside
      //     of the current call stack
      //  2) Clicks inside the popover are fine.  Use the $.has() function
      //     to see if any part of the target is or is inside the popover
      //     element.  Only remove if that is not true.  Remember, has()
      //     returns a set of elements unlike is() which returns true/false.
      //  3) It makes sense to animate the box out.  Leave some time for that
      //     to happen before toasting the element from the DOM.
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
});

localData = [{
  "display_name": "Neal, Amelia R.",
  "organization": "XYZ Company",
  "primary_email": "pede@nibh.com",
  "primary_phone": "(577) 324-9152"
}, {
  "display_name": "Cervantes, Colton Z.",
  "organization": "XYZ Company",
  "primary_email": "imperdiet.dictum.magna@SuspendissesagittisNullam.com",
  "primary_phone": "(730) 491-0518"
}, {
  "display_name": "Thornton, Marvin H.",
  "organization": "XYZ Company",
  "primary_email": "tristique@in.ca",
  "primary_phone": "(530) 962-1617"
}, {
  "display_name": "Watkins, Leilani C.",
  "organization": "XYZ Company",
  "primary_email": "amet.massa@a.edu",
  "primary_phone": "(368) 554-4860"
}, {
  "display_name": "Blake, Sawyer Z.",
  "organization": "XYZ Company",
  "primary_email": "sodales@Pellentesquetincidunttempus.edu",
  "primary_phone": "(247) 412-3266"
}, {
  "display_name": "Fuller, Jennifer W.",
  "organization": "XYZ Company",
  "primary_email": "ullamcorper.Duis.at@ullamcorpernislarcu.org",
  "primary_phone": "(263) 771-8743"
}, {
  "display_name": "Pollard, Noel K.",
  "organization": "XYZ Company",
  "primary_email": "sagittis.Duis.gravida@Proin.com",
  "primary_phone": "(466) 130-3283"
}, {
  "display_name": "Clemons, Thomas Y.",
  "organization": "XYZ Company",
  "primary_email": "Integer@sem.org",
  "primary_phone": "(463) 990-6407"
}, {
  "display_name": "Gilbert, Kimberley D.",
  "organization": "XYZ Company",
  "primary_email": "magna.Cras.convallis@metuseuerat.com",
  "primary_phone": "(845) 785-9757"
}, {
  "display_name": "Green, Zeus L.",
  "organization": "XYZ Company",
  "primary_email": "Ut.tincidunt@pedeCumsociis.edu",
  "primary_phone": "(894) 870-2892"
}, {
  "display_name": "Alston, Lesley P.",
  "organization": "XYZ Company",
  "primary_email": "lectus.quis@gravida.edu",
  "primary_phone": "(709) 389-5236"
}, {
  "display_name": "Perry, Arthur R.",
  "organization": "XYZ Company",
  "primary_email": "orci.lacus.vestibulum@elit.com",
  "primary_phone": "(202) 128-1825"
}, {
  "display_name": "Holman, Anastasia T.",
  "organization": "XYZ Company",
  "primary_email": "lorem.vehicula.et@sitametconsectetuer.com",
  "primary_phone": "(756) 127-8864"
}, {
  "display_name": "Howe, Zena W.",
  "organization": "XYZ Company",
  "primary_email": "nisi@Nulla.org",
  "primary_phone": "(925) 386-6531"
}, {
  "display_name": "Gray, Evan N.",
  "organization": "XYZ Company",
  "primary_email": "nonummy.ac.feugiat@mollis.edu",
  "primary_phone": "(880) 530-9214"
}, {
  "display_name": "Gates, Galvin D.",
  "organization": "XYZ Company",
  "primary_email": "eu@nislQuisquefringilla.com",
  "primary_phone": "(410) 733-0830"
}, {
  "display_name": "Hendrix, Anne E.",
  "organization": "XYZ Company",
  "primary_email": "ornare.libero.at@tempor.org",
  "primary_phone": "(348) 482-7943"
}, {
  "display_name": "Avery, Nerea V.",
  "organization": "XYZ Company",
  "primary_email": "Sed@sedconsequatauctor.org",
  "primary_phone": "(284) 585-9041"
}, {
  "display_name": "Tillman, Debra V.",
  "organization": "XYZ Company",
  "primary_email": "Nunc.lectus@justonecante.edu",
  "primary_phone": "(961) 408-4886"
}, {
  "display_name": "Meadows, Mona F.",
  "organization": "XYZ Company",
  "primary_email": "vestibulum.neque.sed@etlaciniavitae.com",
  "primary_phone": "(322) 745-5208"
}, {
  "display_name": "Yates, Zena A.",
  "organization": "XYZ Company",
  "primary_email": "orci.lacus.vestibulum@Quisque.org",
  "primary_phone": "(975) 832-4608"
}, {
  "display_name": "Hodges, Eric E.",
  "organization": "XYZ Company",
  "primary_email": "natoque.penatibus@Sedneque.edu",
  "primary_phone": "(984) 164-0737"
}, {
  "display_name": "Mclaughlin, Tana K.",
  "organization": "XYZ Company",
  "primary_email": "pharetra.Quisque.ac@Intinciduntcongue.org",
  "primary_phone": "(213) 306-7213"
}, {
  "display_name": "Guerrero, Melvin N.",
  "organization": "XYZ Company",
  "primary_email": "congue.a@orciconsectetuereuismod.ca",
  "primary_phone": "(475) 644-2835"
}, {
  "display_name": "Blevins, Solomon H.",
  "organization": "XYZ Company",
  "primary_email": "risus@diamlorem.com",
  "primary_phone": "(305) 442-7089"
}, {
  "display_name": "Marsh, Victor U.",
  "organization": "XYZ Company",
  "primary_email": "eget@idenim.ca",
  "primary_phone": "(816) 375-3065"
}, {
  "display_name": "Wilson, Mariko X.",
  "organization": "zTech Inc.",
  "primary_email": "habitant.morbi.tristique@tempusrisus.org",
  "primary_phone": "(605) 594-0773"
}, {
  "display_name": "Nichols, Chandler E.",
  "organization": "zTech Inc.",
  "primary_email": "vulputate@auctornonfeugiat.org",
  "primary_phone": "(465) 922-9100"
}, {
  "display_name": "Guerrero, Kylynn P.",
  "organization": "zTech Inc.",
  "primary_email": "massa@In.com",
  "primary_phone": "(671) 413-0348"
}, {
  "display_name": "Phillips, Christen K.",
  "organization": "zTech Inc.",
  "primary_email": "ullamcorper.viverra@anteNuncmauris.org",
  "primary_phone": "(256) 362-6140"
}, {
  "display_name": "Conrad, Flavia L.",
  "organization": "zTech Inc.",
  "primary_email": "sit.amet.consectetuer@Donecsollicitudin.edu",
  "primary_phone": "(935) 427-1624"
}, {
  "display_name": "Strong, Lillith B.",
  "organization": "zTech Inc.",
  "primary_email": "vel.est.tempor@diamPellentesquehabitant.edu",
  "primary_phone": "(172) 575-6246"
}, {
  "display_name": "Santiago, Samantha V.",
  "organization": "zTech Inc.",
  "primary_email": "dictum.cursus.Nunc@dictumcursus.com",
  "primary_phone": "(120) 476-2846"
}, {
  "display_name": "Johns, Kirby T.",
  "organization": "zTech Inc.",
  "primary_email": "malesuada.ut@rutrumFuscedolor.ca",
  "primary_phone": "(571) 139-8270"
}, {
  "display_name": "Whitehead, Lacey K.",
  "organization": "zTech Inc.",
  "primary_email": "dictum.placerat@ipsumdolor.edu",
  "primary_phone": "(128) 593-9691"
}, {
  "display_name": "Wilder, Marcia C.",
  "organization": "zTech Inc.",
  "primary_email": "Donec@a.edu",
  "primary_phone": "(302) 108-9442"
}, {
  "display_name": "Jensen, Stacy G.",
  "organization": "zTech Inc.",
  "primary_email": "arcu.Vestibulum.ante@quis.org",
  "primary_phone": "(533) 459-3610"
}, {
  "display_name": "Fox, Tarik C.",
  "organization": "zTech Inc.",
  "primary_email": "ultrices@estcongue.com",
  "primary_phone": "(217) 746-1658"
}, {
  "display_name": "Wright, Patience O.",
  "organization": "zTech Inc.",
  "primary_email": "ligula@Donecporttitortellus.ca",
  "primary_phone": "(895) 994-3056"
}, {
  "display_name": "Richard, Ila Y.",
  "organization": "zTech Inc.",
  "primary_email": "mattis.velit@pedeCumsociis.com",
  "primary_phone": "(340) 837-8992"
}, {
  "display_name": "Lancaster, Ruth E.",
  "organization": "zTech Inc.",
  "primary_email": "diam.vel.arcu@tortorNunccommodo.com",
  "primary_phone": "(294) 868-5554"
}, {
  "display_name": "Serrano, Cynthia V.",
  "organization": "zTech Inc.",
  "primary_email": "ipsum.Donec@Crasvehiculaaliquet.org",
  "primary_phone": "(626) 554-0714"
}, {
  "display_name": "Schmidt, Ingrid W.",
  "organization": "zTech Inc.",
  "primary_email": "mauris.a@augue.com",
  "primary_phone": "(299) 741-5278"
}, {
  "display_name": "Callahan, Amir N.",
  "organization": "zTech Inc.",
  "primary_email": "Integer.in@feugiat.ca",
  "primary_phone": "(616) 760-5473"
}, {
  "display_name": "Buchanan, Quintessa U.",
  "organization": "zTech Inc.",
  "primary_email": "eu.accumsan.sed@nonmassanon.com",
  "primary_phone": "(917) 697-7431"
}, {
  "display_name": "Kelley, Lilah D.",
  "organization": "zTech Inc.",
  "primary_email": "eu@ornaretortorat.com",
  "primary_phone": "(847) 684-7547"
}, {
  "display_name": "Bass, Forrest G.",
  "organization": "Small Tools Co",
  "primary_email": "nulla@Namnullamagna.edu",
  "primary_phone": "(765) 181-5931"
}, {
  "display_name": "Dyer, Norman L.",
  "organization": "Small Tools Co",
  "primary_email": "Vestibulum.ante@dictum.org",
  "primary_phone": "(681) 164-1873"
}, {
  "display_name": "May, Russell K.",
  "organization": "Small Tools Co",
  "primary_email": "vitae.mauris@malesuadamalesuadaInteger.ca",
  "primary_phone": "(219) 526-7724"
}, {
  "display_name": "Hoffman, Tate A.",
  "organization": "Small Tools Co",
  "primary_email": "adipiscing.ligula@tempus.ca",
  "primary_phone": "(688) 416-9511"
}, {
  "display_name": "Pugh, Julie C.",
  "organization": "Small Tools Co",
  "primary_email": "morbi.tristique@nibh.edu",
  "primary_phone": "(788) 927-3236"
}, {
  "display_name": "Wooten, Iola Q.",
  "organization": "Small Tools Co",
  "primary_email": "Integer@semeget.ca",
  "primary_phone": "(234) 449-1559"
}, {
  "display_name": "Oconnor, Lars C.",
  "organization": "Small Tools Co",
  "primary_email": "mi@purusMaecenaslibero.ca",
  "primary_phone": "(750) 114-0858"
}, {
  "display_name": "Williamson, Ezra T.",
  "organization": "Small Tools Co",
  "primary_email": "sit.amet@tristique.org",
  "primary_phone": "(292) 798-4919"
}, {
  "display_name": "Farmer, Vladimir S.",
  "organization": "Small Tools Co",
  "primary_email": "sem.mollis@Nuncullamcorpervelit.ca",
  "primary_phone": "(377) 850-8351"
}, {
  "display_name": "Holcomb, Keiko W.",
  "organization": "Small Tools Co",
  "primary_email": "egestas.ligula.Nullam@ipsum.com",
  "primary_phone": "(192) 282-3581"
}, {
  "display_name": "Mccall, Hasad E.",
  "organization": "Small Tools Co",
  "primary_email": "pede.ultrices.a@maurissagittisplacerat.ca",
  "primary_phone": "(131) 657-0344"
}]