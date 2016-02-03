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
      var request = $.get($('.in-progress').data('url'), { last_id: $('.in-progress').data('last-id'), submitted: hasBeenSubmitted });

      request.done(function(data, textStatus) {
        hasBeenSubmitted = false;
        StepPoller.poll();

        if(textStatus != "notmodified"){
          $('.wrapper').html(data);
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

// Copy to clipboard
(function() {
  // click events
  document.body.addEventListener('click', copy, true);
  // event handler
  function copy(e) {
    // find target element
    var
      t = e.target,
      c = t.dataset.copytarget,
      inp = (c ? document.querySelector(c) : null);

    // is element selectable?
    if (inp && inp.select) {

      // select text
      inp.select();

      try {
        // copy text
        document.execCommand('copy');
        inp.blur();
      }
      catch (err) {
        alert('please press Ctrl/Cmd+C to copy');
      }
    }
  }
})();
