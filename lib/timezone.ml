(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

type t = Duration.t

(* MAYBE : *)

let positive ~hour:h ~min:m = Duration.(from_hours h + from_minutes m)
let negative ~hour ~min = Duration.neg (positive ~hour ~min)
let equal = Duration.equal
let compare = Duration.compare

module CE = struct
  type nonrec t = t

  let equal = equal
  let compare = compare
end

module Infix = struct
  let ( ~+ ) (hour, min) = positive ~hour ~min
  let ( ~- ) (hour, min) = negative ~hour ~min

  include (Util.Make_equal_infix (CE) : Sigs.EQUATABLE_INFIX with type t := t)

  include (
    Util.Make_compare_infix (CE) : Sigs.COMPARABLE_INFIX with type t := t)
end

include (
  Util.Make_compare_helpers (CE) : Sigs.COMPARABLE_HELPERS with type t := t)

include Infix
