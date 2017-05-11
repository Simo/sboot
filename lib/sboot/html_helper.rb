module Sboot
  module HtmlHelper

    def hidden_field property
      "<input type=\"hidden\" th:field=\"${#{@entity.name.downcase}.#{property.name}}\" />"
    end

    def label property
      "<label for=\"#{property.name}\">#{property[:name].capitalize}</label>"
    end

    def text_field property
      "<input type=\"text\" class=\"form-control\" th:field=\"${#{@entity.name.downcase}.#{property[:name]}}\" placeholder=\"#{property[:name].capitalize}\"/>"
    end

  end
end
