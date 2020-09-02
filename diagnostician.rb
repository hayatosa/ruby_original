require 'active_support/core_ext/numeric/conversions'
require './examinations'
require './comments'
require 'byebug'

include Comments

class Diagnostician

  MAXIMUM_AMOUNT = 60_000

  def examinations
    examination_lists =
      [
        {symptom:"熱っぽい", disease: "風邪", cost: 5_000},
        {symptom:"手が痛い", disease: "骨折", cost: 200_000},
        {symptom:"胃がムカムカ", disease: "胃潰瘍", cost: 600_000},
        {symptom:"下痢・血便", disease: "潰瘍性大腸炎", cost: 1_000_000},
        {symptom:"頭痛・吐き気・あざ・倦怠感・歯ぐきの腫れ", disease: "急性白血病", cost: 5_000_000},
      ]
  end

  FIRST_SYMPTOM_NUM = 1
  TOTAL_SYMPTOM_NUM = examinations.size

  def disp_symptom
    examinations.each.with_index(1) do |examination,i|
      puts "#{i} #{examination[:symptom]}"
    end
  end

  def select_examination
    disp_symptom
    loop{
      print "番号を入力して下さい："
      selected_number = gets.chomp.to_i
      @selected_examination = examinations[selected_number - 1]
      if examinations[selected_number - 1].nil?
        puts "不正な入力値です。#{FIRST_SYMPTOM_NUM}~#{TOTAL_SYMPTOM_NUM}から選んでください"
        next
      end
      break
    }
  end

  def select_age
    print "あなたの年齢を教えてください："
    @age = gets.chomp.to_i

    if @age < 0 || 120 < @age
      puts "不正な値です。0~120を入力してください"
      select_age
    end
  end

  def select_income
    print "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < 0
      puts "不正な値です。0以上を入力してください"
      select_income
    end
    puts "#{@income}万円ですね"
  end

  def self_pay_ratio
    age1 = [[0..5],2]
    age2 = [[6.69],3]
    age3 = [[70..74],2]
    age4 = [[75..120],1]

    case @age
    when age1[0]
      age1.last
    when age2[0]
      age2.last
    when age3[0]
      age3.last
    when age4[0]
      age4.last
    end
  end
  # 収入による支払い上限額
  def self_pay_limit
    income1 = [[0..369],60_000]
    income2 = [[370..769],90_000]
    income3 = [[770..1159],170_000]
    income4 = 260_000

    case @income
    when income1[0]
      income1.last
    when income2[0]
      income2.last
    when income3[0]
      income3.last
    else
      income4
    end
  end

  def calculate
    # 自己負担額
    self_pay = @selected_examination[:cost] * self_pay_ratio/10
    # 医療保険負担額
    health_insurance_pay = @selected_examination[:cost] - self_pay
  end

  def diagnose(examination ,age)
    diagnose_comment(
      age: @age,
      symptom: @selected_examination[:symptom],
      disease: @selected_examination[:disease],
      cost: @selected_examination[:cost],
      )

    def rare_disease
      if @selected_examination == examinations[3]
        diagnose_rare_disease(self_pay, health_insurance_pay)
      end
    end

    def normal
      if @age <= 74 && self_pay <= MAXIMUM_AMOUNT
        self_pay_comment(
          age: @age,
          self_pay: self_pay,
          health_insurance_pay: health_insurance_pay,
          )
      end
    end

    def high_cost
      if self_pay > MAXIMUM_AMOUNT
        high_cost_medical_expense_benefit(self_pay)
      end
    end

    def elderly
      if 75 <= @age
        medical_system_for_elderly
      end
    end
  end

  # 難病助成制度の自己負担額上限
  def rare_disease_self_pay_limit
    rare_disease_income1 = [[0..159],5_000]
    rare_disease_income2 = [[160..369],10_000]
    rare_disease_income3 = [[370..809],20_000]
    rare_disease_income4 = 30_000

    case @income
    when rare_disease_income1[0]
      rare_disease_income1.last
    when rare_disease_income2[0]
      rare_disease_income2.last
    when rare_disease_income3[0]
      rare_disease_income3.last
    else
      rare_disease_income4
    end
  end

  def diagnose_rare_disease(self_pay, health_insurance_pay)
    rare_disease_comment(disease: @selected_examination[:disease])
    select_income
    rare_disease_self_pay_comment(
      cost: @selected_examination[:cost],
      self_pay: self_pay,
      health_insurance_pay: health_insurance_pay,
      )
  end

  # 高額療養費制度
  def high_cost_medical_expense_benefit(self_pay)
    high_cost_medical_expense_benefit_comment
    select_income

    if self_pay - self_pay_limit < 0
      puts <<~TEXT
      今回の自己負担額は、本来あなたが負担する割合（#{self_pay_ratio}割）の範囲内でした
      従って負担額は#{self_pay}円です
      残りの#{@selected_examination[:cost] - self_pay}円はあなたが加入している医療保険が支払います
      TEXT
    else
      puts <<~TEXT
      年収#{@income}万円の場合、自己負担上限額は#{self_pay_limit}円です
      残りの#{@selected_examination[:cost] - self_pay_limit}円をあなたが加入している医療保険が支払います
      TEXT
    end
  end

  # 75歳以上の自己負担割合
  def elderly_self_pay_ratio
    elderly_income1 = [[0..369],1]
    elderly_income2 = 3

    case @income
    when elderly_income1[0]
      elderly_income1.last
    else
      elderly_income2
    end
  end

  def medical_system_for_elderly
    medical_system_for_elderly_comment
    select_income
    puts "年収#{@income}万円の場合、自己負担割合は#{elderly_self_pay_ratio}割です"

    # 高齢者自己負担額
    elderly_self_pay = @selected_examination[:cost] * elderly_self_pay_ratio/10

    if elderly_self_pay - self_pay_limit < 0 || MAXIMUM_AMOUNT >= elderly_self_pay
      elderly_self_pay_comment(
        cost: @selected_examination[:cost],
      )
    else
      elderly_self_pay_limit_comment(
        cost: @selected_examination[:cost],
        income: @income,
      )
    end
  end

end
