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

/* pedantic: Every C code and header with structure definition in FiScE
 * should include following two headers at very first*/
#include "fy_util/Portable.h"
#include "fyc/Config.h"

#include "fyc/Heap.h"

#include "fy_util/Debug.h"
#include "fyc/Constants.h"
#include "fyc/Class.h"
#include "fyc/Thread.h"
#include "fyc/Debug.h"

#if defined(VM_DEBUG) && !defined(FY_VERBOSE)
extern fisce_uint vm_debug;
#endif

#if 0
# ifndef FY_GC_DEBUG
#  define FY_GC_DEBUG
# endif
#endif

static int fetchNextHandle(fy_context *context, fisce_boolean gced,
		fisce_exception *exception) {
	int handle = context->nextHandle;
	while (1) {
		if (fy_heapGetObject(context, handle)->object_data == NULL) {
			break;
		}
		handle++;
		if (handle >= MAX_OBJECTS) {
			handle = 1;
		}
		if (handle == context->nextHandle) {
			/*TODO OOM*/
			if (gced) {
				fy_fault(exception, NULL, "Out of memory! Handle overflow");
				return 0;
			} else {
				DLOG(context, "Call GC due to handle full\n");
				fy_heapGC(context, TRUE, exception);
				return fetchNextHandle(context, TRUE, exception);
			}
		}
	}
	return handle;
}

static int allocate(fy_context *context, fisce_int size, fy_class *clazz,
		fisce_int multiUsageData, fisce_uint toHandle, enum fy_heapPos pos,
		fisce_exception *exception) {
	int handle;
	fy_object *obj;

	handle =
			toHandle == 0 ?
					fetchNextHandle(context, FALSE, exception) : toHandle;
	FYEH()0;
#ifdef FY_VERBOSE
	context->logDVar(context, "Allocating object #%"FY_PRINT32"d for class ", handle);
	context->logDStr(context, clazz->className);
	if(fy_strGet(clazz->className, 0) == '['){
		context->logDVar(context, " length = %"FY_PRINT32"d", multiUsageData);
	}
	context->logDVarLn(context, "");
#endif
	obj = fy_heapGetObject(context, handle);
	switch (pos) {
	case automatic:
		if (size > (COPY_ENTRIES >> 1)) {
			obj->object_data = fy_mmAllocateInOld(context->memblocks, handle,
					size + ((sizeof(fy_object_data) + 3) >> 2) + 1, FALSE,
					exception);
			*(fisce_uint*) (obj->object_data) = handle;
			obj->object_data = (fy_object_data *) ((fisce_uint*) (obj->object_data)
					+ 1);
			memset(obj->object_data, 0,
					(size + ((sizeof(fy_object_data) + 3) >> 2))
							* sizeof(fisce_uint));
			obj->object_data->position = old;
		} else {
			obj->object_data = fy_mmAllocateInEden(context->memblocks, handle,
					size + ((sizeof(fy_object_data) + 3) >> 2), FALSE,
					exception);
			obj->object_data->position = eden;
		}
		break;
	case eden:
		obj->object_data = fy_mmAllocateDirectInEden(context->memblocks,
				size + ((sizeof(fy_object_data) + 3) >> 2), exception);
		break;
	case young:
		obj->object_data = fy_mmAllocateDirectInCopy(context->memblocks,
				size + ((sizeof(fy_object_data) + 3) >> 2), exception);
		break;
	case old:
		obj->object_data = fy_mmAllocateDirectInOld(context->memblocks,
				size + ((sizeof(fy_object_data) + 3) >> 2) + 1, exception);
		*(fisce_uint*) (obj->object_data) = handle;
		obj->object_data =
				(fy_object_data *) ((fisce_uint*) (obj->object_data) + 1);
		break;
	default:
		fy_fault(exception, NULL, "Illegal pos in heap %d.", pos);
		return 0;
	}
	FYEH()0;
	obj->object_data->m.multiUsageData = multiUsageData;
	obj->object_data->clazz = clazz;
	if (context->protectMode) {
		fy_arrayListAdd(context->memblocks, context->protected, &handle,
				exception);
		FYEH()0;
	}
	context->totalObjects++;
	return handle;
}

fisce_uint fy_heapAllocateDirect(fy_context *context, fisce_int size, fy_class *clazz,
		fisce_int multiUsageData, fisce_uint toHandle, enum fy_heapPos pos,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, toHandle);
	if (obj->object_data != NULL) {
		fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE,
				"Handle %d already allocated.", toHandle);
	}
	return allocate(context, size, clazz, multiUsageData, toHandle, pos,
			exception);
}

/**
 * Allocate object
 */
fisce_uint fy_heapAllocate(fy_context *context, fy_class *clazz,
		fisce_exception *exception) {
	fisce_int size = clazz->sizeAbs;

	if (clazz->type != object_class) {
		fy_fault(exception, NULL, "Cannot instance Array without size");
		return 0;
	}

	return allocate(context, size, clazz, 0, 0, automatic, exception);
}

void fy_heapBeginProtect(fy_context *context) {
	context->protectMode = TRUE;
}

void fy_heapEndProtect(fy_context *context) {
	context->protectMode = FALSE;
	fy_arrayListClear(context->memblocks, context->protected);
}

fisce_int fy_heapGetArraySizeFromLength(fy_class *clazz, fisce_int length) {
	switch (clazz->ci.arr.arrayType) {
	case fy_at_long:
		return length << 1;
	case fy_at_int:
		return length;
	case fy_at_byte:
		return (length + 3) >> 2;
	case fy_at_short:
		return (length + 1) >> 1;
		break;
	default:
		fy_fault(NULL, NULL, "Illegal array type %d", clazz->ci.arr.arrayType);
		return 0;
	}
}

fisce_uint fy_heapAllocateArray(fy_context *context, fy_class *clazz,
		fisce_int length, fisce_exception *exception) {
	fisce_int size;

	if (unlikely(clazz->type != array_class) ){
		fy_fault(exception, NULL, "Cannot instance Array with object class");
		return 0;
	}
    if(unlikely(length<0)){
        fy_fault(exception, FY_EXCEPTION_AIOOB, "%d", length);
        return 0;
    }

	size = fy_heapGetArraySizeFromLength(clazz, length);

	return allocate(context, size, clazz, length, 0, automatic, exception);
}

fisce_uint fy_heapAllocateArrayWithContentType(fy_context *context, fy_class *clazz, fisce_int length,fisce_exception *exception){
    fy_str className;
    fy_memblock *block=context->memblocks;
    className.content = NULL;
    fy_strInit(block, &className, 64, exception);
    FYEX({return 0;});
    if (clazz->type == object_class) {
        fy_strAppendUTF8(block, &className, "[L", 3, exception);
        FYEX({fy_strDestroy(block, &className); return 0;});
        fy_strAppend(block, &className, clazz->className, exception);
        FYEX({fy_strDestroy(block, &className); return 0;});
        fy_strAppendUTF8(block, &className, ";", 3, exception);
        FYEX({fy_strDestroy(block, &className); return 0;});
    } else if (clazz->type == array_class) {
        fy_strAppendUTF8(block, &className, "[", 3, exception);
        FYEX({fy_strDestroy(block, &className); return 0;});
        fy_strAppend(block, &className, clazz->className, exception);
        FYEX({fy_strDestroy(block, &className); return 0;});
    }
    clazz = fy_vmLookupClass(context, &className, exception);
    fy_strDestroy(block, &className);
    FYEX({return 0;});
    return fy_heapAllocateArray(context, clazz, length, exception);
}

fy_class* fy_heapGetClassOfObject(fy_context *context, fisce_int handle,
		fisce_exception *exception) {
	if (handle == 0) {
		fy_fault(exception, FY_EXCEPTION_NPT, "");
		return 0;
	}
	return fy_heapGetObject(context, handle)->object_data->clazz;
}

