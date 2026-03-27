(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(** The Range module allows you to create intervals between comparable
    data points (implementing {!module-type:Sigs.COMPARABLE}). *)

module Make (Comp : Sigs.COMPARABLE) : Sigs.RANGE with type elt = Comp.t
