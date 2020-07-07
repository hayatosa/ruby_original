require './comments'

#難病助成制度
def nanbyou_system

  nanbyou_comment

  while true
    puts "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < 0
      puts "不正な値です。0以上を入力してください"
      next
    end
    break
  end
  puts "#{@income}万円ですね"

  # 難病助成の計算
  @nanbyou_support = @self_pay - nanbyou_self_pay_limit

  nanbyou_self_pay_comment

end

def kougaku_system

  kougaku_comment

  while true
    puts "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < 0
      puts "不正な値です。0以上を入力してください"
      next
    end
    break
  end

  @kougaku_support = @self_pay - self_pay_limit

  if @kougaku_support < 0
    puts "今回の自己負担額は上限内でしたので、あなたが負担する金額は変わらず#{@self_pay}円です"
  else
    puts <<~TEXT
    年収#{@income}万円の場合、自己負担上限額は#{self_pay_limit}円です
    残りの#{@kougaku_support}円も、あなたが加入している医療保険が支払います
    TEXT
  end
end

def koureisha_system

  koureisha_comment

  while true
    print "あなたの年収(万)を教えてください："
    @income = gets.chomp.to_i

    if @income < 0
      puts "不正な値です。0以上を入力してください"
      next
    elsif 0 <= @income && @income < 370
      puts "年収#{@income}万円の場合、自己負担割合は#{old_self_pay_ratio}割です"
    elsif 370 <= @income
      puts "年収#{@income}万円の場合、自己負担割合は#{old_self_pay_ratio}割です"
    end
    break
  end


  # 高齢者自己負担額
  @old_self_pay = @selected_examination.cost * old_self_pay_ratio/10
  # 残額
  @balance = @selected_examination.cost - @old_self_pay
  # 公費
  @public_cost = @balance / 2
  # 若年者の保険料
  @young_cost = @balance * 0.4
  #　高齢者の保険料
  @old_cost = @balance * 0.1

  # 自己負担額上限を超えた場合
  @upper_limit_balance = @selected_examination.cost - self_pay_limit
  @upper_limit_public_cost = @upper_limit_balance / 2
  @upper_limit_young_cost = @upper_limit_balance * 0.4
  @upper_limit_old_cost = @upper_limit_balance * 0.1

  if @old_self_pay - self_pay_limit < 0 || 60_000 >= @old_self_pay
    old_self_pay_comment
  else
    self_pay_limit_comment
  end

end
