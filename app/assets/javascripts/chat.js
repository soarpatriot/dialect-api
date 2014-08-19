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
  alert("window.chat not defined");
} else {
  if(window.chat.getChatInfo == undefined) {
    alert("window.chat.getChatInfo not defined");
  }
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
// init(9, "name", "http://99touxiang.com/public/upload/nvsheng/50/26-022722_295.jpg", 6, "User");
// init(6, "name", "http://99touxiang.com/public/upload/nvsheng/50/26-022722_295.jpg", 9, "User");

var chatKey = targetType + "-" + targetId;

var socketUrl = "inkash.test.soundink.net/websocket?user_id=" + userId;
var dispatcher = new WebSocketRails(socketUrl);
var connectingTry = 0;

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

function saveMessage(message) {
  messages.push(message);
  storedMessages[chatKey] = messages;
  storage.setItem("messages", JSON.stringify(storedMessages));
}

function enableSendingButton() {
  $(".send-button, .message-input").removeAttr("disabled");
  $(".send-button").text("发送");
}

function disableSendingButton() {
  $(".send-button, .message-input").attr("disabled", "true")
  $(".send-button").text("连接中...");
}

$(function() {
  disableSendingButton();

  document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

  iscroller = new IScroll("#scroll-wrapper", {
    mouseWheel: true
  });

  new FastClick(document.body);

  $("#message-toolbar .message-input").on("blur", function(){
    window.scrollTo(0, 0);
  });

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

  dispatcher.bind("client_connected", function(data){
    connectingTry = 0;
    dispatcher.trigger("message.get_offline", {target_id: targetId, target_type: targetType});
    enableSendingButton();
  });

  dispatcher.bind("connection_closed", function(data){
    disableSendingButton();
    setTimeout(function() {
      dispatcher.connect();
      connectingTry += 1;
    }, 1000);
  });

  dispatcher.bind("message.sync", function(data){
    _.each(data, function(message) {
      message.type = "received";
      addMessage(message);

      saveMessage(message);
    });
  });

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

    if (window.chat.updateMessage) {
      window.chat.updateMessage(message.user_id, message.name, message.avatar, message.text);
    } else {
      alert("window.chat.updateMessage not defined");
    }

    saveMessage(message);
  });

  setInterval(function() {
    dispatcher.trigger("message.get_offline", {target_id: targetId, target_type: targetType});
  }, 10000);

});
