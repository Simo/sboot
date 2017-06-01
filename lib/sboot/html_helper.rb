module Sboot
  module HtmlHelper

    def hidden_field property
      "<input type=\"hidden\" th:field=\"${#{@entity.name.downcase}.#{property.name}}\" />"
    end

    def label property
      "<label for=\"#{property.name}\">#{property[:name].capitalize}</label>"
    end

    def field property
      ret = "<input type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property[:name]}}\" placeholder=\"#{property[:name].capitalize}\"/>" unless property.type == 'Date'
      ret = "<input  data-provide=\"datepicker\" data-date-format=\"dd/mm/yyyy\" type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property[:name]}}\" placeholder=\"#{property[:name].capitalize}\"/>" if property.type == 'Date'
      ret
    end

    def text_field property
      "<input type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property[:name]}}\" placeholder=\"#{property[:name].capitalize}\"/>"
    end

  end
end
