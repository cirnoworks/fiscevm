#ifdef FY_ENGINE_HEADER
#define Cell fy_stack_item

fy_engine_result FY_ENGINE_NAME(
    fy_context *context,
    fy_thread *thread,
    fy_frame *frame,
    fy_int oops,
    fy_exception *exception) {
#ifndef FY_LATE_DECLARATION
#ifdef USE_CFA
  register fy_e2_label cfa;
#endif
  register fy_instruction *ipp;
  register fy_int ops = oops;
#ifdef FY_USE_TOS
  register fy_stack_item sppTOS;
#endif
  register fy_stack_item *spp;

  fy_instruction *instructions;
  fy_stack_item *stack, *sbase;

  fy_memblock *block;

  fy_method *method = NULL;
#endif

#ifndef FY_LATE_DECLARATION
  fy_uint i1, i2, i3, i4, i5, i6, ir1, ir2, ir3, ir4, ir5, ir6;
#endif

  fy_engine_result ret;
  static fy_e2_label_holder labels[] = {
#undef FY_ENGINE_HEADER
#include "fisce-labels.i"
#define FY_ENGINE_HEADER
      {0, -1}
  };
#ifdef MORE_VARS
  MORE_VARS
#endif

#ifdef VM_DEBUG
  FILE *vm_out = stdout;
  const fy_uint vm_debug = 1;
#endif



  if(thread == NULL){
    ret.labels = labels;
  }else{
#ifdef FY_LATE_DECLARATION


#ifdef USE_CFA
  register
  fy_e2_label cfa;
#endif
  register
  fy_instruction *ipp;
  register
  fy_int ops = oops;
#ifdef FY_USE_TOS
  register fy_stack_item sppTOS;
#endif
  register
  fy_stack_item *spp;

  fy_instruction *instructions;
  fy_stack_item *stack, *sbase;

  fy_memblock *block;

  fy_method *method = NULL;
#endif

  stack = thread->stack;
  block = context->memblocks;

  method = frame->method;
  instructions = method->instructions;
  sbase = frame->baseSpp;

#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, "\nInvoking: ");
    fy_strFPrint(vm_out, method->uniqueName);
    fprintf(vm_out, " pc = %"FY_PRINT32"d + %"FY_PRINT32"d\n sb = %"FY_PRINT32"d", frame->lpc, frame->pcofs, FY_PDIFF(fy_stack_item, sbase, stack));
    if(frame->lpc + frame->pcofs == FY_IP_begin){
#ifndef FY_LATE_DECLARATION
      fy_uint i1, i2;
      fprintf(vm_out, "[")
      i2 = method->max_locals + method->max_stack;
      for(i1 = 0; i1 < i2; i1++){
        printarg_i(sbase + i1);
        if(i1 < i2 - 1) fputs(", ", vm_out);
      }
      fputs("]\n", vm_out);
#endif
    }
  }
#endif

  if ((method->access_flags & FY_ACC_CLINIT) && frame->lpc + frame->pcofs == FY_IP_begin) {
#ifdef VM_DEBUG
    if(vm_debug){
      fprintf(vm_out, "Checking clinit for: ");
      fy_strFPrint(vm_out, method->uniqueName);
      fprintf(vm_out, "\n");
    }
#endif
    //!CLINIT
    ipp = method->instructions;
    spp = frame->baseSpp + method->max_locals;
    FY_ENGINE_CLINIT(method->owner, 0)
  }

  ENGINE_ENTER;
#endif
LABEL(dropout) /* dropout ( -- ) */
/*  */
NAME("dropout")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  #ifdef VM_DEBUG
  if (vm_debug) {
  fputs(" ### ", vm_out); fputc('\n', vm_out);
  }
  #endif
  goto label_fallout_invoke;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(dropout)
NEXT_P2;
}

LABEL(nop) /* nop ( -- ) */
/*  */
NAME("nop")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

;

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(nop)
NEXT_P2;
}

LABEL(pop) /* pop ( i1 -- ) */
/*  */
NAME("pop")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

;

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(pop)
NEXT_P2;
}

LABEL(pop2) /* pop2 ( i1 i2 -- ) */
/*  */
NAME("pop2")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

;

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(pop2)
NEXT_P2;
}

LABEL(iload) /* iload ( -- ir) */
/*  */
NAME("iload")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #iload_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadGetLocalInt(CURR_INST.params.int_params.param1, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iload)
NEXT_P2;
}

LABEL(fload) /* fload ( -- ir) */
/*  */
NAME("fload")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #fload_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadGetLocalInt(CURR_INST.params.int_params.param1, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fload)
NEXT_P2;
}

LABEL(aload) /* aload ( -- ir) */
/*  */
NAME("aload")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #aload_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadGetLocalHandle(CURR_INST.params.int_params.param1, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aload)
NEXT_P2;
}

LABEL(iload_0) /* iload_0 ( -- ir) */
/*  */
NAME("iload_0")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(0, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iload_0)
NEXT_P2;
}

LABEL(fload_0) /* fload_0 ( -- ir) */
/*  */
NAME("fload_0")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(0, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fload_0)
NEXT_P2;
}

LABEL(aload_0) /* aload_0 ( -- ir) */
/*  */
NAME("aload_0")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalHandle(0, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aload_0)
NEXT_P2;
}

LABEL(iload_1) /* iload_1 ( -- ir) */
/*  */
NAME("iload_1")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(1, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iload_1)
NEXT_P2;
}

LABEL(fload_1) /* fload_1 ( -- ir) */
/*  */
NAME("fload_1")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(1, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fload_1)
NEXT_P2;
}

LABEL(aload_1) /* aload_1 ( -- ir) */
/*  */
NAME("aload_1")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalHandle(1, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aload_1)
NEXT_P2;
}

LABEL(iload_2) /* iload_2 ( -- ir) */
/*  */
NAME("iload_2")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(2, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iload_2)
NEXT_P2;
}

LABEL(fload_2) /* fload_2 ( -- ir) */
/*  */
NAME("fload_2")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(2, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fload_2)
NEXT_P2;
}

LABEL(aload_2) /* aload_2 ( -- ir) */
/*  */
NAME("aload_2")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalHandle(2, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aload_2)
NEXT_P2;
}

LABEL(iload_3) /* iload_3 ( -- ir) */
/*  */
NAME("iload_3")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(3, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iload_3)
NEXT_P2;
}

LABEL(fload_3) /* fload_3 ( -- ir) */
/*  */
NAME("fload_3")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalInt(3, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fload_3)
NEXT_P2;
}

LABEL(aload_3) /* aload_3 ( -- ir) */
/*  */
NAME("aload_3")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_threadGetLocalHandle(3, ir);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aload_3)
NEXT_P2;
}

LABEL(istore) /* istore ( i1 -- ) */
/*  */
NAME("istore")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #istore_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadPutLocalInt(CURR_INST.params.int_params.param1, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(istore)
NEXT_P2;
}

LABEL(fstore) /* fstore ( i1 -- ) */
/*  */
NAME("fstore")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #fstore_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadPutLocalInt(CURR_INST.params.int_params.param1, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(fstore)
NEXT_P2;
}

LABEL(astore) /* astore ( i1 -- ) */
/*  */
NAME("astore")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #astore_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadPutLocalHandle(CURR_INST.params.int_params.param1, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(astore)
NEXT_P2;
}

LABEL(istore_0) /* istore_0 ( i1 -- ) */
/*  */
NAME("istore_0")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(0, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(istore_0)
NEXT_P2;
}

LABEL(fstore_0) /* fstore_0 ( i1 -- ) */
/*  */
NAME("fstore_0")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(0, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(fstore_0)
NEXT_P2;
}

LABEL(astore_0) /* astore_0 ( i1 -- ) */
/*  */
NAME("astore_0")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalHandle(0, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(astore_0)
NEXT_P2;
}

LABEL(istore_1) /* istore_1 ( i1 -- ) */
/*  */
NAME("istore_1")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(1, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(istore_1)
NEXT_P2;
}

LABEL(fstore_1) /* fstore_1 ( i1 -- ) */
/*  */
NAME("fstore_1")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(1, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(fstore_1)
NEXT_P2;
}

LABEL(astore_1) /* astore_1 ( i1 -- ) */
/*  */
NAME("astore_1")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalHandle(1, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(astore_1)
NEXT_P2;
}

LABEL(istore_2) /* istore_2 ( i1 -- ) */
/*  */
NAME("istore_2")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(2, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(istore_2)
NEXT_P2;
}

LABEL(fstore_2) /* fstore_2 ( i1 -- ) */
/*  */
NAME("fstore_2")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(2, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(fstore_2)
NEXT_P2;
}

