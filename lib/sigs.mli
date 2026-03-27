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

module type RANGE = sig
  (** Describes a range (an interval between two comparable elements). *)

  (** {1 Types} *)

  (** The type that describes the elements of a range. *)
  type elt

  (** The type describing a range. *)
  type t

  (** {1 Creating Range} *)

  (** [make ~first ~last] constructs a range with [first] as the first
      element and [last] as the last element.

      You'll notice that a range may not be in ascending order
      (hence the names [first] and [last]). *)
  val make : first:elt -> last:elt -> t

  (** {1 Facts about Range} *)

  (** [first_elt r] returns the first element of the range [r]. *)
  val first_elt : t -> elt

  (** [last_elt r] returns the last element of the range [r]. *)
  val last_elt : t -> elt

  (** [is_ascending r] returns [true] if [first r <= last r ], [false]
      otherwise. *)
  val is_ascending : t -> bool

  (** [is_descending r] returns [true] if [last r <= first r ], [false]
      otherwise. *)
  val is_descending : t -> bool

  (** [min_elt r] returns the smallest [elt] for the given range [r]. *)
  val min_elt : t -> elt

  (** [max_elt r] returns the greatest [elt] for the given range [r]. *)
  val max_elt : t -> elt

  (** [contains elt r] Returns [true] if the given element [elt] is included
      in the range [r]. *)
  val contains : elt -> t -> bool

  (** {1 Modifiying Ranges} *)

  (** [rev r] reverse the range [r] ([first_elt] become [last_elt] {i and
      vice-versa}). *)
  val rev : t -> t

  (** [sort r] sorts the range [r] in ascending order. *)
  val sort : t -> t

  (** {1 Equalities}

      The concept of comparing ranges is ambiguous, which is why the API only
      exposes range equality operations. *)

  (** [equal ra rb] equalities betweem [ra] and [rb]. *)
  val equal : t -> t -> bool

  (** {1 Relations between ranges} *)

  (** [overlaps r1 r2] returns [true] if the two ranges share
      at least one common date. *)
  val overlaps : t -> t -> bool

  (** {1 Infix Operators} *)

  module Infix : sig
    (** Common and useful infix operators. *)

    include EQUATABLE_INFIX with type t := t (** @inline *)
  end

  include module type of Infix
end
