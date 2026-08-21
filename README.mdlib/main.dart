import 'package:flutter/material.dart';

void main() => runApp(const RecetasIAApp());

// --- MODELOS ---
class Ingredient {
  final String name;
  bool isAvailable;
  Ingredient(this.name, this.isAvailable);
}

class Recipe {
  final String title;
  final String time;
  final String difficulty;
  final int matched;
  final int total;
  final List<String> tags;
  final String imageUrl;
  final List<String> steps;

  Recipe(this.title, this.time, this.difficulty, this.matched, this.total, this.tags, this.imageUrl, this.steps);
}

// --- APP PRINCIPAL ---
class RecetasIAApp extends StatelessWidget {
  const RecetasIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF32D74B),
        cardColor: const Color(0xFF1C1C1E),
        colorScheme: const ColorScheme.dark(primary: Color(0xFF32D74B)),
      ),
      home: const MainScreen(),
    );
  }
}

// --- CONTROLADOR DE PESTAÑAS (ESTADO GLOBAL) ---
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tab = 0;

  // Estado centralizado de la despensa
  final List<Ingredient> _ingredients = [
    Ingredient('Pollo', true), Ingredient('Ajo', true), Ingredient('Cebolla', true),
    Ingredient('Tomate', true), Ingredient('Arroz', true), Ingredient('Frijoles', false),
    Ingredient('Aguacate', true), Ingredient('Limón', false), Ingredient('Fideos', true),
    Ingredient('Carne picada', true), Ingredient('Aceite de oliva', true), Ingredient('Sal', true),
  ];

  late final List<Recipe> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = [
      Recipe('Guiso de Fideos Casero', '40 min', 'Fácil', 6, 7, ['Familiar', 'Económico'],
          'https://images.unsplash.com/photo-1626844131082-256783844137?q=80&w=600&auto=format&fit=crop',
          ['Pica las verduras.', 'Sofríe con carne picada y puré de tomate.', 'Añade caldo y fideos hasta espesar.']),
      Recipe('Bowl de Pollo y Aguacate', '15 min', 'Fácil', 5, 5, ['Saludable', 'Rápido'],
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=600&auto=format&fit=crop',
          ['Cocina el pollo a la plancha.', 'Sirve con arroz y aguacate rebanado.', 'Rocía con limón y cilantro.']),
    ];
  }

  void _triggerUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final activeCount = _ingredients.where((i) => i.isAvailable).length;

    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [
          HomeTab(recipes: _recipes, activeIngredientsCount: activeCount),
          PantryTab(ingredients: _ingredients, onUpdate: _triggerUpdate),
          const Center(child: Text("Plan Semanal", style: TextStyle(color: Colors.white54))),
          const Center(child: Text("Recetas Guardadas", style: TextStyle(color: Colors.white54))),
          const Center(child: Text("Mi Perfil", style: TextStyle(color: Colors.white54))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        backgroundColor: const Color(0xFF121212),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF32D74B),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Cocinar'),
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Despensa'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Guardados'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
        ],
      ),
    );
  }
}

// --- PESTAÑA 1: INICIO ---
class HomeTab extends StatelessWidget {
  final List<Recipe> recipes;
  final int activeIngredientsCount;
  
  const HomeTab({super.key, required this.recipes, required this.activeIngredientsCount});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("¿Qué cocinamos\nhoy?", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.1)),
          const SizedBox(height: 24),
          
          // Tarjeta Despensa
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF32D74B).withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.kitchen_rounded, color: Color(0xFF32D74B)),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Despensa Activa", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("Ingredientes disponibles", style: TextStyle(fontSize: 13, color: Colors.white54)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF32D74B),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: const Color(0xFF32D74B).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Text("$activeIngredientsCount", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Filtros
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todo', '< 20 min', 'Saludable', 'Familiar'].map((f) => Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: f == 'Todo' ? Colors.white : const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(20)),
                child: Text(f, style: TextStyle(color: f == 'Todo' ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
              )).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Lista de Recetas
          ...recipes.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CookModeScreen(recipe: r))),
              child: RecipeCard(recipe: r),
            ),
          )),
        ],
      ),
    );
  }
}

// --- WIDGET TARJETA DE RECETA ---
class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    bool hasAll = recipe.matched == recipe.total;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(recipe.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              Positioned(
                bottom: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(20)),
                  child: Text("${recipe.time} • ${recipe.difficulty}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  "Usa ${recipe.matched} de ${recipe.total} ingredientes",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: hasAll ? const Color(0xFF32D74B) : Colors.orange),
                ),
                const SizedBox(height: 12),
                Row(children: recipe.tags.map((t) => Container(
                  margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(12)),
                  child: Text("#$t", style: const TextStyle(fontSize: 12, color: Colors.white70)),
                )).toList())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- PESTAÑA 2: DESPENSA (NUEVA Y FUNCIONAL) ---
class PantryTab extends StatefulWidget {
  final List<Ingredient> ingredients;
  final VoidCallback onUpdate;
  
  const PantryTab({super.key, required this.ingredients, required this.onUpdate});

  @override
  State<PantryTab> createState() => _PantryTabState();
}

class _PantryTabState extends State<PantryTab> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.ingredients
        .where((i) => i.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text("Tu Despensa", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Buscar ingredientes...',
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C1C1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final ingredient = filteredList[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  title: Text(ingredient.name, style: const TextStyle(fontSize: 16)),
                  trailing: Switch(
                    value: ingredient.isAvailable,
                    activeColor: const Color(0xFF32D74B),
                    onChanged: (val) {
                      setState(() => ingredient.isAvailable = val);
                      widget.onUpdate(); // Actualiza el contador en Inicio
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- MODO COCINAR (SIMULACIÓN VOZ) ---
class CookModeScreen extends StatefulWidget {
  final Recipe recipe;
  const CookModeScreen({super.key, required this.recipe});

  @override
  State<CookModeScreen> createState() => _CookModeScreenState();
}

class _CookModeScreenState extends State<CookModeScreen> {
  int _step = 0;

  void _next() {
    if (_step < widget.recipe.steps.length - 1) {
      setState(() => _step++);
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SuccessScreen(title: widget.recipe.title)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modo Cocinar"), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Paso ${_step + 1} de ${widget.recipe.steps.length}", style: const TextStyle(color: Color(0xFF32D74B), fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(child: Text(widget.recipe.steps[_step], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500, height: 1.3))),
            
            // Simulación IA Asistente
            Container(
              padding: const EdgeInsets.all(16), margin: const EdgeInsets.only(bottom: 30),
              decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF32D74B).withOpacity(0.3))),
              child: Row(
                children: [
                  const Icon(Icons.graphic_eq, color: Color(0xFF32D74B)),
                  const SizedBox(width: 16),
                  Expanded(child: Text('IA: "${widget.recipe.steps[_step]}"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white))),
                ],
              ),
            ),
            
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF32D74B), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: _next,
                child: Text(_step == widget.recipe.steps.length - 1 ? "¡Terminar Receta!" : "Siguiente Paso", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- PANTALLA: ÉXITO ---
class SuccessScreen extends StatelessWidget {
  final String title;
  const SuccessScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.restaurant_menu, size: 80, color: Color(0xFF32D74B)),
              const SizedBox(height: 40),
              const Text("¡Buen provecho!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text("Has preparado:\n$title", textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 60,
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  child: const Text("Volver al inicio", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
