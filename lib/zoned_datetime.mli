(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(**  A {!type:Datetime.t} associated with a {!type:Timezone.t}.

     Internally stored as a UTC datetime with an associated timezone offset.

     The concept behind a zone-based datetime can be explained as follows:
     A datetime (expressed in local time) is associated with a time zone, and
     the APIs as a whole allow the internal resolution to be hidden. *)

(** {1 Types} *)

(** The type describing a Zoned Datetime. *)
type t

(** {1 Building zoned datetime} *)

(** [from_local_datetime ?tz dt] attach a timezone to a regular
    {!type:Datetime.t}. The default Timezone [tz] is
    {!val:Timezone.utc}. *)
val from_local_datetime : ?tz:Timezone.t -> Datetime.t -> t

(** [make ?tz ?at ~year ~month ~day ()] create and validate a zoned
    datetime. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.make} *)
val make
  :  ?tz:Timezone.t
  -> ?at:int * int * int
  -> year:int
  -> month:Month.t
  -> day:int
  -> unit
  -> (t, Datetime.error) result

(** [make' ?at ~year ~month ~day ()] create and validate a zoned
    datetime. see {!val:make}. Take an integer rather than a
    {!type:Month.t}. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.make'} *)
val make'
  :  ?tz:Timezone.t
  -> ?at:int * int * int
  -> year:int
  -> month:int
  -> day:int
  -> unit
  -> (t, Datetime.error) result

(** [make_exn ?at ~year ~month ~day ()] create and validate a datetime
    like {!val:make} but raise [Invalid_datetime] if the validation
    doesn't succeed. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.make_exn} *)
val make_exn
  :  ?tz:Timezone.t
  -> ?at:int * int * int
  -> year:int
  -> month:Month.t
  -> day:int
  -> unit
  -> t

(** [make_exn' ?at ~year ~month ~day ()] create and validate a zoned datetime,
    like {!val:make'} but raise [Invalid_datetime] if the validation doesn't
    succeed. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.make_exn'} *)
val make_exn'
  :  ?tz:Timezone.t
  -> ?at:int * int * int
  -> year:int
  -> month:int
  -> day:int
  -> unit
  -> t

(** [from d t] creates a zoned datetime object for the given date, [d] and a
    given time [t]. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.from} *)
val from : ?tz:Timezone.t -> Date.t -> Time.t -> t

(** [from_date d] creates a zoned datetime object for the given date, [d], at
    midnight. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.from_date} *)
val from_date : ?tz:Timezone.t -> Date.t -> t

(** [from_duration d] converts a duration to a date.  [0] is the
    1970-01-01 at 00:00:00. The default Timezone [tz] is
    {!val:Timezone.utc}.

    See {!val:Datetime.from_duration} *)
val from_duration : ?tz:Timezone.t -> Duration.t -> t

(** [from_utc dt] creates a zoned datetime from an UTC datetime (does
    not any conversion). *)
val from_utc : Datetime.t -> t

(** Returns the 1st January 1970 at midnight. The default Timezone [tz] is
    {!val:Timezone.utc}.

    See {!val:Datetime.epoch} *)
val epoch : ?tz:Timezone.t -> unit -> t

(** {1 Accessors and component lenses} *)

(** [timezone zdt] returns the attached timezone to the given [zdt]. *)
val timezone : t -> Timezone.t

(** [on_utc f zdt] apply [f] on the datetime (in UTC) of [zdt]. *)
val on_utc : (Datetime.t -> 'a) -> t -> 'a

(** [on_local f zdt] apply [f] on the local datetime of [zdt]. *)
val on_local : (Datetime.t -> 'a) -> t -> 'a

(** [map_utc f zdt] applies [f] to the underlying UTC datetime.

    This transforms the absolute instant while preserving the timezone. *)
val map_utc : (Datetime.t -> Datetime.t) -> t -> t

(** [map_local f zdt] applies [f] to the underlying local datetime.

    This transforms the relative instant while preserving the timezone. *)
val map_local : (Datetime.t -> Datetime.t) -> t -> t

(** {1 Time conversion} *)

(** [to_utc zdt] returns a date in UTC format (subtracting the time zone
    offset) *)
val to_utc : t -> Datetime.t

(** [to_zoned_utc zdt] returns a zoned datetime expressed in UTC.

    This keeps the same instant but changes the timezone to UTC.
    Equivalent to {!val:change_timezone} with {!val:Timezone.utc}. *)
val to_zoned_utc : t -> t

(** [to_local_datetime zdt] returns the date with the time zone offset
    applied. *)
val to_local_datetime : t -> Datetime.t

(** [to_datetime ~tz zdt] displays the datetime using the specified time
    zone [tz]. *)
val to_datetime : tz:Timezone.t -> t -> Datetime.t

(** [change_timezone ~tz zdt] changes the timezone of the given [zdt] by
    [tz]. *)
val change_timezone : tz:Timezone.t -> t -> t

(** {1 Operation on zoned datetimes} *)

(** [add duration zdt] compute a new date adding [duration] to the given
    [zdt]. *)
val add : Duration.t -> t -> t

(** [sub duration zdt] compute a new date substracting [duration] to the given
    [zdt]. *)
val sub : Duration.t -> t -> t

(** [add_seconds number_of_seconds zoned_datetime] add [number_of_seconds] to the
    given [zoned_datetime]. *)
val add_seconds : int -> t -> t

(** [sub_seconds number_of_seconds zoned_datetime] remove [number_of_seconds] to the
    given [zoned_datetime]. *)
val sub_seconds : int -> t -> t

(** [add_minutes number_of_minutes zoned_datetime] add [number_of_minutes] to the
    given [zoned_datetime]. *)
val add_minutes : int -> t -> t

(** [sub_minutes number_of_minutes zoned_datetime] remove [number_of_minutes] to the
    given [zoned_datetime]. *)
val sub_minutes : int -> t -> t

(** [add_hours number_of_hours zoned_datetime] add [number_of_hours] to the
    given [zoned_datetime]. *)
val add_hours : int -> t -> t

(** [sub_hours number_of_hours zoned_datetime] remove [number_of_hours] to the
    given [datime]. *)
val sub_hours : int -> t -> t

(** [add_days number_of_days zoned_datetime] add [number_of_days] to the given
    [zoned_datetime]. *)
val add_days : int -> t -> t

(** [sub_days number_of_days zoned_datetime] remove [number_of_days] to the
    given [zoned_datetime]. *)
val sub_days : int -> t -> t

(** [add_weeks number_of_weeks zoned_datetime] add [number_of_weeks] to the
    given [zoned_datetime] (a week is [7] days). *)
val add_weeks : int -> t -> t

(** [sub_weeks number_of_weeks zoned_datetime] remove [number_of_weeks] to the
    given [zoned_datetime] (a week is [7] days). *)
val sub_weeks : int -> t -> t

(** [add_months number_of_months zoned_datetime] add [number_of_months] to the
    given [zoned_datetime]. *)
val add_months : int -> t -> t

(** [add_months number_of_months zoned_datetime] remove [number_of_months] to
    the given [zoned_datetime]. *)
val sub_months : int -> t -> t

(** [add_quarters number_of_quarters zoned_datetime] add [number_of_quarters] to the
    given [zoned_datetime]. *)
val add_quarters : int -> t -> t

(** [add_quarters number_of_quarters zoned_datetime] remove [number_of_quarters] to
    the given [zoned_datetime]. *)
val sub_quarters : int -> t -> t

(** [add_years number_of_years zoned_datetime] add [number_of_years] to the
    given [zoned_datetime]. *)
val add_years : int -> t -> t

(** [sub_years number_of_years zoned_datetime] remove [number_of_years] to the
    given [zoned_datetime]. *)
val sub_years : int -> t -> t

(** [diff d1 d2] returns the difference (in {!type:Duration.t}) between
    [d1] and [d2]. *)
val diff : t -> t -> Duration.t

(** {2 Succ and Pred}

    The main difference between the [add]/[sub] and [succ]/[pred] operations
    lies in how the result is truncated. [add] and [sub] are standard
    arithmetic operations: you add or subtract a duration.
    [succ] and [pred], on the other hand, calculate the next zoned datetime step.
    See {!val:Time.succ} and {!val:Date.succ}. *)

(** [succ zdt] is [add_seconds 1]. *)
val succ : t -> t

(** [pred zdt] is [sub_seconds 1]. *)
val pred : t -> t

(** [succ_second zdt] returns the zoned datetime at the next second. See
    {!val:succ}. *)
val succ_second : t -> t

(** [pred_second zdt] returns the zoned datetime at the previous
    second. See {!val:pred}. *)
val pred_second : t -> t

(** [succ_minute zdt] returns the zoned datetime at the next minute. *)
val succ_minute : t -> t

(** [pred_minute t] returns the zoned datetime at the previous minute. *)
val pred_minute : t -> t

(** [succ_hour t] returns the zoned datetime at the next hour. *)
val succ_hour : t -> t

(** [pred_hour t] returns the zoned datetime at the previous hour. *)
val pred_hour : t -> t

(** [succ_day ?where:pred from] returns the first following zoned datetime
    that satisfies the predicate [pred] starting from the date [from]
    (exclusive). {b Note}: If the predicate always returns [false],
    the function never terminates. *)
val succ_day : ?where:(Date.t -> bool) -> t -> t

(** [pred_day ~where:pred from] returns the first previous zoned datetime
    that satisfies the predicate [pred] starting from the date [from]
    (exclusive). {b Note}: If the predicate always returns [false],
    the function never terminates. *)
val pred_day : ?where:(Date.t -> bool) -> t -> t

(** [succ_day_of_week weekday from] returns the first following zoned
    datetime corresponding to the specified day of the week. *)
val succ_day_of_week : Weekday.t -> t -> t

(** [pred_day_of_week weekday from] returns the first previous zoned
    datetime corresponding to the specified day of the week. *)
val pred_day_of_week : Weekday.t -> t -> t

(** [succ_weekday from] returns the first following day of week (not
    weekend). *)
val succ_weekday : t -> t

(** [pred_weekday from] returns the first previous day of week (not
    weekend). *)
val pred_weekday : t -> t

(** [succ_week zdt] returns the first day of the next week. *)
val succ_week : ?week_start:Weekday.t -> t -> t

(** [pred_week zdt] returns the first day of the previous week. *)
val pred_week : ?week_start:Weekday.t -> t -> t

(** [succ_month zdt] returns the first day of the next month. *)
val succ_month : t -> t

(** [pred_month zdt] returns the first day of the previous month. *)
val pred_month : t -> t

(** [succ_quarter zdt] returns the first day of the next quarter. *)
val succ_quarter : t -> t

(** [pred_quarter zdt] returns the first day of the previous quarter. *)
val pred_quarter : t -> t

(** [succ_year zdt] returns the first day of the next year. *)
val succ_year : t -> t

(** [pred_year zdt] returns the first day of the previous year. *)
val pred_year : t -> t

(** {1 Common Operations}

    Most of the operations involve the local representation of the zoned date.
*)

(** [with_local_time t zdt] sets the local time component.

    This changes the underlying instant so that the resulting local
    datetime has the given time. *)
val with_local_time : Time.t -> t -> t

(** [with_local_date date zoned_datetime] replace the [date] of the given
    [zoned_datetime].

    This changes the underlying instant so that the resulting local
    datetime has the given time. *)
val with_local_date : Date.t -> t -> t

(** [tomorrow zdt] get the next day of the given [zdt]. See
    {!val:succ_day}. *)
val tomorrow : t -> t

(** [yesterday zdt] get the previous day of the given [zdt]. See
    {!val:pred_day}. *)
val yesterday : t -> t

(** [start_of_minute zdt] returns the zoned datetime at the start of the
    current minute. *)
val start_of_minute : t -> t

(** [end_of_minute zdt] returns the zoned datetime at the end of the current
    minute. *)
val end_of_minute : t -> t

(** [start_of_hour zdt] returns the zoned datetime at the start of the current
    hour. *)
val start_of_hour : t -> t

(** [end_of_hour zdt] returns the zoned datetime at the end of the current
    hour. *)
val end_of_hour : t -> t

(** [start_of_day zdt] Returns a zoned datetime set to the start of the
    day (midnight). *)
val start_of_day : t -> t

(** [end_of_day zdt] Returns a zoned datetime set to the end of the day
    (23:59:59). *)
val end_of_day : t -> t

(** [start_of_morning zdt] returns the zoned datetime at 05:00:00. *)
val start_of_morning : t -> t

(** [end_of_morning zdt] returns the zoned datetime at 11:59:59. *)
val end_of_morning : t -> t

(** [start_of_afternoon zdt] returns the zoned datetime at 12:00:00. *)
val start_of_afternoon : t -> t

(** [at_noon] is {!val:start_of_afternoon}. *)
val at_noon : t -> t

(** [end_of_afternoon zdt] returns the zoned datetime at 16:59:59. *)
val end_of_afternoon : t -> t

(** [start_of_evening zdt] returns the zoned datetime at 17:00:00. *)
val start_of_evening : t -> t

(** [end_of_evening zdt] returns the zoned datetime at 20:59:59. *)
val end_of_evening : t -> t

(** [start_of_night zdt] returns the zoned datetime at 21:00:00. *)
val start_of_night : t -> t

(** [end_of_night zdt] returns the zoned datetime at 04:59:59. *)
val end_of_night : t -> t

(** [start_of_week ?week_start zdt] Returns the first day of the week
    (defined by [week_start]; default: Monday). *)
val start_of_week : ?week_start:Weekday.t -> t -> t

(** [end_of_week ?week_start zdt] Returns the last day of the week
    (defined by [week_start - 1]; default: Monday). *)
val end_of_week : ?week_start:Weekday.t -> t -> t

(** [start_of_month zdt] returns the first day of the month of the given
    zoned datetime [zdt]. *)
val start_of_month : t -> t

(** [end_of_month zdt] returns the last day of the month of the given
    zoned datetime [zdt]. *)
val end_of_month : t -> t

(** [start_of_quarter zdt] returns the first day of the quarter of the given
    zoned datetime [zdt]. *)
val start_of_quarter : t -> t

(** [end_of_quarter zdt] returns the last day of the quarter of the given
    zoned datetime [zdt]. *)
val end_of_quarter : t -> t

(** [start_of_year zdt] returns the first day of the year of the given
    zoned datetime [d]. *)
val start_of_year : t -> t

(** [end_of_year zdt] returns the last day of the year of the given
    zoned datetime [zdt]. *)
val end_of_year : t -> t

(** [age ~birthday current] returns the age calculated from [birthday]
    using the given zoned datetime [current] as the current date. *)
val age : birthday:Date.t -> t -> int

(** {1 Round and truncate}

    A negative duration can produce very strange results, which is
    why durations are converted to absolute values in rounding functions. *)

(** [truncate resolution d] truncates [d] to the beginning of the period
    specified by [resolution]. See {!val:Datetime.truncate} and
    {!val:Time.truncate}.

    All units smaller than [resolution] are discarded. *)
val truncate : [< Resolution.t ] -> t -> t

(** [floor resolution d] is [truncate resolution d]. *)
val floor : [< Resolution.t ] -> t -> t

(** [round resolution d] rounds [d] to the nearest boundary of the period
    specified by [resolution]. See {!val:Datetime.round} and
    {!val:Timetime.round}. *)
val round : [< Resolution.t ] -> t -> t

(** [ceil resolution d] rounds [d] up to the next boundary of the period
    specified by [resolution]. If [d] is already aligned with
    [resolution], it is returned unchanged. See {!val:Datetime.ceil}
    and {!val:Time.ceil}. *)
val ceil : [< Resolution.t ] -> t -> t

(** {1 Comparison} *)

(** Equality between dates. *)
val equal : t -> t -> bool

(** [compare a b] comparison between dates, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Conversion} *)

(** [to_string zdt] returns a string representation of the given [zdt]
    (using the RFC {{:https://datatracker.ietf.org/doc/html/rfc3339}
    ISO 8601}). *)
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
