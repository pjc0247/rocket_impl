require 'optparse'
require 'erb'
require 'zlib'
load 'packet.rb'
load 'enum.rb'

src = nil
dsts = nil
preview = false
OptionParser.new do |opts|
  opts.banner = "Usage: pgen.rb def_file"

  opts.on("-s src", "source file path") do |path|
    src = path
  end
  opts.on("-d path1,path2,...", "specify destination path") do |paths|
    dsts = paths.split(",")
  end
  opts.on("-p", "preview result") do |v|
    preview = v
  end
end.parse!

if src == nil
  exit
end

load src

$_crc_old = [0,0]
$_crc = 0

def update_crc value
  tmp = Zlib::crc32 value.to_s
  $_crc = Zlib::crc32_combine tmp, $_crc_old[0], $_crc_old[1]
  $_crc_old = [$_crc, value.length]
end

puts "PACKETS"
$_packets.each do |packet|
  puts "  %2d - %15s" % [packet.id, packet.name]

  update_crc packet.name
  packet.items.each do |item|
    update_crc item[0]
  end
end
puts "\n"

puts "PACKET VERSION #{$_crc}"
puts "\n"

erb = ERB.new(File.read("packet_template.erb"), nil, '<>')

if preview == true
  puts "PREVIEW"
  puts erb.result
  puts "\n"
end

exit if dsts == nil

puts "OUTPUTS"
dsts.each do |outpath|
  puts "out - #{outpath}"
  fp = File.new(outpath, "w:utf-8")
    fp.write erb.result
  fp.close
end
