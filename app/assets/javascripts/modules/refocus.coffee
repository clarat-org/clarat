# Focus on the field that should have autofocus after all the JS magic is done.
# This should be the last script included.

$(document).ready ->
  $('[autofocus]').focus()