fy_str* fy_heapGetString(fy_context *context, fisce_int handle, fy_str *target,
		fisce_exception *exception) {
	fisce_int i;
	fy_field *valueField, *offsetField, *countField;
	fisce_int ofs, len;
	fisce_int cah;
	if (unlikely(handle == 0)) {
		exception->exceptionType = exception_normal;
		strcpy_s(exception->exceptionName, sizeof(exception->exceptionName),
				FY_EXCEPTION_NPT);
		exception->exceptionDesc[0] = 0;
		return target;
	}
	fy_vmLookupClass(context, context->sString, exception);
	if (unlikely(exception->exceptionType != exception_none)) {
		return NULL;
	}
	valueField = fy_vmGetField(context, context->sStringValue);
	countField = fy_vmGetField(context, context->sStringCount);
	offsetField = fy_vmGetField(context, context->sStringOffset);
	/*No exception except NPT will be thrown, and NPT is processed before,so no need to check
	 * exception.*/
	ofs = fy_heapGetFieldInt(context, handle, offsetField, exception);
	len = fy_heapGetFieldInt(context, handle, countField, exception);
	cah = fy_heapGetFieldInt(context, handle, valueField, exception);
	ASSERT(exception->exceptionType == exception_none);
	if (unlikely(cah == 0)) {
		exception->exceptionType = exception_normal;
		strcpy_s(exception->exceptionName, sizeof(exception->exceptionName),
				FY_EXCEPTION_NPT);
		exception->exceptionDesc[0] = 0;
		return target;
	}
	for (i = 0; i < len; i++) {
		fy_strAppendChar(context->memblocks, target,
				fy_heapGetArrayChar(context, cah, ofs + i, exception),
				exception);
		if (unlikely(exception->exceptionType != exception_none)) {
			return 0;
		}
	}

	return target;
}

fisce_int fy_heapMakeString(fy_context *context, fy_str *target,
		fisce_exception *exception) {
	int i;
	fy_field *valueField, *offsetField, *countField;
	fisce_int len;
	fisce_int cah;
	fisce_int ret;
	if (unlikely(target == NULL)) {
		return 0;
	}
	len = target->length;
	cah = fy_heapAllocateArray(context,
			fy_vmLookupClass(context, context->sArrayChar, exception),
			target->length, exception);
	fy_vmLookupClass(context, context->sString, exception);
	if (unlikely(exception->exceptionType != exception_none)) {
		return 0;
	}
	valueField = fy_vmGetField(context, context->sStringValue);
	countField = fy_vmGetField(context, context->sStringCount);
	offsetField = fy_vmGetField(context, context->sStringOffset);
	/*No exception except NPT will be thrown, and NPT is processed before,so no need to check
	 * exception.*/
	/*GC Safe*/
	ret = fy_heapAllocate(context,
			fy_vmLookupClass(context, context->sString, exception), exception);
	ASSERT(exception->exceptionType == exception_none);
	fy_heapPutFieldHandle(context, ret, valueField, cah, exception);
	fy_heapPutFieldInt(context, ret, countField, len, exception);
	fy_heapPutFieldInt(context, ret, offsetField, 0, exception);
	ASSERT(exception->exceptionType == exception_none);
	for (i = 0; i < len; i++) {
		fy_heapPutArrayChar(context, cah, i, fy_strGet(target, i), exception);
	}

	return ret;
}

fisce_int fy_heapLiteral(fy_context *context, fy_str *str, fisce_exception *exception) {
	fisce_int *pInt;
	fy_memblock *block = context->memblocks;
	pInt = fy_hashMapGet(block, context->literals, str);
	if (unlikely(pInt == NULL)) {
		pInt = fy_mmAllocatePerm(block, sizeof(fisce_int), exception);
		FYEH()0;
		*pInt = fy_heapMakeString(context, str, exception);
		if (exception->exceptionType != exception_none) {
			/*fy_mmFree(block, pInt);*/
			return 0;
		}
		fy_hashMapPut(block, context->literals, str, pInt, exception);
		FYEH()0;
	}
	return *pInt;
}

void fy_heapArrayCopy(fy_context *context, fisce_int src, fisce_int srcPos,
		fisce_int dest, fisce_int destPos, fisce_int len, fisce_exception *exception) {
	fy_object *sObject, *dObject;
	fy_class *sClass, *dClass;
	if (unlikely(src == 0 || dest == 0)) {
		fy_fault(exception, FY_EXCEPTION_STORE, "%s is null",
				src == 0 ? dest == 0 ? "both" : "src":"dest");
		return;
	}
	sObject = fy_heapGetObject(context, src);
	dObject = fy_heapGetObject(context, dest);
	if (unlikely(srcPos < 0 || destPos < 0 || len < 0
			|| (srcPos + len > sObject->object_data->m.arrayLength)
			|| (destPos + len > dObject->object_data->m.arrayLength))) {
		fy_fault(exception, FY_EXCEPTION_AIOOB, "0");
		return;
	}
	sClass = sObject->object_data->clazz;
	dClass = dObject->object_data->clazz;
	if (unlikely(sClass->type != array_class || dClass->type != array_class
	/*TODO still need more study...
	 * || !fy_classCanCastTo(context, sClass, dClass)
	 * @see also void com.cirnoworks.fisce.vm.default_impl.ArrayHeap.arrayCopy
	 * (int srcHandle, int srcOfs, int dstHandle, int dstOfs, int count) throws VMException
	 * */)) {
		fy_fault(exception, FY_EXCEPTION_STORE, "class cast");
		return;
	}

	switch (sClass->ci.arr.arrayType) {
	case fy_at_byte:
		memcpy(((fisce_ubyte* ) dObject->object_data->data) + destPos,
				((fisce_ubyte* ) sObject->object_data->data) + srcPos, len);
		break;
	case fy_at_short:
		memcpy(((fisce_char* ) dObject->object_data->data) + destPos,
				((fisce_char* ) sObject->object_data->data) + srcPos, len << 1);
		break;
	case fy_at_int:
		memcpy(((fisce_uint* ) dObject->object_data->data) + destPos,
				((fisce_uint* ) sObject->object_data->data) + srcPos, len << 2);
		break;
	case fy_at_long:
		memcpy(((fisce_ulong* ) dObject->object_data->data) + destPos,
				((fisce_ulong* ) sObject->object_data->data) + srcPos, len << 3);
		break;
	}
}

fisce_int fy_heapClone(fy_context *context, fisce_int src, fisce_exception *exception) {
	fy_class *clazz;
	fisce_int ret;
	fy_object *sobj, *dobj;
	if (src == 0) {
		fy_fault(exception, FY_EXCEPTION_NPT, "");
		return 0;
	}
	sobj = fy_heapGetObject(context, src);
	clazz = fy_heapGetClassOfObject(context, src, exception);
	FYEH()0;
	if (clazz->type == object_class) {
		ret = fy_heapAllocate(context, clazz, exception);
		FYEH()0;
		dobj = fy_heapGetObject(context, ret);
		memcpy(dobj->object_data, sobj->object_data,
				sizeof(fy_object_data) + (clazz->sizeAbs << 2));
	} else if (clazz->type == array_class) {
		ret = fy_heapAllocateArray(context, clazz,
				sobj->object_data->m.arrayLength, exception);
		FYEH()0;
		dobj = fy_heapGetObject(context, ret);
		switch (clazz->ci.arr.arrayType) {
		case fy_at_byte:
			memcpy(dobj->object_data->data, sobj->object_data->data,
					sobj->object_data->m.arrayLength);
			break;
		case fy_at_short:
			memcpy(dobj->object_data->data, sobj->object_data->data,
					sobj->object_data->m.arrayLength << 1);
			break;
		case fy_at_int:
			memcpy(dobj->object_data->data, sobj->object_data->data,
					sobj->object_data->m.arrayLength << 2);
			break;
		case fy_at_long:
			memcpy(dobj->object_data->data, sobj->object_data->data,
					sobj->object_data->m.arrayLength << 3);
			break;
		}
	} else {
		fy_fault(exception, NULL, "Illegal object type for clone: %d",
				clazz->type);
		return 0;
	}
	return ret;
}

