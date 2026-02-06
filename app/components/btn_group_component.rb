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
                    [&>button]:rounded-none
                    [&>button:first-child]:rounded-l-lg
                    [&>button:last-child]:rounded-r-lg
                    [&>a]:rounded-none
                    [&>a:first-child]:rounded-l-lg
                    [&>a:last-child]:rounded-r-lg
                    [&>form]:rounded-none
                    [&>form:first-child]:rounded-l-lg
                    [&>form:last-child]:rounded-r-lg
                    [&>form>button]:rounded-none
                    [&>form:first-child>button]:rounded-l-lg
                    [&>form:last-child>button]:rounded-r-lg
                    [&>.dropdown]:rounded-none
                    [&>.dropdown:first-child]:rounded-l-lg
                    [&>.dropdown:last-child]:rounded-r-lg
                    [&>.dropdown>button]:rounded-none
                    [&>.dropdown:first-child>button]:rounded-l-lg
                    [&>.dropdown:last-child>button]:rounded-r-lg
                  " do
      content
    end
  end
end
