module CustomUtilities
  def convert_string_array_to_integer_array(strings_array)
    strings_array.map!(&:to_i)
  end
end
