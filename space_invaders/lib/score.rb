class Score

  @file = 'scores.txt'

  def self.save(score)
    File.open(@file, 'a').write("#{Time.now.to_s}: #{score};")
  end

  def self.read
    File.open(@file).read.split(';').map do |score_line|
      score_line.split(': ')
    end
  end

  def self.high_score
    read.map { |score| score[1].to_i }.sort.reverse.first
  end
end
