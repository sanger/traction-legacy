// Select 2 is a javascript library to provide advanced
// select dropdowns, including typing.

$(document).on('turbolinks:load', function() {
  $(".select2").select2({
    theme: "bootstrap"
  });
});