(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "diff" =
  let a = Datetime.epoch
  and b = Datetime.epoch in
  Datetime.diff a b |> dump_dhms;
  [%expect {| 0d, 0:0:0 |}]
;;

let%expect_test "diff" =
  let a = Datetime.epoch
  and b = Datetime.(epoch - Duration.from_days 1) in
  Datetime.diff a b |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "diff" =
  let a = Datetime.epoch in
  let b =
    Datetime.as_duration (fun x -> Duration.(x - from_days 1 - from_hours 2)) a
  in
  Datetime.diff a b |> dump_dhms;
  [%expect {| 1d, 2:0:0 |}]
;;

let%expect_test "diff" =
  let a = Datetime.epoch in
  let b =
    Datetime.as_duration (fun x -> Duration.(x + from_days 1 + from_hours 2)) a
  in
  Datetime.diff a b |> dump_dhms;
  [%expect {| -2d, 22:0:0 |}]
;;

let%expect_test "diff+abs" =
  let a = Datetime.epoch in
  let b =
    Datetime.as_duration (fun x -> Duration.(x + from_days 1 + from_hours 2)) a
  in
  Datetime.diff a b |> Duration.abs |> dump_dhms;
  [%expect {| 1d, 2:0:0 |}]
;;
