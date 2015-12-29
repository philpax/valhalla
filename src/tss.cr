lib CPU
  # Task State Segment
  struct TSS
    link : UInt16
    link_h : UInt16

    esp0 : UInt32
    ss0 : UInt16
    ss0_h : UInt16

    esp1 : UInt32
    ss1 : UInt16
    ss1_h : UInt16

    esp2 : UInt32
    ss2 : UInt16
    ss2_h : UInt16

    cr3 : UInt32
    eip : UInt32
    eflags : UInt32

    eax : UInt32
    ecx : UInt32
    edx : UInt32
    ebx : UInt32

    esp : UInt32
    ebp : UInt32

    esi : UInt32
    edi : UInt32

    es : UInt16
    es_h : UInt16

    cs : UInt16
    cs_h : UInt16

    ss : UInt16
    ss_h : UInt16

    ds : UInt16
    ds_h : UInt16

    fs : UInt16
    fs_h : UInt16

    gs : UInt16
    gs_h : UInt16

    ldt : UInt16
    ldt_h : UInt16

    trap : UInt16
    iomap : UInt16
  end
end
