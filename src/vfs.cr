require "./common/vfs"

struct VirtualFilesystem
	@fs_begin :: UInt8*
	@fs_end :: UInt8*

	def initialize(@fs_begin, @fs_end)
		header = @fs_begin as VFS::Header*
		@version = header.value.version
		@file_count = header.value.file_count
	end

	def self.valid?(fs_begin)
		header = fs_begin as VFS::Header*
		header.value.magic == VFS::HeaderMagic
	end

	def each_file
		nodes = (@fs_begin + sizeof(VFS::Header)) as VFS::FileNode*
		@file_count.times do |i|
			node = nodes[i]
			filename = StringView.new(node.filename.to_unsafe)
			contents = Slice(UInt8).new(@fs_begin + node.offset, node.size.to_i32)
			yield filename, contents
		end
	end
end