grammar Date;

options {
  output=AST;
}

tokens {
  DATE_TIME;
  RELATIVE_DATE;
  EXPLICIT_DATE;
  AM_PM;
  ERA;
  EXPLICIT_TIME;
  DIRECTION;
  MONTH;
  DAY;
  YEAR;
  DAY_OF_WEEK;
  INTEGER;
  DAY_SEEK;
  WEEK_SEEK;
}

@header { package com.natty.parse; }

@lexer::header { package com.natty.parse; }

datetime 
  // time first: 10 am next wednesday
  : time? 'on'? date -> ^(DATE_TIME date time?)
  
  // date first: tomorrow at noon
  | date 'at'? time -> ^(DATE_TIME date time)
  
  // time only, we use today for the date
  | time -> ^(DATE_TIME ^(RELATIVE_DATE DIRECTION[">"] INTEGER["0"]) time)
  ;

date
  : relative_date 
  | explicit_date
  ;
  
time
  : explicit_time
  ;

//an explicit date with a relative year when omitted.
explicit_date
  // January 2, 1980
  : month day ','? numeric_year? -> ^(EXPLICIT_DATE month day numeric_year?)
  
  // 28th of February 1979
  | day 'of' month ','? numeric_year? -> ^(EXPLICIT_DATE month day numeric_year?)
  
  // month before year
  // 1979-2-28, 02/28, etc.
  | (FOUR_DIGITS date_separator)? numeric_month date_separator numeric_day -> 
    ^(EXPLICIT_DATE numeric_month numeric_day FOUR_DIGITS?)
  
  // year before month 
  // 10/10/2009, 10-10-09, etc.
  | numeric_month date_separator numeric_day date_separator numeric_year -> 
    ^(EXPLICIT_DATE numeric_month numeric_day numeric_year)
  ;

//a date relative to the current date
relative_date
  // today, tomorrow, yesterday, day after tomorrow
  : today_or_tomorrow
  
  | 'this'? relative_prefix prefixable_target -> ^(RELATIVE_DATE relative_prefix prefixable_target)
  
  // in 3 days, 6 days from now
  //| 'in' integer 'days' -> ^(RELATIVE_DATE DIRECTION[">"] integer) 
  //| integer 'days' 'from now'? -> ^(RELATIVE_DATE DIRECTION[">"] integer) 
  
  // 2 days ago
  //| integer 'days' 'ago' -> ^(RELATIVE_DATE DIRECTION["<"] integer)
  ;
  
// an explicit time with implicit minutes when omitted 
explicit_time 
  // no minutes with optional indicator: 10 a, 12pm, 10
  : hours meridian_indicator? -> ^(EXPLICIT_TIME hours INTEGER["0"] meridian_indicator?)
  
  //  separator and minutes with optional indicator: 10:05 a, 12:10 pm, 10:00
  | hours ':' minutes meridian_indicator? -> ^(EXPLICIT_TIME hours minutes meridian_indicator?)
  
  | time_identifier -> time_identifier
  ;

// relaxed am or pm meridian indicator
meridian_indicator
  : 'am' -> AM_PM["am"]
  | 'a'  -> AM_PM["am"]
  | 'pm' -> AM_PM["pm"]
  | 'p'  -> AM_PM["pm"]
  ;

date_separator
  : '-'
  | '/'
  ;
  
relative_prefix
  : 'last'     -> DIRECTION["<"] WEEK_SEEK
  | 'next'     -> DIRECTION[">"] WEEK_SEEK
  | 'past'     -> DIRECTION["<"] DAY_SEEK
  | 'coming'   -> DIRECTION[">"] DAY_SEEK
  | 'upcoming' -> DIRECTION[">"] DAY_SEEK
  ;
  
prefixable_target
  : day_of_week 
  | date_frame 
  ;
  
// a regular language, possibly shortened day of the week
day_of_week
  : 'monday'    -> DAY_OF_WEEK["2"]
  | 'mon'       -> DAY_OF_WEEK["2"]
  | 'tuesday'   -> DAY_OF_WEEK["3"]
  | 'tue'       -> DAY_OF_WEEK["3"]
  | 'tues'      -> DAY_OF_WEEK["3"]
  | 'wednesday' -> DAY_OF_WEEK["4"]
  | 'wed'       -> DAY_OF_WEEK["4"]
  | 'thursday'  -> DAY_OF_WEEK["5"]
  | 'thur'      -> DAY_OF_WEEK["5"]
  | 'thurs'     -> DAY_OF_WEEK["5"]
  | 'friday'    -> DAY_OF_WEEK["6"]
  | 'fri'       -> DAY_OF_WEEK["6"]
  | 'saturday'  -> DAY_OF_WEEK["7"]
  | 'sat'       -> DAY_OF_WEEK["7"]
  | 'weekend'   -> DAY_OF_WEEK["7"]
  | 'sunday'    -> DAY_OF_WEEK["1"]
  | 'sun'       -> DAY_OF_WEEK["1"]
  ;
  
