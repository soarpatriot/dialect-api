//= require jquery
//= require websocket
//= require websocket_rails/main
//= require underscore
//= require fastclick
//= require iscroll-probe
//= require_self
//= require talk

var userAgent = window.navigator.userAgent.toLowerCase();
var ios = /iphone|ipod|ipad/.test(userAgent);

if (window.chat == undefined) {
  window.chat = {
    getChatInfo: function() {
      return "11,test,http://p.qq181.com/cms/1210/2012100413195471481.jpg,9,User";
    }
  }
}

if (!ios) {
  document.body.className = "android";
}

var iscroller;

var userId = "";
var avatar = "";
var name = ""
var targetId = "";
var targetType = "";

var storage = window.localStorage;
var storedMessages = JSON.parse(storage.getItem("messages"));
if (!storedMessages || (storedMessages instanceof Array)) {
  storage.setItem("messages", "{}");
  storedMessages = {};
}
var messages = [];

function init(_userId, _name, _avatar, _targetId, _targetType) {
  userId = _userId, name = _name, avatar = _avatar, targetId = _targetId, targetType = _targetType;
}

var params = chat.getChatInfo().split(",");
init(params[0], params[1], params[2], params[3], params[4], params[5]);

var chatKey = targetType + "-" + targetId;

var socketUrl = "inkash.test.soundink.net/websocket?user_id=" + userId;
var dispatcher = new WebSocketRails(socketUrl);

function saveMessage(message) {
  messages.push(message);
  storedMessages[chatKey] = messages;
  storage.setItem("messages", JSON.stringify(storedMessages));
}

dispatcher.bind("message.sent", function(message){
  var msg = _.find(messages, function(item){ return item.timestamp == message.timestamp });
  if (msg) {
    msg.status = "sent";
    var el = $("#" + msg.user_id + "-" + msg.timestamp);
    el.removeAttr("status");
    el.find(".inner").removeClass("sent-error");
    el.find(".msg-sending").remove();
  }
  storedMessages[chatKey] = messages;
  storage.setItem("messages", JSON.stringify(storedMessages));
});

dispatcher.bind("message.new", function(message){
  message.type = "received";
  addMessage(message);

  saveMessage(message);
});

function addMessage(msg, showLoading) {
  var msgHtml = msg.type == "received" ? $("#message-template .received").clone() : $("#message-template .sent").clone();
  if (msg.status == "sent-error") {
    msgHtml.find(".inner").addClass("sent-error");
  }
  msgHtml.attr("id", msg.user_id + "-" + msg.timestamp);
  msgHtml.find(".avatar img").attr("src", msg.avatar);
  if (showLoading) {
    msgHtml.find(".text .inner").html(msg.text + "<span class='msg-sending'>...</span>");
  } else {
    msgHtml.find(".text .inner").html(msg.text);
  }
  msgHtml.appendTo("#messages ul");

  iscroller.refresh();
  iscroller.scrollToElement(document.querySelector('#messages li:nth-last-child(1)'), 500, null, null, IScroll.utils.ease.circular);
}

$(function() {
  document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

  iscroller = new IScroll("#scroll-wrapper", {
    mouseWheel: true
  });

  new FastClick(document.body);

  if (storedMessages[chatKey]) {
    messages = storedMessages[chatKey];
    var i = 0;
    var pageSize = 15;
    var total = messages.length;
    var firstLoadCount = total > pageSize ? pageSize : total;
    for(; i < firstLoadCount; i++) {
      if (total <= pageSize) {
        addMessage(messages[i]);
      } else {
        addMessage(messages[total-pageSize+i]);
      }
    }
  }

  $("#message-toolbar .message-input").on("blur", function(){
    window.scrollTo(0, 0);
  });
});
