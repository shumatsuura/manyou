$ (document).on('turbolinks:load',function() {
    $('#index_sort').change(function() {

      var current_html = window.location.href;

      // ソート機能の重複防止
      if (location['href'].match(/[&?]sort=(?:created_at|priority|due)_(?:DE|A)SC/) != null) {
        var remove = location['href'].match(/[&?]sort=(?:created_at|priority|due)_(?:DE|A)SC/)[0]
        var current_html = current_html.replace(remove, '')
      };

      var html = "";
      var this_value = $(this).val();

      //ページネーションしてるかの判定
      if (location['href'].match(/page=/) != null){
        //ページネーション中
        if (this_value == "due_ASC") {
            html = "&sort=due_ASC"
        } else if (this_value == "due_DESC") {
            html = "&sort=due_DESC"
        } else if (this_value == "priority_ASC") {
            html = "&sort=priority_ASC"
        } else if (this_value == "priority_DESC") {
            html = "&sort=priority_DESC"
        } else if (this_value == "created_at_ASC") {
            html = "&sort=created_at_ASC"
        } else if (this_value == "created_at_DESC") {
            html = "&sort=created_at_DESC"
        } else {
            html = ""
        };
        //ページネーションしてない
      } else {
        if (this_value == "due_ASC") {
            html = "?sort=due_ASC"
        } else if (this_value == "due_DESC") {
            html = "?sort=due_DESC"
        } else if (this_value == "priority_ASC") {
            html = "?sort=priority_ASC"
        } else if (this_value == "priority_DESC") {
            html = "?sort=priority_DESC"
        } else if (this_value == "created_at_ASC") {
            html = "?sort=created_at_ASC"
        } else if (this_value == "created_at_DESC") {
            html = "?sort=created_at_DESC"
        } else {
            html = ""
        };
      };
      window.location.href = current_html + html;
  });
});


$(document).on('turbolinks:load',function(){
  if (location['href'].match(/[&?]sort=(?:created_at|priority|due)_(?:DE|A)SC/) != null){

    selected_option = location['href'].match(/[&?]sort=(?:created_at|priority|due)_(?:DE|A)SC/)[0].replace(/[&?]sort=/,'');

    if (selected_option == "due_ASC") {
      var sort = 1
    } else if (selected_option == "due_DESC"){
      var sort = 2
    } else if (selected_option == "priority_ASC"){
      var sort = 3
    } else if (selected_option == "priority_DESC"){
      var sort = 4
    } else if (selected_option == "created_at_ASC"){
      var sort = 5
    } else if (selected_option == "created_at_DESC"){
      var sort = 6
    };

    var add_selected = $('#index_sort').children()[sort];
    $(add_selected).attr('selected', true);
  };
});
