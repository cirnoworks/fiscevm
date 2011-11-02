/**
 *  Copyright 2010-2011 Yuxuan Huang. All rights reserved.
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "fyc/Utf8.h"

juint fy_utf8Size(jchar unicode) {
	if (unicode > 0x0800) {
		return 3;
	} else if (unicode > 0x80 || unicode == 0) {
		return 2;
	} else {
		return 1;
	}
}

juint fy_utf8SizeU(char firstByte) {
	if (firstByte >= 0) {
		return 1;
	} else if (firstByte >= -16) {
		return 0;
	} else if (firstByte >= -32) {
		return 3;
	} else if (firstByte >= -64) {
		return 2;
	} else {
		return 0;
	}
}

juint fy_utf8SizeS(const char *str, jint length) {
	int i = 0;
	juint ret = 0;
	char c;
	if (length < 0) {
		while ((c = str[i]) != 0) {
			i += fy_utf8SizeU(c);
			ret += 2;
		}
	} else {
		while (i < length) {
			i += fy_utf8SizeU(str[i]);
			ret += 2;
		}
	}

	return ret;
}

jchar fy_utf8Read(const char **from, jint *left) {
	char x = *((*from)++);
		char y;
	char z;
	(*left)--;

	/*
	 * 0-127
	 *
	 * -17~-32
	 */
	switch (fy_utf8SizeU(x)) {
	case 0:
		return '?';
	case 1:
		return x;
	case 2:
		if (*left == 0) {
			return '?';
		}
		y = *((*from)++);
		--(*left);
		return ((x & 0x1f) << 6) + (y & 0x3f);
	case 3:
		if (*left == 0) {
			return '?';
		}
		y = *((*from)++);
		if (--(*left) == 0) {
			return '?';
		}
		z = *((*from)++);
		--(*left);
		return ((x & 0xf) << 12) + ((y & 0x3f) << 6) + (z & 0x3f);
	default:
		return '?';
	}
}

int fy_utf8Write(jchar unicode, char **to, jint *left) {
	switch (fy_utf8Size(unicode)) {
	case 3:
		if (*left < 3) {
			return 0;
		}
		(*left) -= 3;
		*((*to)++) = 0xE0/*0b11100000*/ + (unicode >> 12);
		*((*to)++) = 0x80/*0b10000000*/ + ((unicode >> 6) & 0x3f/*0b111111*/);
		*((*to)++) = 0x80/*0b10000000*/ + (unicode & 0x3f/* 0b111111*/);
		return 3;
	case 2:
		if (*left < 2) {
			return 0;
		}
		(*left) -= 2;
		*((*to)++) = 0xc0/*0b11000000*/ + (unicode >> 6);
		*((*to)++) = 0x80/*0b10000000*/ + (unicode & 0x3f/*0b111111*/);
		return 2;
	case 1:
		if (*left < 1) {
			return 0;
		}
		(*left) -= 1;
		*((*to)++) = (char)unicode;
		return 1;
	default:
		vm_die("ILLEGAL!");
		return -1;
	}
}