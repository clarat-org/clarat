# Monkey Patching Hash
class Hash
  # Deep reject to recursively remove a key out of a nested hash
  def deep_reject_key!(key)
    keys.each { |k| delete(k) if k == key }
    values.each { |v| v.deep_reject_key!(key) if v.is_a? Hash }
    self
  end
end
