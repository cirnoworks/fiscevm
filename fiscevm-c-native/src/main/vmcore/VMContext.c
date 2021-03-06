/**
 *  Copyright 2010-2015 Yuxuan Huang. All rights reserved.
 *
 * This file is part offiscevm
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
 * along withfiscevm  If not, see <http://www.gnu.org/licenses/>.
 */

/* pedantic: Every C code and header with structure definition in FiScE
 * should include following two headers at very first*/
#include "fy_util/Portable.h"
#include "fyc/Config.h"

#include "fy_util/Debug.h"
#include "fyc/Debug.h"
#include "fyc/VMContext.h"
#include "fyc/Constants.h"
#include "fyc/ClassLoader.h"
#include "fyc/Heap.h"
#include "fyc/Instructions.h"
#include "fyc/FileInputStream.h"
#include "fyc/BinarySaver.h"
#include "fyc/BAIS.h"
#include "fyc/RIS.h"
#include "fyc/Engine.h"
#include "fyc/ThreadManager.h"
#include "fyc/CoreHandlers.h"

/***********private***********/
static void initConstantStrings(fy_context *context, fisce_exception *exception) {
	context->sAttCode = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_ATT_CODE);
	FYEH();

	context->sAttLineNum = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_ATT_LINENUM);
	FYEH();

	context->sAttStackMapTable = fy_vmCreateStringByPoolV(context, exception,
			"a", FY_ATT_STACK_MAP_TABLE);
	FYEH();

	context->sAttSynth = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_ATT_SYNTH);
	FYEH();

	context->sAttSourceFile = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_ATT_SOURCE_FILE);
	FYEH();
	context->sAttConstantValue = fy_vmCreateStringByPoolV(context, exception,
			"a", FY_ATT_CONSTANT_VALIE);
	FYEH();
	context->sBoolean = fy_vmCreateStringByPoolV(context, exception, "a",
			"boolean");
	FYEH();

	context->sByte = fy_vmCreateStringByPoolV(context, exception, "a", "byte");
	FYEH();

	context->sShort = fy_vmCreateStringByPoolV(context, exception, "a",
			"short");
	FYEH();

	context->sChar = fy_vmCreateStringByPoolV(context, exception, "a", "char");
	FYEH();

	context->sInt = fy_vmCreateStringByPoolV(context, exception, "a", "int");
	FYEH();

	context->sFloat = fy_vmCreateStringByPoolV(context, exception, "a",
			"float");
	FYEH();

	context->sLong = fy_vmCreateStringByPoolV(context, exception, "a", "long");
	FYEH();

	context->sDouble = fy_vmCreateStringByPoolV(context, exception, "a",
			"double");
	FYEH();

	context->sVoid = fy_vmCreateStringByPoolV(context, exception, "a", "void");
	FYEH();

	context->sEnum = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_ENUM);
	FYEH();

	context->sAnnotation = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_ANNOTATION);
	FYEH();

	context->sTopClass = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_OBJECT);
	FYEH();

	context->sClassClass = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_CLASS);
	FYEH();

	context->sClassField = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_REFLECT_FIELD);
	FYEH();

	context->sClassMethod = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_REFLECT_METHOD);
	FYEH();

	context->sClassConstructor = fy_vmCreateStringByPoolV(context, exception,
			"a", FY_REFLECT_CONSTRUCTOR);
	FYEH();

	context->sClassThrowable = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_THROWABLE);
	FYEH();

	context->sString = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_STRING);
	FYEH();

	context->sThread = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_THREAD);
	FYEH();

	context->sStringArray = fy_vmCreateStringByPoolV(context, exception, "a",
			"[L"FY_BASE_STRING";");
	FYEH();

	context->sThrowablePrintStacktrace = fy_vmCreateStringByPoolV(context,
			exception, "a", FY_BASE_THROWABLE".printStackTrace.()V");
	FYEH();

	context->sThrowableDetailMessage = fy_vmCreateStringByPoolV(context,
			exception, "a",
			FY_BASE_THROWABLE".detailMessage.L"FY_BASE_STRING";");
	FYEH();

	context->sInit = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_METHOD_INIT);
	FYEH();

	context->sClinit = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_METHOD_CLINIT);
	FYEH();

	context->sFMain = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_METHODF_MAIN);
	FYEH();

	context->sFRun = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_METHODF_RUN);
	FYEH();

	context->sFName = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_FIELDF_NAME);
	FYEH();

	context->sMFinalize = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_METHODF_FINALIZE);
	FYEH();

	context->sFPriority = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_FIELDF_PRIORITY);
	FYEH();

	context->sFDaemon = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_FIELDF_DAEMON);
	FYEH();

	context->sStringCount = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_STRING".count.I");
	FYEH();

	context->sStringValue = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_STRING".value.[C");
	FYEH();

	context->sStringOffset = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_STRING".offset.I");
	FYEH();

	context->sStackTraceElement = fy_vmCreateStringByPoolV(context, exception,
			"a", FY_BASE_STACKTHREADELEMENT);
	FYEH();

	context->sStackTraceElementArray = fy_vmCreateStringByPoolV(context,
			exception, "a", "[L"FY_BASE_STACKTHREADELEMENT";");
	FYEH();

	context->sStackTraceElementDeclaringClass = fy_vmCreateStringByPoolV(
			context, exception, "a",
			FY_BASE_STACKTHREADELEMENT".declaringClass.L"FY_BASE_STRING";");
	FYEH();

	context->sStackTraceElementMethodName = fy_vmCreateStringByPoolV(context,
			exception, "a",
			FY_BASE_STACKTHREADELEMENT".methodName.L"FY_BASE_STRING";");
	FYEH();

	context->sStackTraceElementFileName = fy_vmCreateStringByPoolV(context,
			exception, "a",
			FY_BASE_STACKTHREADELEMENT".fileName.L"FY_BASE_STRING";");
	FYEH();

	context->sStackTraceElementLineNumber = fy_vmCreateStringByPoolV(context,
			exception, "a", FY_BASE_STACKTHREADELEMENT".lineNumber.I");
	FYEH();

	context->sThrowableStackTrace = fy_vmCreateStringByPoolV(context, exception,
			"a",
			FY_BASE_THROWABLE".stackTrace.[L"FY_BASE_STACKTHREADELEMENT";");
	FYEH();

	context->sArrayBoolean = fy_vmCreateStringByPoolV(context, exception, "a",
			"[Z");
	FYEH();

	context->sArrayChar = fy_vmCreateStringByPoolV(context, exception, "a",
			"[C");
	FYEH();

	context->sArrayFloat = fy_vmCreateStringByPoolV(context, exception, "a",
			"[F");
	FYEH();

	context->sArrayDouble = fy_vmCreateStringByPoolV(context, exception, "a",
			"[D");
	FYEH();

	context->sArrayByte = fy_vmCreateStringByPoolV(context, exception, "a",
			"[B");
	FYEH();

	context->sArrayShort = fy_vmCreateStringByPoolV(context, exception, "a",
			"[S");
	FYEH();

	context->sArrayInteger = fy_vmCreateStringByPoolV(context, exception, "a",
			"[I");
	FYEH();

	context->sArrayLong = fy_vmCreateStringByPoolV(context, exception, "a",
			"[J");
	FYEH();

	context->sArrayObject = fy_vmCreateStringByPoolV(context, exception, "a",
			"[L"FY_BASE_OBJECT";");
	FYEH();

	context->sArrayClass = fy_vmCreateStringByPoolV(context, exception, "a",
			"[L"FY_BASE_CLASS";");
	FYEH();

	context->sValueBoolean = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_BOOLEAN);
	FYEH();

	context->sValueByte = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_BYTE);
	FYEH();

	context->sValueChar = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_CHARACTER);
	FYEH();

	context->sValueShort = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_SHORT);
	FYEH();

	context->sValueInt = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_INTEGER);
	FYEH();

	context->sValueFloat = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_FLOAT);
	FYEH();

	context->sValueLong = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_LONG);
	FYEH();

	context->sValueDouble = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_VALUE_DOUBLE);
	FYEH();

	context->sClassBoolean = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_BOOLEAN);
	FYEH();

	context->sClassByte = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_BYTE);
	FYEH();
	context->sClassChar = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_CHAR);
	FYEH();

	context->sClassShort = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_SHORT);
	FYEH();

	context->sClassInt = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_INT);
	FYEH();

	context->sClassFloat = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_FLOAT);
	FYEH();

	context->sClassLong = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_LONG);
	FYEH();

	context->sClassDouble = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_BASE_DOUBLE);
	FYEH();

	context->sPhantomReference = fy_vmCreateStringByPoolV(context, exception,
			"a", FY_REF_PHANTOM);
	FYEH();

	context->sSoftReference = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_REF_SOFT);
	FYEH();

	context->sWeakReference = fy_vmCreateStringByPoolV(context, exception, "a",
	FY_REF_WEAK);
	FYEH();
}

