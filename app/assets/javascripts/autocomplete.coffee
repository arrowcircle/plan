$(document).ready ->
  $("#itemizations").bind "insertion-callback", ->
    $(".autocomplete").bind "railsAutocomplete.select", (event, data) ->
      $(this).parent().find(".item_id").val data.item.id
