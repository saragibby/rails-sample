jQuery.extend({
   postJSON: function( url, data, callback) {
      return jQuery.post(url, data, callback, "json");
   }
});

window.locale = {
    "fileupload": {
        "errors": {
            "maxFileSize": "File is too big",
            "minFileSize": "File is too small",
            "acceptFileTypes": "Filetype not allowed",
            "maxNumberOfFiles": "Max number of files exceeded",
            "uploadedBytes": "Uploaded bytes exceed file size",
            "emptyResult": "Empty file upload result"
        },
        "error": "Error",
        "start": "Start",
        "cancel": "Cancel",
        "destroy": "Delete"
    }
};

var Upload = {
    total_file_count: 0,
    files_processed:  0
}

$(function () {
  'use strict';

  // Initialize the jQuery File Upload widget:
  $('form.upload').fileupload();

  // Enable iframe cross-domain access via redirect option:
  $('form.upload').fileupload('option', { 
    redirect: window.location.href.replace(/\/[^\/]*$/,'/cors/result.html?%s')
  });

  $('form.upload')
    .bind('fileuploadsend', function (e, data) {
      Upload.total_file_count = data.originalFiles.length;
    })
    .bind('fileuploaddone', function (e, data) {
      Upload.files_processed = Upload.files_processed + 1;
      if(Upload.total_file_count == Upload.files_processed){
        window.location = '/story_boards/' + data.result[0].story_board_id;
      }
    });
});