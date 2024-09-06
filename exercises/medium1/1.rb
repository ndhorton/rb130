# Listening Device

=begin

P:

Write a #listen method and a #play method for Device.
#listen should #record the return value of a block that is passed to it
  If there is no block, #listen does nothing
#play should print to screen the last recording made

Etc:

DS:

A:

=end

class Device
  def initialize
    @recordings = []
  end

  def record(recording)
    @recordings << recording
  end

  def listen
    record(yield) if block_given?
  end

  # LS solutions
  # def listen
  #   return unless block_given?
  #   recording = yield
  #   record(recording)
  # end

  # def listen
  #   recording = yield if block_given?
  #   record(recording) if recording
  # end

  def play
    puts @recordings.last
  end
end

listener = Device.new
listener.listen { "Hello World!" }
listener.listen
listener.play # Outputs "Hello World!"