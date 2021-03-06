/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package java.util;

import java.io.Serializable;

/**
 * {@code Date} represents a specific moment in time, to the millisecond.
 *
 * @see System#currentTimeMillis
 * @see Calendar
 * @see GregorianCalendar
 * @see SimpleTimeZone
 * @see TimeZone
 */
public class Date implements Serializable, Cloneable, Comparable<Date> {

	private static final long serialVersionUID = 7523967970034938905L;

	// Used by parse()
	private static int creationYear = new Date().getYear();

	private transient long milliseconds;

	@SuppressWarnings("nls")
	private static String[] dayOfWeekNames = { "Sun", "Mon", "Tue", "Wed",
			"Thu", "Fri", "Sat" };

	@SuppressWarnings("nls")
	private static String[] monthNames = { "Jan", "Feb", "Mar", "Apr", "May",
			"Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" };

	/**
	 * Initializes this {@code Date} instance to the current date and time.
	 */
	public Date() {
		this(System.currentTimeMillis());
	}

	/**
	 * Constructs a new {@code Date} initialized to midnight in the default
	 * {@code TimeZone} on the specified date.
	 *
	 * @param year
	 *            the year, 0 is 1900.
	 * @param month
	 *            the month, 0 - 11.
	 * @param day
	 *            the day of the month, 1 - 31.
	 *
	 * @deprecated use
	 *             {@link GregorianCalendar#GregorianCalendar(int, int, int)}
	 */
	public Date(int year, int month, int day) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Constructs a new {@code Date} initialized to the specified date and time
	 * in the default {@code TimeZone}.
	 *
	 * @param year
	 *            the year, 0 is 1900.
	 * @param month
	 *            the month, 0 - 11.
	 * @param day
	 *            the day of the month, 1 - 31.
	 * @param hour
	 *            the hour of day, 0 - 23.
	 * @param minute
	 *            the minute of the hour, 0 - 59.
	 *
	 * @deprecated use
	 *             {@link GregorianCalendar#GregorianCalendar(int, int, int, int, int)}
	 */
	public Date(int year, int month, int day, int hour, int minute) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Constructs a new {@code Date} initialized to the specified date and time
	 * in the default {@code TimeZone}.
	 *
	 * @param year
	 *            the year, 0 is 1900.
	 * @param month
	 *            the month, 0 - 11.
	 * @param day
	 *            the day of the month, 1 - 31.
	 * @param hour
	 *            the hour of day, 0 - 23.
	 * @param minute
	 *            the minute of the hour, 0 - 59.
	 * @param second
	 *            the second of the minute, 0 - 59.
	 *
	 * @deprecated use
	 *             {@link GregorianCalendar#GregorianCalendar(int, int, int, int, int, int)}
	 */
	public Date(int year, int month, int day, int hour, int minute, int second) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Initializes this {@code Date} instance using the specified millisecond
	 * value. The value is the number of milliseconds since Jan. 1, 1970 GMT.
	 *
	 * @param milliseconds
	 *            the number of milliseconds since Jan. 1, 1970 GMT.
	 */
	public Date(long milliseconds) {
		this.milliseconds = milliseconds;
	}

	/**
	 * Constructs a new {@code Date} initialized to the date and time parsed
	 * from the specified String.
	 *
	 * @param string
	 *            the String to parse.
	 *
	 * @deprecated use {@link DateFormat}
	 */
	public Date(String string) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns if this {@code Date} is after the specified Date.
	 *
	 * @param date
	 *            a Date instance to compare.
	 * @return {@code true} if this {@code Date} is after the specified
	 *         {@code Date}, {@code false} otherwise.
	 */
	public boolean after(Date date) {
		return milliseconds > date.milliseconds;
	}

	/**
	 * Returns if this {@code Date} is before the specified Date.
	 *
	 * @param date
	 *            a {@code Date} instance to compare.
	 * @return {@code true} if this {@code Date} is before the specified
	 *         {@code Date}, {@code false} otherwise.
	 */
	public boolean before(Date date) {
		return milliseconds < date.milliseconds;
	}

	/**
	 * Returns a new {@code Date} with the same millisecond value as this
	 * {@code Date}.
	 *
	 * @return a shallow copy of this {@code Date}.
	 *
	 * @see java.lang.Cloneable
	 */
	@Override
	public Object clone() {
		try {
			return super.clone();
		} catch (CloneNotSupportedException e) {
			return null;
		}
	}

	/**
	 * Compare the receiver to the specified {@code Date} to determine the
	 * relative ordering.
	 *
	 * @param date
	 *            a {@code Date} to compare against.
	 * @return an {@code int < 0} if this {@code Date} is less than the
	 *         specified {@code Date}, {@code 0} if they are equal, and an
	 *         {@code int > 0} if this {@code Date} is greater.
	 */
	public int compareTo(Date date) {
		if (milliseconds < date.milliseconds) {
			return -1;
		}
		if (milliseconds == date.milliseconds) {
			return 0;
		}
		return 1;
	}

	/**
	 * Compares the specified object to this {@code Date} and returns if they
	 * are equal. To be equal, the object must be an instance of {@code Date}
	 * and have the same millisecond value.
	 *
	 * @param object
	 *            the object to compare with this object.
	 * @return {@code true} if the specified object is equal to this
	 *         {@code Date}, {@code false} otherwise.
	 *
	 * @see #hashCode
	 */
	@Override
	public boolean equals(Object object) {
		return (object == this) || (object instanceof Date)
				&& (milliseconds == ((Date) object).milliseconds);
	}

	/**
	 * Returns the gregorian calendar day of the month for this {@code Date}
	 * object.
	 *
	 * @return the day of the month.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.DATE)}
	 */
	public int getDate() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the gregorian calendar day of the week for this {@code Date}
	 * object.
	 *
	 * @return the day of the week.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.DAY_OF_WEEK)}
	 */
	public int getDay() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the gregorian calendar hour of the day for this {@code Date}
	 * object.
	 *
	 * @return the hour of the day.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.HOUR_OF_DAY)}
	 */
	public int getHours() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the gregorian calendar minute of the hour for this {@code Date}
	 * object.
	 *
	 * @return the minutes.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.MINUTE)}
	 */
	public int getMinutes() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the gregorian calendar month for this {@code Date} object.
	 *
	 * @return the month.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.MONTH)}
	 */
	public int getMonth() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the gregorian calendar second of the minute for this {@code Date}
	 * object.
	 *
	 * @return the seconds.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.SECOND)}
	 */
	public int getSeconds() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns this {@code Date} as a millisecond value. The value is the number
	 * of milliseconds since Jan. 1, 1970, midnight GMT.
	 *
	 * @return the number of milliseconds since Jan. 1, 1970, midnight GMT.
	 */
	public long getTime() {
		return milliseconds;
	}

	/**
	 * Returns the timezone offset in minutes of the default {@code TimeZone}.
	 *
	 * @return the timezone offset in minutes of the default {@code TimeZone}.
	 *
	 * @deprecated use
	 *             {@code (Calendar.get(Calendar.ZONE_OFFSET) + Calendar.get(Calendar.DST_OFFSET)) / 60000}
	 */
	public int getTimezoneOffset() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the gregorian calendar year since 1900 for this {@code Date}
	 * object.
	 *
	 * @return the year - 1900.
	 *
	 * @deprecated use {@code Calendar.get(Calendar.YEAR) - 1900}
	 */
	public int getYear() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns an integer hash code for the receiver. Objects which are equal
	 * return the same value for this method.
	 *
	 * @return this {@code Date}'s hash.
	 *
	 * @see #equals
	 */
	@Override
	public int hashCode() {
		return (int) (milliseconds >>> 32) ^ (int) milliseconds;
	}

	private static int parse(String string, String[] array) {
		for (int i = 0, alength = array.length, slength = string.length(); i < alength; i++) {
			if (string.regionMatches(true, 0, array[i], 0, slength)) {
				return i;
			}
		}
		return -1;
	}

	/**
	 * Sets the gregorian calendar day of the month for this {@code Date}
	 * object.
	 *
	 * @param day
	 *            the day of the month.
	 *
	 * @deprecated use {@code Calendar.set(Calendar.DATE, day)}
	 */
	public void setDate(int day) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Sets the gregorian calendar hour of the day for this {@code Date} object.
	 *
	 * @param hour
	 *            the hour of the day.
	 *
	 * @deprecated use {@code Calendar.set(Calendar.HOUR_OF_DAY, hour)}
	 */
	public void setHours(int hour) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Sets the gregorian calendar minute of the hour for this {@code Date}
	 * object.
	 *
	 * @param minute
	 *            the minutes.
	 *
	 * @deprecated use {@code Calendar.set(Calendar.MINUTE, minute)}
	 */
	public void setMinutes(int minute) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Sets the gregorian calendar month for this {@code Date} object.
	 *
	 * @param month
	 *            the month.
	 *
	 * @deprecated use {@code Calendar.set(Calendar.MONTH, month)}
	 */
	public void setMonth(int month) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Sets the gregorian calendar second of the minute for this {@code Date}
	 * object.
	 *
	 * @param second
	 *            the seconds.
	 *
	 * @deprecated use {@code Calendar.set(Calendar.SECOND, second)}
	 */
	public void setSeconds(int second) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Sets this {@code Date} to the specified millisecond value. The value is
	 * the number of milliseconds since Jan. 1, 1970 GMT.
	 *
	 * @param milliseconds
	 *            the number of milliseconds since Jan. 1, 1970 GMT.
	 */
	public void setTime(long milliseconds) {
		this.milliseconds = milliseconds;
	}

	/**
	 * Sets the gregorian calendar year since 1900 for this {@code Date} object.
	 *
	 * @param year
	 *            the year since 1900.
	 *
	 * @deprecated use {@code Calendar.set(Calendar.YEAR, year + 1900)}
	 */
	public void setYear(int year) {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the string representation of this {@code Date} in GMT in the
	 * format: 22 Jun 1999 13:02:00 GMT
	 *
	 * @return the string representation of this {@code Date} in GMT.
	 *
	 * @deprecated use {@link DateFormat}
	 */
	public String toGMTString() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the string representation of this {@code Date} for the default
	 * {@code Locale}.
	 *
	 * @return the string representation of this {@code Date} for the default
	 *         {@code Locale}.
	 *
	 * @deprecated use {@link DateFormat}
	 */
	public String toLocaleString() {
		throw new IllegalArgumentException("Method deprecated");
	}

	/**
	 * Returns the string representation of this {@code Date} in the format: Tue
	 * Jun 22 13:07:00 GMT 1999
	 *
	 * @return the string representation of this {@code Date}.
	 */
	@Override
	public String toString() {
		return String.valueOf(milliseconds);
	}

	private String toTwoDigits(int digit) {
		if (digit >= 10) {
			return "" + digit;//$NON-NLS-1$
		} else {
			return "0" + digit;//$NON-NLS-1$
		}
	}

	/**
	 * Returns the millisecond value of the specified date and time in GMT.
	 *
	 * @param year
	 *            the year, 0 is 1900.
	 * @param month
	 *            the month, 0 - 11.
	 * @param day
	 *            the day of the month, 1 - 31.
	 * @param hour
	 *            the hour of day, 0 - 23.
	 * @param minute
	 *            the minute of the hour, 0 - 59.
	 * @param second
	 *            the second of the minute, 0 - 59.
	 * @return the date and time in GMT in milliseconds.
	 *
	 * @deprecated use: <code>
	 *  Calendar cal = new GregorianCalendar(TimeZone.getTimeZone("GMT"));
	 *  cal.set(year + 1900, month, day, hour, minute, second);
	 *  cal.getTime().getTime();</code>
	 */
	public static long UTC(int year, int month, int day, int hour, int minute,
			int second) {
		throw new IllegalArgumentException("Method deprecated");
	}

	private static int zone(String text) {
		if (text.equals("EST")) { //$NON-NLS-1$
			return -5;
		}
		if (text.equals("EDT")) { //$NON-NLS-1$
			return -4;
		}
		if (text.equals("CST")) { //$NON-NLS-1$
			return -6;
		}
		if (text.equals("CDT")) { //$NON-NLS-1$
			return -5;
		}
		if (text.equals("MST")) { //$NON-NLS-1$
			return -7;
		}
		if (text.equals("MDT")) { //$NON-NLS-1$
			return -6;
		}
		if (text.equals("PST")) { //$NON-NLS-1$
			return -8;
		}
		if (text.equals("PDT")) { //$NON-NLS-1$
			return -7;
		}
		return 0;
	}

}
