$(".send-button").on("click", function () {
  var messageText = $(".message-input").val().trim();
  if (messageText.length === 0) return;

  $(".message-input").val("").focus();

  var message = {
    user_id: userId,
    text: messageText,
    avatar: avatar,
    name: name,
    type: "sent",
    timestamp: (new Date().getTime()),
    status: "sending"
  };

  if (window.chat.updateMessage) {
    window.chat.updateMessage(message.user_id, message.name, message.avatar, message.text);
  } else {
    alert("window.chat.updateMessage not defined");
  }

  addMessage(message, true);
  saveMessage(message);

  dispatcher.trigger("message.create", {
    user_id: message.userId,
    text: message.text,
    avatar: message.avatar,
    name: message.name,
    timestamp: message.timestamp,
    target_id: targetId,
    target_type: targetType
  });

  var el = $("#" + message.user_id + "-" + message.timestamp);
  el.attr("status", "sending");

  setTimeout(function() {
    if (el.attr("status") == "sending") {
      el.find(".inner").addClass("sent-error");
      el.find(".msg-sending").remove();
      message.status = "sent-error";
      saveMessage(message);
    }
  }, 10000);

});
