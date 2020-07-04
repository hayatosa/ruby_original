require 'active_support/core_ext/numeric/conversions'
require './comments'
require './self_pay'
require './system'

include Comments

# 症状、診察内容、医療費を用意
examinations = [
  {symptom:"熱っぽい", disease: "風邪", cost: 5_000},
  {symptom:"手が痛い", disease: "骨折", cost: 200_000},
  {symptom:"胃がムカムカ", disease: "胃潰瘍", cost: 600_000},
  {symptom:"下痢・血便", disease: "潰瘍性大腸炎", cost: 1_000_000},
  {symptom:"頭痛・吐き気・あざ・倦怠感・歯ぐきの腫れ", disease: "急性白血病", cost: 5_000_000},
]

question_comment

examinations.each.with_index(1) do |examination,i|
  puts "#{i} #{examination[:symptom]}"
end

while true
  print "番号を入力："
  selected_number = gets.chomp.to_i

  if selected_number < 1 || 5 < selected_number
    puts "不正な入力値です。1~5から選んでください"
    next
  end
  break
end

examination_number = selected_number -1
@selected_examination = examinations[examination_number]

while true
  print "あなたの年齢を教えてください："
  @age = gets.chomp.to_i

  if @age < 0 || 120 < @age
    puts "不正な値です。0~120を入力してください"
    next
  end
  break
end

diagnosis_comment

# 自己負担額
@self_pay = @selected_examination[:cost] * self_pay_ratio/10
# 医療保険負担額
@health_insurance_pay = @selected_examination[:cost] - @self_pay

# 下痢・血便を選んだ場合、難病助成制度に該当
if examination_number == 3

  nanbyou_system

elsif  0 <= @age && @age <= 74 && examination_number != 3

  self_pay_comment

  # 高額療養費制度に該当
  if @self_pay > 60_000

    kougaku_system

  end

# 75歳以上の場合制度が異なる、かつ年収に応じて自己負担額が変わる
elsif 75 <= @age && @age <= 120 && examination_number != 3

    koureisha_system

end

last_comment