#define CHECK_NPT(X) if (unlikely(handle == 0)) { \
		exception->exceptionType = exception_normal; \
		strcpy_s(exception->exceptionName,sizeof(exception->exceptionName), FY_EXCEPTION_NPT); \
		exception->exceptionDesc[0] = 0; \
		return X; \
	} else ASSERT(fy_heapGetObject(context, handle)->object_data!=NULL);

#define CHECK_IOOB(X) if (unlikely(index < 0 || index >= obj->object_data->m.arrayLength)) {\
		exception->exceptionType = exception_normal;\
		strcpy_s(exception->exceptionName,sizeof(exception->exceptionName), FY_EXCEPTION_AIOOB);\
		sprintf_s(exception->exceptionDesc, sizeof(exception->exceptionDesc),\
				"%"FY_PRINT32"d / %"FY_PRINT32"d", index, obj->object_data->m.arrayLength);\
		return X;\
	}

#define CHECK_STATIC(X) if(unlikely((field->access_flags & FY_ACC_STATIC)==0)){\
		exception->exceptionType=exception_normal;\
		strcpy_s(exception->exceptionName,sizeof(exception->exceptionName),FY_EXCEPTION_INCOMPAT_CHANGE);\
		strcpy_s(exception->exceptionDesc,sizeof(exception->exceptionDesc),"get/set static field is not static!");\
		return X;\
	}

#ifdef FY_DEBUG
static fisce_boolean validate(fy_context *context, fisce_int handle, fy_field *field) {
	fisce_boolean ret;
	fy_class *handleClass =
	fy_heapGetObject(context, handle)->object_data->clazz;
	fy_class *fieldClass = field->owner;
	ret = fy_classCanCastTo(context, handleClass, fieldClass, TRUE);
	if (!ret) {
		context->logEVar(context,
				"Validate failed in field operation: Can't cast from ");
		context->logEStr(context, handleClass->className);
		context->logEVar(context, " to ");
		context->logEStr(context, fieldClass->className);
		context->logEVarLn(context, "");
	}
	ASSERT(ret);
	return ret;
}
#else
#define validate(A,B,C)
#endif

fisce_int fy_heapArrayLength(fy_context *context, fisce_int handle,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	return obj->object_data->m.arrayLength;
}

fisce_boolean fy_heapGetArrayBoolean(fy_context *context, fisce_int handle,
		fisce_int index, fisce_exception *exception) {

	fy_object *obj = fy_heapGetObject(context, handle);

	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_byte*) obj->object_data->data)[index];

}
fisce_int fy_heapGetArrayHandle(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);

	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_int*) obj->object_data->data)[index];
}
fisce_byte fy_heapGetArrayByte(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);

	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_byte*) obj->object_data->data)[index];
}

fisce_byte *fy_heapGetArrayBytes(fy_context *context, fisce_int handle,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	return (fisce_byte*) obj->object_data->data;
}

fisce_short fy_heapGetArrayShort(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_short*) obj->object_data->data)[index];
}
fisce_char fy_heapGetArrayChar(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_char*) obj->object_data->data)[index];
}
fisce_int fy_heapGetArrayInt(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_int*) obj->object_data->data)[index];
}
fisce_long fy_heapGetArrayLong(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_long*) obj->object_data->data)[index];
}
fisce_float fy_heapGetArrayFloat(fy_context *context, fisce_int handle, fisce_int index,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_float*) obj->object_data->data)[index];
}
fisce_double fy_heapGetArrayDouble(fy_context *context, fisce_int handle,
		fisce_int index, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0)
	CHECK_IOOB(0)

	return ((fisce_double*) obj->object_data->data)[index];
}

void fy_heapPutArrayBoolean(fy_context *context, fisce_int handle, fisce_int index,
		fisce_boolean value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_byte*) obj->object_data->data)[index] = value;
}
void fy_heapPutArrayHandle(fy_context *context, fisce_int handle, fisce_int index,
		fisce_int value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)
    if (unlikely(value != 0 && !fy_classCanCastTo(context, fy_heapGetClassOfObject(context, value, exception), fy_heapGetClassOfObject(context, handle, exception)->ci.arr.contentClass, TRUE))) {
        fy_fault(exception, FY_EXCEPTION_STORE, "Data type not compatable");
    }else{
        ((fisce_int*) obj->object_data->data)[index] = value;
    }
}
void fy_heapPutArrayByte(fy_context *context, fisce_int handle, fisce_int index,
		fisce_byte value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_byte*) obj->object_data->data)[index] = value;
}
void fy_heapPutArrayShort(fy_context *context, fisce_int handle, fisce_int index,
		fisce_short value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_short*) obj->object_data->data)[index] = value;
}
void fy_heapPutArrayChar(fy_context *context, fisce_int handle, fisce_int index,
		fisce_char value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)
	((fisce_char*) obj->object_data->data)[index] = value;
}
void fy_heapPutArrayInt(fy_context *context, fisce_int handle, fisce_int index,
		fisce_int value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_int*) obj->object_data->data)[index] = value;
}
void fy_heapPutArrayLong(fy_context *context, fisce_int handle, fisce_int index,
		fisce_long value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_long*) obj->object_data->data)[index] = value;
}
void fy_heapPutArrayFloat(fy_context *context, fisce_int handle, fisce_int index,
		fisce_float value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_int*) obj->object_data->data)[index] = fisce_floatToInt(value);
}
void fy_heapPutArrayDouble(fy_context *context, fisce_int handle, fisce_int index,
		fisce_double value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;)
	CHECK_IOOB(;)

	((fisce_long*) obj->object_data->data)[index] = fisce_doubleToLong(value);
}

fisce_boolean fy_heapGetFieldBoolean(fy_context *context, fisce_int handle,
		fy_field *field, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);

	return (fisce_boolean) (((fisce_int*) obj->object_data->data)[field->posAbs]);
}
fisce_int fy_heapGetFieldHandle(fy_context *context, fisce_int handle,
		fy_field *field, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	ASSERT(obj->object_data!=NULL);validate(context, handle, field);

	CHECK_NPT(0)
	return (fisce_int) (((fisce_int*) obj->object_data->data)[field->posAbs]);
}
fisce_byte fy_heapGetFieldByte(fy_context *context, fisce_int handle, fy_field *field,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);

	return (fisce_byte) (((fisce_int*) obj->object_data->data)[field->posAbs]);
}
fisce_short fy_heapGetFieldShort(fy_context *context, fisce_int handle,
		fy_field *field, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);

	return (fisce_short) (((fisce_int*) obj->object_data->data)[field->posAbs]);
}
fisce_char fy_heapGetFieldChar(fy_context *context, fisce_int handle, fy_field *field,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);

	return (fisce_char) (((fisce_int*) obj->object_data->data)[field->posAbs]);
}
fisce_int fy_heapGetFieldInt(fy_context *context, fisce_int handle, fy_field *field,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);

	return (fisce_int) (((fisce_int*) obj->object_data->data)[field->posAbs]);
}
fisce_long fy_heapGetFieldLong(fy_context *context, fisce_int handle, fy_field *field,
		fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVar(context, "high=%ud\nlow=%ud\n",
			((fisce_int*) obj->object_data->data)[field->posAbs],
			((fisce_int*) obj->object_data->data)[field->posAbs + 1]);
#endif
	return fy_I2TOL((((fisce_int* )obj->object_data->data)[field->posAbs]),
			(((fisce_int* )obj->object_data->data)[field->posAbs + 1]));
}
fisce_float fy_heapGetFieldFloat(fy_context *context, fisce_int handle,
		fy_field *field, fisce_exception *exception) {
#ifdef FY_DEBUG
	fy_object *obj = fy_heapGetObject(context, handle);
#endif
	CHECK_NPT(0) validate(context, handle, field);

	return fisce_intToFloat(fy_heapGetFieldInt(context, handle, field, exception));
}
fisce_double fy_heapGetFieldDouble(fy_context *context, fisce_int handle,
		fy_field *field, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(0) validate(context, handle, field);

	return fisce_longToDouble(
			fy_I2TOL(((fisce_int* )obj->object_data->data)[field->posAbs],
					((fisce_int* )obj->object_data->data)[field->posAbs + 1]));
}

