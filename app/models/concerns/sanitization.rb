# Sanitization DSL. Should be used for all text input fields
# @todo Use this module for all text areas within models
module Sanitization
  extend ActiveSupport::Concern
  require 'cgi'

  protected ####################################################################

  # Sanitize specific fields automatically before the validation step
  # @api semipublic
  # @param fields [Symbol] As many ActiveRecord fields as you like
  # @param options [Hash] (Optional)
  #   :method - default: 'clean' | others not yet implemented
  #   :remove_all_spaces - default: false
  #   + other before_validate params
  # @return [undefined]
  def auto_sanitize *fields
    options = {} unless (options = fields.last).is_a? Hash
    options.reverse_merge! method: 'clean', remove_all_spaces: false

    # Each field: define a new method, then register a callback to that method
    fields.each do |field|
      next unless field.is_a? Symbol
      method_name = "sanitize_#{options[:method]}_#{field}"
      define_method(
        method_name,
        send(
          "#{options[:method]}_sanitization",
          field, options[:remove_all_spaces]))
      before_validation method_name.to_sym, options
    end
  end

  private ######################################################################

  # Method content for sanitize_clean_X callbacks
  # @api private
  # @return [Proc]
  def clean_sanitization field, remove_spaces_mode
    proc do
      self.send(
        "#{field}=",
        Sanitization.sanitize_clean(self.send(field), remove_spaces_mode))
    end
  end

  # Clean sanitization with further string modification
  # @api private
  # @param field [String] The content to sanitize
  # @param remove_spaces [Boolean] for stricter modification
  # @return [String] The sanitized content
  def self.sanitize_clean field, remove_spaces
    field = field.first if field.class == Array
    field = Sanitize.clean(field) if field
    reverse_encoding modify field, remove_spaces
  end

  # Modify sanitized strings even further
  # @api private
  # @param string [String, nil] The string to modify
  # @return [String] The modified string
  def self.modify string, remove_spaces
    return string unless string.is_a? String
    string
      .strip # Remove leading and trailing white space
      .gsub(/\s+/, (remove_spaces ? '' : ' '))
    # Either multiple whitespaces become one, or all whitespaces are removed
  end

  # Clean sanitized fields get HTML entities encoded, which we need to revert
  # @api private
  # @param string [String, nil] The string with HTML-entities
  # @return [String] The unencoded string
  def self.reverse_encoding string
    string.is_a?(String) ? CGI.unescapeHTML(string) : string
  end
end
