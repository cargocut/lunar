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

  (** A range has no concept of an iterator; it is simply characterized by a
      first and a last element. An iterator, therefore, is a pair of
      functions for moving from one {!type:elt} to another ([pred] and
      [succ], respectively). *)
  type iterator

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
      otherwise. Singleton ranges are both ascending and descending. *)
  val is_ascending : t -> bool

  (** [is_descending r] returns [true] if [last r <= first r ], [false]
      otherwise. Singleton ranges are both ascending and descending. *)
  val is_descending : t -> bool

  (** [is_singleton] returns [true] if [last = first]. *)
  val is_singleton : t -> bool

  (** [min_elt r] returns the smallest [elt] for the given range [r]. *)
  val min_elt : t -> elt

  (** [max_elt r] returns the greatest [elt] for the given range [r]. *)
  val max_elt : t -> elt

  (**  [bounds r] is [min_elt r, max_elt r]. *)
  val bounds : t -> elt * elt

  (** [contains elt r] returns [true] if the given element [elt] is included
      in the range [r]. *)
  val contains : elt -> t -> bool

  (** [mem] is an alias for {!val:contains}. *)
  val mem : elt -> t -> bool

  (** {1 Modifying Ranges} *)

  (** [rev r] swaps the endpoints of [r]. *)
  val rev : t -> t

  (** [sort r] sorts the range [r] in ascending order. *)
  val sort : t -> t

  (** {1 Equalities}

      The concept of comparing ranges is ambiguous, which is why the API only
      exposes range equality operations. *)

  (** [equal a b] returns [true] if [a] and [b] have the same
      first and last elements. *)
  val equal : t -> t -> bool

  (** {1 Relations between ranges} *)

  (** [overlaps r1 r2] returns [true] if the two ranges share
      at least one common element. *)
  val overlaps : t -> t -> bool

  (** [disjoint r1 r2] returns [true] if [r1] and [r2]
      share no common element. *)
  val disjoint : t -> t -> bool

  (** [includes parent child] returns [true] if every element of
      [child] is contained in [parent]. *)
  val includes : t -> t -> bool

  (** {1 Operation on ranges} *)

  (** [shift f r] moves the entire range forward (or backward) by performing
      [f] on [first_elt] and [last_elt]. *)
  val shift : (elt -> elt) -> t -> t

  (** [map f r] is [shift f r]. (See {!val:shift}) *)
  val map : (elt -> elt) -> t -> t

  (** [span ra rb] returns the smallest ascending range that contains both
      [ra] and [rb]. The resulting range will always be ascending. *)
  val span : t -> t -> t

  (** [intersection a b] returns the common portion of [a] and [b],
      or [None] if they are disjoint.

      The result is always ascending. *)
  val intersection : t -> t -> t option

  (** [clamp ~within r] restricts [r] to the bounds of [within]. (An alias
      of {!val:intersection}). *)
  val clamp : within:t -> t -> t option

  (** {1 Iterators}

      Ranges only capture endpoints. Therefore, enumerating the
      possible values of an interval comes into play only later. *)

  (** [iterator ~pred ~succ] creates an iterator with a pair of functions
      [pred], [succ]. *)
  val iterator : pred:(elt -> elt) -> succ:(elt -> elt) -> iterator

  (** The following functions include an [include_boundaries]
      parameter. This is primarily because iterators can {i skip}
      the last element of an iteration. For example, suppose we
      have a range of dates and decide to iterate over two
      days. It is possible that the last element will be
      skipped. The [include_boundaries] parameter always includes
      the last element in iterations (and defaults to [true]). *)

  (**  [fold_left ?include_boundaries ~iterator f acc range] folds over the
       elements of [range] from the first element to the last element,
       applying [f] to each element and an accumulator [acc]. The
       order of iteration respects the range direction: if the range
       is descending, elements are traversed from first to last in
       descending order.

       - [iterator] must provide a [succ] and [pred] function for moving between
         elements.
       - [include_boundaries] (default [true]) controls whether the last element
         is included if the iterator would overshoot the end.
       - [f] is applied to each element and the current accumulator, returning a
         new accumulator. *)
  val fold_left
    :  ?include_boundaries:bool
    -> iterator:iterator
    -> (elt -> 'acc -> 'acc)
    -> 'acc
    -> t
    -> 'acc

  (** [fold_right ?include_boundaries ~iterator f acc range] is
      {!val:fold_left} but starting from the last element and going
      back to the first. It's basically [fold_left] on [rev range].*)
  val fold_right
    :  ?include_boundaries:bool
    -> iterator:iterator
    -> (elt -> 'acc -> 'acc)
    -> 'acc
    -> t
    -> 'acc

  (** [length ?include_boundaries ~iterator range] calculates the size of a
      range. *)
  val length : ?include_boundaries:bool -> iterator:iterator -> t -> int

  (** [iter ?include_boundaries ~iterator f range] apply [f] on every element of
      the given [range]. *)
  val iter
    :  ?include_boundaries:bool
    -> iterator:iterator
    -> (elt -> unit)
    -> t
    -> unit

  (** [to_list ?include_boundaries ~iterator range] converts the [range]
      into a list. *)
  val to_list : ?include_boundaries:bool -> iterator:iterator -> t -> elt list

  (** [to_seq ?include_boundaries ~iterator range] converts the [range]
      into a seq. *)
  val to_seq : ?include_boundaries:bool -> iterator:iterator -> t -> elt Seq.t

  (** {1 Infix Operators} *)

  module Infix : sig
    (** Common and useful infix operators. *)

    include EQUATABLE_INFIX with type t := t (** @inline *)
  end

  include module type of Infix
end
