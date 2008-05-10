class TicketNotifier < ActionMailer::Base
  def notify_requestor_on_completion(requestor, ticket)
    recipients requestor.email_address
    from       APP_CONFIG[:mail_notify_from]
    subject    "Ticket \# #{ticket.id} has been completed"
    body       :ticket => ticket
  end
  
  def notify_assignee_on_assignment(assignee, ticket)
    recipients assignee.email_address
    from       APP_CONFIG[:mail_notify_from]
    subject    "Ticket \# #{ticket.id} has been assigned to you"
    body       :ticket => ticket, :ticket_url => "/tickets/#{ticket.id}"
  end
end
