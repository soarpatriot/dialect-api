// var database = window.localStorage.getItem("messages");
// var storedMessages = {};

// if (database) {
//   storedMessages = JSON.parse(database);
// }

// window.Messages = function(chatKey) {

//   this.storage = storedMessages[chatKey];

//   this.list = function() {
//     return storage;
//   }

//   this.save = function(message) {
//     storage.push(message);
//     persist();
//   }

//   this.persist = function() {
//     storedMessages[chatKey] = storage;
//     window.localStorage.setItem("messages", JSON.stringify(storedMessages));
//   }
// }
