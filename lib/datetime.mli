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

(** {1 Conversion} *)

(** [to_duration dt] returns a duration since {!val:epoch} for the given
    datetime [dt].*)
val to_duration : t -> Duration.t