// a regular language day of the month
day
  : 'first'                 -> DAY["1"]
  | '1st'                   -> DAY["1"]
  | 'second'                -> DAY["2"]
  | '2nd'                   -> DAY["2"]
  | 'third'                 -> DAY["3"]
  | '3rd'                   -> DAY["3"]
  | 'fourth'                -> DAY["4"]
  | '4th'                   -> DAY["4"]
  | 'fifth'                 -> DAY["5"]
  | '5th'                   -> DAY["5"]
  | 'sixth'                 -> DAY["6"]
  | '6th'                   -> DAY["6"]
  | 'seventh'               -> DAY["7"]
  | '7th'                   -> DAY["7"]
  | 'eighth'                -> DAY["8"]
  | '8th'                   -> DAY["8"]
  | 'ninth'                 -> DAY["9"]
  | '9th'                   -> DAY["9"]
  | 'tenth'                 -> DAY["10"]
  | '10th'                  -> DAY["10"]
  | 'eleventh'              -> DAY["11"]
  | '11th'                  -> DAY["11"]
  | 'twelfth'               -> DAY["12"]
  | '12th'                  -> DAY["12"]
  | 'thirteenth'            -> DAY["13"]
  | '13th'                  -> DAY["13"]
  | 'fourteenth'            -> DAY["14"]
  | '14th'                  -> DAY["14"]
  | 'fifteenth'             -> DAY["15"]
  | '15th'                  -> DAY["15"]
  | 'sixteenth'             -> DAY["16"]
  | '16th'                  -> DAY["16"]
  | 'seventeenth'           -> DAY["17"]
  | '17th'                  -> DAY["17"]
  | 'eighteenth'            -> DAY["18"]
  | '18th'                  -> DAY["18"]
  | 'nineteenth'            -> DAY["19"]
  | '19th'                  -> DAY["19"]
  | 'twentieth'             -> DAY["20"]
  | '20th'                  -> DAY["20"]
  | 'twenty' '-'? 'first'   -> DAY["21"]
  | '21st'                  -> DAY["21"]
  | 'twenty' '-'? 'second'  -> DAY["22"]
  | '22nd'                  -> DAY["22"]
  | 'twenty' '-'? 'third'   -> DAY["23"]
  | '23rd'                  -> DAY["23"]
  | 'twenty' '-'? 'fourth'  -> DAY["24"]
  | '24th'                  -> DAY["24"]
  | 'twenty' '-'? 'fifth'   -> DAY["25"]
  | '25th'                  -> DAY["25"]
  | 'twenty' '-'? 'sixth'   -> DAY["26"]
  | '26th'                  -> DAY["26"]
  | 'twenty' '-'? 'seventh' -> DAY["27"]
  | '27th'                  -> DAY["27"]
  | 'twenty' '-'? 'eighth'  -> DAY["28"]
  | '28th'                  -> DAY["28"]
  | 'twenty' '-'? 'ninth'   -> DAY["29"]
  | '29th'                  -> DAY["29"]
  | 'thirtieth'             -> DAY["30"]
  | '30th'                  -> DAY["30"]
  | 'thirty' '-'? 'first'   -> DAY["31"]
  | '31st'                  -> DAY["31"]
  ;

// a regular language, possibly shortened month name
month
  : 'january'  -> MONTH["1"]
  | 'jan'      -> MONTH["1"]
  | 'february' -> MONTH["2"]
  | 'feb'      -> MONTH["2"]
  | 'march'    -> MONTH["3"]
  | 'mar'      -> MONTH["3"]
  | 'april'    -> MONTH["4"]
  | 'apr'      -> MONTH["4"]
  | 'may'      -> MONTH["5"]
  | 'june'     -> MONTH["6"]
  | 'jun'      -> MONTH["6"]
  | 'july'     -> MONTH["7"]
  | 'jul'      -> MONTH["7"]
  | 'august'   -> MONTH["8"]
  | 'aug'      -> MONTH["8"]
  | 'september'-> MONTH["9"]
  | 'sep'      -> MONTH["9"]
  | 'october'  -> MONTH["10"]
  | 'oct'      -> MONTH["10"]
  | 'november' -> MONTH["11"]
  | 'nov'      -> MONTH["11"]
  | 'december' -> MONTH["12"]
  | 'dec'      -> MONTH["12"]
  ;
  
