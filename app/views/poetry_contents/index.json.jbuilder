# frozen_string_literal: true

json.array! @poetry_contents, partial: "poetry_contents/poetry_content", as: :poetry_content
