$(document).ready(function() {
  if ($(".polling").length == 0) { return; }

  var StepPoller;
  var hasBeenSubmitted = false;

  function submitter(e) {
    e.preventDefault();

    var postData = $(this).serializeArray();
    var formURL = $(this).attr("action");

    var request = $.ajax({
      url:  formURL,
      type: "POST",
      data: postData,
    });

    request.done(function() { hasBeenSubmitted = true; });
  }

  StepPoller = {
    poll: function() {
      return setTimeout(this.request, 1000);
    },
    request: function() {
      var lastID  = $('.in-progress').data('last-id'),
          url     = $('.in-progress').data('url'),
          params  = { last_id: lastID, submitted: hasBeenSubmitted },
          request = $.get(url, params);

      request.done(function(data, textStatus) {
        hasBeenSubmitted = false;
        StepPoller.poll();

        if (textStatus != "notmodified") {
          $('.wrapper').html(data);
        }
      });
    }
  };

  StepPoller.poll();

  $('.wrapper').on('click', '.player-hand span', function() {
    var cardSelect = $('.card-select');

    cardSelect.val($(this).data('card-id'));
    cardSelect.closest("form").submit(submitter).submit();
  });

  $('.wrapper').on('click', '.player-actions', function() {
    $('.player-actions .new_step').submit(submitter).submit();
  });
});
