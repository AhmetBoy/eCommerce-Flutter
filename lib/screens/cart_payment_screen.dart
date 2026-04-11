import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/payment_info.dart';
import '../services/payment_service.dart';

class CartPaymentScreen extends StatefulWidget {
  const CartPaymentScreen({super.key});

  @override
  State<CartPaymentScreen> createState() => _CartPaymentScreenState();
}

class _CartPaymentScreenState extends State<CartPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  bool _savePaymentInfo = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedPaymentInfo();
  }

  Future<void> _loadSavedPaymentInfo() async {
    final paymentInfo = await PaymentService.loadPaymentInfo();
    if (paymentInfo != null) {
      setState(() {
        _cardNumberController.text = paymentInfo.cardNumber;
        _expiryDateController.text = paymentInfo.expiryDate;
        _cvvController.text = paymentInfo.cvv;
        _cardHolderNameController.text = paymentInfo.cardHolderName;
        _savePaymentInfo = true;
      });
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
    super.dispose();
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kart numarası gerekli';
    }
    final cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length != 16 || !RegExp(r'^\d+$').hasMatch(cleanValue)) {
      return 'Geçerli bir kart numarası girin';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Son kullanma tarihi gerekli';
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'AA/YY formatında girin';
    }
    return null;
  }

  String? _validateCvv(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV gerekli';
    }
    if (value.length != 3 || !RegExp(r'^\d+$').hasMatch(value)) {
      return '3 haneli CVV girin';
    }
    return null;
  }

  String? _validateCardHolderName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kart sahibi adı gerekli';
    }
    return null;
  }

  void _formatCardNumber(String value) {
    final cleanValue = value.replaceAll(' ', '');
    if (cleanValue.length > 16) {
      _cardNumberController.text = cleanValue.substring(0, 16);
      _cardNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _cardNumberController.text.length),
      );
      return;
    }

    final formatted = cleanValue
        .replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ')
        .trim();

    _cardNumberController.text = formatted;
    _cardNumberController.selection = TextSelection.fromPosition(
      TextPosition(offset: formatted.length),
    );
  }

  void _formatExpiryDate(String value) {
    final cleanValue = value.replaceAll('/', '');
    if (cleanValue.length > 4) {
      _expiryDateController.text = cleanValue.substring(0, 4);
      _expiryDateController.selection = TextSelection.fromPosition(
        TextPosition(offset: _expiryDateController.text.length),
      );
      return;
    }

    if (cleanValue.length >= 2) {
      final formatted =
          '${cleanValue.substring(0, 2)}/${cleanValue.substring(2)}';
      _expiryDateController.text = formatted;
      _expiryDateController.selection = TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      );
    } else {
      _expiryDateController.text = cleanValue;
      _expiryDateController.selection = TextSelection.fromPosition(
        TextPosition(offset: cleanValue.length),
      );
    }
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simüle edilmiş ödeme işlemi
    await Future.delayed(const Duration(seconds: 2));

    if (_savePaymentInfo) {
      final paymentInfo = PaymentInfo(
        cardNumber: _cardNumberController.text.replaceAll(' ', ''),
        expiryDate: _expiryDateController.text,
        cvv: _cvvController.text,
        cardHolderName: _cardHolderNameController.text,
      );
      await PaymentService.savePaymentInfo(paymentInfo);
    } else {
      await PaymentService.clearPaymentInfo();
    }

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Ödeme başarılı!')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ödeme')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Kart Bilgileri',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Kart Numarası',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19), // 16 digits + 3 spaces
                ],
                validator: _validateCardNumber,
                onChanged: _formatCardNumber,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Son Kullanma',
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: _validateExpiryDate,
                      onChanged: _formatExpiryDate,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      validator: _validateCvv,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cardHolderNameController,
                decoration: const InputDecoration(
                  labelText: 'Kart Sahibi Adı',
                  hintText: 'AD SOYAD',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
                validator: _validateCardHolderName,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Kart bilgilerini kaydet'),
                value: _savePaymentInfo,
                onChanged: (value) {
                  setState(() {
                    _savePaymentInfo = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ödemeyi Tamamla',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
