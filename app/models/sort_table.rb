class SortTable
  include Enumerable

  attr_reader :prefix

  def initialize scope, params:,  prefix: nil, default: nil, sort_model: nil
    @scope   = scope
    @params  = params.clone
    @prefix  = prefix ? "#{prefix}_" : ""
    @default = default
    @model   = sort_model || @scope.model
  end

  def ordered
    if sort_column
      @scope.order "#{@model.table_name}.#{sort_column} #{sort_direction}"
    else
      @scope
    end
  end

  def page_param
    "#{prefix}page"
  end
  def page
    ordered.page(@params[page_param])
  end

  def each
    page.each { |rec| yield rec }
  end

  def model_name
    @model.model_name.singular
  end

  def allowed_columns
    @model.column_names
  end

  def sort_column
    given = @params["#{prefix}sort"]
    allowed_columns.include?(given) ? given : @default
  end

  def sort_direction
    given = @params["#{prefix}direction"]
    %w(asc desc).include?(given) ? given.to_sym : :asc
  end

  def anchor
    "#{model_name}_#{prefix}table"
  end

  def sorter_for column, title: nil
    column  = column.to_s
    title ||= column.titleize

    if column == sort_column
      css = "current #{sort_direction}"
      dir = sort_direction == :asc ? :desc : :asc
    else
      css = nil
      dir = :asc
    end

    [
      title,
      { "#{prefix}sort" => column, "#{prefix}direction" => dir },
      { class: css, anchor: anchor }
    ]
  end
end
