(* Copyright (c) 2026, Cargocut and the Lunar developers.
   All rights reserved.

   SPDX-License-Identifier: BSD-3-Clause *)

open Test_util

let%expect_test "from_int" =
  [ 1; 2; 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 0; 13; -2; 2000; 42 ]
  |> List.map Month.from_int
  |> List.iter dump_month_validation;
  [%expect
    {|
    ok: january
    ok: february
    ok: march
    ok: april
    ok: may
    ok: june
    ok: july
    ok: august
    ok: september
    ok: october
    ok: november
    ok: december
    error: invalid month number: 0
    error: invalid month number: 13
    error: invalid month number: -2
    error: invalid month number: 2000
    error: invalid month number: 42
    |}]
;;

let%expect_test "Month succ" =
  Month.all |> List.map Month.succ |> List.iter dump_month;
  [%expect
    {|
    february
    march
    april
    may
    june
    july
    august
    september
    october
    november
    december
    january
    |}]
;;

let%expect_test "Month pred" =
  Month.all |> List.map Month.pred |> List.iter dump_month;
  [%expect
    {|
    december
    january
    february
    march
    april
    may
    june
    july
    august
    september
    october
    november
    |}]
;;

let%expect_test "Month from_string" =
  [ "Jan"
  ; "Feb"
  ; "Mar"
  ; "Apr"
  ; "May"
  ; "Jun"
  ; "Jul"
  ; "Aug"
  ; "Sep"
  ; " Oct"
  ; "Nov"
  ; "Dec"
  ; "december"
  ; "january"
  ; "february"
  ; "march"
  ; "april"
  ; "may"
  ; "june"
  ; "july"
  ; "august"
  ; "september"
  ; "october"
  ; "november"
  ; "   JaN"
  ; "feb  "
  ; "auGust  "
  ; "fobar"
  ]
  |> List.map Month.from_string
  |> List.iter dump_month_validation;
  [%expect
    {|
    ok: january
    ok: february
    ok: march
    ok: april
    ok: may
    ok: june
    ok: july
    ok: august
    ok: september
    ok: october
    ok: november
    ok: december
    ok: december
    ok: january
    ok: february
    ok: march
    ok: april
    ok: may
    ok: june
    ok: july
    ok: august
    ok: september
    ok: october
    ok: november
    ok: january
    ok: february
    ok: august
    error: invalid month string: fobar
    |}]
;;

let%expect_test "days_in for leap years" =
  let years = [ 1600; 1704; 1808; 1912; 1996; 2000; 2024; 2048; 2400; 2800 ] in
  List.iter
    (fun year ->
       Month.all
       |> List.map (fun m -> m, Month.days_in ~year m)
       |> List.iter (fun (month, days) ->
         string_of_int year
         ^ "/"
         ^ Month.to_short_string month
         ^ ": "
         ^ string_of_int days
         |> print_endline))
    years;
  [%expect
    {|
    1600/jan: 31
    1600/feb: 29
    1600/mar: 31
    1600/apr: 30
    1600/may: 31
    1600/jun: 30
    1600/jul: 31
    1600/aug: 31
    1600/sep: 30
    1600/oct: 31
    1600/nov: 30
    1600/dec: 31
    1704/jan: 31
    1704/feb: 29
    1704/mar: 31
    1704/apr: 30
    1704/may: 31
    1704/jun: 30
    1704/jul: 31
    1704/aug: 31
    1704/sep: 30
    1704/oct: 31
    1704/nov: 30
    1704/dec: 31
    1808/jan: 31
    1808/feb: 29
    1808/mar: 31
    1808/apr: 30
    1808/may: 31
    1808/jun: 30
    1808/jul: 31
    1808/aug: 31
    1808/sep: 30
    1808/oct: 31
    1808/nov: 30
    1808/dec: 31
    1912/jan: 31
    1912/feb: 29
    1912/mar: 31
    1912/apr: 30
    1912/may: 31
    1912/jun: 30
    1912/jul: 31
    1912/aug: 31
    1912/sep: 30
    1912/oct: 31
    1912/nov: 30
    1912/dec: 31
    1996/jan: 31
    1996/feb: 29
    1996/mar: 31
    1996/apr: 30
    1996/may: 31
    1996/jun: 30
    1996/jul: 31
    1996/aug: 31
    1996/sep: 30
    1996/oct: 31
    1996/nov: 30
    1996/dec: 31
    2000/jan: 31
    2000/feb: 29
    2000/mar: 31
    2000/apr: 30
    2000/may: 31
    2000/jun: 30
    2000/jul: 31
    2000/aug: 31
    2000/sep: 30
    2000/oct: 31
    2000/nov: 30
    2000/dec: 31
    2024/jan: 31
    2024/feb: 29
    2024/mar: 31
    2024/apr: 30
    2024/may: 31
    2024/jun: 30
    2024/jul: 31
    2024/aug: 31
    2024/sep: 30
    2024/oct: 31
    2024/nov: 30
    2024/dec: 31
    2048/jan: 31
    2048/feb: 29
    2048/mar: 31
    2048/apr: 30
    2048/may: 31
    2048/jun: 30
    2048/jul: 31
    2048/aug: 31
    2048/sep: 30
    2048/oct: 31
    2048/nov: 30
    2048/dec: 31
    2400/jan: 31
    2400/feb: 29
    2400/mar: 31
    2400/apr: 30
    2400/may: 31
    2400/jun: 30
    2400/jul: 31
    2400/aug: 31
    2400/sep: 30
    2400/oct: 31
    2400/nov: 30
    2400/dec: 31
    2800/jan: 31
    2800/feb: 29
    2800/mar: 31
    2800/apr: 30
    2800/may: 31
    2800/jun: 30
    2800/jul: 31
    2800/aug: 31
    2800/sep: 30
    2800/oct: 31
    2800/nov: 30
    2800/dec: 31
    |}]
