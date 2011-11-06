// Partial implementation of the Greasemonkey API, see:
// http://wiki.greasespot.net/Greasemonkey_Manual:APIs

function GM_addStyle(css) {
  var parent = document.getElementsByTagName("head")[0];
  if (!parent) {
    parent = document.documentElement;
  }
  var style = document.createElement("style");
  style.type = "text/css";
  var textNode = document.createTextNode(css);
  style.appendChild(textNode);
  parent.appendChild(style);
}

function GM_log(message) {
    window.console.log(message);
}

(function (document) {
  %@;
});
