(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

module type S = Sigs.RANGE

module Make (Comp : Sigs.COMPARABLE) = struct
  type elt = Comp.t

  (* NOTE: Since comparisons can be tricky without operators, we're
     providing a helper module. *)
  module Elt = struct
    let equal a b = Int.equal (Comp.compare a b) 0

    module E = struct
      type t = Comp.t

      let equal = equal
    end

    include Util.Make_compare_helpers (Comp)
    include Util.Make_compare_infix (Comp)
    include Util.Make_equal_infix (E)
  end

  type t =
    { first : elt
    ; last : elt
    }

  type iterator =
    { pred : elt -> elt
    ; succ : elt -> elt
    }

  let iterator ~pred ~succ = { pred; succ }

  let linear_iterator f x =
    let pred = f (-x)
    and succ = f x in
    iterator ~pred ~succ
  ;;

  let make ~first ~last = { first; last }
  let first_elt { first; _ } = first
  let last_elt { last; _ } = last
  let is_ascending r = Elt.(first_elt r <= last_elt r)
  let is_descending r = Elt.(first_elt r >= last_elt r)
  let is_singleton r = Elt.equal (first_elt r) (last_elt r)
  let min_elt r = if is_ascending r then first_elt r else last_elt r
  let max_elt r = if is_ascending r then last_elt r else first_elt r
  let bounds r = min_elt r, max_elt r
  let rev { first = last; last = first } = { first; last }
  let sort r = if not (is_ascending r) then rev r else r

  let equal a b =
    Elt.equal (first_elt a) (first_elt b) && Elt.equal (last_elt a) (last_elt b)
  ;;

  let contains x r =
    let a, b = bounds r in
    Elt.(x >= a && x <= b)
  ;;

  let mem = contains

  let overlaps ra rb =
    let min1, max1 = bounds ra in
    let min2, max2 = bounds rb in
    not Elt.(max1 < min2 || max2 < min1)
  ;;

  let disjoint ra rb = not (overlaps ra rb)

  let includes parent r =
    let f, l = bounds r in
    contains f parent && contains l parent
  ;;

  let shift f r =
    let first = f (first_elt r)
    and last = f (last_elt r) in
    make ~first ~last
  ;;

  let map = shift

  let span ra rb =
    let ma, mb = bounds ra
    and na, nb = bounds rb in
    let first = Elt.min ma na
    and last = Elt.max mb nb in
    make ~first ~last
  ;;

  let intersection ra rb =
    if not (overlaps ra rb)
    then None
    else (
      let amin, amax = bounds ra
      and bmin, bmax = bounds rb in
      let first = Elt.max amin bmin
      and last = Elt.min amax bmax in
      Some (make ~first ~last))
  ;;

  let clamp ~within r = intersection within r

  let fold_left
        ?(include_boundaries = true)
        ~iterator:{ succ; pred }
        f
        acc
        range
    =
    let curr = first_elt range in
    let last = last_elt range in
    let is_asc = is_ascending range in
    let next_fn = if is_asc then succ else pred in
    let rec aux curr acc =
      if Elt.equal curr last
      then f curr acc
      else (
        let next = next_fn curr in
        (* KLUDGE: stop if next overshoots last or wraps around (cycle) mostly
           for [time] reason *)
        if
          (is_asc && (Elt.(next > last) || Elt.(next <= curr)))
          || ((not is_asc) && (Elt.(next < last) || Elt.(next >= curr)))
        then if include_boundaries then f last (f curr acc) else f curr acc
        else aux next (f curr acc))
    in
    aux curr acc
  ;;

  let fold_right ?include_boundaries ~iterator f acc range =
    fold_left ?include_boundaries ~iterator f acc (rev range)
  ;;

  let length ?include_boundaries ~iterator =
    fold_left ?include_boundaries ~iterator (fun _ x -> x + 1) 0
  ;;

  let iter ?include_boundaries ~iterator f =
    fold_left ?include_boundaries ~iterator (fun curr () -> f curr) ()
  ;;

  let to_list ?include_boundaries ~iterator range =
    range |> fold_left ?include_boundaries ~iterator List.cons [] |> List.rev
  ;;

  let to_seq ?include_boundaries ~iterator range =
    range |> to_list ?include_boundaries ~iterator |> List.to_seq
  ;;

  module CE = struct
    type nonrec t = t

    let equal = equal
  end

  module Infix = struct
    include Util.Make_equal_infix (CE)
  end

  include Infix
end
