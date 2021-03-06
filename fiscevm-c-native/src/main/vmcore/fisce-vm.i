#ifndef FY_ENGINE_NAME
# define FY_ENGINE_NAME(NUM) fy_thread_runner_##NUM
# define X_FY_ENGINE_NAME(NUM) FY_ENGINE_NAME(NUM)
#endif
FY_HOT fisce_int X_FY_ENGINE_NAME(FY_ENGINE_NUM)(
    fy_context *context,
    fy_thread *thread,
    fy_frame *frame,
    fisce_int ops,
    fisce_exception *exception,
    fy_e2_label_holder **out_labels) {
#ifndef FY_LATE_DECLARATION
# ifdef USE_CFA
  register fy_e2_label cfa;
# endif
  register fy_instruction *ipp;
# ifdef FY_USE_TOS
  register fisce_stack_item sppTOS;
# endif
  register fisce_stack_item *spp;

  fy_instruction *instructions;
  register fisce_stack_item *sbase;


  fy_method *method = NULL;

  fisce_uint i1, i2, i3, i4, i5, i6, ir1, ir2, ir3, ir4, ir5, ir6;
  fy_class *clazz1, *clazz2;
  fy_field *field;
  fy_switch_lookup *swlookup;
  fy_switch_table *swtable;
#endif

  static fy_e2_label_holder labels[] = {
#include "fisce-labels.i"
      {0, -1}
  };
#ifdef MORE_VARS
  MORE_VARS
#endif

#ifdef VM_DEBUG
  FILE *vm_out = stdout;
# ifdef FY_VERBOSE
    const fisce_uint vm_debug = 1;
# endif
#endif

  if(unlikely(thread == NULL)){
    *out_labels = labels;
    return 0;
  }else{
#ifdef FY_LATE_DECLARATION
# ifdef USE_CFA
  register fy_e2_label cfa;
# endif
  register fy_instruction *ipp;
# ifdef FY_USE_TOS
  register fisce_stack_item sppTOS;
# endif
  register fisce_stack_item *spp;

  fy_instruction *instructions;
  register fisce_stack_item *sbase;

  fy_method *method = NULL;
#endif


  method = frame->method;
  instructions = method->c.i.instructions;
  sbase = frame->baseSpp;

#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, "\nInvoking: ");
    fy_strFPrint(vm_out, method->uniqueName);
    fprintf(vm_out, " pc = %"FY_PRINT32"d + %"FY_PRINT32"d\n sb = %"FY_PRINT32"d", frame->lpc, frame->pcofs, FY_PDIFF(fisce_stack_item, sbase, thread->stack));
    if(frame->lpc + frame->pcofs == FY_IP_begin){
#ifdef FY_LATE_DECLARATION
      fisce_uint i1, i2;
#endif
      fprintf(vm_out, "[");
      i2 = method->max_locals + method->max_stack;
      for(i1 = 0; i1 < i2; i1++){
        printarg_i(sbase[i1].ivalue);
        if(i1 < i2 - 1) fputs(", ", vm_out);
      }
      fputs("]\n", vm_out);
    }
  }
#endif

  if (unlikely((method->access_flags & FY_ACC_CLINIT) && frame->lpc + frame->pcofs == FY_IP_begin)) {
#ifdef VM_DEBUG
    if(vm_debug){
      fprintf(vm_out, "Checking clinit for: ");
      fy_strFPrint(vm_out, method->uniqueName);
      fprintf(vm_out, "\n");
    }
#endif
    /*!CLINIT*/
    ipp = method->c.i.instructions;
    spp = frame->baseSpp + method->max_locals;
    FY_ENGINE_CLINIT(method->owner, 0)
  }

  ENGINE_ENTER;
  label_fallout_invoke:
#ifdef FY_INSTRUCTION_COUNT
  context->engines[FY_ENGINE_NUM].replData.last_op = 0x1ff;
#endif
  return ops;
  ENGINE_BODY_BEGIN;
LABEL(iload_r0) /* iload_r0 ( -- ir) */
/*  */
NAME("iload_r0")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r0)
NEXT_P2;
}

LABEL(iload_r1) /* iload_r1 ( -- ir) */
/*  */
NAME("iload_r1")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r1)
NEXT_P2;
}

LABEL(iload_r2) /* iload_r2 ( -- ir) */
/*  */
NAME("iload_r2")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r2)
NEXT_P2;
}

LABEL(iload_r3) /* iload_r3 ( -- ir) */
/*  */
NAME("iload_r3")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r3)
NEXT_P2;
}

LABEL(iload_r4) /* iload_r4 ( -- ir) */
/*  */
NAME("iload_r4")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r4)
NEXT_P2;
}

LABEL(iload_r5) /* iload_r5 ( -- ir) */
/*  */
NAME("iload_r5")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r5)
NEXT_P2;
}

LABEL(iload_r6) /* iload_r6 ( -- ir) */
/*  */
NAME("iload_r6")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r6)
NEXT_P2;
}

LABEL(iload_r7) /* iload_r7 ( -- ir) */
/*  */
NAME("iload_r7")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r7)
NEXT_P2;
}

LABEL(iload_r8) /* iload_r8 ( -- ir) */
/*  */
NAME("iload_r8")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r8)
NEXT_P2;
}

LABEL(iload_r9) /* iload_r9 ( -- ir) */
/*  */
NAME("iload_r9")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r9)
NEXT_P2;
}

LABEL(iload_r10) /* iload_r10 ( -- ir) */
/*  */
NAME("iload_r10")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r10)
NEXT_P2;
}

LABEL(iload_r11) /* iload_r11 ( -- ir) */
/*  */
NAME("iload_r11")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r11)
NEXT_P2;
}

LABEL(iload_r12) /* iload_r12 ( -- ir) */
/*  */
NAME("iload_r12")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r12)
NEXT_P2;
}

LABEL(iload_r13) /* iload_r13 ( -- ir) */
/*  */
NAME("iload_r13")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r13)
NEXT_P2;
}

LABEL(iload_r14) /* iload_r14 ( -- ir) */
/*  */
NAME("iload_r14")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r14)
NEXT_P2;
}

LABEL(iload_r15) /* iload_r15 ( -- ir) */
/*  */
NAME("iload_r15")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r15)
NEXT_P2;
}

LABEL(iload_r16) /* iload_r16 ( -- ir) */
/*  */
NAME("iload_r16")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r16)
NEXT_P2;
}

LABEL(iload_r17) /* iload_r17 ( -- ir) */
/*  */
NAME("iload_r17")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r17)
NEXT_P2;
}

LABEL(iload_r18) /* iload_r18 ( -- ir) */
/*  */
NAME("iload_r18")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r18)
NEXT_P2;
}

LABEL(iload_r19) /* iload_r19 ( -- ir) */
/*  */
NAME("iload_r19")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r19)
NEXT_P2;
}

LABEL(iload_r20) /* iload_r20 ( -- ir) */
/*  */
NAME("iload_r20")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r20)
NEXT_P2;
}

LABEL(iload_r21) /* iload_r21 ( -- ir) */
/*  */
NAME("iload_r21")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r21)
NEXT_P2;
}

LABEL(iload_r22) /* iload_r22 ( -- ir) */
/*  */
NAME("iload_r22")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r22)
NEXT_P2;
}

LABEL(iload_r23) /* iload_r23 ( -- ir) */
/*  */
NAME("iload_r23")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload_r23)
NEXT_P2;
}

LABEL(istore_r0) /* istore_r0 ( i1 -- ) */
/*  */
NAME("istore_r0")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
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
LABEL2(istore_r0)
NEXT_P2;
}

LABEL(istore_r1) /* istore_r1 ( i1 -- ) */
/*  */
NAME("istore_r1")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
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
LABEL2(istore_r1)
NEXT_P2;
}

LABEL(istore_r2) /* istore_r2 ( i1 -- ) */
/*  */
NAME("istore_r2")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
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
LABEL2(istore_r2)
NEXT_P2;
}

LABEL(istore_r3) /* istore_r3 ( i1 -- ) */
/*  */
NAME("istore_r3")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
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
LABEL2(istore_r3)
NEXT_P2;
}

LABEL(sipush_r0) /* sipush_r0 ( -- ir) */
/*  */
NAME("sipush_r0")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r0)
NEXT_P2;
}

