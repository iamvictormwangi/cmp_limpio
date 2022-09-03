local source = {}

local cmp = require "cmp"
local items = require "cmp_limpio/limpio"

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
  return { "^%l" }
end

source.get_keyword_pattern = function()
  return [[\([^"' ~\.\s]\)*]]
end

source.complete = function(self, request, callback)
  if not vim.regex(self.get_keyword_pattern() .. "$"):match_str(request.context.cursor_before_line) then
    return callback()
  end

  local generatedClasses = {}
  for _, class in pairs(items) do
    table.insert(generatedClasses, {
      word = class,
      label = class,
      insertText = class,
      filterText = class,
      kind = cmp.lsp.MarkupKind.PlainText,
      documentation = generateDoc(class),
    })
  end

  callback(generatedClasses)
end

return source
