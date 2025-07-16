import 'package:flutter/material.dart';
import 'package:app/presentation/styles/colors/generic.dart';
import 'package:app/presentation/views/tabBarPages/profilePage/tickets_section.dart';
import 'package:app/model/items/ticket/ticket_display_data.dart';
import 'package:app/data/services/ticket_service.dart';
import 'package:easy_localization/easy_localization.dart';

/// Extended ticket widget with expired ticket support and tap handling
class ExpiredTicketWidget extends StatelessWidget {
  final String eventDate;
  final String eventTime;
  final String eventTitle;
  final String venueAddress;
  final bool isExpired;
  final VoidCallback? onTap;

  const ExpiredTicketWidget({
    super.key,
    required this.eventDate,
    required this.eventTime,
    required this.eventTitle,
    required this.venueAddress,
    required this.isExpired,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isExpired ? 0.6 : 1.0,
        child: ColorFiltered(
          colorFilter: isExpired
              ? const ColorFilter.matrix([
                  0.3, 0.3, 0.3, 0, 0, // Red channel - more gray
                  0.3, 0.3, 0.3, 0, 0, // Green channel
                  0.3, 0.3, 0.3, 0, 0, // Blue channel
                  0, 0, 0, 1, 0, // Alpha channel
                ])
              : const ColorFilter.matrix([
                  1, 0, 0, 0, 0, // Red channel
                  0, 1, 0, 0, 0, // Green channel
                  0, 0, 1, 0, 0, // Blue channel
                  0, 0, 0, 1, 0, // Alpha channel
                ]),
          child: MyTicketWidget(
            eventDate: eventDate,
            eventTime: eventTime,
            eventTitle: eventTitle,
            venueAddress: venueAddress,
          ),
        ),
      ),
    );
  }
}

class TicketListPage extends StatefulWidget {
  const TicketListPage({super.key});

  @override
  TicketListPageState createState() => TicketListPageState();
}

class TicketListPageState extends State<TicketListPage> {
  final TicketService _ticketService = TicketService();
  List<TicketDisplayData> _tickets = [];

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    await _ticketService.ready;
    setState(() {
      _tickets = _ticketService.getAllTickets();
    });
  }

  /// Refresh tickets list
  Future<void> _refreshTickets() async {
    await _ticketService.refreshTickets();
    await _loadTickets();
  }

  /// Shows ticket details modal
  void _showTicketDetails(BuildContext context, TicketDisplayData ticket) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: const BoxConstraints(maxHeight: 500),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFA5A0BE), Color(0xFFF2BFE3)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 30,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ticket_details'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kBlackColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.1),

                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: kBlackColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Event title
                Text(
                  ticket.eventTitle.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kBlackColor,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 16),

                // Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: kBlackColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ticket.eventDate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Time
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: kBlackColor),
                    const SizedBox(width: 8),
                    Text(
                      ticket.eventTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: kBlackColor,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, size: 18, color: kBlackColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ticket.venueAddress,
                        style: const TextStyle(
                          fontSize: 15,
                          color: kBlackColor,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Ticket info (price and type)
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),

                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.euro, size: 16, color: kBlackColor),
                      const SizedBox(width: 4),
                      Text(
                        '${ticket.ticketPrice} • ${ticket.chargingRateType}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),

                // Expired status
                if (ticket.isExpired) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      'expired_event'.tr(),
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Barcode section
                Container(
                  width: double.infinity,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: _buildBarcodeWidget(
                        "MUFANT-${ticket.eventTitle.replaceAll(' ', '').toUpperCase()}-${DateTime.now().millisecondsSinceEpoch}",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBlackColor, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: kWhiteColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'my_tickets'.tr(),
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _refreshTickets,
                      icon: const Icon(
                        Icons.refresh,
                        color: kWhiteColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Tickets count info
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.confirmation_number,
                      color: kWhiteColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'tickets_in_total'.tr(namedArgs: {'count': _tickets.length.toString()}),
                      style: const TextStyle(
                        color: kWhiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'active_tickets'.tr(namedArgs: {'count': _tickets.where((t) => !t.isExpired).length.toString()}),
                      style: TextStyle(
                        color: kWhiteColor.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Tickets List
              Expanded(
                child: _tickets.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _refreshTickets,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _tickets.length,
                          itemBuilder: (context, index) {
                            final ticket = _tickets[index];
                            final isFirstExpired =
                                ticket.isExpired &&
                                (index == 0 || !_tickets[index - 1].isExpired);

                            return Column(
                              children: [
                                // Add divider before first expired ticket
                                if (isFirstExpired) _buildSectionDivider(),
                                _buildTicketItem(ticket, index),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: kWhiteColor.withValues(alpha: 0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'expired_tickets'.tr(),
              style: TextStyle(
                color: kWhiteColor.withValues(alpha: 0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: kWhiteColor.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketItem(TicketDisplayData ticket, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Purchase date info for recent tickets
          if (!ticket.isExpired &&
              DateTime.now().difference(ticket.purchaseDate).inDays < 7)
            Container(
              margin: const EdgeInsets.only(bottom: 8, left: 4),
              child: Text(
                'purchased_on'.tr(namedArgs: {'date': _formatPurchaseDate(ticket.purchaseDate)}),
                style: TextStyle(
                  color: kWhiteColor.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
            ),

          // Ticket widget with controlled sizing
          SizedBox(
            height: 150, // Fixed height to prevent size inconsistencies
            child: ExpiredTicketWidget(
              eventDate: ticket.eventDate,
              eventTime: ticket.eventTime,
              eventTitle: ticket.eventTitle,
              venueAddress: ticket.venueAddress,
              isExpired: ticket.isExpired,
              onTap: () => _showTicketDetails(context, ticket),
            ),
          ),

          // Expired badge
          if (ticket.isExpired)
            Container(
              margin: const EdgeInsets.only(top: 8, left: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
              ),
              child: Text(
                'expired'.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'tickets_empty_state'.tr(),
        style: TextStyle(
          color: kWhiteColor.withValues(alpha: 0.7),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatPurchaseDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'purchased_today'.tr();
    } else if (difference == 1) {
      return 'purchased_yesterday'.tr();
    } else if (difference < 7) {
      return 'purchased_days_ago'.tr(namedArgs: {'days': difference.toString()});
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildBarcodeWidget(String data) {
    // Placeholder for barcode widget
    // This can be replaced with a proper barcode widget when the barcode_widget package is added
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Text(
          data,
          style: const TextStyle(
            fontSize: 8,
            fontFamily: 'monospace',
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