LABEL(sipush_r1) /* sipush_r1 ( -- ir) */
/*  */
NAME("sipush_r1")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r1)
NEXT_P2;
}

LABEL(sipush_r2) /* sipush_r2 ( -- ir) */
/*  */
NAME("sipush_r2")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r2)
NEXT_P2;
}

LABEL(sipush_r3) /* sipush_r3 ( -- ir) */
/*  */
NAME("sipush_r3")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r3)
NEXT_P2;
}

LABEL(sipush_r4) /* sipush_r4 ( -- ir) */
/*  */
NAME("sipush_r4")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r4)
NEXT_P2;
}

LABEL(sipush_r5) /* sipush_r5 ( -- ir) */
/*  */
NAME("sipush_r5")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r5)
NEXT_P2;
}

LABEL(sipush_r6) /* sipush_r6 ( -- ir) */
/*  */
NAME("sipush_r6")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r6)
NEXT_P2;
}

LABEL(sipush_r7) /* sipush_r7 ( -- ir) */
/*  */
NAME("sipush_r7")
{
DEF_CA
fisce_uint ir;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush_r7)
NEXT_P2;
}

LABEL(iinc_r0) /* iinc_r0 ( -- ) */
/*  */
NAME("iinc_r0")
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
LABEL2(iinc_r0)
NEXT_P2;
}

LABEL(iinc_r1) /* iinc_r1 ( -- ) */
/*  */
NAME("iinc_r1")
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
LABEL2(iinc_r1)
NEXT_P2;
}

LABEL(iinc_r2) /* iinc_r2 ( -- ) */
/*  */
NAME("iinc_r2")
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
LABEL2(iinc_r2)
NEXT_P2;
}

LABEL(iinc_r3) /* iinc_r3 ( -- ) */
/*  */
NAME("iinc_r3")
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
LABEL2(iinc_r3)
NEXT_P2;
}

LABEL(iadd_r0) /* iadd_r0 ( i1 i2 -- ir) */
/*  */
NAME("iadd_r0")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iadd_r0)
NEXT_P2;
}

LABEL(iadd_r1) /* iadd_r1 ( i1 i2 -- ir) */
/*  */
NAME("iadd_r1")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iadd_r1)
NEXT_P2;
}

LABEL(iadd_r2) /* iadd_r2 ( i1 i2 -- ir) */
/*  */
NAME("iadd_r2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iadd_r2)
NEXT_P2;
}

LABEL(fadd_r0) /* fadd_r0 ( f1 f2 -- fr) */
/*  */
NAME("fadd_r0")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fadd_r0)
NEXT_P2;
}

LABEL(fadd_r1) /* fadd_r1 ( f1 f2 -- fr) */
/*  */
NAME("fadd_r1")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fadd_r1)
NEXT_P2;
}

LABEL(fadd_r2) /* fadd_r2 ( f1 f2 -- fr) */
/*  */
NAME("fadd_r2")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fadd_r2)
NEXT_P2;
}

LABEL(getfield_n_r0) /* getfield_n_r0 ( i1 -- ir) */
/*  */
NAME("getfield_n_r0")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r0)
NEXT_P2;
}

LABEL(getfield_n_r1) /* getfield_n_r1 ( i1 -- ir) */
/*  */
NAME("getfield_n_r1")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r1)
NEXT_P2;
}

LABEL(getfield_n_r2) /* getfield_n_r2 ( i1 -- ir) */
/*  */
NAME("getfield_n_r2")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r2)
NEXT_P2;
}

LABEL(getfield_n_r3) /* getfield_n_r3 ( i1 -- ir) */
/*  */
NAME("getfield_n_r3")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r3)
NEXT_P2;
}

LABEL(getfield_n_r4) /* getfield_n_r4 ( i1 -- ir) */
/*  */
NAME("getfield_n_r4")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r4)
NEXT_P2;
}

LABEL(getfield_n_r5) /* getfield_n_r5 ( i1 -- ir) */
/*  */
NAME("getfield_n_r5")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r5)
NEXT_P2;
}

LABEL(getfield_n_r6) /* getfield_n_r6 ( i1 -- ir) */
/*  */
NAME("getfield_n_r6")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r6)
NEXT_P2;
}

LABEL(getfield_n_r7) /* getfield_n_r7 ( i1 -- ir) */
/*  */
NAME("getfield_n_r7")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield_n_r7)
NEXT_P2;
}

LABEL(putfield_n_r0) /* putfield_n_r0 ( i1 i2 --) */
/*  */
NAME("putfield_n_r0")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1) = i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putfield_n_r0)
NEXT_P2;
}

LABEL(putfield_n_r1) /* putfield_n_r1 ( i1 i2 --) */
/*  */
NAME("putfield_n_r1")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1) = i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putfield_n_r1)
NEXT_P2;
}

LABEL(putfield_n_r2) /* putfield_n_r2 ( i1 i2 --) */
/*  */
NAME("putfield_n_r2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1) = i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putfield_n_r2)
NEXT_P2;
}

LABEL(putfield_n_r3) /* putfield_n_r3 ( i1 i2 --) */
/*  */
NAME("putfield_n_r3")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1) = i2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putfield_n_r3)
NEXT_P2;
}

LABEL(iaload_r0) /* iaload_r0 ( i1 i2 -- ir) */
/*  */
NAME("iaload_r0")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  ir = fy_heapValue(context, i1, i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload_r0)
NEXT_P2;
}

LABEL(iaload_r1) /* iaload_r1 ( i1 i2 -- ir) */
/*  */
NAME("iaload_r1")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  ir = fy_heapValue(context, i1, i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload_r1)
NEXT_P2;
}

LABEL(iaload_r2) /* iaload_r2 ( i1 i2 -- ir) */
/*  */
NAME("iaload_r2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  ir = fy_heapValue(context, i1, i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload_r2)
NEXT_P2;
}

LABEL(iaload_r3) /* iaload_r3 ( i1 i2 -- ir) */
/*  */
NAME("iaload_r3")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  ir = fy_heapValue(context, i1, i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload_r3)
NEXT_P2;
}

LABEL(iaload_r4) /* iaload_r4 ( i1 i2 -- ir) */
/*  */
NAME("iaload_r4")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  ir = fy_heapValue(context, i1, i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload_r4)
NEXT_P2;
}

LABEL(iaload_r5) /* iaload_r5 ( i1 i2 -- ir) */
/*  */
NAME("iaload_r5")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  ir = fy_heapValue(context, i1, i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload_r5)
NEXT_P2;
}

LABEL(iastore_r0) /* iastore_r0 ( i1 i2 i3 -- ) */
/*  */
NAME("iastore_r0")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  fy_heapValue(context, i1, i2) = i3;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(iastore_r0)
NEXT_P2;
}

LABEL(iastore_r1) /* iastore_r1 ( i1 i2 i3 -- ) */
/*  */
NAME("iastore_r1")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  fy_heapValue(context, i1, i2) = i3;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(iastore_r1)
NEXT_P2;
}

LABEL(iastore_r2) /* iastore_r2 ( i1 i2 i3 -- ) */
/*  */
NAME("iastore_r2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  if(unlikely(i2 < 0 || i2 >= fy_heapArrayLengthFast(context, i1))){
    ops = i2;
    goto label_throw_aioob;
  }
  fy_heapValue(context, i1, i2) = i3;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(iastore_r2)
NEXT_P2;
}

LABEL(getstatic_n_r0) /* getstatic_n_r0 ( -- ir) */
/*  */
NAME("getstatic_n_r0")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.isfield[0];
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic_n_r0)
NEXT_P2;
}

LABEL(getstatic_n_r1) /* getstatic_n_r1 ( -- ir) */
/*  */
NAME("getstatic_n_r1")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.isfield[0];
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic_n_r1)
NEXT_P2;
}

LABEL(getstatic_n_r2) /* getstatic_n_r2 ( -- ir) */
/*  */
NAME("getstatic_n_r2")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.isfield[0];
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic_n_r2)
NEXT_P2;
}

LABEL(getstatic_n_r3) /* getstatic_n_r3 ( -- ir) */
/*  */
NAME("getstatic_n_r3")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.isfield[0];
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic_n_r3)
NEXT_P2;
}

