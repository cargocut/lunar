(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let iterator = Date_range.iterator ~pred:Date.pred ~succ:Date.succ

let%expect_test "dump length" =
  let r = mkr "2026-03-01" "2026-03-10" in
  r |> Date_range.length ~iterator |> print_int;
  [%expect {| 10 |}]
;;

let%expect_test "dump length" =
  let r = mkr "2026-03-01" "2026-03-10" in
  r |> Date_range.rev |> Date_range.length ~iterator |> print_int;
  [%expect {| 10 |}]
;;

let%expect_test "dump list" =
  let r = mkr "2026-03-01" "2026-03-10" in
  r |> Date_range.to_list ~iterator |> List.iter dump_date;
  [%expect
    {|
    2026-03-01
    2026-03-02
    2026-03-03
    2026-03-04
    2026-03-05
    2026-03-06
    2026-03-07
    2026-03-08
    2026-03-09
    2026-03-10
    |}]
;;

let%expect_test "dump list" =
  let r = mkr "2026-03-01" "2026-03-10" in
  let iterator =
    Date_range.iterator ~pred:Date.(sub_days 2) ~succ:Date.(add_days 2)
  in
  r |> Date_range.to_list ~iterator |> List.iter dump_date;
  [%expect
    {|
    2026-03-01
    2026-03-03
    2026-03-05
    2026-03-07
    2026-03-09
    2026-03-10
    |}]
;;

let%expect_test "dump list" =
  let r = mkr "2026-03-01" "2026-03-10" in
  let iterator =
    Date_range.iterator ~pred:Date.(sub_days 2) ~succ:Date.(add_days 2)
  in
  r |> Date_range.to_list ~iterator |> List.iter dump_date;
  [%expect
    {|
    2026-03-01
    2026-03-03
    2026-03-05
    2026-03-07
    2026-03-09
    2026-03-10
    |}]
;;

let%expect_test "dump list" =
  let r = mkr "2026-03-10" "2026-03-01" in
  let iterator =
    Date_range.iterator ~pred:Date.(sub_days 2) ~succ:Date.(add_days 2)
  in
  r
  |> Date_range.to_list ~include_boundaries:false ~iterator
  |> List.iter dump_date;
  [%expect
    {|
    2026-03-10
    2026-03-08
    2026-03-06
    2026-03-04
    2026-03-02
    |}]
;;

let%expect_test "fold_left sum" =
  let r = mkr "2026-03-01" "2026-03-10" in
  let iterator = Date_range.iterator ~pred:Date.pred ~succ:Date.succ in
  let sum =
    Date_range.fold_left ~iterator (fun d acc -> acc + Date.day_of_month d) 0 r
  in
  print_int sum;
  [%expect {| 55 |}]
;;

let%expect_test "fold_right concat" =
  let r = mkr "2026-03-01" "2026-03-05" in
  let iterator = Date_range.iterator ~pred:Date.pred ~succ:Date.succ in
  let s =
    Date_range.fold_right
      ~iterator
      (fun d acc -> acc ^ Date.to_string d ^ " ")
      ""
      r
  in
  print_endline s;
  [%expect {| 2026-03-05 2026-03-04 2026-03-03 2026-03-02 2026-03-01  |}]
;;

let%expect_test "fold_left count" =
  let r = mkr "2026-03-01" "2026-03-10" in
  let iterator = Date_range.iterator ~pred:Date.pred ~succ:Date.succ in
  let count = Date_range.fold_left ~iterator (fun _ acc -> acc + 1) 0 r in
  print_int count;
  [%expect {| 10 |}]
;;

let%expect_test "fold_left step 2" =
  let r = mkr "2026-03-01" "2026-03-10" in
  let iterator =
    Date_range.iterator ~pred:Date.(sub_days 2) ~succ:Date.(add_days 2)
  in
  let sum =
    Date_range.fold_left ~iterator (fun d acc -> acc + Date.day_of_month d) 0 r
  in
  print_int sum;
  [%expect {| 35 |}]
;;

let%expect_test "fold_right reversed range" =
  let r = mkr "2026-03-10" "2026-03-01" in
  let iterator =
    Date_range.iterator ~pred:Date.(sub_days 2) ~succ:Date.(add_days 2)
  in
  let s =
    Date_range.fold_right
      ~include_boundaries:false
      ~iterator
      (fun d acc -> acc ^ Date.to_string d ^ " ")
      ""
      r
  in
  print_endline s;
  [%expect {| 2026-03-01 2026-03-03 2026-03-05 2026-03-07 2026-03-09 |}]
;;
