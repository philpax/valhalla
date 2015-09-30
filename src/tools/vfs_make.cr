require "../common/vfs"

raise ArgumentError.new "src_directory, output_file" if ARGV.size < 2

input = ARGV[0]
output = ARGV[1]
raise ArgumentError.new "First argument not a directory" if !File.directory? input

class File
    def write_struct(s)
        self.write(Slice.new(pointerof(s) as UInt8*, sizeof(typeof(s))))
    end
end

File.open output, "wb" do |file|
    files = Dir.entries(input).reject { |entry| entry == "." || entry == ".." }
                              .map { |path| {path, File.read File.join(input, path)} }
    file_count = files.size

    header = VFS::Header.new
    header.magic = VFS::HeaderMagic
    header.version = 1_u32
    header.file_count = file_count.to_u32

    file.write_struct header
    current_offset = (sizeof(VFS::Header) + file_count * sizeof(VFS::FileNode)).to_u32

    files.each do |f|
        file_node = VFS::FileNode.new
        file_node.filename.to_unsafe.copy_from f[0].cstr, f[0].size
        file_node.offset = current_offset.to_u32
        file_node.size = f[1].size.to_u32

        file.write_struct file_node
        current_offset += file_node.size
    end

    files.each do |f|
        file.write f[1].to_slice
    end
end