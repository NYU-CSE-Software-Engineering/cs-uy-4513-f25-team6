module ApplicationHelper
    def nav_link(title, path)
        link_class = 'nav-link'
        if current_page?(path)
            link_class += ' active'
        end
        link_to(title, path, class: link_class)
    end
end
