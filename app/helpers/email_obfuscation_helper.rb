module EmailObfuscationHelper
  # source: http://unixmonkey.net/?p=20

  # Rot13 encodes a string
  def rot13 string
    string.tr 'A-Za-z', 'N-ZA-Mn-za-m'
  end

  # HTML encodes ASCII chars a-z, useful for obfuscating
  # an email address from spiders and spammers
  def html_obfuscate string
    output_array = []
    lower = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    upper = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    char_array = string.split('')
    char_array.each do |char|
      output = lower.index(char) + 97 if lower.include?(char)
      output = upper.index(char) + 65 if upper.include?(char)
      output_array << output ? "&##{output};" : char
    end
    output_array.join
  end

  # Takes in an email address and (optionally) anchor text,
  # its purpose is to obfuscate email addresses so spiders and
  # spammers can't harvest them.
  def secure_email_to email, linktext = email
    user, domain = email.split('@')
    user   = html_obfuscate(user)
    domain = html_obfuscate(domain)
    # if linktext wasn't specified, throw encoded email address builder into js document.write statement
    linktext = "'+'#{user}'+'@'+'#{domain}'+'" if linktext == email
    rot13_encoded_email = rot13(email) # obfuscate email address as rot13
    out =  "<noscript>#{t('js.obfuscated_email')}</noscript>" # js disabled browsers see this
    out += '<script>'
    out += "    string = '#{rot13_encoded_email}'.replace(/[a-zA-Z]/g, function(c){ return String.fromCharCode((c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26);});"
    out += "    document.getElementById('secure-email').innerHTML = '<a href='+'ma'+'il'+'to:'+ string +'>#{linktext}</a>';"
    out += '</script>'
    out.html_safe
  end
end
