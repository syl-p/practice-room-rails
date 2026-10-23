namespace :admin do
  desc "Promote a user to administrator (EMAIL=someone@example.com)"
  task promote: :environment do
    email = ENV["EMAIL"] || ARGV[0]

    if email.blank?
      abort "Usage: bin/rails admin:promote EMAIL=someone@example.com"
    end

    user = User.find_by(email_address: email.to_s.strip.downcase)

    if user.nil?
      abort "Aucun utilisateur avec l'adresse #{email}."
    end

    user.update!(role: :admin)
    puts "#{user.username} (#{user.email_address}) est maintenant administrateur."
  end

  desc "Remove the administrator role from a user (EMAIL=someone@example.com)"
  task revoke: :environment do
    email = ENV["EMAIL"] || ARGV[0]

    if email.blank?
      abort "Usage: bin/rails admin:revoke EMAIL=someone@example.com"
    end

    user = User.find_by(email_address: email.to_s.strip.downcase)

    if user.nil?
      abort "Aucun utilisateur avec l'adresse #{email}."
    end

    user.update!(role: :member)
    puts "#{user.username} (#{user.email_address}) n'est plus administrateur."
  end
end
