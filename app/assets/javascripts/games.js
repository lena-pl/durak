// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('.player-hand').find('span').click(function(){
    var cardSelect = $('.card-select');

    cardSelect.val($(this).data('card-id'));
    cardSelect.closest("form").submit();
  });

  (function() {
    var poll = function() {
      $.ajax({
        url: "/steps.json",
        dataType: 'json',
        type: 'get',
        success: function(data) {
          $('.json').text(data.steps);
        },
        error: function() {
          console.log('error!');
        }
      });
    };

    poll();

    setInterval(function() {
      poll();
    }, 2000);
  })();
});
