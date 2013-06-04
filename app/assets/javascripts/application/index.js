$(document).ready(function(){
  $('#mobile-nav-button').on('click', function(){
    $('.site-nav').toggle();
    return false;
  });

  $(".avatar img").each(function(i,e) {
    $(e).attr("src", $(e).data().src);
  });

  $('.pagination a').on('click', function () {
    $.getScript(this.href);
    return false;
  });

  $('#search-people, #search-box').submit(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

  $('#search-people, #search-box').find('.button').hide();

  $('#search, #query').each(function() {
    var elem = $(this);

    // Save current value of element
    elem.data('oldVal', elem.val());

    // Look for changes in the value
    elem.bind("propertychange keyup input", function(event){
      // If value has changed...
      if (elem.data('oldVal') != elem.val()) {
        // Updated stored value
        elem.data('oldVal', elem.val());
        var filter = elem.parent().parent().find(":selected").attr('value');

        // do stuff
        $.get(this.action, $(this).serialize() + '&filter_type=' + filter, null, 'script');
        return false;
      }
    });

    $('#search-filters').bind('change', function(event) {
      // Updated stored value
      elem.data('oldVal', elem.val());
      var filter = elem.parent().parent().find(":selected").attr('value');

      // do stuff
      $.get(this.action, 'query=' + elem.val() + '&filter_type=' + filter, null, 'script');
      return false;

    });
  });

  $('#writing-places').on('click', '.edit-writing-place', function () {
    var place_id = $(this).attr('data-writing-place-id');
    $.get('/writing_places/'+place_id+'/edit.js');
    return false;
  });

  $('#writing-place-add').on('click', function(){
    $('#writing-place-new').show();
    $(this).hide();
    return false;
  });


  mixpanel.track_links('.ideas-list .idea-share__link.twitter', 'shared idea on twitter');
  mixpanel.track_links('.ideas-list .idea-share__link.facebook', 'shared idea on facebook');


  $('.person, .subscription, .reports__row').on('click', '.edit_person input[type=checkbox], .edit_subscription input[type=checkbox], .edit_idea input[type=checkbox]', function () {
    $(this).parent().submit();
  });

  $('.idea').on('click', '.idea-edit a.submit', function () {
    var form = $(this).attr('data-form-id');
    if (form) {
      $('#'+form).find('form').trigger('submit.rails');
    }
    return false;
  });

  $('body').on('click', '.modal-close', function(){
    $('#curtain').remove();
    return false;
  });

  var toggle_buttons = $('.hiw-toggle');
  toggle_buttons.on('click', function(){
    $('.how-it-works-wrapper').toggle();
    toggle_buttons.toggle();
  });

  function on_resize(){
    var ww = $(window).width();
    if (ww > 785) {
      $('.how-it-works-wrapper, .hiw-toggle').css('display', '');
    }
  }

  var doit;
  $(window).resize(function(){
    clearTimeout(doit);
    doit = setTimeout(on_resize, 100);
  });

  document.onkeydown = function(evt) {
    evt = evt || window.event;
    if (evt.keyCode == 27) {
      $('#curtain').remove();
    }
  };

});


// Facebook adds garbage to my urls
if (window.location.href.indexOf('#_=_') > 0) {
    window.location = window.location.href.replace(/#.*/, '');
}