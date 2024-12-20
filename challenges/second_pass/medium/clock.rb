# Clock

=begin

P:

Create a clock that is independent of date.

You should be able to add minutes to
  and subtract minutes from
  the time represented by a given Clock object
These + and - operations should not mutate existing object
  return new Clock object

Two clock objects that represent the same time
  should be equal to one another (#==)

Do not use Time, Date, DateTime etc

Etc:

Clock class
::at -> new Clock instance
#to_s
#+
#-

Need to deal with wraparound behaviour forwards and backwards
Need to deal with hours and minutes

Could simply store minutes and then calculate minutes
and hours when giving them out with the to_s method

DS:

MINUTES_PER_HOUR = 60
HOURS_PER_DAY = 24
MINUTES_PER_DAY = MINUTES_PER_HOUR * HOURS_PER_DAY

Clock class
::at -> new Clock instance
#to_s
#+
#-
#==

A:
::at (int hours, int minutes = 0)
Create new Clock object(hours, minutes)

#+
Given an integer, minutes_more
Set minute_pool := @minutes
minutes_pool += @hours * 60
minutes_pool += minutes_more
while minutes_pool >= 1440
  minutes_pool -= 1440
Set new_hours := minutes_pool / 60
Set new_minutes := minutes_pool % 60
Return Clock.at(new_hours, new_minutes)

=end

class Clock
  MINUTES_PER_HOUR = 60
  HOURS_PER_DAY = 24
  MINUTES_PER_DAY = MINUTES_PER_HOUR * HOURS_PER_DAY

  def self.at(hours, minutes = 0)
    Clock.new(hours, minutes)
  end

  def initialize(hours, minutes)
    @hours = hours
    @minutes = minutes
  end

  def +(minutes_more)
    minute_pool = minutes + (hours * MINUTES_PER_HOUR)
    minute_pool += minutes_more
    while minute_pool >= MINUTES_PER_DAY
      minute_pool -= MINUTES_PER_DAY
    end
    while minute_pool.negative?
      minute_pool += MINUTES_PER_DAY
    end
    new_hours, new_minutes = minute_pool.divmod(MINUTES_PER_HOUR)
    Clock.new(new_hours, new_minutes)
  end

  def -(minutes_less)
    self + (-minutes_less)
  end

  def to_s
    format("%02d:%02d", hours, minutes)
  end

  def ==(other)
    hours == other.hours && minutes == other.minutes
  end

  protected

  attr_reader :hours, :minutes

  private_constant :MINUTES_PER_HOUR, :HOURS_PER_DAY, :MINUTES_PER_DAY
end

# 38:56

# 39:37 - rubocop passed
