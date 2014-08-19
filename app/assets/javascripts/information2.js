//= require jquery
//= require fastclick
//= require iscroll-probe
//= require_self
//= require wechat
//= require ios-fix

var userAgent = window.navigator.userAgent.toLowerCase();
var ios = /iphone|ipod|ipad/.test(userAgent);

var commented = false, favorited = false;
var info = "请下载叽咕查看更多有意思的纸条";

function flashBrand() {
  $(".download-block-wrapper").html($(".download-block-wrapper").html());
  $(".download-block").addClass("flash");
}

function setShareData(link, imgUrl, title, content) {
  window.shareData = {
    "link": link,
    "title": title,
    "content": content,
    "imgUrl": imgUrl
  };
}

function favoriteInformation(id) {
  $.ajax({
    url: '/v2/informations/' + id + '/favorite',
    type: 'post'
  });
}

function commentInformation(id, content) {
  $.ajax({
    url: '/v2/comments',
    data: {
      information_id: id,
      content: content
    },
    type: 'post'
  });
}

$(function() {
  new FastClick(document.body);

  if (ios) {
    $("body").addClass("ios");
  }
  $(".container-information").addClass("iscroll-wrapper");

  $(".button-comment").click(function(){
    if(!commented) {
      $(".bottom-buttons").hide();
      $(".add-comment-wrapper").show();
      $(".add-comment textarea").focus();
    } else {
      flashBrand();
    }
  });

  $(".add-comment-wrapper, .add-comment .close").click(function(){
    $(".add-comment-wrapper").hide();
    $(".bottom-buttons").show();
    window.scrollTo(0, 0);
  });

  $(".add-comment, .scrip-body, .bottom-buttons, .add-comment-wrapper").click(function(e){
    e.stopPropagation();
  })

  if (ios) {
    $("#owner-info").click(function() {
      $(".container-information").toggleClass("show-image");
    });
  }
});
