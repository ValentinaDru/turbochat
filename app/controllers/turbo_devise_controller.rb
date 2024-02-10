class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    # метод to_turbo_stream используется для обработки ответа, когда клиент отправляет запрос с ожиданием 
    # потока данных (stream). В данном случае, он вызывается, когда клиент ожидает поток 
    # данных в формате Turbo Streams.
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    # В методе to_turbo_stream происходит обработка ответа в зависимости от ситуации:  
    # Если шаблон для отображения не найден (ActionView::MissingTemplate), и запрос 
    # является запросом типа GET, то генерируется исключение.  
  rescue ActionView::MissingTemplate => e
      if get?
        raise e
    # Если есть ошибки в запросе (has_errors?) и есть действие по умолчанию (default_action), 
    # то вызывается метод render, который отображает шаблон с форматом HTML и статусом 
    # :unprocessable_entity (непроходимый сущности).   
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
    # В остальных случаях происходит перенаправление на указанное местоположение (navigation_location).  
      else
        redirect_to navigation_location
      end
    end
  end

# после определения класса Responder, он становится используемым по умолчанию (реагентом по умолчанию) 
# для обработки ответов на запросы в контроллере TurboDeviseController.  
  self.responder = Responder
# Когда клиент отправляет запрос на контроллер TurboDeviseController, он ожидает ответ в формате HTML 
# или Turbo Streams. Метод respond_to используется для указания того, что контроллер должен уметь 
# обрабатывать запросы обоих типов форматов (HTML и Turbo Streams) и реагировать на них соответствующим образом.  
  respond_to :html, :to_turbo_stream
end

class TurboDeviseController < ApplicationController
  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => e
      if get?
        raise e
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end
  self.responder = Responder
  respond_to :html, :to_turbo_stream
end
