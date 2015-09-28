void kmain()
{
	unsigned short* vidmem = (unsigned short*)0xB8000;
	for (unsigned int i = 0; i < 80*25; ++i)
		vidmem[i] = 0xDD << 8;
}