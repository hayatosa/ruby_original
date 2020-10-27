require 'active_support/core_ext/numeric/conversions'
require './comments'
require 'byebug'

include Comments

class Diagnostician

  MIN_SELF_PAY = 0
  MAX_SELF_PAY = 60_000
  MIN_AGE = 0
  MAX_AGE = 120
  MIN_INCOME = 0
  MAX_INCOME = 100_000_000
  ELDERLY_AGE = 75
  FIRST_SYMPTOM_NUM = 1

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
        puts "不正な入力値です。#{FIRST_SYMPTOM_NUM}~5から選んでください"
        next
      end
      break
    }
  end

  def select_age
    print "あなたの年齢を教えてください："
    @age = gets.chomp.to_i

    if @age < MIN_AGE || MAX_AGE < @age
      puts "不正な値です。0~120以内で入力してください"
      select_age
    end
  end

  def select_income
    print "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < MIN_INCOME || MAX_INCOME < @income
      puts "不正な値です。0~100,000,000以内で入力してください"
      select_income
    end
    puts "#{@income}万円ですね"
  end

  def diagnose
    if @age.nil? || @selected_examination.nil?
      puts <<~TEXT
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

      エラー
      「main.rbにてdiagnoseより先にselect_ageとselect_examinationを呼び出してください」

      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      TEXT
      return
    end

    diagnose_comment(
      age: @age,
      symptom: @selected_examination[:symptom],
      disease: @selected_examination[:disease],
      cost: @selected_examination[:cost],
      )

    selfpayratio_ages = [[5,2],[69,3],[74,2],[MAX_AGE,1],] #年齢による自己負担割合
    selfpaylimit_incomes = [[369,60000],[769,90000],[1159,170000],[MAX_INCOME,260000],] #収入による自己負担上限額
    rarediseaselimit_incomes = [[159,5000],[369,10000],[809,20000],[MAX_INCOME,30000],] #難病制度下での収入による自己負担上限額
    elderly_selfpayratio_incomes = [[369,1],[MAX_INCOME,3],] #75歳以上の収入による自己負担割合

    self_pay = @selected_examination[:cost] * match_case(@age,selfpayratio_ages)/10
    health_insurance_pay = @selected_examination[:cost] - self_pay

    if rare_disease(self_pay, health_insurance_pay, selfpayratio_ages, rarediseaselimit_incomes)
    elsif
      elderly(elderly_selfpayratio_incomes, selfpaylimit_incomes)
    elsif
      high_cost(self_pay, selfpayratio_ages, selfpaylimit_incomes)
    else
      normal(self_pay, health_insurance_pay, selfpayratio_ages)
    end

  end

private

  def match_case(val, array_case)
    array_case.find { |n| n.first >= val }.last
  end

  def rare_disease(self_pay, health_insurance_pay, selfpayratio_ages, rarediseaselimit_incomes)
    if @selected_examination == examinations[3]
      rare_disease_comment(disease: @selected_examination[:disease])
      select_income
      rare_disease_self_pay_comment(
        cost: @selected_examination[:cost],
        self_pay: self_pay,
        health_insurance_pay: health_insurance_pay,
        self_pay_ratio: match_case(@age,selfpayratio_ages),
        rare_disease_self_pay_limit: match_case(@income,rarediseaselimit_incomes),
        )
    end
  end

  def normal(self_pay, health_insurance_pay, selfpayratio_ages)
    if @age < ELDERLY_AGE && self_pay <= MAX_SELF_PAY
      self_pay_comment(
        age: @age,
        self_pay: self_pay,
        health_insurance_pay: health_insurance_pay,
        self_pay_ratio: match_case(@age,selfpayratio_ages),
        )
    end
  end

  def high_cost(self_pay, selfpayratio_ages, selfpaylimit_incomes)
    if self_pay > MAX_SELF_PAY && @selected_examination != examinations[3]
      high_cost_comment
      select_income

      if self_pay - match_case(@income,selfpaylimit_incomes) < MIN_SELF_PAY
        high_cost_self_pay_comment(
          cost: @selected_examination[:cost],
          self_pay: self_pay,
          self_pay_ratio: match_case(@age,selfpayratio_ages),
          )
      else
        high_cost_self_pay_limit_comment(
          income: @income,
          cost: @selected_examination[:cost],
          self_pay_limit: match_case(@income,selfpaylimit_incomes)
          )
      end
    end
  end

  def elderly(elderly_selfpayratio_incomes, selfpaylimit_incomes)
    if ELDERLY_AGE <= @age

      elderly_comment
      select_income
      elderly_self_pay_ratio_comment(
        income: @income,
        elderly_self_pay_ratio: match_case(@income,elderly_selfpayratio_incomes),
        )

      elderly_self_pay = @selected_examination[:cost] * match_case(@income,elderly_selfpayratio_incomes)/10

      if elderly_self_pay - match_case(@income,elderly_selfpayratio_incomes) < MIN_SELF_PAY || elderly_self_pay <= MAX_SELF_PAY
        elderly_self_pay_comment(
          cost: @selected_examination[:cost],
          elderly_self_pay_ratio: match_case(@income,elderly_selfpayratio_incomes),
          )
      else
        elderly_self_pay_limit_comment(
          cost: @selected_examination[:cost],
          income: @income,
          elderly_self_pay_ratio: match_case(@income,elderly_selfpayratio_incomes),
          self_pay_limit: match_case(@income,selfpaylimit_incomes),
        )
      end

    end
  end

end
