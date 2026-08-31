# DateTime: source code

## DateTime.py

```
venv/lib/python3.10/site-packages/robot/libraries


import datetime
import sys
import time

from robot.version import get_version
from robot.utils import (elapsed_time_to_string, secs_to_timestr, timestr_to_secs,
                         type_name)

__version__ = get_version()
__all__ = ['convert_time', 'convert_date', 'subtract_date_from_date',
           'subtract_time_from_date', 'subtract_time_from_time',
           'add_time_to_time', 'add_time_to_date', 'get_current_date']


def get_current_date(time_zone='local', increment=0, result_format='timestamp',
                     exclude_millis=False):
    if time_zone.upper() == 'LOCAL' or result_format.upper() == 'EPOCH':
        dt = datetime.datetime.now()
    elif time_zone.upper() == 'UTC':
        if sys.version_info >= (3, 12):
            # `utcnow()` was deprecated in Python 3.12. We only support "naive"
            # datetime objects and thus need to remove timezone information here.
            dt = datetime.datetime.now(datetime.UTC).replace(tzinfo=None)
        else:
            dt = datetime.datetime.utcnow()
    else:
        raise ValueError(f"Unsupported timezone '{time_zone}'.")
    date = Date(dt) + Time(increment)
    return date.convert(result_format, millis=not exclude_millis)


def convert_date(date, result_format='timestamp', exclude_millis=False,
                 date_format=None):
    return Date(date, date_format).convert(result_format, millis=not exclude_millis)


def convert_time(time, result_format='number', exclude_millis=False):
    return Time(time).convert(result_format, millis=not exclude_millis)


def subtract_date_from_date(date1, date2, result_format='number',
                            exclude_millis=False, date1_format=None,
                            date2_format=None):
    time = Date(date1, date1_format) - Date(date2, date2_format)
    return time.convert(result_format, millis=not exclude_millis)


def add_time_to_date(date, time, result_format='timestamp',
                     exclude_millis=False, date_format=None):
    date = Date(date, date_format) + Time(time)
    return date.convert(result_format, millis=not exclude_millis)


def subtract_time_from_date(date, time, result_format='timestamp',
                            exclude_millis=False, date_format=None):
    date = Date(date, date_format) - Time(time)
    return date.convert(result_format, millis=not exclude_millis)


def add_time_to_time(time1, time2, result_format='number',
                     exclude_millis=False):
    time = Time(time1) + Time(time2)
    return time.convert(result_format, millis=not exclude_millis)


def subtract_time_from_time(time1, time2, result_format='number',
                            exclude_millis=False):
    time = Time(time1) - Time(time2)
    return time.convert(result_format, millis=not exclude_millis)


class Date:

    def __init__(self, date, input_format=None):
        self.datetime = self._convert_to_datetime(date, input_format)

    @property
    def seconds(self):
        # Mainly for backwards compatibility with RF 2.9.1 and earlier.
        return self._convert_to_epoch(self.datetime)

    def _convert_to_datetime(self, date, input_format):
        if isinstance(date, datetime.datetime):
            return date
        if isinstance(date, datetime.date):
            return datetime.datetime(date.year, date.month, date.day)
        if isinstance(date, (int, float)):
            return self._epoch_seconds_to_datetime(date)
        if isinstance(date, str):
            return self._string_to_datetime(date, input_format)
        raise ValueError(f"Unsupported input '{date}'.")

    def _epoch_seconds_to_datetime(self, secs):
        return datetime.datetime.fromtimestamp(secs)

    def _string_to_datetime(self, ts, input_format):
        if not input_format:
            ts = self._normalize_timestamp(ts)
            input_format = '%Y-%m-%d %H:%M:%S.%f'
        return datetime.datetime.strptime(ts, input_format)

    def _normalize_timestamp(self, timestamp):
        numbers = ''.join(d for d in timestamp if d.isdigit())
        if not (8 <= len(numbers) <= 20):
            raise ValueError(f"Invalid timestamp '{timestamp}'.")
        d = numbers[:8]
        t = numbers[8:].ljust(12, '0')
        return f'{d[:4]}-{d[4:6]}-{d[6:8]} {t[:2]}:{t[2:4]}:{t[4:6]}.{t[6:]}'

    def convert(self, format, millis=True):
        dt = self.datetime
        if not millis:
            secs = 1 if dt.microsecond >= 5e5 else 0
            dt = dt.replace(microsecond=0) + datetime.timedelta(seconds=secs)
        if '%' in format:
            return self._convert_to_custom_timestamp(dt, format)
        format = format.lower()
        if format == 'timestamp':
            return self._convert_to_timestamp(dt, millis)
        if format == 'datetime':
            return dt
        if format == 'epoch':
            return self._convert_to_epoch(dt)
        raise ValueError(f"Unknown format '{format}'.")

    def _convert_to_custom_timestamp(self, dt, format):
        return dt.strftime(format)

    def _convert_to_timestamp(self, dt, millis=True):
        if not millis:
            return dt.strftime('%Y-%m-%d %H:%M:%S')
        ms = round(dt.microsecond / 1000)
        if ms == 1000:
            dt += datetime.timedelta(seconds=1)
            ms = 0
        return dt.strftime('%Y-%m-%d %H:%M:%S') + f'.{ms:03d}'

    def _convert_to_epoch(self, dt):
        return dt.timestamp()

    def __add__(self, other):
        if isinstance(other, Time):
            return Date(self.datetime + other.timedelta)
        raise TypeError(f'Can only add Time to Date, got {type_name(other)}.')

    def __sub__(self, other):
        if isinstance(other, Date):
            return Time(self.datetime - other.datetime)
        if isinstance(other, Time):
            return Date(self.datetime - other.timedelta)
        raise TypeError(f'Can only subtract Date or Time from Date, '
                        f'got {type_name(other)}.')


class Time:

    def __init__(self, time):
        self.seconds = float(self._convert_time_to_seconds(time))

    def _convert_time_to_seconds(self, time):
        if isinstance(time, datetime.timedelta):
            return time.total_seconds()
        return timestr_to_secs(time, round_to=None)

    @property
    def timedelta(self):
        return datetime.timedelta(seconds=self.seconds)

    def convert(self, format, millis=True):
        try:
            result_converter = getattr(self, f'_convert_to_{format.lower()}')
        except AttributeError:
            raise ValueError(f"Unknown format '{format}'.")
        seconds = self.seconds if millis else float(round(self.seconds))
        return result_converter(seconds, millis)

    def _convert_to_number(self, seconds, millis=True):
        return seconds

    def _convert_to_verbose(self, seconds, millis=True):
        return secs_to_timestr(seconds)

    def _convert_to_compact(self, seconds, millis=True):
        return secs_to_timestr(seconds, compact=True)

    def _convert_to_timer(self, seconds, millis=True):
        return elapsed_time_to_string(seconds, include_millis=millis, seconds=True)

    def _convert_to_timedelta(self, seconds, millis=True):
        return datetime.timedelta(seconds=seconds)

    def __add__(self, other):
        if isinstance(other, Time):
            return Time(self.seconds + other.seconds)
        raise TypeError(f'Can only add Time to Time, got {type_name(other)}.')

    def __sub__(self, other):
        if isinstance(other, Time):
            return Time(self.seconds - other.seconds)
        raise TypeError(f'Can only subtract Time from Time, got {type_name(other)}.')
```
