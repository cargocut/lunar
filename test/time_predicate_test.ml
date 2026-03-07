(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "is_earlier" =
  Time.midnight |> Time.is_earlier ~than:Time.end_of_day |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_earlier" =
  Time.midnight |> Time.is_earlier ~than:Time.midnight |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_earlier" =
  Time.end_of_day |> Time.is_earlier ~than:Time.midnight |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_later" =
  Time.midnight |> Time.is_later ~than:Time.end_of_day |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_later" =
  Time.midnight |> Time.is_later ~than:Time.midnight |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_later" =
  Time.end_of_day |> Time.is_later ~than:Time.midnight |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am" =
  List.init 24 (fun x -> x |> Time.am) |> List.for_all Time.is_am |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_am" =
  List.init 24 (fun x -> x |> Time.pm) |> List.exists Time.is_am |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_pm" =
  List.init 24 (fun x -> x |> Time.pm) |> List.for_all Time.is_pm |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_pm" =
  List.init 24 (fun x -> x |> Time.am) |> List.exists Time.is_pm |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_noon" =
  Time.noon |> Time.is_noon |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_noon negative" =
  Time.midnight |> Time.is_noon |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_midnight" =
  Time.midnight |> Time.is_midnight |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_midnight negative" =
  Time.noon |> Time.is_midnight |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_morning" =
  let times =
    [ Time.make_exn ~hour:5 ~min:0 ~sec:0 ()
    ; Time.make_exn ~hour:11 ~min:59 ~sec:59 ()
    ]
  in
  List.for_all Time.is_morning times |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_morning negative" =
  let times =
    [ Time.make_exn ~hour:4 ~min:59 ~sec:59 ()
    ; Time.make_exn ~hour:12 ~min:0 ~sec:0 ()
    ]
  in
  List.exists Time.is_morning times |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_afternoon" =
  let times =
    [ Time.make_exn ~hour:12 ~min:0 ~sec:0 ()
    ; Time.make_exn ~hour:16 ~min:59 ~sec:59 ()
    ]
  in
  List.for_all Time.is_afternoon times |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_afternoon negative" =
  let times =
    [ Time.make_exn ~hour:11 ~min:59 ~sec:59 ()
    ; Time.make_exn ~hour:17 ~min:0 ~sec:0 ()
    ]
  in
  List.exists Time.is_afternoon times |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_evening" =
  let times =
    [ Time.make_exn ~hour:17 ~min:0 ~sec:0 ()
    ; Time.make_exn ~hour:20 ~min:59 ~sec:59 ()
    ]
  in
  List.for_all Time.is_evening times |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_evening negative" =
  let times =
    [ Time.make_exn ~hour:16 ~min:59 ~sec:59 ()
    ; Time.make_exn ~hour:21 ~min:0 ~sec:0 ()
    ]
  in
  List.exists Time.is_evening times |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "is_night" =
  let times =
    [ Time.make_exn ~hour:21 ~min:0 ~sec:0 ()
    ; Time.make_exn ~hour:4 ~min:59 ~sec:59 ()
    ]
  in
  List.for_all Time.is_night times |> dump_bool;
  [%expect {| true |}]
;;

let%expect_test "is_night negative" =
  let times =
    [ Time.make_exn ~hour:5 ~min:0 ~sec:0 ()
    ; Time.make_exn ~hour:20 ~min:59 ~sec:59 ()
    ]
  in
  List.exists Time.is_night times |> dump_bool;
  [%expect {| false |}]
;;

let%expect_test "time predicates stress test" =
  let seconds_in_day = 24 * 60 * 60 in
  for s = 0 to seconds_in_day - 1 do
    let t =
      let h = s / 3600 in
      let m = s mod 3600 / 60 in
      let sec = s mod 60 in
      Time.make_exn ~hour:h ~min:m ~sec ()
    in
    if s = 0 then assert (Time.is_midnight t);
    if s = 12 * 3600 then assert (Time.is_noon t);
    if s < 12 * 3600 then assert (Time.is_am t) else assert (Time.is_pm t);
    if s >= 5 * 3600 && s <= (11 * 3600) + (59 * 60) + 59
    then assert (Time.is_morning t)
    else assert (not (Time.is_morning t));
    if s >= 12 * 3600 && s <= (16 * 3600) + (59 * 60) + 59
    then assert (Time.is_afternoon t)
    else assert (not (Time.is_afternoon t));
    if s >= 17 * 3600 && s <= (20 * 3600) + (59 * 60) + 59
    then assert (Time.is_evening t)
    else assert (not (Time.is_evening t));
    if s >= 21 * 3600 || s <= (4 * 3600) + (59 * 60) + 59
    then assert (Time.is_night t)
    else assert (not (Time.is_night t));
    if s > 0 then assert (Time.is_later ~than:Time.midnight t);
    if s < seconds_in_day - 1
    then assert (Time.is_earlier ~than:Time.end_of_day t)
  done;
  print_endline "All predicates stress test passed!";
  [%expect {| All predicates stress test passed! |}]
;;
