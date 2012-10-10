//= require jquery.colorpicker
//= require jquery.contextMenu
//= require jquery.editable
//= require jquery.fileupload
//= require jquery.Jcrop
//= require jquery.qtip
//= require jquery.scrollto
//= require jquery.tools

var View = {
    scrolltoTop: 0,
    scrolltoLeft: 0,
    zoom: 1,
    
    init: function() {
        View.doLayout();
        View.setupTools();
    },
    
    doLayout: function() {
        $('#site-body').layout({
            spacing_open: 0,
            spacing_closed: 0,
            north__size: 63
        });
        
        $('#storyboard-body').layout({
            spacing_open: 0,
            spacing_closed: 0,
            north__size: 49,
            west__size: 226
        });
    },
    
    setupTools: function() {
      if($('#selected-slide').length > 0){
        View.setupDraggable($('.tool.link'), 'link', 150, 40);
        View.setupDraggable($('.tool.text'), 'text', 175, 30);
        View.setupDraggable($('.tool.checkbox'), 'checkbox', 15, 20);
        View.setupDraggable($('.tool.radio'), 'radio', 10, 10);
        View.setupDraggable($('.tool.variable'), 'variable', 175, 30);
        View.setupDraggable($('.tool.gif'), 'gif', 40, 40);
      }
    },
    
    setupDraggable: function(tool, type, width, height) {
        tool.attr('title', type);
        tool.draggable({
            cursor: 'none',
            helper: function(event){
                div = $("<div>").addClass("helper-" + type);
                if(type == 'checkbox'){ div.html("<img src='/assets/check_mark.png'/>")}
                if(type == 'radio'){ div.html("<img src='/assets/radio_button.png'/>")}
                div.resizable({ handles: 'nw, n, ne, e, sw, s, w, se' });
                div.css('width',width);
                div.css('height',height);
                div = StoryBoard.set_resize_handlers_position(div,{action_type: type},height,width)
                $('#canvas').append(div);
                return $('.helper-' + type);
            },
            appendTo: '#canvas',
            start: function(event,ui){
              $('.action_item.selected').qtip('hide');
              $('.action_item.selected').removeClass('selected');
            },
            stop: function(event, ui){
                newActionItem = StoryBoard.add_action_item({
                    action_type: type,
                    width: width,
                    height: height,
                    left: ui.position.left,
                    top: ui.position.top
                }, false);
                newActionItem.addClass('selected');
                newActionItem.qtip('show');
            }
        });
    },
    
    validateVariableName: function(event) {
        var unicode = event.charCode ? event.charCode : event.keyCode;
        if (unicode == 8 || unicode >= 48 && unicode <= 57 || unicode >= 65 && unicode <= 90 || unicode >= 97 && unicode <= 122) {
            return true;
        } else {
            return false;
        }
    }
};