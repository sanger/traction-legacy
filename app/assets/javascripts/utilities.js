$(document).on('turbolinks:load', function() {

  // Select 2 is a javascript library to provide advanced
  // select dropdowns, including typing.
  $(".select2").select2({
    theme: "bootstrap"
  });

  $(".alert-success").fadeOut(15000);
});