// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var StepPoller;

$(document).ready(function() {

  StepPoller = {
    poll: function() {
      return setTimeout(this.request, 1000);
    },
    request: function() {
      var request = $.get($('.in-progress').data('url'), { last_id: $('.in-progress').data('last-id') });

      request.done(function(data, textStatus) {
        StepPoller.poll();

        if(textStatus != "notmodified"){
          $('.wrapper').html(data);
          // $('.wrapper').load($('.in-progress').data('url'));
        }
      });
    }
  };

  StepPoller.poll();

  $('.wrapper').on('click', '.player-hand span', function() {
    var cardSelect = $('.card-select');

    cardSelect.val($(this).data('card-id'));
    cardSelect.closest("form").submit(function(e) {
      var postData = $(this).serializeArray();
      var formURL = $(this).attr("action");

      $.ajax({
        url: formURL,
        type: "POST",
        data: postData,
        success:function(data, textStatus, jqXHR)
        {
        },
        error: function(jqXHR, textStatus, errorThrown)
        {
        }
      });
      e.preventDefault();
    });
    cardSelect.closest("form").submit();
    // $('.wrapper').load($('.in-progress').data('url'));
  });

  $('.wrapper').on('click', '.player-actions', function() {
    $('.player-actions .new_step').submit(function(e) {
      var postData = $(this).serializeArray();
      var formURL = $(this).attr("action");

      $.ajax({
        url: formURL,
        type: "POST",
        data: postData,
        success:function(data, textStatus, jqXHR)
        {
        },
        error: function(jqXHR, textStatus, errorThrown)
        {
        }
      });
      e.preventDefault();
    });
    $('.player-actions .new_step').submit();
    // $('.wrapper').load($('.in-progress').data('url'));
  });
});
