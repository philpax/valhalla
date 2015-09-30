require "./kernel"

fun kmain(multiboot : Multiboot::Information*)
	kernel = Kernel.new multiboot
end