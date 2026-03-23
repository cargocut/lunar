(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "add_seconds" =
  "2026-03-19"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T00:00:01 |}]
;;

let%expect_test "add_seconds" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T11:22:24 |}]
;;

let%expect_test "add_seconds" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 234567890
  |> dump_datetime;
  [%expect {| 2033-08-24T09:07:13 |}]
;;

let%expect_test "sub_seconds" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds 234567890
  |> dump_datetime;
  [%expect {| 2018-10-12T13:37:33 |}]
;;

let%expect_test "add_seconds: +1 from midnight" =
  "2026-03-19"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T00:00:01 |}]
;;

let%expect_test "add_seconds: simple increment" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T11:22:24 |}]
;;

let%expect_test "add_seconds: second overflow to minute" =
  "2026-03-19 11:22:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T11:23:00 |}]
;;

let%expect_test "add_seconds: minute overflow to hour" =
  "2026-03-19 11:59:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T12:00:00 |}]
;;

let%expect_test "add_seconds: hour overflow to next day" =
  "2026-03-19 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-20T00:00:00 |}]
;;

let%expect_test "add_seconds: crossing month boundary" =
  "2026-01-31 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2026-02-01T00:00:00 |}]
;;

let%expect_test "add_seconds: crossing year boundary" =
  "2026-12-31 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2027-01-01T00:00:00 |}]
;;

let%expect_test "sub_seconds: simple decrement" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T11:22:22 |}]
;;

let%expect_test "sub_seconds: borrow from minute" =
  "2026-03-19 11:22:00"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T11:21:59 |}]
;;

let%expect_test "sub_seconds: borrow from hour" =
  "2026-03-19 12:00:00"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T11:59:59 |}]
;;

let%expect_test "sub_seconds: crossing day boundary" =
  "2026-03-20 00:00:00"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds 1
  |> dump_datetime;
  [%expect {| 2026-03-19T23:59:59 |}]
;;

let%expect_test "add_seconds: large value" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 234567890
  |> dump_datetime;
  [%expect {| 2033-08-24T09:07:13 |}]
;;

let%expect_test "sub_seconds: large value" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds 234567890
  |> dump_datetime;
  [%expect {| 2018-10-12T13:37:33 |}]
;;

let%expect_test "add_seconds: negative behaves like sub" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds (-1)
  |> dump_datetime;
  [%expect {| 2026-03-19T11:22:22 |}]
;;

let%expect_test "sub_seconds: negative behaves like add" =
  "2026-03-19 11:22:23"
  |> Datetime.from_string_exn
  |> Datetime.sub_seconds (-1)
  |> dump_datetime;
  [%expect {| 2026-03-19T11:22:24 |}]
;;

let%expect_test "add_seconds: leap day transition" =
  "2024-02-28 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2024-02-29T00:00:00 |}]
;;

let%expect_test "add_seconds: after leap day" =
  "2024-02-29 23:59:59"
  |> Datetime.from_string_exn
  |> Datetime.add_seconds 1
  |> dump_datetime;
  [%expect {| 2024-03-01T00:00:00 |}]
;;

let%expect_test "add then sub cancels out" =
  let dt = Datetime.from_string_exn "2026-03-19 11:22:23" in
  let result = dt |> Datetime.add_seconds 12345 |> Datetime.sub_seconds 12345 in
  dump_bool (Datetime.equal dt result);
  [%expect {| true |}]
;;

let%expect_test "monotonicity" =
  let d1 =
    Datetime.from_string_exn "2026-03-19 11:22:23" |> Datetime.add_seconds 1
  and d2 =
    Datetime.from_string_exn "2026-03-19 11:22:23" |> Datetime.add_seconds 2
  in
  dump_bool Datetime.(d1 < d2);
  [%expect {| true |}]
;;

let%expect_test "add_months: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_months 1
  |> dump_datetime;
  [%expect {| 2026-04-20T00:00:00 |}]
;;

let%expect_test "add_months: crossing year" =
  "2026-12-20"
  |> Datetime.from_string_exn
  |> Datetime.add_months 1
  |> dump_datetime;
  [%expect {| 2027-01-20T00:00:00 |}]
;;

let%expect_test "add_months: clamp Jan 31 -> Feb" =
  "2026-01-31"
  |> Datetime.from_string_exn
  |> Datetime.add_months 1
  |> dump_datetime;
  [%expect {| 2026-02-28T00:00:00 |}]
;;

let%expect_test "add_months: clamp March 31 -> April" =
  "2026-03-31"
  |> Datetime.from_string_exn
  |> Datetime.add_months 1
  |> dump_datetime;
  [%expect {| 2026-04-30T00:00:00 |}]
