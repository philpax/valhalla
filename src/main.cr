require "./kernel"

fun kmain(multiboot : Multiboot::Information*)
	Kernel.main(multiboot)
end