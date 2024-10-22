import 'package:flutter/foundation.dart';
import '../models/ticket.dart';

class TicketViewModel extends ChangeNotifier {
  List<Ticket> _tickets = [];
  int _lastTicketId = 0;

  List<Ticket> get tickets => _tickets;

  void addTicket(Ticket ticket) {
    _tickets.add(ticket);
    notifyListeners();
  }

  void deleteTicket(String ticketId) {
    _tickets.removeWhere((ticket) => ticket.id == ticketId);
    notifyListeners();
  }

  void updateTicket(Ticket updatedTicket) {
    final index = _tickets.indexWhere((ticket) => ticket.id == updatedTicket.id);
    if (index != -1) {
      _tickets[index] = updatedTicket;
      notifyListeners();
    }
  }

  void updateTicketStatus(String ticketId, String newStatus) {
    final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index != -1) {
      _tickets[index].status = newStatus;
      _tickets[index].lastUpdated = DateTime.now();
      notifyListeners();
    }
  }

  void createNewTicket(String title, String description, String customerName, String status) {
    final newTicket = Ticket(
      id: (++_lastTicketId).toString(),
      title: title,
      description: description,
      customerName: customerName,
      status: status,
      lastUpdated: DateTime.now(),
    );
    addTicket(newTicket);
    print('Ticket added: ${newTicket.id}, Total tickets: ${_tickets.length}'); // Debug output
  }
}
