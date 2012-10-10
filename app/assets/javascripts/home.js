//= require jquery
//= require jquery_ujs
//= require jquery.ui
//= require jquery.placeholder

$(document).ready(function(){
  
  $(".dialog").dialog({
   autoOpen: false,
   modal: true 
  });

  $("#sign_in_dialog").dialog({
    width: 450
  });
  $('#home_page_login').click(function(){
    $("#sign_in_dialog").dialog("open");
    return false;
  });
});