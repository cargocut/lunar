(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "diff - 1" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_days 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "diff - same datetime" =
  let d = Datetime.from_string_exn "2026-03-20 11:22:23" in
  Datetime.diff d d |> dump_dhms;
  [%expect {| 0d, 0:0:0 |}]
;;

let%expect_test "diff - 1 day" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_days 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "diff - 1 hour" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_hours 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 0d, 1:0:0 |}]
;;

let%expect_test "diff - 1 minute" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_minutes 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 0d, 0:1:0 |}]
;;

let%expect_test "diff - 1 second" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_seconds 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 0d, 0:0:1 |}]
;;

let%expect_test "diff - mixed (d+h+m+s)" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 =
    d1
    |> Datetime.add_days 2
    |> Datetime.add_hours 3
    |> Datetime.add_minutes 4
    |> Datetime.add_seconds 5
  in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 2d, 3:4:5 |}]
;;

let%expect_test "diff - negative 1 day" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.sub_days 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| -1d, 0:0:0 |}]
;;

let%expect_test "diff - negative mixed" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 =
    d1
    |> Datetime.sub_days 2
    |> Datetime.sub_hours 3
    |> Datetime.sub_minutes 4
    |> Datetime.sub_seconds 5
  in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| -3d, 20:55:55 |}]
;;

let%expect_test "diff - second across minute" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:59" in
  let d2 = Datetime.add_seconds 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 0d, 0:0:1 |}]
;;

let%expect_test "diff - across hour" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:59:59" in
  let d2 = Datetime.add_seconds 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 0d, 0:0:1 |}]
;;

let%expect_test "diff - across day" =
  let d1 = Datetime.from_string_exn "2026-03-20 23:59:59" in
  let d2 = Datetime.add_seconds 1 d1 in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 0d, 0:0:1 |}]
;;

let%expect_test "diff - across month" =
  let d1 = Datetime.from_string_exn "2026-01-31 00:00:00" in
  let d2 = Datetime.from_string_exn "2026-02-01 00:00:00" in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "diff - across year" =
  let d1 = Datetime.from_string_exn "2026-12-31 00:00:00" in
  let d2 = Datetime.from_string_exn "2027-01-01 00:00:00" in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "diff - leap day" =
  let d1 = Datetime.from_string_exn "2024-02-28 00:00:00" in
  let d2 = Datetime.from_string_exn "2024-02-29 00:00:00" in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 1d, 0:0:0 |}]
;;

let%expect_test "diff - across leap day" =
  let d1 = Datetime.from_string_exn "2024-02-28 00:00:00" in
  let d2 = Datetime.from_string_exn "2024-03-01 00:00:00" in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 2d, 0:0:0 |}]
;;

let%expect_test "diff - large span" =
  let d1 = Datetime.from_string_exn "2000-01-01 00:00:00" in
  let d2 = Datetime.from_string_exn "2026-01-01 00:00:00" in
  Datetime.diff d2 d1 |> dump_dhms;
  [%expect {| 9497d, 0:0:0 |}]
;;

let%expect_test "diff symmetry" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_days 5 d1 in
  let a = Datetime.diff d2 d1
  and b = Datetime.diff d1 d2 in
  dump_bool Duration.(equal a (zero - b));
  [%expect {| true |}]
;;

let%expect_test "diff after add" =
  let d1 = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d2 = Datetime.add_days 7 d1 in
  let diff = Datetime.diff d2 d1 in
  let d3 = Datetime.add diff d1 in
  dump_bool (Datetime.equal d2 d3);
  [%expect {| true |}]
;;

let%expect_test "diff monotonicity" =
  let d = Datetime.from_string_exn "2026-03-20 11:22:23" in
  let d1 = Datetime.add_days 1 d
  and d2 = Datetime.add_days 2 d in
  let diff1 = Datetime.diff d1 d
  and diff2 = Datetime.diff d2 d in
  dump_bool Duration.(diff2 > diff1);
  [%expect {| true |}]
;;