static void initConstantPrimitives(fy_context *context, fisce_exception *exception) {
	fisce_char *cc;
	fy_memblock *block = context->memblocks;

	context->primitives[FY_TYPE_BOOLEAN] = context->sBoolean;
	context->primitives[FY_TYPE_BYTE] = context->sByte;
	context->primitives[FY_TYPE_SHORT] = context->sShort;
	context->primitives[FY_TYPE_CHAR] = context->sChar;
	context->primitives[FY_TYPE_INT] = context->sInt;
	context->primitives[FY_TYPE_FLOAT] = context->sFloat;
	context->primitives[FY_TYPE_LONG] = context->sLong;
	context->primitives[FY_TYPE_DOUBLE] = context->sDouble;
	context->primitives[FY_TYPE_VOID] = context->sVoid;

	fy_hashMapInitPerm(block, context->mapPrimitivesRev, 19, exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_BOOLEAN;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sBoolean, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_BYTE;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sByte, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_SHORT;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sShort, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_CHAR;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sChar, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_INT;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sInt, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_FLOAT;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sFloat, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_LONG;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sLong, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_DOUBLE;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sDouble, cc,
			exception);
	FYEH();

	cc = fy_mmAllocatePerm(block, sizeof(fisce_char), exception);
	FYEH();
	*cc = FY_TYPE_VOID;
	fy_hashMapPut(block, context->mapPrimitivesRev, context->sVoid, cc,
			exception);
	FYEH();
}

static void initStructClassloader(fy_context *context, fisce_exception *exception) {
	fy_memblock *block = context->memblocks;
	fy_hashMapInitPerm(block, context->mapClassNameToId, 1024, exception);
	FYEH();

	fy_hashMapInitPerm(block, context->mapFieldNameToId, 4096, exception);
	FYEH();

	fy_hashMapInitPerm(block, context->mapMethodNameToId, 4096, exception);
	FYEH();

	fy_hashMapInitPerm(block, context->mapMUNameToNH, 1024, exception);
	FYEH();

	fy_hashMapIInitPerm(block, context->classObjIds, 7, -1, exception);
	FYEH();

	fy_hashMapIInitPerm(block, context->methodObjIds, 7, -1, exception);
	FYEH();

	fy_hashMapIInitPerm(block, context->fieldObjIds, 7, -1, exception);
	FYEH();

	fy_hashMapIInitPerm(block, context->constructorObjIds, 7, -1, exception);
	FYEH();

	fy_hashMapInitPerm(block, context->customClassData, 128, exception);
	FYEH();

	fy_hashMapIInit(block, context->references, 7, 13, 0, exception);
	FYEH();
}

static void initThreadManager(fy_context *context, fisce_exception *exception) {
	context->nextThreadId = 1;

	context->runningThreads = fy_arrayListCreatePerm(context->memblocks,
			sizeof(fy_thread*), 128, exception);
	FYEH();

	context->state = FY_TM_STATE_NEW;

	context->pricmds[0] = 10;
	context->pricmds[1] = 125;
	context->pricmds[2] = 250;
	context->pricmds[3] = 500;
	context->pricmds[4] = 1000;
	context->pricmds[5] = 2000;
	context->pricmds[6] = 4000;
	context->pricmds[7] = 8000;
	context->pricmds[8] = 16000;
	context->pricmds[9] = 32000;
	context->pricmds[10] = 64000;
}

static void mkReplData(fy_context *context, fisce_exception *exception,
		fy_repl_data **replDatas, fisce_int op, fisce_int count, ...) {
	int i;
	va_list arg_ptr;
	replDatas[op] = fy_mmAllocatePerm(context->memblocks, sizeof(fy_repl_data),
			exception);
	FYEH();
	replDatas[op]->op = op;
	replDatas[op]->repl_count = count;
	replDatas[op]->ops = fy_mmAllocatePerm(context->memblocks,
			sizeof(fisce_int) * count, exception);
	FYEH();
	va_start(arg_ptr, count);
	for (i = 0; i < count; i++) {
		replDatas[op]->ops[i] = va_arg(arg_ptr, fisce_int);
	}
	va_end(arg_ptr);
}

