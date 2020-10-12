module Comments

  def question_comment
    puts <<~TEXT
    今日はどうされましたか？
    症状と年齢を教えてください
    ----------------
    TEXT
  end

  def diagnose_comment(age: ,symptom: ,disease: ,cost:)
    puts <<~TEXT
    ----------------
    年齢は#{age}歳、症状は「#{symptom}」ですね

    診察中...
    診察中...
    診察中...

    診断内容は「#{disease}」です
    医療費は「#{cost}円」です
    ----------------
    TEXT
  end

  def self_pay_comment(age: ,self_pay: ,health_insurance_pay: ,self_pay_ratio:)
    puts <<~TEXT
    #{age}歳の場合、医療費の自己負担は#{self_pay_ratio}割です
    あなたが負担する金額は：#{self_pay}円です
    残りの#{health_insurance_pay}円はあなたが加入している医療保険が支払います
    TEXT
  end

  def rare_disease_comment(disease:)
    puts <<~TEXT
    #{disease}は国が定めた指定難病に該当するため
    医療費の助成を受けられます
    自己負担額は年収により異なります
    TEXT
  end

  def rare_disease_self_pay_comment(cost: ,self_pay: ,health_insurance_pay: ,self_pay_ratio: ,rare_disease_self_pay_limit:)
    puts <<~TEXT
    あなたの年収では、自己負担額は#{rare_disease_self_pay_limit}円になります
    あなたの年齢では、医療費の#{10 - self_pay_ratio}割（#{health_insurance_pay}円）を
    あなたが加入している医療保険が負担します
    残りの#{self_pay - rare_disease_self_pay_limit}円（#{cost}円 - #{rare_disease_self_pay_limit}円 - #{health_insurance_pay}円)を国と都道府県が半分ずつ#{(self_pay - rare_disease_self_pay_limit)/2}円を負担します
    TEXT
  end

  def high_cost_comment
    puts <<~TEXT
    医療費が高額の場合、年齢や年収に応じ
    自己負担額に上限が定められます（高額療養費制度）
    TEXT
  end

  def high_cost_self_pay_comment(cost: ,self_pay: ,self_pay_ratio:)
    puts <<~TEXT
    今回の自己負担額は、本来あなたが負担する割合（#{self_pay_ratio}割）の範囲内でした
    従って負担額は#{self_pay}円です
    残りの#{cost - self_pay}円はあなたが加入している医療保険が支払います
    TEXT
  end

  def high_cost_self_pay_limit_comment(income: ,cost: ,self_pay_ratio:)
    puts <<~TEXT
    年収#{income}万円の場合、自己負担上限額は#{self_pay_ratio}円です
    残りの#{cost - self_pay_ratio}円をあなたが加入している医療保険が支払います
    TEXT
  end


  def elderly_comment
    puts <<~TEXT
    75歳を超えると医療保険制度が変わります（後期高齢者医療制度）
    自己負担の割合や上限額はあなたの年収により変わります
    TEXT
  end

  def elderly_self_pay_ratio_comment(income: ,elderly_self_pay_ratio:)
    puts "年収#{income}万円の場合、自己負担割合は#{elderly_self_pay_ratio}割です"
  end

  def elderly_self_pay_comment(cost: ,elderly_self_pay_ratio:)
    balance = cost - cost * elderly_self_pay_ratio/10

    puts <<~TEXT
    ----------------
    自己負担額は#{cost * elderly_self_pay_ratio/10}円です
    残りの#{balance}円の負担内訳です
    5割（#{(balance * 0.5).floor}円）が公費（国、都道府県、市町村）
    4割（#{(balance * 0.4).floor}円）が若年者（75歳未満）の保険料
    1割（#{(balance * 0.1).floor}円）が高齢者（75歳以上）の保険料
    TEXT
  end

  def elderly_self_pay_limit_comment(cost: ,income: ,elderly_self_pay_ratio: ,self_pay_limit:)
    balance2 = cost - self_pay_limit

    puts <<~TEXT
    ----------------
    自己負担額は本来#{cost * elderly_self_pay_ratio/10}円ですが、
    上限が定められており、年収#{income}万円の場合#{self_pay_limit}円で済みます
    残りの#{balance2}円の負担内訳です
    5割（#{(balance2 * 0.5).floor}円）が公費（国、都道府県、市町村）
    4割（#{(balance2 * 0.4).floor}円）が若年者（75歳未満）の保険料
    1割（#{(balance2 * 0.1).floor}円）が高齢者（75歳以上）の保険料
    TEXT
  end

  def last_comment
    puts <<~TEXT
    ----------------
    お大事にしてください
    TEXT
  end
end
