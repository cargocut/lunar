(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "clamp: inside interval" =
  let curr = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year curr
  and max = Date.end_of_year curr in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-03-20 |}]
;;

let%expect_test "clamp: above interval" =
  let curr = Date.make_exn ~year:2027 ~month:Month.Jan ~day:5 () in
  let base = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year base
  and max = Date.end_of_year base in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "clamp: below interval" =
  let curr = Date.make_exn ~year:2025 ~month:Month.Dec ~day:25 () in
  let base = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year base
  and max = Date.end_of_year base in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "clamp: at min boundary" =
  let base = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year base
  and max = Date.end_of_year base
  and curr = Date.start_of_year base in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "clamp: at max boundary" =
  let base = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year base
  and max = Date.end_of_year base
  and curr = Date.end_of_year base in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "clamp: reversed bounds" =
  let curr = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.end_of_year curr
  and max = Date.start_of_year curr in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-03-20 |}]
;;

let%expect_test "clamp: far future date" =
  let curr = Date.make_exn ~year:2100 ~month:Month.Jan ~day:1 () in
  let base = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year base
  and max = Date.end_of_year base in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-12-31 |}]
;;

let%expect_test "clamp: far past date" =
  let curr = Date.make_exn ~year:1900 ~month:Month.Jan ~day:1 () in
  let base = Date.make_exn ~year:2026 ~month:Month.Mar ~day:20 () in
  let min = Date.start_of_year base
  and max = Date.end_of_year base in
  curr |> Date.clamp ~min ~max |> dump_date;
  [%expect {| 2026-01-01 |}]
;;
