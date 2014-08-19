//= require jquery
//= require jquery_ujs
//= require bootstrap/transition
//= require bootstrap/collapse
//= require bootstrap/button
//= require fastclick
//= require iscroll
//= require textarea
//= require_self
//= require ios-fix

var userAgent = window.navigator.userAgent.toLowerCase();
var ios = /iphone|ipod|ipad/.test(userAgent);

$(function() {
  new FastClick(document.body);

  // init the custom auto height text area
  var text = $("#comment_content")[0];
  if (text) {
      autoTextarea(text, 15);
  }

  if (ios) {
    $("body").addClass("ios");
    $("#scroll-wrapper").addClass("iscroll-wrapper");
  } else {
    $("body").addClass("android");
  }

  $("#button-comment, .button-comment").click(function() {
    $("#add-comment").show(0, function(){
      $("#comment_content").focus();
    });
  });

  $("#new_comment").on("ajax:before", function(event, xhr, status){
    if ($("#comment_content").val().trim().length != 0) {
      $("#add-comment").hide(0);
    } else {
      $("#comment_content").focus();
      return false;
    }
  });

  $("#comment_content").on("blur", function(){
    $("#add-comment").hide(0);
    window.scrollTo(0, 0);
  });

  $("#new_comment").on("ajax:complete", function(event, xhr, status){
    $("#comment_content").val("");
  });

  $(".load-more a").trigger("click");
  $('.load-more a').click(function () {
    var btn = $(this)
    btn.button('loading')
  });
});
