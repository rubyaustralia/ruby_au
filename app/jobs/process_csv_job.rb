require 'csv'

class ProcessCsvJob
  include SuckerPunch::Job

  def perform(import_id)
    ActiveRecord::Base.connection_pool.with_connection do
      import = Import.find(import_id)
      import_issues = []
      imported_users = []
      existing_users = []

      CSV.parse(import.csv,headers: true).each_with_index do |row, index|
        row = row.to_h
        email = row['Ticket Email']

        user = User.find_by(email: email)

        if user
          existing_users.push(
            email: user.email,
            full_name: user.full_name,
            user_id: user.id
          )
        else
          full_name = row['Ticket Full Name']
          preferred_name = row['Ticket First Name']

          user = User.new(
            email: email,
            full_name: full_name,
            preferred_name: preferred_name,
            password: SecureRandom.base64(20)
          )

          if user.save
            imported_users.push(
              email: email,
              full_name: full_name,
              user_id: user.id
            )
          else
            import_issues.push(
              line_no: index + 1,
              email: email,
              messages: user.errors.full_messages
            )
          end
        end

        import.status = :imported
        import.import_issues = import_issues
        import.imported_users = imported_users
        import.existing_users = existing_users
        import.save!
      end
    end
  end
end
