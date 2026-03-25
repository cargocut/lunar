(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Represents a Datetime. A {!type:Date.t} associated with a
    {!type:Time.t}. *)

(** {1 Types} *)

(** The type describing a Datetime. *)
type t

(** Type listing errors that may occur when working with datetime. *)
type error =
  | Invalid_date of Date.error
  | Invalid_time of Time.error
  | Invalid of Date.error * Time.error
  | Invalid_string of string

(** An exception used for unsafe function. *)
exception Invalid_datetime of error

(** {1 Building datetime} *)

(** [make ?at ~year ~month ~day ()] create and validate a datetime. *)
val make
  :  ?at:int * int * int
  -> year:int
  -> month:Month.t
  -> day:int
  -> unit
  -> (t, error) result

(** [make' ?at ~year ~month ~day ()] create and validate a datetime. see
    {!val:make}. Take an integer rather than a {!type:Month.t}. *)
val make'
  :  ?at:int * int * int
  -> year:int
  -> month:int
  -> day:int
  -> unit
  -> (t, error) result

(** [make_exn ?at ~year ~month ~day ()] create and validate a datetime
    like {!val:make} but raise [Invalid_datetime] if the validation
    doesn't succeed. *)
val make_exn
  :  ?at:int * int * int
  -> year:int
  -> month:Month.t
  -> day:int
  -> unit
  -> t

(** [make_exn' ?at ~year ~month ~day ()] create and validate a datetime,
    like {!val:make'} but raise [Invalid_datetime] if the validation doesn't
    succeed. *)
val make_exn'
  :  ?at:int * int * int
  -> year:int
  -> month:int
  -> day:int
  -> unit
  -> t

(** [from_string s] try to read a date from a string (using the format
    [year-mon-day hh:mm:ss]). *)
val from_string : string -> (t, error) result

(** [from_string_exn s] try to read a date from a string (using the format
    [year-mon-day hh:mm:ss]) and raise and exception if it fails. *)
val from_string_exn : string -> t

(** [from d t] creates a datetime object for the given date, [d] and a
    given time [t]. *)
val from : Date.t -> Time.t -> t

(** [from_date d] creates a datetime object for the given date, [d], at
    midnight. *)
val from_date : Date.t -> t

(** [from_duration d] converts a duration to a date.
    [0] is the 1970-01-01 at 00:00:00. *)
val from_duration : Duration.t -> t

(** Returns the 1st January 1970 at midnight. *)
val epoch : t

(** {1 Accessors}

    Information and facts about Datetime. *)

(** [date dt] returns the date part of the datetime. *)
val date : t -> Date.t

(** [time dt] returns the time part of the datetime. *)
val time : t -> Time.t

(** [hour dt] returns the hour. *)
val hour : t -> int

(** [hour dt] returns the minute. *)
val minute : t -> int

(** [hour dt] returns the second. *)
val second : t -> int

(** [era dt] returns the {i era} of the given datetime [dt]. *)
val era : t -> Era.t

(** [year_of_era dt] returns the year of the associated era for the given
    datetime [dt]. *)
val year_of_era : t -> int

(** [century d] returns the century of the associated era for the given
    datetime [dt]. *)
val century_of_era : t -> int

(** [year_of_century d] returns the year of the century of the associated
    era for the given datetime [dt]. *)
val year_of_century : t -> int

(** [year dt] returns the year from a datetime. *)
val year : t -> int

(** [quarter dt] Returns the quarter number ([1-4]) in which the given datetime
    [dt] falls. *)
val quarter : t -> int

(** [month dt] returns the month from a datetime. *)
val month : t -> Month.t

(** [day_of_month dt] returns the day of month from a datetime. *)
val day_of_month : t -> int

(** [day_of_week dt] returns the day of week from a datetime. *)
val day_of_week : t -> Weekday.t

(** [days_in_month dt] returns the number of days in the month of the given
    datetime [dt]. *)
val days_in_month : t -> int

(** [day_of_year dt] returns the day of year from a datetime. *)
val day_of_year : t -> int

(** [week_of_year dt] returns the pair [year] and [week number] for a
    given datetime [dt]. See {!val:Date.week_of_year}. *)
val week_of_year : t -> int * int

(** {2 Aliases}

    A few aliases for common terms. *)

(** See {!val:day_of_month}. *)
val day : t -> int

(** See {!val:day_of_week}. *)
val weekday : t -> Weekday.t

(** {1 Component lenses}

    A datetime is simply a pair consisting of a
    {!type:Date.t} and {!type:Time.t}. *)

(** [to_pair dt] convert the given datetime [dt] into a pair of
    {!type:Date.t} and {!type:Time.t} *)
val to_pair : t -> Date.t * Time.t

(** [on_date f dt] apply [f] on the date part of the given datetime
    ([dt]). *)
val on_date : (Date.t -> 'a) -> t -> 'a

(** [on_time f dt] apply [f] on the time part of the given datetime
    ([dt]). *)
val on_time : (Time.t -> 'a) -> t -> 'a

(** [map_date f dt] update the date part of the given datetime [d] using
    [f]. *)
val map_date : (Date.t -> Date.t) -> t -> t

(** [map_time f dt] update the time part of the given datetime [d] using
    [f]. *)
val map_time : (Time.t -> Time.t) -> t -> t

(** {1 Operation on datetimes} *)

(** [add duration dt] compute a new date adding [duration] to the given
    [dt]. *)
val add : Duration.t -> t -> t

(** [sub duration dt] compute a new date substracting [duration] to the given
    [dt]. *)
val sub : Duration.t -> t -> t

(** [add_seconds number_of_seconds datetime] add [number_of_seconds] to the
    given [datetime]. *)
val add_seconds : int -> t -> t

(** [sub_seconds number_of_seconds datetime] remove [number_of_seconds] to the
    given [datetime]. *)
val sub_seconds : int -> t -> t

(** [add_minutes number_of_minutes datetime] add [number_of_minutes] to the
    given [datetime]. *)
val add_minutes : int -> t -> t

(** [sub_minutes number_of_minutes datetime] remove [number_of_minutes] to the
    given [datetime]. *)
val sub_minutes : int -> t -> t

(** [add_hours number_of_hours datetime] add [number_of_hours] to the
    given [datetime]. *)
val add_hours : int -> t -> t

(** [sub_hours number_of_hours datetime] remove [number_of_hours] to the
    given [datime]. *)
val sub_hours : int -> t -> t

(** [add_days number_of_days datetime] add [number_of_days] to the given
    [datetime]. *)
val add_days : int -> t -> t

(** [sub_days number_of_days datetime] remove [number_of_days] to the
    given [datetime]. *)
val sub_days : int -> t -> t

(** [add_weeks number_of_weeks datetime] add [number_of_weeks] to the
    given [datetime] (a week is [7] days). *)
val add_weeks : int -> t -> t

(** [sub_weeks number_of_weeks datetime] remove [number_of_weeks] to the
    given [datetime] (a week is [7] days). *)
val sub_weeks : int -> t -> t

(** [add_months number_of_months datetime] add [number_of_months] to the
    given [datetime]. *)
val add_months : int -> t -> t

(** [add_months number_of_months datetime] remove [number_of_months] to
    the given [datetime]. *)
val sub_months : int -> t -> t

(** [add_quarters number_of_quarters datetime] add [number_of_quarters] to the
    given [datetime]. *)
val add_quarters : int -> t -> t

(** [add_quarters number_of_quarters datetime] remove [number_of_quarters] to
    the given [datetime]. *)
val sub_quarters : int -> t -> t

(** [add_years number_of_years datetime] add [number_of_years] to the
    given [datetime]. *)
val add_years : int -> t -> t

(** [sub_years number_of_years datetime] remove [number_of_years] to the
    given [datetime]. *)
val sub_years : int -> t -> t

(** [diff d1 d2] returns the difference (in {!type:Duration.t}) between
    [d1] and [d2]. *)
val diff : t -> t -> Duration.t

(** {2 Succ and Pred}

    The main difference between the [add]/[sub] and [succ]/[pred] operations
    lies in how the result is truncated. [add] and [sub] are standard
    arithmetic operations: you add or subtract a duration.
    [succ] and [pred], on the other hand, calculate the next datetime step.
    See {!val:Time.succ} and {!val:Date.succ}. *)

(** [succ dt] is [add_seconds 1]. *)
val succ : t -> t

(** [pred dt] is [sub_seconds 1]. *)
val pred : t -> t

(** [succ_second dt] returns the datetime at the next second. See {!val:succ}.
*)
val succ_second : t -> t

(** [pred_second dt] returns the datetime at the previous second. See
    {!val:pred}. *)
val pred_second : t -> t

(** [succ_minute dt] returns the datetime at the next minute. *)
val succ_minute : t -> t

(** [pred_minute t] returns the datetime at the previous minute. *)
val pred_minute : t -> t

(** [succ_hour t] returns the datetime at the next hour. *)
val succ_hour : t -> t

(** [pred_hour t] returns the datetime at the previous hour. *)
val pred_hour : t -> t

(** [succ_day ?where:pred from] returns the first following datetime that
    satisfies the predicate [pred] starting from the date [from]
    (exclusive). {b Note}: If the predicate always returns [false],
    the function never terminates. *)
val succ_day : ?where:(Date.t -> bool) -> t -> t

(** [pred_day ~where:pred from] returns the first previous datetime that
    satisfies the predicate [pred] starting from the date [from]
    (exclusive). {b Note}: If the predicate always returns [false],
    the function never terminates. *)
val pred_day : ?where:(Date.t -> bool) -> t -> t

(** [succ_day_of_week weekday from] returns the first following datetime
    corresponding to the specified day of the week. *)
val succ_day_of_week : Weekday.t -> t -> t

(** [pred_day_of_week weekday from] returns the first previous datetime
    corresponding to the specified day of the week. *)
val pred_day_of_week : Weekday.t -> t -> t

(** [succ_weekday from] returns the first following day of week (not
    weekend). *)
val succ_weekday : t -> t

(** [pred_weekday from] returns the first previous day of week (not
    weekend). *)
val pred_weekday : t -> t

(** [succ_week dt] returns the first day of the next week. *)
val succ_week : ?week_start:Weekday.t -> t -> t

(** [pred_week dt] returns the first day of the previous week. *)
val pred_week : ?week_start:Weekday.t -> t -> t

(** [succ_month dt] returns the first day of the next month. *)
val succ_month : t -> t

(** [pred_month dt] returns the first day of the previous month. *)
val pred_month : t -> t

(** [succ_quarter dt] returns the first day of the next quarter. *)
val succ_quarter : t -> t

(** [pred_quarter dt] returns the first day of the previous quarter. *)
val pred_quarter : t -> t

(** [succ_year dt] returns the first day of the next year. *)
val succ_year : t -> t

(** [pred_year dt] returns the first day of the previous year. *)
val pred_year : t -> t

(** {2 On duration}

    Arithmetic operations, such as {!val:add} and {!val:sub}, rely on
    conversions to {!type:Duration.t}, which means, for example, that in the
    expression: [Infix.(date + d1 + d2 + d3)], [datetime] is
    converted to duration, added, converted back to date, added
    again, and so on.

    For simply adding a single value, this is fine, but when you want
    to build more complex operations, this back-and-forth is a bit
    tedious. {!val:as_duration} allows you to avoid these trips back
    and forth. *)

(** [as_duration f dt] Converts the given datetime [dt] to a duration,
    applies the function [f] to this duration, and returns the result
    as a date. Useful for performing multiple operations on a
    single datetime. *)
val as_duration : (Duration.t -> Duration.t) -> t -> t

(** {1 Common Operations} *)

(** [with_time time datetime] replace the [time] of the given [datetime]. *)
val with_time : Time.t -> t -> t

(** [with_date date datetime] replace the [date] of the given [datetime]. *)
val with_date : Date.t -> t -> t

(** [tomorrow dt] get the next day of the given [dt]. See {!val:succ_day}. *)
val tomorrow : t -> t

(** [yesterday dt] get the previous day of the given [dt]. See
    {!val:pred_day}. *)
val yesterday : t -> t

(** [start_of_minute dt] returns the datetime at the start of the current
    minute. *)
val start_of_minute : t -> t

(** [end_of_minute dt] returns the datetime at the end of the current
    minute. *)
val end_of_minute : t -> t

(** [start_of_hour dt] returns the datetime at the start of the current
    hour. *)
val start_of_hour : t -> t

(** [end_of_hour dt] returns the datetime at the end of the current
    hour. *)
val end_of_hour : t -> t

(** [start_of_day dt] Returns a datetime set to the start of the day
    (midnight). *)
val start_of_day : t -> t

(** [end_of_day dt] Returns a datetime set to the end of the day
    (23:59:59). *)
val end_of_day : t -> t

(** [start_of_morning dt] returns the datetime at 05:00:00. *)
val start_of_morning : t -> t

(** [end_of_morning dt] returns the datetime at 11:59:59. *)
val end_of_morning : t -> t

(** [start_of_afternoon dt] returns the datetime at 12:00:00. *)
val start_of_afternoon : t -> t

(** [at_noon] is {!val:start_of_afternoon}. *)
val at_noon : t -> t

(** [end_of_afternoon dt] returns the datetime at 16:59:59. *)
val end_of_afternoon : t -> t

(** [start_of_evening dt] returns the datetime at 17:00:00. *)
val start_of_evening : t -> t

(** [end_of_evening dt] returns the datetime at 20:59:59. *)
val end_of_evening : t -> t

(** [start_of_night dt] returns the datetime at 21:00:00. *)
val start_of_night : t -> t

(** [end_of_night dt] returns the datetime at 04:59:59. *)
val end_of_night : t -> t

(** [start_of_week ?week_start dt] Returns the first day of the week
    (defined by [week_start]; default: Monday). *)
val start_of_week : ?week_start:Weekday.t -> t -> t

(** [end_of_week ?week_start dt] Returns the last day of the week
    (defined by [week_start - 1]; default: Monday). *)
val end_of_week : ?week_start:Weekday.t -> t -> t

(** [start_of_month dt] returns the first day of the month of the given
    datetime [dt]. *)
val start_of_month : t -> t

(** [end_of_month dt] returns the last day of the month of the given
    datetime [dt]. *)
val end_of_month : t -> t

(** [start_of_quarter dt] returns the first day of the quarter of the given
    datetime [dt]. *)
val start_of_quarter : t -> t

(** [end_of_quarter dt] returns the last day of the quarter of the given
    datetime [dt]. *)
val end_of_quarter : t -> t

(** [start_of_year dt] returns the first day of the year of the given
    datetime [d]. *)
val start_of_year : t -> t

(** [end_of_year dt] returns the last day of the year of the given
    datetime [dt]. *)
val end_of_year : t -> t

(** [age ~birthday current] returns the age calculated from [birthday]
    using the given datetime [current] as the current date. *)
val age : birthday:Date.t -> t -> int

(** {1 Round and truncate}

    A negative duration can produce very strange results, which is
    why durations are converted to absolute values in rounding functions. *)

(** [truncate resolution d] truncates [d] to the beginning of the period
    specified by [resolution]. See {!val:Date.truncate} and
    {!val:Time.truncate}.

    All units smaller than [resolution] are discarded. *)
val truncate : [< Resolution.t ] -> t -> t

(** [floor resolution d] is [truncate resolution d]. *)
val floor : [< Resolution.t ] -> t -> t

(** [round resolution d] rounds [d] to the nearest boundary of the period
    specified by [resolution]. See {!val:Date.round} and
    {!val:Time.round}. *)
val round : [< Resolution.t ] -> t -> t

(** [ceil resolution d] rounds [d] up to the next boundary of the period
    specified by [resolution]. If [d] is already aligned with
    [resolution], it is returned unchanged. See {!val:Date.ceil}
    and {!val:Time.ceil}. *)
val ceil : [< Resolution.t ] -> t -> t

(** {1 Predicates} *)

(** [is_am dt] returns [true] if the time of the given [dt] is between
    [00:00:00] and [11:59:59], [false] otherwise. *)
val is_am : t -> bool

(** [is_pm dt] returns [true] if the time of the given [dt] is between
    [12:00:00] and [23:59:59], [false] otherwise. *)
val is_pm : t -> bool

(** [is_noon dt] returns [true] if the time of the given [dt] is exactly
    [12:00:00], [false] otherwise. *)
val is_noon : t -> bool

(** [is_midnight dt] returns [true] if the time of the given [dt] is
    exactly [00:00:00], [false] otherwise. *)
val is_midnight : t -> bool

(** [is_morning dt] returns [true] if the time of the given [dt] is
    between [05:00:00] and [11:59:59], [false] otherwise. *)
val is_morning : t -> bool

(** [is_afternoon dt] returns [true] if the time of the given [dt] is
    between [12:00:00] and [16:59:59], [false] otherwise. *)
val is_afternoon : t -> bool

(** [is_evening dt] returns [true] if the time of the given [dt] is
    between [17:00:00] and [20:59:59], [false] otherwise. *)
val is_evening : t -> bool

(** [is_night dt] returns [true] if the time of the given [dt] is between
    [21:00:00] and [04:59:59], [false] otherwise. *)
val is_night : t -> bool

(** [is_weekend dt] returns [true] if the date of the given [dt] is on
    [Saturday] or [Sunday]. *)
val is_weekend : t -> bool

(** [is_weekday dt] returns [true] if the date of the given [dt] is not on
    [Saturday] or [Sunday]. *)
val is_weekday : t -> bool

(** [is_day_of_week wd d] returns [true] if the current day of week is the
    given one [wd], [false] otherwise.*)
val is_day_of_week : Weekday.t -> t -> bool

(** [is_first_day_of_week ?week_start d] returns [true] if the given date [d] is the
    first day of the week. *)
val is_first_day_of_week : ?week_start:Weekday.t -> t -> bool

(** [is_last_day_of_week ?week_start d] returns [true] if the given date [d] is the
    last day of the week. *)
val is_last_day_of_week : ?week_start:Weekday.t -> t -> bool

(** [is_leap_year dt] returns [true] if [year d] is a leap year, [false]
    otherwise.*)
val is_leap_year : t -> bool

(** [is_first_day_of_month dt] returns [true] if the date of the given
    [dt] is the first day of the month. *)
val is_first_day_of_month : t -> bool

(** [is_last_day_of_month dt] returns [true] if the date of the given [dt]
    is the last day of the month. *)
val is_last_day_of_month : t -> bool

(** [is_first_day_of_quarter d] returns [true] if the date of the given [dt] is the
    first day of the current quarter. *)
val is_first_day_of_quarter : t -> bool

(** [is_last_day_of_q d] returns [true] if the date of the given [dt] is the
    last day of the current quarter. *)
val is_last_day_of_quarter : t -> bool

(** [is_first_day_of_year dt] returns [true] if the date of the given [dt]
    is the first day of the year. *)
val is_first_day_of_year : t -> bool

(** [is_last_day_of_year dt] returns [true] if the date of the given [dt]
    is the last day of the year. *)
val is_last_day_of_year : t -> bool

(** {1 Comparison} *)

(** Equality between dates. *)
val equal : t -> t -> bool

(** [compare a b] comparison between dates, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Conversion} *)

(** [to_duration dt] returns a duration since {!val:epoch} for the given
    datetime [dt].*)
val to_duration : t -> Duration.t

(** [to_string dt] returns a string representation of the given [dt]. *)
val to_string : t -> string

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  (** [d + dur] is {!val:add} *)
  val ( + ) : t -> Duration.t -> t

  (** [d - dur] is {!val:sub} *)
  val ( - ) : t -> Duration.t -> t

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