LABEL(getstatic_n_r4) /* getstatic_n_r4 ( -- ir) */
/*  */
NAME("getstatic_n_r4")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.isfield[0];
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic_n_r4)
NEXT_P2;
}

LABEL(getstatic_n_r5) /* getstatic_n_r5 ( -- ir) */
/*  */
NAME("getstatic_n_r5")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  ir = CURR_INST.params.isfield[0];
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic_n_r5)
NEXT_P2;
}

LABEL(putstatic_n_r0) /* putstatic_n_r0 ( i1 -- ) */
/*  */
NAME("putstatic_n_r0")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  CURR_INST.params.isfield[0] = i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putstatic_n_r0)
NEXT_P2;
}

LABEL(putstatic_n_r1) /* putstatic_n_r1 ( i1 -- ) */
/*  */
NAME("putstatic_n_r1")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  CURR_INST.params.isfield[0] = i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putstatic_n_r1)
NEXT_P2;
}

LABEL(putstatic_n_r2) /* putstatic_n_r2 ( i1 -- ) */
/*  */
NAME("putstatic_n_r2")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  CURR_INST.params.isfield[0] = i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putstatic_n_r2)
NEXT_P2;
}

LABEL(putstatic_n_r3) /* putstatic_n_r3 ( i1 -- ) */
/*  */
NAME("putstatic_n_r3")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  CURR_INST.params.isfield[0] = i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
IF_sppTOS(sppTOS = spp[-1]);
LABEL2(putstatic_n_r3)
NEXT_P2;
}

LABEL(nop_r0) /* nop_r0 ( -- ) */
/*  */
NAME("nop_r0")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{

}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(nop_r0)
NEXT_P2;
}

LABEL(nop_r1) /* nop_r1 ( -- ) */
/*  */
NAME("nop_r1")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{

}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(nop_r1)
NEXT_P2;
}

LABEL(nop_r2) /* nop_r2 ( -- ) */
/*  */
NAME("nop_r2")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{

}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(nop_r2)
NEXT_P2;
}

LABEL(slpush) /* slpush ( -- ir1 ir2) */
/*  */
NAME("slpush")
{
DEF_CA
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 2;
{

{
  ir1 = CURR_INST.params.int_params.param1;
  ir2 = CURR_INST.params.int_params.param2;
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(slpush)
NEXT_P2;
}

LABEL(dup) /* dup ( i1 -- ir1 ir2) */
/*  */
NAME("dup")
{
DEF_CA
fisce_uint i1;
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(dup)
NEXT_P2;
}

LABEL(isub) /* isub ( i1 i2 -- ir) */
/*  */
NAME("isub")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(isub)
NEXT_P2;
}

LABEL(imul) /* imul ( i1 i2 -- ir) */
/*  */
NAME("imul")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = (fisce_uint)((fisce_int)i1 * (fisce_int)i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(imul)
NEXT_P2;
}

LABEL(idiv) /* idiv ( i1 i2 -- ir) */
/*  */
NAME("idiv")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i2 == 0)){
    goto label_throw_dbz;
  } else {
    ir = ((fisce_int)i1) / ((fisce_int)i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(idiv)
NEXT_P2;
}

LABEL(irem) /* irem ( i1 i2 -- ir) */
/*  */
NAME("irem")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  if(unlikely(i2 == 0)){
    goto label_throw_dbz;
  } else {
    ir = ((fisce_int)i1) % ((fisce_int)i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(irem)
NEXT_P2;
}

LABEL(ineg) /* ineg ( i1 -- ir) */
/*  */
NAME("ineg")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(ineg)
NEXT_P2;
}

LABEL(iand) /* iand ( i1 i2 -- ir) */
/*  */
NAME("iand")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iand)
NEXT_P2;
}

LABEL(ior) /* ior ( i1 i2 -- ir) */
/*  */
NAME("ior")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(ior)
NEXT_P2;
}

LABEL(ixor) /* ixor ( i1 i2 -- ir) */
/*  */
NAME("ixor")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(ixor)
NEXT_P2;
}

LABEL(ishl) /* ishl ( i1 i2 -- ir) */
/*  */
NAME("ishl")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(ishl)
NEXT_P2;
}

LABEL(ishr) /* ishr ( i1 i2 -- ir) */
/*  */
NAME("ishr")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  ir = ((fisce_int)i1) >> ((fisce_int)i2);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(ishr)
NEXT_P2;
}

LABEL(iushr) /* iushr ( i1 i2 -- ir) */
/*  */
NAME("iushr")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iushr)
NEXT_P2;
}

LABEL(fsub) /* fsub ( f1 f2 -- fr) */
/*  */
NAME("fsub")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fsub)
NEXT_P2;
}

LABEL(fmul) /* fmul ( f1 f2 -- fr) */
/*  */
NAME("fmul")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fmul)
NEXT_P2;
}

LABEL(fdiv) /* fdiv ( f1 f2 -- fr) */
/*  */
NAME("fdiv")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fdiv)
NEXT_P2;
}

LABEL(frem) /* frem ( f1 f2 -- fr) */
/*  */
NAME("frem")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(frem)
NEXT_P2;
}

LABEL(fneg) /* fneg ( f1 -- fr) */
/*  */
NAME("fneg")
{
DEF_CA
fisce_float f1;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(sppTOS,f1);
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
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fneg)
NEXT_P2;
}

LABEL(fcmpg) /* fcmpg ( f1 f2 -- ir) */
/*  */
NAME("fcmpg")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(fcmpg)
NEXT_P2;
}

LABEL(fcmpl) /* fcmpl ( f1 f2 -- ir) */
/*  */
NAME("fcmpl")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(fcmpl)
NEXT_P2;
}

LABEL(dup_x1) /* dup_x1 ( i1 i2 -- ir1 ir2 ir3) */
/*  */
NAME("dup_x1")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir1;
fisce_uint ir2;
fisce_uint ir3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir1,spp[-3]);
vm_i2fisce_stack_item(ir2,spp[-2]);
vm_i2fisce_stack_item(ir3,sppTOS);
LABEL2(dup_x1)
NEXT_P2;
}

LABEL(dup_x2) /* dup_x2 ( i1 i2 i3 -- ir1 ir2 ir3 ir4) */
/*  */
NAME("dup_x2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
fisce_uint ir1;
fisce_uint ir2;
fisce_uint ir3;
fisce_uint ir4;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
vm_i2fisce_stack_item(ir1,spp[-4]);
vm_i2fisce_stack_item(ir2,spp[-3]);
vm_i2fisce_stack_item(ir3,spp[-2]);
vm_i2fisce_stack_item(ir4,sppTOS);
LABEL2(dup_x2)
NEXT_P2;
}

LABEL(dup2) /* dup2 ( i1 i2 -- ir1 ir2 ir3 ir4) */
/*  */
NAME("dup2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir1;
fisce_uint ir2;
fisce_uint ir3;
fisce_uint ir4;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir1,spp[-4]);
vm_i2fisce_stack_item(ir2,spp[-3]);
vm_i2fisce_stack_item(ir3,spp[-2]);
vm_i2fisce_stack_item(ir4,sppTOS);
LABEL2(dup2)
NEXT_P2;
}

LABEL(dup2_x1) /* dup2_x1 ( i1 i2 i3 -- ir1 ir2 ir3 ir4 ir5) */
/*  */
NAME("dup2_x1")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
fisce_uint ir1;
fisce_uint ir2;
fisce_uint ir3;
fisce_uint ir4;
fisce_uint ir5;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
vm_i2fisce_stack_item(ir1,spp[-5]);
vm_i2fisce_stack_item(ir2,spp[-4]);
vm_i2fisce_stack_item(ir3,spp[-3]);
vm_i2fisce_stack_item(ir4,spp[-2]);
vm_i2fisce_stack_item(ir5,sppTOS);
LABEL2(dup2_x1)
NEXT_P2;
}

