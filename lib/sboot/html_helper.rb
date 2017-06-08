module Sboot
  module HtmlHelper

    def hidden_field property
      "<input type=\"hidden\" th:field=\"${#{@entity.name.downcase}.#{property.name}}\" />"
    end

    def label property
      "<label for=\"#{property.name}\">#{property.camel_rather_dash(firstLetter: 'upcase')}</label>"
    end

    def field property
      ret = "<input type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property.camel_rather_dash}}\" placeholder=\"#{property.camel_rather_dash(firstLetter: 'upcase')}\"/>" unless property.type == 'Date'
      ret = "<input  data-provide=\"datepicker\" data-date-format=\"dd/mm/yyyy\" type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property.camel_rather_dash}}\" placeholder=\"#{property.camel_rather_dash(firstLetter: 'upcase')}\"/>" if property.type == 'Date'
      ret
    end

    def text_field property
      "<input type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property[:name]}}\" placeholder=\"#{property[:name].capitalize}\"/>"
    end

  end
end
