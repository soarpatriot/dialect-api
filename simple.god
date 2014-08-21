God.watch do |w|
  w.name = "simple"
  w.start = "ruby /home/soar/source/inkash-api/server.rb -sv"


  w.keepalive
end