static void initEngine(fy_context *context, fisce_exception *exception) {
	int i;

	context->engines = fy_mmAllocatePerm(context->memblocks,
			sizeof(fy_engine) * FY_ENGINE_COUNT, exception);
	FYEH();

	for (i = 0; i < FY_ENGINE_COUNT; i++) {
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_iload, 24, /**/
				FY_OP_iload_r0,
				FY_OP_iload_r1,
				FY_OP_iload_r2,
				FY_OP_iload_r3,
				FY_OP_iload_r4,
				FY_OP_iload_r5,
				FY_OP_iload_r6,
				FY_OP_iload_r7,
				FY_OP_iload_r8,
				FY_OP_iload_r9,
				FY_OP_iload_r10,
				FY_OP_iload_r11,
				FY_OP_iload_r12,
				FY_OP_iload_r13,
				FY_OP_iload_r14,
				FY_OP_iload_r15,
				FY_OP_iload_r16,
				FY_OP_iload_r17,
				FY_OP_iload_r18,
				FY_OP_iload_r19,
				FY_OP_iload_r20,
				FY_OP_iload_r21,
				FY_OP_iload_r22,
				FY_OP_iload_r23);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_istore, 4, /**/
				FY_OP_istore_r0,
				FY_OP_istore_r1,
				FY_OP_istore_r2,
				FY_OP_istore_r3);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_sipush, 8, /**/
				FY_OP_sipush_r0,
				FY_OP_sipush_r1,
				FY_OP_sipush_r2,
				FY_OP_sipush_r3,
				FY_OP_sipush_r4,
				FY_OP_sipush_r5,
				FY_OP_sipush_r6,
				FY_OP_sipush_r7);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_iinc, 4, /**/
				FY_OP_iinc_r0,
				FY_OP_iinc_r1,
				FY_OP_iinc_r2,
				FY_OP_iinc_r3);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_getfield, 8, /**/
				FY_OP_getfield_n_r0,
				FY_OP_getfield_n_r1,
				FY_OP_getfield_n_r2,
				FY_OP_getfield_n_r3,
				FY_OP_getfield_n_r4,
				FY_OP_getfield_n_r5,
				FY_OP_getfield_n_r6,
				FY_OP_getfield_n_r7);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_putfield, 4, /**/
				FY_OP_putfield_n_r0,
				FY_OP_putfield_n_r1,
				FY_OP_putfield_n_r2,
				FY_OP_putfield_n_r3);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_getstatic, 6, /**/
				FY_OP_getstatic_n_r0,
				FY_OP_getstatic_n_r1,
				FY_OP_getstatic_n_r2,
				FY_OP_getstatic_n_r3,
				FY_OP_getstatic_n_r4,
				FY_OP_getstatic_n_r5);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_putstatic, 12, /**/
				FY_OP_putstatic_n_r0,
				FY_OP_putstatic_n_r1,
				FY_OP_putstatic_n_r2,
				FY_OP_putstatic_n_r3);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_fadd, 3, /**/
				FY_OP_fadd_r0,
				FY_OP_fadd_r1,
				FY_OP_fadd_r2);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_iadd, 3, /**/
				FY_OP_iadd_r0,
				FY_OP_iadd_r1,
				FY_OP_iadd_r2);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_iastore, 3, /**/
				FY_OP_iastore_r0,
				FY_OP_iastore_r1,
				FY_OP_iastore_r2);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_iaload, 6, /**/
				FY_OP_iaload_r0,
				FY_OP_iaload_r1,
				FY_OP_iaload_r2,
				FY_OP_iaload_r3,
				FY_OP_iaload_r4,
				FY_OP_iaload_r5);
		mkReplData(context, exception, context->engines[i].replData.repl_data,
		FY_OP_nop, 3, /**/
				FY_OP_nop_r0,
				FY_OP_nop_r1,
				FY_OP_nop_r2);
		fy_hashMapIInit(context->memblocks,
				context->engines[i].replData.repl_count, 8, 12, 0, exception);
		FYEH();
		fy_hashMapIInit(context->memblocks,
				context->engines[i].replData.repl_result, 6, 12, -1, exception);
		FYEH();
#ifdef FY_INSTRUCTION_COUNT
		context->engines[i].replData.last_op = FY_OP_none;
#endif
	}

	context->engines[0].runner = fy_thread_runner_00;

#if FY_ENGINE_COUNT >= 2
	context->engines[1].runner = fy_thread_runner_01;
#endif

#if FY_ENGINE_COUNT >= 3
	context->engines[2].runner = fy_thread_runner_02;
#endif

#if FY_ENGINE_COUNT >= 4
	context->engines[3].runner = fy_thread_runner_03;
#endif

#if FY_ENGINE_COUNT >= 5
	context->engines[4].runner = fy_thread_runner_04;
#endif

#if FY_ENGINE_COUNT >= 6
	context->engines[5].runner = fy_thread_runner_05;
#endif

#if FY_ENGINE_COUNT >= 7
	context->engines[6].runner = fy_thread_runner_06;
#endif

#if FY_ENGINE_COUNT >= 8
	context->engines[7].runner = fy_thread_runner_07;
#endif
	context->engineCount = FY_ENGINE_COUNT;
}

static void initHeap(fy_context *context, fisce_exception *exception) {
	fy_memblock *block = context->memblocks;
	context->nextHandle = 1;
	block->gcContext = context;
	block->gcProvider = fy_heapGC;

	fy_hashMapInitPerm(block, context->literals, 4096, exception);
	FYEH();

	fy_arrayListInit(block, context->toFinalize, sizeof(fisce_uint), 256,
			exception);
	FYEH();

	fy_arrayListInit(block, context->protected, sizeof(fisce_uint), 128,
			exception);
	FYEH();

	fy_arrayListInit(block, context->toEnqueue, sizeof(fisce_uint), 256,
			exception);
	FYEH();
}
/************public***************/