LABEL(astore_2) /* astore_2 ( i1 -- ) */
/*  */
NAME("astore_2")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalHandle(2, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(astore_2)
NEXT_P2;
}

LABEL(istore_3) /* istore_3 ( i1 -- ) */
/*  */
NAME("istore_3")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(3, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(istore_3)
NEXT_P2;
}

LABEL(fstore_3) /* fstore_3 ( i1 -- ) */
/*  */
NAME("fstore_3")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalInt(3, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(fstore_3)
NEXT_P2;
}

LABEL(astore_3) /* astore_3 ( i1 -- ) */
/*  */
NAME("astore_3")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadPutLocalHandle(3, i1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(astore_3)
NEXT_P2;
}

LABEL(dload) /* dload ( -- lr) */
/*  */
NAME("dload")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #dload_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadGetLocalLong(CURR_INST.params.int_params.param1, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(dload)
NEXT_P2;
}

LABEL(lload) /* lload ( -- lr) */
/*  */
NAME("lload")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #lload_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadGetLocalLong(CURR_INST.params.int_params.param1, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lload)
NEXT_P2;
}

LABEL(dload_0) /* dload_0 ( -- lr) */
/*  */
NAME("dload_0")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(0, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(dload_0)
NEXT_P2;
}

LABEL(lload_0) /* lload_0 ( -- lr) */
/*  */
NAME("lload_0")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(0, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lload_0)
NEXT_P2;
}

LABEL(dload_1) /* dload_1 ( -- lr) */
/*  */
NAME("dload_1")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(1, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(dload_1)
NEXT_P2;
}

LABEL(lload_1) /* lload_1 ( -- lr) */
/*  */
NAME("lload_1")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(1, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lload_1)
NEXT_P2;
}

LABEL(dload_2) /* dload_2 ( -- lr) */
/*  */
NAME("dload_2")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(2, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(dload_2)
NEXT_P2;
}

LABEL(lload_2) /* lload_2 ( -- lr) */
/*  */
NAME("lload_2")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(2, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lload_2)
NEXT_P2;
}

LABEL(dload_3) /* dload_3 ( -- lr) */
/*  */
NAME("dload_3")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(3, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(dload_3)
NEXT_P2;
}

LABEL(lload_3) /* lload_3 ( -- lr) */
/*  */
NAME("lload_3")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  fy_threadGetLocalLong(3, lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lload_3)
NEXT_P2;
}

LABEL(dstore) /* dstore ( l1 -- ) */
/*  */
NAME("dstore")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #dstore_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadPutLocalLong(CURR_INST.params.int_params.param1, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dstore)
NEXT_P2;
}

LABEL(lstore) /* lstore ( l1 -- ) */
/*  */
NAME("lstore")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #lstore_%"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  fy_threadPutLocalLong(CURR_INST.params.int_params.param1, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lstore)
NEXT_P2;
}

LABEL(dstore_0) /* dstore_0 ( l1 -- ) */
/*  */
NAME("dstore_0")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(0, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dstore_0)
NEXT_P2;
}

LABEL(lstore_0) /* lstore_0 ( l1 -- ) */
/*  */
NAME("lstore_0")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(0, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lstore_0)
NEXT_P2;
}

LABEL(dstore_1) /* dstore_1 ( l1 -- ) */
/*  */
NAME("dstore_1")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(1, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dstore_1)
NEXT_P2;
}

LABEL(lstore_1) /* lstore_1 ( l1 -- ) */
/*  */
NAME("lstore_1")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(1, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lstore_1)
NEXT_P2;
}

LABEL(dstore_2) /* dstore_2 ( l1 -- ) */
/*  */
NAME("dstore_2")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(2, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dstore_2)
NEXT_P2;
}

LABEL(lstore_2) /* lstore_2 ( l1 -- ) */
/*  */
NAME("lstore_2")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(2, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lstore_2)
NEXT_P2;
}

LABEL(dstore_3) /* dstore_3 ( l1 -- ) */
/*  */
NAME("dstore_3")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(3, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dstore_3)
NEXT_P2;
}

LABEL(lstore_3) /* lstore_3 ( l1 -- ) */
/*  */
NAME("lstore_3")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
  fy_threadPutLocalLong(3, l1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lstore_3)
NEXT_P2;
}

LABEL(iinc) /* iinc ( -- ) */
/*  */
NAME("iinc")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  sbase[CURR_INST.params.int_params.param1].uvalue += CURR_INST.params.int_params.param2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(iinc)
NEXT_P2;
}

LABEL(dup) /* dup ( i1 -- ir1 ir2) */
/*  */
NAME("dup")
{
DEF_CA
fy_uint i1;
fy_uint ir1;
fy_uint ir2;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
  ir1 = ir2 = i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-2]);
vm_i2fy_stack_item(ir2,sppTOS);
LABEL2(dup)
NEXT_P2;
}

LABEL(dup_x1) /* dup_x1 ( i1 i2 -- ir1 ir2 ir3) */
/*  */
NAME("dup_x1")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir1;
fy_uint ir2;
fy_uint ir3;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += 1;
{

{
  ir1 = i2;
  ir2 = i1;
  ir3 = i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputs(" ir3=", vm_out); printarg_i(ir3);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-3]);
vm_i2fy_stack_item(ir2,spp[-2]);
vm_i2fy_stack_item(ir3,sppTOS);
LABEL2(dup_x1)
NEXT_P2;
}

LABEL(dup_x2) /* dup_x2 ( i1 i2 i3 -- ir1 ir2 ir3 ir4) */
/*  */
NAME("dup_x2")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
fy_uint ir1;
fy_uint ir2;
fy_uint ir3;
fy_uint ir4;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += 1;
{

{
  ir1 = i3;
  ir2 = i1;
  ir3 = i2;
  ir4 = i3;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputs(" ir3=", vm_out); printarg_i(ir3);
fputs(" ir4=", vm_out); printarg_i(ir4);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-4]);
vm_i2fy_stack_item(ir2,spp[-3]);
vm_i2fy_stack_item(ir3,spp[-2]);
vm_i2fy_stack_item(ir4,sppTOS);
LABEL2(dup_x2)
NEXT_P2;
}

LABEL(dup2) /* dup2 ( i1 i2 -- ir1 ir2 ir3 ir4) */
/*  */
NAME("dup2")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir1;
fy_uint ir2;
fy_uint ir3;
fy_uint ir4;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += 2;
{

{
  ir3 = ir1 = i1;
  ir4 = ir2 = i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputs(" ir3=", vm_out); printarg_i(ir3);
fputs(" ir4=", vm_out); printarg_i(ir4);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-4]);
vm_i2fy_stack_item(ir2,spp[-3]);
vm_i2fy_stack_item(ir3,spp[-2]);
vm_i2fy_stack_item(ir4,sppTOS);
LABEL2(dup2)
NEXT_P2;
}

LABEL(dup2_x1) /* dup2_x1 ( i1 i2 i3 -- ir1 ir2 ir3 ir4 ir5) */
/*  */
NAME("dup2_x1")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
fy_uint ir1;
fy_uint ir2;
fy_uint ir3;
fy_uint ir4;
fy_uint ir5;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += 2;
{

{
  ir1 = i2;
  ir2 = i3;
  ir3 = i1;
  ir4 = i2;
  ir5 = i3;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputs(" ir3=", vm_out); printarg_i(ir3);
fputs(" ir4=", vm_out); printarg_i(ir4);
fputs(" ir5=", vm_out); printarg_i(ir5);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-5]);
vm_i2fy_stack_item(ir2,spp[-4]);
vm_i2fy_stack_item(ir3,spp[-3]);
vm_i2fy_stack_item(ir4,spp[-2]);
vm_i2fy_stack_item(ir5,sppTOS);
LABEL2(dup2_x1)
NEXT_P2;
}

LABEL(dup2_x2) /* dup2_x2 ( i1 i2 i3 i4 -- ir1 ir2 ir3 ir4 ir5 ir6) */
/*  */
NAME("dup2_x2")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
fy_uint i4;
fy_uint ir1;
fy_uint ir2;
fy_uint ir3;
fy_uint ir4;
fy_uint ir5;
fy_uint ir6;
NEXT_P0;
vm_fy_stack_item2i(spp[-4],i1);
vm_fy_stack_item2i(spp[-3],i2);
vm_fy_stack_item2i(spp[-2],i3);
vm_fy_stack_item2i(sppTOS,i4);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
fputs(" i4=", vm_out); printarg_i(i4);
}
#endif
spp += 2;
{

{
  ir1 = i3;
  ir2 = i4;
  ir3 = i1;
  ir4 = i2;
  ir5 = i3;
  ir6 = i4;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputs(" ir3=", vm_out); printarg_i(ir3);
fputs(" ir4=", vm_out); printarg_i(ir4);
fputs(" ir5=", vm_out); printarg_i(ir5);
fputs(" ir6=", vm_out); printarg_i(ir6);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-6]);
vm_i2fy_stack_item(ir2,spp[-5]);
vm_i2fy_stack_item(ir3,spp[-4]);
vm_i2fy_stack_item(ir4,spp[-3]);
vm_i2fy_stack_item(ir5,spp[-2]);
vm_i2fy_stack_item(ir6,sppTOS);
LABEL2(dup2_x2)
NEXT_P2;
}

