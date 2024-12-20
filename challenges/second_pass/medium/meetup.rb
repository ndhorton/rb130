# Meetups

=begin

P:

Write a Meetup class that encapsulates a month and year.
Each object takes a month number (1-12) and a year (2021)
You should be able to query the Meetup for the exact date
the meetup will be happening in a particular month of a particular
year.

The descriptors that may be given are strings:
'first', 'second', 'third', 'fourth', 'fifth', 'last', 'teenth'
Should be case-insensitive.

There are 7 days of the month ending in -teenth
So in any particular month, a day out of these seven in that
month can be uniquely identified by the day of the week
and 'teenth'

Etc:

Define a class Meetup with a constructor taking month, year
#day(weekday, schedule) -> Date object
weekday is 'monday' .. 'sunday'
schedule is 'first' .. 'teenth'

#day returns `nil` if we ask for the 'fifth' and there isn't one

approach:

2013, 3

One way to do it
if teenth
  loop forward until day is 13
  loop forward until weekday

loop forward until we find the right day of week
  starting from 1st of the month
first = we're there
second = add 7
third = add 14
fourth = add 21
fifth = add 28, if the month is wrong, return nil
last = first day of next month loop back to correct weekday

DS:

#day method needs to return a Date giving the precise
day based on month and year given to constructor
plus weekday and 'first' type descriptor

A:

#day
Given two strings, weekday and schedule
Normalize case
if schedule == 'teenth'
  calculate_teenth(weekday, schedule)
else

#calculate_teenth
Given weekend and schedule
date = Date.new(year, month, 13)
date = find_weekday(weekday, date)
return date

#calculate_day
Given weekend and schedule
date = Date.new(year, month, 1)
date = find_weekday(weekday, date)

=end

require 'date'

class Meetup
  WEEKDAYS = %w(
    monday tuesday wednesday thursday friday saturday sunday
  ).freeze
  private_constant :WEEKDAYS

  def initialize(year, month)
    @year = year
    @month = month
  end

  def day(weekday, schedule)
    weekday = weekday.downcase
    schedule = schedule.downcase
    raise ArgumentError unless WEEKDAYS.include?(weekday)
    weekday = "#{weekday}?"

    case schedule
    when 'teenth' then calculate_teenth(weekday)
    when 'fifth'  then calculate_fifth(weekday)
    when 'last'   then calculate_last(weekday)
    else               calculate_day(weekday, schedule)
    end
  end

  private

  attr_reader :year, :month

  def calculate_day(weekday, schedule)
    date = find_weekday(weekday, Date.new(year, month, 1))
    case schedule
    when 'first'    then date
    when 'second'   then date + 7
    when 'third'    then date + 14
    when 'fourth'   then date + 21
    end
  end

  def calculate_fifth(weekday)
    date = find_weekday(weekday, Date.new(year, month, 1))
    date += 28
    return if date.month != month
    date
  end

  def calculate_last(weekday)
    date = Date.new(year, month, -1)
    date -= 1 until date.public_send(weekday)
    date
  end

  def calculate_teenth(weekday)
    find_weekday(weekday, Date.new(year, month, 13))
  end

  def find_weekday(weekday, date)
    date += 1 until date.public_send(weekday)
    date
  end
end

# 50:25 (forgot to pause, so probably 5-10 minutes less in reality)
# 56:05 refactor to ensure weekday is not malicious, passes rubocop
