(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "add_days" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.add_days 10 |> dump_date;
  [%expect {| 2020-03-10 |}]
;;

let%expect_test "add_days" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.sub_days 10 |> dump_date;
  [%expect {| 2020-02-19 |}]
;;

let%expect_test "add_weeks" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 ()
  |> Date.add_weeks 10
  |> dump_date;
  [%expect {| 2020-05-09 |}]
;;

let%expect_test "add_weeks" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 ()
  |> Date.sub_weeks 10
  |> dump_date;
  [%expect {| 2019-12-21 |}]
;;

let%expect_test "add_years" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.add_years 2 |> dump_date;
  [%expect {| 2022-02-28 |}]
;;

let%expect_test "add_years" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.sub_years 4 |> dump_date;
  [%expect {| 2016-02-29 |}]
;;

let%expect_test "add_days month boundary forward" =
  Date.make_exn' ~year:2021 ~month:1 ~day:31 () |> Date.add_days 1 |> dump_date;
  [%expect {| 2021-02-01 |}]
;;

let%expect_test "add_days month boundary backward" =
  Date.make_exn' ~year:2021 ~month:3 ~day:1 () |> Date.sub_days 1 |> dump_date;
  [%expect {| 2021-02-28 |}]
;;

let%expect_test "add_days leap crossing" =
  Date.make_exn' ~year:2020 ~month:2 ~day:28 () |> Date.add_days 1 |> dump_date;
  [%expect {| 2020-02-29 |}]
;;

let%expect_test "add_days leap crossing next" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.add_days 1 |> dump_date;
  [%expect {| 2020-03-01 |}]
;;

let%expect_test "add_days new year" =
  Date.make_exn' ~year:2021 ~month:12 ~day:31 () |> Date.add_days 1 |> dump_date;
  [%expect {| 2022-01-01 |}]
;;

let%expect_test "sub_days previous year" =
  Date.make_exn' ~year:2021 ~month:1 ~day:1 () |> Date.sub_days 1 |> dump_date;
  [%expect {| 2020-12-31 |}]
;;

let%expect_test "add_weeks across year" =
  Date.make_exn' ~year:2021 ~month:12 ~day:15 ()
  |> Date.add_weeks 4
  |> dump_date;
  [%expect {| 2022-01-12 |}]
;;

let%expect_test "sub_weeks across year" =
  Date.make_exn' ~year:2021 ~month:1 ~day:10 () |> Date.sub_weeks 3 |> dump_date;
  [%expect {| 2020-12-20 |}]
;;

let%expect_test "add_years from leap day" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.add_years 1 |> dump_date;
  [%expect {| 2021-02-28 |}]
;;

let%expect_test "sub_years preserves leap day" =
  Date.make_exn' ~year:2020 ~month:2 ~day:29 () |> Date.sub_years 4 |> dump_date;
  [%expect {| 2016-02-29 |}]
;;

let%expect_test "add_days large jump" =
  Date.make_exn' ~year:2000 ~month:1 ~day:1 ()
  |> Date.add_days 10000
  |> dump_date;
  [%expect {| 2027-05-19 |}]
;;

let%expect_test "sub_days large jump" =
  Date.make_exn' ~year:2000 ~month:1 ~day:1 ()
  |> Date.sub_days 10000
  |> dump_date;
  [%expect {| 1972-08-15 |}]
;;

let%expect_test "add then sub days identity" =
  let d = Date.make_exn' ~year:2023 ~month:6 ~day:15 () in
  d |> Date.add_days 50 |> Date.sub_days 50 |> dump_date;
  [%expect {| 2023-06-15 |}]
;;

let%expect_test "add then sub weeks identity" =
  let d = Date.make_exn' ~year:2023 ~month:6 ~day:15 () in
  d |> Date.add_weeks 20 |> Date.sub_weeks 20 |> dump_date;
  [%expect {| 2023-06-15 |}]
;;

let%expect_test "epoch plus one day" =
  Date.epoch |> Date.add_days 1 |> dump_date;
  [%expect {| 1970-01-02 |}]
;;

let%expect_test "epoch minus one day" =
  Date.epoch |> Date.sub_days 1 |> dump_date;
  [%expect {| 1969-12-31 |}]
;;

let%expect_test "gregorian cycle" =
  Date.make_exn' ~year:2000 ~month:2 ~day:29 ()
  |> Date.add_years 400
  |> dump_date;
  [%expect {| 2400-02-29 |}]
;;

let%expect_test "add_days vs duration" =
  let d = Date.make_exn' ~year:2023 ~month:5 ~day:1 () in
  let a = Date.add_days 10 d in
  let b = Date.as_duration (fun x -> Duration.(x + from_days 10)) d in
  dump_date a;
  dump_date b;
  [%expect
    {|
    2023-05-11
    2023-05-11 |}]
;;

let%expect_test "add_months simple forward" =
  Date.make_exn' ~year:2023 ~month:1 ~day:15 ()
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2023-02-15 |}]
;;

let%expect_test "add_months simple backward" =
  Date.make_exn' ~year:2023 ~month:3 ~day:15 ()
  |> Date.sub_months 1
  |> dump_date;
  [%expect {| 2023-02-15 |}]
;;

let%expect_test "add_months trim 31 -> 30" =
  Date.make_exn' ~year:2023 ~month:1 ~day:31 ()
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2023-02-28 |}]
;;

let%expect_test "add_months trim 31 -> 30 (april)" =
  Date.make_exn' ~year:2023 ~month:3 ~day:31 ()
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2023-04-30 |}]
;;

let%expect_test "add_months leap year february" =
  Date.make_exn' ~year:2020 ~month:1 ~day:31 ()
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2020-02-29 |}]
;;

