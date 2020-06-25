require './comments'

  #難病助成制度
  def nanbyou_system

    nanbyou_comment

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

    # 難病助成制度の計算
    @nanbyou_support = @selected_examination[:cost] - nanbyou_self_pay_limit -  @health_insurance_pay

    puts nanbyou_calculation_comment

  end

  def kougaku_system
    kougaku_comment

    while true
      print "あなたの年収(万)を教えてください："
      @income = gets.chomp.to_i

      if @income < 0
        puts "不正な値です。0以上を入力してください"
        next
      end
      break
    end

      @high_medical_costs_system = @self_pay - kougaku_self_pay_limit

      if @high_medical_costs_system < 0
        puts "今回の自己負担額は上限内でしたので、あなたが負担する金額は変わらず#{@self_pay.to_s(:delimited)}円です"
      else
        puts <<~TEXT
        年収#{@income}万円の場合、自己負担上限額は#{kougaku_self_pay_limit.to_s(:delimited)}円です
        残りの#{@high_medical_costs_system.to_s(:delimited)}円も、あなたが加入している医療保険が支払います
        TEXT
      end
  end

  def kouki_koureisha_system
    kouki_koureisha_comment

    while true
      print "あなたの年収(万)を教えてください："
      @income = gets.chomp.to_i

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

    # 自己負担額の計算
    @old_self_pay = @selected_examination[:cost] * old_self_pay_ratio/10
    # 残額の計算
    @balance = @selected_examination[:cost] - @old_self_pay
    @public_cost = @balance / 2
    @young_cost = @balance * 0.4
    @old_cost = @balance * 0.1

    @balances = @selected_examination[:cost] - old_self_pay_limit
    @public_costs = @balances / 2
    @young_costs = @balances * 0.4
    @old_costs = @balances * 0.1

    if 60_000 < @old_self_pay
      puts <<~TEXT
      ----------------
      自己負担額は#{@old_self_pay.to_s(:delimited)}円です
      ただし、上限が定められており、年収#{@income}万円の場合、#{old_self_pay_limit.to_s(:delimited)}円です
      残りの#{@balances.to_s(:delimited)}円の負担内訳です
      5割（#{@public_costs.to_s(:delimited)}円）が公費（国、都道府県、市町村）
      4割（#{@young_costs.to_s(:delimited)}円）が若年者（75歳未満）の保険料
      1割（#{@old_costs.to_s(:delimited)}円）が高齢者（75歳以上）の保険料
      TEXT
    else

      puts <<~TEXT
      ----------------
      自己負担額は#{@old_self_pay.to_s(:delimited)}円です
      残りの#{@balance.to_s(:delimited)}円の負担内訳です
      5割（#{@public_cost.to_s(:delimited)}円）が公費（国、都道府県、市町村）
      4割（#{@young_cost.to_s(:delimited)}円）が若年者（75歳未満）の保険料
      1割（#{@old_cost.to_s(:delimited)}円）が高齢者（75歳以上）の保険料
      TEXT
    end
  end
