var iscroller;

var initIScroll = function() {
  if(!ios) {
    return;
  }

  document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

  iscroller = new IScroll(".iscroll-wrapper", {
    mouseWheel: true,
    probeType: 3
  });

  iscroller.on('scroll', function() {
    var distance = -this.y;
    var backgroundSize = (1 - distance/$(".container-information").height()) * 100 + 20;
    var backgroundPositionY = -distance/4;
    if (backgroundSize <= 100) {
      backgroundSize = 100;
    }
    if(backgroundPositionY >=0) {
      backgroundPositionY = 0;
    }

    $(".container-information").css({
      "background-size": backgroundSize + "%",
      "background-position-y": backgroundPositionY + "px"
    });
  });

  $("img").load(function(){
    iscroller.refresh();
  });
}
