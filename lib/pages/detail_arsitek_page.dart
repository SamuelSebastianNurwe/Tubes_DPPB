import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/data.dart';
import '../core/theme.dart';
import '../models/architect.dart';
import '../models/order.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';

class DetailArsitekPage extends StatefulWidget {
  final Architect architect;

  const DetailArsitekPage({super.key, required this.architect});

  @override
  State<DetailArsitekPage> createState() => _DetailArsitekPageState();
}

class _DetailArsitekPageState extends State<DetailArsitekPage> {
  final AuthService _authService = AuthService();
  final OrderService _orderService = OrderService();

  Future<void> _handleOrder() async {
    final isLoggedIn = await _authService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      _showOrderForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login untuk memesan')),
      );
      Navigator.pushNamed(context, '/login');
    }
  }

  void _showOrderForm() {
    final noteController = TextEditingController();
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Form Pemesanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arsitek: ${widget.architect.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Harga: ${currencyFormatter.format(widget.architect.startingPrice)}',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan / Deskripsi Proyek',
                  border: OutlineInputBorder(),
                  hintText: 'Contoh: Saya ingin renovasi dapur...',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Create Order
              final newOrder = Order(
                id: DateTime.now().toString(),
                architectName: widget.architect.name,
                serviceType: 'Jasa Desain Arsitektur',
                status: 'Menunggu Konfirmasi',
                orderDate: DateTime.now(),
                price: widget.architect.startingPrice.toDouble(),
                note: noteController.text,
              );

              await _orderService.addOrder(newOrder);

              if (!mounted) return;
              Navigator.pop(context); // Close Form
              _showSuccessPopup();
            },
            child: const Text('Kirim Pesanan'),
          ),
        ],
      ),
    );
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pesanan Berhasil!'),
        content: const Text(
          'Pesanan Anda telah dikirim dan menunggu konfirmasi arsitek.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close Popup
              Navigator.pop(
                context,
              ); // Close Detail Page to return to Dashboard
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8),
          decoration: const BoxDecoration(
            color: Colors.white70,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.architect.portfolioImages.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          widget.architect.imageUrl,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.architect.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.architect.expertise,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppTheme.secondaryColor,
                          ),
                          Text(
                            widget.architect.rating.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Tentang',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.architect.description,
                    style: TextStyle(color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Pricing
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mulai dari',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          currencyFormatter.format(
                            widget.architect.startingPrice,
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Portfolio Grid
                  const Text(
                    'Portofolio Karya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: widget.architect.portfolioImages.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.architect.portfolioImages[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _handleOrder,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Pesan Sekarang'),
        ),
      ),
    );
  }
}
