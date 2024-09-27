# 4. Meetups

=begin

P:

Write a class whose instances represent a day of the month for a recurring
meetup.

The input will be an ordinal number given as a string and a day of the week
Ordinal values:
'first', 'second', 'third', 'fourth', 'fifth', 'last', 'teenth'
Days of the week: 'monday' to 'sunday'
Ignore case.
The meaning of 'teenth' is that are exactly seven days that end in '-teenth'.
Therefore, it's guarenteed that each day of the week will have exactly one date
that is the 'teenth' of that day in a given month.

approach:
for first we just start on the first of the month and iterate until date is a `weekday`
  could do something like,
    d += 1 until d.wday == WEEKDAY_TO_NUMERIC[weekday]
  or
    d += 1 until d.public_send("#{weekday}?".to_sym)
for second, do first and then add 7*1
for third, do first and then add 7*2
for fourth, do first and then add 7*3
for fifth, do first and then add 7*4
  but then we need to check if we're still in the same month
  
for teenth, we could simply
  jump to 13 (d += 12)
  iterate from 13 to 19 and stop when we get to the
  date that is valid for that day of the week

Etc:

Define a class Meetup with a constructor taking a month and a year
with a method `day` which takes weekday and schedule
  where weekday is monday..sunday and schedule is first..teenth

Return nil if the fifth whatever-weekday of the month doesn't exist

class Meetup is a wrapper for the Date class (require 'date')
  #initialize(int year, int month) -> save to instance variables
  #day(string weekday, string schedule)

DS:
input: integers to constructor, strings to #day
output: Date or nil

Need Date class

weekdays:
0 - sunday
1 - monday
...
6 - saturday

A:
#initialize
given two ints, year and month
set @date := new date using args

#day
Given two strings, weekday and schedule
Normalize case
append '?' to weekday
send schedule to as message to self with weekday as argument

#first
Given a string, weekday
date = copy of @date
while date is not weekday
  date = date + 1
return date

#second
date = first(weekday) + 7
return date

#third
date = first(weekday) + 7 * 2
return date

#fourth
date = first(weeday) + 7 * 3
return date

#fifth
date = first(weekday) + 7 * 4
if date's month is the same as @date's month
  return date
else
  return nil

#teenth
date = @date + 12
while date is not weekday
  date = date + 1
return date

#last
date = fourth(weekday)
if (date + 7) has the same month as @date
  return (date + 7)
else
  return date

=end

class Meetup
  def initialize(year, month)
    @fixed_date = Date.civil(year, month)
  end

  def day(weekday, schedule)
    weekday = "#{weekday.downcase}?".to_sym
    send(schedule.downcase.to_sym, weekday)
  end

  private

  attr_reader :fixed_date

  def first(weekday)
    date = fixed_date
    date += 1 until date.public_send(weekday)
    date
  end

  def second(weekday)
    first(weekday) + 7
  end

  def third(weekday)
    first(weekday) + 7 * 2
  end

  def fourth(weekday)
    first(weekday) + 7 * 3
  end

  def fifth(weekday)
    date = first(weekday) + 7 * 4
    date.month == fixed_date.month ? date : nil
  end

  def teenth(weekday)
    date = fixed_date + 12
    date += 1 until date.public_send(weekday)
    date
  end

  def last(weekday)
    fifth(weekday) || fourth(weekday) 
  end
end

# 48:06

# LS solution
# class Meetup
#   SCHEDULE_START_DAY = {
#     'first' => 1,
#     'second' => 8,
#     'third' => 15,
#     'fourth' => 22,
#     'fifth' => 29,
#     'teenth' => 13,
#     'last' => nil
#   }.freeze

#   def initialize(year, month)
#     @year = year
#     @month = month
#     @days_in_month = Date.civil(year, month, -1).day
#   end

#   def day(weekday, schedule)
#     weekday = weekday.downcase
#     schedule = schedule.downcase

#     first_possible_day = first_day_to_search(schedule)
#     last_possible_day = [first_possible_day + 6, @days_in_month].min

#     (first_possible_day..last_possible_day).find do |day|
#       date = Date.civil(@year, @month, day)
#       break date if day_of_week_is?(date, weekday)
#     end
#   end

#   private

#   def first_day_to_search(schedule)
#     SCHEDULE_START_DAY[schedule] || (@days_in_month - 6)
#   end

#   def day_of_week_is?(date, weekday)
#     case weekday
#     when 'monday'   then date.monday?
#     when 'tuesday'   then date.tuesday?
#     when 'wednesday' then date.wednesday?
#     when 'thursday'  then date.thursday?
#     when 'friday'    then date.friday?
#     when 'saturday'  then date.saturday?
#     when 'sunday'    then date.sunday?
#     end
#   end
# end