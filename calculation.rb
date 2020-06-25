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

# 年収による自己負担額上限
# def self_pay_limit
#   if 0 <= @income && @income < 160
#     5_000
#   elsif 160 <= @income && @income < 370
#     10_000
#   elsif 370 <= @income && @income < 810
#     20_000
#   elsif 810 <= @income
#     30_000
#   end
# end

# def self_pay_limit
def nanbyou_self_pay_limit
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
# 75歳以上の自己負担割合
def old_self_pay_ratio
  case @income
  when 0..369
    1
  else
    3
  end
end

# 75歳以上の自己負担額上限
# def old_maximum_self_pay
def old_self_pay_limit
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

# 高額療養費制度での自己負担額上限
# def maximum_self_pay
def kougaku_self_pay_limit
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
