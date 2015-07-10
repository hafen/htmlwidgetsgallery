$( function() {
  var qsRegex;
  var $grid = $('#grid');

  $grid.isotope({
    itemSelector : '.grid-item',
    layoutMode: 'masonry',
    getSortData: {
      // author: '[data-author]',
      author: function( itemElem ) {
        var name = $( itemElem ).find('.widget-author').text();
        return name.toLowerCase();
      },
      name: function( itemElem ) {
        var name = $( itemElem ).find('.card-title').text();
        return name.toLowerCase();
      },
      stars: function( itemElem ) {
        var stars = -parseInt($( itemElem ).find(".gh-count").html());
        return stars;
      }
    },
    masonry: {
      isFitWidth: true,
      gutter: 20
    }
  });

  // use value of search field to filter
  var $textfilter = $('#textfilter').keyup( debounce( function() {
    if(!$("#tagfilter").val() == "") {
      $("#tagfilter").val(0);
      $("#tagfilter").material_select();
    }
    if(!$("#authorfilter").val() == "") {
      $("#authorfilter").val(0);
      $("#authorfilter").material_select();
    }
    qsRegex = new RegExp( $textfilter.val(), 'gi' );
    $grid.isotope({ filter: function() {
      var curText = $(this).find('.card-title').html() + " " + $(this).find('.widget-author').html() + " " + $(this).find('.widget-shortdesc').html();
      return qsRegex ? curText.match( qsRegex ) : true;
    }});
  }, 100 ) );

  $('#gridsort').change(function() {
    var sortVal = $(this).val();
    if(sortVal === 'stars')
      $grid.isotope('updateSortData');
    $grid.isotope({ sortBy : sortVal });
  });

  $('#authorfilter').change(function() {
    // first get rid of tag filters & text
    $("#tagfilter").val(0);
    $("#tagfilter").material_select();
    $("#textfilter").val("");
    var authorVal = $(this).val();
    $grid.isotope({ filter : function() {
      if(authorVal == "")
        return true;
      return $(this).find('.widget-author').html() == authorVal;
    }});
  });

  $('#tagfilter').change(function() {
    // first get rid of author filters & text
    $("#authorfilter").val(0);
    $("#authorfilter").material_select();
    $("#textfilter").val("");
    var tagVal = $(this).val();
    $grid.isotope({ filter : function() {
      if(tagVal == "")
        return true;
      var tags = $(this).find('.widget-tags').html();
      tags = tags.split(',');
      var res = false;
      for (var i = 0; i < tags.length; i++) {
        res = res || (tags[i] == tagVal);
      };
      return res;
    }});
  });

  $('.star-frame').load(function() {
      var doc = this.contentDocument || this.contentWindow.document;
      var target = doc.getElementById("gh-count");
      console.log(target.innerHTML);
  });

  $.each(window.widget_authors, function (key, value) {
    $('#authorfilter').append($('<option/>', {
      value: key,
      text : key + ' (' + value + ')'
    }));
  });

  $.each(window.widget_tags, function (key, value) {
    $('#tagfilter').append($('<option/>', {
      value: key,
      text : key + ' (' + value + ')'
    }));
  });

  $('#gridsort').trigger('change');
  $('select').material_select();
});

function debounce( fn, threshold ) {
  var timeout;
  return function debounced() {
    if ( timeout ) {
      clearTimeout( timeout );
    }
    function delayed() {
      fn();
      timeout = null;
    }
    timeout = setTimeout( delayed, threshold || 100 );
  }
}



// var $grid = $('.grid').isotope({
//   itemSelector: '.grid-item',
//   isFitWidth: true
//   // percentPosition: true,
//   // masonry: {
//   //   // use element for option
//   //   columnWidth: '.grid-item',
//   //   rowHeight: '.grid-item'
//   // }
// });