void fy_heapPutFieldBoolean(fy_context *context, fisce_int handle, fy_field *field,
		fisce_boolean value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(boolean) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) obj->object_data->data + field->posAbs), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = value;
}
void fy_heapPutFieldHandle(fy_context *context, fisce_int handle, fy_field *field,
		fisce_int value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(handle) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) obj->object_data->data + field->posAbs), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = value;
}
void fy_heapPutFieldByte(fy_context *context, fisce_int handle, fy_field *field,
		fisce_byte value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(byte) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) obj->object_data->data + field->posAbs), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = value;
}
void fy_heapPutFieldShort(fy_context *context, fisce_int handle, fy_field *field,
		fisce_short value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(short) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) obj->object_data->data + field->posAbs), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = value;
}
void fy_heapPutFieldChar(fy_context *context, fisce_int handle, fy_field *field,
		fisce_char value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(char) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) obj->object_data->data + field->posAbs), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = value;
}
void fy_heapPutFieldInt(fy_context *context, fisce_int handle, fy_field *field,
		fisce_int value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(int) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) obj->object_data->data + field->posAbs), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = value;
}
void fy_heapPutFieldLong(fy_context *context, fisce_int handle, fy_field *field,
		fisce_long value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(long) address=%p value=%"FY_PRINT32"d %"FY_PRINT32"d as %"FY_PRINT64"d",
			((fisce_int*) obj->object_data->data + field->posAbs), fy_HOFL(value), fy_LOFL(value), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = fy_HOFL(value);
	((fisce_int*) obj->object_data->data)[field->posAbs + 1] = fy_LOFL(value);
}
void fy_heapPutFieldFloat(fy_context *context, fisce_int handle, fy_field *field,
		fisce_float value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(float) address=%p value=%"FY_PRINT32"d as %f",
			((fisce_int*) obj->object_data->data + field->posAbs), fisce_floatToInt(value), value);
#endif
	((fisce_int*) obj->object_data->data)[field->posAbs] = fisce_floatToInt(value);
}
void fy_heapPutFieldDouble(fy_context *context, fisce_int handle, fy_field *field,
		fisce_double value, fisce_exception *exception) {
	fy_object *obj = fy_heapGetObject(context, handle);
	fisce_long longValue;
	CHECK_NPT(;) validate(context, handle, field);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "putField(double) address=%p value=%"FY_PRINT32"d %"FY_PRINT32"d as %f",
			((fisce_int*) obj->object_data->data + field->posAbs), fisce_doubleToLong(value), value);
#endif
	longValue = fisce_doubleToLong(value);
	((fisce_int*) obj->object_data->data)[field->posAbs] = fy_HOFL(longValue);
	((fisce_int*) obj->object_data->data)[field->posAbs + 1] = fy_LOFL(longValue);
}

fisce_boolean fy_heapGetStaticBoolean(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(boolean) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs]);
#endif
	return field->owner->staticArea[field->posAbs];
}
fisce_int fy_heapGetStaticHandle(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(handle) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs]);
#endif
	return field->owner->staticArea[field->posAbs];
}
fisce_byte fy_heapGetStaticByte(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(byte) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs]);
#endif
	return field->owner->staticArea[field->posAbs];
}
fisce_short fy_heapGetStaticShort(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(short) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs]);
#endif
	return field->owner->staticArea[field->posAbs];
}
fisce_char fy_heapGetStaticChar(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(char) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs]);
#endif
	return field->owner->staticArea[field->posAbs];
}
fisce_int fy_heapGetStaticInt(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(int) address=%p value=%"FY_PRINT32"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs]);
#endif
	return field->owner->staticArea[field->posAbs];
}
fisce_long fy_heapGetStaticLong(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(long) address=%p value=%"FY_PRINT32"d %"FY_PRINT32"d as %"FY_PRINT64"d",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs],
			field->owner->staticArea[field->posAbs + 1], fy_I2TOL(field->owner->staticArea[field->posAbs],
			field->owner->staticArea[field->posAbs + 1]));
#endif
	return fy_I2TOL(field->owner->staticArea[field->posAbs],
			field->owner->staticArea[field->posAbs + 1]);
}
fisce_float fy_heapGetStaticFloat(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	CHECK_STATIC(0)
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(int) address=%p value=%"FY_PRINT32"d as %f",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs],
			*(float*) (field->owner->staticArea + field->posAbs));
#endif
	return *(float*) (field->owner->staticArea + field->posAbs);
}
fisce_double fy_heapGetStaticDouble(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	fisce_long lvalue;
	CHECK_STATIC(0)
	lvalue = fy_I2TOL(field->owner->staticArea[field->posAbs],
			field->owner->staticArea[field->posAbs + 1]);
#ifdef FY_VERBOSE
	context->logDVarLn(context, "getStatic(long) address=%p value=%"FY_PRINT32"d %"FY_PRINT32"d as %f",
			((fisce_int*) field->owner->staticArea + field->posAbs), field->owner->staticArea[field->posAbs],
			field->owner->staticArea[field->posAbs + 1], fisce_longToDouble(lvalue));
#endif
	return fisce_longToDouble(lvalue);
}

void fy_heapPutStaticBoolean(fy_context *context, fy_field *field,
		fisce_boolean value, fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = value;
}
void fy_heapPutStaticHandle(fy_context *context, fy_field *field, fisce_int value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = value;
}
void fy_heapPutStaticByte(fy_context *context, fy_field *field, fisce_byte value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = value;
}
void fy_heapPutStaticShort(fy_context *context, fy_field *field, fisce_short value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = value;
}
void fy_heapPutStaticChar(fy_context *context, fy_field *field, fisce_char value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = value;
}
void fy_heapPutStaticInt(fy_context *context, fy_field *field, fisce_int value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = value;
}
void fy_heapPutStaticLong(fy_context *context, fy_field *field, fisce_long value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = fy_HOFL(value);
	field->owner->staticArea[field->posAbs + 1] = fy_LOFL(value);
}
void fy_heapPutStaticFloat(fy_context *context, fy_field *field, fisce_float value,
		fisce_exception *exception) {
	CHECK_STATIC(;)
	field->owner->staticArea[field->posAbs] = fisce_floatToInt(value);
}
void fy_heapPutStaticDouble(fy_context *context, fy_field *field,
		fisce_double value, fisce_exception *exception) {
	fisce_long lvalue;
	CHECK_STATIC(;)
	lvalue = fisce_doubleToLong(value);
	field->owner->staticArea[field->posAbs] = fy_HOFL(lvalue);
	field->owner->staticArea[field->posAbs + 1] = fy_LOFL(lvalue);
}

void fy_heapRegisterReference(fy_context *context, fisce_int reference,
		fisce_int referent, fisce_exception *exception) {
	fisce_int ret;
	ret = fy_hashMapIPut(context->memblocks, context->references, reference,
			referent, exception);
	FYEH();
	if (ret != 0) {
		fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE,
				"Reference #%"FY_PRINT32"d is already registered with referent #%"FY_PRINT32"d",
				reference, referent);
		FYEH();
	}
}

fisce_int fy_heapGetReferent(fy_context *context, fisce_int reference) {
	return fy_hashMapIGet(context->memblocks, context->references, reference);
}

static void markObjectInitialUsing(fy_context *context, fy_arrayList *from,
		fisce_uint handle, fisce_exception *exception) {
#if 0
	if(handle==3395) {
		handle=3395;
	}
#endif
	if (handle != 0) {
		fy_arrayListAdd(context->memblocks, from, &handle, exception);
	}
}

typedef struct fy_fill_literals_data {
	fy_context *context;
	fy_arrayList *from;
	fisce_exception *exception;
} fy_fill_literals_data;

static void fillLiterals(fy_str *key, void *value, void *data) {
	fy_fill_literals_data *ffld = (fy_fill_literals_data*) data;
	fisce_uint handle = *(fisce_uint*) value;
	markObjectInitialUsing(ffld->context, ffld->from, handle, ffld->exception);
}

