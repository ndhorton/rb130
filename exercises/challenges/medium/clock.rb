# 3. Clock

=begin

P:

Create a Clock.
The Clock has no concept of date.
Times wrap around at midnight.
We need to be able to add minutes to, and subtract minutes from, a Clock object
Addition and subtraction create a new instance rather than mutating the
existing object

Etc:

A Clock object can be instantiated with the class method `at`, which
  can take one or two arguments, hours and minutes

We need a String representation method that returns a time formatted 'hh:mm'
  The instance method `to_s` returns this string.

format "%02d:%02d", hours, minutes, 24-hour time not 12-hour

1440 minutes in a day
so
current_time = current_clock.hours * 60 + current_clock.minutes
current_time += minutes
missed modulo by 1440
new_hours, new_minutes = current_time divmod 60

3.2.2 :001 > current_time = 23 * 60 + 30
 => 1410 
3.2.2 :002 > current_time += 60
 => 1470 
3.2.2 :003 > current_time %= 1440
 => 30 
3.2.2 :004 > new_hours, new_minutes = current_time.divmod(60)
 => [0, 30] 
3.2.2 :005 > new_hours
 => 0 
3.2.2 :006 > new_minutes
 => 30 
3.2.2 :007 > 

Need to implement #== method
to satisfy test suite (assert_equal, refute_equal)

DS:

class Clock
::at(int hour, minute = 0) -> instantiates new Clock, passes through args
#initialize(int hour, int minute = 0) -> saves hour and minute
#to_s => returns string representation 'hh:mm'
#+(int minutes) -> instantiates new Clock object with caller's time + minutes
#-(int minutes) -> "" - minutes
private ? #hour, #minute attributes

A:

::at
Given two integers, hour, minute
Instantiate new Clock object passing hour and minute to constructor

#initialize
Given two integers, hour, minute
Save to @hour, @minute

#to_s
Format string "%02d:%02d" with hour and minute

#+
Given an integer, additional_minutes
current_total_minutes = hour() * 60 + minute()
current_total_minutes += additional_minutes
current_total_minutes %= MINUTES_IN_DAY (1440)
new_hour, new_minute = current_total_minutes divmod 60
Instantiate new Clock with new_hour, new_minute

#-
Given an integer, minutes_difference
+(-minutes_difference)

=end

class Clock
  MINUTES_IN_DAY = 1440

  def initialize(hour, minute = 0)
    @hour = hour
    @minute = minute
  end

  def ==(other)
    hour == other.hour && minute == other.minute
  end

  def to_s
    format("%02d:%02d", hour, minute)
  end

  def +(additional_minutes)
    current_total_minutes = hour * 60 + minute
    current_total_minutes += additional_minutes
    current_total_minutes %= MINUTES_IN_DAY
    new_hour, new_minute = current_total_minutes.divmod(60)
    Clock.at(new_hour, new_minute)
  end

  def -(minutes_difference)
    self.+(-minutes_difference) # needs to be distinguished from unary +
  end

  def self.at(hour, minute = 0)
    Clock.new(hour, minute)
  end

  protected

  attr_reader :hour, :minute
end

# 39:50

# LS solution
# class Clock
#   attr_reader :hour, :minute

#   ONE_DAY = 24 * 60

#   def initialize(hour, minute)
#     @hour = hour
#     @minute = minute
#   end

#   def self.at(hour, minute = 0)
#     new(hour, minute)
#   end

#   def +(add_minutes)
#     minutes_since_midnight = compute_minutes_since_midnight + add_minutes
#     while minutes_since_midnight >= ONE_DAY
#       minutes_since_midnight -= ONE_DAY
#     end

#     compute_time_from(minutes_since_midnight)
#   end

#   def -(sub_minutes)
#     minutes_since_midnight = compute_minutes_since_midnight - sub_minutes
#     while minutes_since_midnight < 0
#       minutes_since_midnight += ONE_DAY
#     end

#     compute_time_from(minutes_since_midnight)
#   end

#   def ==(other_time)
#     hour == other_time.hour && minute == other_time.minute
#   end

#   def to_s
#     format('%02d:%02d', hour, minute);
#   end

#   private

#   def compute_minutes_since_midnight
#     total_minutes = 60 * hour + minute
#     total_minutes % ONE_DAY
#   end

#   def compute_time_from(minutes_since_midnight)
#     hours, minutes = minutes_since_midnight.divmod(60)
#     hours %= 24
#     self.class.new(hours, minutes)
#   end
# end