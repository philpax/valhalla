lib CPU
  fun cpuid_get_vendor_id_string(str : UInt8*) : Void
  fun cpuid_get_feature_information(f1 : UInt64*) : Void
end

struct CPUID
  @[Flags]
  enum Features : UInt64
    FPU,        # 0-0
VME,            # 0-1
DE,             # 0-2
PSE,            # 0-3
TSC,            # 0-4
MSR,            # 0-5
PAE,            # 0-6
MCE,            # 0-7
CX8,            # 0-8
APIC,           # 0-9
Reserved_1_10,  # 0-10
SEP,            # 0-11
MTRR,           # 0-12
PGE,            # 0-13
MCA,            # 0-14
CMDV,           # 0-15
PAT,            # 0-16
PSE36,          # 0-17
PSN,            # 0-18
CLFSH,          # 0-19
Reserved_1_20,  # 0-20
DS,             # 0-21
ACPI,           # 0-22
MMX,            # 0-23
FXSR,           # 0-24
SSE,            # 0-25
SSE2,           # 0-26
SS,             # 0-27
HTT,            # 0-28
TM,             # 0-29
Reserved_1_30,  # 0-30
PBE,            # 0-31
SSE3            # 1-0
    PCLMULQDQ,  # 1-1
DTES64,         # 1-2
MONITOR,        # 1-3
DSCPL,          # 1-4
VMX,            # 1-5
SMX,            # 1-6
EIST,           # 1-7
TM2,            # 1-8
SSSE3,          # 1-9
CNXTID,         # 1-10
SDBG,           # 1-11
FMA,            # 1-12
CMPXCHG16B,     # 1-13
XTPR,           # 1-14
PDCM,           # 1-15
Reserved_1_15,  # 1-16
PCID,           # 1-17
DCA,            # 1-18
SSE41,          # 1-19
SSE42,          # 1-20
X2APIC,         # 1-21
MOVBE,          # 1-22
POPCNT,         # 1-23
TSCDeadline,    # 1-24
AESNI,          # 1-25
XSAVE,          # 1-26
OSXSAVE,        # 1-27
AVX,            # 1-28
F16C,           # 1-29
RDRAND,         # 1-30
Reserved_1_31   # 1-31
  end

  def self.get_vendor_id_string(str : StringView)
    str.map_byte! { 0_u8 }

    return if str.size < 12
    CPU.cpuid_get_vendor_id_string(str.ptr)
  end

  def self.get_feature_information : CPUID::Features
    ret = 0_u64
    CPU.cpuid_get_feature_information(pointerof(ret))
    CPUID::Features.new ret
  end
end
