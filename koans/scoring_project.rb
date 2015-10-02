# Scoring Project Code.

def score(dice)
  tally = 0

  counts = Hash.new(0)
  dice.each { |x| counts[x] += 1 }

  (1..6).each do |i|
    if counts[i] >= 3
      i == 1 ? tally += 1000 : tally += 100 * i
      counts[i] = [counts[i] - 3, 0].max
    end

    if i == 1
      tally += 100 * counts[i]
    elsif i == 5
      tally += 50 * counts[i]
    end
  end

  tally
end
