# reply-from
# ----------
# File: /home/garoth/.sup/hooks/reply-from.rb
# Selects a default address for the From: header of a new reply.
# Variables:
#   message: a message object representing the message being replied to
#     (useful values include message.recipient_email, message.to, and message.cc)
# Return value:
#   A Person to be used as the default for the From: header, or nil to use the
#   default behavior.

found = false

tos = [ "arch-general@archlinux.org", "aur-dev@archlinux.org",
        "aur-general@archlinux.org", "awesome-devel@naquadah.org",
        "sup-talk@rubyforge.org", "garoth@gmail.com" ]

tos.each do |from|
        if "#{message.to}".include? "#{from}"
                found = true
        end
end

if found
        AccountManager.account_for "garoth@gmail.com"
else
        AccountManager.default_account
end
