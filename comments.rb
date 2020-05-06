module Comment
  # 最初のコメント
  def question_comment
    puts <<~TEXT
      今日はどうされましたか？
      症状と年齢を教えてください

    TEXT
  end

  # 診断後のコメント
  def diagnosis_comment
  end

  # プラスアルファのコメント
  def add_comment
  end
end
