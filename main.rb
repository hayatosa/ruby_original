require 'active_support/core_ext/numeric/conversions'
require './comments'
require './diagnostician'
require 'byebug'

question_comment

diagnostician = Diagnostician.new

diagnostician.select_examination
diagnostician.select_age
diagnostician.diagnose

last_comment
