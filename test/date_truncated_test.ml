(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "truncate on day should preserve the date" =
  let date = "2026-03-21"
  and resolution = Resolution.day in
  date |> Date.from_string_exn |> Date.truncate resolution |> dump_date;
  [%expect {| 2026-03-21 |}]
;;

let%expect_test "truncate on week should jump to the first day of the week" =
  let date = "2026-03-21"
  and resolution = Resolution.week in
  date |> Date.from_string_exn |> Date.truncate resolution |> dump_date;
  [%expect {| 2026-03-16 |}]
;;

let%expect_test
    "truncate on week should jump to the first day of the week (when the first \
     day of week is sunday)"
  =
  let date = "2026-03-21"
  and resolution = Resolution.week_with_start Weekday.Sun in
  date |> Date.from_string_exn |> Date.truncate resolution |> dump_date;
  [%expect {| 2026-03-15 |}]
;;

let%expect_test "truncate on month" =
  let date = "2026-03-21"
  and resolution = Resolution.month in
  date |> Date.from_string_exn |> Date.truncate resolution |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "truncate on quarter" =
  let date = "2026-03-21"
  and resolution = Resolution.quarter in
  date |> Date.from_string_exn |> Date.truncate resolution |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "truncate on year" =
  let date = "2026-03-21"
  and resolution = Resolution.year in
  date |> Date.from_string_exn |> Date.truncate resolution |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "truncate is idempotent on boundaries" =
  let test date resolution =
    date
    |> Date.from_string_exn
    |> Date.truncate resolution
    |> Date.truncate resolution
    |> dump_date
  in
  test "2026-03-01" Resolution.month;
  test "2026-01-01" Resolution.year;
  test "2026-04-01" Resolution.quarter;
  [%expect
    {|
    2026-03-01
    2026-01-01
    2026-04-01 |}]
;;

let%expect_test "truncate handles end-of-month correctly" =
  let date = "2026-02-28" in
  date |> Date.from_string_exn |> Date.truncate Resolution.month |> dump_date;
  [%expect {| 2026-02-01 |}]
;;

let%expect_test "truncate handles leap year" =
  let date = "2024-02-29" in
  date |> Date.from_string_exn |> Date.truncate Resolution.year |> dump_date;
  [%expect {| 2024-01-01 |}]
;;

let%expect_test "truncate quarter at boundary" =
  let date = "2026-04-01" in
  date |> Date.from_string_exn |> Date.truncate Resolution.quarter |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "truncate week when already first day" =
  let date = "2026-03-16" in
  date |> Date.from_string_exn |> Date.truncate Resolution.week |> dump_date;
  [%expect {| 2026-03-16 |}]
;;

let%expect_test "ceil on month" =
  let date = "2026-03-21" in
  date |> Date.from_string_exn |> Date.ceil Resolution.month |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "ceil should not change aligned date" =
  let date = "2026-03-01" in
  date |> Date.from_string_exn |> Date.ceil Resolution.month |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "ceil across year boundary" =
  let date = "2026-12-31" in
  date |> Date.from_string_exn |> Date.ceil Resolution.year |> dump_date;
  [%expect {| 2027-01-01 |}]
;;

let%expect_test "ceil week" =
  let date = "2026-03-17" in
  date |> Date.from_string_exn |> Date.ceil Resolution.week |> dump_date;
  [%expect {| 2026-03-23 |}]
;;

let%expect_test "round month downward" =
  let date = "2026-03-10" in
  date |> Date.from_string_exn |> Date.round Resolution.month |> dump_date;
  [%expect {| 2026-03-01 |}]
;;

let%expect_test "round month upward" =
  let date = "2026-03-20" in
  date |> Date.from_string_exn |> Date.round Resolution.month |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "round month midpoint goes up" =
  let date = "2026-03-17" in
  date |> Date.from_string_exn |> Date.round Resolution.month |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "round quarter" =
  let date = "2026-02-15" in
  date |> Date.from_string_exn |> Date.round Resolution.quarter |> dump_date;
  [%expect {| 2026-01-01 |}]
;;

let%expect_test "round quarter upward" =
  let date = "2026-03-20" in
  date |> Date.from_string_exn |> Date.round Resolution.quarter |> dump_date;
  [%expect {| 2026-04-01 |}]
;;

let%expect_test "truncate <= d <= ceil invariant" =
  let d = Date.from_string_exn "2026-03-21" in
  let f = Date.truncate Resolution.month d in
  let c = Date.ceil Resolution.month d in
  dump_bool Date.(f <= d && d <= c);
  [%expect {| true |}]
;;

let%expect_test "round is either floor or ceil" =
  let d = Date.from_string_exn "2026-03-21" in
  let f = Date.truncate Resolution.month d in
  let c = Date.ceil Resolution.month d in
  let r = Date.round Resolution.month d in
  dump_bool (Date.equal r f || Date.equal r c);
  [%expect {| true |}]
;;
