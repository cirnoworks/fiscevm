/**
 *  Copyright 2010-2015 Yuxuan Huang. All rights reserved.
 *
 * This file is part of fiscevm
 *
 * fiscevm is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * fiscevm is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with fiscevm  If not, see <http://www.gnu.org/licenses/>.
 */

#include "fy_util/String.h"
#include "fy_util/Utf8.h"
#include <stdarg.h>
FY_ATTR_EXPORT fy_str *fy_strCreatePerm(fy_memblock *mem, fisce_int size,
		fisce_exception *exception) {
	fy_str *str = fy_mmAllocatePerm(mem,
			sizeof(fy_str) + size * sizeof(fisce_char), exception);
	FYEH()NULL;
	str->length = 0;
	str->maxLength = size;
	str->status = FY_STR_PERM;
	str->content = str->staticContent;
	return str;
}

FY_ATTR_EXPORT fy_str *fy_strCreatePermFromClone(fy_memblock *mem,
		fy_str *other, fisce_int additionalSize, fisce_exception *exception) {
	fy_str *str;
	fisce_int size = other->length + additionalSize;
	str = fy_strCreatePerm(mem, size, exception);
	FYEH()NULL;
	fy_strAppend(mem, str, other, exception);
	FYEH()NULL;
	return str;
}
FY_ATTR_EXPORT fy_str *fy_strCreatePermFromSubstring(fy_memblock *mem,
		fy_str *other, fisce_int begin, fisce_int end, fisce_exception *exception) {
	fy_str *ret;

	if (begin < 0 || begin >= other->length || end < begin
			|| end > other->length) {
		fy_fault(exception, NULL,
				"Illegal arguments length=%"FY_PRINT32"d begin=%"FY_PRINT32"d end=%"FY_PRINT32"d",
				other->length, begin, end);
		FYEH()NULL;
	}
	ret = fy_mmAllocatePerm(mem, sizeof(fy_str), exception);
	FYEH()NULL;
	ret->length = end - begin;
	ret->status &= ~FY_STR_PERM;

	return ret;
}
FY_ATTR_EXPORT fy_str *fy_strCreatePermFromUTF8(fy_memblock *mem,
		const char *utf8, fisce_int additionalSize, fisce_exception *exception) {
	fy_str *str;
	fisce_int size = fy_utf8SizeS(utf8, -1) + additionalSize;
	str = fy_strCreatePerm(mem, size, exception);
	FYEH()NULL;
	fy_strAppendUTF8(mem, str, utf8, -1, exception);
	FYEH()NULL;
	return str;
}

FY_ATTR_EXPORT fy_str *fy_strInit(fy_memblock *block, fy_str *str, fisce_int size,
		fisce_exception *exception) {
	if (str->content != NULL) {
		fy_fault(exception, NULL, "duplicated initJavaString");
		return NULL;
	}
	str->length = 0;
	str->maxLength = size;
	str->content = fy_mmAllocate(block, size << 1, exception);
	str->status = 0;
	return str;
}

FY_ATTR_EXPORT void fy_strDestroy(fy_memblock *block, fy_str *string) {
	if (string->status & (FY_STR_PERM | FY_STR_PERSIST)) {
		fy_fault(NULL, NULL, "Try to destroy a static string");
	} else {
		fy_mmFree(block, string->content);
		string->length = 0;
		string->maxLength = 0;
		string->content = NULL;
	}
}

FY_ATTR_EXPORT void fy_strInitWithUTF8(fy_memblock *block, fy_str *str,
		const char *utf8, fisce_exception *exception) {
	size_t size;
	size = fy_utf8SizeS(utf8, -1);
	fy_strInit(block, str, (fisce_int)size, exception);
	FYEH();
	fy_strAppendUTF8(block, str, utf8, -1, exception);
	FYEH();
}

static fy_str *ensureSize(fy_memblock *block, fy_str *_this, fisce_int size,
		fisce_exception *exception) {
	int len;
	fisce_char *newContent;

	if (_this->maxLength < size) {
		if (_this->status & FY_STR_PERM) {
			fy_fault(exception, NULL, "Perm string overflow!");
			FYEH()NULL;
		}
		len = _this->maxLength;
		while (len < size) {
			len <<= 1;
		}
		newContent = fy_mmAllocate(block, len * sizeof(fisce_char), exception);
		FYEH()NULL;
		memcpy(newContent, _this->content, _this->length << 1);
		fy_mmFree(block, _this->content);
		_this->content = newContent;
		_this->maxLength = len;
	}
	return _this;
}

static fy_str *fy_strAppendPriv(fy_memblock *block, fy_str *_this,
		fisce_char *from, fisce_int length, fisce_exception *exception) {

	if (_this == NULL || from == NULL) {
		fy_fault(exception, NULL, "NPT");
		return NULL;
	}
	ensureSize(block, _this, _this->length + length, exception);
	FYEH()NULL;
	memcpy(_this->content + _this->length, from, length << 1);
	_this->length += length;
	_this->status &= ~FY_STR_HASHED;
	return _this;
}

