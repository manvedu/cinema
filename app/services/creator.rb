module Services
  class Creator

    def initialize(input)
      @input = input
    end

    def create
      validate
      save_data
    end

    def validate
      object = @input.delete("class_name").new(@input)
      @result = { success: object.valid?, object: object }
    end

    def save_data
      if @result[:success]
        { attributes: @result[:object].save.values, status_code: 201 }
      else
        errors = @result[:object].errors.full_messages.join(", ")
        { :error => errors, status_code: 400 }
      end
    end

  end
end
