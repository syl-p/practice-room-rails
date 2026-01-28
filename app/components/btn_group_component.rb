# frozen_string_literal: true

class BtnGroupComponent < ViewComponent::Base
  def call
    content_tag :div,
                role: "group",
                class: "
                    inline-flex
                    [&>*]:rounded-none
                    [&>*]:border-0
                    [&>*:first-child]:rounded-l-lg
                    [&>*:last-child]:rounded-r-lg
                  " do
      content
    end
  end
end
