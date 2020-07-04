class Examinations
  attr_reader :symptom, :disease, :cost

  def initialize(**params)
    @symptom = params[:symptom]
    @disease = params[:disease]
    @cost = params[:cost]
  end
end

def examinations
  [
    Examinations.new(symptom:"熱っぽい", disease: "風邪", cost: 5_000),
    Examinations.new(symptom:"手が痛い", disease: "骨折", cost: 200_000),
    Examinations.new(symptom:"胃がムカムカ", disease: "胃潰瘍", cost: 600_000),
    Examinations.new(symptom:"下痢・血便", disease: "潰瘍性大腸炎", cost: 1_000_000),
    Examinations.new(symptom:"頭痛・吐き気・あざ・倦怠感・歯ぐきの腫れ", disease: "急性白血病", cost: 5_000_000),
  ]
end

#症状選択
def select_symptom
  #question_comment
  puts "今日はどうされましたか？症状と年齢を教えてください"

  examinations.each.with_index(1) do |examination,i|
    puts "#{i} #{examination.symptom}"
  end

  while true
    puts "番号を入力："
    selected_number= gets.chomp.to_i
    if selected_number < 1 || 5 < selected_number
      puts "不正な入力値です。1~5から選んでください"
      next
    end
    break
  end

  examination_number = selected_number -1
  @selected_examination = examinations[examination_number]

  while true
    puts "あなたの年齢を教えてください："
    @age = gets.chomp.to_i

    if @age < 0 || 120 < @age
      puts "不正な値です。0~120を入力してください"
      next
    end
    break
  end

  puts <<~TEXT
  ----------------
  年齢は#{@age}歳、症状は「#{@selected_examination.symptom}」ですね

  診察中...
  診察中...
  診察中...

  診断内容は「#{@selected_examination.disease}」です
  医療費は「#{@selected_examination.cost}円」です
  ----------------
  TEXT

end

examinations
select_symptom
