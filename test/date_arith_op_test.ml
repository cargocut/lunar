(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "add" =
  let d = Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 () in
  let e = Date.add d (Duration.from_seconds 2000) in
  e |> dump_date;
  [%expect {| 2026-03-06 |}]
;;

let%expect_test "add" =
  let d = Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 () in
  let e = Date.add d (Duration.from_days 3) in
  e |> dump_date;
  [%expect {| 2026-03-09 |}]
;;

let%expect_test "sub" =
  let d = Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 () in
  let e = Date.sub d (Duration.from_seconds 2000) in
  e |> dump_date;
  [%expect {| 2026-03-05 |}]
;;

let%expect_test "sub" =
  let d = Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 () in
  let e = Date.sub d (Duration.from_days 3) in
  e |> dump_date;
  [%expect {| 2026-03-03 |}]
;;

let%expect_test "succ" =
  let d = Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 () in
  d |> Date.succ |> dump_date;
  [%expect {| 2026-03-07 |}]
;;

let%expect_test "pred" =
  let d = Date.make_exn ~year:2026 ~month:Month.Mar ~day:6 () in
  d |> Date.pred |> dump_date;
  [%expect {| 2026-03-05 |}]
;;
