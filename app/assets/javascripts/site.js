$(document).ready(function() {
    $('body').layout({
        spacing_open: 0,
        spacing_closed: 0,
        north__size: 22,
        south__size: 58
    });
    
    if (typeof(View) != "undefined" && typeof(View.init) != "undefined") {
        View.init();
    }
});