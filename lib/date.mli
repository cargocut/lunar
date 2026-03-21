(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Represents a date (year, month, day). *)

(** {1 Types} *)

(** The type describing a Date. *)
type t

(** Type listing errors that may occur when working with date. *)
type error =
  | Invalid_year of int
  | Invalid_month of Month.error
  | Invalid_day of
      { day_max : int
      ; day : int
      }
  | Invalid_string of string

(** An exception used for unsafe function. *)
exception Invalid_date of error

(** {1 Building date} *)

(** [make ~year ~month ~day ()] create and validate a date. *)
val make : year:int -> month:Month.t -> day:int -> unit -> (t, error) result

(** [make' ~year ~month ~day ()] create and validate a date, see
    {!val:make}. Take an integer rather than a {!val:Month.t}. *)
val make' : year:int -> month:int -> day:int -> unit -> (t, error) result

(** [make_exn ~year ~month ~day ()] create and validate a date
    like {!val:make} but raise [Invalid_date] if the validation
    doesn't succeed. *)
val make_exn : year:int -> month:Month.t -> day:int -> unit -> t

(** [make_exn' ~year ~month ~day ()] create and validate a date,
    like {!val:make'} but raise [Invalid_date] if the validation doesn't
    succeed. *)
val make_exn' : year:int -> month:int -> day:int -> unit -> t

(** [from_string] try to read a date from a string (using the format
    [year-mon-day]). *)
val from_string : string -> (t, error) result

(** [from_string_exn] try to read a date from a string (using the format
    [year-mon-day]) and raise and exception if it fails. *)
val from_string_exn : string -> t

(** [from_duration d] converts a duration to a date.
    [0] is the 1970-01-01. *)
val from_duration : Duration.t -> t

(** [epoch] is the date at 1970-01-01. *)
val epoch : t

(** {1 Accessors}

    Information and facts about Date. *)

(** [era d] returns the {i era} of the given date [d]. *)
val era : t -> Era.t

(** [year_of_era d] returns the year of the associated era for the given
    date [d]. *)
val year_of_era : t -> int

(** [century d] returns the century of the associated era for the given
    date [d]. *)
val century_of_era : t -> int

(** [year_of_century d] returns the year of the century of the associated
    era for the given date [d]. *)
val year_of_century : t -> int

(** [year dt] returns the year from a date. *)
val year : t -> int

(** [quarter d] Returns the quarter number ([1-4]) in which the given date
    [d] falls. *)
val quarter : t -> int

(** [month dt] returns the month from a date. *)
val month : t -> Month.t

(** [day_of_month dt] returns the day of month from a date. *)
val day_of_month : t -> int

(** [day_of_week dt] returns the day of week from a date. *)
val day_of_week : t -> Weekday.t

(** [days_in_month d] returns the number of days in the month of the given
    date [d]. *)
val days_in_month : t -> int

(** [day_of_year dt] returns the day of year from a date. *)
val day_of_year : t -> int

(** [week_of_year dt] returns the pair [year] and [week number] for a
    given datetime [dt].

    The ISO 8601 standard is used where Monday is the first
    day of the week. The year is carried over if a day belongs
    to a week in the previous year.

    {b see:} {{:https://en.wikipedia.org/wiki/ISO_8601} ISO 8601}. *)
val week_of_year : t -> int * int

(** {1 Aliases}

    A few aliases for common terms. *)

(** See {!val:day_of_month}. *)
val day : t -> int

(** See {!val:day_of_week}. *)
val weekday : t -> Weekday.t

(** {1 Conversion} *)

(** [to_duration dt] returns a duration since {!val:epoch} for the given
    datetime [dt].*)
val to_duration : t -> Duration.t

(** [to_string dt] returns a string representation of the given [dt]. *)
val to_string : t -> string

(** {1 Operation on dates} *)

(** [add duration date] compute a new date adding [duration] to the given
    [date]. {b warning}: Since the duration does not always correspond
    to a full day, the results are truncated. *)
val add : Duration.t -> t -> t

(** [sub duration date] compute a new date substracting [duration] to
    the given [datetime]. {b warning}: Since the duration does not
    always correspond to a full day, the results are truncated. *)
val sub : Duration.t -> t -> t

(** [add_days number_of_days d] add [number_of_days] to the given date
    [d]. *)
val add_days : int -> t -> t

(** [sub_days number_of_days d] remove [number_of_days] to the given date
    [d]. *)
val sub_days : int -> t -> t

(** [add_weeks number_of_weeks d] add [number_of_weeks] to the given date
    [d] (a week is [7] days). *)
val add_weeks : int -> t -> t

(** [sub_weeks number_of_weeks d] remove [number_of_weeks] to the given date
    [d] (a week is [7] days). *)
val sub_weeks : int -> t -> t

(** [add_months number_of_months d] add [number_of_months] to the given
    date [d]. *)
val add_months : int -> t -> t

(** [add_months number_of_months d] remove [number_of_months] to the given
    date [d]. *)
val sub_months : int -> t -> t

(** [add_years number_of_years d] add [number_of_years] to the given date
    [d]. *)
val add_years : int -> t -> t

(** [sub_years number_of_years d] remove [number_of_years] to the given date
    [d]. *)
val sub_years : int -> t -> t

(** [succ d] is [add_days 1]. *)
val succ : t -> t

(** [pred d] is [sub_days 1]. *)
val pred : t -> t

(** [diff d1 d2] returns the difference (in {!type:Duration.t}) between
    [d1] and [d2]. *)
val diff : t -> t -> Duration.t

(** [next_day ~where:pred from] returns the first following date that
    satisfies the predicate [pred] starting from the date [from]
    (exclusive). {b Note}: If the predicate always returns [false],
    the function never terminates. *)
val next_day : where:(t -> bool) -> t -> t

(** [prev_day ~where:pred from] returns the first previous date that
    satisfies the predicate [pred] starting from the date [from]
    (exclusive). {b Note}: If the predicate always returns [false],
    the function never terminates. *)
val prev_day : where:(t -> bool) -> t -> t

(** [next_day_of_week weekday from] returns the first following date
    corresponding to the specified day of the week. *)
val next_day_of_week : Weekday.t -> t -> t

(** [pred_day_of_week weekday from] returns the first previous date
    corresponding to the specified day of the week. *)
val prev_day_of_week : Weekday.t -> t -> t

(** [next_weekday from] returns the first following day of week (not
    weekend). *)
val next_weekday : t -> t

(** [pred_weekday from] returns the first previous day of week (not
    weekend). *)
val prev_weekday : t -> t

(** {2 On duration}

    Arithmetic operations, such as {!val:add} and {!val:sub}, rely on
    conversions to {!type:Duration.t}, which means, for example, that in the
    expression: [Infix.(date + d1 + d2 + d3)], [date] is
    converted to duration, added, converted back to date, added
    again, and so on.

    For simply adding a single value, this is fine, but when you want
    to build more complex operations, this back-and-forth is a bit
    tedious. {!val:as_duration} allows you to avoid these trips back
    and forth. *)

(** [as_duration f d] Converts the given date [d] to a duration,
    applies the function [f] to this duration, and returns the result
    as a date. Useful for performing multiple operations on a
    single date. *)
val as_duration : (Duration.t -> Duration.t) -> t -> t

(** {1 Comparison} *)

(** Equality between dates. *)
val equal : t -> t -> bool

(** [compare a b] comparison between dates, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Common Operations} *)

(** [tomorrow d] get the next day of the given [d]. See {!val:succ}. *)
val tomorrow : t -> t

(** [yesterday d] get the previous day of the given [d]. See {!val:pred}. *)
val yesterday : t -> t

(** [next_week d] returns the first day of the next week. *)
val next_week : ?week_start:Weekday.t -> t -> t

(** [prev_week d] returns the first day of the previous week. *)
val prev_week : ?week_start:Weekday.t -> t -> t

(** [next_month d] returns the first day of the next month. *)
val next_month : t -> t

(** [prev_month d] returns the first day of the previous month. *)
val prev_month : t -> t

(** [next_quarter d] returns the first day of the next quarter. *)
val next_quarter : t -> t

(** [prev_quarter d] returns the first day of the previous quarter. *)
val prev_quarter : t -> t

(** [next_year d] returns the first day of the next year. *)
val next_year : t -> t

(** [prev_year d] returns the first day of the previous year. *)
val prev_year : t -> t

(** [start_of_week ?week_start d] Returns the first day of the week
    (defined by [week_start]; default: Monday). *)
val start_of_week : ?week_start:Weekday.t -> t -> t

(** [end_of_week ?week_start d] Returns the last day of the week
    (defined by [week_start - 1]; default: Monday). *)
val end_of_week : ?week_start:Weekday.t -> t -> t

(** [start_of_month d] returns the first day of the month of the given
    date [d]. *)
val start_of_month : t -> t

(** [end_of_month d] returns the last day of the month of the given
    date [d]. *)
val end_of_month : t -> t

(** [start_of_quarter d] returns the first day of the quarter of the given
    date [d]. *)
val start_of_quarter : t -> t

(** [end_of_quarter d] returns the last day of the quarter of the given
    date [d]. *)
val end_of_quarter : t -> t

(** [start_of_year d] returns the first day of the year of the given
    date [d]. *)
val start_of_year : t -> t

(** [end_of_year d] returns the last day of the year of the given
    date [d]. *)
val end_of_year : t -> t

(** [age ~birthday current] returns the age calculated from [birthday]
    using the given date [current] as the current date. *)
val age : birthday:t -> t -> int

(** {1 Round and truncate}

    A negative duration can produce very strange results, which is
    why durations are converted to absolute values in rounding functions. *)

(** [truncate resolution d] truncates [d] to the beginning of the
    period specified by [resolution].

    All units smaller than [resolution] are discarded.

    Examples:
    - [truncate `day 2024-03-15] = [2024-03-15]
    - [truncate (`week Mon) 2024-03-13] = [2024-03-11]
    - [truncate `month 2024-03-15] = [2024-03-01]
    - [truncate `quarter 2024-05-10] = [2024-04-01]
    - [truncate `year 2024-03-15] = [2024-01-01]. *)
val truncate : [< Resolution.for_date ] -> t -> t

(** [floor resolution d] is [truncate resolution d]. *)
val floor : [< Resolution.for_date ] -> t -> t

(** [round resolution d] rounds [d] to the nearest boundary of
    the period specified by [resolution].

    If [d] lies exactly halfway between two boundaries, it is rounded
    up to the next one.

    Examples:
    - [round `month 2024-03-10] = [2024-03-01]
    - [round `month 2024-03-20] = [2024-04-01]
    - [round `quarter 2024-02-15] = [2024-01-01]
    - [round `quarter 2024-03-20] = [2024-04-01]
    - [round `year 2024-07-01] = [2025-01-01]. *)
val round : [< Resolution.for_date ] -> t -> t

(** [ceil resolution d] rounds [d] up to the next boundary of the
    period specified by [resolution]. If [d] is already aligned with
    [resolution], it is returned unchanged.

    All units smaller than [resolution] are discarded unless rounding
    up requires incrementing a larger unit.

    Examples:
    - [ceil `month 2024-03-01] = [2024-03-01]
    - [ceil `month 2024-03-02] = [2024-04-01]
    - [ceil (`week Mon) 2024-03-11] = [2024-03-11]
    - [ceil (`week Mon) 2024-03-13] = [2024-03-18]
    - [ceil `year 2024-01-01] = [2024-01-01]
    - [ceil `year 2024-03-15] = [2025-01-01]. *)
val ceil : [< Resolution.for_date ] -> t -> t

(** {1 Predicates} *)

(** [is_weekend d] returns [true] if the given date [d] is on [Saturday]
    or [Sunday]. *)
val is_weekend : t -> bool

(** [is_weekday] returns [true] if the given date [d] is not on [Saturday]
    or [Sunday]. *)
val is_weekday : t -> bool

(** [is_leap_year dt] returns [true] if [year dt] is a leap year, [false]
    otherwise.*)
val is_leap_year : t -> bool

(** [is_first_day_of_month d] returns [true] if the given date [d] is the
    first day of the month. *)
val is_first_day_of_month : t -> bool

(** [is_last_day_of_month d] returns [true] if the given date [d] is the
    last day of the month. *)
val is_last_day_of_month : t -> bool

(** [is_first_day_of_year d] returns [true] if the given date [d] is the
    first day of the year. *)
val is_first_day_of_year : t -> bool

(** [is_last_day_of_year d] returns [true] if the given date [d] is the
    last day of the year. *)
val is_last_day_of_year : t -> bool

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