LABEL(swap) /* swap ( i1 i2 -- ir1 ir2) */
/*  */
NAME("swap")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir1;
fy_uint ir2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
{

{
  ir1 = i2;
  ir2 = i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir1=", vm_out); printarg_i(ir1);
fputs(" ir2=", vm_out); printarg_i(ir2);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir1,spp[-2]);
vm_i2fy_stack_item(ir2,sppTOS);
LABEL2(swap)
NEXT_P2;
}

LABEL(bipush) /* bipush ( -- ir) */
/*  */
NAME("bipush")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.int_params.param1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(bipush)
NEXT_P2;
}

LABEL(sipush) /* sipush ( -- ir) */
/*  */
NAME("sipush")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.int_params.param1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(sipush)
NEXT_P2;
}

LABEL(iconst_m1) /* iconst_m1 ( -- ir) */
/*  */
NAME("iconst_m1")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = -1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_m1)
NEXT_P2;
}

LABEL(aconst_null) /* aconst_null ( -- ir) */
/*  */
NAME("aconst_null")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 0;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aconst_null)
NEXT_P2;
}

LABEL(iconst_0) /* iconst_0 ( -- ir) */
/*  */
NAME("iconst_0")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 0;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_0)
NEXT_P2;
}

LABEL(fconst_0) /* fconst_0 ( -- fr) */
/*  */
NAME("fconst_0")
{
DEF_CA
fy_float fr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fr = 0.0f;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fconst_0)
NEXT_P2;
}

LABEL(dconst_0) /* dconst_0 ( -- dr) */
/*  */
NAME("dconst_0")
{
DEF_CA
fy_double dr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  dr = 0.0;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(dconst_0)
NEXT_P2;
}

LABEL(lconst_0) /* lconst_0 ( -- lr) */
/*  */
NAME("lconst_0")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  lr = 0;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lconst_0)
NEXT_P2;
}

LABEL(iconst_1) /* iconst_1 ( -- ir) */
/*  */
NAME("iconst_1")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_1)
NEXT_P2;
}

LABEL(fconst_1) /* fconst_1 ( -- fr) */
/*  */
NAME("fconst_1")
{
DEF_CA
fy_float fr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fr = 1.0f;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fconst_1)
NEXT_P2;
}

LABEL(dconst_1) /* dconst_1 ( -- dr) */
/*  */
NAME("dconst_1")
{
DEF_CA
fy_double dr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  dr = 1.0;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(dconst_1)
NEXT_P2;
}

LABEL(lconst_1) /* lconst_1 ( -- lr) */
/*  */
NAME("lconst_1")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  lr = 1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lconst_1)
NEXT_P2;
}

LABEL(iconst_2) /* iconst_2 ( -- ir) */
/*  */
NAME("iconst_2")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_2)
NEXT_P2;
}

LABEL(fconst_2) /* fconst_2 ( -- fr) */
/*  */
NAME("fconst_2")
{
DEF_CA
fy_float fr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fr = 2.0f;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fconst_2)
NEXT_P2;
}

LABEL(iconst_3) /* iconst_3 ( -- ir) */
/*  */
NAME("iconst_3")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 3;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_3)
NEXT_P2;
}

LABEL(iconst_4) /* iconst_4 ( -- ir) */
/*  */
NAME("iconst_4")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 4;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_4)
NEXT_P2;
}

LABEL(iconst_5) /* iconst_5 ( -- ir) */
/*  */
NAME("iconst_5")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = 5;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iconst_5)
NEXT_P2;
}

