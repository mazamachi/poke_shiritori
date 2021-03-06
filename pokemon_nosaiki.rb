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

def answer
	File.open("shiritori.txt", "w") { |f|  
		$ans_hash={}
		$ans_hash[1] = {}
		list = []
		File.open("./pokemon_list.txt", "r") { |file|
			file.each do |pokemon|
				pokemon.chomp!
				list << pokemon
				if $ans_hash[1][pokemon[0]]
					$ans_hash[1][pokemon[0]] << [pokemon]
				else
					$ans_hash[1][pokemon[0]] = [[pokemon]]
				end
			end
		}
		p $ans_hash
		for n in 2..5
			$ans_hash[n] = {}
			list.each do |poke|
				if $ans_hash[n][poke[0]]
					($ans_hash[n-1][poke.last]||[]).each do |ar|
						unless ar.include?(poke)
							$ans_hash[n][poke[0]]<<([poke]+ar)
						end
					end
				else
					$ans_hash[n][poke[0]] = []
					($ans_hash[n-1][poke.last]||[]).each do |ar|
						unless ar.include?(poke)
							$ans_hash[n][poke[0]]<<([poke]+ar)
						end
					end
				end
				p [n,poke]
			end
		#	p $ans_hash
		end
		n=6
		sum = 0
		list.each do |poke|
			p [n,poke]
			($ans_hash[n-1][poke.last]||[]).each do |ar|
				unless ar.include?(poke)
					sum += 1
					f.puts ([poke]+ar).join(",")
				end
			end
		end
		f.puts sum.to_s
	}
	return 0
end
answer