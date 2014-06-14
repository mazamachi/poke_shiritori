#! ruby -Ku
t0 = Time.now
class String
	def last
		large=["ア","イ","ウ","エ","オ","ツ","ヤ","ユ","ヨ"]
		small=["ァ","ィ","ゥ","ェ","ォ","ッ","ャ","ュ","ョ"]
		if self[-1] == "ー"
			return self[0..-2].last
		elsif large.include?(self[-1])
			return small[large.index(self[-1])]
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
	File.open("shiritori_loop_sort5_300.txt", "w") { |f|  
		$ans_hash={}
		$ans_hash[1] = {}
		list = []
		File.open("./pokemon_list300.txt", "r") { |file|
			file.each do |pokemon|
				pokemon.chomp!
				list << pokemon if pokemon.last != "ン"
				($ans_hash[1][pokemon[0]]||$ans_hash[1][pokemon[0]] = []) << [pokemon]
			end
		}
		list.sort!
		p $ans_hash
		for n in 2..4
			$ans_hash[n] = {}
			list.each do |poke|
				$ans_hash[n][poke[0]]||$ans_hash[n][poke[0]] = []
				($ans_hash[n-1][poke.last]||[]).each do |ar|
					unless ar.include?(poke)
						$ans_hash[n][poke[0]]<<([poke]+ar)
					end
				end
				p [n,poke]
			end
		#	p $ans_hash
		end

		n = 5
		$ans_hash[n] = {}
		list.each do |poke|
			p [n,poke]
			$ans_hash[n][poke[0]]||$ans_hash[n][poke[0]]={}
			($ans_hash[n-1][poke.last]||[]).each do |ar|
				unless ar.include?(poke)
					($ans_hash[n][poke[0]+ar[-1].last]||$ans_hash[n][poke[0]+ar[-1].last]=[]) <<([poke]+ar)					
				end
			end
		end
#			p $ans_hash
		n=6
		$sum = 0
		list.each do |poke|
			p [n,poke]
			unless poke.smaller?
				next
			end
			($ans_hash[n-1][poke.last+poke[0]]||{}).each do |ar|
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