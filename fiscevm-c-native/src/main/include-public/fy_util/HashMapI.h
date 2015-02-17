/**
 *  Copyright 2010-2013 Yuxuan Huang. All rights reserved.
 *
 * This file is part of fiscevm
 *
 *fiscevmis free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 *fiscevmis distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with fiscevm  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef FY_HASHMAPI_H_
#define FY_HASHMAPI_H_

#include "fy_util/Portable.h"
#include "fy_util/MemMan.h"

#ifdef	__cplusplus
extern "C" {
#endif

typedef struct fy_hashMapI {
	fy_char loadFactor;
	fy_char perm;
	fy_uint bucketsFact;
	fy_uint bucketsSizeM1;
	void **buckets;
	fy_uint size;
	fy_int nullValue;
} fy_hashMapI;

FY_ATTR_EXPORT void fy_hashMapIInit(fy_memblock *mem, fy_hashMapI *this,
		fy_uint initSize, fy_uint loadFactor, fy_int nullValue,
		fy_exception *exception);
FY_ATTR_EXPORT void fy_hashMapIInitPerm(fy_memblock *mem, fy_hashMapI *this,
		fy_uint initFact, fy_int nullValue, fy_exception *exception);
FY_ATTR_EXPORT fy_int fy_hashMapIPut(fy_memblock *mem, fy_hashMapI *this,
		fy_int, fy_int, fy_exception *exception);
FY_ATTR_EXPORT fy_int fy_hashMapIRemove(fy_memblock *mem, fy_hashMapI *this,
		fy_int key);
FY_ATTR_EXPORT fy_int fy_hashMapIGet(fy_memblock *mem, fy_hashMapI *this,
		fy_int key);
FY_ATTR_EXPORT fy_int fy_hashMapIInc(fy_memblock *mem, fy_hashMapI *this,
		fy_int key, fy_int value, fy_exception *exception);
FY_ATTR_EXPORT void fy_hashMapIDestroy(fy_memblock *mem, fy_hashMapI *this);
FY_ATTR_EXPORT void fy_hashMapIEachValue(fy_memblock *mem, fy_hashMapI *map,
		void (*fn)(fy_int key, fy_int value, fy_int nullValue, void *addition),
		void *addition);

#ifdef	__cplusplus
}
#endif

#endif /* FY_HASHMAPI_H_ */