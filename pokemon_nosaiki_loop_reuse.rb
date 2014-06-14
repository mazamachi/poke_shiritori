#! ruby -Ku
t0 = Time.now
class String
	def last#しりとりのルールに則った最後の文字を返す。
		large=["ア","イ","ウ","エ","オ","ツ","ヤ","ユ","ヨ"]
		small=["ァ","ィ","ゥ","ェ","ォ","ッ","ャ","ュ","ョ"]
		if self[-1] == "ー"
			return self[0..-2].last
		elsif small.include?(self[-1])
			return large[small.index(self[-1])]
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
	def sentou?(ar) #あるポケモンがarに追加されるとき、それより前に出ていないかチェック
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
					$ans_hash[1][pokemon[0]] ||= {} 
					($ans_hash[1][pokemon[0]][pokemon.last]||= []) << [pokemon]
					#各ポケモンの先頭の文字及び末尾の文字で分類したハッシュを作成。
				end
			end
		}
		list.sort!
		for n in 2..5
			$ans_hash[n] = {}
			list.each do |poke|
				$ans_hash[n][poke[0]] || $ans_hash[n][poke[0]] = {}
				($ans_hash[n-1][poke.last]||[]).each do |kumi|
					if n==5 #5の場合だけは、6匹目が追加されることを考えて、先頭の文字と末尾の文字を満たす
						#ポケモンが存在する時のみ配列を作成する。
						if $ans_hash[1][kumi[0]][poke[0]]
							kumi[1].each do |ar|
								unless ar.include?(poke)
									($ans_hash[n][poke[0]][kumi[0]]||=[])<<([poke]+ar)
								end
							end
						end
					else #nが2から4では、$ans_hash[n-1]に分類されたしりとりが作成されているので、
						#各ポケモンの末尾の文字の配列を参照して先頭に追加すれば良い。
						kumi[1].each do |ar|
							unless ar.include?(poke)
								($ans_hash[n][poke[0]][kumi[0]]||=[])<<([poke]+ar)
							end
						end
					end
				end
				p [n,poke]
			end
		end
		n=6
		$sum = 0
		list.each do |poke|
			p [n,poke]
			unless poke.smaller?
				next
			end
			#n=6では先頭に追加して書き込むだけで良い。
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
p (Time.now-t0).to_s+"s" 