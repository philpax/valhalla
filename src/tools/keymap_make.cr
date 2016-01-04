# Courtesy of https://github.com/charliesome/jsos/blob/master/kernel/js/kernel/keyboard.js
keyMap = [
  # 0x00
  nil, nil,
  nil, nil,
  "1", "!",
  "2", "@",
  "3", "#",
  "4", "$",
  "5", "%",
  "6", "^",
  "7", "&",
  "8", "*",
  "9", "(",
  "0", ")",
  "-", "_",
  "=", "+",
  "\x7f", "\x7f", # backspace
  " ", " ",

  # 0x10
  "q", "Q",
  "w", "W",
  "e", "E",
  "r", "R",
  "t", "T",
  "y", "Y",
  "u", "U",
  "i", "I",
  "o", "O",
  "p", "P",
  "[", "{",
  "]", "}",
  "\n", "\n",
  nil, nil,
  "a", "A",
  "s", "S",

  # 0x20
  "d", "D",
  "f", "F",
  "g", "G",
  "h", "H",
  "j", "J",
  "k", "K",
  "l", "L",
  ";", ":",
  "'", "\"",
  "`", "~",
  nil, nil,
  "\\", "|",
  "z", "Z",
  "x", "X",
  "c", "C",
  "v", "V",

  # 0x30
  "b", "B",
  "n", "N",
  "m", "M",
  ",", "<",
  ".", ">",
  "/", "?",
  nil, nil,
  "*", "*",
  nil, nil,
  " ", " ",
  nil, nil,
  nil, nil,
  nil, nil,
  nil, nil,
  nil, nil,
  nil, nil,

  # 0x40
  nil,  nil,
  nil,  nil,
  nil,  nil,
  nil,  nil,
  nil,  nil,
  nil,  nil,
  nil,  nil,
  "7", "7",
  "8", "8",
  "9", "9",
  "-", "-",
  "4", "4",
  "5", "5",
  "6", "6",
  "+", "+",
  "1", "1",

  # 0x50
  "2", "2",
  "3", "3",
  "0", "0",
  ".", ".",
  nil, nil
];

raise ArgumentError.new "output_file" if ARGV.size < 1

output = ARGV[0]

File.open output, "wb" do |file|
  keyMap.each do |v|
    if v.is_a? Nil
      file.write_byte 0.to_u8
    else
      file.write_byte v.byte_at(0)
    end
  end
end
