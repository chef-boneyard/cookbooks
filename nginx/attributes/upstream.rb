
set_unless[:nginx][:upstream][:fair]          = true
set_unless[:nginx][:upstream][:max_fails]     = 3
set_unless[:nginx][:upstream][:fail_timeout]  = "5s"
