import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../domain/models/character.dart';
import '../domain/models/asset.dart';
import '../domain/enums/asset_type.dart';

class ShopItem {
  final String id;
  final String name;
  final String description;
  final AssetType type;
  final double price;
  final double maintenanceCost;
  final double income;
  final IconData icon;
  final int minReputation;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    this.maintenanceCost = 0,
    this.income = 0,
    required this.icon,
    this.minReputation = 0,
  });
}

class ShopScreen extends StatefulWidget {
  final Character character;
  final VoidCallback onPurchase;

  const ShopScreen({super.key, required this.character, required this.onPurchase});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final _uuid = const Uuid();

  static const List<ShopItem> _properties = [
    ShopItem(id: 'studio', name: 'Estudio', description: 'Departamento pequeño en zona céntrica', type: AssetType.property, price: 80000, maintenanceCost: 3000, income: 6000, icon: Icons.apartment),
    ShopItem(id: 'house', name: 'Casa', description: 'Casa de 3 cuartos en residencial', type: AssetType.property, price: 200000, maintenanceCost: 6000, income: 12000, icon: Icons.house),
    ShopItem(id: 'mansion', name: 'Mansión', description: 'Mansión de lujo con alberca y jardín', type: AssetType.property, price: 800000, maintenanceCost: 24000, income: 36000, icon: Icons.villa),
    ShopItem(id: 'penthouse', name: 'Penthouse', description: 'Ático en el mejor edificio de la ciudad', type: AssetType.property, price: 2000000, maintenanceCost: 50000, income: 80000, icon: Icons.location_city),
  ];

  static const List<ShopItem> _vehicles = [
    ShopItem(id: 'sedan', name: 'Sedán', description: 'Auto confiable para el día a día', type: AssetType.vehicle, price: 25000, maintenanceCost: 2000, icon: Icons.directions_car),
    ShopItem(id: 'suv', name: 'SUV', description: 'Camioneta espaciosa y potente', type: AssetType.vehicle, price: 50000, maintenanceCost: 3500, icon: Icons.time_to_leave),
    ShopItem(id: 'sports_car', name: 'Auto Deportivo', description: 'Auto deportivo de alta gama', type: AssetType.vehicle, price: 150000, maintenanceCost: 8000, icon: Icons.speed),
    ShopItem(id: 'luxury_car', name: 'Auto de Lujo', description: 'Auto de lujo importado', type: AssetType.vehicle, price: 300000, maintenanceCost: 15000, icon: Icons.airport_shuttle),
    ShopItem(id: 'yacht', name: 'Yate', description: 'Yate de 40 pies con camarotes', type: AssetType.vehicle, price: 500000, maintenanceCost: 30000, icon: Icons.sailing),
    ShopItem(id: 'jet', name: 'Jet Privado', description: 'Jet ejecutivo para viajes internacionales', type: AssetType.vehicle, price: 3000000, maintenanceCost: 200000, icon: Icons.flight),
  ];

  static const List<ShopItem> _luxuries = [
    ShopItem(id: 'watch', name: 'Reloj de Lujo', description: 'Reloj suizo edición limitada', type: AssetType.luxury, price: 15000, maintenanceCost: 500, icon: Icons.watch),
    ShopItem(id: 'jewelry', name: 'Joyería', description: 'Colección de joyas finas', type: AssetType.luxury, price: 30000, maintenanceCost: 1000, icon: Icons.diamond),
    ShopItem(id: 'art', name: 'Obra de Arte', description: 'Pintura de artista reconocido', type: AssetType.luxury, price: 50000, maintenanceCost: 2000, icon: Icons.palette),
    ShopItem(id: 'collection', name: 'Colección VIP', description: 'Colección de objetos de colección exclusivos', type: AssetType.luxury, price: 100000, maintenanceCost: 5000, icon: Icons.collections_bookmark),
  ];

  static const List<ShopItem> _investments = [
    ShopItem(id: 'bonds', name: 'Bonos del Gobierno', description: 'Inversión segura de bajo rendimiento', type: AssetType.investment, price: 10000, income: 500, icon: Icons.article),
    ShopItem(id: 'index_fund', name: 'Fondo Indexado', description: 'Fondo diversificado de mercado', type: AssetType.investment, price: 50000, income: 4000, icon: Icons.trending_up),
    ShopItem(id: 'real_estate_fund', name: 'Fondo Inmobiliario', description: 'Inversión en bienes raíces comerciales', type: AssetType.investment, price: 100000, income: 8000, icon: Icons.business),
    ShopItem(id: 'vc_fund', name: 'Capital de Riesgo', description: 'Alto riesgo, alto rendimiento', type: AssetType.investment, price: 200000, income: 30000, icon: Icons.rocket_launch),
  ];

  int _categoryIndex = 0;

  List<ShopItem> get _currentItems {
    switch (_categoryIndex) {
      case 0: return _properties;
      case 1: return _vehicles;
      case 2: return _luxuries;
      case 3: return _investments;
      default: return _properties;
    }
  }

  String get _categoryName {
    switch (_categoryIndex) {
      case 0: return 'Propiedades';
      case 1: return 'Vehículos';
      case 2: return 'Lujos';
      case 3: return 'Inversiones';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _currentItems;

    return Scaffold(
      appBar: AppBar(title: Text(_categoryName)),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _categoryChip('Propiedades', Icons.home, 0),
                _categoryChip('Vehículos', Icons.directions_car, 1),
                _categoryChip('Lujos', Icons.diamond, 2),
                _categoryChip('Inversiones', Icons.trending_up, 3),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (_, i) => _buildItemCard(items[i], theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, IconData icon, int index) {
    final selected = _categoryIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        selected: selected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (_) => setState(() => _categoryIndex = index),
      ),
    );
  }

  Widget _buildItemCard(ShopItem item, ThemeData theme) {
    final canAfford = widget.character.money >= item.price;
    final hasReputation = widget.character.stats.reputation >= item.minReputation;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(item.icon, size: 40, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(item.description, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('\$${item.price.toStringAsFixed(0)}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  if (item.maintenanceCost > 0)
                    Text('Mantenimiento: \$${item.maintenanceCost.toStringAsFixed(0)}/año', style: TextStyle(fontSize: 11, color: Colors.red.shade300)),
                  if (item.income > 0)
                    Text('Ganancia: \$${item.income.toStringAsFixed(0)}/año', style: TextStyle(fontSize: 11, color: Colors.green.shade300)),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: FilledButton(
                onPressed: canAfford && hasReputation ? () => _buyItem(item) : null,
                child: const Text('Comprar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buyItem(ShopItem item) {
    if (widget.character.money < item.price) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar compra'),
        content: Text('¿Comprar ${item.name} por \$${item.price.toStringAsFixed(0)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              widget.character.addMoney(-item.price);
              final asset = Asset(
                id: _uuid.v4(),
                name: item.name,
                type: item.type,
                value: item.price,
                maintenanceCost: item.maintenanceCost,
                income: item.income,
              );
              widget.character.assets = List.from(widget.character.assets)..add(asset);
              widget.character.eventHistory.add('Comprado: ${item.name}');
              Navigator.pop(ctx);
              Navigator.pop(context);
              widget.onPurchase();
            },
            child: const Text('Comprar'),
          ),
        ],
      ),
    );
  }
}