LABEL(d2f) /* d2f ( d1 -- fr) */
/*  */
NAME("d2f")
{
DEF_CA
fy_double d1;
fy_float fr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
spp += -1;
{

{
  fr = (fy_float)d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(d2f)
NEXT_P2;
}

LABEL(d2i) /* d2i ( d1 -- ir) */
/*  */
NAME("d2i")
{
DEF_CA
fy_double d1;
fy_uint ir;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
spp += -1;
{

{
  ir = (fy_int)d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(d2i)
NEXT_P2;
}

LABEL(d2l) /* d2l ( d1 -- lr) */
/*  */
NAME("d2l")
{
DEF_CA
fy_double d1;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
{

{
  lr = (fy_long)d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(d2l)
NEXT_P2;
}

LABEL(f2d) /* f2d ( f1 -- dr) */
/*  */
NAME("f2d")
{
DEF_CA
fy_float f1;
fy_double dr;
NEXT_P0;
vm_fy_stack_item2f(sppTOS,f1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
}
#endif
spp += 1;
{

{
  dr = f1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(f2d)
NEXT_P2;
}

LABEL(f2i) /* f2i ( f1 -- ir) */
/*  */
NAME("f2i")
{
DEF_CA
fy_float f1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2f(sppTOS,f1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
}
#endif
{

{
  ir = (fy_int)f1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(f2i)
NEXT_P2;
}

LABEL(f2l) /* f2l ( f1 -- lr) */
/*  */
NAME("f2l")
{
DEF_CA
fy_float f1;
fy_ulong lr;
NEXT_P0;
vm_fy_stack_item2f(sppTOS,f1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
}
#endif
spp += 1;
{

{
  lr = (fy_long)f1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(f2l)
NEXT_P2;
}

LABEL(i2b) /* i2b ( i1 -- ir) */
/*  */
NAME("i2b")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = (fy_byte)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(i2b)
NEXT_P2;
}

LABEL(i2c) /* i2c ( i1 -- ir) */
/*  */
NAME("i2c")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = i1 & 0xffff;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(i2c)
NEXT_P2;
}

LABEL(i2d) /* i2d ( i1 -- dr) */
/*  */
NAME("i2d")
{
DEF_CA
fy_uint i1;
fy_double dr;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
  dr = (fy_int)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(i2d)
NEXT_P2;
}

LABEL(i2f) /* i2f ( i1 -- fr) */
/*  */
NAME("i2f")
{
DEF_CA
fy_uint i1;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  fr = (fy_int)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(i2f)
NEXT_P2;
}

LABEL(i2l) /* i2l ( i1 -- lr) */
/*  */
NAME("i2l")
{
DEF_CA
fy_uint i1;
fy_ulong lr;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
  lr = (fy_int)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(i2l)
NEXT_P2;
}

LABEL(i2s) /* i2s ( i1 -- ir) */
/*  */
NAME("i2s")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = (fy_short)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(i2s)
NEXT_P2;
}

LABEL(l2d) /* l2d ( l1 -- dr) */
/*  */
NAME("l2d")
{
DEF_CA
fy_ulong l1;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
{

{
  dr = (fy_long)l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(l2d)
NEXT_P2;
}

LABEL(l2f) /* l2f ( l1 -- fr) */
/*  */
NAME("l2f")
{
DEF_CA
fy_ulong l1;
fy_float fr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -1;
{

{
  fr = (fy_long)l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(l2f)
NEXT_P2;
}

LABEL(l2i) /* l2i ( l1 -- ir) */
/*  */
NAME("l2i")
{
DEF_CA
fy_ulong l1;
fy_uint ir;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -1;
{

{
  ir = (fy_uint)l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(l2i)
NEXT_P2;
}

LABEL(fadd) /* fadd ( f1 f2 -- fr) */
/*  */
NAME("fadd")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  fr = f1 + f2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fadd)
NEXT_P2;
}

LABEL(fsub) /* fsub ( f1 f2 -- fr) */
/*  */
NAME("fsub")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  fr = f1 - f2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fsub)
NEXT_P2;
}

LABEL(fmul) /* fmul ( f1 f2 -- fr) */
/*  */
NAME("fmul")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  fr = f1 * f2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fmul)
NEXT_P2;
}

LABEL(fdiv) /* fdiv ( f1 f2 -- fr) */
/*  */
NAME("fdiv")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  fr = f1 / f2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fdiv)
NEXT_P2;
}

LABEL(frem) /* frem ( f1 f2 -- fr) */
/*  */
NAME("frem")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  if(f2 == 0){
    fr = 0.0 / f2;
  } else {
    fr = f1 - floor(f1 / f2) * f2;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(frem)
NEXT_P2;
}

LABEL(fneg) /* fneg ( f1 -- fr) */
/*  */
NAME("fneg")
{
DEF_CA
fy_float f1;
fy_float fr;
NEXT_P0;
vm_fy_stack_item2f(sppTOS,f1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
}
#endif
{

{
  fr = -f1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fy_stack_item(fr,sppTOS);
LABEL2(fneg)
NEXT_P2;
}

LABEL(fcmpg) /* fcmpg ( f1 f2 -- ir) */
/*  */
NAME("fcmpg")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  if (unlikely(fy_isnand(f2) || fy_isnand(f1))) {
    ir = 1;
  } else {
    ir = f1 == f2 ? 0 : (f1 - f2 > 0) ? 1 : -1;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fcmpg)
NEXT_P2;
}

LABEL(fcmpl) /* fcmpl ( f1 f2 -- ir) */
/*  */
NAME("fcmpl")
{
DEF_CA
fy_float f1;
fy_float f2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2f(spp[-2],f1);
vm_fy_stack_item2f(sppTOS,f2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
fputs(" f2=", vm_out); printarg_f(f2);
}
#endif
spp += -1;
{

{
  if (unlikely(fy_isnand(f2) || fy_isnand(f1))) {
    ir = -1;
  } else {
    ir = f1 == f2 ? 0 : (f1 - f2 > 0) ? 1 : -1;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(fcmpl)
NEXT_P2;
}

LABEL(dadd) /* dadd ( d1 d2 -- dr) */
/*  */
NAME("dadd")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -2;
{

{
  dr = d1 + d2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(dadd)
NEXT_P2;
}

LABEL(dsub) /* dsub ( d1 d2 -- dr) */
/*  */
NAME("dsub")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -2;
{

{
  dr = d1 - d2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(dsub)
NEXT_P2;
}

LABEL(ddiv) /* ddiv ( d1 d2 -- dr) */
/*  */
NAME("ddiv")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -2;
{

{
  dr = d1 / d2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(ddiv)
NEXT_P2;
}

LABEL(dmul) /* dmul ( d1 d2 -- dr) */
/*  */
NAME("dmul")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -2;
{

{
  dr = d1 * d2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(dmul)
NEXT_P2;
}

LABEL(drem) /* drem ( d1 d2 -- dr) */
/*  */
NAME("drem")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -2;
{

{
  if(d2 == 0){
    dr = 0.0 / d2;
  } else {
    dr = d1 - floor(d1 / d2) * d2;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(drem)
NEXT_P2;
}

LABEL(dneg) /* dneg ( d1 -- dr) */
/*  */
NAME("dneg")
{
DEF_CA
fy_double d1;
fy_double dr;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
{

{
  dr = -d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofy_stack_item(dr, spp[-2], sppTOS)
LABEL2(dneg)
NEXT_P2;
}

LABEL(dcmpg) /* dcmpg ( d1 d2 -- ir) */
/*  */
NAME("dcmpg")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_uint ir;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -3;
{

{
  if (unlikely(fy_isnand(d2) || fy_isnand(d1))) {
    ir = 1;
  } else {
    ir = d1 == d2 ? 0 : (d1 - d2 > 0) ? 1 : -1;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(dcmpg)
NEXT_P2;
}

LABEL(dcmpl) /* dcmpl ( d1 d2 -- ir) */
/*  */
NAME("dcmpl")
{
DEF_CA
fy_double d1;
fy_double d2;
fy_uint ir;
NEXT_P0;
vm_twofy_stack_item2d((Cell)spp[-4], (Cell)spp[-3], d1)
vm_twofy_stack_item2d((Cell)spp[-2], (Cell)sppTOS, d2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
fputs(" d2=", vm_out); printarg_d(d2);
}
#endif
spp += -3;
{

{
  if (unlikely(fy_isnand(d2) || fy_isnand(d1))) {
    ir = -1;
  } else {
    ir = d1 == d2 ? 0 : (d1 - d2 > 0) ? 1 : -1;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(dcmpl)
NEXT_P2;
}

LABEL(iadd) /* iadd ( i1 i2 -- ir) */
/*  */
NAME("iadd")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 + i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iadd)
NEXT_P2;
}

LABEL(isub) /* isub ( i1 i2 -- ir) */
/*  */
NAME("isub")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 - i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(isub)
NEXT_P2;
}

LABEL(imul) /* imul ( i1 i2 -- ir) */
/*  */
NAME("imul")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = (fy_uint)((fy_int)i1 * (fy_int)i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(imul)
NEXT_P2;
}

LABEL(idiv) /* idiv ( i1 i2 -- ir) */
/*  */
NAME("idiv")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(i2 == 0){
    fy_fault(exception, FY_EXCEPTION_ARITHMETIC, "Divided by zero!");
    FY_THEH()
    ir = 0;
  } else {
    ir = ((fy_int)i1) / ((fy_int)i2);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(idiv)
NEXT_P2;
}

LABEL(irem) /* irem ( i1 i2 -- ir) */
/*  */
NAME("irem")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(i2 == 0){
    fy_fault(exception, FY_EXCEPTION_ARITHMETIC, "Divided by zero!");
    FY_THEH()
    ir = 0;
  } else {
    ir = ((fy_int)i1) % ((fy_int)i2);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(irem)
NEXT_P2;
}

LABEL(ineg) /* ineg ( i1 -- ir) */
/*  */
NAME("ineg")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = -i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ineg)
NEXT_P2;
}

LABEL(iand) /* iand ( i1 i2 -- ir) */
/*  */
NAME("iand")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 & i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iand)
NEXT_P2;
}

LABEL(ior) /* ior ( i1 i2 -- ir) */
/*  */
NAME("ior")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 | i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ior)
NEXT_P2;
}

LABEL(ixor) /* ixor ( i1 i2 -- ir) */
/*  */
NAME("ixor")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 ^ i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ixor)
NEXT_P2;
}

LABEL(ishl) /* ishl ( i1 i2 -- ir) */
/*  */
NAME("ishl")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 << i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ishl)
NEXT_P2;
}

LABEL(ishr) /* ishr ( i1 i2 -- ir) */
/*  */
NAME("ishr")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = ((fy_int)i1) >> ((fy_int)i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ishr)
NEXT_P2;
}

LABEL(iushr) /* iushr ( i1 i2 -- ir) */
/*  */
NAME("iushr")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = i1 >> i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iushr)
NEXT_P2;
}

LABEL(ladd) /* ladd ( l1 l2 -- lr) */
/*  */
NAME("ladd")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = l1 + l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(ladd)
NEXT_P2;
}

LABEL(lsub) /* lsub ( l1 l2 -- lr) */
/*  */
NAME("lsub")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = l1 - l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lsub)
NEXT_P2;
}

LABEL(lmul) /* lmul ( l1 l2 -- lr) */
/*  */
NAME("lmul")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = (fy_long) l1 * (fy_long) l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lmul)
NEXT_P2;
}

LABEL(ldiv) /* ldiv ( l1 l2 -- lr) */
/*  */
NAME("ldiv")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  if (unlikely(l2 == 0)) {
    fy_fault(exception, FY_EXCEPTION_ARITHMETIC, "Divided by zero!");
    FY_THEH()
  }
  lr = (fy_long) l1 / (fy_long) l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(ldiv)
NEXT_P2;
}

LABEL(lrem) /* lrem ( l1 l2 -- lr) */
/*  */
NAME("lrem")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  if (unlikely(l2 == 0)) {
    fy_fault(exception, FY_EXCEPTION_ARITHMETIC, "Divided by zero!");
    FY_THEH()
  }
  lr = (fy_long) l1 % (fy_long) l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lrem)
NEXT_P2;
}

LABEL(lneg) /* lneg ( l1 -- lr) */
/*  */
NAME("lneg")
{
DEF_CA
fy_ulong l1;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
{

{
  lr = -l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lneg)
NEXT_P2;
}

LABEL(land) /* land ( l1 l2 -- lr) */
/*  */
NAME("land")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = l1 & l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(land)
NEXT_P2;
}

LABEL(lor) /* lor ( l1 l2 -- lr) */
/*  */
NAME("lor")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = l1 | l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lor)
NEXT_P2;
}

LABEL(lxor) /* lxor ( l1 l2 -- lr) */
/*  */
NAME("lxor")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = l1 ^ l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lxor)
NEXT_P2;
}

LABEL(lcmp) /* lcmp ( l1 l2 -- ir) */
/*  */
NAME("lcmp")
{
DEF_CA
fy_ulong l1;
fy_ulong l2;
fy_uint ir;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-4], (Cell)spp[-3], l1)
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -3;
{

{
  ir = l1 == l2 ? 0 : ((fy_long)l1 > (fy_long)l2 ? 1 : -1) ;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(lcmp)
NEXT_P2;
}

LABEL(lshl) /* lshl ( l1 i1 -- lr) */
/*  */
NAME("lshl")
{
DEF_CA
fy_ulong l1;
fy_uint i1;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-3], (Cell)spp[-2], l1)
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  lr = l1 << i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lshl)
NEXT_P2;
}