void fy_vmContextInit(fy_context *context, fisce_exception *exception) {
	fy_debugInit(context);
	ILOG(
			context,
			"Initialing vm, context size=%d bytes including heap size=%d bytes,including object meta=%d bytes\n",
			(fisce_int) sizeof(fy_context), (fisce_int) sizeof(fy_memblock),
			MAX_OBJECTS * (fisce_int) sizeof(fy_object))
;
	fy_mmInit(context->memblocks, exception);
	FYEH();
	fy_bsRegisterBinarySaver(context);
	fy_fisInitInputStream(context, exception);
	FYEH();
	fy_portInit(context->port);

	fy_hashMapInitPerm(context->memblocks, context->stringPool, 16384,
			exception);
	FYEH();

	initHeap(context, exception);
	FYEH();

	initThreadManager(context, exception);
	FYEH();

	initEngine(context, exception);
	FYEH();

	initConstantStrings(context, exception);
	FYEH();

	initConstantPrimitives(context, exception);
	FYEH();

	initStructClassloader(context, exception);
	FYEH();

	fy_arrayListInit(context->memblocks, context->switchTargets,
			sizeof(fy_switch_lookup*), 64, exception);
	FYEH();

	fy_coreRegisterCoreHandlers(context, exception);
	FYEH();

	fy_coreRegisterMathHandlers(context, exception);
	FYEH();

	fy_risInit(context, exception);
	FYEH();
}

static fy_class* getClass(fy_context *context, fy_str *name) {
	int *pFid;
	fy_class *ret;
	pFid = fy_hashMapGet(context->memblocks, context->mapClassNameToId, name);
	if (pFid == NULL) {
		return NULL;
	}
	if (pFid == NULL || (ret = context->classes[*pFid]) == NULL) {
		return NULL;
	}
	return ret;
}
#ifdef FY_PROFILE
static void sortUsage(fy_profile_data *data, int length) {
	fisce_boolean changed = TRUE;
	fy_profile_data tmp;
	fisce_int i;
	while (changed) {
		changed = FALSE;
		for (i = 0; i < length - 1; i++) {
			if (data[i].count < data[i + 1].count) {
				changed = TRUE;
				tmp = data[i];
				data[i] = data[i + 1];
				data[i + 1] = tmp;
			}
		}
	}
}
#endif
void fy_vmContextDestroy(fy_context *context) {
#ifdef FY_PROFILE
	fisce_uint i, imax;
	const char *c, *c2;
	imax = 256;
#endif
	context->logDVar(context, "Destroying vm\n");
#ifdef FY_PROFILE
	context->logDVar(context,"Op usage top 10:\n");
	for (i = 0; i < imax; i++) {
		context->opUsage[i].op1 = i;
	}
	sortUsage(context->opUsage, 256);
	for (i = 0; i < 10; i++) {
		if (context->opUsage[i].count) {
			c = FY_OP_NAME[context->opUsage[i].op1];
			if (c) {
				context->logDVar(context,"%s(%d) - %d\n", c, context->opUsage[i].op1,
						context->opUsage[i].count);
			} else {
				context->logDVar(context,"UNKNOWN(%d) - %d\n", context->opUsage[i].op1,
						context->opUsage[i].count);
			}
		}
	}
	context->logDVar(context,"Op combian usage top 16:\n");
	imax = 65536;
	for (i = 0; i < imax; i++) {
		context->opCombine[i].op1 = i >> 8;
		context->opCombine[i].op2 = i & 0xff;
	}
	sortUsage(context->opCombine, 65536);
	for (i = 0; i < 16; i++) {
		if (context->opUsage[i].count) {
			c = FY_OP_NAME[context->opCombine[i].op1];
			c2 = FY_OP_NAME[context->opCombine[i].op2];
			context->logDVar(context,"%s(%d)+%s(%d) - %d\n", c, context->opCombine[i].op1, c2,
					context->opCombine[i].op2, context->opCombine[i].count);
		}
	}
#endif
	fy_risDestroy(context);
	fy_portDestroy(context->port);
	fy_mmDestroy(context->memblocks);
}

void fy_vmRegisterField(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	int *pFid;
	fy_memblock *block = context->memblocks;
	pFid = fy_hashMapGet(block, context->mapFieldNameToId, field->uniqueName);
	if (pFid == NULL) {
		pFid = fy_mmAllocatePerm(block, sizeof(int), exception);
		FYEH();
		field->field_id = *pFid = context->fieldsCount++;
		fy_hashMapPut(block, context->mapFieldNameToId, field->uniqueName, pFid,
				exception);
		FYEH();
	}
	context->fields[*pFid] = field;
}

fy_field *fy_vmGetField(fy_context *context, fy_str *uniqueName) {
	int *pFid = fy_hashMapGet(context->memblocks, context->mapFieldNameToId,
			uniqueName);
	if (unlikely(pFid == NULL)) {
		return NULL;
	}
	return context->fields[*pFid];
}

fy_field *fy_vmLookupFieldVirtual(fy_context *context, fy_class *clazz,
		fy_str *fieldName, fisce_exception *exception) {
	/*TODO Maybe wrong!!! need to check*/
	int *pFid, i, imax;
	fy_field *field = NULL;
	fy_str *uniqueName;
	fy_str *uniqueNameTmp;
	fy_memblock *block = context->memblocks;
	fy_class *intf;

	uniqueName = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	uniqueNameTmp = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	fy_strInit(block, uniqueName,
			clazz->className->length + fieldName->length + 1, exception);
	FYEH()NULL;
	fy_strInit(block, uniqueNameTmp,
			clazz->className->length + fieldName->length + 1, exception);
	FYEH()NULL;

	fy_strAppend(block, uniqueName, clazz->className, exception);
	FYEH()NULL;
	fy_strAppend(block, uniqueName, fieldName, exception);
	FYEH()NULL;
#ifdef FY_VERBOSE
	context->logDVar(context, "Looking up field ");
	context->logDStr(context, uniqueName);
	context->logDVarLn(context, "");
#endif

	imax = clazz->interfacesCount;
	for (i = 0; i < imax; i++) {
		intf = clazz->interfaces[i];
		fy_strClear(uniqueNameTmp);
		fy_strAppend(block, uniqueNameTmp, intf->className, exception);
		FYEH()NULL;
		fy_strAppend(block, uniqueNameTmp, fieldName, exception);
		FYEH()NULL;
#ifdef FY_VERBOSE
		context->logDVar(context, "++Trying ");
		context->logDStr(context, uniqueNameTmp);
#endif
		pFid = fy_hashMapGet(block, context->mapFieldNameToId, uniqueNameTmp);
		if (pFid != NULL) {
#ifdef FY_VERBOSE
			context->logDVarLn(context, "...Succeed!");
#endif
			fy_hashMapPut(block, context->mapFieldNameToId, uniqueName, pFid,
					exception);
			FYEH()NULL;
			field = context->fields[*pFid];
			clazz = NULL;
			break;
		} else {
#ifdef FY_VERBOSE
			context->logDVarLn(context, "...");
#endif
		}
	}

	while (clazz != NULL) {
		fy_strClear(uniqueNameTmp);
		fy_strAppend(block, uniqueNameTmp, clazz->className, exception);
		FYEH()NULL;
		fy_strAppend(block, uniqueNameTmp, fieldName, exception);
		FYEH()NULL;
#ifdef FY_VERBOSE
		context->logDVar(context, "++Trying ");
		context->logDStr(context, uniqueNameTmp);
#endif
		pFid = fy_hashMapGet(block, context->mapFieldNameToId, uniqueNameTmp);
		if (pFid != NULL) {
#ifdef FY_VERBOSE
			context->logDVarLn(context, "...Succeed!");
#endif
			fy_hashMapPut(block, context->mapFieldNameToId, uniqueName, pFid,
					exception);
			FYEH()NULL;
			field = context->fields[*pFid];
			break;
		} else {
#ifdef FY_VERBOSE
			context->logDVarLn(context, "...");
#endif
		}
		clazz = clazz->s.super;
	}

	fy_strDestroy(block, uniqueNameTmp);
	fy_mmFree(block, uniqueNameTmp);
	fy_strDestroy(block, uniqueName);
	fy_mmFree(block, uniqueName);
	return field;
}

