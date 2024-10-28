include Gem::Text


candidates = Hash.new(0)
bad_candidates_with_bad_letter = Array.new(0)
def contains_latin?(str)
  str =~ /[a-zA-Z]/ ? true : false
end



File.open('data/log.txt', 'r') do |file|
  file.each_line do |line|
    parsed_string = line.split('=>').last.strip
    name_parts = parsed_string.split(' ')


    full_name = [name_parts[0], name_parts[1], name_parts[2]].join(' ')


    if contains_latin?(full_name)
      bad_candidates_with_bad_letter.append(full_name)

    else
      if candidates.key?(full_name)

          candidates[full_name] += 1
      else
        candidates[full_name] = 1
      end
    end




  end
end
sorted_candidates = candidates.sort_by { |key, value| -value }.to_h
good_candidates = sorted_candidates.first(200).to_h
bad_candidates = sorted_candidates.drop(200).to_h




bad_candidates.each_key do |bad_candidate|

  good_candidates.each_key do |cand|
        if  (cand.length - bad_candidate.length).abs<=4 && levenshtein_distance(cand,bad_candidate)<=4


          good_candidates[cand] +=  bad_candidates[bad_candidate]

          break

        end
    end
end

bad_candidates_with_bad_letter.each do |bad_candidate|

  good_candidates.each_key do |cand|
      if  (cand.length - bad_candidate.length).abs<=4 and levenshtein_distance(cand,bad_candidate)<=4

        good_candidates[cand] += 1

        break

      end
  end
end

good_candidates.sort_by { |key, value| -value }.to_h.each_key do |resident|
  puts "Кандидат: #{resident} - #{good_candidates[resident]}"
end