LABEL(dup2_x2) /* dup2_x2 ( i1 i2 i3 i4 -- ir1 ir2 ir3 ir4 ir5 ir6) */
/*  */
NAME("dup2_x2")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
fisce_uint i4;
fisce_uint ir1;
fisce_uint ir2;
fisce_uint ir3;
fisce_uint ir4;
fisce_uint ir5;
fisce_uint ir6;
NEXT_P0;
vm_fisce_stack_item2i(spp[-4],i1);
vm_fisce_stack_item2i(spp[-3],i2);
vm_fisce_stack_item2i(spp[-2],i3);
vm_fisce_stack_item2i(sppTOS,i4);
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
vm_i2fisce_stack_item(ir1,spp[-6]);
vm_i2fisce_stack_item(ir2,spp[-5]);
vm_i2fisce_stack_item(ir3,spp[-4]);
vm_i2fisce_stack_item(ir4,spp[-3]);
vm_i2fisce_stack_item(ir5,spp[-2]);
vm_i2fisce_stack_item(ir6,sppTOS);
LABEL2(dup2_x2)
NEXT_P2;
}

LABEL(swap) /* swap ( i1 i2 -- ir1 ir2) */
/*  */
NAME("swap")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(swap)
NEXT_P2;
}

LABEL(d2f) /* d2f ( d1 -- fr) */
/*  */
NAME("d2f")
{
DEF_CA
fisce_double d1;
fisce_float fr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-2], sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
spp += -1;
{

{
  fr = (fisce_float)d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(d2f)
NEXT_P2;
}

LABEL(d2i) /* d2i ( d1 -- ir) */
/*  */
NAME("d2i")
{
DEF_CA
fisce_double d1;
fisce_uint ir;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-2], sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
spp += -1;
{

{
  ir = (fisce_int)d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(d2i)
NEXT_P2;
}

LABEL(d2l) /* d2l ( d1 -- lr) */
/*  */
NAME("d2l")
{
DEF_CA
fisce_double d1;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-2], sppTOS, d1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" d1=", vm_out); printarg_d(d1);
}
#endif
{

{
  lr = (fisce_long)d1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(d2l)
NEXT_P2;
}

LABEL(f2d) /* f2d ( f1 -- dr) */
/*  */
NAME("f2d")
{
DEF_CA
fisce_float f1;
fisce_double dr;
NEXT_P0;
vm_fisce_stack_item2f(sppTOS,f1);
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(f2d)
NEXT_P2;
}

LABEL(f2i) /* f2i ( f1 -- ir) */
/*  */
NAME("f2i")
{
DEF_CA
fisce_float f1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2f(sppTOS,f1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
}
#endif
{

{
  ir = (fisce_int)f1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(f2i)
NEXT_P2;
}

LABEL(f2l) /* f2l ( f1 -- lr) */
/*  */
NAME("f2l")
{
DEF_CA
fisce_float f1;
fisce_ulong lr;
NEXT_P0;
vm_fisce_stack_item2f(sppTOS,f1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" f1=", vm_out); printarg_f(f1);
}
#endif
spp += 1;
{

{
  lr = (fisce_long)f1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(f2l)
NEXT_P2;
}

LABEL(i2b) /* i2b ( i1 -- ir) */
/*  */
NAME("i2b")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = (fisce_byte)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(i2b)
NEXT_P2;
}

LABEL(i2c) /* i2c ( i1 -- ir) */
/*  */
NAME("i2c")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(i2c)
NEXT_P2;
}

LABEL(i2d) /* i2d ( i1 -- dr) */
/*  */
NAME("i2d")
{
DEF_CA
fisce_uint i1;
fisce_double dr;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
  dr = (fisce_int)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(i2d)
NEXT_P2;
}

LABEL(i2f) /* i2f ( i1 -- fr) */
/*  */
NAME("i2f")
{
DEF_CA
fisce_uint i1;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  fr = (fisce_int)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(i2f)
NEXT_P2;
}

LABEL(i2l) /* i2l ( i1 -- lr) */
/*  */
NAME("i2l")
{
DEF_CA
fisce_uint i1;
fisce_ulong lr;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
  lr = (fisce_int)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(i2l)
NEXT_P2;
}

LABEL(i2s) /* i2s ( i1 -- ir) */
/*  */
NAME("i2s")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = (fisce_short)i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(i2s)
NEXT_P2;
}

LABEL(l2d) /* l2d ( l1 -- dr) */
/*  */
NAME("l2d")
{
DEF_CA
fisce_ulong l1;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-2], sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
{

{
  dr = (fisce_long)l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" dr=", vm_out); printarg_d(dr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(l2d)
NEXT_P2;
}

LABEL(l2f) /* l2f ( l1 -- fr) */
/*  */
NAME("l2f")
{
DEF_CA
fisce_ulong l1;
fisce_float fr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-2], sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -1;
{

{
  fr = (fisce_long)l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(l2f)
NEXT_P2;
}

LABEL(l2i) /* l2i ( l1 -- ir) */
/*  */
NAME("l2i")
{
DEF_CA
fisce_ulong l1;
fisce_uint ir;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-2], sppTOS, l1)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
}
#endif
spp += -1;
{

{
  ir = (fisce_uint)l1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(l2i)
NEXT_P2;
}

LABEL(lload) /* lload ( -- lr) */
/*  */
NAME("lload")
{
DEF_CA
fisce_ulong lr;
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
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lload)
NEXT_P2;
}

LABEL(lstore) /* lstore ( l1 -- ) */
/*  */
NAME("lstore")
{
DEF_CA
fisce_ulong l1;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-2], sppTOS, l1)
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

LABEL(ladd) /* ladd ( l1 l2 -- lr) */
/*  */
NAME("ladd")
{
DEF_CA
fisce_ulong l1;
fisce_ulong l2;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-4], spp[-3], l1)
vm_twofisce_stack_item2l(spp[-2], sppTOS, l2)
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
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(ladd)
NEXT_P2;
}

LABEL(lsub) /* lsub ( l1 l2 -- lr) */
/*  */
NAME("lsub")
{
DEF_CA
fisce_ulong l1;
fisce_ulong l2;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-4], spp[-3], l1)
vm_twofisce_stack_item2l(spp[-2], sppTOS, l2)
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
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lsub)
NEXT_P2;
}

LABEL(lmul) /* lmul ( l1 l2 -- lr) */
/*  */
NAME("lmul")
{
DEF_CA
fisce_ulong l1;
fisce_ulong l2;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-4], spp[-3], l1)
vm_twofisce_stack_item2l(spp[-2], sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -2;
{

{
  lr = (fisce_long) l1 * (fisce_long) l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lmul)
NEXT_P2;
}

LABEL(ldiv) /* ldiv ( l1 l2 -- lr) */
/*  */
NAME("ldiv")
{
DEF_CA
fisce_ulong l1;
fisce_ulong l2;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-4], spp[-3], l1)
vm_twofisce_stack_item2l(spp[-2], sppTOS, l2)
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
    goto label_throw_dbz;
  }
  lr = (fisce_long) l1 / (fisce_long) l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(ldiv)
NEXT_P2;
}

LABEL(lrem) /* lrem ( l1 l2 -- lr) */
/*  */
NAME("lrem")
{
DEF_CA
fisce_ulong l1;
fisce_ulong l2;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-4], spp[-3], l1)
vm_twofisce_stack_item2l(spp[-2], sppTOS, l2)
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
    goto label_throw_dbz;
  }
  lr = (fisce_long) l1 % (fisce_long) l2;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lrem)
NEXT_P2;
}

LABEL(lneg) /* lneg ( l1 -- lr) */
/*  */
NAME("lneg")
{
DEF_CA
fisce_ulong l1;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-2], sppTOS, l1)
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
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lneg)
NEXT_P2;
}

