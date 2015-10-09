lib CPU
	fun cpuid_get_vendor_id_string(str : UInt8*) : Void
end

struct CPUID
	def self.get_vendor_id_string(str : StringView)
		str.map_byte! { 0_u8 }

		return if str.size < 12
		CPU.cpuid_get_vendor_id_string(str.ptr)
	end
end