void fy_vmRegisterMethod(fy_context *context, fy_method *method,
		fisce_exception *exception) {
	int *pMid;
	fy_memblock *block = context->memblocks;
	pMid = fy_hashMapGet(context->memblocks, context->mapMethodNameToId,
			method->uniqueName);
	if (pMid == NULL) {
		pMid = fy_mmAllocatePerm(block, sizeof(int), exception);
		FYEH();
		method->method_id = *pMid = context->methodsCount++;
		fy_hashMapPut(block, context->mapMethodNameToId, method->uniqueName,
				pMid, exception);
		FYEH();
	}
	context->methods[*pMid] = method;
}

fy_method *fy_vmGetMethod(fy_context *context, fy_str *uniqueName) {
	int *pMid = fy_hashMapGet(context->memblocks, context->mapMethodNameToId,
			uniqueName);
	if (unlikely(pMid == NULL)) {
		return NULL;
	}
	return context->methods[*pMid];
}

fy_method *fy_vmLookupMethodVirtualByMethod(fy_context *context,
		fy_class *clazz, fy_method *method, fisce_exception *exception) {
	fy_method *actureMethod;
	fisce_uint actureMethodId;
	actureMethodId = fy_hashMapIGet(context->memblocks, clazz->virtualTable,
			method->method_id);
	if (unlikely(actureMethodId == -1)) {
		actureMethod = fy_vmLookupMethodVirtual(context, clazz,
				method->fullName, exception);
		FYEH()NULL;

		if (actureMethod == NULL) {
			fy_fault(exception, FY_EXCEPTION_ABSTRACT, "%s", method->utf8Name);
			return NULL;
		}
		if (actureMethod->access_flags & FY_ACC_STATIC) {
			fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "%s", method->utf8Name);
			return NULL;
		}
		if ((actureMethod->access_flags & FY_ACC_ABSTRACT)) {
			fy_fault(exception, FY_EXCEPTION_ABSTRACT, "%s", method->utf8Name);
			return NULL;
		}
		fy_hashMapIPut(context->memblocks, clazz->virtualTable,
				method->method_id, actureMethod->method_id, exception);
		FYEH()NULL;
	} else {
		actureMethod = context->methods[actureMethodId];
	}
	return actureMethod;
}

fy_method *fy_vmLookupMethodFromInterfaces(fy_context *context, fy_class *clazz,
		fy_str *methodName, fisce_exception *exception) {
	int *pMid;
	fy_class *intf;
	fisce_int i, imax;
	fy_method *method = NULL;
	fy_memblock *block = context->memblocks;
	fy_str *uniqueNameTmp;
	fy_str *uniqueName;

	uniqueName = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	uniqueNameTmp = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	fy_strInit(block, uniqueName,
			clazz->className->length + methodName->length + 1, exception);
	FYEH()NULL;
	fy_strInit(block, uniqueNameTmp,
			clazz->className->length + methodName->length + 1, exception);
	FYEH()NULL;

	fy_strAppend(block, uniqueName, clazz->className, exception);
	FYEH()NULL;
	fy_strAppend(block, uniqueName, methodName, exception);
	FYEH()NULL;
	while (clazz != NULL) {
		imax = clazz->interfacesCount;
		for (i = 0; i < imax; i++) {
			intf = clazz->interfaces[i];
			fy_strClear(uniqueNameTmp);
			fy_strAppend(block, uniqueNameTmp, intf->className, exception);
			FYEH()NULL;
			fy_strAppend(block, uniqueNameTmp, methodName, exception);
			FYEH()NULL;
			pMid = fy_hashMapGet(block, context->mapMethodNameToId,
					uniqueNameTmp);
			if (pMid != NULL) {
				fy_hashMapPut(block, context->mapMethodNameToId, uniqueName,
						pMid, exception);
				FYEH()NULL;
				method = context->methods[*pMid];
				break;
			}
		}
		if (method != NULL) {
			break;
		}
		clazz = clazz->s.super;
	}
	fy_strDestroy(block, uniqueNameTmp);
	fy_mmFree(block, uniqueNameTmp);
	fy_strDestroy(block, uniqueName);
	fy_mmFree(block, uniqueName);
	return method;
}

