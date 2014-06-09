#! ruby -Ku
class String
	def last
		if self[-1] == "ー"
			return self[-2]
		elsif self[-1] == "ァ"
			return "ア"
		elsif self[-1] == "ィ"
			return "イ"
		elsif self[-1] == "ゥ"
			return "ウ"
		elsif self[-1] == "ェ"
			return "エ"
		elsif self[-1] == "ォ"
			return "オ"
		elsif self[-1] == "ッ"
			return "ツ"
		elsif self[-1] == "ャ"
			return "ヤ"
		elsif self[-1] == "ュ"
			return "ユ"
		elsif self[-1] == "ョ"
			return "ヨ"
		else
			return self[-1]
		end
	end
end
class Hash
	def shiritori(kashiramoji,nokori) #帰納的定義
		if nokori == 1
			a = []
			if self[kashiramoji]
				self[kashiramoji].each do |pokes|
					pokes[1].each do |poke|
						a << [poke]
					end
				end
			return a	
			end
		else
			a = []
			if self[kashiramoji]
				self[kashiramoji].each do |poke| 
					sh = shiritori(poke[0],nokori-1)
					if sh
						sh.each do |shiri|
							unless shiri.include?(poke[1][0]) #重複削除
								a << shiri.unshift(poke[1][0])
							end
						end
					end
				end
			end
			return a
		end
	end
end
$hash = Hash.new
("ア".ord .. "ン".ord).each do |ord|
	$hash[ord.chr("UTF-8")] = {}
end
File.open("./pokemon_list.txt", "r") { |file|
	file.each do |pokemon|
		pokemon.chomp!
		if $hash[pokemon[0]][pokemon.last]
			$hash[pokemon[0]][pokemon.last] << pokemon
		else
			$hash[pokemon[0]][pokemon.last] = [pokemon]
		end
	end
}
puts $hash

def answer
	ans = []
	("ア".ord .. "ン".ord).each do |ord|
		$hash.shiritori(ord.chr("UTF-8"),6).each do |kumi|
			p kumi
			ans << kumi
		end
	end
	return ans
end