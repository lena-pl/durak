// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var StepPoller;

$(document).ready(function() {
  var lastStepId;

  StepPoller = {
    poll: function() {
      return setTimeout(this.request, 1000);
    },
    request: function() {
      var request = $.get(location.pathname + '/last_step_id')

      request.done(function(data) {
        console.log(data, lastStepId)
        StepPoller.poll();

        if (typeof lastStepId === "undefined") {
          lastStepId = data;
          return;
        };

        if (lastStepId !== data) {
          location.reload();
        };

        $("#steps").html(data);
      });
    }
  };

  StepPoller.poll();

  $('.player-hand').find('span').click(function(){
    var cardSelect = $('.card-select');

    cardSelect.val($(this).data('card-id'));
    cardSelect.closest("form").submit();
  });
});
