admin_login   = Authsig.admin_login
admin_service = Authsig.admin_service

# email     = shell.ask "Which email do you want use for logging into admin?"
# password  = shell.ask "Tell me the password to use:"
email, password = 'samsm@samsm.com', 'aaaaaaaa'
name, surname   = 'Sam', 'Schenkman-Moore'
shell.say ""

account = Account.create(:email => email, :name => name, :surname => surname, :password => password, :password_confirmation => password, :role => "admin")

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

shell.say ""

(1..5).each do |n|
  User.create(login: "user_#{n}", password: 'aaaaaaaa', service: "password")
end

User.create(login: admin_login, service: admin_service)
