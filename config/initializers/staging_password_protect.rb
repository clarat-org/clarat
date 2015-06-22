if Rails.env.staging?
  # Write .htpasswd file
  File.open '.htpasswd', 'w' do |f|
    f.write ENV['STAGING_PWD']
  end

  # Write .htaccess file
  File.open '.htaccess', 'w' do |f|
    f.write <<-HTACCESS
AuthUserFile /app/.htpasswd
AuthType Basic
AuthName "Restricted Access"
Require valid-user
    HTACCESS
  end
end
