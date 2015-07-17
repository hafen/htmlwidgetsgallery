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
    handleFilter();
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
    handleFilter();
  });

  $('#tagfilter').change(function() {
    // first get rid of author filters & text
    $("#authorfilter").val(0);
    $("#authorfilter").material_select();
    $("#textfilter").val("");
    handleFilter();
  });

  $("#crancheckbox").click(function() {
    handleFilter();
  });

  function handleFilter() {
    var tagVal = $('#tagfilter').val();
    var authorVal = $('#authorfilter').val();
    var textVal = $('#textfilter').val();

    $grid.isotope({ filter : function() {

      var textBool = true;
      if(textVal !== '') {
        qsRegex = new RegExp( textVal, 'gi' );
        curText = $(this).find('.card-title').html() + " " + $(this).find('.widget-author').html() + " " + $(this).find('.widget-shortdesc').html();
        textBool = qsRegex ? curText.match( qsRegex ) : true;
      }

      var tagBool = true;
      if(tagVal !== '') {
        tagBool = false;
        var tags = $(this).find('.widget-tags').html();
        tags = tags.split(',');
        for (var i = 0; i < tags.length; i++) {
          tagBool = tagBool || (tags[i] == tagVal);
        };
      }

      var authorBool = true;
      if(authorVal !== '') {
        authorBool = false;
        authorBool = $(this).find('.widget-author').html() == authorVal;
      }

      var cranBool = $(this).find('.widget-cran').html() === "true";
      if($("#crancheckbox:checked").length == 0) {
        cranBool = true;
      }

      return textBool && tagBool && authorBool && cranBool;
    }}, function() {alert('hi');});
  }

  $grid.on('arrangeComplete', function(event, laidOutItems) {
    $("#shown-widgets").html($(".grid-item:visible").length);
  })

  $('.widget-tags').each(function(i) {
    var tagVals = $(this).html().split(',');
    $(this).addClass('hidden');
    for (var j = 0; j < tagVals.length; j++) {
      var el = document.createElement("a");
      el.className = 'taghref';
      el.textContent = tagVals[j];
      el.href = 'javascript:;';
      $(this).before(el);
      if (j < tagVals.length - 1) {
        $(this).before(", ");
      }
    };
  });

  $('.taghref').click(function() {
    $('#tagfilter > option').removeAttr("selected");
    $('#tagfilter > option[value="' + $(this).html() + '"]').attr("selected", "selected");
    $('select').material_select();
    $('#tagfilter').trigger('change');
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
  handleFilter();
  $("#shown-widgets").html($(".grid-item:visible").length);
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


