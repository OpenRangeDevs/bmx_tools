module ApplicationHelper
  def flash_class(type)
    case type.to_s
    when 'notice'
      'bg-green-100 border-green-300 text-green-800'
    when 'alert'
      'bg-red-100 border-red-300 text-red-800' 
    when 'error'
      'bg-red-100 border-red-300 text-red-800'
    else
      'bg-blue-100 border-blue-300 text-blue-800'
    end
  end
end
