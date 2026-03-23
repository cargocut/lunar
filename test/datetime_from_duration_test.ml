(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from epoch" =
  Datetime.from_duration Duration.zero |> dump_datetime;
  [%expect {| 1970-01-01T00:00:00 |}]
;;

let%expect_test "from epoch + 1s" =
  Datetime.from_duration Duration.one |> dump_datetime;
  [%expect {| 1970-01-01T00:00:01 |}]
;;

let%expect_test "from epoch + 1 day" =
  Datetime.from_duration (Duration.from_days 1) |> dump_datetime;
  [%expect {| 1970-01-02T00:00:00 |}]
;;

let%expect_test "from epoch - 1 day" =
  Datetime.from_duration Duration.(zero - from_days 1) |> dump_datetime;
  [%expect {| 1969-12-31T00:00:00 |}]
;;

let%expect_test "from epoch + 3 days" =
  Datetime.from_duration (Duration.from_days 3) |> dump_datetime;
  [%expect {| 1970-01-04T00:00:00 |}]
;;

let%expect_test "from epoch + arbitrary value" =
  Datetime.from_duration
    Duration.(
      zero - (from_days 3 + from_hours 64 + from_minutes 43 + from_seconds 33))
  |> dump_datetime;
  [%expect {| 1969-12-26T07:16:27 |}]
;;

let%expect_test "from epoch + arbitrary value" =
  Datetime.from_duration
    Duration.(
      zero
      - (from_days 545678 + from_hours 64 + from_minutes 43 + from_seconds 33))
  |> dump_datetime;
  [%expect {| 0475-12-23T07:16:27 |}]
;;

let%expect_test "from epoch + hours/minutes/seconds" =
  Datetime.from_duration
    Duration.(from_hours 10 + from_minutes 30 + from_seconds 15)
  |> dump_datetime;
  [%expect {| 1970-01-01T10:30:15 |}]
;;

let%expect_test "from epoch - hours/minutes/seconds" =
  Datetime.from_duration
    Duration.(zero - (from_hours 1 + from_minutes 1 + from_seconds 1))
  |> dump_datetime;
  [%expect {| 1969-12-31T22:58:59 |}]
;;

let%expect_test "crossing into next month" =
  Datetime.from_duration (Duration.from_days 31) |> dump_datetime;
  [%expect {| 1970-02-01T00:00:00 |}]
;;

let%expect_test "crossing into previous month" =
  Datetime.from_duration Duration.(zero - from_days 1) |> dump_datetime;
  [%expect {| 1969-12-31T00:00:00 |}]
;;

let%expect_test "crossing into next year" =
  Datetime.from_duration (Duration.from_days 365) |> dump_datetime;
  [%expect {| 1971-01-01T00:00:00 |}]
;;

let%expect_test "leap year forward (1972)" =
  Datetime.from_duration (Duration.from_days (365 * 2)) |> dump_datetime;
  [%expect {| 1972-01-01T00:00:00 |}]
;;

let%expect_test "around leap day" =
  Datetime.from_duration (Duration.from_days ((365 * 2) + 59)) |> dump_datetime;
  [%expect {| 1972-02-29T00:00:00 |}]
;;

let%expect_test "from epoch - arbitrary value" =
  Datetime.from_duration
    Duration.(
      zero - (from_days 3 + from_hours 64 + from_minutes 43 + from_seconds 33))
  |> dump_datetime;
  [%expect {| 1969-12-26T07:16:27 |}]
;;

let%expect_test "from epoch - large arbitrary value" =
  Datetime.from_duration
    Duration.(
      zero
      - (from_days 545678 + from_hours 64 + from_minutes 43 + from_seconds 33))
  |> dump_datetime;
  [%expect {| 0475-12-23T07:16:27 |}]
;;

let%expect_test "roundtrip duration -> datetime -> duration" =
  let d =
    Duration.(from_days 1234 + from_hours 5 + from_minutes 6 + from_seconds 7)
  in
  let d' = Datetime.from_duration d |> Datetime.to_duration in
  dump_bool (Duration.equal d d');
  [%expect {| true |}]
;;

let%expect_test "monotonicity" =
  let d1 = Datetime.from_duration Duration.(from_days 10)
  and d2 = Datetime.from_duration Duration.(from_days 11) in
  dump_bool Datetime.(d1 < d2);
  [%expect {| true |}]
;;

let%expect_test "add then subtract duration" =
  let base = Datetime.from_duration Duration.(from_days 100) in
  let d = Duration.(from_hours 5 + from_minutes 30) in
  let result = base |> Datetime.add d |> Datetime.sub d in
  dump_bool (Datetime.equal base result);
  [%expect {| true |}]
;;