;;

let%expect_test "add_months: leap year Feb" =
  "2024-01-31"
  |> Datetime.from_string_exn
  |> Datetime.add_months 1
  |> dump_datetime;
  [%expect {| 2024-02-29T00:00:00 |}]
;;

let%expect_test "sub_months: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.sub_months 1
  |> dump_datetime;
  [%expect {| 2026-02-20T00:00:00 |}]
;;

let%expect_test "sub_months: crossing year" =
  "2026-01-20"
  |> Datetime.from_string_exn
  |> Datetime.sub_months 1
  |> dump_datetime;
  [%expect {| 2025-12-20T00:00:00 |}]
;;

let%expect_test "add_months: negative" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_months (-1)
  |> dump_datetime;
  [%expect {| 2026-02-20T00:00:00 |}]
;;

let%expect_test "add_months then sub_months cancels" =
  let dt = Datetime.from_string_exn "2026-03-20" in
  let result = dt |> Datetime.add_months 5 |> Datetime.sub_months 5 in
  dump_bool (Datetime.equal dt result);
  [%expect {| true |}]
;;

let%expect_test "add_years: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_years 1
  |> dump_datetime;
  [%expect {| 2027-03-20T00:00:00 |}]
;;

let%expect_test "add_years: leap day -> non leap" =
  "2024-02-29"
  |> Datetime.from_string_exn
  |> Datetime.add_years 1
  |> dump_datetime;
  [%expect {| 2025-02-28T00:00:00 |}]
;;

let%expect_test "sub_years: leap day backward" =
  "2024-02-29"
  |> Datetime.from_string_exn
  |> Datetime.sub_years 1
  |> dump_datetime;
  [%expect {| 2023-02-28T00:00:00 |}]
;;

let%expect_test "add_years: large" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_years 100
  |> dump_datetime;
  [%expect {| 2126-03-20T00:00:00 |}]
;;

let%expect_test "add_years: negative" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_years (-1)
  |> dump_datetime;
  [%expect {| 2025-03-20T00:00:00 |}]
;;

let%expect_test "add_years then sub_years cancels" =
  let dt = Datetime.from_string_exn "2026-03-20" in
  let result = dt |> Datetime.add_years 10 |> Datetime.sub_years 10 in
  dump_bool (Datetime.equal dt result);
  [%expect {| true |}]
;;

let%expect_test "add_weeks: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_weeks 1
  |> dump_datetime;
  [%expect {| 2026-03-27T00:00:00 |}]
;;

let%expect_test "add_weeks: crossing month" =
  "2026-01-28"
  |> Datetime.from_string_exn
  |> Datetime.add_weeks 1
  |> dump_datetime;
  [%expect {| 2026-02-04T00:00:00 |}]
;;

let%expect_test "sub_weeks: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.sub_weeks 1
  |> dump_datetime;
  [%expect {| 2026-03-13T00:00:00 |}]
;;

let%expect_test "add_weeks then sub_weeks cancels" =
  let dt = Datetime.from_string_exn "2026-03-20" in
  let result = dt |> Datetime.add_weeks 3 |> Datetime.sub_weeks 3 in
  dump_bool (Datetime.equal dt result);
  [%expect {| true |}]
;;

let%expect_test "add_quarters: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.add_quarters 1
  |> dump_datetime;
  [%expect {| 2026-06-20T00:00:00 |}]
;;

let%expect_test "add_quarters: crossing year" =
  "2026-11-20"
  |> Datetime.from_string_exn
  |> Datetime.add_quarters 1
  |> dump_datetime;
  [%expect {| 2027-02-20T00:00:00 |}]
;;

let%expect_test "add_quarters: clamp Jan 31" =
  "2026-01-31"
  |> Datetime.from_string_exn
  |> Datetime.add_quarters 1
  |> dump_datetime;
  [%expect {| 2026-04-30T00:00:00 |}]
;;

let%expect_test "sub_quarters: simple" =
  "2026-03-20"
  |> Datetime.from_string_exn
  |> Datetime.sub_quarters 1
  |> dump_datetime;
  [%expect {| 2025-12-20T00:00:00 |}]
;;

let%expect_test "add_quarters then sub_quarters cancels" =
  let dt = Datetime.from_string_exn "2026-03-20" in
  let result = dt |> Datetime.add_quarters 2 |> Datetime.sub_quarters 2 in
  dump_bool (Datetime.equal dt result);
  [%expect {| true |}]
;;
