var StoryBoard = {
  get_slide: function(id){
    StoryBoard.perform_zoom();
    $("#canvas").data("slide_id", id);
    if(id != undefined) {
      $.get("/slides/"+id, function(slide){
        $.each(slide.action_items, function(i, action_item){
          StoryBoard.add_action_item(action_item, true);
        });
      });
    }
  },
  
  save_action_item: function(selection,payload,callback){
    payload = $.rails_payload_extend({action_item_id: selection.data("id"), action_item: payload});
    
    if(selection.data("id")){ // update
      $.ajax({  type: "PUT",
                url: '/action_items/'+selection.data("id"),
                data: payload
      });  
    }else{ // create
      $.ajax({  type: "POST",
                url: '/action_items/',
                data: payload,
                success: function(response) { callback(selection,response.action_item) }
      });
    }
  },
  
  add_action_item: function(item, showCancel){
    var coords = {
        width: item.width,
        height: item.height,
        left: showCancel ? item.left : item.left / View.zoom,
        top: showCancel ? item.top : item.top / View.zoom
    };
    selection = $("<div>").addClass("action_item").css(coords);
    selection.data(coords);

    selection.css({
      left: coords.left * View.zoom,
      top: coords.top * View.zoom,
      width: coords.width * View.zoom,
      height: coords.height * View.zoom,
      borderWidth: (0.18 * View.zoom) + "em"
    });
    
    if(item.action_type == 'checkbox'){ 
      if(item.data == null) {
        selection.html("<img class='helper' src='/assets/check_mark.png'/>")
      }
      else {
        if(item.data.checkbox_type == 'x_mark') { selection.html("<img class='helper' src='/assets/x_mark.png'/>") }
        else{ selection.html("<img class='helper' src='/assets/check_mark.png'/>") }
      }
    }
    if(item.action_type == 'radio'){ 
      selection.html("<img class='helper' src='/assets/radio_button.png'/>")
    }
    if(item.action_type == 'radio' || item.action_type == 'checkbox' || item.action_type == 'gif'){
      selection.addClass('add_padding');
    }

    // initialize selection, if persistent, give it the DB id, else autosave it
    if(item.id){ selection.data("id", item.id); }
    else{ StoryBoard.save_action_item(selection, $.extend({slide_id: $("#canvas").data("slide_id"), action_type: item.action_type}, coords),StoryBoard.load_new_action_item_id); }

    selection.mousedown(function(){
      if(selection.data('id') != $('.action_item.selected').data('id')){ 
        $('.action_item.selected').qtip('hide'); 
      }
      $('.action_item.selected').removeClass('selected');
      $(this).addClass('selected');
      return false;
    });
    
    // if action item is incomplete then give it the incomplete class
    if(item.incomplete == true){ selection.addClass('incomplete'); }

    selection = StoryBoard.set_draggable_and_resizeable(selection,item);
    selection = StoryBoard.create_tooltip(selection,item,showCancel);
    selection = StoryBoard.set_resize_handlers_position(selection,item,coords.height,coords.width);
    $("#canvas").append(selection);
    return selection;
  },

  load_new_action_item_id: function(selection,item) {
    selection.data("id",item.id);
    if($('.ui-tooltip-content form #action_item_id').val() == "") { $('.ui-tooltip-content form #action_item_id').val(item.id); }
  },
  
  clear_selected_items: function() {
    $('.action_item.selected').removeClass('selected');
  },
  
  set_draggable_and_resizeable: function(selection,item) {
    selection.draggable({
      start: function(event, ui){
        $(this).qtip('hide');
        $(this).css('cursor','none');
      },
      stop: function(event, ui){
        ui.position.left = ui.position.left / View.zoom;
        ui.position.top = ui.position.top / View.zoom;
        $(this).data($.extend(ui.size, ui.position)); // resets top & left
        StoryBoard.save_action_item(selection, $.extend(ui.size, ui.position));
        $(this).css('cursor','move');
        $('.action_item.selected').removeClass('selected');
        $(this).qtip('show');
      }
    }).resizable({
      handles: 'nw, n, ne, e, sw, s, w, se',
      aspectRatio: StoryBoard.get_item_resize_aspect_ratio(item),
      alwaysRelative: true,
      minHeight: StoryBoard.get_item_min_height(item),
			minWidth: StoryBoard.get_item_min_width(item),
      start: function(event, ui){
        $(this).qtip('hide');
      },
      resize: function(event, ui){
        StoryBoard.set_resize_handlers_position(selection,item,$.extend(ui.size, ui.position).height,$.extend(ui.size, ui.position).width);
      },
      stop: function(event, ui){
        ui.position.left = ui.position.left / View.zoom;
        ui.position.top = ui.position.top / View.zoom;
        ui.size.width = ui.size.width / View.zoom;
        ui.size.height = ui.size.height / View.zoom;
        $(this).data($.extend(ui.size, ui.position)); // resets width & height
        StoryBoard.save_action_item(selection, $.extend(ui.size, ui.position));
        StoryBoard.set_resize_handlers_position(selection,item,$.extend(ui.size, ui.position).height,$.extend(ui.size, ui.position).width);
        $('.action_item.selected').removeClass('selected');
        $(this).qtip('show');
      }
    });
    return selection;
  },
  
  get_item_resize_aspect_ratio: function(item){
    if(item.action_type == 'radio') { return 1; }
  },
  
  set_resize_handlers_position: function(selection,item,height,width){
    if(item.action_type == 'radio' || item.action_type == 'checkbox' || item.action_type == 'gif'){
      var newHeight = height + 6,
          newWidth = width + 6;  
    }
    else{
      var newHeight = height - 8,
          newWidth = width - 8;
    }

    selection.find('.ui-resizable-e').css('top',(newHeight*.5));
    selection.find('.ui-resizable-w').css('top',(newHeight*.5));
    selection.find('.ui-resizable-n').css('left',(newWidth*.5));
    selection.find('.ui-resizable-s').css('left',(newWidth*.5));
    
    selection.find('.ui-resizable-ne').removeClass('ui-resizable-handle');
    
    selection.find('.ui-resizable-ne').click(function(){
      $.ajax({
        type: 'DELETE',
        url: "/action_items/"+selection.data("id"),
        data: { authenticity_token: $('meta[name=csrf-token]').attr('content') },
        beforeSend: function(xhr, settings) {
          xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
        },
        success: function(){ selection.remove(); }
      });
      return false;
    });
    
    return selection;
  },
  
  get_item_min_height: function(item){
  },
  
  get_item_min_width: function(item){
  },
  
  get_qtip_postion: function(selection){
    var totalHeight = selection.data('top') + selection.data('height') + 120;
    if (totalHeight > $('#storyboard-editor-body').height()) {
        return { my: 'bottom center', at: 'top center', viewport: $('#storyboard-editor-body'), container: $('#storyboard-editor-body') };
    } else {
        return { my: 'top center', at: 'bottom center', viewport: $('#storyboard-editor-body'), container: $('#storyboard-editor-body') };
    }
  },
  
  get_action_item_form_html: function(item){
  },
  
  get_action_item_title: function(item){
  },
  
  create_tooltip: function(selection,item,showCancel){
    return selection;
  },
  
  set_action_item_file_upload: function(element,tooltip,item){
  },

  setup_slide_right_click_menu: function(){
    $(".slide-image").contextMenu({ menu: 'myMenu' },
      function(action, el, pos) {
        var storyBoardID = $("#canvas").data("story_board_id");
        var slideID = $(el).data("slide_id");
        
        switch(action){
          case "destroy":
            if (confirm("Are you sure you want to delete this slide?") ) {
              $.ajax({
                type: 'DELETE',
                url: "/story_boards/"+storyBoardID+"/slides/"+slideID,
                data: { authenticity_token: $('meta[name=csrf-token]').attr('content'),
                      current_slide_id: $("#canvas").data("slide_id") },
                beforeSend: function(xhr, settings) {
                  xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
                }
              });
            }
            break;
          case "replace":
            $("#replace_image_dialog").dialog({
              open: function(event, ui) {
                $(this).find("#current_slide_id").val($("#canvas").data("slide_id"));
                $(this).find("#slide_id").val(slideID);
              }
            });
            $("#replace_image_dialog").dialog("open");
            break;
        }
    });
  },
  
  setup_sortable_sidebar: function(){
    $('#story-board-slides ul').sortable({
      revert: true,
      placeholder: "ui-state-highlight",
      start: function(e, ui) {
        origIndex = ui.item.index();
      },
      update: function(event, ui) { 
        var orderNum, slideID,
            newIndex = ui.item.index();

        if(origIndex > newIndex){ orderNum = (ui.item.index() * 100) - 50; }
        else{ orderNum = (ui.item.index() * 100) + 50; }

        slideID = ui.item.attr('data-slide_id');
        $('#update_slide_form #slide_id').val(slideID);
        $('#update_slide_form #current_slide_id').val($("#canvas").data("slide_id"));
        $('#update_slide_form #slide_order_number').val(orderNum);
        $('#update_slide_form').submit();
      }
    });
  },
  
  load_story_board: function(){
    $.get("/story_boards/" + storyBoardId + ".js");
    if ($("#story_board_menu").length > 0) { clearInterval(refresh_story_board); }
  },
  
  setup_security_form: function(){
    $('div.save_error').text("");
    if($("input[name='story_board[security_level]']:radio:checked").val().toLowerCase() == 'private'){
      $('#story_board_security_dialog .password').show();
    }
    else {
      $('#story_board_security_dialog .password').hide();
    }
  },
  
  perform_zoom: function() {
    var canvas = $("#canvas");
      
    var orig_width = canvas.data("width"),
        orig_height = canvas.data("height"),
        orig_img_width = canvas.find("#canvas_image").data("width"),
        orig_img_height = canvas.find("#canvas_image").data("height"),
        orig_r_gutter_width = canvas.find("#right-gutter").data("width"),
        orig_r_gutter_height = canvas.find("#right-gutter").data("height"),
        orig_b_gutter_width = canvas.find("#bottom-gutter").data("width"),
        orig_b_gutter_height = canvas.find("#bottom-gutter").data("height");
    
    canvas.find("#canvas_image").css({
      width: orig_img_width * View.zoom,
      height: orig_img_height * View.zoom
    });
    
    canvas.find("#right-gutter").css({
      left: orig_width * View.zoom,
      width: orig_r_gutter_width * View.zoom,
      height: orig_r_gutter_height * View.zoom
    });
    
    canvas.find("#bottom-gutter").css({
      top: orig_height * View.zoom,
      width: orig_b_gutter_width * View.zoom,
      height: orig_b_gutter_height * View.zoom
    });
      
    canvas.find(".action_item").each(function(){
      var data = $(this).data();
 
      $(this).css({
          left: data.left * View.zoom,
          top: data.top * View.zoom,
          width: data.width * View.zoom,
          height: data.height * View.zoom,
          borderWidth: (0.18 * View.zoom) + "em"
        });
      if(parseInt($(this).css('padding-top')) > 0){
        $(this).css({
          padding: (0.685 * View.zoom) + "em"
        });
      }
    }); 
  }
};

