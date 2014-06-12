#! ruby -Ku
t0 = Time.now
class String
	def last
		if self[-1] == "ー"
			return self[0..-2].last
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
	def smaller? #ワニノコなどはワ>コなので不適
		if self[0].ord <= self.last.ord
			return true
		else
			return false
		end
	end
	def sentou?(ar)
		if (ar+[self]).sort[0] == self
			return true
		else
			return false
		end
	end
end


def answer
	File.open("shiritori_loop_sort_reuse.txt", "w") { |f|  
		$ans_hash={}
		$ans_hash[1] = {}
		list = []
		File.open("./pokemon_list.txt", "r") { |file|
			file.each do |pokemon|
				pokemon.chomp!
				if pokemon.last!="ン"
					list << pokemon
					$ans_hash[1][pokemon[0]]||$ans_hash[1][pokemon[0]] = {}
					($ans_hash[1][pokemon[0]][pokemon.last]||= []) << [pokemon]
				end
			end
		}
		list.sort!
		for n in 2..5
			$ans_hash[n] = {}
			list.each do |poke|
				$ans_hash[n][poke[0]] || $ans_hash[n][poke[0]] = {}
				($ans_hash[n-1][poke.last]||[]).each do |kumi|
					if n==5
						if $ans_hash[1][kumi[0]][poke[0]]
							kumi[1].each do |ar|
								unless ar.include?(poke)
									($ans_hash[n][poke[0]][kumi[0]]||=[])<<([poke]+ar)
								end
							end
						end
					else
						kumi[1].each do |ar|
							unless ar.include?(poke)
								($ans_hash[n][poke[0]][kumi[0]]||=[])<<([poke]+ar)
							end
						end
					end
				end
				p [n,poke]
			end
#			p $ans_hash
		end
		n=6
		$sum = 0
		list.each do |poke|
			p [n,poke]
			unless poke.smaller?
				next
			end
			(($ans_hash[n-1][poke.last]||{})[poke[0]]||[]).each do |ar|
				if poke.sentou?(ar)
					unless ar.include?(poke)
						$sum += 1
						f.puts ([poke]+ar).join(",")
					end
				end
			end
		end
		f.puts $sum.to_s
	}
	return $sum
end
p answer
p Time.now-t0