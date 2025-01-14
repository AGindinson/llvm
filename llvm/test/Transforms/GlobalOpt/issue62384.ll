; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; if INTEL_SYCL_OPAQUEPOINTER_READY
; RUN: opt -S -p=globalopt %s | FileCheck %s
; else
// XFAIL: *
; end


@llvm.used = appending global [1 x ptr] [ptr @ctor]
@gv0 = internal addrspace(1) global ptr null
@gv1 = internal addrspace(1) global ptr addrspace(3) null
@gv2 = internal addrspace(1) global ptr addrspace(1) null
@gv3 = internal addrspace(1) global ptr addrspace(1) null

define internal void @ctor() {
; CHECK-LABEL: define internal void @ctor() {
; CHECK-NEXT:    tail call fastcc void @init0(ptr addrspacecast (ptr addrspace(1) null to ptr))
; CHECK-NEXT:    tail call fastcc void @init1(ptr addrspacecast (ptr addrspace(3) null to ptr))
; CHECK-NEXT:    tail call fastcc void @init2(ptr addrspace(1) addrspacecast (ptr null to ptr addrspace(1)))
; CHECK-NEXT:    tail call fastcc void @init3(ptr addrspace(1) addrspacecast (ptr addrspace(2) null to ptr addrspace(1)))
; CHECK-NEXT:    ret void
;
  tail call void @init0(ptr addrspacecast (ptr addrspace(1) null to ptr))
  tail call void @init1(ptr addrspacecast (ptr addrspace(3) null to ptr))
  tail call void @init2(ptr addrspace(1) addrspacecast (ptr null to ptr addrspace(1)))
  tail call void @init3(ptr addrspace(1) addrspacecast (ptr addrspace(2) null to ptr addrspace(1)))
  ret void
}

define internal void @init0(ptr %T) {
; CHECK-LABEL: define internal fastcc void @init0
; CHECK-SAME: (ptr [[T:%.*]]) unnamed_addr {
; CHECK-NEXT:    [[LD:%.*]] = load ptr, ptr addrspace(1) @gv0, align 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr [[LD]], null
; CHECK-NEXT:    store ptr addrspacecast (ptr addrspace(1) null to ptr), ptr addrspace(1) @gv0, align 8
; CHECK-NEXT:    ret void
;
  %ld = load ptr, ptr addrspace(1) @gv0, align 8
  %cmp = icmp eq ptr %ld, null
  store ptr addrspacecast (ptr addrspace(1) null to ptr), ptr addrspace(1) @gv0, align 8
  ret void
}

define internal void @init1(ptr %T) {
; CHECK-LABEL: define internal fastcc void @init1
; CHECK-SAME: (ptr [[T:%.*]]) unnamed_addr {
; CHECK-NEXT:    [[LD:%.*]] = load ptr addrspace(3), ptr addrspace(1) @gv1, align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(3) [[LD]], null
; CHECK-NEXT:    store ptr addrspacecast (ptr addrspace(3) null to ptr), ptr addrspace(1) @gv1, align 8
; CHECK-NEXT:    ret void
;
  %ld = load ptr addrspace(3), ptr addrspace(1) @gv1, align 4
  %cmp = icmp eq ptr addrspace(3) %ld, null
  store ptr addrspacecast (ptr addrspace(3) null to ptr), ptr addrspace(1) @gv1, align 8
  ret void
}

define internal void @init2(ptr addrspace(1) %T) {
; CHECK-LABEL: define internal fastcc void @init2
; CHECK-SAME: (ptr addrspace(1) [[T:%.*]]) unnamed_addr {
; CHECK-NEXT:    [[LD:%.*]] = load ptr addrspace(1), ptr addrspace(1) @gv2, align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(1) [[LD]], null
; CHECK-NEXT:    store ptr addrspace(1) addrspacecast (ptr null to ptr addrspace(1)), ptr addrspace(1) @gv2, align 8
; CHECK-NEXT:    ret void
;
  %ld = load ptr addrspace(1), ptr addrspace(1) @gv2, align 4
  %cmp = icmp eq ptr addrspace(1) %ld, null
  store ptr addrspace(1) addrspacecast (ptr null to ptr addrspace(1)), ptr addrspace(1) @gv2, align 8
  ret void
}

define internal void @init3(ptr addrspace(1) %T) {
; CHECK-LABEL: define internal fastcc void @init3
; CHECK-SAME: (ptr addrspace(1) [[T:%.*]]) unnamed_addr {
; CHECK-NEXT:    [[LD:%.*]] = load ptr addrspace(1), ptr addrspace(1) @gv3, align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr addrspace(1) [[LD]], null
; CHECK-NEXT:    store ptr addrspace(1) addrspacecast (ptr addrspace(2) null to ptr addrspace(1)), ptr addrspace(1) @gv3, align 8
; CHECK-NEXT:    ret void
;
  %ld = load ptr addrspace(1), ptr addrspace(1) @gv3, align 4
  %cmp = icmp eq ptr addrspace(1) %ld, null
  store ptr addrspace(1) addrspacecast (ptr addrspace(2) null to ptr addrspace(1)), ptr addrspace(1) @gv3, align 8
  ret void
}