FY_ATTR_EXPORT fy_str *fy_strEnsureSize(fy_memblock *block, fy_str *_this,
		fisce_int size, fisce_exception *exception) {
	if (_this->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return NULL;
	}
	return ensureSize(block, _this, size, exception);
}

FY_ATTR_EXPORT fy_str *fy_strAppendChar(fy_memblock *block, fy_str *_this,
		fisce_char ch, fisce_exception *exception) {
	if (_this->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return NULL;
	}
	return fy_strAppendPriv(block, _this, &ch, 1, exception);
}

FY_ATTR_EXPORT fy_str *fy_strAppend(fy_memblock *block, fy_str *_this,
		const fy_str *string, fisce_exception *exception) {
	if (_this->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return NULL;
	}
	return fy_strAppendPriv(block, _this, string->content, string->length,
			exception);
}

FY_ATTR_EXPORT fy_str *fy_strAppendUTF8(fy_memblock *block, fy_str *_this,
		const char *utf8, fisce_int size, fisce_exception *exception) {
	const char *inbuf = utf8;
	fisce_char outbuf;
	fisce_int sl = (fisce_int)strlen(utf8);
	if (_this->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return NULL;
	}
	if (size > sl || size < 0) {
		size = sl;
	}
	while (size > 0) {
		outbuf = fy_utf8Read(&inbuf, &size);
		fy_strAppendPriv(block, _this, &outbuf, 1, exception);
		FYEH()NULL;
	}
	return _this;
}

FY_ATTR_EXPORT fy_str *fy_strAppendVA(fy_memblock *block, fy_str *_this,
		fy_strVA *va, fisce_exception *exception) {
	fisce_int i, max = va->patternLength;
	char c;
	for (i = 0; i < max; i++) {
		c = va->pattern[i];
		switch (c) {
		case 'c':
			fy_strAppendChar(block, _this, (fisce_char) va->vars[i].c, exception);
			break;
		case 'a':
			fy_strAppendUTF8(block, _this, va->vars[i].a, -1, exception);
			break;
		case 's':
			fy_strAppend(block, _this, va->vars[i].s, exception);
			break;
		}
	}
	return _this;
}

FY_ATTR_EXPORT fy_str *fy_strSubstring(fy_memblock *block, fy_str *_this,
		fisce_int begin, fisce_int end) {
	int size = end - begin;
	int i;
	if (_this == NULL) {
		fy_fault(NULL, NULL, "Null pointer exception.");
		return NULL;
	}
	if (begin < 0 || end < 0 || end >= _this->length || begin > end) {
		fy_fault(NULL, NULL, "Index out of bound exception");
		return NULL;
	}
	if (_this->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return NULL;
	}
	_this->length = size;
	for (i = 0; i < size; i++) {
		_this->content[i] = _this->content[i + begin];
	}
	_this->status &= ~FY_STR_HASHED;
	return _this;
}

FY_ATTR_EXPORT fisce_uint fy_strUtf8Count(fy_str *str) {
	fisce_uint size = 0;
	int i, count;
	count = str->length;
	for (i = 0; i < count; i++) {
		size += fy_utf8Size(str->content[i]);
	}
	return size;
}

FY_ATTR_EXPORT fisce_int fy_strCmp(fy_str *left, fy_str *right) {
	fisce_int resultWhenEqual =
			left->length == right->length ?
					0 : (left->length > right->length ? 1 : -1);
	fisce_int len = left->length > right->length ? right->length : left->length;
	fisce_int i;
	fisce_char *lc = left->content;
	fisce_char *rc = right->content;
	fisce_int ret;
	for (i = 0; i < len; i++) {
		ret = lc[i] - rc[i];
		if (ret != 0) {
			return ret;
		}
	}
	return resultWhenEqual;
}

FY_ATTR_EXPORT fisce_int fy_strCmpVA(fy_str *left, fy_strVA *va) {
	fisce_int i, pos = 0, ret, j, maxj;
	fisce_int max = va->patternLength;
	char c;
	fisce_int resultWhenEqual =
			left->length == va->size ? 0 : (left->length > va->size ? 1 : -1);
	char *rightArray;
	fisce_char ch;
	fisce_int utf8Left;
	fy_str *rightStr;
	for (i = 0; i < max; i++) {
		c = va->pattern[i];
		switch (c) {
		case 'c':
			if (pos >= left->length) {
				return -1;
			}
			ret = left->content[pos++] - (va->vars[i]).c;
			if (ret != 0) {
				return ret;
			}
			break;
		case 'a':
			rightArray = va->vars[i].a;
			utf8Left = (fisce_int)strlen(rightArray);
			while (utf8Left > 0) {
				if (pos >= left->length) {
					return -1;
				}
				ch = fy_utf8Read((char const **) &rightArray, &utf8Left);
				ret = left->content[pos++] - ch;
				if (ret != 0) {
					return ret;
				}
			}
			break;
		case 's':
			rightStr = va->vars[i].s;
			maxj = rightStr->length;
			for (j = 0; j < maxj; j++) {
				if (pos >= left->length) {
					return -1;
				}
				ret = left->content[pos++] - rightStr->content[j];
				if (ret != 0) {
					return ret;
				}
			}
			break;
		default:
			break;
		}
	}
	return resultWhenEqual;
}

