(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** Set of reusable signatures for sharing behaviors, among other things. *)

module type COMPARABLE = sig
  (** Comparison is very useful for describing, in particular, the set of
      infix comparison operators. *)

  type t

  val compare : t -> t -> int
end

module type EQUATABLE = sig
  (** Equality is very useful for describing, in particular, the set of
      infix equality operators. *)

  type t

  val equal : t -> t -> bool
end

module type COMPARABLE_HELPERS = sig
  (** Functions derived from comparison. *)

  type t

  (** [min a b] returns the smaller of two arguments. *)
  val min : t -> t -> t

  (** [max a b] returns the greater of two arguments. *)
  val max : t -> t -> t

  (** [clamp ~min ~max x] restricts the [x] to the inclusive interval
      [[min, max]]. *)
  val clamp : min:t -> max:t -> t -> t

  (** [is_earlier ~than x] returns [true] if [x] is (strictly) earlier than
      [than], [false] otherwise. *)
  val is_earlier : than:t -> t -> bool

  (** [is_later ~than x] returns [true] if [x] is (strictly) later than
      [than], [false] otherwise. *)
  val is_later : than:t -> t -> bool
end

module type COMPARABLE_INFIX = sig
  (** All operators derived from the comparison. *)

  type t

  (** [v1 > v2] returns [true] if [v1] is greater than [v2], [false]
      otherwise. *)
  val ( > ) : t -> t -> bool

  (** [v1 >= v2] returns [true] if [v1] is greater or equal to [v2], [false]
      otherwise. *)
  val ( >= ) : t -> t -> bool

  (** [v1 < v2] returns [true] if [v2] is greater than [v1], [false]
      otherwise. *)
  val ( < ) : t -> t -> bool

  (** [v1 <= v2] returns [true] if [v2] is greater or equal to [v1], [false]
      otherwise. *)
  val ( <= ) : t -> t -> bool
end

module type EQUATABLE_INFIX = sig
  (** All operators derived from equalities. *)

  type t

  (** [v1 = v2] is [equal v1 v2]. *)
  val ( = ) : t -> t -> bool

  (** [v1 <> v2] is [not (equal v1 v2)]. *)
  val ( <> ) : t -> t -> bool
end
