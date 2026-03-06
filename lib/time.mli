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

(** {1 Comparison} *)

(** Equality between times. *)
val equal : t -> t -> bool

(** [compare a b] comparison between times, following OCaml convention. *)
val compare : t -> t -> int

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
