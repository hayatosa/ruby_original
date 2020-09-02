require 'active_support/core_ext/numeric/conversions'
require './examinations'
require './comments'
require './diagnostician'
require 'byebug'

question_comment

diagnostician = Diagnostician.new
examination = diagnostician.select_examination
age = diagnostician.select_age
diagnostician.calculate
diagnostician.diagnose(examination ,age)

last_comment