let%expect_test "sub_months leap year february" =
  Date.make_exn' ~year:2020 ~month:3 ~day:31 ()
  |> Date.sub_months 1
  |> dump_date;
  [%expect {| 2020-02-29 |}]
;;

let%expect_test "add_months cross year" =
  Date.make_exn' ~year:2023 ~month:11 ~day:15 ()
  |> Date.add_months 2
  |> dump_date;
  [%expect {| 2024-01-15 |}]
;;

let%expect_test "sub_months cross year" =
  Date.make_exn' ~year:2023 ~month:1 ~day:15 ()
  |> Date.sub_months 2
  |> dump_date;
  [%expect {| 2022-11-15 |}]
;;

let%expect_test "add_months 12 months" =
  Date.make_exn' ~year:2020 ~month:6 ~day:10 ()
  |> Date.add_months 12
  |> dump_date;
  [%expect {| 2021-06-10 |}]
;;

let%expect_test "sub_months 12 months" =
  Date.make_exn' ~year:2020 ~month:6 ~day:10 ()
  |> Date.sub_months 12
  |> dump_date;
  [%expect {| 2019-06-10 |}]
;;

let%expect_test "add_months large jump" =
  Date.make_exn' ~year:2000 ~month:1 ~day:1 ()
  |> Date.add_months 240
  |> dump_date;
  [%expect {| 2020-01-01 |}]
;;

let%expect_test "sub_months large jump" =
  Date.make_exn' ~year:2000 ~month:1 ~day:1 ()
  |> Date.sub_months 240
  |> dump_date;
  [%expect {| 1980-01-01 |}]
;;

let%expect_test "epoch add months" =
  Date.epoch |> Date.add_months 1 |> dump_date;
  [%expect {| 1970-02-01 |}]
;;

let%expect_test "epoch sub months" =
  Date.epoch |> Date.sub_months 1 |> dump_date;
  [%expect {| 1969-12-01 |}]
;;

let%expect_test "add then sub months identity" =
  let d = Date.make_exn' ~year:2022 ~month:7 ~day:14 () in
  d |> Date.add_months 15 |> Date.sub_months 15 |> dump_date;
  [%expect {| 2022-07-14 |}]
;;

let%expect_test "jan 31 + 1 month leap year" =
  Date.make_exn' ~year:2020 ~month:1 ~day:31 ()
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2020-02-29 |}]
;;

let%expect_test "jan 31 + 1 month non leap" =
  Date.make_exn' ~year:2021 ~month:1 ~day:31 ()
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2021-02-28 |}]
;;

let%expect_test "add_months 4800 months (400 years)" =
  Date.make_exn' ~year:2000 ~month:2 ~day:29 ()
  |> Date.add_months 4800
  |> dump_date;
  [%expect {| 2400-02-29 |}]
;;

let%expect_test "12 months equals 1 year" =
  let d = Date.make_exn' ~year:2023 ~month:5 ~day:12 () in
  d |> Date.add_months 12 |> dump_date;
  [%expect {| 2024-05-12 |}]
;;

let%expect_test "jan31 month chain leap year" =
  Date.make_exn' ~year:2020 ~month:1 ~day:31 ()
  |> Date.add_months 1
  |> Date.add_months 1
  |> dump_date;
  [%expect {| 2020-03-29 |}]
;;

let%expect_test "century non leap year" =
  Date.make_exn' ~year:2099 ~month:2 ~day:28 ()
  |> Date.add_days 366
  |> dump_date;
  [%expect {| 2100-03-01 |}]
;;

let%expect_test "gregorian 400y cycle days" =
  Date.make_exn' ~year:2000 ~month:3 ~day:1 ()
  |> Date.add_days 146097
  |> dump_date;
  [%expect {| 2400-03-01 |}]
;;

let%expect_test "gregorian 400y cycle months" =
  Date.make_exn' ~year:2000 ~month:3 ~day:1 ()
  |> Date.add_months 4800
  |> dump_date;
  [%expect {| 2400-03-01 |}]
;;

let%expect_test "negative year leap rule" =
  Date.make_exn' ~year:0 ~month:2 ~day:29 () |> Date.add_years 4 |> dump_date;
  [%expect {| 0004-02-29 |}]
;;

let%expect_test "epoch roundtrip months" =
  Date.epoch |> Date.add_months 1200 |> Date.sub_months 1200 |> dump_date;
  [%expect {| 1970-01-01 |}]
;;

let%expect_test "month drift stress test" =
  Date.make_exn' ~year:2020 ~month:1 ~day:31 ()
  |> Date.add_months 120
  |> dump_date;
  [%expect {| 2030-01-31 |}]
;;

let%expect_test "jan31 + multiple months" =
  Date.make_exn' ~year:2020 ~month:1 ~day:31 ()
  |> Date.add_months 13
  |> dump_date;
  [%expect {| 2021-02-28 |}]
;;

let%expect_test "1900 non-leap year" =
  Date.make_exn' ~year:1899 ~month:2 ~day:28 ()
  |> Date.add_days 366
  |> dump_date;
  [%expect {| 1900-03-01 |}]
;;

let%expect_test "2000 leap year" =
  Date.make_exn' ~year:1999 ~month:2 ~day:28 ()
  |> Date.add_days 366
  |> dump_date;
  [%expect {| 2000-02-29 |}]
;;

let%expect_test "week of year jan1 edge" =
  Date.make_exn' ~year:2021 ~month:1 ~day:1 () |> dump_date_iso_week_of_year;
  [%expect {| 2020 W53, fri/5 |}]
;;
