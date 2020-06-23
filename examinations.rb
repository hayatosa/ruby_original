class Examination
  attr_reader :symptom, :disease, :cost

  def initialize(**params)
    @symptom = params[:symptom]
    @disease = params[:disease]
    @cost = params[:cost]
  end
end