struct gc_data {
	fy_context *context;
	fisce_uint *marks;
	fy_arrayList *from;
	fisce_exception *exception;
};

static void markSoftReference(fisce_int reference, fisce_int referent,
		fisce_int nullValue, void *addition) {
	struct gc_data *data = addition;
	fy_context *context = data->context;
	fisce_exception *exception = data->exception;
	fy_arrayList *from = data->from;
	fy_object *reference_object = fy_heapGetObject(context, reference);
	fisce_uint access = reference_object->object_data->clazz->accessFlags;
	if (access & FY_ACC_SOFT_REF) {
		markObjectInitialUsing(context, from, referent, exception);
	}
}

static void clearAndEnqueue(fy_context *context, fisce_int reference,
		fisce_exception *exception) {
	fy_arrayListAdd(context->memblocks, context->toEnqueue, &reference,
			exception);
	FYEH();
#if 0
	context->logDVarLn(context, "Clear and enqueue: %"FY_PRINT32"d", reference);
#endif
	fy_hashMapIRemove(context->memblocks, context->references, reference);
}

/*
 * Clean and enqueue SoftRef and WeakRef, launched before finalize scan.
 * */
static void processReferencePhase1(fisce_int reference, fisce_int referent,
		fisce_int nullValue, void *addition) {
	struct gc_data *data = addition;
	fy_context *context = data->context;
	fisce_uint *marks = data->marks;
	fisce_exception *exception = data->exception;
	fy_arrayList *from = data->from;
	fy_object *obj_reference = fy_heapGetObject(context, reference);
	fy_object *obj_referent = fy_heapGetObject(context, referent);
#if 0
	context->logDVar(context,"#GC Processing reference=%"FY_PRINT32"d class=",reference);
	context->logDStr(context,obj_reference->object_data->clazz->className);
	context->logDVarLn(context," flag=%x",obj_reference->object_data->clazz->accessFlags);
#endif
	if (obj_referent->object_data == NULL
			|| (!fy_bitGet(marks, referent)
					&& (obj_reference->object_data->clazz->accessFlags
							& FY_ACC_PHANTOM_REF) == 0)) {
		fy_arrayListAdd(context->memblocks, from, &reference, exception);
		clearAndEnqueue(context, reference, exception);
	}
}

static void processReferencePhase2(fisce_int reference, fisce_int referent,
		fisce_int nullValue, void *addition) {
	struct gc_data *data = addition;
	fy_context *context = data->context;
	fisce_uint *marks = data->marks;
	fisce_exception *exception = data->exception;
	fy_object *obj_referent = fy_heapGetObject(context, referent);
	if (obj_referent->object_data == NULL && fy_bitGet(marks, reference)) {
		clearAndEnqueue(context, reference, exception);
	}
}

static void fillInitialHandles(fy_context *context, fy_arrayList *from,
		fisce_boolean processSoft, fisce_exception *exception) {
	fisce_uint i, imax, j, jmax;
	fy_class *clazz;
	fy_field *field;
	fy_fill_literals_data ffld;
	fy_thread *thread;
	fy_class *classClass, *classMethod, *classField, *classConstructor;
	fy_object *object;
	struct gc_data gc_data;

	gc_data.context = context;
	gc_data.exception = exception;
	gc_data.from = from;

	classClass = fy_vmLookupClass(context, context->sClassClass, exception);
	FYEH();
	classMethod = fy_vmLookupClass(context, context->sClassMethod, exception);
	FYEH();
	classField = fy_vmLookupClass(context, context->sClassField, exception);
	FYEH();
	classConstructor = fy_vmLookupClass(context, context->sClassConstructor,
			exception);
	FYEH();

	/*Reflection objects*/
	imax = MAX_OBJECTS;
	for (i = 1; i < MAX_OBJECTS; i++) {
		object = context->objects + i;
		if (object->object_data != NULL) {
			clazz = object->object_data->clazz;
			if (clazz == classClass || clazz == classMethod
					|| clazz == classField || clazz == classConstructor) {
				markObjectInitialUsing(context, from, i, exception);
				FYEH();
			}
		}
	}

	/*Class static area*/
	imax = context->classesCount;
	for (i = 1; i <= imax; i++) {
		clazz = context->classes[i];
		if (clazz->phase == 2) {
			jmax = clazz->staticSize;
			for (j = 0; j < jmax; j++) {
				field = clazz->fieldStatic[j];
				if (field != NULL
						&& (fy_strGet(field->descriptor,0) == FY_TYPE_HANDLE
								|| fy_strGet(field->descriptor, 0)
										== FY_TYPE_ARRAY)) {
					markObjectInitialUsing(context, from, clazz->staticArea[j],
							exception);
					FYEH();
				}
			}
		}
	}

	/*Literals*/
	{
		ffld.context = context;
		ffld.from = from;
		ffld.exception = exception;

		fy_hashMapEachValue(context->memblocks, context->literals, fillLiterals,
				&ffld);
	}
	/*Thread objects*/
	for (i = 1; i < MAX_THREADS; i++) {
		thread = context->threads[i];
		if (thread != NULL) {
			markObjectInitialUsing(context, from, thread->handle, exception);
			FYEH();
			markObjectInitialUsing(context, from, thread->waitForLockId,
					exception);
			FYEH();
			markObjectInitialUsing(context, from, thread->waitForNotifyId,
					exception);
			FYEH();
			markObjectInitialUsing(context, from, thread->currentThrowable,
					exception);
			FYEH();
			fy_threadScanRef(context, thread, from, exception);
			FYEH();
		}
	}

	imax = context->toFinalize->length;
	for (i = 0; i < imax; i++) {
		markObjectInitialUsing(context, from,
				*(fisce_int*) fy_arrayListGet(context->memblocks,
						context->toFinalize, i, NULL), exception);
	}

	imax = context->protected->length;
	for (i = 0; i < imax; i++) {
		markObjectInitialUsing(context, from,
				*(fisce_int*) fy_arrayListGet(context->memblocks,
						context->protected, i, NULL), exception);
	}

	imax = context->toEnqueue->length;
	for (i = 0; i < imax; i++) {
		markObjectInitialUsing(context, from,
				*(fisce_int*) fy_arrayListGet(context->memblocks,
						context->toEnqueue, i, NULL), exception);
	}

	if (processSoft) {
		fy_hashMapIEachValue(context->memblocks, context->references,
				markSoftReference, &gc_data);
	}
}

