class FormsController < ApplicationController
  respond_to do |format|
    format.json
  end

  def index
    @forms = Form.all
  end

end
