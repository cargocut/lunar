> [!WARNING]  
> This project is still **highly experimental**, but we would be
> delighted to receive feedback (but please be careful with
> production).

# lunar

> Lunar is a very small date management library to facilitate the
> development of applications that need to make use of dates and
> times. 

From a business perspective, Lunar could be described as a composable
library for manipulating dates, timestamps, and ranges using a
proleptic [Gregorian
representation](https://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar).

## What does Lunar offer

- Working with `Time`, `Date`, `Datetime` and `Zoned_datetime`
- Range over `comparable` elements
- Arithmetic and truncation operations

The **smallest unit of measurement in Lunar is the second**, so this
library is not intended for high-precision calculations (but rather
serves as a foundation for describing applications centered around
calendars so it also **does not support negative years or leap
seconds**).

> [!IMPORTANT]  
> At the moment, parsing tools and (_available_) encoded time zones
> are very limited.
