# frozen_string_literal: true

module EmailObfuscationHelper
  # source: http://unixmonkey.net/?p=20

  # Takes in an email address and (optionally) anchor text,
  # its purpose is to obfuscate email addresses so spiders and
  # spammers can't harvest them.
  def secure_email_to email, index, linktext = email
    user, domain = email.split('@')
    user   = html_obfuscate(user)
    domain = html_obfuscate(domain)
    # if linktext wasn't specified, throw encoded email address builder into
    # js document.write statement
    linktext = "'+'#{user}'+'@'+'#{domain}'+'" if linktext == email
    rot13_encoded_email = rot13(email) # obfuscate email address as rot13
    secured_template rot13_encoded_email, linktext, index
  end

  private

  # HTML encodes ASCII chars a-z, useful for obfuscating
  # an email address from spiders and spammers
  def html_obfuscate string
    output_array = []
    lower = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z]
    upper = lower.map(&:upcase)
    char_array = string.split('')
    char_array.each do |char|
      output = lower.index(char) + 97 if lower.include?(char)
      output = upper.index(char) + 65 if upper.include?(char)
      output_array << (output ? "&##{output};" : char)
    end
    output_array.join
  end

  # Rot13 encodes a string
  def rot13 string
    string.tr 'A-Za-z', 'N-ZA-Mn-za-m'
  end

  # render data as HTML string
  def secured_template rot13_encoded_email, linktext, index
    <<-SCRIPT
      <noscript>#{t('.obfuscated_email')}</noscript>
      <script>//<![CDATA[
        string = '#{rot13_encoded_email}'.replace(
          /[a-zA-Z]/g, function(c) {
            return String.fromCharCode(
              (c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26
        );});
        document.getElementById('secure-email-' + #{index}).innerHTML =
          '<a href='+'ma'+'il'+'to:'+ string +' target="_blank">#{linktext}</a>';
      //]]></script>
    SCRIPT
      .html_safe
  end
end
