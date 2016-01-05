// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function() {
  $('.player-hand').find('span').click(function(){
    var cardSelect = $('.card-select');

    cardSelect.val($(this).data('card-id'));
    cardSelect.closest("form").submit();
  });
});
