$ (document).on('turbolinks:load',function() {
    $('#index_sort').change(function() {

      var current_html = window.location.href;
      var html = "";

      var this_value = $(this).val();
      if (this_value == "due_ASC") {
        html = "?sort=due_ASC"
      } else if (this_value == "due_DESC") {
        html = "?sort=due_DESC"
      } else if (this_value == "created_at_ASC") {
        html = "?sort=created_at_ASC"
      } else if (this_value == "created_at_DESC") {
        html = "?sort=created_at_DESC"
      } else {
        html = ""
      };
      window.location.href = current_html + html
  });
});
