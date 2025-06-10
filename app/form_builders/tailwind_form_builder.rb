class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  INPUT_CLASSES = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-gray-600 focus:border-gray-600 block w-full p-2.5"
  TEXT_AREA_CLASSES = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-gray-600 focus:border-gray-600 block w-full p-2.5"
  LABEL_CLASSES = "block mb-2 text-sm font-medium text-gray-900"
  ERROR_CLASSES = "text-sm text-red-500 mb-3"

  def text_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, INPUT_CLASSES))
    end
  end

  def email_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, INPUT_CLASSES))
    end
  end

  (method, options = {})

  def file_field(method, options = nil)
    form_group(method, options) do
      super(method, options)
    end
  end

  def text_area(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, TEXT_AREA_CLASSES))
    end
  end

  def password_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, INPUT_CLASSES))
    end
  end

  def submit(value = nil, options = {})
    options[:class] ||= 'btn btn-primary'
    @template.content_tag(:div, class: [TailwindHelper::BTN_BASE_CLASSES, TailwindHelper::PRIMARY_CLASSES].join) do
      super(value, options)
    end
  end

  private

  def form_group(method, options, &block)
    label_text = options.delete(:label) { method.to_s.humanize }
    error_messages = @object.errors[method].map { |msg| "#{label_text} #{msg}" }.join(', ') if @object && @object.errors
    error_span = error_messages.present? ? @template.content_tag(:span, error_messages, class: ERROR_CLASSES) : ''.html_safe

    @template.content_tag(:div, class: "form-group mb-3 #{'has-error' if error_messages.present?}") do
      @template.concat @template.label(@object_name, method, label_text, class: LABEL_CLASSES)
      @template.concat(block.call)
      @template.concat(error_span)
    end
  end

  def merge_default_classes(options, default_class)
    options[:class] = [options[:class], default_class].compact.join(' ')
    options
  end
end
