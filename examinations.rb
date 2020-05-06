class Examination
  attr_reader :symptom, :disease_name, :medical_cost

  def initialize(**params)
    @symptom = params[:symptom]
    @disease_name = params[:disease_name]
    @medical_cost = params[:medical_cost]
  end
end
