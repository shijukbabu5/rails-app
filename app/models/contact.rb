class Contact < ActiveRecord::Base
	has_no_table
	column :name, :string
	column :email, :string
	column :content, :string
	#field validations- required - validates_presence_of, email format validation with REGEX, email content length maximum to 500.
	validates_presence_of :name
	validates_presence_of :email
	validates_presence_of :content
	validates_format_of :email,
	:with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
	validates_length_of :content, :maximum => 500

	def update_spreadsheet
		# Connecting to google drive for the email account provided in secrets.yml
		connection = GoogleDrive.login(Rails.application.secrets.email_provider_username,Rails.application.secrets.email_provider_password)
		#connecting to google drive spreadsheet file called "Learn-Rails-Example"
		ss = connection.spreadsheet_by_title('Learn-Rails-Example')
		#If there is no drive spreadsheet with the gven name, create a new one
		if ss.nil?
			ss = connection.create_spreadsheet('Learn-Rails-Example')
		end
		#get number of rows filled in first sheet of spreadsheet document
		ws = ss.worksheets[0]
		#last row index
		last_row = 1 + ws.num_rows
		#Add data to last row in each column.
		ws[last_row, 1] = Time.new
		ws[last_row, 2] = self.name
		ws[last_row, 3] = self.email
		ws[last_row, 4] = self.content
		#Save the row in spreadsheet.
		ws.save
	end
end