LABEL(land) /* land ( i1 i2 i3 i4 -- ir1 ir2) */
/*  */
NAME("land")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
fisce_uint i4;
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-4],i1);
vm_fisce_stack_item2i(spp[-3],i2);
vm_fisce_stack_item2i(spp[-2],i3);
vm_fisce_stack_item2i(sppTOS,i4);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
fputs(" i4=", vm_out); printarg_i(i4);
}
#endif
spp += -2;
{

{
  ir1 = i1 & i3;
  ir2 = i2 & i4;
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(land)
NEXT_P2;
}

LABEL(lor) /* lor ( i1 i2 i3 i4 -- ir1 ir2) */
/*  */
NAME("lor")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
fisce_uint i4;
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-4],i1);
vm_fisce_stack_item2i(spp[-3],i2);
vm_fisce_stack_item2i(spp[-2],i3);
vm_fisce_stack_item2i(sppTOS,i4);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
fputs(" i4=", vm_out); printarg_i(i4);
}
#endif
spp += -2;
{

{
  ir1 = i1 | i3;
  ir2 = i2 | i4;
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(lor)
NEXT_P2;
}

LABEL(lxor) /* lxor ( i1 i2 i3 i4 -- ir1 ir2) */
/*  */
NAME("lxor")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
fisce_uint i4;
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-4],i1);
vm_fisce_stack_item2i(spp[-3],i2);
vm_fisce_stack_item2i(spp[-2],i3);
vm_fisce_stack_item2i(sppTOS,i4);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
fputs(" i3=", vm_out); printarg_i(i3);
fputs(" i4=", vm_out); printarg_i(i4);
}
#endif
spp += -2;
{

{
  ir1 = i1 ^ i3;
  ir2 = i2 ^ i4;
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(lxor)
NEXT_P2;
}

LABEL(lcmp) /* lcmp ( l1 l2 -- ir) */
/*  */
NAME("lcmp")
{
DEF_CA
fisce_ulong l1;
fisce_ulong l2;
fisce_uint ir;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-4], spp[-3], l1)
vm_twofisce_stack_item2l(spp[-2], sppTOS, l2)
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" l2=", vm_out); printarg_l(l2);
}
#endif
spp += -3;
{

{
  ir = l1 == l2 ? 0 : ((fisce_long)l1 > (fisce_long)l2 ? 1 : -1) ;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(lcmp)
NEXT_P2;
}

LABEL(lshl) /* lshl ( l1 i1 -- lr) */
/*  */
NAME("lshl")
{
DEF_CA
fisce_ulong l1;
fisce_uint i1;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-3], spp[-2], l1)
vm_fisce_stack_item2i(sppTOS,i1);
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
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lshl)
NEXT_P2;
}

LABEL(lshr) /* lshr ( l1 i1 -- lr) */
/*  */
NAME("lshr")
{
DEF_CA
fisce_ulong l1;
fisce_uint i1;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-3], spp[-2], l1)
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" l1=", vm_out); printarg_l(l1);
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  lr = ((fisce_long)l1) >> i1;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lshr)
NEXT_P2;
}

LABEL(lushr) /* lushr ( l1 i1 -- lr) */
/*  */
NAME("lushr")
{
DEF_CA
fisce_ulong l1;
fisce_uint i1;
fisce_ulong lr;
NEXT_P0;
vm_twofisce_stack_item2l(spp[-3], spp[-2], l1)
vm_fisce_stack_item2i(sppTOS,i1);
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
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(lushr)
NEXT_P2;
}

LABEL(arraylength) /* arraylength ( i1 -- ir) */
/*  */
NAME("arraylength")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  ir = fy_heapArrayLength(context, i1, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(arraylength)
NEXT_P2;
}

LABEL(baload) /* baload ( i1 i2 -- ir) */
/*  */
NAME("baload")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(baload)
NEXT_P2;
}

LABEL(bastore) /* bastore ( i1 i2 i3 -- ) */
/*  */
NAME("bastore")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  fy_heapPutArrayByte(context, i1, i2, (fisce_byte) i3, exception);
  FY_THEH(;)
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
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(caload)
NEXT_P2;
}

LABEL(castore) /* castore ( i1 i2 i3 -- ) */
/*  */
NAME("castore")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  fy_heapPutArrayChar(context, i1, i2, (fisce_char) i3, exception);
  FY_THEH(;)
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
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(saload)
NEXT_P2;
}

LABEL(sastore) /* sastore ( i1 i2 i3 -- ) */
/*  */
NAME("sastore")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  fy_heapPutArrayShort(context, i1, i2, (fisce_short) i3, exception);
  FY_THEH(;)
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

LABEL(laload) /* laload ( i1 i2 -- lr) */
/*  */
NAME("laload")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_ulong lr;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
{

{
  lr = fy_heapGetArrayLong(context, i1, i2, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(laload)
NEXT_P2;
}

LABEL(lastore) /* lastore ( i1 i2 l1 -- ) */
/*  */
NAME("lastore")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_ulong l1;
NEXT_P0;
vm_fisce_stack_item2i(spp[-4],i1);
vm_fisce_stack_item2i(spp[-3],i2);
vm_twofisce_stack_item2l(spp[-2], sppTOS, l1)
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
  FY_THEH(;)
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
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  fy_localToFrame(context, frame);
  ir = fy_heapAllocateArrayWithContentType(context, CURR_INST.params.clazz, i1, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(anewarray)
NEXT_P2;
}

LABEL(multianewarray) /* multianewarray ( -- ir) */
/*  */
NAME("multianewarray")
{
DEF_CA
fisce_uint ir;
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
  fy_localToFrame(context, frame);
  clazz1 = fy_vmLookupClassFromConstant(context, (ConstantClass*) method->owner->constantPools[CURR_INST.params.int_params.param1], exception);
  FY_THEH(;)
  spp -= CURR_INST.params.int_params.param2;
#ifdef VM_DEBUG
  if(vm_debug){
# ifdef FY_LATE_DECLARATION
    fisce_int i1;
# endif
    fputc(' ', vm_out);
    for(i1 = 0; i1 < CURR_INST.params.int_params.param2; i1 ++){
      fprintf(vm_out, "[%"FY_PRINT32"d]", spp[i1].ivalue);
    }
    fputc(' ', vm_out);
  }
#endif
  fy_heapBeginProtect(context);
  ir = fy_heapMultiArray(context, clazz1, CURR_INST.params.int_params.param2, fisce_stack_item2iarray(spp - 1),
      exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(multianewarray)
NEXT_P2;
}

LABEL(new) /* new ( -- ir) */
/*  */
NAME("new")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  fy_localToFrame(context, frame);
  ir = fy_heapAllocate(context, CURR_INST.params.clazz, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(new)
NEXT_P2;
}

LABEL(newarray) /* newarray ( i1 -- ir) */
/*  */
NAME("newarray")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
  if (unlikely(((fisce_int) i1) < 0)) {
    ops = i1;
    goto label_throw_nase;
  }
  fy_localToFrame(context, frame);
  ir = fy_heapAllocateArray(context, CURR_INST.params.clazz, i1, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(newarray)
NEXT_P2;
}

LABEL(getfield_x) /* getfield_x ( i1 -- ir1 ir2) */
/*  */
NAME("getfield_x")
{
DEF_CA
fisce_uint i1;
fisce_uint ir1;
fisce_uint ir2;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += 1;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getfield #%"FY_PRINT32"d(%"FY_PRINT32"d)# ", i1, CURR_INST.params.int_params.param1);
  }
#endif
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir1 = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
  ir2 = fy_heapValue(context, i1, CURR_INST.params.int_params.param1 + 1);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #value=%"FY_PRINT64"d# ", fy_I2TOL(ir1, ir2));
  }
#endif
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(getfield_x)
NEXT_P2;
}

LABEL(putfield_x) /* putfield_x ( i1 i2 i3 --) */
/*  */
NAME("putfield_x")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putfield #%"FY_PRINT32"d(%"FY_PRINT32"d) value=%"FY_PRINT64"d# ", i1, CURR_INST.params.int_params.param1, fy_I2TOL(i2, i3));
  }
#endif
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1) = i2;
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1 + 1) = i3;
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

LABEL(getstatic_x) /* getstatic_x ( -- ir1 ir2) */
/*  */
NAME("getstatic_x")
{
DEF_CA
fisce_uint ir1;
fisce_uint ir2;
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
    fprintf(vm_out, " #getstatic %p# ", CURR_INST.params.isfield);
  }
#endif
  ir1 = CURR_INST.params.isfield[0];
  ir2 = CURR_INST.params.isfield[1];
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %p value = %"FY_PRINT64"d# ", CURR_INST.params.isfield, fy_I2TOL(ir1, ir2));
  }
#endif
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
vm_i2fisce_stack_item(ir1,spp[-2]);
vm_i2fisce_stack_item(ir2,sppTOS);
LABEL2(getstatic_x)
NEXT_P2;
}

LABEL(putstatic_x) /* putstatic_x ( i1 i2 -- ) */
/*  */
NAME("putstatic_x")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putstatic %p value=%"FY_PRINT64"d# ", CURR_INST.params.isfield, fy_I2TOL(i1, i2));
  }
