// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var StepPoller;
var hasBeenSubmitted = false;
function submitter (e){
    var postData = $(this).serializeArray();
    var formURL = $(this).attr("action");
    $.ajax({
      url: formURL,
      type: "POST",
      data: postData,
      success:function(data, textStatus, jqXHR)
      {
        hasBeenSubmitted = true;
      },
      error: function(jqXHR, textStatus, errorThrown)
      {
      }
    });
    e.preventDefault();
}

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
    cardSelect.closest("form").submit(submitter
  );
    cardSelect.closest("form").submit();
  });

  $('.wrapper').on('click', '.player-actions', function() {
    $('.player-actions .new_step').submit(submitter
  );
    $('.player-actions .new_step').submit();
  });
});
