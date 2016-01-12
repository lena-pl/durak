// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var StepPoller;
$(document).ready(function() {
  $('.player-hand').find('span').click(function(){
    var cardSelect = $('.card-select');

    cardSelect.val($(this).data('card-id'));
    cardSelect.closest("form").submit();
  });

  StepPoller = {
    poll: function() {
      return setTimeout(this.request, 2000);
    },
    request: function() {
      var request = $.get($('#steps').data('url'), { after: $('.step').last().data('id')} );
      request.done(function(data){
        $("#steps").html(data);
        StepPoller.poll();
      });
    }
  };

  jQuery(function() {
    if ($('#steps').length > 0) {
      StepPoller.request(),
      StepPoller.poll();
    }
  });
});
