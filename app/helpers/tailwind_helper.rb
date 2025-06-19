module TailwindHelper
  TAG_CLASSES = "inline-flex items-center rounded-full px-2 py-1 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2"
  INPUT_CLASSES = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-gray-600 focus:border-gray-600 block w-full p-2.5"
  TEXT_AREA_CLASSES = "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-gray-600 focus:border-gray-600 block w-full p-2.5"
  LABEL_CLASSES = "block mb-2 text-sm font-medium text-gray-900"
  ERROR_CLASSES = "text-sm text-red-500 mb-3"

  BTN_BASE_CLASSES = " inline-flex items-center gap-3 justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2 "
  PRIMARY_CLASSES = " bg-primary text-primary-foreground hover:bg-primary/80 "
  SECONDARY_CLASSES = " bg-secondary text-secondary-foreground hover:bg-secondary/80 "
  OUTLINE_CLASSES = "  border border-input bg-background hover:bg-accent hover:text-accent-foreground "
  GHOST_CLASSES = " hover:bg-accent hover:text-accent-foreground  "
  DESTRUCTIVE_CLASSES = " bg-destructive text-destructive-foreground hover:bg-destructive/90 "
end
