(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

(* A set of tests inspired by
   {{:https://github.com/ocaml-community/calendar} Calendarlib}. *)

open Test_util

let%expect_test "pred month" =
  (* see https://github.com/ocaml-community/calendar/issues/44 *)
  let today = Date.from_string_exn "2025-10-31" in
  today |> Date.pred_month |> dump_date;
  [%expect {| 2025-09-01 |}]
;;

let%expect_test "prev month using addition" =
  (* see https://github.com/ocaml-community/calendar/issues/44 *)
  let today = Date.from_string_exn "2025-10-31" in
  today |> Date.sub_months 1 |> dump_date;
  [%expect {| 2025-09-30 |}]
;;
