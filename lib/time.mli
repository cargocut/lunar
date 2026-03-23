(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Represents a time from [00:00:00] to [23:59:59]. *)

(** {1 Types} *)

(** The type describing a Time. *)
type t

(** Type listing errors that may occur when working with time. *)
type error =
  | Invalid_hour of int
  | Invalid_minute of int
  | Invalid_second of int
  | Invalid_string of string

(** An exception used for unsafe function. *)
exception Invalid_time of error

(** {1 Building time} *)

(** [make ~hour ~min ~sec ()] create and validate a time. *)
val make : hour:int -> min:int -> sec:int -> unit -> (t, error) result

(** [make_exn ~hour ~min ~sec ()] create and validate a time, like
    {!val:make} but raise [Invalid_time] if the validation doesn't
    succeed. *)
val make_exn : hour:int -> min:int -> sec:int -> unit -> t

(** [from_string s] try to read a time from a string. *)
val from_string : string -> (t, error) result

(** [from_string_exn s] try to read a time from a string and raise and exception
    if it fails *)
val from_string_exn : string -> t

(** [from_duration d] returns a [time] representation for the given
    duration [d]. *)
val from_duration : Duration.t -> t

(** [midnight] is [00:00:00]. *)
val midnight : t

(** [start_of_day] is {!val:midnight}. *)
val start_of_day : t

(** [noon] is [12:00:00]. *)
val noon : t

(** [end_of_day] is [23:59:59]. *)
val end_of_day : t

(** [start_of_morning] is [05:00:00] *)
val start_of_morning : t

(** [end_of_morning] is [11:59:59] *)
val end_of_morning : t

(** [start_of_afternoon] is {!val:noon}. *)
val start_of_afternoon : t

(** [end_of_afternoon] is [16:59:59] *)
val end_of_afternoon : t

(** [start_of_evening] is [17:00:00] *)
val start_of_evening : t

(** [end_of_evening] is [20:59:59] *)
val end_of_evening : t

(** [start_of_night] is [21:00:00] *)
val start_of_night : t

(** [end_of_night] is [04:59:59] *)
val end_of_night : t

(** [am h] is a safe builder (using [mod]) to build an hour. *)
val am : int -> t

(** [pm h] is a safe builder (using [mod]) to build an hour. *)
val pm : int -> t

