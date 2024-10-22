import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../view_models/ticket_view_model.dart';
import 'ticket_detail_view.dart';
import '../../models/ticket.dart';

class TicketListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ticketViewModel = Provider.of<TicketViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Tickets',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 600;

          return Padding(
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
            child: ListView.builder(
              itemCount: ticketViewModel.tickets.length,
              itemBuilder: (context, index) {
                final ticket = ticketViewModel.tickets[index];
                String formattedTime = DateFormat('HH:mm').format(ticket.lastUpdated);

                return Card(
                  margin: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 8.0 : 12.0,
                    horizontal: isSmallScreen ? 8.0 : 16.0,
                  ),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
                    title: Text(
                      ticket.title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${ticket.status}'),
                        Text('Customer: ${ticket.customerName}'),
                        Text(
                          'Last Updated: $formattedTime',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.green),
                          onPressed: () {
                            _showTicketForm(context, ticket: ticket);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, ticket.id);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketDetailView(ticketId: ticket.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          _showTicketForm(context);
        },
      ),
    );
  }

  void _showTicketForm(BuildContext context, {Ticket? ticket}) {
    final isEditing = ticket != null;
    final titleController = TextEditingController(text: ticket?.title);
    final descriptionController = TextEditingController(text: ticket?.description);
    final customerNameController = TextEditingController(text: ticket?.customerName);
    final statusController = TextEditingController(text: ticket?.status ?? 'Active');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Ticket' : 'Add Ticket'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(titleController, 'Title'),
                _buildTextField(descriptionController, 'Description'),
                _buildTextField(customerNameController, 'Customer Name'),
                _buildTextField(statusController, 'Status'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final ticketViewModel = Provider.of<TicketViewModel>(
                  context,
                  listen: false,
                );

                if (isEditing) {
                  ticketViewModel.updateTicket(
                    Ticket(
                      id: ticket!.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      status: statusController.text,
                      customerName: customerNameController.text,
                      lastUpdated: DateTime.now(),
                    ),
                  );
                } else {
                  ticketViewModel.createNewTicket(
                    titleController.text,
                    descriptionController.text,
                    customerNameController.text,
                    statusController.text,
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Update': 'Add', style : TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String ticketId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Ticket'),
          content: const Text('You want to delete this ticket?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                final ticketViewModel = Provider.of<TicketViewModel>(
                  context,
                  listen: false,
                );
                ticketViewModel.deleteTicket(ticketId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes', style: TextStyle( color: Colors.red )),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
