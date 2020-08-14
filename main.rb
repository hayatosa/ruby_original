require 'active_support/core_ext/numeric/conversions'
require './examinations'
require './comments'
require './diagnostician'
require 'byebug'

include Comments

# shindan = Shindan.new
# shindan.disp_symptom(examinations)
# shindan.select_symptom(examinations)
# shindan.select_age
# shindan.announcement
# shindan.calculation
# shindan.selected_disease

diagnostician = Diagnostician.new
diagnostician.select_symptom(examinations)
diagnostician.select_age
# diagnostician.select_income
diagnostician.diagnose
