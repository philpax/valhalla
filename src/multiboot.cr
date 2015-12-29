lib Multiboot
  @[Flags]
  enum Flags
    Memory,
    BootDevice,
    CmdLine,
    Modules,
    SymbolsAout,
    SymbolsELF,
    MemoryMap,
    Drives,
    ROMConfig,
    BootloaderName,
    APMTable,
    GraphicsTable
  end

  struct AOut
    tabsize : UInt32
    strsize : UInt32
    addr : Void*
    reserved : UInt32
  end

  struct ELF
    num : UInt32
    size : UInt32
    addr : Void*
    shndx : UInt32
  end

  union Symbols
    aout : AOut
    elf : ELF
  end

  struct Module
    mod_start : Void*
    mod_end : Void*
    str : UInt8*
    reserved : UInt32
  end

  struct MemoryMap
    size : UInt32
    base_addr : UInt64
    length : UInt64
    region_type : UInt32
  end

  struct Information
    # ------------------------------
    flags : Flags # 0
    # ------------------------------
    mem_lower : UInt32 # 4
    mem_upper : UInt32 # 8
    # ------------------------------
    boot_device : UInt32 # 12
    # ------------------------------
    cmdline : UInt8* # 16
    # ------------------------------
    mods_count : UInt32 # 20
    mods_addr : Module* # 24
    # ------------------------------
    symbols : Symbols # 28
    # ------------------------------
    mmap_length : UInt32   # 44
    mmap_addr : MemoryMap* # 48
    # ------------------------------
    drives_length : UInt32 # 52
    drives_addr : Void*    # 56
    # ------------------------------
    config_table : Void* # 60
    # ------------------------------
    bootloader_name : UInt8* # 64
    # ------------------------------
    apm_table : Void* # 68
    # ------------------------------
    vbe_control_info : Void*   # 72
    vbe_mode_info : Void*      # 76
    vbe_mode : UInt16          # 80
    vbe_interface_seg : UInt16 # 82
    vbe_interface_off : UInt16 # 84
    vbe_interface_len : UInt16 # 86
  end
end
