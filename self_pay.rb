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

# 難病助成制度の自己負担額上限
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

# 高額療養費制度での自己負担額上限
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

# 75歳以上の自己負担割合
def old_self_pay_ratio
  case @income
  when 0..369
    1
  else
    3
  end
end
