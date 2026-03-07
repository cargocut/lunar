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

(** And exception used for unsafe function. *)
exception Invalid_time of error

(** {1 Building time} *)

(** [make ~hour ~min ~sec ()] create and validate a time. *)
val make : hour:int -> min:int -> sec:int -> unit -> (t, error) result

(** [make_exn ~hour ~min ~sec ()] create and validate a time, like
    {!val:make} but raise [Invalid_time] if the validation doesn't
    succeed. *)
val make_exn : hour:int -> min:int -> sec:int -> unit -> t

(** [from_duration d] returns a [time] representation for the given
    duration [d]. *)
val from_duration : Duration.t -> t

(** [midnight] is [00:00:00]. *)
val midnight : t

(** [noon] is [12:00:00]. *)
val noon : t

(** [end_of_day] is [23:59:59]. *)
val end_of_day : t

(** [am h] is a safe builder (using [mod]) to build an hour. *)
val am : int -> t

(** [pm h] is a safe builder (using [mod]) to build an hour. *)
val pm : int -> t

(** There is a confusion for the [am/pm] system
    ({{:https://en.wikipedia.org/wiki/12-hour_clock#Confusion_at_noon_and_midnight}
    see}). In Lunar, [am] is between [00:00:00] and [11:59:59] and
    [pm] is between [12:00:00] and [23:59:59]. *)

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

(** [succ t] is [add_seconds 1]. *)
val succ : t -> t

(** [pred t] is [sub_seconds 1]. *)
val pred : t -> t

(** {1 Round and truncate} *)

(** [truncate resolution t] truncates [t] to the previous multiple of
    [resolution].

    All units smaller than [resolution] are discarded.

    Examples:
    - [truncate (Duration.from_minutes 1) 12:34:56] = [12:34:00]
    - [truncate (Duration.from_hours 1) 12:34:56] = [12:00:00]. *)
val truncate : Duration.t -> t -> t

(** [round resolution t] rounds [t] to the nearest multiple of
    [resolution].

    If [t] lies exactly halfway between two multiples of [resolution],
    it is rounded up to the next multiple.

    Examples:
    - [round (Duration.from_minutes 1) 12:34:29] = [12:34:00]
    - [round (Duration.from_minutes 1) 12:34:30] = [12:35:00]
    - [round (Duration.from_hours 1) 12:29:59] = [12:00:00]
    - [round (Duration.from_hours 1) 12:30:00] = [13:00:00]. *)
val round : Duration.t -> t -> t

(** {1 Comparison} *)

(** Equality between times. *)
val equal : t -> t -> bool

(** [compare a b] comparison between times, following OCaml convention. *)
val compare : t -> t -> int

(** [min a b] returns the smaller of two arguments. *)
val min : t -> t -> t

(** [max a b] returns the greater of two arguments. *)
val max : t -> t -> t

(** {1 Predicates} *)

(** [is_earlier ~than t] returns [true] if [t] is (strictly) earlier than
    [than], [false] otherwise. *)
val is_earlier : than:t -> t -> bool

(** [is_later ~than t] returns [true] if [t] is (strictly) later than
    [than], [false] otherwise. *)
val is_later : than:t -> t -> bool

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

  (** [t1 = t2] is [equal t1 t2]. *)
  val ( = ) : t -> t -> bool

  (** [t1 <> t2] is [not (equal t1 t2)]. *)
  val ( <> ) : t -> t -> bool

  (** [t1 > t2] returns [true] if [t1] is greater than [t2]. *)
  val ( > ) : t -> t -> bool

  (** [t1 >= t2] returns [true] if [t1] is greater or equal to [t2]. *)
  val ( >= ) : t -> t -> bool

  (** [t1 < t2] returns [true] if [t2] is greater than [t1]. *)
  val ( < ) : t -> t -> bool

  (** [t1 <= t2] returns [true] if [t2] is greater or equal to [t1]. *)
  val ( <= ) : t -> t -> bool
end

include module type of Infix