static void scanRef(fy_context *context, fy_arrayList *from, fisce_uint *marks,
		fisce_exception *exception) {

	fy_object *object;
	fisce_int i;
	fisce_uint handle;

#ifndef FY_LATE_DECLARATION
	fisce_uint handle1, handle2;
	fy_class *clazz;
	fy_field *field;
	fisce_char fieldType;
#endif

#ifdef FY_GC_DEBUG
	for (i = 0; i < from->length; i++) {
		fy_arrayListGet(context->memblocks, from, i, &handle);
	}
	context->logDVar(context, "#Scanref root=%"FY_PRINT32"d", handle);
	i = 0;
	handle = 0;
#endif
	while (fy_arrayListPop(context->memblocks, from, &handle)) {
#ifdef FY_LATE_DECLARATION
		fy_class *clazz;
		fisce_uint handle2;
		fy_field *field;
		fisce_char fieldType;
#endif
		ASSERT(handle>0 && handle<MAX_OBJECTS);
		if (fy_bitGet(marks, handle)) {
			continue;
		} else {
			fy_bitSet(marks, handle);
		}
		object = context->objects + handle;
		clazz = object->object_data->clazz;
		ASSERT(clazz!=NULL);
		switch (clazz->type) {
		case array_class:
			if (clazz->ci.arr.contentClass->type != primitive_class) {
				for (i = object->object_data->m.arrayLength - 1; i >= 0; i--) {
					handle2 = fy_heapGetArrayHandle(context, handle, i,
							exception);
					FYEH();
					if (handle2 == 0) {
						continue;
					}/**/
					ASSERT(
							handle2 > 0 && handle2 < MAX_OBJECTS && fy_heapGetObject(context,handle2)->object_data != NULL);
					if (!fy_bitGet(marks, handle2)) {
						/*
						 markObjectUsing(context, marks, handle2);
						 */
#ifdef FY_GC_DEBUG
						context->logDVar(context,
								"#Scanref add(%"FY_PRINT32"d) from (%"FY_PRINT32"d)\n",
								handle2, handle);
#endif
						fy_arrayListAdd(context->memblocks, from, &handle2,
								exception);
						FYEH();
					}
				}
			}
			break;
			case object_class:
			for (i = clazz->sizeAbs - 1; i >= 0; i--) {
				field = clazz->fieldAbs[i];
				if (field == NULL) {
					continue;
				}
				fieldType = fy_strGet(field->descriptor,0);
				if (fieldType == FY_TYPE_HANDLE || fieldType == FY_TYPE_ARRAY) {
					handle2 = fy_heapGetFieldHandle(context, handle,
							clazz->fieldAbs[i], exception);
					FYEH();
					if (handle2 == 0) {
						continue;
					}/**/
					ASSERT(
							handle2 > 0 && handle2 < MAX_OBJECTS && fy_heapGetObject(context,handle2)->object_data != NULL);
					if (!fy_bitGet(marks, handle2)) {
						/*
						 markObjectUsing(context, marks, handle2);
						 */
#ifdef FY_GC_DEBUG
						context->logDVar(context,
								"#Scanref add(%"FY_PRINT32"d) from (%"FY_PRINT32"d)\n",
								handle2, handle);
#endif
						fy_arrayListAdd(context->memblocks, from, &handle2,
								exception);
						FYEH();
					}
				}
			}
			break;
			default:
			fy_fault(exception, NULL, "Illegal object type for object %d.",
					handle);
			break;
		}
	}
}

static fisce_int getSizeFromObject(fy_context *context, fy_object *object) {
	fy_class *clazz = object->object_data->clazz;
	switch (clazz->type) {
	case array_class:
		return fy_heapGetArraySizeFromLength(clazz,
				object->object_data->m.arrayLength)
				+ ((sizeof(fy_object_data) + 3) >> 2);
		break;
	case object_class:
		return clazz->sizeAbs + ((sizeof(fy_object_data) + 3) >> 2);
		break;
	default:
		fy_fault(NULL, NULL, "Illegal class type %d in GC", clazz->type);
		return 0;
	}
}

static void release(fy_context *context, fisce_uint handle) {
	fy_memblock *block = context->memblocks;
	fy_object *object = fy_heapGetObject(context, handle);
	/*
	 fy_class *clazz = object->object_data->clazz;
	 */
#if 0
	context->logDVarLn(context, "release handle: %"FY_PRINT32"d", handle);
#endif
	if (object->object_data->position == old) {
		block->oldReleasedSize += getSizeFromObject(context, object) + 1;
	}
#if 0
	context->logDVarLn(context, "Ref release: %"FY_PRINT32"d", handle);
#endif
	fy_hashMapIRemove(context->memblocks, context->references, handle);
	/* TODO ??? should I clear all object's heap data? */
	/*memset(object->object_data, 0, sizeof(fy_object_data));*/
	object->object_data = NULL;
	context->totalObjects--;
}

static void compactOld(fy_context *context, fisce_uint *marks,
		fisce_exception *exception) {
	fisce_uint i, imax;
	fisce_uint newPos = 0;
	fisce_uint handle;
	fisce_uint size;
	fy_object *object;
	fy_memblock *block = context->memblocks;
	imax = block->posInOld;
	for (i = 0; i < imax; i++) {
		handle = block->old[i];
		if (handle > 0 && handle < MAX_OBJECTS) {
			object = context->objects + handle;
			if (object->object_data != NULL
					&& (void*) object->object_data == block->old + i + 1) {
				/*It's a real object*/
				size = getSizeFromObject(context, object) + 1;
				if (marks != NULL && !fy_bitGet(marks, handle)) {
#ifdef FY_GC_DEBUG
					context->logDVarLn(context, "release %d(%d) at %d size=%d",
							handle, object->object_data->clazz->type, i, size);
#endif
					release(context, handle);
					i += size - 1;
				} else {
					if (newPos != i) {
#ifdef FY_GC_DEBUG
						context->logDVarLn(context,
								"Move %d(%d) from %d to %d size=%d", handle,
								object->object_data->clazz->type, i, newPos,
								size);
#endif
						memmove(block->old + newPos, block->old + i,
								size * sizeof(fisce_uint));
						object->object_data = (void*) (block->old + newPos + 1);
					}
#ifdef FY_GC_DEBUG
					else {
						context->logDVarLn(context, "Hold %d(%d) at %d size=%d",
								handle, object->object_data->clazz->type, i,
								size);
					}
#endif
					newPos += size;
					i += size - 1;
				}
			}
#ifdef FY_GC_DEBUG
			else {
				context->logDVarLn(context, "Ignore %d at %d", handle, i);
			}
#endif
		}
#ifdef FY_GC_DEBUG
		else {
			context->logDVarLn(context, "Ignore2 %d at %d", handle, i);
		}
#endif
	}
	block->posInOld = newPos;
	block->oldReleasedSize = 0;
}

static void moveToOld(fy_context *context, fy_class *clazz, fisce_uint handle,
		fy_object *object, fisce_int size, fisce_exception *exception) {
	fy_memblock *block = context->memblocks;
	fisce_int pos = block->posInOld;
	if (pos + size + 1 >= block->oldTop) {
		compactOld(context, NULL, exception);
		pos = block->posInOld;
		if (pos + size + 1 >= block->oldTop) {
			/*Really OOM*/
			fy_fault(exception, NULL, "Old area full");
		}
	}
	block->old[pos] = handle;
	memcpy(block->old + pos + 1, object->object_data, size * sizeof(fisce_uint));
	block->posInOld = pos + size + 1;
	object->object_data = (void*) (block->old + pos + 1);
	object->object_data->position = old;
}
static void moveToYoung(fy_context *context, fy_class *clazz, fisce_uint handle,
		fy_object *object, fisce_int size, fisce_int youngId, fisce_exception *exception) {
	fy_memblock *block = context->memblocks;
	fisce_int pos = block->posInYong;
	if (pos + size >= COPY_ENTRIES) {
		/*move to old*/
		moveToOld(context, clazz, handle, object, size, exception);
	} else {
		/*move to young*/
		memcpy(block->young + youngId * COPY_ENTRIES + pos, object->object_data,
				size * sizeof(fisce_uint));
		block->posInYong = pos + size;
		object->object_data = (void*) (block->young + youngId * COPY_ENTRIES
				+ pos);
		object->object_data->position = young;
		object->object_data->gen++;
	}
}

static void move(fy_context *context, fy_class *clazz, fisce_uint handle,
		fy_object *object, fisce_int youngId, fisce_exception *exception) {
	fisce_int size;

	size = getSizeFromObject(context, object);

	if (object->object_data->gen > MAX_GEN) {
		moveToOld(context, clazz, handle, object, size, exception);
	} else {
		moveToYoung(context, clazz, handle, object, size, youngId, exception);
	}
}

