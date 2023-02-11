-- check this link, how to use lua snippet https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
return {
  s("ifer", {
    t 'Expands to bar',
  }),
  s("del-later//", {
    t '// FIX: DELETE LATER',
  }),
  s("fix", {
    t '// FIX: ',
  }),
  s("print (for testing / debug)", {
    t ' fmt.Printl("")// FIX: delete later ',
  }),

  s('print (fmt)',
    fmt('fmt.Println("{}") // FIX: delete later', {
      i(1)
    })
  ),

  s('print 2 (fmt)', {
    t('fmt.Println("'),
    i(0),
    t('") // FIX: delete later'),
    t({ "kabo", "hahah" })
  }),

  s('test (kabom)',
    fmt("To {title} {} {}.", {
      i(2, "Name"),
      i(3, "Surname"),
      title = c(1, { t("Mr."), t("Ms.") }),
    })),

  s(
    "fmt3",
    fmt("{} {a} {} {1} {}", {
      t("1"),
      t("3"),
      a = t("A"),
    })
  ),
}
