
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/revenuecat_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Offerings? offerings;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final o = await RevenueCatService().getOfferings();
    setState(() { offerings = o; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GamerSpace Pro')),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Unlock Pro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text('For serious collectors', style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 32),
              _perk(Icons.all_inclusive, 'Unlimited games'),
              _perk(Icons.auto_awesome, 'AI recommendations'),
              _perk(Icons.bar_chart_rounded, 'Year in Review & Stats'),
              _perk(Icons.palette_outlined, 'Custom themes & icons'),
              _perk(Icons.block, 'No ads, ever'),
              const Spacer(),
              if (offerings?.current != null)
                ...offerings!.current!.availablePackages.map((pkg) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C4DFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      onPressed: () async {
                        final isPro = await RevenueCatService().purchase(pkg);
                        if (isPro && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Welcome to Pro!')));
                          Navigator.pop(context);
                        }
                      },
                      child: Text('${pkg.storeProduct.title} - ${pkg.storeProduct.priceString}'),
                    ),
                  ),
                )),
              if (offerings?.current == null)
                const Text('Add your RevenueCat API keys to see real packages. Mock mode active for now.', style: TextStyle(color: Colors.white54, fontSize: 12)),
              TextButton(onPressed: () async { await RevenueCatService().restore(); }, child: const Text('Restore Purchases')),
            ],
          ),
        ),
    );
  }

  Widget _perk(IconData icon, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(children: [Icon(icon, color: const Color(0xFF00E5FF)), const SizedBox(width: 12), Text(text, style: const TextStyle(fontSize: 16))]),
  );
}
