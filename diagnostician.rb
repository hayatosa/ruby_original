require 'active_support/core_ext/numeric/conversions'
require './examinations'
require './comments'
require 'byebug'

include Comments

class Diagnostician
  question_comment

  def disp_symptom(examinations)
    examinations.each.with_index(1) do |examination,i|
      puts "#{i} #{examination[:symptom]}"
    end
  end

  def select_symptom(examinations)

    disp_symptom(examinations)

    print "番号を入力して下さい："
    selected_number = gets.chomp.to_i
    @selected_examination = examinations[selected_number - 1]

    # メソッド名による繰り返し処理
    if selected_number < 1 || 5 < selected_number
      puts "不正な入力値です。1~5から選んでください"
      select_symptom(examinations)
    end
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

  def diagnose
    diagnose_comment(
      age: @age,
      symptom: @selected_examination[:symptom],
      disease: @selected_examination[:disease],
      cost: @selected_examination[:cost],
      )
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

    if @selected_examination[3]
      diagnose_rare_disease

    elsif @age <= 74 && @self_pay <= 60_000
      self_pay_comment(
        age: @age,
        self_pay: @self_pay,
        health_insurance_pay: @health_insurance_pay,
        )

    elsif @self_pay > 60_000
      high_cost_medical_expense_benefit

    elsif 75 <= @age
    # && examination_number != 3
      medical_system_for_elderly
    end
  end

  def diagnose_rare_disease
    # 難病助成制度の自己負担額上限
    def rare_disease_self_pay_limit
      case @income
      when 0..159
        5_000
      when 160..369
        10_000
      when 370..809
        20_000
      else
        30_000
      end
    end

    rare_disease_comment(disease: @selected_examination[:disease])
    select_income
    rare_disease_self_pay_comment(cost: @selected_examination[:cost])

  end

  def high_cost_medical_expense_benefit

    def self_pay_limit
      case @income
      when 0..369
        60_000
      when 370..769
        90_000
      when 770..1159
        170_000
      else
        260_000
      end
    end

    high_cost_medical_expense_benefit_comment
    select_income

    if @self_pay - self_pay_limit < 0
      puts "今回の自己負担額は上限内でしたので、あなたが負担する金額は変わらず#{@self_pay}円です"
    else
      puts <<~TEXT
      年収#{@income}万円の場合、自己負担上限額は#{self_pay_limit}円です
      残りの#{@self_pay - self_pay_limit}円も、あなたが加入している医療保険が支払います
      TEXT
    end
  end

  def medical_system_for_elderly
    # 75歳以上の自己負担割合
    def elderly_self_pay_ratio
      case @income
      when 0..369
        1
      else
        3
      end
    end

    def self_pay_limit
      case @income
      when 0..369
        60_000
      when 370..769
        90_000
      when 770..1159
        170_000
      else
        260_000
      end
    end

    medical_system_for_elderly_comment
    select_income
    puts "年収#{income}万円の場合、自己負担割合は#{elderly_self_pay_ratio}割です"

    # 高齢者自己負担額
    elderly_self_pay = @selected_examination[:cost] * elderly_self_pay_ratio/10

    # 自己負担額上限を超えた場合
    @upper_limit_balance = @selected_examination.cost - self_pay_limit
    @upper_limit_public_cost = @upper_limit_balance / 2
    @upper_limit_young_cost = @upper_limit_balance * 0.4
    @upper_limit_old_cost = @upper_limit_balance * 0.1

    if elderly_self_pay - self_pay_limit < 0 || 60_000 >= elderly_self_pay
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

# Diagnostician.select_symptom
# Diagnostician.select_age
# Diagnostician.select_income
# Diagnostician.diagnose