;;

let%expect_test "days_in for non-leap years" =
  let years = [ 1601; 1705; 1809; 1913; 1997; 2001; 2025; 2049; 2401; 2801 ] in
  List.iter
    (fun year ->
       Month.all
       |> List.map (fun m -> m, Month.days_in ~year m)
       |> List.iter (fun (month, days) ->
         string_of_int year
         ^ "/"
         ^ Month.to_short_string month
         ^ ": "
         ^ string_of_int days
         |> print_endline))
    years;
  [%expect
    {|
    1601/jan: 31
    1601/feb: 28
    1601/mar: 31
    1601/apr: 30
    1601/may: 31
    1601/jun: 30
    1601/jul: 31
    1601/aug: 31
    1601/sep: 30
    1601/oct: 31
    1601/nov: 30
    1601/dec: 31
    1705/jan: 31
    1705/feb: 28
    1705/mar: 31
    1705/apr: 30
    1705/may: 31
    1705/jun: 30
    1705/jul: 31
    1705/aug: 31
    1705/sep: 30
    1705/oct: 31
    1705/nov: 30
    1705/dec: 31
    1809/jan: 31
    1809/feb: 28
    1809/mar: 31
    1809/apr: 30
    1809/may: 31
    1809/jun: 30
    1809/jul: 31
    1809/aug: 31
    1809/sep: 30
    1809/oct: 31
    1809/nov: 30
    1809/dec: 31
    1913/jan: 31
    1913/feb: 28
    1913/mar: 31
    1913/apr: 30
    1913/may: 31
    1913/jun: 30
    1913/jul: 31
    1913/aug: 31
    1913/sep: 30
    1913/oct: 31
    1913/nov: 30
    1913/dec: 31
    1997/jan: 31
    1997/feb: 28
    1997/mar: 31
    1997/apr: 30
    1997/may: 31
    1997/jun: 30
    1997/jul: 31
    1997/aug: 31
    1997/sep: 30
    1997/oct: 31
    1997/nov: 30
    1997/dec: 31
    2001/jan: 31
    2001/feb: 28
    2001/mar: 31
    2001/apr: 30
    2001/may: 31
    2001/jun: 30
    2001/jul: 31
    2001/aug: 31
    2001/sep: 30
    2001/oct: 31
    2001/nov: 30
    2001/dec: 31
    2025/jan: 31
    2025/feb: 28
    2025/mar: 31
    2025/apr: 30
    2025/may: 31
    2025/jun: 30
    2025/jul: 31
    2025/aug: 31
    2025/sep: 30
    2025/oct: 31
    2025/nov: 30
    2025/dec: 31
    2049/jan: 31
    2049/feb: 28
    2049/mar: 31
    2049/apr: 30
    2049/may: 31
    2049/jun: 30
    2049/jul: 31
    2049/aug: 31
    2049/sep: 30
    2049/oct: 31
    2049/nov: 30
    2049/dec: 31
    2401/jan: 31
    2401/feb: 28
    2401/mar: 31
    2401/apr: 30
    2401/may: 31
    2401/jun: 30
    2401/jul: 31
    2401/aug: 31
    2401/sep: 30
    2401/oct: 31
    2401/nov: 30
    2401/dec: 31
    2801/jan: 31
    2801/feb: 28
    2801/mar: 31
    2801/apr: 30
    2801/may: 31
    2801/jun: 30
    2801/jul: 31
    2801/aug: 31
    2801/sep: 30
    2801/oct: 31
    2801/nov: 30
    2801/dec: 31
    |}]
;;
