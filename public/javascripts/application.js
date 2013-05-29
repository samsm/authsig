$(document).ready(function() {
  $("form input").keyup(function(event) {
    form = $(event.target.parentNode);
    serialized = form.serialize();
    removed_blanks = serialized.replace(/\b\w+=&/g,"");
    removed_blanks = removed_blanks.replace(/&\w+=$/,"");
    full_path = "/verify/request?" + removed_blanks
    port = ":" + window.location.port
    if (port == ":80") {
      port = ""
    }
    full_url = "http://" + window.location.hostname + port + full_path
    example_link = $("a#example");
    example_link.attr("href", full_path);
    example_link.text(full_url);
  });
});