void fy_heapGC(void *ctx, fisce_boolean memoryStressed, fisce_exception *exception) {
	/*Init scan for all handles*/
	fisce_uint *marks;
	fy_object *object;
	fy_class *clazz;
	fy_arrayList from;
	/*
	 fisce_uint handle;
	 fisce_int j;
	 */
	fisce_int i;
	fy_context *context = ctx;
	fy_memblock *block = context->memblocks;
	fisce_int youngId = block->youngId;
	struct gc_data gc_data;
	fisce_long timeStamp;
	fisce_long t1, t2, t3, t4, t5, t6, t7;
    fisce_int externCount;
    fisce_int *externContent;
#ifdef FY_GC_DEBUG
	void *tmpPointer;
#endif
    if(context->beforeGC){
        context->beforeGC(context->gcCustomData);
    }

	if (block->posInOld + block->posInEden + block->posInYong
			+ context->totalObjects > block->oldTop) {
#ifdef FY_DEBUG
		context->logDVarLn(context,
				"#FISCE GC use memory stress mode since heap is nearly full");
#endif
		memoryStressed = TRUE;
	}
#ifdef FY_DEBUG
	context->logDVar(context,
			"#FISCE GC %s BEFORE %d+%d+%d total %dbytes, %d managed native bytes, %d perm bytes\n",
			memoryStressed ? "stressed" : "",
			block->posInEden * (fisce_int) sizeof(fisce_uint),
			block->posInYong * (fisce_int) sizeof(fisce_uint),
			block->posInOld * (fisce_int) sizeof(fisce_uint),
			(fisce_int) ((block->posInEden + block->posInYong + block->posInOld)
					* (fisce_int) sizeof(fisce_uint)), context->memblocks->size,
			(fisce_int) ((OLD_ENTRIES - context->memblocks->oldTop)
					* (fisce_int) sizeof(fisce_uint)));
#else
	context->logDVar(context,
			"#FISCE GC %s BEFORE %d+%d+%d total %dbytes, %d perm bytes\n",
			memoryStressed ? "stressed" : "",
			block->posInEden * (fisce_int) sizeof(fisce_uint),
			block->posInYong * (fisce_int) sizeof(fisce_uint),
			block->posInOld * (fisce_int) sizeof(fisce_uint),
			(fisce_int) ((block->posInEden + block->posInYong + block->posInOld)
					* (fisce_int) sizeof(fisce_uint)),
			(fisce_int) ((OLD_ENTRIES - context->memblocks->oldTop)
					* (fisce_int) sizeof(fisce_uint)));
#endif

	timeStamp = fy_portTimeMillSec(context->port);
	marks = /*TEMP*/fy_allocate(fy_bitSizeToInt(MAX_OBJECTS) * sizeof(fisce_int), exception);
	FYEG(RETURN);
	fy_arrayListInit(context->memblocks, &from, sizeof(fisce_uint),
			context->totalObjects, exception);
	if (exception->exceptionType != exception_none) {
		fy_free(marks);
        goto RETURN;
	}
	gc_data.context = context;
	gc_data.marks = marks;
	gc_data.exception = exception;

	t1 = fy_portTimeMillSec(context->port);
	fillInitialHandles(context, &from, !memoryStressed, exception);
	if (exception->exceptionType != exception_none) {
		fy_free(marks);
		fy_arrayListDestroy(context->memblocks, &from);
        goto RETURN;
	}
    if(context->getExtraGCKeep){
        context->getExtraGCKeep(context->gcCustomData, &externCount, &externContent);
        if(externCount > 0){
            for(i = 0; i < externCount; i++){
                markObjectInitialUsing(context, &from, externContent[i], exception);
                FYEG(RETURN);
            }
        }
    }

	gc_data.from = &from;

	t2 = fy_portTimeMillSec(context->port);

	scanRef(context, &from, marks, exception);
	if (exception->exceptionType != exception_none) {
		fy_free(marks);
		fy_arrayListDestroy(context->memblocks, &from);
        goto RETURN;
	}

	t3 = fy_portTimeMillSec(context->port);
	fy_arrayListClear(context->memblocks, &from);
	for (i = 1; i < MAX_OBJECTS; i++) {
		object = fy_heapGetObject(context, i);
		if (object->object_data != NULL && !fy_bitGet(marks, i)
				&& object->object_data->clazz->needFinalize
				&& object->object_data->finalizeStatus == not_finalized) {
			clazz = object->object_data->clazz;
			/*
			 context->logDVar(context,"ADD %d need finalize\n", i);
			 markObjectUsing(context, marks, i);
			 */
			fy_arrayListAdd(context->memblocks, context->toFinalize, &i,
					exception);
			if (exception->exceptionType != exception_none) {
				fy_free(marks);
				fy_arrayListDestroy(context->memblocks, &from);
                goto RETURN;
			}
			fy_arrayListAdd(context->memblocks, &from, &i, exception);
			if (exception->exceptionType != exception_none) {
				fy_free(marks);
				fy_arrayListDestroy(context->memblocks, &from);
                goto RETURN;
			}
			object->object_data->finalizeStatus = in_finalize_array;
		}
	}
	fy_hashMapIEachValue(context->memblocks, context->references,
			processReferencePhase1, &gc_data);
	t4 = fy_portTimeMillSec(context->port);
	scanRef(context, &from, marks, exception);
	fy_arrayListDestroy(context->memblocks, &from);
	if (exception->exceptionType != exception_none) {
		fy_free(marks);
        goto RETURN;
	}

	t5 = fy_portTimeMillSec(context->port);
	if (memoryStressed) {
		compactOld(context, marks, exception);
		FYEG(RETURN);
	}
	t6 = fy_portTimeMillSec(context->port);
	block->posInEden = 0;
	block->posInYong = 0;
	block->youngId = youngId = 1 - block->youngId;
	for (i = 1; i < MAX_OBJECTS; i++) {
		object = fy_heapGetObject(context, i);
		if (object->object_data != NULL) {
			clazz = object->object_data->clazz;
			if (fy_bitGet(marks, i)) {

				switch (object->object_data->position) {
				case eden:
				case young:
#ifdef FY_GC_DEBUG
					context->logDVarLn(context, "#GC move %d.", i);
#endif
#ifdef FY_STRICT_CHECK
					if (object->object_data == NULL
							|| object->object_data->clazz == NULL
							|| object->object_data->clazz->utf8Name == NULL) {
						fy_fault(NULL, NULL, "Illegal object #%d", i);
					}
#endif
					move(context, clazz, i, object, youngId, exception);
					break;
				case old:
#ifdef FY_GC_DEBUG
					context->logDVarLn(context, "#GC hold %d.", i);
#endif
#ifdef FY_STRICT_CHECK
					if (object->object_data == NULL
							|| object->object_data->clazz == NULL
							|| object->object_data->clazz->utf8Name == NULL) {
						fy_fault(NULL, NULL, "Illegal object #%d", i);
					}
#endif
					break;
				default: {
					fy_fault(exception, NULL, "Illegal position %d in heap",
							object->object_data->position);
					return;
				}
				}
			} else {
#ifdef FY_GC_DEBUG
				context->logDVarLn(context, "#GC release %d at (%p)->%p.", i,
						object, object->object_data);
				tmpPointer = object->object_data;
				object->object_data = (void*) 1234567890;
				object->object_data = tmpPointer;
#endif
#ifdef FY_STRICT_CHECK
				if (object->object_data == NULL
						|| object->object_data->clazz == NULL
						|| object->object_data->clazz->utf8Name == NULL) {
					fy_fault(NULL, NULL, "Illegal object #%d", i);
				}
#endif
				release(context, i);
			}
		}
	}
	fy_hashMapIEachValue(context->memblocks, context->references,
			processReferencePhase2, &gc_data);
#ifdef FY_GC_FORCE_FULL
	compactOld(context, exception);
	FYEG(RETURN);
#endif
	t7 = fy_portTimeMillSec(context->port);
	memset(context->memblocks->eden, 0, sizeof(context->memblocks->eden));
#ifdef FY_DEBUG
	context->logDVar(context,
			"#FISCE GC AFTER %d+%d+%d total %dbytes, %d managed native bytes, %d perm bytes, %d context size, time=%"FY_PRINT64"d\n",
			block->posInEden * (fisce_int) sizeof(fisce_uint),
			block->posInYong * (fisce_int) sizeof(fisce_uint),
			block->posInOld * (fisce_int) sizeof(fisce_uint),
			(fisce_int) ((block->posInEden + block->posInYong + block->posInOld)
					* (fisce_int) sizeof(fisce_uint)), context->memblocks->size,
			(OLD_ENTRIES - context->memblocks->oldTop)
			* (fisce_int) sizeof(fisce_uint), (fisce_int) sizeof(fy_context),
			fy_portTimeMillSec(context->port) - timeStamp);
	context->logDVar(context, "%d %d %d %d %d %d %d %d\n", t1 - timeStamp,
			t2 - t1, t3 - t2, t4 - t3, t5 - t4, t6 - t5, t7 - t6,
			fy_portTimeMillSec(context->port) - t7);
#else
	context->logDVar(context,
			"#FISCE GC AFTER %d+%d+%d total %dbytes,%d perm bytes,%d context bytes, time=%"FY_PRINT64"d\n",
			block->posInEden * (fisce_int) sizeof(fisce_uint),
			block->posInYong * (fisce_int) sizeof(fisce_uint),
			block->posInOld * (fisce_int) sizeof(fisce_uint),
			(fisce_int) ((block->posInEden + block->posInYong + block->posInOld)
					* (fisce_int) sizeof(fisce_uint)),
			(OLD_ENTRIES - context->memblocks->oldTop)
					* (fisce_int) sizeof(fisce_uint), (fisce_int) sizeof(fy_context),
			fy_portTimeMillSec(context->port) - timeStamp);
	context->logDVar(context, "%d %d %d %d %d %d %d %d\n", t1 - timeStamp,
			t2 - t1, t3 - t2, t4 - t3, t5 - t4, t6 - t5, t7 - t6,
			fy_portTimeMillSec(context->port) - t7);
#endif
	fy_free(marks);
    
RETURN:
    if(context->afterGC){
        context->afterGC(context->gcCustomData);
    }
}

