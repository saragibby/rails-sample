//= require jquery.cookie
//= require jquery.querystring
//= require jquery.scrollto

var action_item_render = {
  text: function(data,image_url){
    var input;
    return input;
  },
  link: function(data,image_url){
    var link = $("<div>");
    return link;
  },
  checkbox: function(data,image_url){
    var checkbox = $("<div>");
    return checkbox;
  },
  radio: function(data,image_url){
    var radio = $("<div>");
    return radio;
  },
  gif: function(data,image_url){
    var image = $("<div>");
    return image;
  },
  variable: function(data,image_url){
    var variable = $('<div>');
    return variable;
  }
};

$(function(){
  var top = $.QueryString["top"];
  var left = $.QueryString["left"];

  $(document).scrollTo({top:top||0, left:left||0});
  
  $(".action_item").each(function(){
    var data = $(this).data(), 
        image_url = $(this).attr('image_url'),
        action_item;

    if(data.action_type){
      action_item = action_item_render[data.action_type](data,image_url);
      
      action_item.css({
        height: data.height,
        width: data.width,
        left: data.left,
        top: data.top
      });
      action_item.addClass("action_item").appendTo("#preview")
      action_item.attr("tabindex", data.tabindex);
      
      if(data.action_type == 'radio' || data.action_type == 'checkbox' || data.action_type == 'gif'){
        action_item.addClass('add_padding');
      }
      else if(data.action_type == 'text' || data.action_type == 'variable'){
        action_item.css({
          height: data.height + 2,
          width: data.width - 3
        });
      }
    }
    $(this).remove();
  });
  
  if($('#preview').data("transfer_to_slide_id") > 0){
    transition_to = $('#preview').data("transfer_to_slide_id");
    wait_length = $('#preview').data("transfer_wait");
    setTimeout(function() {location.assign("?current_slide_id="+transition_to)}, wait_length * 1000);
  }