fy_method *fy_vmLookupMethodVirtual(fy_context *context, fy_class *clazz,
		fy_str *methodName, fisce_exception *exception) {
	int *pMid;
	fy_method *method = NULL;
	fy_memblock *block = context->memblocks;
	fy_str *uniqueName;
	fy_str *uniqueNameTmp;

	uniqueName = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	uniqueNameTmp = fy_mmAllocate(block, sizeof(fy_str), exception);
	FYEH()NULL;
	fy_strInit(block, uniqueName,
			clazz->className->length + methodName->length + 1, exception);
	FYEH()NULL;
	fy_strInit(block, uniqueNameTmp,
			clazz->className->length + methodName->length + 1, exception);
	FYEH()NULL;

	fy_strAppend(block, uniqueName, clazz->className, exception);
	FYEH()NULL;
	fy_strAppend(block, uniqueName, methodName, exception);
	FYEH()NULL;
	while (clazz != NULL) {
		fy_strClear(uniqueNameTmp);
		fy_strAppend(block, uniqueNameTmp, clazz->className, exception);
		FYEH()NULL;
		fy_strAppend(block, uniqueNameTmp, methodName, exception);
		FYEH()NULL;
		pMid = fy_hashMapGet(block, context->mapMethodNameToId, uniqueNameTmp);
		if (pMid != NULL) {
			fy_hashMapPut(block, context->mapMethodNameToId, uniqueName, pMid,
					exception);
			FYEH()NULL;
			method = context->methods[*pMid];
			break;
		}
		clazz = clazz->s.super;
	}
	fy_strDestroy(block, uniqueNameTmp);
	fy_mmFree(block, uniqueNameTmp);
	fy_strDestroy(block, uniqueName);
	fy_mmFree(block, uniqueName);
	return method;
}

void fy_vmRegisterClass(fy_context *context, fy_class *clazz,
		fisce_exception *exception) {
	int *pCid;
	fy_memblock *block = context->memblocks;
	pCid = fy_hashMapGet(block, context->mapClassNameToId, clazz->className);
	if (pCid == NULL) {
		pCid = fy_mmAllocatePerm(block, sizeof(int), exception);
		FYEH();
		*pCid = (context->classesCount++) + 1;
		if (*pCid >= MAX_CLASSES) {
			fy_fault(exception, NULL, "Too many classes!");
			return;
		}
#if 0
		if(*pCid==76) {
			int j;
			j++;
			j++;
		}
#endif
		fy_hashMapPut(block, context->mapClassNameToId, clazz->className, pCid,
				exception);
		FYEH();
	}
	context->classes[*pCid] = clazz;
	clazz->classId = *pCid;
}

