lib VFS
	struct Header
		magic : UInt32
		version : UInt32
		file_count : UInt32
	end

	struct FileNode
		filename : UInt8[32]
		offset : UInt32
		size : UInt32
	end

	HeaderMagic = 0xEC40455E_u32 # FNV: "valhallafs"
end