LABEL(lshr) /* lshr ( l1 i1 -- lr) */
/*  */
NAME("lshr")
{
DEF_CA
fy_ulong l1;
fy_uint i1;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-3], (Cell)spp[-2], l1)
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  lr = ((fy_long)l1) >> i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lshr)
NEXT_P2;
}

LABEL(lushr) /* lushr ( l1 i1 -- lr) */
/*  */
NAME("lushr")
{
DEF_CA
fy_ulong l1;
fy_uint i1;
fy_ulong lr;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-3], (Cell)spp[-2], l1)
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  lr = l1 >> i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(lushr)
NEXT_P2;
}

LABEL(ldc) /* ldc ( -- ir) */
/*  */
NAME("ldc")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = opLDC(context, method->owner, CURR_INST.params.ldc.value, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ldc)
NEXT_P2;
}

LABEL(ldc_w) /* ldc_w ( -- ir) */
/*  */
NAME("ldc_w")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = opLDC(context, method->owner, CURR_INST.params.ldc.value, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(ldc_w)
NEXT_P2;
}

LABEL(ldc2_w) /* ldc2_w ( -- lr) */
/*  */
NAME("ldc2_w")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  lr = opLDC2(context, method->owner, CURR_INST.params.ldc.value, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(ldc2_w)
NEXT_P2;
}

LABEL(arraylength) /* arraylength ( i1 -- ir) */
/*  */
NAME("arraylength")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = fy_heapArrayLength(context, i1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(arraylength)
NEXT_P2;
}

LABEL(aaload) /* aaload ( i1 i2 -- ir) */
/*  */
NAME("aaload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = fy_heapGetArrayHandle(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(aaload)
NEXT_P2;
}

LABEL(iaload) /* iaload ( i1 i2 -- ir) */
/*  */
NAME("iaload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = fy_heapGetArrayHandle(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(iaload)
NEXT_P2;
}

LABEL(faload) /* faload ( i1 i2 -- ir) */
/*  */
NAME("faload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = fy_heapGetArrayHandle(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(faload)
NEXT_P2;
}

