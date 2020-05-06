require 'active_support/core_ext/numeric/conversions'
require './settei'


# 症状、診察内容、医療費を用意
examinations = [
  {symptom:"熱っぽい", disease_name: "風邪", medical_cost: 5_000},
  {symptom:"手が痛い", disease_name: "骨折", medical_cost: 200_000},
  {symptom:"胃がムカムカ", disease_name: "胃潰瘍", medical_cost: 600_000},
  {symptom:"下痢・血便", disease_name: "潰瘍性大腸炎", medical_cost: 1_000_000},
  {symptom:"頭痛・吐き気・あざ・倦怠感・歯ぐきの腫れ", disease_name: "急性白血病", medical_cost: 5_000_000},
]

puts question_comment
puts <<~TEXT
  今日はどうされましたか？
  症状と年齢を教えてください

TEXT

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
selected_examination = examinations[examination_number]

  # 年齢を入力：正しい値を入力しない場合、繰り返し処理
  while true
    print "あなたの年齢を教えてください："
    @age = gets.chomp.to_i

    if @age < 0 || 120 < @age
      puts "不正な値です。0~120を入力してください"
      next
    end

    break
  end

puts <<~TEXT
----------------
  年齢は#{@age}歳、症状は「#{selected_examination[:symptom]}」ですね

  診察中...
  診察中...
  診察中...

  診断内容は「#{selected_examination[:disease_name]}」です
  医療費は「#{selected_examination[:medical_cost].to_s(:delimited, delimiter: ',')}円」です
----------------
TEXT


  def self_pay_ratio
  ratio = (
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
    )
  end

# 自己負担額の計算
self_pay = selected_examination[:medical_cost] * self_pay_ratio/10
# 残額の計算
health_insurance_pay = selected_examination[:medical_cost] - self_pay

if examination_number == 3
  puts <<~TEXT
  #{selected_examination[:disease_name]}は国が定めた指定難病に該当するため
  医療費の助成を受けられます
  自己負担額は年収により異なります
  TEXT

  while true
    print "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < 0
      puts "不正な値です。0以上を入力してください"
      next
    end
    break
  end
  puts "#{@income}万円"

  def self_pay_limit
    if 0 <= @income && @income < 160
      5_000
    elsif 160 <= @income && @income < 370
      10_000
    elsif 370 <= @income && @income < 810
      20_000
    elsif 810 <= @income
      30_000
    end
  end

  # 難病助成制度の計算
  rare_diseases_support = selected_examination[:medical_cost] - self_pay_limit -  health_insurance_pay

  puts <<~TEXT
  あなたの年収では、自己負担額は#{self_pay_limit}円になります
  あなたの年齢では、医療費の#{10 - self_pay_ratio}割（#{health_insurance_pay}円）を
  あなたが加入している医療保険が負担します
  残りの#{rare_diseases_support}円（#{selected_examination[:medical_cost]}円 - #{self_pay_limit}円 - #{health_insurance_pay}円)を国と都道府県が半分の#{rare_diseases_support/2}円ずつ負担します
TEXT

# 潰瘍性大腸炎以外の場合
elsif  0 <= @age && @age <= 74 && examination_number != 3

  puts "#{@age}歳の場合、医療費の自己負担は#{self_pay_ratio}割です"
  puts "あなたが負担する金額は：#{self_pay.to_s(:delimited, delimiter: ',')}円です"
  puts "残りの#{health_insurance_pay.to_s(:delimited, delimiter: ',')}円はあなたが加入している医療保険が支払います"

  # 高額療養費制度の計算
  if self_pay > 60_000

  puts <<~TEXT
  -------------------
    医療費が高額の場合、年齢や年収に応じ
    自己負担額に上限が定められます（高額療養費制度）
  TEXT

  while true
    print "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < 0
      puts "不正な値です。0以上を入力してください"
      next
    end
    break
  end

  def maximum_self_pay
    if 0 <= @income && @income < 370
      60_000
    elsif 370 <= @income && @income < 770
      90_000
    elsif 770 <= @income && @income < 1160
      170_000
    elsif 1160 <= @income
      260_000
    end
  end

    high_medical_expenses_system = self_pay - maximum_self_pay

    if high_medical_expenses_system < 0
      puts "今回の自己負担額は上限内でしたので、あなたが負担する金額は変わらず#{self_pay.to_s(:delimited, delimiter: ',')}円です"
    else
  puts <<~TEXT
  年収#{@income}万円の場合、自己負担上限額は#{maximum_self_pay.to_s(:delimited, delimiter: ',')}円です
  残りの#{high_medical_expenses_system.to_s(:delimited, delimiter: ',')}円も、あなたが加入している医療保険が支払います
  TEXT
    end
  end

  # 75歳以上の場合制度が異なるし、年収に応じて自己負担額が変わる
