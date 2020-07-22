require 'active_support/core_ext/numeric/conversions'
require './examinations'
require './comments'
require './self_pay'
require './system'
require 'byebug'

include Comments

examinations =
  [
    {symptom:"熱っぽい", disease: "風邪", cost: 5_000},
    {symptom:"手が痛い", disease: "骨折", cost: 200_000},
    {symptom:"胃がムカムカ", disease: "胃潰瘍", cost: 600_000},
    {symptom:"下痢・血便", disease: "潰瘍性大腸炎", cost: 1_000_000},
    {symptom:"頭痛・吐き気・あざ・倦怠感・歯ぐきの腫れ", disease: "急性白血病", cost: 5_000_000},
  ]

class Shindan

  question_comment

  def disp_symptom(examinations)
    examinations.each.with_index(1) do |examination,i|
      puts "#{i} #{examination[:symptom]}"
    end
  end

  def select_symptom(examinations)
    loop{
      print "番号を入力して下さい："
      selected_number = gets.chomp.to_i

      @selected_examination = examinations[selected_number - 1]

      if selected_number < 1 || 5 < selected_number
        puts "不正な入力値です。1~5から選んでください"
        next
      end
      break
     }
  end

  def how_old
    loop {
      print "あなたの年齢を教えてください："
      @age = gets.chomp.to_i

      if @age < 0 || 120 < @age
        puts "不正な値です。0~120を入力してください"
        next
      end
      break
    }
  end

  def announcement
    diagnosis_comment(
      age: @age,
      symptom: @selected_examination[:symptom],
      disease: @selected_examination[:disease],
      cost: @selected_examination[:cost],
      )
  end

  def calculation
    # 年齢による自己負担割合
    def self_pay_ratio
      case @age
      when 0..5
        2
      when 6..69
        3
      when 70..74
        2
      when 75..120
        1
      end
    end

  # 自己負担額
  @self_pay = @selected_examination[:cost] * self_pay_ratio/10
  # 医療保険負担額
  @health_insurance_pay = @selected_examination[:cost] - @self_pay
  end

  def selected_disease
    # 下痢・血便を選んだ場合、難病助成制度に該当
    if @selected_examination[3]
      nanbyou_system

    elsif  0 <= @age && @age <= 74

      self_pay_comment(
        age: @age,
        self_pay: @self_pay,
        health_insurance_pay: @health_insurance_pay,
        )
    end
  end

  # def high_cost
  #   # 高額療養費制度に該当
  #   if @self_pay > 60_000
  #     kougaku_system
  #   end
  # end
  #
  # def old_people
  # # 75歳以上の場合制度が異なる、かつ年収に応じて自己負担額が変わる
  #   if 75 <= @age && @age <= 120 && examination_number != 3
  #     koureisha_system
  #   end
  # end

  # last_comment
end

shindan = Shindan.new
shindan.disp_symptom(examinations)
shindan.select_symptom(examinations)
shindan.how_old
shindan.announcement
shindan.calculation
shindan.selected_disease
