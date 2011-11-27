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

#ifndef FY_DEBUG_H_
/**
 *  Copyright 2010 Yuxuan Huang. All rights reserved.
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
#define FY_DEBUG_H_

#include "../fisceprt.h"
#include "String.h"

#ifdef	__cplusplus
extern "C" {
#endif

_FY_EXPORT void fy_strPrint(fy_str *str);

#ifdef _DEBUG

#define ASSERT(TEST) {if((TEST)==0) fy_fault(NULL,NULL,"ASSERTION ERROR IN %s:%d", __FILE__,__LINE__);}
_FY_EXPORT void fy_varprintf(const char *format, ...);
#define   DLOG   \
        printf( "%s(%s:%d):D: ",__FUNCTION__,   __FILE__,   __LINE__); \
        fy_varprintf
#else

#define ASSERT(TEST)
#define DLOG(fmt, args...)

#endif

#ifdef	__cplusplus
}
#endif

#endif /* FY_DEBUG_H_ */