FY_ATTR_EXPORT fisce_boolean fy_strEndsWith(fy_str *_this, fy_str *right) {
	int delta;
	int i;
	if (_this->length < right->length) {
		return FALSE;
	}
	delta = _this->length - right->length;
	i = 0;
	for (i = right->length - 1; i >= 0; i--) {
		if (right->content[i] != _this->content[i + delta]) {
			return FALSE;
		}
	}
	return TRUE;
}
FY_ATTR_EXPORT void fy_strClear(fy_str *_this) {
	if (_this->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return;
	}
	_this->length = 0;
}

FY_ATTR_EXPORT fy_str *fy_strReplaceOne(fy_str *str, fisce_char from, fisce_char to) {
	int i;
	if (str->status & FY_STR_PERSIST) {
		fy_fault(NULL, NULL, "Logic error: try to clear a persisted string");
		return NULL;
	}
	for (i = str->length - 1; i >= 0; i--) {
		if (str->content[i] == from) {
			str->content[i] = to;
		}
	}
	str->status &= ~FY_STR_HASHED;
	return str;
}

FY_ATTR_EXPORT char *fy_strSPrint(char *target, size_t targetSize, const fy_str *str) {
	int i, count;
	fisce_char unicode;
	char *tmp;
	fisce_int left;
	tmp = target;
	left = (fisce_int)targetSize;
	count = str->length;
	for (i = 0; i < count; i++) {
		unicode = str->content[i];
		if (fy_utf8Write(unicode, &tmp, &left) <= 0) {
			break;
		}
	}
	if (left > 0) {
		*tmp = 0;
	} else {
		target[targetSize - 1] = 0;
	}
	return target;
}

FY_ATTR_EXPORT char *fy_strToUTF8Perm(fy_memblock *block, fy_str *from,
		fisce_exception *exception) {
	fisce_int count = fy_strUtf8Count(from) + 1;
	char *result = fy_mmAllocatePerm(block, count, exception);
	FYEH()NULL;
	fy_strSPrint(result, count, from);
	return result;
}

FY_ATTR_EXPORT fy_str *fy_strCreateClone(fy_memblock *block, fy_str *from,
		fisce_exception *exception) {
	fy_str *_this = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	fy_strInit(block, _this, from->length, exception);
	FYEH()NULL;
	fy_strAppend(block, _this, from, exception);
	FYEH()NULL;
	_this->status |= FY_STR_HASHED;
	_this->hashCode = from->hashCode;
	return _this;
}

static fisce_uint hash(fy_str *key) {
	int i, imax;
	fisce_uint ret = 0;
	for (i = 0, imax = key->length; i < imax; i++) {
		ret = (ret << 5) + (ret << 2) + (ret >> 30) + key->content[i];
	}
	return ret;
}

FY_ATTR_EXPORT fisce_uint fy_strHash(fy_str *str) {
	if (str->status & FY_STR_HASHED) {
		return str->hashCode;
	} else {
		str->status |= FY_STR_HASHED;
		return str->hashCode = hash(str);
	}
}

FY_ATTR_EXPORT fisce_uint fy_strHashVA(fy_strVA *va) {
	int i = 0;
	fisce_uint ret = 0;
	char c;
	fisce_char value;
	fy_str *str;

	char *arrayBase;
	fisce_int left;
	const char *pattern = va->pattern;
	fy_strVarStorage *vars = va->vars;

	while ((c = pattern[i]) != 0) {
		switch (c) {
		case 'c':
			ret = (ret << 5) + (ret << 2) + (ret >> 30) + (fisce_char) (vars[i].c);
			break;
		case 'a':
			arrayBase = vars[i].a;
			left = (fisce_int)strlen(arrayBase);
			while (left > 0) {
				value = fy_utf8Read((char const **) &arrayBase, &left);
				ret = (ret << 5) + (ret << 2) + (ret >> 30) + value;
			}
			break;
		case 's':
			str = vars[i].s;
			for (left = 0; left < str->length; left++) {
				ret = (ret << 5) + (ret << 2) + (ret >> 30)
						+ str->content[left];
			}
			break;
		default:
			fy_fault(NULL, NULL, "Illegal character %c in pattern %s", c,
					pattern);
			return 0;
		}
		i++;
	}

	return ret;
}

