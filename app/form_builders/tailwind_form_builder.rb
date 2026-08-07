class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, TailwindHelper::INPUT_CLASSES))
    end
  end

  def number_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, TailwindHelper::INPUT_CLASSES))
    end
  end

  def email_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, TailwindHelper::INPUT_CLASSES))
    end
  end

  def text_area(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, TailwindHelper::TEXT_AREA_CLASSES))
    end
  end

  def password_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, TailwindHelper::INPUT_CLASSES))
    end
  end

  def submit(value = nil, options = {})
    variant = options.delete(:variant) || :primary
    btn_classes = [
      TailwindHelper::BTN_BASE_CLASSES,
      TailwindHelper::BUTTON_VARIANTS.fetch(variant)
    ].join(" ")

    super(value, merge_default_classes(options, btn_classes))
  end

  private

  def form_group(method, options, &block)
    label_text = options.delete(:label) { method.to_s.humanize } if options.present?
    error_messages = @object.errors[method].map { |msg| "#{label_text} #{msg}" }.join(", ") if @object && @object.errors
    error_span = error_messages.present? ? @template.content_tag(:span, error_messages, class: TailwindHelper::ERROR_CLASSES) : "".html_safe

    @template.content_tag(:div, class: "form-group mb-3 #{'has-error' if error_messages.present?}") do
      @template.concat @template.label(@object_name, method, label_text, class: TailwindHelper::LABEL_CLASSES)
      @template.concat(block.call)
      @template.concat(error_span)
    end
  end

  def merge_default_classes(options, default_class)
    options[:class] = [ options[:class], default_class ].compact.join(" ")
    options
  end
end