LABEL(aastore) /* aastore ( i1 i2 i3 -- ) */
/*  */
NAME("aastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += -3;
{

{
  fy_class *clazz1, *clazz2;
  clazz1 = fy_heapGetClassOfObject(context, i1, exception);
  clazz2 = clazz1->ci.arr.contentClass;
  if (unlikely(i3 != 0 &&
      !fy_classCanCastTo(context,
                         fy_heapGetClassOfObject(context, i3, exception),
                         clazz2,
                         TRUE))) {
    exception->exceptionType = exception_normal;
    strcpy_s(exception->exceptionName,
             sizeof(exception->exceptionName),
             FY_EXCEPTION_STORE);
    strcpy_s(exception->exceptionDesc,
             sizeof(exception->exceptionDesc),
             "Data type not compatable!");
    FY_THEH()
  }
  fy_heapPutArrayHandle(context, i1, i2, i3, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(aastore)
NEXT_P2;
}

LABEL(iastore) /* iastore ( i1 i2 i3 -- ) */
/*  */
NAME("iastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += -3;
{

{
  fy_heapPutArrayInt(context, i1, i2, i3, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(iastore)
NEXT_P2;
}

LABEL(fastore) /* fastore ( i1 i2 i3 -- ) */
/*  */
NAME("fastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += -3;
{

{
  fy_heapPutArrayInt(context, i1, i2, i3, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(fastore)
NEXT_P2;
}

LABEL(baload) /* baload ( i1 i2 -- ir) */
/*  */
NAME("baload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{ /*handle index -- value*/
  ir = fy_heapGetArrayByte(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(baload)
NEXT_P2;
}

LABEL(bastore) /* bastore ( i1 i2 i3 -- ) */
/*  */
NAME("bastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += -3;
{

{ /*handle index value*/
  fy_heapPutArrayByte(context, i1, i2, (fy_byte) i3, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(bastore)
NEXT_P2;
}

LABEL(caload) /* caload ( i1 i2 -- ir) */
/*  */
NAME("caload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{ /*index handle -- value*/
  ir = fy_heapGetArrayChar(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(caload)
NEXT_P2;
}

LABEL(castore) /* castore ( i1 i2 i3 -- ) */
/*  */
NAME("castore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += -3;
{

{ /*value index handle*/
  fy_heapPutArrayChar(context, i1, i2, (fy_char) i3, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(castore)
NEXT_P2;
}

LABEL(saload) /* saload ( i1 i2 -- ir) */
/*  */
NAME("saload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{ /*index handle -- value*/
  ir = fy_heapGetArrayShort(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(saload)
NEXT_P2;
}

LABEL(sastore) /* sastore ( i1 i2 i3 -- ) */
/*  */
NAME("sastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_uint i3;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_fy_stack_item2i(spp[-2],i2);
vm_fy_stack_item2i(sppTOS,i3);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
}
#endif
spp += -3;
{

{ /*value index handle*/
  fy_heapPutArrayShort(context, i1, i2, (fy_short) i3, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(sastore)
NEXT_P2;
}

LABEL(daload) /* daload ( i1 i2 -- lr) */
/*  */
NAME("daload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_ulong lr;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
{

{
  lr = fy_heapGetArrayLong(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(daload)
NEXT_P2;
}

LABEL(dastore) /* dastore ( i1 i2 l1 -- ) */
/*  */
NAME("dastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_ulong l1;
NEXT_P0;
vm_fy_stack_item2i(spp[-4],i1);
vm_fy_stack_item2i(spp[-3],i2);
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -4;
{

{
  fy_heapPutArrayLong(context, i1, i2, l1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dastore)
NEXT_P2;
}

LABEL(laload) /* laload ( i1 i2 -- lr) */
/*  */
NAME("laload")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_ulong lr;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
{

{
  lr = fy_heapGetArrayLong(context, i1, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(laload)
NEXT_P2;
}

LABEL(lastore) /* lastore ( i1 i2 l1 -- ) */
/*  */
NAME("lastore")
{
DEF_CA
fy_uint i1;
fy_uint i2;
fy_ulong l1;
NEXT_P0;
vm_fy_stack_item2i(spp[-4],i1);
vm_fy_stack_item2i(spp[-3],i2);
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -4;
{

{
  fy_heapPutArrayLong(context, i1, i2, l1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lastore)
NEXT_P2;
}

LABEL(anewarray) /* anewarray ( i1 -- ir) */
/*  */
NAME("anewarray")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  fy_class *clazz1, *clazz2;
  fy_str str1;
  
  if (unlikely(((fy_int) i1) < 0)) {
    exception->exceptionType = exception_normal;
    strcpy_s(exception->exceptionName,
        sizeof(exception->exceptionName),
        FY_EXCEPTION_AIOOB);
    sprintf_s(exception->exceptionDesc,
        sizeof(exception->exceptionDesc), "%d<0", i1);
    FY_THEH()
  }
  clazz1 = CURR_INST.params.clazz;
  FY_THEH()
  str1.content = NULL;
  fy_strInit(block, &str1, 64, exception);
  FY_THEH()
  if (clazz1->type == object_class) {
    fy_strAppendUTF8(block, &str1, "[L", 3, exception);
    FY_THEH({fy_strDestroy(block, &str1);})
    fy_strAppend(block, &str1, clazz1->className, exception);
    FY_THEH({fy_strDestroy(block, &str1);})
    fy_strAppendUTF8(block, &str1, ";", 3, exception);
    FY_THEH({fy_strDestroy(block, &str1);})
  } else if (clazz1->type == array_class) {
    fy_strAppendUTF8(block, &str1, "[", 3, exception);
    FY_THEH({fy_strDestroy(block, &str1);})
    fy_strAppend(block, &str1, clazz1->className, exception);
    FY_THEH({fy_strDestroy(block, &str1);})
  }
  clazz2 = fy_vmLookupClass(context, &str1, exception);
  FY_THEH()
  fy_strDestroy(block, &str1);
  ir = fy_heapAllocateArray(context, clazz2, i1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(anewarray)
NEXT_P2;
}

LABEL(multianewarray) /* multianewarray ( -- ir) */
/*  */
NAME("multianewarray")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_class *clazz1;
  clazz1 = fy_vmLookupClassFromConstant(context, (ConstantClass*) method->owner->constantPools[CURR_INST.params.int_params.param1], exception);
  FY_THEH()
  spp -= CURR_INST.params.int_params.param2;
#ifdef VM_DEBUG
  if(vm_debug){
# ifdef FY_LATE_DECLARATION
    fy_int i1;
# endif
    fputc(' ', vm_out);
    for(i1 = 0; i1 < CURR_INST.params.int_params.param2; i1 ++){
      fprintf(vm_out, "[%"FY_PRINT32"d]", spp[i1].ivalue);
    }
    fputc(' ', vm_out);
  }
#endif
  fy_heapBeginProtect(context);
  ir = fy_heapMultiArray(context, clazz1, CURR_INST.params.int_params.param2, fy_stack_item2iarray(spp - 1),
      exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(multianewarray)
NEXT_P2;
}

LABEL(new) /* new ( -- ir) */
/*  */
NAME("new")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_class *clazz1;
  clazz1 = CURR_INST.params.clazz;
  if (unlikely(clazz1->accessFlags
      & (FY_ACC_INTERFACE | FY_ACC_ABSTRACT))) {
#ifdef FY_LATE_DECLARATION
    char msg[256];
#endif
    fy_strSPrint(msg, 256, clazz1->className);
    fy_fault(exception, NULL, "InstantiationErro %s", msg);
    FY_THEH();
  }
  //!CLINIT
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(clazz1, 0);

  ir = fy_heapAllocate(context, clazz1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(new)
NEXT_P2;
}

LABEL(newarray) /* newarray ( i1 -- ir) */
/*  */
NAME("newarray")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  fy_class *clazz1;
  fy_str *pstr1;
  if (unlikely(((fy_int) i1) < 0)) {
    fy_fault(exception, FY_EXCEPTION_NASE, "%d", i1);
    FY_THEH()
  }
  switch(CURR_INST.params.int_params.param1){
  case 4:
    pstr1 = context->sArrayBoolean;
    break;
  case 5:
    pstr1 = context->sArrayChar;
    break;
  case 6:
    pstr1 = context->sArrayFloat;
    break;
  case 7:
    pstr1 = context->sArrayDouble;
    break;
  case 8:
    pstr1 = context->sArrayByte;
    break;
  case 9:
    pstr1 = context->sArrayShort;
    break;
  case 10:
    pstr1 = context->sArrayInteger;
    break;
  case 11:
    pstr1 = context->sArrayLong;
    break;
  default:
    pstr1 = NULL; /*make compiler happy*/
    fy_fault(exception, FY_EXCEPTION_VM, "%d", CURR_INST.params.int_params.param1);
    FY_THEH()
    break;
  }
  clazz1 = fy_vmLookupClass(context, pstr1, exception);
  FY_THEH()
  ir = fy_heapAllocateArray(context, clazz1, i1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(newarray)
NEXT_P2;
}

LABEL(getfield) /* getfield ( i1 -- ir) */
/*  */
NAME("getfield")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  fy_field *field;
  field = CURR_INST.params.field;
  if (unlikely(field->access_flags & FY_ACC_STATIC)) {
    fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "field %s is static", field->utf8Name);
    FY_THEH()
  }
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getfield %s from #%"FY_PRINT32"d# ", field->utf8Name, i1);
  }
#endif
  ir = fy_heapGetFieldInt(context, i1, field, exception);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #value=%"FY_PRINT32"d# ", ir);
  }
#endif
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(getfield)
NEXT_P2;
}

LABEL(putfield) /* putfield ( i1 i2 --) */
/*  */
NAME("putfield")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  fy_field *field;

  field = CURR_INST.params.field;
  if (unlikely(field->access_flags & FY_ACC_STATIC)) {
    fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "field %s is static", field->utf8Name);
    FY_THEH()
  }
  if (unlikely((field->access_flags & FY_ACC_FINAL) && method->owner != field->owner)) {
    fy_fault(exception, FY_EXCEPTION_ACCESS, "field %s is final", field->utf8Name);
    FY_THEH()
  }
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putfield %s to #%"FY_PRINT32"d value=%"FY_PRINT32"d# ", field->utf8Name, i1, i2);
  }
#endif
  fy_heapPutFieldInt(context, i1, field, i2, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putfield)
NEXT_P2;
}

LABEL(getfield_x) /* getfield_x ( i1 -- lr) */
/*  */
NAME("getfield_x")
{
DEF_CA
fy_uint i1;
fy_ulong lr;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
  fy_field *field;
  field = CURR_INST.params.field;
  if (unlikely(field->access_flags & FY_ACC_STATIC)) {
    fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "field %s is static", field->utf8Name);
    FY_THEH()
  }
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getfield %s from #%"FY_PRINT32"d# ", field->utf8Name, i1);
  }
#endif
  lr = fy_heapGetFieldLong(context, i1, field, exception);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #value=%"FY_PRINT64"d# ", lr);
  }
#endif
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(getfield_x)
NEXT_P2;
}

LABEL(putfield_x) /* putfield_x ( i1 l1 --) */
/*  */
NAME("putfield_x")
{
DEF_CA
fy_uint i1;
fy_ulong l1;
NEXT_P0;
vm_fy_stack_item2i(spp[-3],i1);
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -3;
{

{
  fy_field *field;

  field = CURR_INST.params.field;
  if (unlikely(field->access_flags & FY_ACC_STATIC)) {
    fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "field %s is static", field->utf8Name);
    FY_THEH()
  }
  if (unlikely((field->access_flags & FY_ACC_FINAL) && method->owner != field->owner)) {
    fy_fault(exception, FY_EXCEPTION_ACCESS, "field %s is final", field->utf8Name);
    FY_THEH()
  }
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putfield %s to #%"FY_PRINT32"d value=%"FY_PRINT64"d# ", field->utf8Name, i1, l1);
  }
#endif
  fy_heapPutFieldLong(context, i1, field, l1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putfield_x)
NEXT_P2;
}

LABEL(getstatic) /* getstatic ( -- ir) */
/*  */
NAME("getstatic")
{
DEF_CA
fy_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_field *field;
  fy_class *clazz1;
#endif
  field = CURR_INST.params.field;
  clazz1 = field->owner;
  if (unlikely(!(field->access_flags & FY_ACC_STATIC))) {
    fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "field %s is not static", field->utf8Name);
    FY_THEH()
  }
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %s# ", field->utf8Name);
  }
#endif
  //!CLINIT
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(clazz1, 0);
  ir = fy_heapGetStaticInt(context, field, exception);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %s value=%"FY_PRINT32"d# ", field->utf8Name, ir);
  }
#endif
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(getstatic)
NEXT_P2;
}

LABEL(putstatic) /* putstatic ( i1 -- ) */
/*  */
NAME("putstatic")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_field *field;
  fy_class *clazz1;
#endif
  
  field = CURR_INST.params.field;
  if (unlikely((field->access_flags & FY_ACC_FINAL) && (field->owner != method->owner))) {
    fy_fault(exception, FY_EXCEPTION_ACCESS, "");
    fy_strSPrint(exception->exceptionDesc, sizeof(exception->exceptionDesc), field->uniqueName);
    FY_THEH()
  }
  clazz1 = field->owner;
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #to putstatic %s value=%"FY_PRINT32"d# ", field->utf8Name, i1);
  }
#endif
  //!CLINIT
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(clazz1, 1);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putstatic %s value=%"FY_PRINT32"d# ", field->utf8Name, i1);
  }
#endif
  fy_heapPutStaticInt(context, field, i1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putstatic)
NEXT_P2;
}

LABEL(getstatic_x) /* getstatic_x ( -- lr) */
/*  */
NAME("getstatic_x")
{
DEF_CA
fy_ulong lr;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
#ifdef FY_LATE_DECLARATION
  fy_field *field;
  fy_class *clazz1;
#endif
  field = CURR_INST.params.field;
  clazz1 =  field->owner;
  if (unlikely(!(field->access_flags & FY_ACC_STATIC))) {
    fy_fault(exception, FY_EXCEPTION_INCOMPAT_CHANGE, "field %s is not static", field->utf8Name);
    FY_THEH()
  }
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %s# ", field->utf8Name);
  }
#endif
  //!CLINIT
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(clazz1, 0);
  lr = fy_heapGetStaticLong(context, field, exception);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %s value = %"FY_PRINT64"d# ", field->utf8Name, lr);
  }
#endif
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofy_stack_item(lr, spp[-2], sppTOS)
LABEL2(getstatic_x)
NEXT_P2;
}

LABEL(putstatic_x) /* putstatic_x ( l1 -- ) */
/*  */
NAME("putstatic_x")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
#ifdef FY_LATE_DECLARATION
  fy_field *field;
  fy_class *clazz1;
#endif

  field = CURR_INST.params.field;
  if (unlikely((field->access_flags & FY_ACC_FINAL) && (field->owner != method->owner))) {
    fy_fault(exception, FY_EXCEPTION_ACCESS, "");
    fy_strSPrint(exception->exceptionDesc, sizeof(exception->exceptionDesc), field->uniqueName);
    FY_THEH()
  }
  clazz1 = field->owner;
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #to putstatic %s value=%"FY_PRINT64"d# ", field->utf8Name, l1);
  }
#endif
  //!CLINIT
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(clazz1, 2);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putstatic %s value=%"FY_PRINT64"d# ", field->utf8Name, l1);
  }
#endif
  fy_heapPutStaticLong(context, field, l1, exception);
  FY_THEH()
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putstatic_x)
NEXT_P2;
}

LABEL(checkcast) /* checkcast ( i1 -- ir) */
/*  */
NAME("checkcast")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
#ifdef FY_LATE_DECLARATION
  fy_class *clazz1, *clazz2;
  fy_str str1;
#endif
  if (i1 != 0) {
    clazz1 = fy_heapGetClassOfObject(context, i1, exception);
    clazz2 = CURR_INST.params.clazz;
    
    FY_THEH()
    if (unlikely(!fy_classCanCastTo(context, clazz1, clazz2, TRUE))) {
      strcpy_s(exception->exceptionName,
          sizeof(exception->exceptionName),
          FY_EXCEPTION_CAST);
      str1.content = NULL;
      fy_strInit(block, &str1, 64, exception);
      fy_strAppendUTF8(block, &str1, "from ", 99, exception);
      fy_strAppend(block, &str1, clazz1->className,
          exception);
      fy_strAppendUTF8(block, &str1, " to ", 99, exception);
      fy_strAppend(block, &str1, clazz2->className,
          exception);
      fy_strSPrint(exception->exceptionDesc,
          sizeof(exception->exceptionDesc), &str1);
      fy_strDestroy(block, &str1);
      exception->exceptionType = exception_normal;
      FY_THEH()
      ir = 0;
    } else {
      ir = i1;
    }
  } else {
    ir = i1;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(checkcast)
NEXT_P2;
}

LABEL(instanceof) /* instanceof ( i1 -- ir) */
/*  */
NAME("instanceof")
{
DEF_CA
fy_uint i1;
fy_uint ir;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
#ifdef FY_LATE_DECLARATION
  fy_class *clazz1, *clazz2;
#endif

  if(i1 == 0){
    ir = 0;
  } else {
    clazz1 = fy_heapGetClassOfObject(context, i1, exception);
    clazz2 = CURR_INST.params.clazz;
    FY_THEH()
    ir = fy_classCanCastTo(context, clazz1, clazz2, TRUE) ? 1 : 0;
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fy_stack_item(ir,sppTOS);
LABEL2(instanceof)
NEXT_P2;
}

LABEL(monitorenter) /* monitorenter ( i1 -- ) */
/*  */
NAME("monitorenter")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops = fy_threadMonitorEnter(context, thread, i1, ops);
  FY_CHECK_OPS;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(monitorenter)
NEXT_P2;
}

LABEL(monitorexit) /* monitorexit ( i1 -- ) */
/*  */
NAME("monitorexit")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops = fy_threadMonitorExit(context, thread, i1, ops, exception);
  FY_THEH()
  FY_CHECK_OPS;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(monitorexit)
NEXT_P2;
}

LABEL(invokespecial) /* invokespecial ( -- ) */
/*  */
NAME("invokespecial")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_localToFrame(context, frame);
  ops = fy_threadInvokeSpecial(context, thread, frame, CURR_INST.params.method, spp, ops, exception);
  FY_THEH();
  FY_CHECK_OPS_INVOKE;
  FY_UPDATE_SP(context, frame);
  SUPER_END;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invokespecial)
NEXT_P2;
}

LABEL(invokestatic) /* invokestatic ( -- ) */
/*  */
NAME("invokestatic")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  //!CLINIT
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.method->owner, 0);
  ops = fy_threadInvokeStatic(context, thread, frame, CURR_INST.params.method, spp, ops, exception);
  FY_THEH();
  FY_CHECK_OPS_INVOKE;
  FY_UPDATE_SP(context, frame);
  SUPER_END;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invokestatic)
NEXT_P2;
}

LABEL(invokeinterface) /* invokeinterface ( -- ) */
/*  */
NAME("invokeinterface")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_localToFrame(context, frame);
  ops = fy_threadInvokeVirtual(context, thread, frame, CURR_INST.params.method, spp, ops, exception);
  FY_THEH();
  FY_CHECK_OPS_INVOKE;
  FY_UPDATE_SP(context, frame);
  SUPER_END;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invokeinterface)