// common day identifiers (today, tomorrow, etc)
today_or_tomorrow
  : 'today' -> ^(RELATIVE_DATE DIRECTION[">"] INTEGER["0"])
  | tomorrow
  
  // yesterday
  | 'yesterday' -> ^(RELATIVE_DATE DIRECTION["<"] INTEGER["1"])
  
  // to humor the end of the world theorists
  | 'the'? 'day after ' tomorrow -> ^(RELATIVE_DATE DIRECTION[">"] INTEGER["2"])
  | 'the'? 'day before yesterday' -> ^(RELATIVE_DATE DIRECTION["<"] INTEGER["2"])
  ;
  
tomorrow
  : ('tomorow' | 'tomorrow' | 'tommorow' | 'tommorrow') 
    -> ^(RELATIVE_DATE DIRECTION[">"] INTEGER["1"])
  ;

// common time identifiers (noon, midnight, etc)
time_identifier
  : 'midnight' -> ^(EXPLICIT_TIME INTEGER["12"] INTEGER["0"] AM_PM["am"])
  | 'noon' -> ^(EXPLICIT_TIME INTEGER["12"] INTEGER["0"] AM_PM["pm"])
  ;

// a number between 1 and 31, 0 prefix optional for numbers 1 through 9
numeric_day
  : ONE_TO_TWELVE
  | THIRTEEN_TO_TWENTY_FOUR
  | TWENTY_FIVE_TO_THIRTY_ONE
  ;

// a number between 1 and 12, 0 prefix optional for numbers 1 through 9
numeric_month
  : ONE_TO_TWELVE
  ;
  
// a number between 1 and 9999, 0 prefix(es) optional for numbers 1 through 999.
// additionally, two digit years may have an optional ' prefix, and four digit 
// years may have an optional ad/bc suffux
numeric_year
  : '\''? up_to_two_digits -> YEAR[$up_to_two_digits.text]
  | ('in' 'the' YEAR_DATE_FRAME)? up_to_four_digits era? -> YEAR[$up_to_four_digits.text] era?
  ;

era
  : 'ad' -> ERA["ad"]
  | 'bc' -> ERA["bc"]
  ;
  
hours
  : TWO_ZEROS
  | ONE_TO_TWELVE
  | THIRTEEN_TO_TWENTY_FOUR
  ;
  
minutes
  : TWO_ZEROS
  | ONE_TO_TWELVE
  | THIRTEEN_TO_TWENTY_FOUR
  | TWENTY_FIVE_TO_THIRTY_ONE
  | THIRTY_TWO_TO_FIFTY_NINE
  ;
  
// any two subsequnt digits
up_to_two_digits
  : TWO_ZEROS
  | ONE_TO_TWELVE
  | THIRTEEN_TO_TWENTY_FOUR
  | TWENTY_FIVE_TO_THIRTY_ONE
  | THIRTY_TWO_TO_FIFTY_NINE
  | SIXTY_TO_NINETY_NINE
  ;
  
up_to_four_digits
  : up_to_two_digits
  | THREE_DIGITS
  | FOUR_DIGITS
  ;
  
integer
  : up_to_two_digits -> INTEGER[$up_to_two_digits.text]
  | digits=(DIGIT DIGIT DIGIT+) -> INTEGER[$digits.text]
  ;
  
date_frame
  : 'week'
  | 'month'
  | YEAR_DATE_FRAME
  ;
  
YEAR_DATE_FRAME
  : 'year'  
  ;
  
// two subsequent zeros
TWO_ZEROS
  : '0' '0'
  ;
  
// a number between 1 and 12, 0 prefix optional for numbers 1 through 9
ONE_TO_TWELVE
  : '0'? '1'..'9'
  | '1' '0'..'2'
  ;
  
// a number between 13 and 24, inclusive
THIRTEEN_TO_TWENTY_FOUR
  : '1' '3'..'9'
  | '2' '0'..'4'
  ;
  
// a number between 25 and 31, inclusive
TWENTY_FIVE_TO_THIRTY_ONE
  : '2' '5'..'9'
  | '3' '0'..'1'
  ;
  
// a number between 32 and 59, inclusive
THIRTY_TWO_TO_FIFTY_NINE
  : '3' '2'..'9'
  | '4'..'5' DIGIT 
  ;
  
// a number between 60 and 99, inclusive
SIXTY_TO_NINETY_NINE
  : '6'..'9' DIGIT
  ;
  
// any four subsequent digits
FOUR_DIGITS
  : DIGIT DIGIT DIGIT DIGIT
  ;
  
// any three subsequent digits
THREE_DIGITS
  : DIGIT DIGIT DIGIT
  ;
  
WHITE_SPACE
  : (' ' | '\t' | '\n' | '\r')+ { $channel=HIDDEN; }
  ;
  
fragment DIGIT
  : '0'..'9'
  ;