(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t

val from_int64 : int64 -> t
val of_int64 : int64 -> t
val from_seconds : int -> t
val from_minutes : int -> t
val from_hours : int -> t
val from_days : int -> t

val from_datetime
  :  year:int
  -> month:int
  -> day:int
  -> hour:int
  -> min:int
  -> sec:int
  -> t

val to_datetime : t -> int * int * int * int * int * int
val to_int64 : t -> int64
val compare : t -> t -> int
val equal : t -> t -> bool

module Infix : sig
  val ( + ) : t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> int -> t
  val ( = ) : t -> t -> bool
  val ( <> ) : t -> t -> bool
  val ( > ) : t -> t -> bool
  val ( >= ) : t -> t -> bool
  val ( < ) : t -> t -> bool
  val ( <= ) : t -> t -> bool
end

include module type of Infix
