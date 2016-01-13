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
    cardSelect.closest("form").submit();
  });
});
