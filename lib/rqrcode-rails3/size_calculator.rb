module RQRCode
  module SizeCalculator

#    limits were be calculated with this code :
#            
#    string = "\ré" * 3000        
#        
#    limits = {}
#
#    [:l, :m, :q, :h].each do |level|
#      limits[level] = []
#      i = 0
#      begin
#        i += 1
#        RQRCode::QRCode.new(string, :size => i, :level => level)
#        return i
#      rescue RQRCode::QRCodeRunTimeError => e
#        plimit = (e.to_s.scan(/code length overflow. \(\d*>(\d*)\)/).first[0].to_i)
#        limit = (plimit / 8.051948052).to_i         
#        puts "size #{i}, level #{level}: #{limit} (#{plimit})"
#        limits[level] << limit
#        retry unless i == 40
#      end
#    end

#    puts limits.inspect

    QR_CHAR_SIZE_VS_SIZE = {
      :l => [18, 33, 54, 79, 107, 135, 154, 192, 230, 272, 321, 367, 425, 458, 519, 585, 642, 716, 789, 855, 925, 999, 1086, 1166, 1267, 1361, 1458, 1521, 1620, 1723, 1831, 1942, 2057, 2176, 2291, 2418, 2549, 2684, 2793, 2936]
      :m => [15, 27, 43, 63, 85, 107, 123, 153, 180, 214, 252, 288, 331, 362, 412, 450, 503, 559, 622, 664, 709, 776, 854, 908, 993, 1055, 1120, 1185, 1258, 1364, 1445, 1531, 1620, 1713, 1800, 1901, 1979, 2088, 2201, 2318],
      :q => [12, 21, 33, 47, 61, 75, 87, 109, 131, 153, 178, 204, 242, 259, 293, 322, 364, 394, 442, 481, 508, 564, 610, 659, 713, 749, 802, 865, 905, 978, 1026, 1107, 1163, 1223, 1277, 1345, 1416, 1492, 1571, 1655],
      :h => [8, 15, 25, 35, 45, 59, 65, 85, 99, 121, 139, 156, 178, 195, 131, 251, 281, 310, 338, 382, 403, 439, 461, 510, 534, 592, 623, 656, 696, 740, 787, 839, 895, 954, 979, 1047, 1088, 1134, 1214, 1267],
    }

    def minimum_qr_size_from_string(string, level)
      raise "level #{level} not found in size table" unless QR_CHAR_SIZE_VS_SIZE.has_key? level

      QR_CHAR_SIZE_VS_SIZE[level].each_with_index do |size, index|
        return (index + 1) if string.size < size
      end

      raise "your data is really too big!"

    end
  end
end