#endif
  CURR_INST.params.isfield[0] = i1;
  CURR_INST.params.isfield[1] = i2;
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

LABEL(checkcast) /* checkcast ( -- ) */
/*  */
NAME("checkcast")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_heapCheckCast(context, sppTOS.ivalue, CURR_INST.params.clazz, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(checkcast)
NEXT_P2;
}

LABEL(instanceof) /* instanceof ( i1 -- ir) */
/*  */
NAME("instanceof")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
#ifdef FY_LATE_DECLARATION
  fy_class *clazz1;
#endif

  if(i1 == 0){
    ir = 0;
  } else {
    clazz1 = fy_heapGetClassOfObject(context, i1, exception);
    FY_THEH(;)
    ir = fy_classCanCastTo(context, clazz1, CURR_INST.params.clazz, TRUE) ? 1 : 0;
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(instanceof)
NEXT_P2;
}

LABEL(monitorenter) /* monitorenter ( i1 -- ) */
/*  */
NAME("monitorenter")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ops = fy_threadMonitorEnter(context, thread, i1, ops);
  FY_CHECK_OPS(ops);
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
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  fy_threadMonitorExit(context, thread, i1, exception);
  FY_THEH(;)
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

LABEL(invoke_d) /* invoke_d ( -- ) */
/*  */
NAME("invoke_d")
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
  ops = fy_threadPushMethod(context, thread, CURR_INST.params.invoke->n.nn.method, 
    spp - CURR_INST.params.invoke->n.nn.paramCount, ops - 1, exception);
  FYEH()0;
  if (unlikely(ops <= 0)) {
    FY_FALLOUT_INVOKE
  }
  ops = (*(CURR_INST.params.invoke->n.nn.method->engine->runner))(context, thread, frame - 1, ops, exception, NULL);
  FY_THEH(;);
  FY_CHECK_OPS_INVOKE(ops);
  FY_UPDATE_SP(context);
  SUPER_END;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invoke_d)
NEXT_P2;
}

LABEL(invoke_dn) /* invoke_dn ( -- ) */
/*  */
NAME("invoke_dn")
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
  fy_heapBeginProtect(context);
  ops = (CURR_INST.params.invoke->n.nh.handler)(context, thread, 
    CURR_INST.params.invoke->n.nh.data, 
    spp - CURR_INST.params.invoke->n.nh.stack_count, 
    CURR_INST.params.invoke->n.nh.stack_count, ops, exception);
  fy_heapEndProtect(context);
  FY_THEH(;);
  FY_CHECK_OPS_INVOKE(ops);
  FY_UPDATE_SP(context);
  SUPER_END;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invoke_dn)
NEXT_P2;
}

LABEL(invoke_dnp) /* invoke_dnp ( -- ) */
/*  */
NAME("invoke_dnp")
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
  thread->pendingNative = CURR_INST.params.invoke->n.pendingNative;
  thread->pendingNative.params = spp - CURR_INST.params.invoke->n.pendingNative.paramCount;
  ops = 0;
  FY_FALLOUT_INVOKE;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invoke_dnp)
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
  ops--;
  fy_localToFrame(context, frame);
  ops = fy_threadInvokeVirtual(context, thread, frame, CURR_INST.params.method, spp, ops, exception);
  FY_THEH(;);
  FY_CHECK_OPS_INVOKE(ops);
  FY_UPDATE_SP(context);
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

LABEL(return_sync) /* return_sync ( -- ) */
/*  */
NAME("return_sync")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_threadMonitorExit(context, thread, sbase->uvalue, exception);
  FY_THEH(;)
  FORWARD(return);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(return_sync)
NEXT_P2;
}

LABEL(return_sync_s) /* return_sync_s ( -- ) */
/*  */
NAME("return_sync_s")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_threadMonitorExit(context, thread, CURR_INST.params.int_params.param1, exception);
  FY_THEH(;)
  FORWARD(return);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(return_sync_s)
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

LABEL(ireturn_sync) /* ireturn_sync ( -- ) */
/*  */
NAME("ireturn_sync")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_threadMonitorExit(context, thread, sbase->uvalue, exception);
  FY_THEH(;)
  FORWARD(ireturn);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ireturn_sync)
NEXT_P2;
}

LABEL(ireturn_sync_s) /* ireturn_sync_s ( -- ) */
/*  */
NAME("ireturn_sync_s")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_threadMonitorExit(context, thread, CURR_INST.params.int_params.param1, exception);
  FY_THEH(;)
  FORWARD(ireturn);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ireturn_sync_s)
NEXT_P2;
}

LABEL(ireturn) /* ireturn ( i1 -- ) */
/*  */
NAME("ireturn")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  sbase[0].ivalue = i1;
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

LABEL(lreturn_sync) /* lreturn_sync ( -- ) */
/*  */
NAME("lreturn_sync")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_threadMonitorExit(context, thread, sbase->uvalue, exception);
  FY_THEH(;)
  FORWARD(lreturn);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(lreturn_sync)
NEXT_P2;
}

LABEL(lreturn_sync_s) /* lreturn_sync_s ( -- ) */
/*  */
NAME("lreturn_sync_s")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_threadMonitorExit(context, thread, CURR_INST.params.int_params.param1, exception);
  FY_THEH(;)
  FORWARD(lreturn);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(lreturn_sync_s)
NEXT_P2;
}

LABEL(lreturn) /* lreturn ( i1 i2 -- ) */
/*  */
NAME("lreturn")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  sbase[0].ivalue = i1;
  sbase[1].ivalue = i2;
  fy_threadPopFrame(context, thread);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #Return %"FY_PRINT64"d to %s @%d + %d# ",
      fy_I2TOL(i1, i2),
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
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  thread->currentThrowable = i1;
  ops = 0;
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

