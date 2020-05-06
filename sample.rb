require 'active_support/core_ext'

# 旅行会社簡易プログラム

# 0. 旅行プランのデータと定数を用意
travel_plans = [
  {name: "沖縄", price: 10000},
  {name: "東京", price: 30000},
  {name: "大阪", price: 20000},
]

CUTTING_RATE = 0.9
DISCOUNT_NUM = 10


# 1. プランを選択：正しい値を入力しない場合、繰り返し処理

text = "旅行プランを選択してください"

travel_plans.each.with_index(1) do |travel_plan, index|
  puts "No.#{index} #{travel_plan[:name]}（¥#{travel_plan[:price]}）"
end

while true
  print "番号を入力："
  selected_number = gets.chomp.to_i

  if selected_number < 1 || 3 < selected_number
    puts "不正な値です。1~3の値を入力してください"
    next
  end

  break
end

plan_number = selected_number - 1

selected_travel_plan = travel_plans[plan_number]

puts "旅行プラン「#{selected_travel_plan[:name]}」を選択しました"



# 2. 人数を入力：正しい値を入力しない場合、繰り返し処理

while true
  print "参加人数を入力："
  number_of_people = gets.chomp.to_i

  if number_of_people < 1
    puts "不正な値です。1以上の値を入力してください"
    next
  end

  break
end

puts "旅行参加人数は#{number_of_people}人です"



# 3. 人数x料金で合計額を算出

total_charge = selected_travel_plan[:price] * number_of_people


# 4. 割引処理（人数が10人以上なら1割引、それ以外なら通常料金）：条件分岐

total_charge *= CUTTING_RATE if number_of_people >= DISCOUNT_NUM

puts "合計料金は¥#{total_charge.floor.to_s(:delimited)}です"
