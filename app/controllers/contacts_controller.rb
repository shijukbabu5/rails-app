class ContactsController < ApplicationController
	# def process_form
	# Rails.logger.debug "DEBUG: params are #{params}"
	# flash[:notice] = "Received request from #{params[:contact][:name]}"
	#redirect_to root_path
	# end
	def new
		@contact = Contact.new
	end
	def create
		@contact = Contact.new(secure_params)
		if @contact.valid?
			#save to spreadsheet
			@contact.update_spreadsheet
			#send to email.
			UserMailer.contact_email(@contact).deliver
			flash[:notice] = "Message sent from #{@contact.name}."
			redirect_to root_path
		else
			render :new
		end
	end
	private
	#secure_params allows user to send only specified params. (name,email&content. Can be user defined name, same as Contact.new(name))
	def secure_params
		params.require(:contact).permit(:name, :email, :content)
	end
end