NEXT_P2;
}

LABEL(invokevirtual) /* invokevirtual ( -- ) */
/*  */
NAME("invokevirtual")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_localToFrame(context, frame);
  ops = fy_threadInvokeVirtual(context, thread, frame, CURR_INST.params.method, spp, ops, exception);
  FY_THEH();
  FY_CHECK_OPS_INVOKE;
  FY_UPDATE_SP(context, frame);
  SUPER_END;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invokevirtual)
NEXT_P2;
}

LABEL(return) /* return ( -- ) */
/*  */
NAME("return")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2;
#endif

  if (unlikely(method->access_flags & FY_ACC_SYNCHRONIZED)) {
    if (method->access_flags & FY_ACC_STATIC) {
      i2 = fy_vmGetClassObjHandle(context, method->owner, exception);
      FY_THEH()
      ops = fy_threadMonitorExit(context, thread, i2, ops, exception);
    } else {
      /*CUSTOM*/
      ops = fy_threadMonitorExit(context, thread, sbase->uvalue, ops, exception);
    }
    FY_THEH()
  }
  if (unlikely(method->access_flags & FY_ACC_CLINIT)) {
    method->owner->clinitThreadId = -1;
  }
  fy_localToFrame(context, frame);
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    if(thread->frameCount > 0){
      fprintf(vm_out, " #Return to %s @%d + %d# ", 
        fy_threadCurrentFrame(context, thread)->method->utf8Name,
        fy_threadCurrentFrame(context, thread)->lpc,
        fy_threadCurrentFrame(context, thread)->pcofs
      );
    }
  }
#endif
  SUPER_END;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(return)
NEXT_P2;
}

LABEL(ireturn) /* ireturn ( i1 -- ) */
/*  */
NAME("ireturn")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2;
#endif

  if (unlikely(method->access_flags & FY_ACC_SYNCHRONIZED)) {
    if (method->access_flags & FY_ACC_STATIC) {
      i2 = fy_vmGetClassObjHandle(context, method->owner, exception);
      FY_THEH()
      ops = fy_threadMonitorExit(context, thread, i2, ops, exception);
    } else {
      /*CUSTOM*/
      ops = fy_threadMonitorExit(context, thread, sbase->uvalue, ops, exception);
    }
    FY_THEH()
  }
  fy_threadReturnInt(frame->baseSpp, i1);
  fy_localToFrame(context, frame);
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #Return %"FY_PRINT32"d to %s @%d + %d# ",
      sbase->ivalue,
      fy_threadCurrentFrame(context, thread)->method->utf8Name,
      fy_threadCurrentFrame(context, thread)->lpc,
      fy_threadCurrentFrame(context, thread)->pcofs
    );
  }
#endif
  SUPER_END;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ireturn)
NEXT_P2;
}

LABEL(freturn) /* freturn ( i1 -- ) */
/*  */
NAME("freturn")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2;
#endif

  if (unlikely(method->access_flags & FY_ACC_SYNCHRONIZED)) {
    if (method->access_flags & FY_ACC_STATIC) {
      i2 = fy_vmGetClassObjHandle(context, method->owner, exception);
      FY_THEH()
      ops = fy_threadMonitorExit(context, thread, i2, ops, exception);
    } else {
      /*CUSTOM*/
      ops = fy_threadMonitorExit(context, thread, sbase->uvalue, ops, exception);
    }
    FY_THEH()
  }
  fy_threadReturnInt(frame->baseSpp, i1);
  fy_localToFrame(context, frame);
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #Return %f to %s @%d + %d# ",
      fy_intToFloat(sbase->ivalue),
      fy_threadCurrentFrame(context, thread)->method->utf8Name,
      fy_threadCurrentFrame(context, thread)->lpc,
      fy_threadCurrentFrame(context, thread)->pcofs
    );
  }
#endif
  SUPER_END;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(freturn)
NEXT_P2;
}

