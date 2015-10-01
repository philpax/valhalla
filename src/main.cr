require "./kernel"

lib LibCrystalMain
	@[Raises]
	fun __crystal_main(argc : Int32, argv : UInt8**)
end

fun kmain(multiboot : Multiboot::Information*)
	LibCrystalMain.__crystal_main(0, Pointer(UInt8*).null)
	kernel = Kernel.new multiboot
end