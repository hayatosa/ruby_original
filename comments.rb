module Comments

  def question_comment
    puts <<~TEXT
    今日はどうされましたか？
    症状と年齢を教えてください
    ----------------
    TEXT
  end

  def diagnosis_comment
    puts <<~TEXT
    ----------------
    年齢は#{@age}歳、症状は「#{@selected_examination[:symptom]}」ですね

    診察中...
    診察中...
    診察中...

    診断内容は「#{@selected_examination[:disease]}」です
    医療費は「#{@selected_examination[:cost].to_s(:delimited)}円」です
    ----------------
    TEXT
  end

  def self_pay_comment
    puts <<~TEXT
    #{@age}歳の場合、医療費の自己負担は#{self_pay_ratio}割です
    あなたが負担する金額は：#{@self_pay.to_s(:delimited)}円です
    残りの#{@health_insurance_pay.to_s(:delimited)}円はあなたが加入している医療保険が支払います
    TEXT
  end

  def kougaku_comment
    puts <<~TEXT
    ----------------
    医療費が高額の場合、年齢や年収に応じ
    自己負担額に上限が定められます（高額療養費制度）
    TEXT
  end

  def nanbyou_comment
    puts <<~TEXT
    #{@selected_examination[:disease]}は国が定めた指定難病に該当するため
    医療費の助成を受けられます
    自己負担額は年収により異なります
    TEXT
  end

  def nanbyou_self_pay_comment
    puts <<~TEXT
    あなたの年収では、自己負担額は#{nanbyou_self_pay_limit.to_s(:delimited)}円になります
    あなたの年齢では、医療費の#{10 - self_pay_ratio}割（#{@health_insurance_pay.to_s(:delimited)}円）を
    あなたが加入している医療保険が負担します
    残りの#{@nanbyou_support.to_s(:delimited)}円（#{@selected_examination[:cost].to_s(:delimited)}円 - #{nanbyou_self_pay_limit.to_s(:delimited)}円 - #{@health_insurance_pay.to_s(:delimited)}円)を国と都道府県が半分の#{(@nanbyou_support/2).to_s(:delimited)}円ずつ負担します
    TEXT

  end

  def koureisha_comment
    puts <<~TEXT
    75歳を超えると医療保険制度が変わります（後期高齢者医療制度）
    自己負担の割合や上限額はあなたの年収により変わります
    TEXT
  end

  def old_self_pay_comment
    puts <<~TEXT
    ----------------
    自己負担額は#{@old_self_pay.to_s(:delimited)}円です
    残りの#{@balance.to_s(:delimited)}円の負担内訳です
    5割（#{@public_cost.to_s(:delimited)}円）が公費（国、都道府県、市町村）
    4割（#{@young_cost.floor.to_s(:delimited)}円）が若年者（75歳未満）の保険料
    1割（#{@old_cost.floor.to_s(:delimited)}円）が高齢者（75歳以上）の保険料
    TEXT
  end

  def self_pay_limit_comment
    puts <<~TEXT
    ----------------
    自己負担額は本来#{@old_self_pay.to_s(:delimited)}円ですが、
    上限が定められており、年収#{@income}万円の場合#{self_pay_limit.to_s(:delimited)}円で済みます
    残りの#{@upper_limit_balance.to_s(:delimited)}円の負担内訳です
    5割（#{@upper_limit_public_cost.to_s(:delimited)}円）が公費（国、都道府県、市町村）
    4割（#{@upper_limit_young_cost.floor.to_s(:delimited)}円）が若年者（75歳未満）の保険料
    1割（#{@upper_limit_old_cost.floor.to_s(:delimited)}円）が高齢者（75歳以上）の保険料
    TEXT
  end

  def last_comment
    puts <<~TEXT
    ----------------
    お大事にしてください
    TEXT
  end
end