LABEL(goto_b) /* goto_b ( -- ) */
/*  */
NAME("goto_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  }
  FORWARD(goto);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(goto_b)
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
  ops--;
  FY_OP_GOTO;
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

LABEL(if_icmpeq_b) /* if_icmpeq_b ( -- ) */
/*  */
NAME("if_icmpeq_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(if_icmpeq);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(if_icmpeq_b)
NEXT_P2;
}

LABEL(if_icmpeq) /* if_icmpeq ( i1 i2 -- ) */
/*  */
NAME("if_icmpeq")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  ops--;
  if(i1 == i2){
    FY_OP_GOTO;
    
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

LABEL(if_icmpne_b) /* if_icmpne_b ( -- ) */
/*  */
NAME("if_icmpne_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(if_icmpne);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(if_icmpne_b)
NEXT_P2;
}

LABEL(if_icmpne) /* if_icmpne ( i1 i2 -- ) */
/*  */
NAME("if_icmpne")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  ops--;
  if(i1 != i2){
    FY_OP_GOTO;
    
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

LABEL(if_icmplt_b) /* if_icmplt_b ( -- ) */
/*  */
NAME("if_icmplt_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(if_icmplt);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(if_icmplt_b)
NEXT_P2;
}

LABEL(if_icmplt) /* if_icmplt ( i1 i2 -- ) */
/*  */
NAME("if_icmplt")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  ops--;
  if((fisce_int)i1 < (fisce_int)i2){
    FY_OP_GOTO;
    
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

LABEL(if_icmple_b) /* if_icmple_b ( -- ) */
/*  */
NAME("if_icmple_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(if_icmple);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(if_icmple_b)
NEXT_P2;
}

LABEL(if_icmple) /* if_icmple ( i1 i2 -- ) */
/*  */
NAME("if_icmple")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  ops--;
  if((fisce_int)i1 <= (fisce_int)i2){
    FY_OP_GOTO;
    
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

LABEL(if_icmpgt_b) /* if_icmpgt_b ( -- ) */
/*  */
NAME("if_icmpgt_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(if_icmpgt);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(if_icmpgt_b)
NEXT_P2;
}

LABEL(if_icmpgt) /* if_icmpgt ( i1 i2 -- ) */
/*  */
NAME("if_icmpgt")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  ops--;
  if((fisce_int)i1 > (fisce_int)i2){
    FY_OP_GOTO;
    
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

LABEL(if_icmpge_b) /* if_icmpge_b ( -- ) */
/*  */
NAME("if_icmpge_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(if_icmpge);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(if_icmpge_b)
NEXT_P2;
}

LABEL(if_icmpge) /* if_icmpge ( i1 i2 -- ) */
/*  */
NAME("if_icmpge")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
  ops--;
  if((fisce_int)i1 >= (fisce_int)i2){
    FY_OP_GOTO;
    
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

LABEL(ifeq_b) /* ifeq_b ( -- ) */
/*  */
NAME("ifeq_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifeq);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifeq_b)
NEXT_P2;
}

LABEL(ifeq) /* ifeq ( i1 -- ) */
/*  */
NAME("ifeq")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if(i1 == 0){
    FY_OP_GOTO;
    
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

LABEL(ifnull_b) /* ifnull_b ( -- ) */
/*  */
NAME("ifnull_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifnull);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifnull_b)
NEXT_P2;
}

LABEL(ifnull) /* ifnull ( i1 -- ) */
/*  */
NAME("ifnull")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if(i1 == 0){
    FY_OP_GOTO;
    
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

LABEL(ifne_b) /* ifne_b ( -- ) */
/*  */
NAME("ifne_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifne);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifne_b)
NEXT_P2;
}

LABEL(ifne) /* ifne ( i1 -- ) */
/*  */
NAME("ifne")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if(i1 != 0){
    FY_OP_GOTO;
    
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

LABEL(ifnonnull_b) /* ifnonnull_b ( -- ) */
/*  */
NAME("ifnonnull_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifnonnull);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifnonnull_b)
NEXT_P2;
}

LABEL(ifnonnull) /* ifnonnull ( i1 -- ) */
/*  */
NAME("ifnonnull")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if(i1 != 0){
    FY_OP_GOTO;
    
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

LABEL(iflt_b) /* iflt_b ( -- ) */
/*  */
NAME("iflt_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(iflt);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(iflt_b)
NEXT_P2;
}

LABEL(iflt) /* iflt ( i1 -- ) */
/*  */
NAME("iflt")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if((fisce_int)i1 < 0){
    FY_OP_GOTO;
    
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

LABEL(ifle_b) /* ifle_b ( -- ) */
/*  */
NAME("ifle_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifle);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifle_b)
NEXT_P2;
}

LABEL(ifle) /* ifle ( i1 -- ) */
/*  */
NAME("ifle")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if((fisce_int)i1 <= 0){
    FY_OP_GOTO;
    
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

LABEL(ifgt_b) /* ifgt_b ( -- ) */
/*  */
NAME("ifgt_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifgt);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifgt_b)
NEXT_P2;
}

LABEL(ifgt) /* ifgt ( i1 -- ) */
/*  */
NAME("ifgt")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if((fisce_int)i1 > 0){
    FY_OP_GOTO;
    
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

LABEL(ifge_b) /* ifge_b ( -- ) */
/*  */
NAME("ifge_b")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  if(unlikely(ops <= 0)){
    fy_localToFrame(context, frame);
    frame->pcofs = 0;
    FY_FALLOUT_INVOKE;
  } else {
    FORWARD(ifge);
  }
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(ifge_b)
NEXT_P2;
}

LABEL(ifge) /* ifge ( i1 -- ) */
/*  */
NAME("ifge")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  ops--;
  if((fisce_int)i1 >= 0){
    FY_OP_GOTO;
    
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
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fisce_uint i2, i3;
  fy_switch_lookup *swlookup;
#endif
  ops--;
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
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
#ifdef FY_LATE_DECLARATION
  fisce_uint i2, i3;
#endif
  ops--;
  i2 = CURR_INST.params.swtable->lowest;/*lb*/
  i3 = CURR_INST.params.swtable->highest;/*hb*/
  if ((fisce_int) i1 < (fisce_int) i2
      || (fisce_int) i1 > (fisce_int) i3) {
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

LABEL(pop) /* pop ( i1 -- ) */
/*  */
NAME("pop")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
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
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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

LABEL(dadd) /* dadd ( d1 d2 -- dr) */
/*  */
NAME("dadd")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(dadd)
NEXT_P2;
}

LABEL(dsub) /* dsub ( d1 d2 -- dr) */
/*  */
NAME("dsub")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(dsub)
NEXT_P2;
}

LABEL(ddiv) /* ddiv ( d1 d2 -- dr) */
/*  */
NAME("ddiv")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(ddiv)
NEXT_P2;
}

LABEL(dmul) /* dmul ( d1 d2 -- dr) */
/*  */
NAME("dmul")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(dmul)
NEXT_P2;
}

LABEL(drem) /* drem ( d1 d2 -- dr) */
/*  */
NAME("drem")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(drem)
NEXT_P2;
}

LABEL(dneg) /* dneg ( d1 -- dr) */
/*  */
NAME("dneg")
{
DEF_CA
fisce_double d1;
fisce_double dr;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-2], sppTOS, d1)
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
vm_d2twofisce_stack_item(dr, spp[-2], sppTOS)
LABEL2(dneg)
NEXT_P2;
}

LABEL(dcmpg) /* dcmpg ( d1 d2 -- ir) */
/*  */
NAME("dcmpg")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_uint ir;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(dcmpg)
NEXT_P2;
}

LABEL(dcmpl) /* dcmpl ( d1 d2 -- ir) */
/*  */
NAME("dcmpl")
{
DEF_CA
fisce_double d1;
fisce_double d2;
fisce_uint ir;
NEXT_P0;
vm_twofisce_stack_item2d(spp[-4], spp[-3], d1)
vm_twofisce_stack_item2d(spp[-2], sppTOS, d2)
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
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(dcmpl)
NEXT_P2;
}

LABEL(iload) /* iload ( -- ir) */
/*  */
NAME("iload")
{
DEF_CA
fisce_uint ir;
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
  RCAL(FY_OP_iload);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iload)
NEXT_P2;
}

LABEL(istore) /* istore ( i1 -- ) */
/*  */
NAME("istore")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
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
  RCAL(FY_OP_istore);
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

LABEL(sipush) /* sipush ( -- ir) */
/*  */
NAME("sipush")
{
DEF_CA
fisce_uint ir;
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
    fprintf(vm_out, " #sipush %"FY_PRINT32"d# ", CURR_INST.params.int_params.param1);
  }
#endif
  ir = CURR_INST.params.int_params.param1;
  RCAL(FY_OP_sipush);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(sipush)
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
  RCAL(FY_OP_iinc);
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

LABEL(iadd) /* iadd ( i1 i2 -- ir) */
/*  */
NAME("iadd")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
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
  RCAL(FY_OP_iadd);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iadd)
NEXT_P2;
}

LABEL(fadd) /* fadd ( f1 f2 -- fr) */
/*  */
NAME("fadd")
{
DEF_CA
fisce_float f1;
fisce_float f2;
fisce_float fr;
NEXT_P0;
vm_fisce_stack_item2f(spp[-2],f1);
vm_fisce_stack_item2f(sppTOS,f2);
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
  RCAL(FY_OP_fadd);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" fr=", vm_out); printarg_f(fr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_f2fisce_stack_item(fr,sppTOS);
LABEL2(fadd)
NEXT_P2;
}

LABEL(getfield) /* getfield ( i1 -- ir) */
/*  */
NAME("getfield")
{
DEF_CA
fisce_uint i1;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getfield #%"FY_PRINT32"d(#%"FY_PRINT32"d)# ", i1, CURR_INST.params.int_params.param1);
  }
#endif
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  ir = fy_heapValue(context, i1, CURR_INST.params.int_params.param1);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #value=%"FY_PRINT32"d# ", ir);
  }
#endif
  RCAL(FY_OP_getfield);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getfield)
NEXT_P2;
}

LABEL(putfield) /* putfield ( i1 i2 --) */
/*  */
NAME("putfield")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -2;
{

{
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putfield #%"FY_PRINT32"d(#%"FY_PRINT32"d) value=%"FY_PRINT32"d# ", i1, CURR_INST.params.int_params.param1, i2);
  }
#endif
  if(unlikely(i1 == 0)){
    goto lable_throw_npt;
  }
  fy_heapValue(context, i1, CURR_INST.params.int_params.param1) = i2;
  RCAL(FY_OP_putfield);
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

LABEL(iaload) /* iaload ( i1 i2 -- ir) */
/*  */
NAME("iaload")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint ir;
NEXT_P0;
vm_fisce_stack_item2i(spp[-2],i1);
vm_fisce_stack_item2i(sppTOS,i2);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
fputs(" i2=", vm_out); printarg_i(i2);
}
#endif
spp += -1;
{

{
  RCAL(FY_OP_iaload);
  ir = fy_heapGetArrayInt(context, i1, i2, exception);
  FY_THEH(;)
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(iaload)
NEXT_P2;
}

LABEL(iastore) /* iastore ( i1 i2 i3 -- ) */
/*  */
NAME("iastore")
{
DEF_CA
fisce_uint i1;
fisce_uint i2;
fisce_uint i3;
NEXT_P0;
vm_fisce_stack_item2i(spp[-3],i1);
vm_fisce_stack_item2i(spp[-2],i2);
vm_fisce_stack_item2i(sppTOS,i3);
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
  RCAL(FY_OP_iastore);
  fy_heapPutArrayInt(context, i1, i2, i3, exception);
  FY_THEH(;)
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

LABEL(getstatic) /* getstatic ( -- ir) */
/*  */
NAME("getstatic")
{
DEF_CA
fisce_uint ir;
NEXT_P0;
IF_sppTOS(spp[-1] = sppTOS);
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
spp += 1;
{

{
  getstatic_body:
  RCAL(FY_OP_getstatic);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %p# ", CURR_INST.params.isfield);
  }
#endif
  ir = CURR_INST.params.isfield[0];
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #getstatic %p value=%"FY_PRINT32"d# ", CURR_INST.params.isfield, ir);
  }
#endif
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(getstatic)
NEXT_P2;
}

LABEL(putstatic) /* putstatic ( i1 -- ) */
/*  */
NAME("putstatic")
{
DEF_CA
fisce_uint i1;
NEXT_P0;
vm_fisce_stack_item2i(sppTOS,i1);
#ifdef VM_DEBUG
if (vm_debug) {
fputs(" i1=", vm_out); printarg_i(i1);
}
#endif
spp += -1;
{

{
  putstatic_body:
  RCAL(FY_OP_putstatic);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, " #putstatic %p value=%"FY_PRINT32"d# ", CURR_INST.params.isfield, i1);
  }
#endif
  CURR_INST.params.isfield[0] = i1;
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

{
  RCAL(FY_OP_nop);
}

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

LABEL(ldc) /* ldc ( -- ir) */
/*  */
NAME("ldc")
{
DEF_CA
fisce_uint ir;
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
  FY_THEH(;)
  MODIFY_CURR_INST(sipush);
  CURR_INST.params.int_params.param1 = ir;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" ir=", vm_out); printarg_i(ir);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_i2fisce_stack_item(ir,sppTOS);
LABEL2(ldc)
NEXT_P2;
}

LABEL(ldc2_w) /* ldc2_w ( -- lr) */
/*  */
NAME("ldc2_w")
{
DEF_CA
fisce_ulong lr;
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
  FY_THEH(;)
  MODIFY_CURR_INST(slpush);
  CURR_INST.params.int_params.param1 = fy_HOFL(lr);
  CURR_INST.params.int_params.param2 = fy_LOFL(lr);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputs(" lr=", vm_out); printarg_l(lr);
fputc('\n', vm_out);
}
#endif
NEXT_P1;
vm_l2twofisce_stack_item(lr, spp[-2], sppTOS)
LABEL2(ldc2_w)
NEXT_P2;
}

LABEL(new_cl) /* new_cl ( -- ) */
/*  */
NAME("new_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.clazz, 0);
  MODIFY_CURR_INST(new);
  FORWARD(new);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(new_cl)
NEXT_P2;
}

LABEL(getstatic_cl) /* getstatic_cl ( -- ) */
/*  */
NAME("getstatic_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.field->owner, 0);
  CURR_INST.params.isfield = CURR_INST.params.field->owner->staticArea + CURR_INST.params.field->posAbs;
  MODIFY_CURR_INST(getstatic);
  FORWARD(getstatic);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(getstatic_cl)
NEXT_P2;
}

LABEL(putstatic_cl) /* putstatic_cl ( -- ) */
/*  */
NAME("putstatic_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.field->owner, 0);
  CURR_INST.params.isfield = CURR_INST.params.field->owner->staticArea + CURR_INST.params.field->posAbs;
  MODIFY_CURR_INST(putstatic);
  FORWARD(putstatic);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(putstatic_cl)
NEXT_P2;
}

LABEL(getstatic_clx) /* getstatic_clx ( -- ) */
/*  */
NAME("getstatic_clx")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.field->owner, 0);
  CURR_INST.params.isfield = CURR_INST.params.field->owner->staticArea + CURR_INST.params.field->posAbs;
  MODIFY_CURR_INST(getstatic_x);
  FORWARD(getstatic_x);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(getstatic_clx)
NEXT_P2;
}

