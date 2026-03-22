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
    {!val:make}. Take an integer rather than a {!val:Month.t}. *)
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

(** {1 Component lenses}

    A datetime is simply a pair consisting of a
    {!type:Date.t} and {!type:time.t}. *)

(** [to_pair dt] convert the given datetime [dt] into a pair of
    {!type:Date.t} and {!type:time.t} *)
val to_pair : t -> Date.t * Time.t

(** [date dt] returns the date part of the datetime. *)
val date : t -> Date.t

(** [time dt] returns the time part of the datetime. *)
val time : t -> Time.t

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

(** [succ t] is [add_seconds 1]. *)
val succ : t -> t

(** [pred t] is [sub_seconds 1]. *)
val pred : t -> t

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
