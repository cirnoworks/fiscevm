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

#include "fyc/CoreHandlers.h"
#include "fiscedev.h"

static void SystemGC(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {

}

static void SystemExit(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	context->exitCode = args[0];
}

static void StringIntern(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_str str;
	fy_uint ret;

	str.content = NULL;
	fy_strInit(context->memblocks, &str, 512, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_heapGetString(context, args[0], &str, exception);
	if (exception->exceptionType != exception_none) {
		fy_strDestroy(context->memblocks, &str);
		return;
	}
	ret = fy_heapLiteral(context, &str, exception);
	fy_strDestroy(context->memblocks, &str);
	fy_nativeReturnHandle(context, thread, ret);
}

static void SystemArrayCopy(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_int srcHandle = args[0];
	fy_int srcPos = args[1];
	fy_int dstHandle = args[2];
	fy_int dstPos = args[3];
	fy_int len = args[4];
	fy_heapArrayCopy(context, srcHandle, srcPos, dstHandle, dstPos, len,
			exception);
}

static void SystemTimeMS(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_nativeReturnLong(context, thread, fy_portTimeMillSec(context->port));
}

static void SystemTimeNS(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_nativeReturnLong(context, thread, fy_portTimeNanoSec(context->port));
}

static void SystemIdentityHashCode(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_nativeReturnInt(context, thread, args[0]);
}

static void ObjectGetClass(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_class *clazz = fy_heapGetClassOfObject(context, args[0]);
	fy_nativeReturnHandle(context, thread, clazz->classObjId);
}
static void ObjectClone(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_int ret = fy_heapClone(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnHandle(context, thread, ret);
}
static void ObjectWait(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_uint monitorId = args[0];
	fy_uint high = args[1];
	fy_uint low = args[2];
	fy_long time = fy_I2TOL(high,low);
	fy_tmWait(context, thread, monitorId, time, exception);
}

static void ObjectNotify(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_uint monitorId = args[0];
	fy_tmNotify(context, thread, monitorId, FALSE, exception);
}

static void ObjectNotifyAll(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_uint monitorId = args[0];
	fy_tmNotify(context, thread, monitorId, TRUE, exception);
}

static void ClassGetComponentType(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_heapGetClassOfObject(context, args[0]);
	if (clazz->type == arr) {
		fy_nativeReturnHandle(context, thread,
				clazz->ci.arr.contentClass->classObjId);
	} else {
		fy_nativeReturnHandle(context, thread, 0);
	}
}

static void ClassInvokeMethod(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_uint classHandle = args[0];
	fy_uint methodNameHandle = args[1];
	/*fy_boolean isStatic = args[2];*/
	fy_uint paramsHandle = args[3];
	fy_class *clazz = fy_vmGetClassFromClassObject(context, classHandle,
			exception);
	fy_str methodName;
	fy_exceptionCheckAndReturn(exception);
	fy_method *method;
	fy_byte *paramTypes;
	fy_uint count, i;
	fy_frame *currentFrame = thread->frames + (thread->frameCount - 1);
	fy_uint sp = currentFrame->sp;

	methodName.content = NULL;
	fy_strInit(context->memblocks, &methodName, 64, exception);
	fy_exceptionCheckAndReturn(exception);

	fy_strAppendUTF8(context->memblocks, &methodName, ".", 1, exception);
	if (exception->exceptionType != exception_none) {
		fy_strDestroy(context->memblocks, &methodName);
		return;
	}

	fy_heapGetString(context, methodNameHandle, &methodName, exception);
	if (exception->exceptionType != exception_none) {
		fy_strDestroy(context->memblocks, &methodName);
		return;
	}

	method = fy_vmLookupMethodVirtual(context, clazz, &methodName, exception);
	fy_strDestroy(context->memblocks, &methodName);
	fy_exceptionCheckAndReturn(exception);
	if (method == NULL) {
		fy_fault(exception, FY_EXCEPTION_ITE, "Method not found!");
		return;
	}
	if (method->returnType != FY_TYPE_HANDLE) {
		fy_fault(exception, FY_EXCEPTION_ITE, "Return type not Object!");
		return;
	}
	paramTypes = method->paramTypes;
	count = paramsHandle == 0 ?
			0 : fy_heapArrayLength(context, paramsHandle, exception);
	fy_exceptionCheckAndReturn(exception);
	if (count != method->paramCount) {
		fy_fault(exception, FY_EXCEPTION_ITE, "param count not match!");
		return;
	}
	for (i = 0; i < count; i++) {
		thread->stack[sp + i] = fy_heapGetArrayInt(context, paramsHandle, i,
				exception);
		fy_exceptionCheckAndReturn(exception);
		thread->typeStack[sp + i] = FY_TYPE_HANDLE;
		if (paramTypes[i] != FY_TYPE_HANDLE) {
			fy_fault(exception, FY_EXCEPTION_ITE, "param type not all handle");
			break;
		}
	}
	fy_threadPushMethod(context, thread, method, NULL, exception);
	fy_exceptionCheckAndReturn(exception);

}

static void ThreadCurrentThread(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_nativeReturnHandle(context, thread, thread->handle);
}

static void ThreadSetPriority(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_thread *target;
	fy_object *obj = context->objects + args[0];
	target = context->threads[obj->attachedId];
	if (target != NULL) {
		target->priority = args[1];
	}
}

static void ThreadIsAlive(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_nativeReturnInt(context, thread,
			fy_tmIsAlive(context, args[0], exception) ? 1 : 0);
}

static void ThreadInterrupt(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_tmInterrupt(context, args[0], exception);
}

static void ThreadInterrupted(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_boolean ret;
	ret = fy_tmIsInterrupted(context, args[0], args[1], exception);
	fy_nativeReturnInt(context, thread, ret ? 1 : 0);
}

static void ThreadStart(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_tmPushThread(context, args[0], exception);
}

static void ThreadSleep(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_tmSleep(context, thread, fy_I2TOL(args[0],args[1]));
}

static void ThreadYield(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	thread->yield = TRUE;
}

static void VMDebugOut(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_str *str;
	fy_memblock *block = context->memblocks;
	fy_vmLookupClass(context, context->sString, exception);
	if (exception->exceptionType != exception_none) {
		return;
	}
	str = fy_strCreate(block, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_heapGetString(context, args[0], str, exception);
	if (exception->exceptionType != exception_none) {
		return;
	}
	printf("VMDebugOut: ");
	fy_strPrint(str);
	printf("\n");
	fy_strRelease(block, str);
}

static void VMDebugOutI(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	printf("VMDebugOutI: %d\n", args[0]);
}

static void VMDebugOutJ(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	printf("VMDebugOutI: %"FY_PRINT64"d\n", fy_I2TOL(args[0],args[1]));
}

static void VMDebugOutF(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	printf("VMDebugOutI: %f\n", fy_intToFloat(args[0]));
}

static void VMDebugOutD(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	printf("VMDebugOutI: %f\n", fy_longToDouble(fy_I2TOL(args[0],args[1])));
}

static void VMThrowOut(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	/*TODO */
	thread->currentThrowable = args[0];
}

static void VMExit(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	/*TODO */
}

static void SOSWrite(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	putchar(args[1]);
}

static void VMDecode(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_int handleSrc = args[1];
	fy_int ofs = args[2];
	fy_int len = args[3];
	int i, maxi;
	fy_byte *array;
	fy_byte *newArray;
	fy_str *str;
	fy_int handleRet;
	fy_class *charArray;
	fy_memblock *block = context->memblocks;
	charArray = fy_vmLookupClass(context, context->sArrayChar, exception);
	if (exception->exceptionType != exception_none) {
		fy_nativeReturnHandle(context, thread, 0);
		return;
	}
	array = fy_heapGetArrayBytes(context, handleSrc, exception);
	if (exception->exceptionType != exception_none) {
		fy_nativeReturnHandle(context, thread, 0);
		return;
	}

	newArray = fy_allocate(len + 1, exception);
	fy_exceptionCheckAndReturn(exception);
	memcpy(newArray, array + ofs, len);
	newArray[len] = 0;
	str = fy_strCreateFromUTF8(block, (char*) newArray, exception);
	fy_free(newArray);
	fy_exceptionCheckAndReturn(exception);

	handleRet = fy_heapAllocateArray(context, charArray, maxi = str->length,
			exception);
	if (exception->exceptionType != exception_none) {
		fy_nativeReturnHandle(context, thread, 0);
		fy_strDestroy(block, str);
		fy_free(str);
		return;
	}
	for (i = 0; i < maxi; i++) {
		fy_heapPutArrayChar(context, handleRet, i, str->content[i], exception);
		if (exception->exceptionType != exception_none) {
			fy_nativeReturnHandle(context, thread, 0);
			fy_strDestroy(block, str);
			fy_free(str);
			return;
		}
	}
	fy_strDestroy(block, str);
	fy_free(str);
	fy_nativeReturnHandle(context, thread, handleRet);
}

static void VMEncode(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_int handleSrc = args[1];
	fy_int ofs = args[2];
	fy_int len = args[3];
	fy_class *byteClass;
	fy_int handleRet;
	fy_byte *out;
	fy_byte *outTmp;
	fy_int olen;
	fy_int left;
	fy_int read;
	fy_int i;
	fy_char ch;
	byteClass = fy_vmLookupClass(context, context->sArrayByte, exception);
	if (exception->exceptionType != exception_none) {
		fy_nativeReturnHandle(context, thread, 0);
		return;
	}
	left = len * 3 + 1;
	olen = 0;
	out = outTmp = fy_allocate(left, exception);
	fy_exceptionCheckAndReturn(exception);
	for (i = 0; i < len; i++) {
		ch = fy_heapGetArrayChar(context, handleSrc, i + ofs, exception);
		if (exception->exceptionType != exception_none) {
			fy_nativeReturnHandle(context, thread, 0);
			fy_free(out);
			return;
		}
		read = fy_utf8Write(ch, (char**) &outTmp, &left);
		if (read <= 0) {
			break;
		}
		olen += read;
	}
	handleRet = fy_heapAllocateArray(context, byteClass, olen, exception);
	if (exception->exceptionType != exception_none) {
		fy_nativeReturnHandle(context, thread, 0);
		fy_free(out);
		return;
	}

	outTmp = fy_heapGetArrayBytes(context, handleRet, exception);
	if (exception->exceptionType != exception_none) {
		fy_nativeReturnHandle(context, thread, 0);
		fy_free(out);
		return;
	}

	memcpy(outTmp, out, olen);
	fy_free(out);
	fy_nativeReturnHandle(context, thread, handleRet);
}

static void VMGetDoubleRaw(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_nativeReturnLong(context, thread,
			((fy_long) args[0] << 32) | ((fy_uint) args[1]));
}

static void VMGetFloatRaw(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_nativeReturnInt(context, thread, args[0]);
}

static void VMStringToDouble(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_memblock *block = context->memblocks;
	fy_str *str = fy_strCreate(block, exception);
	fy_exceptionCheckAndReturn(exception);
	char ch[64];
	fy_double value;
	str = fy_heapGetString(context, args[0], str, exception);
	fy_strSPrint(ch, sizeof(ch), str);
	value = atof(ch);
	fy_nativeReturnLong(context, thread, fy_doubleToLong(value));
}

static void VMDoubleToString(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_memblock *block = context->memblocks;
	fy_long lvalue = ((fy_ulong) args[0] << 32) | ((fy_uint) args[1]);
	fy_double dvalue = fy_longToDouble(lvalue);
	fy_int handleRet;
	fy_str *str;
	char ch[64];
	sprintf_s(ch, sizeof(ch), "%f", dvalue);
	str = fy_strCreateFromUTF8(block, ch, exception);
	fy_exceptionCheckAndReturn(exception);
	handleRet = fy_heapMakeString(context, str, exception);
	fy_strRelease(block, str);
	if (exception->exceptionType != exception_none) {
		return;
	}
	fy_nativeReturnHandle(context, thread, handleRet);
}

static void VMStringToFloat(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_memblock *block = context->memblocks;
	fy_str *str = fy_strCreate(block, exception);
	fy_exceptionCheckAndReturn(exception);
	char ch[64];
	fy_double value;
	str = fy_heapGetString(context, args[0], str, exception);
	fy_strSPrint(ch, sizeof(ch), str);
	value = atof(ch);
	fy_nativeReturnInt(context, thread, fy_floatToInt((fy_float) value));
}

static void VMFloatToString(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_memblock *block = context->memblocks;
	fy_int value = args[0];
	fy_float fvalue = fy_intToFloat(value);
	fy_int handleRet;
	fy_str *str;
	char ch[64];
	sprintf_s(ch, sizeof(ch), "%f", fvalue);
	str = fy_strCreateFromUTF8(block, ch, exception);
	fy_exceptionCheckAndReturn(exception);
	handleRet = fy_heapMakeString(context, str, exception);
	fy_strRelease(block, str);
	if (exception->exceptionType != exception_none) {
		return;
	}
	fy_nativeReturnHandle(context, thread, handleRet);
}

static void throwableFillInStackTrace(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_int value = args[0];
	fy_threadFillException(context, thread, value, exception);
}

static void classGetName(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_uint handle;
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	if (exception->exceptionType != exception_none) {
		return;
	}
	handle = fy_heapMakeString(context, clazz->className, exception);
	if (exception->exceptionType != exception_none) {
		return;
	}
	fy_nativeReturnHandle(context, thread, handle);
}

static void classForName(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_uint nameHandle = args[0];
	fy_boolean initialize = args[1];
	fy_str str;
	fy_class *clazz;
	str.content = NULL;
	fy_strInit(context->memblocks, &str, 64, exception);
	fy_exceptionCheckAndReturn(exception);

	fy_heapGetString(context, nameHandle, &str, exception);
	if (exception->exceptionType != exception_none) {
		fy_strDestroy(context->memblocks, &str);
		return;
	}
	fy_strReplaceOne(&str, '.', '/');
	clazz = fy_vmLookupClass(context, &str, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnHandle(context, thread, clazz->classObjId);
}

static void classNewInstanceO(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz;
	fy_frame *currentFrame = thread->frames + thread->frameCount - 1;
	fy_method *invoke;
	fy_str str;
	fy_uint sp;
	fy_uint handle;
	clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	if (clazz->type != obj) {
		fy_fault(exception, FY_EXCEPTION_RT, "Class is not an object class!");
		return;
	}
	handle = fy_heapAllocate(context, clazz, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnHandle(context, thread, handle);
	sp = currentFrame->sp;
	str.content = NULL;
	fy_strInitWithUTF8(context->memblocks, &str, "."FY_METHOD_INIT".()V",
			exception);
	fy_exceptionCheckAndReturn(exception);
	invoke = fy_vmLookupMethodVirtual(context, clazz, &str, exception);
	fy_strDestroy(context->memblocks, &str);
	fy_exceptionCheckAndReturn(exception);
	thread->stack[sp] = handle;
	thread->typeStack[sp] = FY_TYPE_HANDLE;
	fy_threadPushMethod(context, thread, invoke, NULL, exception);
}

/*Make an array of array class for example Object[]->Object[]*/
static void classNewInstanceA(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz;
	clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	if (clazz->type != arr) {
		fy_fault(exception, FY_EXCEPTION_RT, "Class is not an object class!");
	}
	fy_nativeReturnHandle(context, thread,
			fy_heapAllocateArray(context, clazz, args[1], exception));
}

static void vmNewInstance(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_class *clazz;
	fy_frame *currentFrame = thread->frames + thread->frameCount - 1;
	fy_method *invoke;
	fy_str str;
	fy_uint sp;
	fy_uint handle;
	fy_uint paramsArray = args[2];
	fy_uint paramsClassArray = args[1];
	fy_uint paramClassHandle;
	fy_int len, i;
	fy_class *paramClass;
	clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	if (clazz->type != obj) {
		fy_fault(exception, FY_EXCEPTION_RT, "Class is not an object class!");
		return;
	}
	len = fy_heapArrayLength(context, paramsArray, exception);
	fy_exceptionCheckAndReturn(exception);

	handle = fy_heapAllocate(context, clazz, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnHandle(context, thread, handle);
	sp = currentFrame->sp;
	str.content = NULL;
	fy_strInitWithUTF8(context->memblocks, &str, "."FY_METHOD_INIT".(",
			exception);
	fy_exceptionCheckAndReturn(exception);
	for (i = 0; i < len; i++) {
		paramClassHandle = fy_heapGetArrayHandle(context, paramsClassArray, i,
				exception);
		if (exception->exceptionType != exception_none) {
			fy_strDestroy(context->memblocks, &str);
			return;
		}
		paramClass = fy_vmGetClassFromClassObject(context, paramClassHandle,
				exception);
		if (exception->exceptionType != exception_none) {
			fy_strDestroy(context->memblocks, &str);
			return;
		}
		switch (paramClass->type) {
		case obj:
			fy_strAppendUTF8(context->memblocks, &str, "L", 1, exception);
			if (exception->exceptionType != exception_none) {
				fy_strDestroy(context->memblocks, &str);
				return;
			}
			fy_strAppend(context->memblocks, &str, paramClass->className,
					exception);
			if (exception->exceptionType != exception_none) {
				fy_strDestroy(context->memblocks, &str);
				return;
			}
			fy_strAppendUTF8(context->memblocks, &str, ";", 1, exception);
			if (exception->exceptionType != exception_none) {
				fy_strDestroy(context->memblocks, &str);
				return;
			}
			break;
		case arr:
			fy_strAppend(context->memblocks, &str, paramClass->className,
					exception);
			if (exception->exceptionType != exception_none) {
				fy_strDestroy(context->memblocks, &str);
				return;
			}
			break;
		case prm:
			fy_strAppendChar(context->memblocks, &str, paramClass->ci.prm.pType,
					exception);
			if (exception->exceptionType != exception_none) {
				fy_strDestroy(context->memblocks, &str);
				return;
			}
			break;
		default:
			fy_fault(exception, NULL, "Invalid class type %d",
					paramClass->type);
			break;
		}
	}
	fy_strAppendUTF8(context->memblocks, &str, ")V", 2, exception);
	if (exception->exceptionType != exception_none) {
		fy_strDestroy(context->memblocks, &str);
		return;
	}
	invoke = fy_vmLookupMethodVirtual(context, clazz, &str, exception);
	fy_strDestroy(context->memblocks, &str);
	fy_exceptionCheckAndReturn(exception);
	thread->stack[sp] = handle;
	thread->typeStack[sp] = FY_TYPE_HANDLE;
	for (i = 0; i < len; i++) {
		paramClassHandle = fy_heapGetArrayHandle(context, paramsArray, i,
				exception);
		fy_exceptionCheckAndReturn(exception);
		thread->stack[sp + i + 1] = paramClassHandle;
		thread->typeStack[sp + i + 1] = FY_TYPE_HANDLE;
	}
	fy_threadPushMethod(context, thread, invoke, NULL, exception);
}

/*Make an array of any class for example Object->Object[]*/
static void vmNewArray(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_class *clazz;
	fy_str str;
	fy_char *cc;
	clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);

	str.content = NULL;
	fy_strInit(context->memblocks, &str, clazz->className->length + 3,
			exception);
	fy_exceptionCheckAndReturn(exception);
	switch (clazz->type) {
	case obj:
		fy_strAppendUTF8(context->memblocks, &str, "[L", 2, exception);
		fy_strAppend(context->memblocks, &str, clazz->className, exception);
		fy_strAppendChar(context->memblocks, &str, ';', exception);
		break;
	case arr:
		fy_strAppendUTF8(context->memblocks, &str, "[", 1, exception);
		fy_strAppend(context->memblocks, &str, clazz->className, exception);
		break;
	case prm:
		fy_strAppendChar(context->memblocks, &str, '[', exception);
		cc = fy_hashMapGet(context->memblocks, context->mapPrimitivesRev,
				clazz->className);
		fy_strAppendChar(context->memblocks, &str, *cc, exception);
		break;
	}
	if (exception->exceptionType != exception_none) {
		fy_strDestroy(context->memblocks, &str);
		return;
	}
	clazz = fy_vmLookupClass(context, &str, exception);
	fy_strDestroy(context->memblocks, &str);
	fy_exceptionCheckAndReturn(exception);
	if (clazz->type != arr) {
		fy_fault(exception, FY_EXCEPTION_RT, "Class is not an object class!");
	}
	fy_nativeReturnHandle(context, thread,
			fy_heapAllocateArray(context, clazz, args[1], exception));
}

static void classIsInstance(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_class *objClazz = fy_heapGetObject(context,args[1])->clazz;
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnInt(context, thread,
			fy_classCanCastTo(context, objClazz, clazz) ? 1 : 0);
}

static void classIsAssignableFrom(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_class *targetClazz = fy_vmGetClassFromClassObject(context, args[1],
			exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnInt(context, thread,
			fy_classCanCastTo(context, clazz, targetClazz) ? 1 : 0);
}

static void classIsInterface(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnInt(context, thread,
			(clazz->accessFlags & FY_ACC_INTERFACE) ? 1 : 0);
}

static void classIsArray(struct fy_context *context, struct fy_thread *thread,
		void *data, fy_uint *args, fy_int argsCount, fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnInt(context, thread, clazz->type == arr ? 1 : 0);
}

static void classIsPrimitive(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	fy_nativeReturnInt(context, thread, clazz->type == prm ? 1 : 0);
}

static void classGetSuperclass(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_exceptionCheckAndReturn(exception);
	clazz = clazz->super;
	fy_nativeReturnInt(context, thread, clazz == NULL ? 0 : clazz->classObjId);
}

static void classGetInterfaces(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_class *clazz = fy_vmGetClassFromClassObject(context, args[0], exception);
	fy_class *classOfClass;
	fy_uint ret, i, imax;
	fy_exceptionCheckAndReturn(exception);
	classOfClass = fy_vmLookupClass(context, context->sClassClass, exception);
	fy_exceptionCheckAndReturn(exception);
	imax = clazz->interfacesCount;
	ret = fy_heapAllocateArray(context, classOfClass, imax, exception);
	fy_exceptionCheckAndReturn(exception);
	for (i = 0; i < imax; i++) {
		fy_heapPutArrayHandle(context, ret, i, clazz->interfaces[i]->classObjId,
				exception);
		fy_exceptionCheckAndReturn(exception);
	}
	fy_nativeReturnHandle(context, thread, ret);
}

static void finalizerGetFinalizee(struct fy_context *context,
		struct fy_thread *thread, void *data, fy_uint *args, fy_int argsCount,
		fy_exception *exception) {
	fy_uint ret;
	fy_int storage, i, len = context->toFinalize->length;

	fy_class *clazz = fy_vmLookupClass(context, context->sArrayObject,
			exception);
	fy_exceptionCheckAndReturn(exception);

	ret = fy_heapAllocateArray(context, clazz, len, exception);
	fy_exceptionCheckAndReturn(exception);

	for (i = 0; i < len; i++) {
		fy_arrayListGet(context->memblocks, context->toFinalize, i, &storage);
		fy_heapPutArrayHandle(context, ret, i, storage, exception);
		fy_exceptionCheckAndReturn(exception);
	}
	fy_nativeReturnHandle(context, thread, ret);
}

void fy_coreRegisterCoreHandlers(fy_context *context, fy_exception *exception) {
	/*vm*/
	fy_vmRegisterNativeHandler(context,
			FY_BASE_VM".newInstance0.(L"FY_BASE_CLASS";I)[L"FY_BASE_OBJECT";",
			NULL, classNewInstanceA, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			FY_BASE_VM".newInstance0.(L"FY_BASE_CLASS";[L"FY_BASE_CLASS";[L"FY_BASE_OBJECT";)L"FY_BASE_OBJECT";",
			NULL, vmNewInstance, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_VM".newArray0.(L"FY_BASE_CLASS";I)[L"FY_BASE_OBJECT";",
			NULL, vmNewArray, exception);
	fy_exceptionCheckAndReturn(exception);
	/*String*/
	fy_vmRegisterNativeHandler(context,
			FY_BASE_STRING".intern.()L"FY_BASE_STRING";", NULL, StringIntern,
			exception);
	fy_exceptionCheckAndReturn(exception);

	/*System*/
	fy_vmRegisterNativeHandler(
			context,
			FY_BASE_SYSTEM".arraycopy.(L"FY_BASE_OBJECT";IL"FY_BASE_OBJECT";II)V",
			NULL, SystemArrayCopy, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_SYSTEM".currentTimeMillis.()J",
			NULL, SystemTimeMS, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_SYSTEM".nanoTime.()J", NULL,
			SystemTimeNS, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_SYSTEM".identityHashCode.(L"FY_BASE_OBJECT";)I", NULL,
			SystemIdentityHashCode, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_SYSTEM".gc.()V", NULL, SystemGC,
			exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_SYSTEM".exit.(I)V", NULL,
			SystemExit, exception);
	fy_exceptionCheckAndReturn(exception);

	/*Class*/
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".getComponentType.()L"FY_BASE_CLASS";", NULL,
			ClassGetComponentType, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			FY_BASE_CLASS".invokeMethodHandleReturn0.(L"FY_BASE_STRING";Z[L"FY_BASE_OBJECT";)L"FY_BASE_OBJECT";",
			NULL, ClassInvokeMethod, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".forName0.(L"FY_BASE_STRING";Z)L"FY_BASE_CLASS";",
			NULL, classForName, exception);
	fy_exceptionCheckAndReturn(exception);

	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".newInstance0.()L"FY_BASE_OBJECT";", NULL,
			classNewInstanceO, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".isInstance.(L"FY_BASE_OBJECT";)Z", NULL,
			classIsInstance, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".isAssignableFrom.(L"FY_BASE_CLASS";)Z", NULL,
			classIsAssignableFrom, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_CLASS".isInterface.()Z", NULL,
			classIsInterface, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_CLASS".isArray.()Z", NULL,
			classIsArray, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_CLASS".isPrimitive.()Z", NULL,
			classIsPrimitive, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".getSuperclass.()L"FY_BASE_CLASS";", NULL,
			classGetSuperclass, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".getInterfaces.()[L"FY_BASE_CLASS";", NULL,
			classGetInterfaces, exception);
	fy_exceptionCheckAndReturn(exception);

	/*Object*/
	fy_vmRegisterNativeHandler(context,
			FY_BASE_OBJECT".clone.()L"FY_BASE_OBJECT";", NULL, ObjectClone,
			exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_OBJECT".getClass.()L"FY_BASE_CLASS";", NULL, ObjectGetClass,
			exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_OBJECT".wait.(J)V", NULL,
			ObjectWait, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_OBJECT".notify.()V", NULL,
			ObjectNotify, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_OBJECT".notifyAll.()V", NULL,
			ObjectNotifyAll, exception);
	fy_exceptionCheckAndReturn(exception);

	/*Thread*/
	fy_vmRegisterNativeHandler(context,
			FY_BASE_THREAD".currentThread.()L"FY_BASE_THREAD";", NULL,
			ThreadCurrentThread, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".setPriority0.(I)V",
			NULL, ThreadSetPriority, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".isAlive.()Z", NULL,
			ThreadIsAlive, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".start0.()V", NULL,
			ThreadStart, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".interrupt0.()V", NULL,
			ThreadInterrupt, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".isInterrupted.(Z)Z",
			NULL, ThreadInterrupted, exception);
	fy_exceptionCheckAndReturn(exception);

	/*FiScEVM*/
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.debugOut.(L"FY_BASE_STRING";)V",
			NULL, VMDebugOut, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.debugOut.(I)V", NULL,
			VMDebugOutI, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.debugOut.(J)V", NULL,
			VMDebugOutJ, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.debugOut.(F)V", NULL,
			VMDebugOutF, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.debugOut.(D)V", NULL,
			VMDebugOutD, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.throwOut.(L"FY_BASE_THROWABLE";L"FY_BASE_STRING";)V",
			NULL, VMThrowOut, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.exit.(I)V", NULL, VMExit,
			exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.decode.(L"FY_BASE_STRING";[BII)[C",
			NULL, VMDecode, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.encode.(L"FY_BASE_STRING";[CII)[B",
			NULL, VMEncode, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.getDoubleRaw.(D)J", NULL,
			VMGetDoubleRaw, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			"com/cirnoworks/fisce/privat/FiScEVM.getFloatRaw.(F)I", NULL,
			VMGetFloatRaw, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.stringToDouble.(L"FY_BASE_STRING";)D",
			NULL, VMStringToDouble, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.doubleToString.(D)L"FY_BASE_STRING";",
			NULL, VMDoubleToString, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.stringToFloat.(L"FY_BASE_STRING";)F",
			NULL, VMStringToFloat, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/FiScEVM.floatToString.(F)L"FY_BASE_STRING";",
			NULL, VMFloatToString, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(
			context,
			"com/cirnoworks/fisce/privat/SystemOutputStream.write0.(IL"FY_BASE_STRING";)V",
			NULL, SOSWrite, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_THROWABLE".fillInStackTrace0.()V", NULL,
			throwableFillInStackTrace, exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context,
			FY_BASE_CLASS".getName0.()L"FY_BASE_STRING";", NULL, classGetName,
			exception);
	fy_exceptionCheckAndReturn(exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".sleep.(J)V", NULL,
			ThreadSleep, exception);
	fy_vmRegisterNativeHandler(context, FY_BASE_THREAD".yield.()V", NULL,
			ThreadYield, exception);
	fy_exceptionCheckAndReturn(exception);

	fy_vmRegisterNativeHandler(context,
			FY_BASE_FINALIZER".getFinalizee.()[L"FY_BASE_OBJECT";", NULL,
			finalizerGetFinalizee, exception);
	fy_exceptionCheckAndReturn(exception);

}