(** There is a confusion for the [am/pm] system
    ({{:https://en.wikipedia.org/wiki/12-hour_clock#Confusion_at_noon_and_midnight}
    see}). In Lunar, [am] is between [00:00:00] and [11:59:59] and
    [pm] is between [12:00:00] and [23:59:59]. *)

(** {1 Accessors}

    Information and facts about Time. *)

(** [hour t] returns the hour. *)
val hour : t -> int

(** [hour t] returns the minute. *)
val minute : t -> int

(** [hour t] returns the second. *)
val second : t -> int

(** {1 Conversion} *)

(** [to_duration t] converts the given time [t] to a duration. *)
val to_duration : t -> Duration.t

(** [to_string t] returns a string representation of the given time [t]. *)
val to_string : t -> string

(** {1 Operation on times} *)

(** [add duration time] compute a new time adding [duration] to the given
    [time]. *)
val add : Duration.t -> t -> t

(** [sub duration time] compute a new time removing [duration] to the
    given [time]. *)
val sub : Duration.t -> t -> t

(** [add_seconds number_of_seconds time] add [number_of_seconds] to the
    given [time]. *)
val add_seconds : int -> t -> t

(** [sub_seconds number_of_seconds time] remove [number_of_seconds] to the
    given [time]. *)
val sub_seconds : int -> t -> t

(** [add_minutes number_of_minutes time] add [number_of_minutes] to the
    given [time]. *)
val add_minutes : int -> t -> t

(** [sub_minutes number_of_minutes time] remove [number_of_minutes] to the
    given [time]. *)
val sub_minutes : int -> t -> t

(** [add_hours number_of_hours time] add [number_of_hours] to the
    given [time]. *)
val add_hours : int -> t -> t

(** [sub_hours number_of_hours time] remove [number_of_hours] to the
    given [time]. *)
val sub_hours : int -> t -> t

(** [diff d1 d2] returns the difference (in {!type:Duration.t}) between
    [d1] and [d2]. *)
val diff : t -> t -> Duration.t

(** {2 Succ and Pred}

    The main difference between the [add]/[sub] and [succ]/[pred] operations
    lies in how the result is truncated. [add] and [sub] are standard
    arithmetic operations: you add or subtract a duration.
    [succ] and [pred], on the other hand, calculate the next time step.
    For example let's imagine the following time:

    {eof@ocaml[
      let a_time = Lunar.Time.make_exn ~hour:12 ~min:34 ~sec:51 ()
    ]eof}

    Adding one minute will preserve [sec 51]:

    {@ocaml[
      # a_time |> Lunar.Time.add_minutes 1  |> Lunar.Time.to_string ;;
      - : string = "12:35:51"
    ]}

    But going {b to the next minute} :

    {@ocaml[
      # a_time |> Lunar.Time.succ_minute  |> Lunar.Time.to_string ;;
      - : string = "12:35:00"
    ]} *)

(** [succ t] is [add_seconds 1]. *)
val succ : t -> t

(** [pred t] is [sub_seconds 1]. *)
val pred : t -> t

(** [succ_second t] returns the time at the next second. See {!val:succ}. *)
val succ_second : t -> t

(** [pred_second t] returns the time at the previous second. See
    {!val:pred}. *)
val pred_second : t -> t

(** [succ_minute t] returns the time at the next minute. *)
val succ_minute : t -> t

(** [pred_minute t] returns the time at the previous minute. *)
val pred_minute : t -> t

(** [succ_hour t] returns the time at the next hour. *)
val succ_hour : t -> t

(** [pred_hour t] returns the time at the previous hour. *)
val pred_hour : t -> t

(** [start_of_minute t] returns the time at the start of the current
    minute. *)
val start_of_minute : t -> t

(** [end_of_minute t] returns the time at the end of the current
    minute. *)
val end_of_minute : t -> t

(** [start_of_hour t] returns the time at the start of the current
    hour. *)
val start_of_hour : t -> t

(** [end_of_hour t] returns the time at the end of the current
    hour. *)
val end_of_hour : t -> t

(** {1 Round and truncate}

    A negative duration can produce very strange results, which is
    why durations are converted to absolute values in rounding functions. *)

(** [truncate resolution t] truncates [t] to the previous multiple of
    [resolution].

    All units smaller than [resolution] are discarded.

    Examples:
    - [truncate (Resolution.from_minutes 1) 12:34:56] = [12:34:00]
    - [truncate (Resolution.from_hours 1) 12:34:56] = [12:00:00]. *)
val truncate : [> Resolution.for_time ] -> t -> t

(** [floor d t] is [truncate d t]. *)
val floor : [> Resolution.for_time ] -> t -> t

(** [round resolution t] rounds [t] to the nearest multiple of
    [resolution].

    If [t] lies exactly halfway between two multiples of [resolution],
    it is rounded up to the next multiple.

    Examples:
    - [round (Resolution.from_minutes 1) 12:34:29] = [12:34:00]
    - [round (Resolution..from_minutes 1) 12:34:30] = [12:35:00]
    - [round (Resolution.from_hours 1) 12:29:59] = [12:00:00]
    - [round (Resolution.from_hours 1) 12:30:00] = [13:00:00]. *)
val round : [> Resolution.for_time ] -> t -> t

(** [ceil resolution t] rounds the given [time] [t] up to the nearest multiple of
    [resolution]. If [t] is already aligned with [resolution], it is returned
    unchanged.

    All units smaller than [resolution] are discarded unless rounding up
    requires incrementing a larger unit.

    Examples:
    - [ceil (Resolution.from_minutes 1) 12:34:00] = [12:34:00]
    - [ceil (Resolution.from_minutes 1) 12:34:01] = [12:35:00]
    - [ceil (Resolution.from_hours 1) 12:00:00] = [12:00:00]
    - [ceil (Resolution.from_hours 1) 12:01:00] = [13:00:00]. *)
val ceil : [> Resolution.for_time ] -> t -> t

(** {1 Comparison} *)

(** Equality between times. *)
val equal : t -> t -> bool

(** [compare a b] comparison between times, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Predicates} *)

(** [is_am t] returns [true] if [t] is between [00:00:00] and [11:59:59],
    [false] otherwise. *)
val is_am : t -> bool

(** [is_pm t] returns [true] if [t] is between [12:00:00] and [23:59:59],
    [false] otherwise. *)
val is_pm : t -> bool

(** [is_noon t] returns [true] if [t] is exactly [12:00:00], [false]
    otherwise. *)
val is_noon : t -> bool

(** [is_midnight t] returns [true] if [t] is exactly [00:00:00], [false]
    otherwise. *)
val is_midnight : t -> bool

(** [is_morning t] returns [true] if [t] is between [05:00:00] and
    [11:59:59], [false] otherwise. *)
val is_morning : t -> bool

(** [is_afternoon t] returns [true] if [t] is between [12:00:00] and
    [16:59:59], [false] otherwise. *)
val is_afternoon : t -> bool

(** [is_evening t] returns [true] if [t] is between [17:00:00] and
    [20:59:59], [false] otherwise. *)
val is_evening : t -> bool

(** [is_night t] returns [true] if [t] is between [21:00:00] and
    [04:59:59], [false] otherwise. *)
val is_night : t -> bool

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  (** [t + dur] is {!val:add} *)
  val ( + ) : t -> Duration.t -> t

  (** [t - dur] is {!val:sub} *)
  val ( - ) : t -> Duration.t -> t

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
