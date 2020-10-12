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
      puts "不正な値です。0~120を入力してください"
      select_age
    end
  end

  def select_income
    print "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < MIN_INCOME
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

    #年齢による自己負担割合
    ages = [
      [[0..],2],
      [[6..],3],
      [[70..],2],
      [[75..],1],
      ]

    #収入による自己負担上限額
    incomes = [
      [[0..],60000],
      [[370..],90000],
      [[770..],170000],
      [[1160..],260000],
      ]

    #難病制度下での収入による自己負担上限額
    rare_disease_incomes = [
      [[0..],5000],
      [[160..],10000],
      [[370..],20000],
      [[810..],30000],
      ]

    #75歳以上
    elderly_incomes = [
      [[0..369],1],
      [[370..],3],
      ]

    self_pay = @selected_examination[:cost] * self_pay_ratio(@age,ages)/10
    health_insurance_pay = @selected_examination[:cost] - self_pay

    if rare_disease(self_pay, health_insurance_pay, ages, rare_disease_incomes)
    elsif
      elderly(elderly_incomes, incomes)
    elsif
      high_cost(self_pay, ages, incomes)
    elsif
      normal(self_pay, health_insurance_pay, ages)
    end

  end

private

  def self_pay_ratio(variable, array)
    case variable
    when *array[3].first
      array[3].last
    when *array[2].first
      array[2].last
    when *array[1].first
      array[1].last
    when *array[0].first
      array[0].last
    end
  end

  def rare_disease(self_pay, health_insurance_pay, ages, rare_disease_incomes)
    if @selected_examination == examinations[3]
      rare_disease_comment(disease: @selected_examination[:disease])
      select_income
      rare_disease_self_pay_comment(
        cost: @selected_examination[:cost],
        self_pay: self_pay,
        health_insurance_pay: health_insurance_pay,
        self_pay_ratio: self_pay_ratio(@age,ages),
        rare_disease_self_pay_limit: self_pay_ratio(@income,rare_disease_incomes),
        )
    end
  end

  def normal(self_pay, health_insurance_pay, ages)
    if @age < ELDERLY_AGE && self_pay <= MAX_SELF_PAY
      self_pay_comment(
        age: @age,
        self_pay: self_pay,
        health_insurance_pay: health_insurance_pay,
        self_pay_ratio: self_pay_ratio(@age,ages),
        )
    end
  end

  def high_cost(self_pay, ages, incomes)
    if self_pay > MAX_SELF_PAY && @selected_examination != examinations[3]
      high_cost_comment
      select_income

      if self_pay - self_pay_ratio(@income,incomes) < MIN_SELF_PAY
        high_cost_self_pay_comment(
          cost: @selected_examination[:cost],
          self_pay: self_pay,
          self_pay_ratio: self_pay_ratio(@age,ages),
          )
      else
        high_cost_self_pay_limit_comment(
          income: @income,
          cost: @selected_examination[:cost],
          self_pay_ratio: self_pay_ratio(@income,incomes),
          )
      end
    end
  end


  # 75歳以上
  def elderly_self_pay_ratio(variable, array)
    case variable
    when *array[1].first
      array[1].last
    when *array[0].first
      array[0].last
    end
  end

  def elderly(elderly_incomes, incomes)
    if ELDERLY_AGE <= @age

      elderly_comment
      select_income
      elderly_self_pay_ratio_comment(
        income: @income,
        elderly_self_pay_ratio: elderly_self_pay_ratio(@income,elderly_incomes),
        )

      elderly_self_pay = @selected_examination[:cost] * elderly_self_pay_ratio(@income,elderly_incomes)/10

      if elderly_self_pay - self_pay_ratio(@income,incomes) < MIN_SELF_PAY || elderly_self_pay <= MAX_SELF_PAY
        elderly_self_pay_comment(
          cost: @selected_examination[:cost],
          elderly_self_pay_ratio: elderly_self_pay_ratio(@income,elderly_incomes),
          )
      else
        elderly_self_pay_limit_comment(
          cost: @selected_examination[:cost],
          income: @income,
          elderly_self_pay_ratio: elderly_self_pay_ratio(@income,elderly_incomes),
          self_pay_limit: self_pay_ratio(@income,incomes),
        )
      end

    end
  end

end
