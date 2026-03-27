(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

module Make (Comp : Sigs.COMPARABLE) = struct
  type elt = Comp.t

  (* NOTE: Since comparisons can be tricky without operators, we're
     providing a helper module. *)
  module Elt = struct
    module E = struct
      type t = Comp.t

      let equal a b = Int.equal (Comp.compare a b) 0
    end

    include Util.Make_compare_helpers (Comp)
    include Util.Make_compare_infix (Comp)
    include Util.Make_equal_infix (E)
  end

  type t =
    { first : elt
    ; last : elt
    }

  let make ~first ~last = { first; last }
  let first_elt { first; _ } = first
  let last_elt { last; _ } = last
  let is_ascending r = Elt.(first_elt r < last_elt r)
  let is_descending r = Elt.(first_elt r > last_elt r)
  let min_elt r = if is_ascending r then first_elt r else last_elt r
  let max_elt r = if is_ascending r then last_elt r else first_elt r
  let rev { first = last; last = first } = { first; last }
  let sort r = if not (is_ascending r) then rev r else r
end