elsif 75 <= @age && @age <= 120 && examination_number != 3
    puts <<~TEXT
      75歳以上の場合、自己負担の割合と上限額はあなたの年収により変わります
      なお、自己負担を除いた医療費の5割を公費（国、都道府県、市町村)から、
      4割を若年者（74歳未満）、1割を高齢者（75歳以上）からの保険料負担で賄われます
    TEXT

      while true
        print "あなたの年収(万)を教えてください："
        @income = gets.chomp.to_i

        def old_self_pay_ratio
        ratio = (
          case @income

          when 0..369
            1
          else
            3
          end
          )
        end

        if @income < 0
          puts "不正な値です。1以上を入力してください"
          next

        elsif 0 <= @income && @income < 370
          puts "年収#{@income}万円の場合、自己負担割合は#{old_self_pay_ratio}割です"
        elsif 370 <= @income
          puts "年収#{@income}万円の場合、自己負担割合は#{old_self_pay_ratio}割です"
        end
        break
      end

      def old_maximum_self_pay
        if 0 <= @income && @income < 370
          60_000
        elsif 370 <= @income && @income < 770
          90_000
        elsif 770 <= @income && @income < 1160
          170_000
        elsif 1160 <= @income
          260_000
        end
      end

      # 自己負担額の計算
      old_self_pay = selected_examination[:medical_cost] * old_self_pay_ratio/10
      # 残額の計算
      balance = selected_examination[:medical_cost] - old_self_pay
      public_cost = balance / 2
      young_cost = balance * 0.4
      old_cost = balance * 0.1

      balances = selected_examination[:medical_cost] - old_maximum_self_pay
      public_costs = balances / 2
      young_costs = balances * 0.4
      old_costs = balances * 0.1

      if 60_000 < old_self_pay
        puts <<~TEXT
        -------------
        自己負担額は#{old_self_pay.to_s(:delimited, delimiter: ',')}円です
        ただし、上限が定められており、年収#{@income}万円の場合、#{old_maximum_self_pay.to_s(:delimited, delimiter: ',')}円です
        残りの#{balances.to_s(:delimited, delimiter: ',')}円の負担内訳です
        5割（#{public_costs.to_s(:delimited, delimiter: ',')}円）が公費（国、都道府県、市町村）
        4割（#{young_costs.to_s(:delimited, delimiter: ',')}円）が若年者（75歳未満）の保険料
        1割（#{old_costs.to_s(:delimited, delimiter: ',')}円）が高齢者（75歳以上）の保険料
        TEXT

      else

        puts <<~TEXT
        -------------
        自己負担額は#{old_self_pay.to_s(:delimited, delimiter: ',')}円です
        残りの#{balance.to_s(:delimited, delimiter: ',')}円の負担内訳です
        5割（#{public_cost.to_s(:delimited, delimiter: ',')}円）が公費（国、都道府県、市町村）
        4割（#{young_cost.to_s(:delimited, delimiter: ',')}円）が若年者（75歳未満）の保険料
        1割（#{old_cost.to_s(:delimited, delimiter: ',')}円）が高齢者（75歳以上）の保険料
        TEXT
      end
end
