// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var StepPoller;

$(document).ready(function() {

  StepPoller = {
    poll: function() {
      return setTimeout(this.request, 1000);
    },
    request: function() {
      var request = $.get();

      request.done(function(data) {
        StepPoller.poll();

        $(".wrapper").html(data);
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
  });
});