LABEL(areturn) /* areturn ( i1 -- ) */
/*  */
NAME("areturn")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2;
#endif

  if (unlikely(method->access_flags & FY_ACC_SYNCHRONIZED)) {
    if (method->access_flags & FY_ACC_STATIC) {
      i2 = fy_vmGetClassObjHandle(context, method->owner, exception);
      FY_THEH()
      ops = fy_threadMonitorExit(context, thread, i2, ops, exception);
    } else {
      /*CUSTOM*/
      ops = fy_threadMonitorExit(context, thread, sbase->uvalue, ops, exception);
    }
    FY_THEH()
  }
  fy_threadReturnHandle(frame->baseSpp, i1);
  fy_localToFrame(context, frame);
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #Return #%d to %s @%d + %d# ",
      sbase->ivalue,
      fy_threadCurrentFrame(context, thread)->method->utf8Name,
      fy_threadCurrentFrame(context, thread)->lpc,
      fy_threadCurrentFrame(context, thread)->pcofs
    );
  }
#endif
  SUPER_END;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(areturn)
NEXT_P2;
}

LABEL(dreturn) /* dreturn ( l1 -- ) */
/*  */
NAME("dreturn")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2;
#endif

  if ((method->access_flags & FY_ACC_SYNCHRONIZED)) {
    if (method->access_flags & FY_ACC_STATIC) {
      i2 = fy_vmGetClassObjHandle(context, method->owner, exception);
      FY_THEH()
      ops = fy_threadMonitorExit(context, thread, i2, ops, exception);
    } else {
      /*CUSTOM*/
      ops = fy_threadMonitorExit(context, thread, sbase->uvalue, ops, exception);
    }
    FY_THEH()
  }
  fy_threadReturnLong(frame->baseSpp, l1);
  fy_localToFrame(context, frame);
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #Return %f to %s @%d + %d# ",
      fy_longToDouble(fy_I2TOL(sbase->ivalue, (sbase + 1)->ivalue)),
      fy_threadCurrentFrame(context, thread)->method->utf8Name,
      fy_threadCurrentFrame(context, thread)->lpc,
      fy_threadCurrentFrame(context, thread)->pcofs
    );
  }
#endif
  SUPER_END;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(dreturn)
NEXT_P2;
}

LABEL(lreturn) /* lreturn ( l1 -- ) */
/*  */
NAME("lreturn")
{
DEF_CA
fy_ulong l1;
NEXT_P0;
vm_twofy_stack_item2l((Cell)spp[-2], (Cell)sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -2;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2;
#endif

  if (unlikely(method->access_flags & FY_ACC_SYNCHRONIZED)) {
    if (method->access_flags & FY_ACC_STATIC) {
      i2 = fy_vmGetClassObjHandle(context, method->owner, exception);
      FY_THEH()
      ops = fy_threadMonitorExit(context, thread, i2, ops, exception);
    } else {
      /*CUSTOM*/
      ops = fy_threadMonitorExit(context, thread, sbase->uvalue, ops, exception);
    }
    FY_THEH()
  }
  fy_threadReturnLong(frame->baseSpp, l1);
  fy_localToFrame(context, frame);
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #Return %"FY_PRINT64"d to %s @%d + %d# ",
      fy_I2TOL(sbase->ivalue, (sbase + 1)->ivalue),
      fy_threadCurrentFrame(context, thread)->method->utf8Name,
      fy_threadCurrentFrame(context, thread)->lpc,
      fy_threadCurrentFrame(context, thread)->pcofs
    );
  }
#endif
  SUPER_END;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lreturn)
NEXT_P2;
}

LABEL(athrow) /* athrow ( i1 -- ) */
/*  */
NAME("athrow")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  thread->currentThrowable = i1;
  SUPER_END;
  FY_FALLOUT_NOINVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(athrow)
NEXT_P2;
}

LABEL(goto) /* goto ( -- ) */
/*  */
NAME("goto")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  FY_CHECK_OPS_AND_GOTO;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(goto)
NEXT_P2;
}

LABEL(goto_w) /* goto_w ( -- ) */
/*  */
NAME("goto_w")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  FY_CHECK_OPS_AND_GOTO;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(goto_w)
NEXT_P2;
}

LABEL(if_icmpeq) /* if_icmpeq ( i1 i2 -- ) */
/*  */
NAME("if_icmpeq")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(i1 == i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_icmpeq)
NEXT_P2;
}

LABEL(if_acmpeq) /* if_acmpeq ( i1 i2 -- ) */
/*  */
NAME("if_acmpeq")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(i1 == i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_acmpeq)
NEXT_P2;
}

LABEL(if_icmpne) /* if_icmpne ( i1 i2 -- ) */
/*  */
NAME("if_icmpne")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(i1 != i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_icmpne)
NEXT_P2;
}

LABEL(if_acmpne) /* if_acmpne ( i1 i2 -- ) */
/*  */
NAME("if_acmpne")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(i1 != i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_acmpne)
NEXT_P2;
}

LABEL(if_icmplt) /* if_icmplt ( i1 i2 -- ) */
/*  */
NAME("if_icmplt")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if((fy_int)i1 < (fy_int)i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_icmplt)
NEXT_P2;
}

LABEL(if_icmple) /* if_icmple ( i1 i2 -- ) */
/*  */
NAME("if_icmple")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if((fy_int)i1 <= (fy_int)i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_icmple)
NEXT_P2;
}

LABEL(if_icmpgt) /* if_icmpgt ( i1 i2 -- ) */
/*  */
NAME("if_icmpgt")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if((fy_int)i1 > (fy_int)i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_icmpgt)
NEXT_P2;
}

LABEL(if_icmpge) /* if_icmpge ( i1 i2 -- ) */
/*  */
NAME("if_icmpge")
{
DEF_CA
fy_uint i1;
fy_uint i2;
NEXT_P0;
vm_fy_stack_item2i(spp[-2],i1);
vm_fy_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if((fy_int)i1 >= (fy_int)i2){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(if_icmpge)
NEXT_P2;
}

LABEL(ifeq) /* ifeq ( i1 -- ) */
/*  */
NAME("ifeq")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if(i1 == 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifeq)
NEXT_P2;
}

LABEL(ifnull) /* ifnull ( i1 -- ) */
/*  */
NAME("ifnull")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if(i1 == 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifnull)
NEXT_P2;
}

LABEL(ifne) /* ifne ( i1 -- ) */
/*  */
NAME("ifne")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if(i1 != 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifne)
NEXT_P2;
}

LABEL(ifnonnull) /* ifnonnull ( i1 -- ) */
/*  */
NAME("ifnonnull")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if(i1 != 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifnonnull)
NEXT_P2;
}

LABEL(iflt) /* iflt ( i1 -- ) */
/*  */
NAME("iflt")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if((fy_int)i1 < 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(iflt)
NEXT_P2;
}

LABEL(ifle) /* ifle ( i1 -- ) */
/*  */
NAME("ifle")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if((fy_int)i1 <= 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifle)
NEXT_P2;
}

LABEL(ifgt) /* ifgt ( i1 -- ) */
/*  */
NAME("ifgt")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if((fy_int)i1 > 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifgt)
NEXT_P2;
}

LABEL(ifge) /* ifge ( i1 -- ) */
/*  */
NAME("ifge")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if((fy_int)i1 >= 0){
    FY_CHECK_OPS_AND_GOTO;
    
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
  SUPER_CONTINUE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(ifge)
NEXT_P2;
}

LABEL(lookupswitch) /* lookupswitch ( i1 -- ) */
/*  */
NAME("lookupswitch")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2, i3;
  fy_switch_lookup *swlookup;
#endif
  swlookup = CURR_INST.params.swlookup;
  i3 = swlookup->count;
  for(i2 = 0; i2 < i3; i2++){
    if(swlookup->targets[i2].value == i1){
      SET_IP(swlookup->targets[i2].target);
      SUPER_END;

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

      break;
    }
  }

  SET_IP(swlookup->defaultJump);
}

}
SUPER_END;

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(lookupswitch)
NEXT_P2;
}

LABEL(tableswitch) /* tableswitch ( i1 -- ) */
/*  */
NAME("tableswitch")
{
DEF_CA
fy_uint i1;
NEXT_P0;
vm_fy_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fy_uint i2, i3;
#endif
  i2 = CURR_INST.params.swtable->lowest;/*lb*/
  i3 = CURR_INST.params.swtable->highest;/*hb*/
  if ((fy_int) i1 < (fy_int) i2
      || (fy_int) i1 > (fy_int) i3) {
    SET_IP(CURR_INST.params.swtable->defaultJump);
    SUPER_END;

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  } else {
    SET_IP(CURR_INST.params.swtable->targets[i1 - i2]);
    SUPER_END;

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
NEXT_P2;

  }
}

}
SUPER_END;

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(tableswitch)
NEXT_P2;
}

#ifdef FY_ENGINE_HEADER
    label_fallout_invoke:
    ret.ops = ops;
  }
  return ret;
}
#undef FY_ENGINE_NAME
#endif
