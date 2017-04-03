module Sboot
  class HtmlWriter
    class HtmlHelper

      def hidden_field entity, field
        "<input type=\"hidden\" th:field=\"${#{@entity.name}.#{@entity.properties[field]}\" />"
      end

    end
  end
end
