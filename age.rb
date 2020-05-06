
@age = gets.to_i


puts <<~TEXT
年齢を教えてください

============
#{@age}歳

TEXT


# class Medical_bills
#
#   def age_group
#     if @age >= 0 && @age < 6
#       your_payment == medical_bills*0.2
#     elsif @age >= 6 && @age < 70
#       your_payment == medical_bills*0.3
#     elsif @age >= 70 && @age < 74
#       your_payment == medical_bills*0.2
#     elsif @age >=75
#       your_payment == medical_bills*0.1
#     end
#   end
#
#   def medical_bills
#     if disease[0]
#       5000
#     elsif disease[1]
#       200000
#     elsif disease[2]
#       500000
#     elsif disease[3]
#       1000000
#     end
#   end
# end