fisce_uint fy_heapWrapBoolean(fy_context *context, fisce_boolean value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sBoolean, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueBoolean);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldBoolean(context, ret, field, value, exception);
	return ret;
}

fisce_boolean fy_heapUnwrapBoolean(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassBoolean,
			exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sBoolean, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueBoolean);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as boolean", handle);
		return 0;
	}
	return fy_heapGetFieldBoolean(context, handle, field, exception);
}

fisce_uint fy_heapWrapByte(fy_context *context, fisce_byte value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sByte, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueByte);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldByte(context, ret, field, value, exception);
	return ret;
}

fisce_byte fy_heapUnwrapByte(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassByte, exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sByte, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueByte);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as byte", handle);
		return 0;
	}
	return fy_heapGetFieldByte(context, handle, field, exception);
}

fisce_uint fy_heapWrapShort(fy_context *context, fisce_short value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sShort, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueShort);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldShort(context, ret, field, value, exception);
	return ret;
}

fisce_short fy_heapUnwrapShort(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassShort,
			exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sShort, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueShort);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as short", handle);
		return 0;
	}
	return fy_heapGetFieldShort(context, handle, field, exception);
}

fisce_uint fy_heapWrapChar(fy_context *context, fisce_char value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sChar, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueChar);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldChar(context, ret, field, value, exception);
	return ret;
}

fisce_char fy_heapUnwrapChar(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassChar, exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sChar, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueChar);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as char", handle);
		return 0;
	}
	return fy_heapGetFieldChar(context, handle, field, exception);
}

fisce_uint fy_heapWrapInt(fy_context *context, fisce_int value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sInt, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueInt);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldInt(context, ret, field, value, exception);
	return ret;
}

fisce_int fy_heapUnwrapInt(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class * clazz = fy_vmLookupClass(context, context->sClassInt, exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sInt, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueInt);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as int", handle);
		return 0;
	}
	return fy_heapGetFieldInt(context, handle, field, exception);
}

fisce_uint fy_heapWrapFloat(fy_context *context, fisce_float value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sFloat, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueFloat);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldFloat(context, ret, field, value, exception);
	return ret;
}

fisce_float fy_heapUnwrapFloat(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassFloat,
			exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sFloat, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueFloat);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as float", handle);
		return 0;
	}
	return fy_heapGetFieldFloat(context, handle, field, exception);
}

fisce_uint fy_heapWrapLong(fy_context *context, fisce_long value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sLong, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueLong);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldLong(context, ret, field, value, exception);
	return ret;
}

fisce_long fy_heapUnwrapLong(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassLong, exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sLong, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueLong);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as long", handle);
		return 0;
	}
	return fy_heapGetFieldLong(context, handle, field, exception);
}

fisce_uint fy_heapWrapDouble(fy_context *context, fisce_double value,
		fisce_exception *exception) {
	fy_class *clazz;
	fy_field *field;
	fisce_uint ret;
	clazz = fy_vmLookupClass(context, context->sDouble, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueDouble);
	FYEH()0;
	ret = fy_heapAllocate(context, clazz, exception);
	FYEH()0;
	fy_heapPutFieldDouble(context, ret, field, value, exception);
	return ret;
}

fisce_double fy_heapUnwrapDouble(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_field *field;
	fy_class *clazz = fy_vmLookupClass(context, context->sClassDouble,
			exception);
	FYEH()0;
	fy_vmLookupClass(context, context->sDouble, exception);
	FYEH()0;
	field = fy_vmGetField(context, context->sValueDouble);
	FYEH()0;
	if (fy_heapGetObject(context,handle)->object_data->clazz != clazz) {
		fy_fault(exception, FY_EXCEPTION_ARGU,
				"Can't unwarp handle=%"FY_PRINT32"d as double", handle);
		return 0;
	}
	return fy_heapGetFieldDouble(context, handle, field, exception);
}

fisce_uint fy_heapLookupStringFromConstant(fy_context *context,
		ConstantStringInfo *constantStringInfo, fisce_exception *exception) {
	fisce_uint hvalue;
	if (!constantStringInfo->derefed) {
		fy_heapBeginProtect(context);
		hvalue = fy_heapLiteral(context, constantStringInfo->ci.string,
				exception);
		if (exception->exceptionType != exception_none) {
			return 0;
		}
		constantStringInfo->derefed = TRUE;
		constantStringInfo->ci.handle = hvalue;
	} else {
		hvalue = constantStringInfo->ci.handle;
	}
	return hvalue;
}

fisce_int fy_heapMultiArray(fy_context *context, fy_class *clazz, fisce_int layers,
		fisce_int *elementsForEachLayer, fisce_exception *exception) {
	int i;
	fisce_int handle;
	int size = elementsForEachLayer[0];
	int ret = fy_heapAllocateArray(context, clazz, size, exception);
	if (exception->exceptionType != exception_none) {
		return 0;
	}
	if (layers > 1) {
		for (i = 0; i < size; i++) {
			handle = fy_heapMultiArray(context, clazz->ci.arr.contentClass,
					layers - 1, elementsForEachLayer + 1, exception);
			if (exception->exceptionType != exception_none) {
				return 0;
			}
			fy_heapPutArrayHandle(context, ret, i, handle, exception);
			if (exception->exceptionType != exception_none) {
				return 0;
			}
		}
	}
	return ret;
}

void fy_heapCheckCast(fy_context *context, fisce_int fromHandle, fy_class *toClass, fisce_exception *exception){
    fy_class *clazz1;
    fy_memblock *block = context->memblocks;
    fy_str str1;
    if (fromHandle != 0) {
        clazz1 = fy_heapGetClassOfObject(context, fromHandle, exception);
        FYEH();
        if (unlikely(!fy_classCanCastTo(context, clazz1, toClass, TRUE))) {
            strcpy_s(exception->exceptionName,
                     sizeof(exception->exceptionName),
                     FY_EXCEPTION_CAST);
            str1.content = NULL;
            fy_strInit(block, &str1, 64, exception);
            fy_strAppendUTF8(block, &str1, "from ", 99, exception);
            fy_strAppend(block, &str1, clazz1->className,
                         exception);
            fy_strAppendUTF8(block, &str1, " to ", 99, exception);
            fy_strAppend(block, &str1, toClass->className,
                         exception);
            fy_strSPrint(exception->exceptionDesc,
                         sizeof(exception->exceptionDesc), &str1);
            fy_strDestroy(block, &str1);
            exception->exceptionType = exception_normal;
            FYEH();
        }
    }
}
