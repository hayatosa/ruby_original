require 'active_support/core_ext/numeric/conversions'
require './examinations'
require './comments'
require './diagnostician'
require 'byebug'

question_comment

diagnostician = Diagnostician.new
diagnostician.select_symptom(examinations)
diagnostician.select_age
# diagnostician.select_income
diagnostician.diagnose

last_comment