var storyBoardId = $("#canvas").data("story_board_id");
    
var internal_link_selecting = false,
    transition_slide_selecting = false,
    internal_link_form, 
    jcrop, 
    canvas_state = "select";

$(function(){
  
  StoryBoard.get_slide($("#canvas").data("slide_id"));
  
  if ($("#story_board_menu").length == 0) {
    refresh_story_board = setInterval(function() {
      StoryBoard.load_story_board()
    }, 2000);
  }
  
  $('#share_link').click(function(){
    $('#share_url').toggle();
    return false;
  });

  $('#add_slide_form a').click(function(){
    $('#add_slide_form').submit();
    return false;
  });
  
  $('#preview_slide_form a').click(function(){
    $('#preview_slide_form #current_slide_id').val($("#canvas").data("slide_id"));
    $('#preview_slide_form').submit();
    return false;
  });
  
  $('#story_board_save_background select').change(function(){
    $('#story_board_save_background #current_slide_id').val($("#canvas").data("slide_id"));
    $('#story_board_save_background').submit();
    return false;    
  });

  // *** Dialogs ***
  $(".dialog").dialog({
   autoOpen: false,
   modal: true 
  });
  
  $("#story_board_security_dialog").dialog({
    width: 450
  });
  $('#security_level a').click(function(){
    $("#story_board_security_dialog").dialog("open");
    return false;
  });
  
  StoryBoard.setup_security_form();
  $("input[name='story_board[security_level]']").click(function(){
    StoryBoard.setup_security_form();
  });
  
  $('#story_board_security_dialog input[class=cancel]').click(function(){
    if($("input[name='story_board[security_level]']:radio:checked").val().toLowerCase() != $('#security_level a').text()){
      if(confirm("You have unsaved changes. Are you sure you want to exit?")){
        $("#story_board_security_dialog").dialog("close");
        return false;
      }
      else { return false; }
    }
    else{
      $("#story_board_security_dialog").dialog("close");
      return false; 
    }
  });
  
  $("#story_board_security_dialog form").submit(function(){
    if($("input[name='story_board[security_level]']:radio:checked").val().toLowerCase() == 'private' && $('#story_board_password').val() == ''){
     $('div.save_error').text("Password required for private story board");
     return false;
    }
    else{
      $('div.save_error').text("");
      return true;
    }
  });
  // *** End Dialogs ***
  
  $('.editable').editable('/ajax/editable', {
    style : "inherit",
    width: 300,
    submitdata: { authenticity_token: $('meta[name=csrf-token]').attr('content') },
    onblur: "submit"
  });
  
  StoryBoard.setup_slide_right_click_menu();
  
  $("#canvas_zoom").change(function(){
    View.zoom = parseInt($(this).find(":selected").val(), 10)/100;
    StoryBoard.perform_zoom();
  });
  
  $("#left_sidebar").on("click", ".slide-image", function(){    
    if(internal_link_selecting){
      internal_link_form.find("#action_item_data_internal_link").val($(this).data("slide_id"));
      internal_link_form.submit();
      return false;
    }
    else if(transition_slide_selecting){
      $("#slide_transfer_to_slide_id").val($(this).data("slide_id"));
      transition_slide_selecting = false;
      return false;
    }
  });
  
  $("#left_sidebar").on("mouseenter", ".slide-image", function(){    
    if(internal_link_selecting){
      $(this).find('img').addClass('slide_green_border');
    }
  });
  
  $("#left_sidebar").on("mouseleave", ".slide-image", function(){   
    if(internal_link_selecting){
      $(this).find('img').removeClass('slide_green_border');
    } 
  });
  
  $('#transition_link').click(function(){
    $('#transition form').toggle();
    return false;
  });
  
  $('#transition_slide_selector').click(function(){
    transition_slide_selecting = true;
    return false;
  });
  
  $('#remove_transition').click(function(){
    $('#slide_transfer_to_slide_id').val(null);
    $('#slide_transfer_wait').val(null);
    $(this).closest('form').submit();
    return false;
  });
  
  $('.tool-container img').click(function(){
    StoryBoard.clear_selected_items();
  });
  
  var origIndex;
  StoryBoard.setup_sortable_sidebar();
  
  $.rails_payload_extend = function(payload){
    var x = {};
    x[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content');
    return $.extend(payload, x);
  }
  
});
