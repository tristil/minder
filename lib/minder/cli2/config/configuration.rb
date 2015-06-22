Vedeu.configure do
  log         "/tmp/cli2.log"

  base_path File.dirname(File.expand_path('./../', __FILE__))

  # debug!
  # drb!
  # drb_host    'localhost'
  # drb_port    21420
  # drb_width   80
  # drb_height  25

  # cooked!
  # raw!

  # run_once!

  # interactive!
  # standalone!

  # Not used yet
  # stdin  File.open("/dev/tty", "r")
  # stdout File.open("/dev/tty", "w")
  # stderr File.open("/tmp/vedeu_error.log", "w+")
end
Vedeu::Log.log(message: 'hello')