fy_class *fy_vmLoadClass(fy_context *context, fy_str *name,
		fisce_exception *exception) {
	fy_class *clazz;
	clazz = getClass(context, name);
	if (unlikely(clazz == NULL)) {
		clazz = fy_clLoadclass(context, name, exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
		fy_vmRegisterClass(context, clazz, exception);
		FYEH()NULL;
		fy_clPhase2(context, clazz, exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
		fy_vmLookupClass(context, context->sClassClass, exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
	}
	return clazz;
}

/*Likes com.cirnoworks.fisce.vm.VMContext.getClass(String name)*/
fy_class *fy_vmLookupClass(fy_context *context, fy_str *name,
		fisce_exception *exception) {
	return fy_vmLoadClass(context, name, exception);
}

fy_class *fy_vmGetClassFromClassObject(fy_context *context, fisce_uint handle,
		fisce_exception *exception) {
	fy_class *classClass;
	fy_class *inputClass;
	fisce_int classId;
	inputClass = fy_heapGetClassOfObject(context, handle, exception);
	FYEH()NULL;
	classClass = fy_vmLookupClass(context, context->sClassClass, exception);
	if (unlikely(exception->exceptionType != exception_none)) {
		return NULL;
	}
	if (inputClass != classClass) {
		exception->exceptionType = exception_normal;
		strcpy_s(exception->exceptionName, sizeof(exception->exceptionName),
				FY_EXCEPTION_VM);
		strcpy_s(exception->exceptionDesc, sizeof(exception->exceptionDesc),
				"Get class ID for non-class object");
		return NULL;
	}
	classId = context->objects[handle].object_data->m.classId;
	return context->classes[classId];
}

fy_class *fy_vmLookupClassFromConstant(fy_context *context,
		ConstantClass *classInfo, fisce_exception *exception) {
	if (unlikely(classInfo->derefed == 0)) {
		classInfo->ci.clazz = fy_vmLookupClass(context, classInfo->ci.className,
				exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
		classInfo->derefed = 1;
	}
	return classInfo->ci.clazz;
}

fy_field *fy_vmLookupFieldFromConstant(fy_context *context,
		ConstantFieldRef *fieldInfo, fisce_exception *exception) {
	fy_field *field;

	if (unlikely(fieldInfo->derefed == 0)) {
		fieldInfo->c.clazz = fy_vmLookupClassFromConstant(context,
				fieldInfo->c.constantClass, exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
		field = fy_vmLookupFieldVirtual(context, fieldInfo->c.clazz,
				fieldInfo->nt.nameType, exception);
		FYEH()NULL;
		if (field == NULL) {
			fy_fault(exception, NULL, "Field not found");
			return NULL;
		}
		fieldInfo->derefed = 1;
		fieldInfo->field = field;
	} else {
		field = fieldInfo->field;
	}
	return field;
}

fy_method *fy_vmLookupMethodFromConstant(fy_context *context,
		ConstantMethodRef *methodInfo, fisce_exception *exception) {
	fy_method *method;
	if (unlikely(methodInfo->derefed == 0)) {
		methodInfo->clazz = fy_vmLookupClassFromConstant(context,
				methodInfo->constantClass, exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
		method = fy_vmLookupMethodVirtual(context, methodInfo->clazz,
				methodInfo->nameType, exception);
		FYEH()NULL;
		if (method == NULL
				&& (methodInfo->clazz->accessFlags & FY_ACC_ABSTRACT)) {
			method = fy_vmLookupMethodFromInterfaces(context, methodInfo->clazz,
					methodInfo->nameType, exception);
			FYEH()NULL;
		}
		if (method == NULL) {
			context->logEVar(context, "Method not found:");
			context->logEStr(context, methodInfo->clazz->className);
			context->logEStr(context, methodInfo->nameType);
			context->logEVarLn(context, "");
			fy_fault(exception, NULL, "Method not found");
			return NULL;
		}
		methodInfo->derefed = 1;
		methodInfo->method = method;
	} else {
		method = methodInfo->method;
	}
	return method;
}

void fy_vmRegisterNativeHandler(fy_context *context, const char *name,
		void *data, fy_nhFunction handler, fisce_exception *exception) {
	fy_nh* nh;
	fy_str *str;
	fy_memblock *block = context->memblocks;
	str = fy_vmCreateStringByPoolV(context, exception, "a", name);/*fy_strCreatePermFromUTF8(block, name, 0, exception);*/
	FYEH();
	if (unlikely(fy_hashMapGet(block, context->mapMUNameToNH, str) != NULL)) {
		fy_fault(exception, NULL, "Native handler conflict %s", name);
	}
	nh = fy_mmAllocatePerm(block, sizeof(fy_nh), exception);
	FYEH();
	nh->data = data;
	nh->handler = handler;
	fy_hashMapPut(block, context->mapMUNameToNH, str, nh, exception);
	FYEH();
}

void fy_vmUnRegisterNativeHandler(fy_context *context, const char *name,
		fisce_exception *exception) {
	fy_nh* nh;
	fy_str str[1];
	fy_memblock *block = context->memblocks;
	str->content = NULL;
	fy_strInitWithUTF8(block, str, name, exception);
	FYEH();
	if ((nh = fy_hashMapGet(block, context->mapMUNameToNH, str)) != NULL) {
		fy_hashMapPut(block, context->mapMUNameToNH, str, NULL, exception);
		/*fy_mmFree(block, nh);*/
	}
	fy_strDestroy(block, str);
}

fy_class *fy_vmLookupClassFromExceptionHandler(fy_context *context,
		fy_exceptionHandler *exceptionHandler, fisce_exception *exception) {
	fy_class *clazz;
	if (unlikely(exceptionHandler->catchTypeDerefed == 0)) {
		clazz = fy_vmLookupClassFromConstant(context,
				exceptionHandler->ci.constantClass, exception);
		if (exception->exceptionType != exception_none) {
			return NULL;
		}
	} else {
		clazz = exceptionHandler->ci.clazz;
	}
	return clazz;
}

fisce_boolean fy_vmBootup(fy_context *context, const char* bootStrapClass,
		fisce_exception *exception) {
	fy_str name;
	fy_class *clazz;
	/*
	 context->TOP_CLASS = fy_vmLookupClass(context, context->sTopClass,
	 exception);
	 FYEH();

	 context->TOP_THROWABLE = fy_vmLookupClass(context, context->sClassThrowable,
	 exception);
	 FYEH();
	 */
	name.content = NULL;
	if (unlikely(exception == NULL)) {
		return FALSE;
	}
	fy_strInitWithUTF8(context->memblocks, &name, bootStrapClass, exception);
	FYEH()FALSE;
	clazz = fy_vmLookupClass(context, &name, exception);
	fy_strDestroy(context->memblocks, &name);
	FYEH()FALSE;
	fy_tmBootFromMain(context, clazz, exception);
	FYEH()FALSE;
	return TRUE;
}

static void fillValues(fy_str *key, void *value, void *addition) {
	**(int**) addition = *(int*) value;
	(*(int**) addition)++;
}

void fy_vmSave(fy_context *context, fisce_exception *exception) {
	fisce_uint i, imax, count, j, jmax, tmp;
	fy_class *clazz;
	fy_method *method;
	fy_field *field;
	fy_object *object;
	fisce_uint *handles;
	fisce_uint *temp;
	fy_thread *thread;
	fy_frame *frame;
	void *saver;
	/*Header*/
	saver = context->saveBegin(context, exception);
	FYEH();
	/*Class*/
	context->savePrepareClass(context, saver, imax = context->classesCount,
			exception);
	FYEH();
	imax = context->classesCount;
	for (i = 1; i <= imax; i++) {
		clazz = context->classes[i];
		tmp = fy_hashMapIGet(context->memblocks, context->classObjIds,
				clazz->classId);
		FYEH();
		context->saveClass(context, saver, i, tmp, clazz->clinitThreadId,
				clazz->className, clazz->staticSize, clazz->staticArea,
				exception);
		FYEH();
	}/**/
	context->saveEndClass(context, saver, exception);
	FYEH();
	/*Method*/
	context->savePrepareMethod(context, saver, imax = context->methodsCount,
			exception);
	FYEH();
	for (i = 0; i < imax; i++) {
		method = context->methods[i];
		context->saveMethod(context, saver, i, 0/*TODO*/, method->uniqueName,
				exception);
		FYEH();
	}/**/
	context->saveEndMethod(context, saver, exception);
	FYEH();
	/*Field*/
	context->savePrepareField(context, saver, imax = context->fieldsCount,
			exception);
	FYEH();
	for (i = 0; i < imax; i++) {
		field = context->fields[i];
		context->saveField(context, saver, i, 0/*TODO*/, field->uniqueName,
				exception);
		FYEH();
	}/**/
	context->saveEndField(context, saver, exception);
	FYEH();
	/*Objects*/
	count = 0;
	for (i = 1; i < MAX_OBJECTS; i++) {
		if (fy_heapGetObject(context,i)->object_data != NULL) {
			count++;
		}
	}
	context->savePrepareObjects(context, saver, context->nextHandle, count,
			exception);
	FYEH();
	for (i = 1; i < MAX_OBJECTS; i++) {
		if ((object = fy_heapGetObject(context, i))->object_data != NULL) {
			context->saveObject(context, saver, i,
					object->object_data->clazz->classId,
					object->object_data->position, object->object_data->gen,
					object->object_data->finalizeStatus,
					object->object_data->monitorOwnerId,
					object->object_data->monitorOwnerTimes,
					object->object_data->m.multiUsageData,
					object->object_data->clazz->type == array_class ?
							fy_heapGetArraySizeFromLength(
									object->object_data->clazz,
									object->object_data->m.arrayLength) :
							object->object_data->clazz->sizeAbs,
					(void*) object->object_data->data, exception);
			count++;
		}
	}/**/
	context->saveEndObject(context, saver, exception);
	FYEH();
	/*Literals*/
	handles = /*TEMP*/fy_allocate(context->literals->size * sizeof(fisce_uint),
			exception);
	FYEH();
	temp = handles;
	fy_hashMapEachValue(context->memblocks, context->literals, fillValues,
			&temp);
	context->saveLiterals(context, saver, context->literals->size, handles,
			exception);
	fy_free(handles);
	FYEH();
	context->saveFinalizes(context, saver, context->toFinalize->length,
			context->toFinalize->data, exception);
	FYEH();
	context->savePrepareThreads(context, saver,
			imax = context->runningThreads->length, exception);
	FYEH();
	for (i = 0; i < imax; i++) {
		fy_arrayListGet(context->memblocks, context->runningThreads, i,
				&thread);
		jmax = thread->frameCount;
		/*last frame*/
		frame = FY_GET_FRAME(thread, jmax - 1);
		context->saveThread(context, saver, thread->threadId, thread->handle,
				thread->priority, thread->daemon, thread->destroyPending,
				thread->interrupted, thread->nextWakeTime,
				thread->pendingLockCount, thread->waitForLockId,
				thread->waitForNotifyId,
				FY_PDIFF(fisce_stack_item, frame->baseSpp, thread->stack)
						+ frame->method->max_locals + frame->method->max_stack,
				thread->stack, exception);
		FYEH();
		context->savePrepareFrame(context, saver, jmax, exception);
		FYEH();
		for (j = 0; j < jmax; j++) {
			frame = FY_GET_FRAME(thread, j);
			context->saveFrame(context, saver, frame->method->method_id,
					FY_PDIFF(fisce_stack_item, frame->baseSpp, thread->stack),
					frame->lpc, frame->pcofs, exception);
			FYEH();
		}
		context->saveEndFrame(context, saver, exception);
	}
	context->saveEndThread(context, saver, exception);
	context->saveEnd(context, saver, exception);
}

void fy_vmBootFromData(fy_context *context, fisce_exception *exception) {

	context->loadData(context, exception);
	/*
	 context->TOP_CLASS = fy_vmLookupClass(context, context->sTopClass,
	 exception);
	 FYEH();

	 context->TOP_THROWABLE = fy_vmLookupClass(context, context->sClassThrowable,
	 exception);
	 FYEH();
	 */
	context->state = FY_TM_STATE_RUN_PENDING;
	context->nextGCTime = fy_portTimeMillSec(context->port) + FY_GC_IDV;
	context->nextForceGCTime = context->nextGCTime + FY_GC_FORCE_IDV;
}

fisce_int fy_vmGetClassObjHandle(fy_context *context, fy_class *clazz,
		fisce_exception *exception) {
	fy_class *clcl = fy_vmLookupClass(context, context->sClassClass, exception);
	fisce_int handle = fy_hashMapIGet(context->memblocks, context->classObjIds,
			clazz->classId);
	FYEH()-1;
	if (unlikely(handle == -1)) {
		fy_heapBeginProtect(context);
		handle = fy_heapAllocate(context, clcl, exception);
		fy_heapGetObject(context,handle)->object_data->m.classId = clazz->classId;
		fy_hashMapIPut(context->memblocks, context->classObjIds, clazz->classId,
				handle, exception);
		/*FYEH is unnessessery*/
	}
	return handle;
}

fisce_int fy_vmGetMethodObjHandle(fy_context *context, fy_method *method,
		fisce_exception *exception) {
	fy_class *mecl = fy_vmLookupClass(context, context->sClassMethod,
			exception);
	fy_class *cocl = fy_vmLookupClass(context, context->sClassConstructor,
			exception);
	fisce_int handle = fy_hashMapIGet(context->memblocks, context->methodObjIds,
			method->method_id);
	FYEH()-1;
	if (unlikely(handle == -1)) {
		fy_heapBeginProtect(context);
		if (method->access_flags & FY_ACC_CONSTRUCTOR) {
			handle = fy_heapAllocate(context, cocl, exception);
		} else {
			handle = fy_heapAllocate(context, mecl, exception);
		}
		FYEH()-1;
		fy_heapGetObject(context,handle)->object_data->m.methodId =
				method->method_id;
		fy_hashMapIPut(context->memblocks, context->methodObjIds,
				method->method_id, handle, exception);
	}
	return handle;
}

fisce_int fy_vmGetFieldObjHandle(fy_context *context, fy_field *field,
		fisce_exception *exception) {
	fy_class *ficl = fy_vmLookupClass(context, context->sClassField, exception);
	fisce_int handle = fy_hashMapIGet(context->memblocks, context->fieldObjIds,
			field->field_id);
	FYEH()-1;
	if (unlikely(handle == -1)) {
		fy_heapBeginProtect(context);
		handle = fy_heapAllocate(context, ficl, exception);
		fy_heapGetObject(context,handle)->object_data->m.fieldId =
				field->field_id;
		fy_hashMapIPut(context->memblocks, context->fieldObjIds,
				field->field_id, handle, exception);
	}
	return handle;
}

fy_str *fy_vmCreateStringByPoolV(fy_context *context, fisce_exception *exception,
		const char *pattern, ...) {
	va_list arg_ptr;
	fy_strVA va[1];
	va_start(arg_ptr, pattern);
	fy_strParseVA(va, pattern, arg_ptr);
	va_end(arg_ptr);
	return fy_vmCreateStringByPoolVA(context, va, exception);
}

fy_str *fy_vmCreateStringByPool(fy_context *context, fy_str *tmp,
		fisce_exception *exception) {
	fy_str *ret;
	ret = fy_hashMapGet(context->memblocks, context->stringPool, tmp);
#ifdef FY_DEBUG
	context->stringPoolTimes++;
#endif
	if (unlikely(ret == NULL)) {
		ret = fy_strCreatePermPersistClone(context->memblocks, tmp, exception);
		FYEH()NULL;
		fy_hashMapPut(context->memblocks, context->stringPool, ret, ret,
				exception);
		FYEH()NULL;
#if 0
		context->logDVar(context, "Added string to string pool %d/%d: ",
				context->stringPool->size, context->stringPoolTimes);
		context->logDStr(context, ret);
		context->logDVarLn(context, "");
	} else {
		context->logDVar(context, "Reusing string from string pool %d/%d: ",
				context->stringPool->size, context->stringPoolTimes);
		context->logDStr(context, ret);
		context->logDVarLn(context, "");
#endif
	}
	return ret;
}

fy_str *fy_vmCreateStringByPoolVA(fy_context *context, fy_strVA *va,
		fisce_exception *exception) {
	fy_str *ret;
	ret = fy_hashMapGetVA(context->memblocks, context->stringPool, va);
#ifdef FY_DEBUG
	context->stringPoolTimes++;
#endif
	if (unlikely(ret == NULL)) {
		ret = fy_strCreatePermPersistVA(context->memblocks, va, exception);
		FYEH()NULL;
		fy_hashMapPut(context->memblocks, context->stringPool, ret, ret,
				exception);
		FYEH()NULL;
#if 0
		context->logDVar(context, "Added string to string pool %d/%d: ",
				context->stringPool->size, context->stringPoolTimes);
		context->logDStr(context, ret);
		context->logDVarLn(context, "");
	} else {
		context->logDVar(context, "Reusing string from string pool %d/%d: ",
				context->stringPool->size, context->stringPoolTimes);
		context->logDStr(context, ret);
		context->logDVarLn(context, "");
#endif
	}
	return ret;
}