FY_ATTR_EXPORT fisce_char fy_strGet0(const fy_str *str, fisce_int pos) {
	return str->content[pos];
}

FY_ATTR_EXPORT fy_str *fy_strCreatePermPersistVA(fy_memblock *mem, fy_strVA *va,
		fisce_exception *exception) {
	char c;
	fy_str *str;
	fisce_int i;
	str = fy_strCreatePerm(mem, va->size, exception);
	FYEH()NULL;
	for (i = 0; i < va->patternLength; i++) {
		c = va->pattern[i];
		switch (c) {
		case 'c':
			/*(one char)*/
			fy_strAppendChar(mem, str, va->vars[i].c, exception);
			FYEH()NULL;
			break;
			case 'a':
			/*(char*)*/
			fy_strAppendUTF8(mem, str, va->vars[i].a, -1, exception);
			FYEH()NULL;
			break;
			case 's':
			/*(fy_str*)*/
			fy_strAppend(mem, str, va->vars[i].s, exception);
			FYEH()NULL;
			break;
			default:
			fy_fault(exception, NULL, "Illegal character %c in pattern %s", c,
					va->pattern);
			return NULL;
		}
	}
	str->status |= FY_STR_PERSIST;
	return str;
}

FY_ATTR_EXPORT fy_str *fy_strCreatePermPersist(fy_memblock *mem,
		fisce_exception *exception, const char *pattern, ...) {

	va_list arg_ptr;
	fy_strVA va[1];

	va_start(arg_ptr, pattern);
	fy_strParseVA(va, pattern, arg_ptr);
	va_end(arg_ptr);
	return fy_strCreatePermPersistVA(mem, va, exception);
}

FY_ATTR_EXPORT fy_str *fy_strCreatePermPersistClone(fy_memblock *mem,
		fy_str *from, fisce_exception *exception) {
	fy_str *ret;
	if (from->status & FY_STR_PERSIST) {
		ret = from;
#if 0
		if((fisce_ulong)from > 0x7fffffffffff0000ll) {
			int j=0;
			j++;
			j++;
		}
#endif
	} else {
		ret = fy_strCreatePermFromClone(mem, from, 0, exception);
		ret->status |= FY_STR_PERSIST;
	}
	return ret;
}

FY_ATTR_EXPORT fy_str *fy_strCreatePermPersistSubstring(fy_memblock *mem,
		fy_str *from, int begin, int end, fisce_exception *exception) {
	fy_str *str;
	if (begin < 0) {
		begin = 0;
	}
	if (end < 0) {
		end = from->length;
	}
	if (end < begin || end > from->length) {
		fy_fault(exception, NULL, "Index out of bound exception");
		return NULL;
	}
	if (from->status & FY_STR_PERSIST) {
		str = fy_strCreatePerm(mem, 0, exception);
		FYEH()NULL;
		str->content = from->content + begin;
		str->length = end - begin;
		str->maxLength = end - begin;
		str->status = FY_STR_PERM & FY_STR_PERSIST;
	} else {
		fy_fault(exception, NULL,
				"Can't make persist substring from non-persisted string.");
		return NULL;
	}
	return str;
}

FY_ATTR_EXPORT void fy_strParseV(fy_strVA *output, const char *pattern, ...) {
	va_list arg_ptr;
	va_start(arg_ptr, pattern);
	fy_strParseVA(output, pattern, arg_ptr);
	va_end(arg_ptr);
}
FY_ATTR_EXPORT void fy_strParseVA(fy_strVA *output, const char *pattern,
		va_list arg_ptr) {
	fisce_int i = 0;
	char c;
	fisce_int size = 0;
	fy_strVarStorage *vs = output->vars;
	while ((c = pattern[i]) != 0) {
		if (i >= FY_STR_MAX_VA) {
			fy_fault(NULL, NULL, "Too many var args, max is %d", FY_STR_MAX_VA);
		}
		switch (c) {
		case 'c':
			/*(one char)*/
			vs[i].c = va_arg(arg_ptr, int);
			size += 1;
			break;
		case 'a':
			/*(char*)*/
			vs[i].a = va_arg(arg_ptr, char*);
			size += fy_utf8SizeS(vs[i].a, -1);
			break;
		case 's':
			/*(fy_str*)*/
			vs[i].s = va_arg(arg_ptr, fy_str*);
			size += vs[i].s->length;
			break;
		default:
			fy_fault(NULL, NULL, "Illegal character %c in pattern %s", c,
					pattern);
			return;
		}
		i++;
	}
	memcpy(output->pattern, pattern, i + 1);
	output->patternLength = i;
	output->size = size;
}

