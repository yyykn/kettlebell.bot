require 'natto'
require 'date'

def read_dic
  dictionary = {}
  open('./pn_ja.dic') do |f|
    f.each_line do |l|
      line_arr = l.gsub(/\r\n/, "").split(":")
      dictionary[line_arr[0]] = line_arr[3]
      dictionary[line_arr[1]] = line_arr[3]
    end
  end
  dictionary
end

def text2point(natto, text, dic)
  score = []
  natto.parse(text) do |words|
    score.push(dic[words.surface].to_f || 0.0) unless words.surface.empty?
  end
  point = score.empty? ? 0.0 : score.inject(:+) / score.size
  print "[debug][#{DateTime.now}][np][target:\t#{text}][count:#{score.size}][point:\t#{point}]\n"
  point
end

#nm = Natto::MeCab.new
#texts = ['今日は空き缶を踏んでころんだので死ぬかと思ったしお家に帰りたい', '美味しいご飯食べたしお風呂最高だったので非常に眠い']
#texts.each do |t|
#  text2point(nm,t,read_dic)
#end
