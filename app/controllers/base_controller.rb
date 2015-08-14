class BaseController < ApplicationController
	layout false
	
  def index
  end

  def authors
    @array = ["Blake","Chaucer","Greene"]
    # console.log "calling authors view"
  end

  def author
    # console.log "calling (single) author view"
    @id = params['id'].to_i
    @page = params[:page].to_i
  end

  def hello
  	# a remnant
  	@array = [1,2,3,4,5]
    @id = params['id'].to_i
    @page = params[:page].to_i
  end

  def kg
  	redirect_to('http://kgeographer.org')
  end

end