class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, "form__input"))
    end
  end

  def email_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, "form__input"))
    end
  end

  def text_area(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, "form__input"))
    end
  end

  def password_field(method, options = {})
    form_group(method, options) do
      super(method, merge_default_classes(options, "form__input"))
    end
  end

  def submit(value = nil, options = {})
    options[:class] ||= "btn btn--primary"
    @template.content_tag(:div) do
      super(value, options)
    end
  end

  private

  def form_group(method, options, &block)
    label_text = options.delete(:label) { method.to_s.humanize } if options.present?
    error_messages = @object.errors[method].map { |msg| "#{label_text} #{msg}" }.join(", ") if @object && @object.errors
    error_span = error_messages.present? ? @template.content_tag(:span, error_messages, class: "text-error") : "".html_safe

    @template.content_tag(:div, class: "form__group mb-3 #{'has-error' if error_messages.present?}") do
      @template.concat @template.label(@object_name, method, label_text, class: "form__label")
      @template.concat(block.call)
      @template.concat(error_span)
    end
  end

  def merge_default_classes(options, default_class)
    options[:class] = [ options[:class], default_class ].compact.join(" ")
    options
  end
end
