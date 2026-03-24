(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Represents a Zoned Datetime. A {!type:Date.t} associated with a
    {!type:Time.t} and a {!type:Timezone.t}.

    The concept behind a zone-based datetime can be explained as follows:
    A datetime (expressed in local time) is associated with a time zone, and
    the APIs as a whole allow the internal resolution to be hidden. *)

(** {1 Types} *)

(** The type describing a Zoned Datetime. *)
type t

(** {1 Building zoned datetime} *)

(** [from_datetime ?tz dt] attach a timezone to a regular
    {!type:Datetime.t}. The default Timezone [tz] is
    {!val:Timezone.utc}. *)
val from_datetime : ?tz:Timezone.t -> Datetime.t -> t

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

(** [from_date d] creates a datetime object for the given date, [d], at
    midnight. The default Timezone [tz] is {!val:Timezone.utc}.

    See {!val:Datetime.from_date} *)
val from_date : ?tz:Timezone.t -> Date.t -> t

(** [from_duration d] converts a duration to a date.  [0] is the
    1970-01-01 at 00:00:00. The default Timezone [tz] is
    {!val:Timezone.utc}.

    See {!val:Datetime.from_duration} *)
val from_duration : ?tz:Timezone.t -> Duration.t -> t

(** Returns the 1st January 1970 at midnight. The default Timezone [tz] is
    {!val:Timezone.utc}.

    See {!val:Datetime.epoch} *)
val epoch : ?tz:Timezone.t -> unit -> t

(** {1 Time conversion} *)

(** [to_utc zdt] returns a date in UTC format (subtracting the time zone
    offset) *)
val to_utc : t -> Datetime.t

(** {1 Comparison} *)

(** Equality between dates. *)
val equal : t -> t -> bool

(** [compare a b] comparison between dates, following OCaml convention. *)
val compare : t -> t -> int

include Sigs.COMPARABLE_HELPERS with type t := t (** @inline *)

(** {1 Conversion} *)

(** [to_string dt] returns a string representation of the given [dt]. *)
val to_string : t -> string

(** {1 Infix Operators} *)

module Infix : sig
  (** Common and useful infix operators. *)

  include Sigs.EQUATABLE_INFIX with type t := t (** @inline *)

  include Sigs.COMPARABLE_INFIX with type t := t (** @inline *)
end

include module type of Infix
