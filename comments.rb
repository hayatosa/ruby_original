

module Comments
  # 最初のコメント
  def question_comment
    puts <<~TEXT
      今日はどうされましたか？
      症状と年齢を教えてください
      ----------------
    TEXT
  end

  # 診断後のコメント
  def diagnosis_comment
    puts <<~TEXT
    ----------------
      年齢は#{@age}歳、症状は「#{@selected_examination[:symptom]}」ですね

      診察中...
      診察中...
      診察中...

      診断内容は「#{@selected_examination[:disease]}」です
      医療費は「#{@selected_examination[:cost].to_s(:delimite)}円」です
    ----------------
    TEXT
  end

  # 指定難病に関するコメント
  def nanbyou_comment
    puts <<~TEXT
    #{@selected_examination[:disease]}は国が定めた指定難病に該当するため
    医療費の助成を受けられます
    自己負担額は年収により異なります
    TEXT
  end

  def nanbyou_calculation_comment
    puts <<~TEXT
    あなたの年収では、自己負担額は#{self_pay_limit}円になります
    あなたの年齢では、医療費の#{10 - self_pay_ratio}割（#{@health_insurance_pay}円）を
    あなたが加入している医療保険が負担します
    残りの#{@rare_diseases_support}円（#{@selected_examination[:cost]}円 - #{self_pay_limit}円 - #{@health_insurance_pay}円)を国と都道府県が半分の#{@rare_diseases_support/2}円ずつ負担します
    TEXT

  end

  def calculation_comment
    puts <<~TEXT
    #{@age}歳の場合、医療費の自己負担は#{self_pay_ratio}割です
    あなたが負担する金額は：#{@self_pay.to_s(:delimite)}円です
    残りの#{@health_insurance_pay.to_s(:delimite)}円はあなたが加入している医療保険が支払います
    TEXT
  end

  def kougaku_comment
    puts <<~TEXT
    ----------------
    医療費が高額の場合、年齢や年収に応じ
    自己負担額に上限が定められます（高額療養費制度）
    TEXT
  end

  def kouki_koureisha_comment
    puts <<~TEXT
    75歳以上の場合、自己負担の割合と上限額はあなたの年収により変わります
    ちなみに、自己負担を除いた残りの医療費は
    5割が公費（国、都道府県、市町村)から、
    4割が若年者（74歳未満）から、
    1割が高齢者（75歳以上）からの保険料負担で賄われます
    TEXT
  end


  def last_comment
    puts <<~TEXT

      ----------------
      お大事にしてください
      TEXT
  end
end