LABEL(putstatic_clx) /* putstatic_clx ( -- ) */
/*  */
NAME("putstatic_clx")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.field->owner, 0);
  CURR_INST.params.isfield = CURR_INST.params.field->owner->staticArea + CURR_INST.params.field->posAbs;
  MODIFY_CURR_INST(putstatic_x);
  FORWARD(putstatic_x);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(putstatic_clx)
NEXT_P2;
}

LABEL(invoke_d_cl) /* invoke_d_cl ( -- ) */
/*  */
NAME("invoke_d_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.invoke->clinit, 0);
  MODIFY_CURR_INST(invoke_d);
  FORWARD(invoke_d);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invoke_d_cl)
NEXT_P2;
}

LABEL(invoke_dn_cl) /* invoke_dn_cl ( -- ) */
/*  */
NAME("invoke_dn_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.invoke->clinit, 0);
  MODIFY_CURR_INST(invoke_dn);
  FORWARD(invoke_dn);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invoke_dn_cl)
NEXT_P2;
}

LABEL(invoke_dnp_cl) /* invoke_dnp_cl ( -- ) */
/*  */
NAME("invoke_dnp_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  /*!CLINIT*/
  fy_localToFrame(context, frame);
  FY_ENGINE_CLINIT(CURR_INST.params.invoke->clinit, 0);
  MODIFY_CURR_INST(invoke_dnp);
  FORWARD(invoke_dnp);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(invoke_dnp_cl)
NEXT_P2;
}

LABEL(return_cl) /* return_cl ( -- ) */
/*  */
NAME("return_cl")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  method->owner->clinitThreadId = -1;
  FORWARD(return);
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(return_cl)
NEXT_P2;
}

LABEL(fault) /* fault ( -- ) */
/*  */
NAME("fault")
{
DEF_CA
NEXT_P0;
#ifdef VM_DEBUG
if (vm_debug) {
}
#endif
{

{
  fy_fault(exception, CURR_INST.params.exception->exceptionName, "%s", CURR_INST.params.exception->exceptionDesc);
#ifdef VM_DEBUG
  if(vm_debug){
    fprintf(vm_out, "fault: %s %s\n", CURR_INST.params.exception->exceptionName, CURR_INST.params.exception->exceptionDesc);
  }
#endif
  goto label_throw;
}

}

#ifdef VM_DEBUG
if (vm_debug) {
fputs(" -- ", vm_out); fputc('\n', vm_out);
}
#endif
NEXT_P1;
LABEL2(fault)
NEXT_P2;
}

    ENGINE_BODY_END;
    lable_throw_npt:
    fy_fault(exception, FY_EXCEPTION_NPT, "");
    goto label_throw;
    label_throw_aioob:
    fy_fault(exception, FY_EXCEPTION_AIOOB, "%"FY_PRINT32"d", ops);
    goto label_throw;
    label_throw_nase:
    fy_fault(exception, FY_EXCEPTION_NASE, "%"FY_PRINT32"d", ops);
    goto label_throw;
    label_throw_dbz:
    fy_fault(exception, FY_EXCEPTION_ARITHMETIC, "Divided by zero!");
    goto label_throw;
    label_throw:
    ops = 0;
    fy_localToFrame(context, frame);
    goto label_fallout_invoke;
  }
}
#undef FY_ENGINE_NAME
