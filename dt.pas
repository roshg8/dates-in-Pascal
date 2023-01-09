program assign4;
uses sysutils;
{* Assignment #4
Roshnica Gurung (rgurung)
CSCI 314
*}

type
    day_range = 1..31;

    month_range = 1..12;

    date_t = record
        day : day_range;
        month : month_range;
        year : integer;
    end;

var
    d1, d2, d3 : date_t;
    format_str : string;

procedure init_date (var dt : date_t; day : day_range; month : month_range; year : integer);
{* This initializes date with the day, month, and year parameters. *}
begin
    dt.day := day;
    dt.month := month;
    dt.year := year;
end;

procedure init_date1 (var dt : date_t);
{* This initializes date with the current date.
It also declares variables for month, day, and year (of pre-defined type word) and calls DecodeDate (Date, year, month, day).
It includes ‘uses sysutils’ near beginning of program.
Date: pre-defined function that returns the current date (no parameters, so no ()’s needed)
Lastly, it assigns values in month, day, and year to corresponding fields in dt. *}
var
    day, month, year : word;

begin
    DecodeDate (Date, year, month, day);

    dt.day := day;
    dt.month := month;
    dt.year := year;
end;

function date_equal (date1 : date_t; date2 : date_t) : boolean;
{* This compares two dates and returns true if they're equal; otherwise returns false. *}
begin
    if ((date1.day = date2.day) and (date1.month = date2.month) and (date1.year = date2.year)) then
    begin
        date_equal := true;
    end
    else
    begin
        date_equal := false;
    end;
end;

function date_less_than (date1 : date_t; date2 : date_t) : boolean;
{* This compares two dates and returns true if date1 is less than date2; otherwise returns false. *}
begin
    if (date1.year < date2.year) then
    begin
        date_less_than := true;
    end
    else
    begin
        if (date1.year = date2.year) then
        begin
            if (date1.month < date2.month) then
            begin
                date_less_than := true;
            end
            else
            begin
                if (date1.month = date2.month) then
                begin
                    if (date1.day < date2.day) then
                    begin
                        date_less_than := true;
                    end
                    else
                    begin
                        date_less_than := false;
                    end;
                end
                else
                begin
                    date_less_than := false;
                end;
            end;
        end
        else
        begin
            date_less_than := false;
        end;
    end;
end;

function month_str (month : month_range) : string;
{* This returns string name corresponding to month number (through a case statement) *}
begin
    case (month) of
        1 : month_str := 'January';
        2 : month_str := 'February';
        3 : month_str := 'March';
        4 : month_str := 'April';
        5 : month_str := 'May';
        6 : month_str := 'June';
        7 : month_str := 'July';
        8 : month_str := 'August';
        9 : month_str := 'September';
        10 : month_str := 'October';
        11 : month_str := 'November';
        12 : month_str := 'December';
    end;
end;

procedure format_date (dt : date_t; var ret_str : string);
{* This formats a date into a 'month day, year' format (e.g. March 5, 2018) *}
var
    day : string;
    month : string;
    year : string;

begin
    {* month into string *}
    month := month_str(dt.month);
    {* day and year into strings *}
    str (dt.day, day);
    str (dt.year, year);
    ret_str := month + ' ' + day + ', ' + year
end;

procedure next_day (var dt : date_t);
{* This increments the current date by one day.
    Note: includes the following nested functions 
    - leap_year
    - month_length *}
var
    leap : boolean;
    length : month_range;

function leap_year (year : integer) : boolean;
{* This returns true if year is a leap year.*}
begin
    if (year mod 400 = 0) or ((year mod 4 = 0) and not (year mod 100 = 0)) then
    begin
        leap_year := true;
    end
    else
    begin
        leap_year := false;
    end;
end;

function month_length (month: month_range; leap: boolean): day_range;
{* This returns the number of days in month. *}
begin
    if (month in  [1,3,5,7,8,10,12]) then
        begin
            month_length := 31;
        end
        else
        begin
            if (month = 2) then
            begin
                if (leap = true) then
                begin
                    month_length := 29;
                end
                else
                begin
                    month_length := 28;
                end;
            end

            else
            begin
                month_length := 30;
            end;
        end;
end;
begin 
    {* This gets the next day. *}
    leap := leap_year(dt.year);
    length := month_length(dt.month,leap);

    {* This checks if it's the last day of the month. *}
    if (dt.day = length) then
    begin
    {* This checks if it's the last day of the year. *}
        if (dt.month = 12) then 
        begin
            dt.month := 1;
            dt.year := dt.year + 1;
        end
        else
        begin
            dt.month := dt.month + 1;
        end;
        dt.day := 1;
    end
    else
    begin
        dt.day := dt.day + 1;
    end;
end;



begin
    init_date1(d1);
    init_date(d2,30,12,1999);
    init_date(d3,1,1,2000);

    format_date(d1,format_str);
    writeln('d1: ' + format_str);

    format_date(d2,format_str);
    writeln('d2: ' + format_str);

    format_date(d3,format_str);
    writeln('d3: ' + format_str + ^M+^J);

    str(date_less_than(d1,d2),format_str);
    writeln('d1 < d2? ' + format_str);
    str(date_less_than(d2,d3),format_str);
    writeln('d2 < d3? ' + format_str + ^M+^J);

    next_day(d2);
    format_date(d2,format_str);
    writeln('next day d2: ' + format_str);
    str(date_less_than(d2,d3),format_str);
    writeln('d2 < d3? ' + format_str);
    str(date_equal(d2,d3),format_str);
    writeln('d2 = d3? ' + format_str);
    str(date_less_than(d3,d2),format_str);
    writeln('d2 > d3? ' + format_str + ^M+^J);

    next_day(d2);
    format_date(d2,format_str);
    writeln('next day d2: ' + format_str);
    str(date_equal(d2,d3),format_str);
    writeln('d2 = d3? ' + format_str + ^M+^J);

    init_date(d1,28,2,1529);
    format_date(d1,format_str);
    writeln('initialized d1 to: ' + format_str);
    next_day(d1);
    format_date(d1,format_str);
    writeln('next day d1: ' + format_str + ^M+^J);

    init_date(d1,28,2,1460);
    format_date(d1,format_str);
    writeln('initialized d1 to: ' + format_str);
    next_day(d1);
    format_date(d1,format_str);
    writeln('next day d1: ' + format_str + ^M+^J);

    init_date(d1,28,2,1700);
    format_date(d1,format_str);
    writeln('initialized d1 to: ' + format_str);
    next_day(d1);
    format_date(d1,format_str);
    writeln('next day d1: ' + format_str + ^M+^J);

    init_date(d1,28,2,1600);
    format_date(d1,format_str);
    writeln('initialized d1 to: ' + format_str);
    next_day(d1);
    format_date(d1,format_str);
    writeln('next day d1: ' + format_str + ^M+^J);
end.