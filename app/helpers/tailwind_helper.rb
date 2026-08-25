# frozen_string_literal: true

module TailwindHelper
  TAG_CLASSES = "inline-flex items-center rounded-full px-2 py-1 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
  INPUT_CLASSES = "bg-background border border-input text-foreground text-sm rounded-lg focus:ring-ring focus:border-ring block w-full p-2.5"
  TEXT_AREA_CLASSES = "bg-background border border-input text-foreground text-sm rounded-lg focus:ring-ring focus:border-ring block w-full p-2.5"
  LABEL_CLASSES = "block mb-2 text-sm font-medium text-foreground"
  ERROR_CLASSES = "text-sm text-destructive mb-3"
  FIELDSET_CLASSES = "border border-border rounded-lg p-6"
  LEGEND_CLASSES = "text-sm font-semibold text-foreground px-2 bg-primary/5 rounded-md uppercase tracking-wider"

  BTN_BASE_CLASSES = "inline-flex items-center gap-3 justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2 "

  PRIMARY_CLASSES = "bg-primary text-primary-foreground hover:bg-primary/80 "
  SECONDARY_CLASSES = "bg-secondary text-secondary-foreground hover:bg-secondary/80 "
  OUTLINE_CLASSES = "border border-input bg-background hover:bg-accent hover:text-accent-foreground "
  GHOST_CLASSES = "hover:bg-accent hover:text-accent-foreground  "
  DESTRUCTIVE_CLASSES = "bg-destructive text-destructive-foreground hover:bg-destructive/90 "

  BUTTON_VARIANTS = {
    primary: PRIMARY_CLASSES,
    secondary: SECONDARY_CLASSES,
    outline: OUTLINE_CLASSES,
    ghost: GHOST_CLASSES,
    destructive: DESTRUCTIVE_CLASSES
  }

  # merge classes
  # @param [Array<String>] arg
  # @return [String]
  def tw_merge(*arg)
    arg.compact.join(" ")
  end

  # render a button/link cta with tailwind variant classes
  # @param [Symbol] as
  # @param [Symbol] variant
  def ui_action_to(name = nil, options = nil, as:, variant: :primary, **html_options, &block)
    html_options ||= {}

    # Compatibilité API Rails
    if block_given?
      options = name
      name = nil
    end

    classes = [
      BTN_BASE_CLASSES,
      BUTTON_VARIANTS.fetch(variant),
      html_options[:class]
    ].compact.join(" ")

    html_options[:class] = classes

    case as
    when :link
      if block_given?
        link_to(options, html_options, &block)
      else
        link_to(name, options, html_options, &block)
      end
    when :button
      # with form or not
      if options
        if block_given?
          button_to(options, html_options, &block)
        else
          button_to(name, options, html_options, &block)
        end
      else
        content_tag :button, html_options.merge(type: "button"), &block
      end
    else
      raise ArgumentError, "as: must be :link or :button"
    end
  end
end
