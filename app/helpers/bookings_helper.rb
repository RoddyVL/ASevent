module BookingsHelper
  def payment_status_label(status)
    case status
    when "pending"
      content_tag(:span, "Pending", class: "badge bg-danger")
    when "paid"
      content_tag(:span, "Paid", class: "badge bg-success")
    else
      content_tag(:span, "Unknown", class: "badge bg-secondary")
    end
  end

  def booking_status_label(status)
    case status
    when "en_attente"
      content_tag(:span, "en attente", class: "badge bg-primary")
    when "livré"
      content_tag(:span, "livré", class: "badge bg-success")
    else
      content_tag(:span, "Unknown", class: "badge bg-secondary")
    end
  end
end
